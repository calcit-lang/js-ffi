import { createFloat32RectBatch } from '../webgpu-rect-batches.mjs';
import { probeWebGpuDevice } from '../webgpu-capabilities.mjs';

/** Deterministic host-double checks shared by Node and Chromium. */
export async function testWebGpuRectBatches(a) {
  const writes = [];
  const draws = [];
  let pipelines = 0;
  let computePipelines = 0;
  let createdBuffers = 0;
  let destroyedBuffers = 0;
  let configurations = 0;
  let unconfigurations = 0;
  const device = {
    limits: { maxBufferSize: 80000 },
    queue: {
      writeBuffer(...args) { writes.push(args); },
      submit(commandBuffers) { a.equal(commandBuffers.length, 1); },
    },
    createShaderModule(descriptor) {
      a.equal(descriptor.code.includes('@vertex') || descriptor.code.includes('@compute'), true);
      a.equal(descriptor.code.includes('params.translationTiming'), true);
      a.equal(descriptor.code.includes('fn sampledTranslation()'), true);
      return {};
    },
    async createRenderPipelineAsync(descriptor) {
      pipelines++;
      a.equal(descriptor.vertex.buffers[0].stepMode, 'instance');
      a.equal(descriptor.fragment.targets[0].blend.color.srcFactor, 'one');
      return { getBindGroupLayout() { return {}; } };
    },
    async createComputePipelineAsync(descriptor) {
      computePipelines++;
      a.equal(descriptor.compute.entryPoint, 'probe');
      return { getBindGroupLayout() { return {}; } };
    },
    createBuffer(descriptor) {
      createdBuffers++;
      return {
        descriptor,
        async mapAsync() {},
        getMappedRange() { return descriptor.size === 8 ? new Float32Array([88, 90]).buffer : new Uint8Array([12, 88, 234, 255]).buffer; },
        unmap() {},
        destroy() { destroyedBuffers++; },
      };
    },
    createBindGroup(descriptor) { a.equal([1, 2].includes(descriptor.entries.length), true); return {}; },
    createCommandEncoder() {
      return {
        copyBufferToBuffer(source, sourceOffset, destination, destinationOffset, size) {
          a.equal(source.descriptor.size, 8);
          a.equal(destination.descriptor.size, 8);
          a.equal(sourceOffset, 0);
          a.equal(destinationOffset, 0);
          a.equal(size, 8);
        },
        beginComputePass() {
          return { setPipeline() {}, setBindGroup() {}, dispatchWorkgroups(count) { a.equal(count, 1); }, end() {} };
        },
        copyTextureToBuffer(source, destination, extent) {
          a.equal(source.origin.x, 1);
          a.equal(destination.bytesPerRow, 256);
          a.equal(extent.width, 1);
        },
        beginRenderPass(descriptor) {
          a.equal(descriptor.colorAttachments[0].clearValue.r, 1);
          return {
            setPipeline() {}, setBindGroup() {}, setVertexBuffer() {},
            draw(...args) { draws.push(args); }, end() {},
          };
        },
        finish() { return {}; },
      };
    },
  };
  const context = {
    configure(options) { configurations++; a.equal(options.format, 'bgra8unorm'); },
    getCurrentTexture() { return { createView() { return {}; } }; },
    unconfigure() { unconfigurations++; },
  };
  const canvas = { width: 320, height: 100, getContext(name) { a.equal(name, 'webgpu'); return context; } };
  const batch = await createFloat32RectBatch(canvas, device, 'bgra8unorm', 10000);
  a.equal(pipelines, 1);
  a.equal(createdBuffers, 2);
  a.equal(configurations, 1);
  a.equal(batch.activeCount, 0);
  let beforeDrawError;
  try { await batch.readTranslation(); } catch (error) { beforeDrawError = error; }
  a.equal(/draw required/.test(String(beforeDrawError)), true);
  const positions = new Float32Array(20000);
  positions[0] = 40;
  positions[1] = 50;
  a.equal(batch.upload(positions).positionBytesUploaded, 80000);
  a.equal(batch.activeCount, 10000);
  a.equal(writes[0][1], 0);
  a.equal(writes[0][3], 0);
  a.equal(writes[0][4], 20000);
  const fill = { r: 234 / 255, g: 88 / 255, b: 12 / 255, a: 1 };
  const cold = batch.draw({ width: 8, height: 8, fill, alpha: 0.5 });
  a.equal(cold.drawCalls, 1);
  a.equal(cold.instances, 10000);
  a.equal(cold.positionBytesUploaded, 80000);
  a.equal(cold.uniformBytesUploaded, 64);
  a.equal(draws[0].join(','), '6,10000,0,0');
  a.equal(writes[1][2][7], 0.5);
  const warm = batch.draw({ width: 8, height: 8, fill });
  a.equal(warm.positionBytesUploaded, 0);
  a.equal(warm.pipelinesCreated, 1);
  a.equal(warm.buffersCreated, 2);
  a.equal(pipelines, 1);
  a.equal(createdBuffers, 2);
  positions[2] = 80;
  a.equal(batch.upload(positions, 1, 1).positionBytesUploaded, 8);
  a.equal(writes[3][1], 8);
  a.equal(writes[3][3], 2);
  a.equal(writes[3][4], 2);
  const dirty = batch.draw({ start: 1, count: 1, width: 8, height: 8, fill });
  a.equal(dirty.positionBytesUploaded, 8);
  a.equal(draws[2].join(','), '6,1,0,1');
  a.equal((await batch.readPixel(1, 1)).join(','), '234,88,12,255');
  a.equal(createdBuffers, 3);
  a.equal(destroyedBuffers, 1);
  const translated = batch.draw({ width: 8, height: 8, fill, translation: {
    from: { x: 48, y: 80 }, to: { x: 208, y: 120 }, time: 0.25, start: 0, duration: 1, easing: 'linear',
  } });
  a.equal(translated.positionBytesUploaded, 0);
  a.equal(translated.uniformBytesUploaded, 64);
  a.equal(writes.at(-1)[2].length, 16);
  a.equal(Array.from(writes.at(-1)[2].slice(8)).join(','), '48,80,208,120,0.25,0,1,1');
  a.equal((await batch.readTranslation()).x, 88);
  a.equal((await batch.readTranslation()).y, 90);
  a.equal(computePipelines, 1);
  a.equal(createdBuffers, 7);
  a.equal(destroyedBuffers, 5);
  a.throws(() => batch.draw({ width: 8, height: 8, fill, translation: {
    from: { x: 0, y: 0 }, to: { x: 1, y: 1 }, time: 0, start: 0, duration: -1, easing: 'linear',
  } }), /duration/);
  a.throws(() => batch.draw({ width: 8, height: 8, fill, translation: {
    from: { x: 0, y: 0 }, to: { x: 1, y: 1 }, time: 0, start: 0, duration: 1, easing: 'cubic',
  } }), /easing/);
  a.throws(() => batch.upload(positions, 10000, 1), /range/);
  positions[0] = Number.NaN;
  a.throws(() => batch.upload(positions), /non-finite/);
  positions[0] = 40;
  a.throws(() => batch.draw({ width: -1, height: 8, fill }), /dimensions/);
  a.throws(() => batch.draw({ width: 8, height: 8, fill, alpha: 2 }), /alpha/);
  a.equal(batch.dispose(), true);
  a.equal(batch.dispose(), false);
  a.equal(unconfigurations, 1);
  a.equal(destroyedBuffers, 7);
  a.throws(() => batch.draw({ width: 8, height: 8, fill }), /disposed/);
  a.throws(() => batch.upload(positions), /disposed/);
  let rejected = false;
  try { await createFloat32RectBatch({ getContext: () => null }, device, 'bgra8unorm', 1); }
  catch (error) { rejected = /context unavailable/.test(String(error)); }
  a.equal(rejected, true);
}

