function failure(stage, error) {
  let message;
  try { message = String(error?.message ?? error); }
  catch { message = 'WebGPU.error-unprintable'; }
  return Object.freeze({ kind: 'failed', stage, message });
}

function unavailable(stage) {
  return Object.freeze({ kind: 'unavailable', stage });
}

/** Acquire a default WebGPU device and an explicit, observable ownership boundary. */
export async function probeWebGpuDevice(navigatorHost = globalThis.navigator) {
  let gpu;
  try { gpu = navigatorHost?.gpu; }
  catch (error) { return failure('gpu', error); }
  if (gpu == null) return unavailable('gpu');
  if (typeof gpu.requestAdapter !== 'function' || typeof gpu.getPreferredCanvasFormat !== 'function') {
    return failure('gpu', new TypeError('WebGPU host methods unavailable'));
  }

  let adapter;
  try { adapter = await gpu.requestAdapter(); }
  catch (error) { return failure('adapter', error); }
  if (adapter == null) return unavailable('adapter');
  if (typeof adapter.requestDevice !== 'function') {
    return failure('adapter', new TypeError('WebGPU adapter method unavailable'));
  }

  let format;
  try {
    format = gpu.getPreferredCanvasFormat();
    if (format !== 'rgba8unorm' && format !== 'bgra8unorm') {
      throw new TypeError('WebGPU preferred canvas format unavailable');
    }
  } catch (error) { return failure('format', error); }

  let device;
  try { device = await adapter.requestDevice(); }
  catch (error) { return failure('device', error); }
  let lostSignal;
  try {
    if (device == null || typeof device.destroy !== 'function') {
      throw new TypeError('WebGPU device lifecycle unavailable');
    }
    lostSignal = device.lost;
    if (typeof lostSignal?.then !== 'function') {
      throw new TypeError('WebGPU device lifecycle unavailable');
    }
  } catch (error) {
    try { device?.destroy?.(); }
    catch (cleanupError) { return failure('device-shape', cleanupError); }
    return failure('device-shape', error);
  }

  let state = 'ready';
  const lost = Promise.resolve(lostSignal).then(
    info => {
      if (state === 'ready') state = 'lost';
      return Object.freeze({
        reason: typeof info?.reason === 'string' ? info.reason : 'unknown',
        message: typeof info?.message === 'string' ? info.message : '',
      });
    },
    error => {
      if (state === 'ready') state = 'lost';
      return Object.freeze({ reason: 'unknown', message: failure('lost', error).message });
    },
  );
  return Object.freeze({
    kind: 'ready', adapter, device, format, lost,
    get state() { return state; },
    release() {
      if (state === 'released') return false;
      state = 'released';
      device.destroy();
      return true;
    },
  });
}
