const SHADER = /* wgsl */ `
struct Params {
  resolution: vec2f,
  size: vec2f,
  color: vec4f,
}
@group(0) @binding(0) var<uniform> params: Params;

@vertex fn vertex(@builtin(vertex_index) vertexIndex: u32, @location(0) origin: vec2f) -> @builtin(position) vec4f {
  let corners = array<vec2f, 6>(
    vec2f(0.0, 0.0), vec2f(1.0, 0.0), vec2f(0.0, 1.0),
    vec2f(0.0, 1.0), vec2f(1.0, 0.0), vec2f(1.0, 1.0),
  );
  let pixel = origin + corners[vertexIndex] * params.size;
  return vec4f(pixel.x / params.resolution.x * 2.0 - 1.0, 1.0 - pixel.y / params.resolution.y * 2.0, 0.0, 1.0);
}

@fragment fn fragment() -> @location(0) vec4f {
  return vec4f(params.color.rgb * params.color.a, params.color.a);
}
`;

const COPY_DST = 0x08;
const VERTEX = 0x20;
const UNIFORM = 0x40;

function safeCount(value, name) {
  if (!Number.isSafeInteger(value) || value < 0) throw new RangeError(`${name} must be a nonnegative safe integer`);
}

function unit(value, name) {
  if (!Number.isFinite(value) || value < 0 || value > 1) throw new RangeError(`${name} must be within 0..1`);
}

function color(value, name) {
  if (value === null || typeof value !== 'object') throw new TypeError(`${name} must be RGBA`);
  for (const channel of ['r', 'g', 'b', 'a']) unit(value[channel], `${name}.${channel}`);
  return value;
}

