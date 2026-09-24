import { _$n__PCT__$M_ as makeStruct, _$L_ as list, newTag } from '@calcit/procs';
import { _PCT_none as none, _PCT_some as some, to_js_data as toJsData } from '../js-out/calcit.core.mjs';
import {
  RectColor, RectFrame, RectTranslation, RectVec2,
  dispose_batch_$x_ as disposeBatch, draw_rects_$x_ as drawRects,
  positions_from_list as positionsFromList, read_pixel_$x_ as readPixel,
  read_translation_$x_ as readTranslation,
  upload_positions_$x_ as uploadPositions,
} from '../js-out/js-ffi.webgpu-batches.mjs';

const struct = (proto, values) => makeStruct(proto, ...Object.entries(values).flatMap(([key, value]) => [newTag(key), value]));

/** The public Calcit namespace, not the raw JS batch, owns marshalling and diagnostics. */
export async function testCalcitWebGpuBatches(a) {
  let submitted;
  let released = 0;
  const batch = {
    upload(positions, start, count) {
      a.equal(positions instanceof Float32Array, true);
      a.equal(Array.from(positions).join(','), '1,2,3,4');
      a.equal(start, 0);
      a.equal(count, 2);
      return { positionBytesUploaded: 16, activeCount: 2 };
    },
    draw(options) {
      submitted = options;
      return { drawCalls: 1, instances: options.count ?? 2, positionBytesUploaded: 0,
        uniformBytesUploaded: 64, pipelinesCreated: 1, buffersCreated: 2 };
    },
    async readPixel() { return [234, 88, 12, 255]; },
    async readTranslation() { return { x: 3.5, y: -2.25 }; },
    dispose() { released++; return released === 1; },
  };
  const positions = positionsFromList(list(1, 2, 3, 4));
  a.equal(uploadPositions(batch, positions, 0, 2), 16);
  const fill = struct(RectColor, { r: 1, g: 0.25, b: 0, a: 1 });
  const motion = struct(RectTranslation, {
    from: struct(RectVec2, { x: 1.25, y: -2.5 }),
    to: struct(RectVec2, { x: 17.75, y: 8.25 }),
    time: 0.5, start: 0, duration: 1, easing: 'smoothstep',
  });
  const frame = struct(RectFrame, { width: 8, height: 6, fill, alpha: 0.75, translation: some(motion), count: none() });
  const metrics = toJsData(drawRects(batch, frame));
  a.equal(metrics['draw-calls'], 1);
  a.equal(metrics.instances, 2);
  a.equal(metrics['position-bytes-uploaded'], 0);
  a.equal(metrics['uniform-bytes-uploaded'], 64);
  a.equal(metrics['pipelines-created'], 1);
  a.equal(metrics['buffers-created'], 2);
  a.equal(JSON.stringify(submitted), JSON.stringify({
    width: 8, height: 6, fill: { r: 1, g: 0.25, b: 0, a: 1 }, alpha: 0.75,
    translation: { from: { x: 1.25, y: -2.5 }, to: { x: 17.75, y: 8.25 }, time: 0.5, start: 0, duration: 1, easing: 'smoothstep' }, count: undefined,
  }));
  a.equal(toJsData(await readTranslation(batch)).x, 3.5);
  a.equal(toJsData(await readTranslation(batch)).y, -2.25);
  const pixel = toJsData(await readPixel(batch, 1, 2));
  a.equal([pixel.r, pixel.g, pixel.b, pixel.a].join(','), '234,88,12,255');
  drawRects(batch, struct(RectFrame, { width: 8, height: 6, fill, alpha: 1, translation: none(), count: some(0) }));
  a.equal(submitted.translation, undefined);
  a.equal(submitted.count, 0);
  a.equal(disposeBatch(batch), true);
  a.equal(disposeBatch(batch), false);
}
