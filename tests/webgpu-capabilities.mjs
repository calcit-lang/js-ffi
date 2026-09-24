import { probeWebGpuDevice } from '../webgpu-capabilities.mjs';

/** Same deterministic WebGPU capability contract on Node and Chromium. */
export async function testWebGpuCapabilities(a) {
  a.equal((await probeWebGpuDevice(null)).kind, 'unavailable');
  a.equal((await probeWebGpuDevice({ gpu: null })).stage, 'gpu');
  a.equal((await probeWebGpuDevice({ get gpu() { throw new Error('blocked'); } })).message, 'blocked');
  a.equal((await probeWebGpuDevice({ gpu: {} })).stage, 'gpu');

  const host = (requestAdapter, getPreferredCanvasFormat = () => 'bgra8unorm') => ({
    gpu: { requestAdapter, getPreferredCanvasFormat },
  });
  a.equal((await probeWebGpuDevice(host(async () => null))).stage, 'adapter');
  a.equal((await probeWebGpuDevice(host(() => { throw new Error('adapter denied'); }))).message, 'adapter denied');
  a.equal((await probeWebGpuDevice(host(async () => ({})))).stage, 'adapter');
  a.equal((await probeWebGpuDevice(host(async () => ({ requestDevice() {} }), () => 'bad'))).stage, 'format');
  a.equal((await probeWebGpuDevice(host(async () => ({ requestDevice() { throw new Error('device denied'); } })))).message, 'device denied');
  a.equal((await probeWebGpuDevice(host(async () => ({ requestDevice: async () => null })))).stage, 'device-shape');

  let destroyed = 0;
  const malformed = { destroy() { destroyed++; }, lost: {} };
  a.equal((await probeWebGpuDevice(host(async () => ({ requestDevice: async () => malformed })))).stage, 'device-shape');
  a.equal(destroyed, 1);
  const throwingLost = { destroy() { destroyed++; }, get lost() { throw new Error('lost getter denied'); } };
  a.equal((await probeWebGpuDevice(host(async () => ({ requestDevice: async () => throwingLost })))).message, 'lost getter denied');
  a.equal(destroyed, 2);

  let lose;
  const device = {
    lost: new Promise(resolve => { lose = resolve; }),
    destroy() { destroyed++; },
  };
  const ready = await probeWebGpuDevice(host(async () => ({ requestDevice: async () => device })));
  a.equal(ready.kind, 'ready');
  a.equal(ready.format, 'bgra8unorm');
  a.equal(ready.device, device);
  a.equal(ready.state, 'ready');
  lose({ reason: 'unknown', message: 'removed' });
  const loss = await ready.lost;
  a.equal(loss.reason, 'unknown');
  a.equal(loss.message, 'removed');
  a.equal(ready.state, 'lost');
  a.equal(ready.release(), true);
  a.equal(ready.state, 'released');
  a.equal(ready.release(), false);
  a.equal(destroyed, 3);

  let rejectLoss;
  const rejected = await probeWebGpuDevice(host(async () => ({
    requestDevice: async () => ({ lost: new Promise((_, reject) => { rejectLoss = reject; }), destroy() {} }),
  })));
  rejectLoss({ toString() { throw new Error('unprintable'); } });
  a.equal((await rejected.lost).message, 'WebGPU.error-unprintable');
  a.equal(rejected.state, 'lost');
  rejected.release();

  let releasedBeforeLoss;
  const released = await probeWebGpuDevice(host(async () => ({
    requestDevice: async () => ({
      lost: new Promise(resolve => { releasedBeforeLoss = resolve; }), destroy() {},
    }),
  })));
  a.equal(released.release(), true);
  releasedBeforeLoss({ reason: 'destroyed', message: '' });
  await released.lost;
  a.equal(released.state, 'released');
}
