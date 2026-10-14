import { canvas_text as drawText } from '../js-out/js-ffi.canvas-text-example.mjs';
import { canvas_text_ink as textInk } from '../js-out/js-ffi.canvas-text-ink-example.mjs';
import { to_js_data as plain } from '../js-out/calcit.core.mjs';

// Compare the Calcit call path with the browser's native Canvas2D behavior.
export function testCanvasText(a) {
  const createContext = () => {
    const canvas = document.createElement('canvas');
    canvas.width = 180;
    canvas.height = 52;
    return canvas.getContext('2d', { willReadFrequently: true });
  };
  const state = ctx => JSON.stringify([
    ctx.font, ctx.textAlign, ctx.textBaseline, ctx.direction, ctx.fillStyle,
  ]);
  for (const text of ['Hello', '你好 Calcit']) {
    const actual = createContext();
    const expected = createContext();
    for (const ctx of [actual, expected]) {
      ctx.font = '12px serif';
      ctx.textAlign = 'right';
      ctx.textBaseline = 'top';
      ctx.direction = 'rtl';
      ctx.fillStyle = '#ea580c';
    }
    const before = state(actual);
    const width = drawText(actual, text);
    expected.save();
    expected.font = '20px monospace';
    expected.textAlign = 'left';
    expected.textBaseline = 'alphabetic';
    expected.direction = 'ltr';
    const nativeWidth = expected.measureText(text).width;
    expected.fillText(text, 8, 28);
    expected.restore();
    a.equal(Math.abs(width - nativeWidth) < 0.001, true);
    a.equal(width > 0, true);
    a.equal(state(actual), before);
    a.equal(state(actual), state(expected));
    const pixels = actual.getImageData(0, 0, 180, 52).data;
    const reference = expected.getImageData(0, 0, 180, 52).data;
    a.equal(pixels.some(value => value !== 0), true);
    a.equal(pixels.every((value, index) => value === reference[index]), true);
  }
  let differentFromAdvance = 0, alignedLeft = 0, negativeMetric = 0;
  for (const scale of [1, 2])
    for (const font of ['italic 28px serif', '24px sans-serif', '20px monospace'])
      for (const text of ['WWWWiiii', 'jÁgy', '你好 Calcit', ''])
        for (const align of ['left', 'center', 'right'])
          for (const baseline of ['alphabetic', 'middle', 'top']) {
            const ctx = createContext();
            ctx.scale(scale, scale);
            ctx.font = font;
            ctx.textAlign = align;
            ctx.textBaseline = baseline;
            ctx.direction = 'ltr';
            ctx.fillRect(0, 0, 8, 8);
            ctx.beginPath();
            ctx.rect(1, 1, 8, 8);
            const before = state(ctx), pixels = ctx.getImageData(0, 0, 180, 52).data;
            const pathBefore = ctx.isPointInPath(4 * scale, 4 * scale);
            const native = ctx.measureText(text);
            const expected = [native.width, native.actualBoundingBoxLeft, native.actualBoundingBoxRight, native.actualBoundingBoxAscent, native.actualBoundingBoxDescent];
            const actual = plain(textInk(ctx, text));
            a.equal(actual.length, 5);
            for (let i = 0; i < 5; i++) a.equal(actual[i], expected[i]);
            a.equal(state(ctx), before);
            a.equal(ctx.isPointInPath(4 * scale, 4 * scale), pathBefore);
            a.equal(ctx.getImageData(0, 0, 180, 52).data.every((value, i) => value === pixels[i]), true);
            if (text && Math.abs(actual[0] - actual[1] - actual[2]) > 0.1) differentFromAdvance++;
            if (text && align !== 'left' && actual[1] > 0) alignedLeft++;
            if (actual.slice(1).some(value => value < 0)) negativeMetric++;
          }
  a.equal(differentFromAdvance > 0, true); // width不是墨迹宽度，不能悄悄替代。
  a.equal(alignedLeft > 0, true);
  a.equal(negativeMetric > 0, true); // 保留相对基线/对齐点的有符号距离。
}
