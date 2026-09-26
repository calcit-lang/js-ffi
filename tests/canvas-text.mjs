import { canvas_text as drawText } from '../js-out/js-ffi.canvas-text-example.mjs';

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
}
