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
    async function render({ label, time, offset, easing = 'linear', start = 0, duration = 1, gap }) {
      const metrics = batch.draw({ width: 4, height: 4, fill: { r: 234 / 255, g: 88 / 255, b: 12 / 255, a: 1 },
        translation: { from: { x: 0, y: 0 }, to: { x: 20, y: 0 }, start, duration, easing, time } });
      const left = 10 + Math.round(offset);
      const right = 30 + Math.round(offset);
      const [first, second, gapPixel] = await Promise.all([
        batch.readPixel(left, 10), batch.readPixel(right, 10), batch.readPixel(gap, 10),
      ]);
      if (first.join(',') !== '234,88,12,255' || second.join(',') !== '234,88,12,255' || gapPixel.join(',') !== '255,255,255,255') {
        throw new Error(`WebGPU translated pixel mismatch: ${first} / ${second} / ${gapPixel}`);
      }
      status.dataset.result = 'ready';
      const info = capability.adapter.info ?? {};
      status.textContent = `GPU PASS · ${label} · draw=${metrics.drawCalls} · upload=${metrics.positionBytesUploaded} · uniform=${metrics.uniformBytesUploaded} · pipeline=${metrics.pipelinesCreated} · buffers=${metrics.buffersCreated} · pixel=${first.join(',')} · adapter=${info.vendor ?? 'unknown'}/${info.isFallbackAdapter ?? 'unknown'}`;
    }
    let tail = Promise.resolve();
    const cases = [
      { label: '0s', time: 0, offset: 0, gap: 20 },
      { label: '0.5s', time: 0.5, offset: 10, gap: 10 },
      { label: '1s', time: 1, offset: 20, gap: 10 },
      { label: 'smoothstep 0.25s', time: 0.25, offset: 3.125, easing: 'smoothstep', gap: 18 },
      { label: '跳变前', time: 0.25, offset: 0, start: 0.5, duration: 0, gap: 20 },
      { label: '跳变时', time: 0.5, offset: 20, start: 0.5, duration: 0, gap: 10 },
    ];
    for (const frame of cases) {
      const button = document.createElement('button');
      button.textContent = frame.label;
      button.addEventListener('click', () => {
        tail = tail.then(() => render(frame)).catch(error => {
          status.dataset.result = 'failed';
          status.textContent = `GPU render failed: ${error.message}`;
          throw error;
        });
      });
      document.querySelector('#times').append(button);
    }
    await render(cases[0]);
  } catch (error) {
    status.dataset.result = 'failed';
    status.textContent = `GPU render failed: ${error.message}`;
    throw error;
  }
}
