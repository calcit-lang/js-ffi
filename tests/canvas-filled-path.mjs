import { canvas_filled_path as draw } from '../js-out/js-ffi.canvas-filled-path-example.mjs';

// Native Canvas is the oracle; the library only exposes typed host methods.
export function testCanvasFilledPath(a) {
  const context = () => {
    const canvas = document.createElement('canvas');
    canvas.width = 120;
    canvas.height = 120;
    return canvas.getContext('2d', { willReadFrequently: true });
  };
  const pixels = ctx => ctx.getImageData(0, 0, 120, 120).data;
  const state = ctx => JSON.stringify([
    ctx.fillStyle, ctx.strokeStyle, ctx.lineWidth,
    ...['a', 'b', 'c', 'd', 'e', 'f'].map(key => ctx.getTransform()[key]),
  ]);
  const setup = ctx => {
    ctx.fillStyle = '#abcdef';
    ctx.strokeStyle = '#123456';
    ctx.lineWidth = 4;
    ctx.setTransform(1.1, 0, 0, 1.1, 3, 5);
    ctx.beginPath();
    ctx.rect(5, 5, 90, 95);
    ctx.clip();
    ctx.beginPath();
    ctx.moveTo(0, 105);
    ctx.lineTo(110, 105);
  };
  const native = (ctx, fill = true, stroke = true) => {
    ctx.save();
    ctx.beginPath();
    ctx.moveTo(18, 74);
    ctx.bezierCurveTo(18, 20, 82, 20, 82, 74);
    ctx.arc(70, 68, 12, 0, Math.PI, false);
    ctx.closePath();
    ctx.fillStyle = '#0ea5e9';
    ctx.strokeStyle = '#ea580c';
    if (fill) ctx.fill();
    if (stroke) ctx.stroke();
    ctx.restore();
  };
  const actual = context();
  const expected = context();
  const strokeOnly = context();
  const fillOnly = context();
  for (const ctx of [actual, expected, strokeOnly, fillOnly]) setup(ctx);
  const before = state(actual);
  a.equal(draw(actual), undefined);
  native(expected);
  native(strokeOnly, false, true);
  native(fillOnly, true, false);
  a.equal(state(actual), before);
  const result = pixels(actual);
  const reference = pixels(expected);
  const strokePixels = pixels(strokeOnly);
  const fillPixels = pixels(fillOnly);
  a.equal(result.some(value => value !== 0), true);
  a.equal(result.every((value, index) => value === reference[index]), true);
  a.equal(result.some((value, index) => value !== strokePixels[index]), true);
  a.equal(result.some((value, index) => value !== fillPixels[index]), true);
  // save/restore does not restore the path; the caller-owned path was replaced.
  actual.clearRect(-100, -100, 400, 400);
  expected.clearRect(-100, -100, 400, 400);
  actual.stroke();
  expected.stroke();
  const restrokedReference = pixels(expected);
  a.equal(pixels(actual).every((value, index) => value === restrokedReference[index]), true);
}
