import { canvas_path as draw } from '../js-out/js-ffi.canvas-path-example.mjs';

// Native Canvas is the independent oracle; production library adds no JS renderer.
export function testCanvasPath(a) {
  const context = () => {
    const canvas = document.createElement('canvas');
    canvas.width = 140;
    canvas.height = 140;
    return canvas.getContext('2d', { willReadFrequently: true });
  };
  const pixels = ctx => ctx.getImageData(0, 0, 140, 140).data;
  const state = ctx => JSON.stringify([
    ctx.strokeStyle, ctx.fillStyle, ctx.lineWidth, ctx.lineCap, ctx.lineJoin,
    ctx.miterLimit, ...['a', 'b', 'c', 'd', 'e', 'f'].map(key => ctx.getTransform()[key]),
  ]);
  const setup = ctx => {
    ctx.strokeStyle = '#123456';
    ctx.fillStyle = '#abcdef';
    ctx.lineWidth = 3;
    ctx.lineCap = 'square';
    ctx.lineJoin = 'bevel';
    ctx.miterLimit = 1;
    ctx.setTransform(1.4, 0.2, -0.1, 1.1, 4, 3);
    ctx.beginPath();
    ctx.rect(0, 0, 55, 90);
    ctx.clip();
    // Must be replaced by beginPath, not accidentally added to the stroke.
    ctx.beginPath();
    ctx.moveTo(0, 70);
    ctx.lineTo(80, 70);
  };
  const native = (ctx, cap, join, closed) => {
    ctx.save();
    ctx.transform(1, 0, 0, 1, 7, 9);
    ctx.strokeStyle = '#ea580c';
    ctx.lineWidth = 10;
    ctx.lineCap = cap;
    ctx.lineJoin = join;
    ctx.miterLimit = 8;
    ctx.beginPath();
    ctx.moveTo(15, 45);
    ctx.lineTo(35, 15);
    ctx.lineTo(55, 45);
    if (closed) ctx.closePath();
    ctx.stroke();
    ctx.restore();
  };
  const signatures = new Map();
  for (const cap of ['butt', 'round', 'square']) {
    for (const join of ['miter', 'round', 'bevel']) {
      for (const closed of [false, true]) {
        const actual = context();
        const expected = context();
        setup(actual);
        setup(expected);
        const before = state(actual);
        a.equal(draw(actual, cap, join, closed), undefined);
        native(expected, cap, join, closed);
        a.equal(state(actual), before);
        const result = pixels(actual);
        const reference = pixels(expected);
        a.equal(result.some(value => value !== 0), true);
        a.equal(result.every((value, i) => value === reference[i]), true);
        if (!closed) signatures.set(`${cap}/${join}`, result.join(','));
        // clearRect leaves the path intact. Re-stroking after restore must
        // reproduce the new path, not the old caller-owned horizontal line.
        actual.clearRect(-100, -100, 400, 400);
        expected.clearRect(-100, -100, 400, 400);
        actual.stroke();
        expected.stroke();
        const restroked = pixels(actual);
        const restrokedReference = pixels(expected);
        a.equal(restroked.some(value => value !== 0), true);
        a.equal(restroked.every((value, i) => value === restrokedReference[i]), true);
      }
    }
  }
  // Negative controls: losing cap/join assignment must change these pixels.
  a.equal(new Set(signatures.values()).size, 9);
}
