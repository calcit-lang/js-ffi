import * as gpu from '../js-out/js-ffi.webgpu.mjs';
import * as internal from '../js-out/js-ffi.webgpu-internal.mjs';
import { buffer_lifecycle } from '../js-out/js-ffi.webgpu-example.mjs';
import { newTag } from '@calcit/procs';
import { option_$o_none_$q_ as isNone, option_$o_unwrap as unwrap } from '../js-out/calcit.core.mjs';

// Deterministic boundary tests, not a substitute for a real GPU smoke test.
export async function testWebGpu(a) {
  const descriptorBefore = Object.getOwnPropertyDescriptor(navigator, 'gpu');
  try {
    Object.defineProperty(navigator, 'gpu', {configurable: true, value: undefined});
    a.equal(isNone(gpu.gpu()), true);
    Object.defineProperty(navigator, 'gpu', {configurable: true, value: {}});
    a.throws(() => gpu.gpu(), /WebGPU/);
  } finally {
    if (descriptorBefore) Object.defineProperty(navigator, 'gpu', descriptorBefore);
    else delete navigator.gpu;
  }
  const result = invoke => new Promise((resolve, reject) => invoke(value => { resolve(value); }, message => { reject(new Error(message)); }));
  const failure = invoke => new Promise((resolve, reject) => invoke(() => { reject(new Error('Unexpected success')); }, message => { resolve(message); }));
  for (const decode of [internal.gpu_host, internal.adapter_host, internal.device_host, internal.buffer_host, internal.promise_host]) {
    a.throws(() => decode(null), /WebGPU/);
    a.throws(() => decode({}), /WebGPU/);
  }
  let destroyedDevice = 0, destroyedBuffer = 0, descriptor, pushed;
  const buffer = { size: 16, usage: 8, destroy() { a.equal(this, buffer); destroyedBuffer++; }, unmap() {} };
  const device = {
    lost: Promise.resolve({reason: 'destroyed', message: 'explicit cleanup'}),
    destroy() { a.equal(this, device); destroyedDevice++; },
    createBuffer(value) {
      a.equal(this, device);
      if (destroyedDevice) throw new Error('Test device is destroyed');
      descriptor = value;
      return buffer;
    },
    pushErrorScope(filter) { a.equal(this, device); pushed = filter; },
    popErrorScope() { a.equal(this, device); return Promise.resolve(null); },
  };
  const adapter = { requestDevice(options) { a.equal(this, adapter); a.equal(Object.keys(options).length, 0); return Promise.resolve(device); } };
  const host = {
    requestAdapter(options) { a.equal(this, host); a.equal(Object.keys(options).length, 0); return Promise.resolve(adapter); },
    getPreferredCanvasFormat() { a.equal(this, host); return 'bgra8unorm'; },
  };
  a.equal(internal.gpu_host(host), host);
  for (const [decode, object, members] of [
    [internal.gpu_host, host, ['requestAdapter', 'getPreferredCanvasFormat']],
    [internal.adapter_host, adapter, ['requestDevice']],
    [internal.device_host, device, ['destroy', 'createBuffer', 'pushErrorScope', 'popErrorScope']],
    [internal.buffer_host, buffer, ['destroy', 'unmap']],
    [internal.promise_host, {then() {}}, ['then']],
  ]) {
    for (const member of members) a.throws(() => decode({...object, [member]: 42}), /WebGPU/);
  }
  a.throws(() => gpu.request_device_$x_({requestDevice: () => { throw new Error('sync failure'); }}, () => {}, () => {}), /sync failure/);
  a.throws(() => gpu.request_device_$x_({requestDevice: () => ({})}, () => {}, () => {}), /WebGPU/);
  let synchronous = true;
  await new Promise((resolve, reject) => {
    a.equal(gpu.request_adapter_$x_(host, () => { a.equal(synchronous, false); resolve(); }, reject), undefined);
    synchronous = false;
  });
  a.equal(gpu.preferred_canvas_format(host), 'bgra8unorm');
  a.equal(unwrap(await result((ok, fail) => gpu.request_adapter_$x_(host, ok, fail))), adapter);
  a.equal(await result((ok, fail) => gpu.request_device_$x_(adapter, ok, fail)), device);
  a.equal(isNone(await result((ok, fail) => gpu.request_adapter_$x_({...host, requestAdapter: () => Promise.resolve(null)}, ok, fail))), true);
  a.equal((await failure((ok, fail) => gpu.request_device_$x_({requestDevice: () => Promise.reject(new Error('denied'))}, ok, fail))).includes('denied'), true);
  for (const reason of [Object.create(null), {toString() { throw new Error('conversion failed'); }}]) {
    let calls = 0;
    a.equal(await failure((ok, fail) => gpu.request_device_$x_({requestDevice: () => Promise.reject(reason)}, ok, message => { calls++; fail(message); })), 'WebGPU.error-unprintable');
    a.equal(calls, 1);
  }
  a.equal((await failure((ok, fail) => gpu.request_device_$x_({requestDevice: () => Promise.resolve({})}, ok, fail))).includes('WebGPU'), true);
  a.equal(gpu.create_buffer(device, 16, 8), buffer);
  a.equal(descriptor.size, 16);
  a.equal(descriptor.usage, 8);
  a.equal(descriptor.mappedAtCreation, false);
  for (const size of [-1, 0.5, NaN, Infinity, Number.MAX_SAFE_INTEGER + 1]) a.throws(() => gpu.create_buffer(device, size, 8), /size/);
  for (const usage of [0, -1, 0.5, NaN, Infinity, 1024]) a.throws(() => gpu.create_buffer(device, 16, usage), /usage/);
  a.equal(gpu.buffer_size(buffer), 16);
  a.throws(() => gpu.buffer_size({...buffer, size: '16'}), /GPUBuffer.size/);
  a.equal(gpu.push_validation_scope_$x_(device), undefined);
  a.equal(pushed, 'validation');
  a.equal(isNone(await result((ok, fail) => gpu.pop_error_scope_$x_(device, ok, fail))), true);
  a.equal(unwrap(await result((ok, fail) => gpu.pop_error_scope_$x_({...device, popErrorScope: () => Promise.resolve({message: 'bad buffer'})}, ok, fail))), 'bad buffer');
  a.equal((await failure((ok, fail) => gpu.pop_error_scope_$x_({...device, popErrorScope: () => Promise.reject(new Error('empty stack'))}, ok, fail))).includes('empty stack'), true);
  const lost = await result((ok, fail) => gpu.watch_device_lost_$x_(device, ok, fail));
  a.equal(lost.get(newTag('reason')), 'destroyed');
  a.equal(lost.get(newTag('message')), 'explicit cleanup');
  a.equal((await failure((ok, fail) => gpu.watch_device_lost_$x_({...device, lost: Promise.resolve({reason: 42})}, ok, fail))).includes('GPUDeviceLostInfo'), true);
  a.equal(gpu.destroy_buffer_$x_(buffer), undefined);
  a.equal(destroyedBuffer, 1);
  a.equal(buffer_lifecycle(device), 16);
  a.equal(destroyedBuffer, 2);
  for (const badSize of ['invalid', () => { throw new Error('size getter failed'); }]) {
    let released = 0;
    const broken = {get size() { return typeof badSize === 'function' ? badSize() : badSize; }, destroy() { released++; }, unmap() {}};
    a.throws(() => buffer_lifecycle({...device, createBuffer: () => broken}), /failed-to-read-size/);
    a.equal(released, 1);
  }
  a.equal(gpu.destroy_device_$x_(device), undefined);
  a.equal(destroyedDevice, 1);
  a.throws(() => buffer_lifecycle(device), /device is destroyed/);
}

export async function smokeWebGpu(a) {
  const available = gpu.gpu();
  if (isNone(available)) return 'SKIP: navigator.gpu unavailable';
  const request = invoke => new Promise((resolve, reject) => invoke(value => { resolve(value); }, message => { reject(new Error(message)); }));
  const adapter = await request((ok, fail) => gpu.request_adapter_$x_(unwrap(available), ok, fail));
  if (isNone(adapter)) return 'SKIP: no WebGPU adapter';
  const device = await request((ok, fail) => gpu.request_device_$x_(unwrap(adapter), ok, fail));
  try {
    gpu.push_validation_scope_$x_(device);
    const buffer = gpu.create_buffer(device, 16, GPUBufferUsage.COPY_DST);
    try { a.equal(gpu.buffer_size(buffer), 16); }
    finally { gpu.destroy_buffer_$x_(buffer); }
    a.equal(isNone(await request((ok, fail) => gpu.pop_error_scope_$x_(device, ok, fail))), true);
  } finally { gpu.destroy_device_$x_(device); }
  return 'PASS: native WebGPU device/buffer/error scope';
}