/** A retained, single-draw WebGPU layer for interleaved Float32 xy rectangles. */
export async function createFloat32RectBatch(canvas, device, format, capacity) {
  if (canvas === null || typeof canvas?.getContext !== 'function') throw new TypeError('canvas required');
  if (device === null || typeof device?.createShaderModule !== 'function' || typeof device?.createRenderPipelineAsync !== 'function' ||
      typeof device?.createBuffer !== 'function' || typeof device?.createBindGroup !== 'function' ||
      typeof device?.createCommandEncoder !== 'function' || typeof device?.queue?.writeBuffer !== 'function' ||
      typeof device?.queue?.submit !== 'function') throw new TypeError('WebGPU device required');
  if (format !== 'rgba8unorm' && format !== 'bgra8unorm') throw new RangeError('unsupported canvas format');
  safeCount(capacity, 'capacity');
  if (capacity === 0 || capacity > Math.floor(Number.MAX_SAFE_INTEGER / 8) ||
      (device.limits?.maxBufferSize !== undefined && capacity * 8 > device.limits.maxBufferSize)) {
    throw new RangeError('capacity exceeds GPU buffer limits');
  }
  const context = canvas.getContext('webgpu');
  if (context === null || typeof context?.configure !== 'function' || typeof context?.getCurrentTexture !== 'function' ||
      typeof context?.unconfigure !== 'function') throw new TypeError('WebGPU canvas context unavailable');

  let positionsBuffer;
  let paramsBuffer;
  try {
    const shader = device.createShaderModule({ code: SHADER, label: 'js-ffi Float32 rectangle batch' });
    const pipeline = await device.createRenderPipelineAsync({
      layout: 'auto',
      vertex: { module: shader, entryPoint: 'vertex', buffers: [{ arrayStride: 8, stepMode: 'instance', attributes: [{ shaderLocation: 0, offset: 0, format: 'float32x2' }] }] },
      fragment: { module: shader, entryPoint: 'fragment', targets: [{
        format,
        blend: {
          color: { srcFactor: 'one', dstFactor: 'one-minus-src-alpha', operation: 'add' },
          alpha: { srcFactor: 'one', dstFactor: 'one-minus-src-alpha', operation: 'add' },
        },
      }] },
      primitive: { topology: 'triangle-list' },
    });
    positionsBuffer = device.createBuffer({ size: capacity * 8, usage: VERTEX | COPY_DST, label: 'js-ffi rectangle positions' });
    paramsBuffer = device.createBuffer({ size: 32, usage: UNIFORM | COPY_DST, label: 'js-ffi rectangle parameters' });
    const bindGroup = device.createBindGroup({ layout: pipeline.getBindGroupLayout(0), entries: [{ binding: 0, resource: { buffer: paramsBuffer } }] });
    context.configure({ device, format, usage: 0x10 | 0x01, alphaMode: 'premultiplied' });

    let disposed = false;
    let activeCount = 0;
    let totalPositionBytesUploaded = 0;
    let pendingPositionBytesUploaded = 0;
    let frames = 0;
    const ensureLive = () => { if (disposed) throw new Error('WebGPU rectangle batch disposed'); };
    return Object.freeze({
      get activeCount() { return activeCount; },
      get disposed() { return disposed; },
      upload(positions, start = 0, count = positions?.length / 2) {
        ensureLive();
        if (!(positions instanceof Float32Array) ||
            (typeof SharedArrayBuffer !== 'undefined' && positions.buffer instanceof SharedArrayBuffer) || positions.length % 2 !== 0) {
          throw new TypeError('interleaved non-shared Float32Array positions required');
        }
        safeCount(start, 'start');
        safeCount(count, 'count');
        if (start + count > capacity || start + count > positions.length / 2 || (start > 0 && start + count > activeCount)) {
          throw new RangeError('rectangle upload range exceeds active capacity');
        }
        for (let index = start * 2; index < (start + count) * 2; index++) {
          if (!Number.isFinite(positions[index])) throw new RangeError('non-finite rectangle position');
        }
        if (count > 0) device.queue.writeBuffer(positionsBuffer, start * 8, positions, start * 2, count * 2);
        if (start === 0) activeCount = count;
        const bytes = count * 8;
        totalPositionBytesUploaded += bytes;
        pendingPositionBytesUploaded += bytes;
        return Object.freeze({ positionBytesUploaded: bytes, activeCount });
      },
      draw({ start = 0, count = activeCount, width, height, fill, alpha = 1, clear = { r: 1, g: 1, b: 1, a: 1 } }) {
        ensureLive();
        safeCount(start, 'start');
        safeCount(count, 'count');
        if (start + count > activeCount) throw new RangeError('rectangle draw range exceeds uploaded positions');
        if (!Number.isFinite(width) || width < 0 || !Number.isFinite(height) || height < 0) throw new RangeError('rectangle dimensions must be finite and nonnegative');
        if (!Number.isSafeInteger(canvas.width) || canvas.width <= 0 || !Number.isSafeInteger(canvas.height) || canvas.height <= 0) {
          throw new RangeError('canvas dimensions must be positive integers');
        }
        color(fill, 'fill');
        color(clear, 'clear');
        unit(alpha, 'alpha');
        const params = new Float32Array([canvas.width, canvas.height, width, height, fill.r, fill.g, fill.b, fill.a * alpha]);
        device.queue.writeBuffer(paramsBuffer, 0, params);
        const encoder = device.createCommandEncoder();
        const pass = encoder.beginRenderPass({ colorAttachments: [{
          view: context.getCurrentTexture().createView(),
          loadOp: 'clear', storeOp: 'store',
          clearValue: { r: clear.r, g: clear.g, b: clear.b, a: clear.a },
        }] });
        if (count > 0) {
          pass.setPipeline(pipeline);
          pass.setBindGroup(0, bindGroup);
          pass.setVertexBuffer(0, positionsBuffer);
          pass.draw(6, count, 0, start);
        }
        pass.end();
        device.queue.submit([encoder.finish()]);
        frames++;
        const metrics = Object.freeze({
          frames, drawCalls: count > 0 ? 1 : 0, instances: count,
          positionBytesUploaded: pendingPositionBytesUploaded,
          totalPositionBytesUploaded, uniformBytesUploaded: 32,
          pipelinesCreated: 1, buffersCreated: 2,
        });
        pendingPositionBytesUploaded = 0;
        return metrics;
      },
      async readPixel(x, y) {
        ensureLive();
        safeCount(x, 'x');
        safeCount(y, 'y');
        if (x >= canvas.width || y >= canvas.height) throw new RangeError('readback pixel outside canvas');
        const buffer = device.createBuffer({ size: 256, usage: 0x01 | COPY_DST, label: 'js-ffi diagnostic pixel readback' });
        let mapped = false;
        try {
          const encoder = device.createCommandEncoder();
          encoder.copyTextureToBuffer(
            { texture: context.getCurrentTexture(), origin: { x, y, z: 0 } },
            { buffer, bytesPerRow: 256 },
            { width: 1, height: 1, depthOrArrayLayers: 1 },
          );
          device.queue.submit([encoder.finish()]);
          await buffer.mapAsync(0x01);
          mapped = true;
          const bytes = new Uint8Array(buffer.getMappedRange(), 0, 4);
          return Object.freeze(format === 'bgra8unorm' ? [bytes[2], bytes[1], bytes[0], bytes[3]] : Array.from(bytes));
        } finally {
          if (mapped) buffer.unmap();
          buffer.destroy();
        }
      },
      dispose() {
        if (disposed) return false;
        disposed = true;
        context.unconfigure();
        positionsBuffer.destroy();
        paramsBuffer.destroy();
        return true;
      },
    });
  } catch (error) {
    positionsBuffer?.destroy();
    paramsBuffer?.destroy();
    throw error;
  }
}
