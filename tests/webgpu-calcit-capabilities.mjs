import { probe_device_$x_ as probeDevice } from '../js-out/js-ffi.webgpu-capabilities.mjs';

const field = (value, name) => value.values[value.fields.findIndex(item => item.value === name)];

/** Exercise the compiled Calcit discriminated probe and retained ready ownership. */
export async function testCalcitWebGpuCapabilities(a) {
  const missing = await probeDevice(null);
  a.equal(missing.tag.value, 'unavailable');
  a.equal(field(missing.extra[0], 'stage'), 'gpu');

  const denied = await probeDevice({ gpu: { requestAdapter() { throw new Error('adapter denied'); }, getPreferredCanvasFormat() { return 'bgra8unorm'; } } });
  a.equal(denied.tag.value, 'failed');
  a.equal(field(denied.extra[0], 'stage'), 'adapter');
  a.equal(field(denied.extra[0], 'message'), 'adapter denied');

  let destroyed = 0;
  let lose;
  const device = { lost: new Promise(resolve => { lose = resolve; }), destroy() { destroyed++; } };
  const adapter = { requestDevice: async () => device };
  const readyResult = await probeDevice({ gpu: { requestAdapter: async () => adapter, getPreferredCanvasFormat: () => 'bgra8unorm' } });
  a.equal(readyResult.tag.value, 'ready');
  const ready = readyResult.extra[0];
  a.equal(ready.adapter, adapter);
  a.equal(ready.device, device);
  a.equal(ready.format, 'bgra8unorm');
  a.equal(ready.state, 'ready');
  lose({ reason: 'unknown', message: 'removed' });
  const loss = await ready.lost;
  a.equal(loss.message, 'removed');
  a.equal(ready.state, 'lost');
  a.equal(ready.release(), true);
  a.equal(ready.release(), false);
  a.equal(destroyed, 1);
}
