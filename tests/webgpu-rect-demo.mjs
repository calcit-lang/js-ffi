import { probeWebGpuDevice } from '../webgpu-capabilities.mjs';
import { createFloat32RectBatch } from '../webgpu-rect-batches.mjs';

const status = document.querySelector('#status');
const canvas = document.querySelector('#scene');
const capability = await probeWebGpuDevice(navigator);
if (capability.kind !== 'ready') {
  status.dataset.result = 'unavailable';
  status.textContent = `WebGPU ${capability.kind}/${capability.stage}`;
} else {
  try {
    const batch = await createFloat32RectBatch(canvas, capability.device, capability.format, 2);
    window.addEventListener('pagehide', () => { batch.dispose(); capability.release(); }, { once: true });
    batch.upload(new Float32Array([10, 10, 30, 10]));
    const metrics = batch.draw({ width: 4, height: 4, fill: { r: 234 / 255, g: 88 / 255, b: 12 / 255, a: 1 } });
    const [pixelBytes, gapBytes] = await Promise.all([batch.readPixel(10, 10), batch.readPixel(20, 10)]);
    const pixel = pixelBytes.join(',');
    const gap = gapBytes.join(',');
    if (pixel !== '234,88,12,255' || gap !== '255,255,255,255') {
      throw new Error(`WebGPU pixel mismatch: ${pixel} / ${gap}`);
    }
    status.dataset.result = 'ready';
    status.textContent = `GPU drawn: ${metrics.instances} rectangles, ${metrics.drawCalls} draw, ${metrics.positionBytesUploaded} position bytes; pixel=${pixel}; adapter=${JSON.stringify(capability.adapter.info ?? {})}`;
  } catch (error) {
    status.dataset.result = 'failed';
    status.textContent = `GPU render failed: ${error.message}`;
    throw error;
  }
}