/** Real GPU pixel check when the browser provides an adapter; never counts a skip as GPU evidence. */
export async function smokeWebGpuRectBatches(a) {
  const capability = await probeWebGpuDevice(navigator);
  if (capability.kind !== 'ready') return `SKIP: ${capability.kind}/${capability.stage}`;
  const canvas = document.createElement('canvas');
  canvas.width = 80;
  canvas.height = 40;
  let batch;
  try {
    batch = await createFloat32RectBatch(canvas, capability.device, capability.format, 2);
    batch.upload(new Float32Array([10, 10, 30, 10]));
    const metrics = batch.draw({ width: 4, height: 4, fill: { r: 234 / 255, g: 88 / 255, b: 12 / 255, a: 1 } });
    const pixels = await Promise.all([batch.readPixel(10, 10), batch.readPixel(30, 10), batch.readPixel(20, 10)]);
    a.equal(metrics.drawCalls, 1);
    a.equal(metrics.instances, 2);
    a.equal(metrics.positionBytesUploaded, 16);
    a.equal(pixels[0].join(','), '234,88,12,255');
    a.equal(pixels[1].join(','), '234,88,12,255');
    a.equal(pixels[2].join(','), '255,255,255,255');
    const translated = batch.draw({ width: 4, height: 4, fill: { r: 234 / 255, g: 88 / 255, b: 12 / 255, a: 1 },
      translation: { from: { x: 0, y: 0 }, to: { x: 20, y: 0 }, time: 0.5, start: 0, duration: 1, easing: 'linear' } });
    const translatedPixels = await Promise.all([batch.readPixel(20, 10), batch.readPixel(40, 10), batch.readPixel(10, 10)]);
    a.equal(translated.positionBytesUploaded, 0);
    a.equal(translated.uniformBytesUploaded, 64);
    a.equal(translatedPixels[0].join(','), '234,88,12,255');
    a.equal(translatedPixels[1].join(','), '234,88,12,255');
    a.equal(translatedPixels[2].join(','), '255,255,255,255');
    const withinTolerance = (actual, expected) => Math.abs(actual - expected) <= 1e-5 + 1e-5 * Math.abs(expected);
    let seed = 0x52c0ffee;
    const nextTime = () => { seed = (Math.imul(seed, 1664525) + 1013904223) >>> 0; return -0.25 + seed / 0x100000000 * 1.5; };
    for (const easing of ['linear', 'smoothstep']) {
      for (const time of [-0.25, 0, 0.25, 0.5, 0.75, 1, 1.25, ...Array.from({ length: 16 }, nextTime)]) {
        const translation = { from: { x: 1.25, y: -2.5 }, to: { x: 17.75, y: 8.25 }, time, start: 0, duration: 1, easing };
        batch.draw({ width: 4, height: 4, fill: { r: 1, g: 0, b: 0, a: 1 }, translation });
        const actual = await batch.readTranslation();
        let progress = Math.min(Math.max(time, 0), 1);
        if (easing === 'smoothstep') progress = progress * progress * (3 - 2 * progress);
        a.equal(withinTolerance(actual.x, 1.25 + (17.75 - 1.25) * progress), true);
        a.equal(withinTolerance(actual.y, -2.5 + (8.25 + 2.5) * progress), true);
      }
    }
    for (const [time, expectedX] of [[0.499999, 1.25], [0.5, 17.75], [0.500001, 17.75]]) {
      batch.draw({ width: 4, height: 4, fill: { r: 1, g: 0, b: 0, a: 1 },
        translation: { from: { x: 1.25, y: 0 }, to: { x: 17.75, y: 0 }, time, start: 0.5, duration: 0, easing: 'linear' } });
      a.equal(withinTolerance((await batch.readTranslation()).x, expectedX), true);
    }
    return `PASS: real WebGPU rectangles (${capability.format}, adapter=${JSON.stringify(capability.adapter.info ?? {})})`;
  } finally {
    batch?.dispose();
    capability.release();
  }
}
