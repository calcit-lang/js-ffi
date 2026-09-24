import { probeWebGpuDevice } from '../webgpu-capabilities.mjs';
import { _$n__PCT__$M_ as makeStruct, _$L_ as list, newTag } from '@calcit/procs';
import { _PCT_some as some, to_js_data as toJsData } from '../js-out/calcit.core.mjs';
import {
  RectColor, RectFrame, RectTranslation, RectVec2,
  create_rect_batch_$x_ as createRectBatch, dispose_batch_$x_ as disposeBatch,
  draw_rects_$x_ as drawRects, positions_from_list as positionsFromList,
  read_translation_$x_ as readTranslation, upload_positions_$x_ as uploadPositions,
} from '../js-out/js-ffi.webgpu-batches.mjs';
import { assertions } from './shared.mjs';
import { smokeWebGpuRectBatches } from './webgpu-rect-batches.mjs';

const struct = (proto, values) => makeStruct(proto, ...Object.entries(values).flatMap(([key, value]) => [newTag(key), value]));

const status = document.querySelector('#status');
const canvas = document.querySelector('#scene');
const capability = await probeWebGpuDevice(navigator);
if (capability.kind !== 'ready') {
  status.dataset.result = 'unavailable';
  status.textContent = `WebGPU ${capability.kind}/${capability.stage}`;
} else {
  try {
    const batch = await createRectBatch(canvas, capability.device, capability.format, 2);
    window.addEventListener('pagehide', () => { disposeBatch(batch); capability.release(); }, { once: true });
    uploadPositions(batch, positionsFromList(list(10, 10, 30, 10)), 0, 2);
    async function render({ label, time, offset, easing = 'linear', start = 0, duration = 1, gap }) {
      const motion = struct(RectTranslation, {
        from: struct(RectVec2, { x: 0, y: 0 }), to: struct(RectVec2, { x: 20, y: 0 }), start, duration, easing, time,
      });
      const frame = struct(RectFrame, {
        width: 4, height: 4, fill: struct(RectColor, { r: 234 / 255, g: 88 / 255, b: 12 / 255, a: 1 }),
        alpha: 1, translation: some(motion),
      });
      const metrics = toJsData(drawRects(batch, frame));
      const left = 10 + Math.round(offset);
      const right = 30 + Math.round(offset);
      const [sampled, first, second, gapPixel] = await Promise.all([
        readTranslation(batch), batch.readPixel(left, 10), batch.readPixel(right, 10), batch.readPixel(gap, 10),
      ]);
      const translation = toJsData(sampled);
      if (Math.abs(translation.x - offset) > 1e-5 + 1e-5 * Math.abs(offset) || Math.abs(translation.y) > 1e-5) {
        throw new Error(`WebGPU translation mismatch: ${translation.x},${translation.y} vs ${offset},0`);
      }
      if (first.join(',') !== '234,88,12,255' || second.join(',') !== '234,88,12,255' || gapPixel.join(',') !== '255,255,255,255') {
        throw new Error(`WebGPU translated pixel mismatch: ${first} / ${second} / ${gapPixel}`);
      }
      status.dataset.result = 'ready';
      const info = capability.adapter.info ?? {};
      status.textContent = `Calcit FFI GPU PASS · ${label} · translation=${translation.x},${translation.y} · draw=${metrics['draw-calls']} · upload=${metrics['position-bytes-uploaded']} · uniform=${metrics['uniform-bytes-uploaded']} · pixel=${first.join(',')} · adapter=${info.vendor ?? 'unknown'}/${info.isFallbackAdapter ?? 'unknown'}`;
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
    const sweep = document.createElement('button');
    sweep.textContent = '固定 seed 数值扫描';
    sweep.addEventListener('click', () => {
      tail = tail.then(async () => {
        const checks = assertions();
        const result = await smokeWebGpuRectBatches(checks);
        if (!result.startsWith('PASS:')) throw new Error(result);
        status.dataset.result = 'ready';
        status.textContent = `GPU 数值扫描 PASS · ${checks.count} 项 · ${result}`;
      }).catch(error => {
        status.dataset.result = 'failed';
        status.textContent = `GPU 数值扫描失败：${error.message}`;
        throw error;
      });
    });
    document.querySelector('#times').append(sweep);
    await render(cases[0]);
  } catch (error) {
    status.dataset.result = 'failed';
    status.textContent = `GPU render failed: ${error.message}`;
    throw error;
  }
}
