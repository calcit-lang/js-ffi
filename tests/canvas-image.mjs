import * as browser from '../js-out/js-ffi.browser.mjs';
import {
  draw_image_at_$x_ as drawImageAt,
  draw_image_crop_$x_ as drawImageCrop,
  draw_image_sized_$x_ as drawImageSized,
} from '../js-out/js-ffi.canvas-batches.mjs';
import { result_$o_ok_$q_ as isOk, option_$o_none_$q_ as isNone, option_$o_unwrap as unwrap } from '../js-out/calcit.core.mjs';
import { canvas_surface as drawSurface } from '../js-out/js-ffi.canvas-surface-example.mjs';
import { dom_canvas_create as domSurface, offscreen_canvas_create as offscreenSurface, surface_2d_context as surfaceContext } from '../js-out/js-ffi.canvas-batches.mjs';

/** Compare the typed crop adapter with actual browser Canvas pixels and errors. */
export async function testCanvasImage(a) {
  testCanvasSurface(a);
  const source = document.createElement('canvas');
  source.width = 4;
  source.height = 2;
  const sourceContext = source.getContext('2d');
  sourceContext.fillStyle = '#ff0000';
  sourceContext.fillRect(0, 0, 2, 2);
  sourceContext.fillStyle = '#0000ff';
  sourceContext.fillRect(2, 0, 2, 2);

  const image = browser.image_create();
  browser.image_src_$x_(image, source.toDataURL('image/png'));
  a.equal(isOk(await browser.image_decode_$x_(image)), true);
  a.equal(browser.image_natural_width(image), 4);
  a.equal(browser.image_natural_height(image), 2);

  const naturalCanvas = document.createElement('canvas');
  naturalCanvas.width = 4;
  naturalCanvas.height = 2;
  const naturalContext = naturalCanvas.getContext('2d', { willReadFrequently: true });
  a.equal(drawImageAt(naturalContext, image, 0, 0), undefined);
  a.equal(Array.from(naturalContext.getImageData(0, 0, 1, 1).data).join(','), '255,0,0,255');
  a.equal(Array.from(naturalContext.getImageData(3, 0, 1, 1).data).join(','), '0,0,255,255');

  const scaledCanvas = document.createElement('canvas');
  scaledCanvas.width = 8;
  scaledCanvas.height = 2;
  const scaledContext = scaledCanvas.getContext('2d', { willReadFrequently: true });
  scaledContext.imageSmoothingEnabled = false;
  a.equal(drawImageSized(scaledContext, image, 0, 0, 8, 2), undefined);
  a.equal(Array.from(scaledContext.getImageData(1, 0, 1, 1).data).join(','), '255,0,0,255');
  a.equal(Array.from(scaledContext.getImageData(6, 0, 1, 1).data).join(','), '0,0,255,255');

  const target = document.createElement('canvas');
  target.width = 4;
  target.height = 4;
  const context = target.getContext('2d', { willReadFrequently: true });
  a.equal(drawImageCrop(context, image, 2, 0, 2, 2, 1, 1, 2, 2), undefined);
  const pixel = (x, y) => Array.from(context.getImageData(x, y, 1, 1).data).join(',');
  a.equal(pixel(0, 0), '0,0,0,0');
  a.equal(pixel(1, 1), '0,0,255,255');
  a.equal(pixel(2, 2), '0,0,255,255');
  a.equal(pixel(3, 3), '0,0,0,0');

  // Chromium treats a zero-width source rectangle as a no-op.
  a.equal(drawImageCrop(context, image, 0, 0, 0, 2, 0, 0, 2, 2), undefined);
  a.equal(pixel(1, 1), '0,0,255,255');
  const emptyImage = browser.image_create();
  // An image without a source is also a no-op in Chromium.
  a.equal(drawImageCrop(context, emptyImage, 0, 0, 1, 1, 0, 0, 1, 1), undefined);
  a.equal(pixel(1, 1), '0,0,255,255');
  a.throws(() => drawImageCrop(context, null, 0, 0, 1, 1, 0, 0, 1, 1), /TypeError/);
}

/** Compare surface overloads and verify that both success and rejection restore caller state. */
function testCanvasSurface(a) {
  const pixels = context => [...context.getImageData(0, 0, 80, 70).data];
  const target = () => {
    const canvas = document.createElement('canvas');
    canvas.width = 80; canvas.height = 70;
    const context = canvas.getContext('2d');
    context.globalAlpha = 0.7;
    context.translate(8, 7);
    context.beginPath(); context.rect(3, 2, 40, 40); context.clip();
    return context;
  };
  const invalid = target(), unchanged = target();
  a.throws(() => drawSurface(invalid, false, 3), /invalid-surface-mode/);
  a.equal(invalid.globalAlpha, unchanged.globalAlpha);
  a.equal(invalid.getTransform().e, unchanged.getTransform().e);
  a.equal(invalid.getTransform().f, unchanged.getTransform().f);
  a.equal(pixels(invalid).every(value => value === 0), true);
  // With no caller save, restore must be a no-op: the recipe must not leave a stack entry.
  invalid.globalAlpha = 0.9;
  invalid.restore();
  a.equal(invalid.globalAlpha, 0.9);
  invalid.globalAlpha = unchanged.globalAlpha;
  invalid.fillRect(-50, -50, 150, 150); unchanged.fillRect(-50, -50, 150, 150);
  const unchangedPixels = pixels(unchanged);
  a.equal(pixels(invalid).every((value, index) => value === unchangedPixels[index]), true);
  for (const offscreen of [false, true]) for (const mode of [0, 1, 2]) {
    const actual = target(), expected = target();
    const surface = drawSurface(actual, offscreen, mode);
    a.equal(surface.width, 32); a.equal(surface.height, 24);
    const native = offscreen ? new OffscreenCanvas(32, 24) : document.createElement('canvas');
    native.width = 32; native.height = 24;
    const source = native.getContext('2d');
    source.fillStyle = '#ff0000'; source.fillRect(0, 0, 24, 24);
    source.fillStyle = '#0000ff'; source.fillRect(16, 0, 16, 24);
    expected.save(); expected.globalAlpha = 0.5;
    if (mode === 0) expected.drawImage(native, 4, 5);
    if (mode === 1) expected.drawImage(native, 4, 5, 40, 30);
    if (mode === 2) expected.drawImage(native, 16, 0, 16, 24, 4, 5, 20, 30);
    expected.restore();
    const reference = pixels(expected), image = pixels(actual);
    a.equal(image.every((value, index) => value === reference[index]), true, `surface=${offscreen} mode=${mode}`);
    a.equal(image.some(value => value !== 0), true);
    a.equal(actual.globalAlpha, 0.7);
    a.equal(actual.getTransform().e, 8); a.equal(actual.getTransform().f, 7);
    actual.fillStyle = expected.fillStyle = '#00ff00';
    actual.fillRect(-50, -50, 150, 150); expected.fillRect(-50, -50, 150, 150);
    const restored = pixels(expected);
    a.equal(pixels(actual).every((value, index) => value === restored[index]), true, 'clip restored');
    surface.width = 32;
    a.equal(unwrap(surfaceContext(surface)).getImageData(0, 0, 1, 1).data[3], 0, 'resize clears surface');
  }
  for (const create of [domSurface, offscreenSurface]) {
    const surface = create(8, 8);
    a.equal(surface.getContext('bitmaprenderer') !== null, true);
    a.equal(isNone(surfaceContext(surface)), true, 'bound non-2d context remains unavailable');
  }
  a.throws(() => surfaceContext(null), /TypeError/);
  a.throws(() => surfaceContext({ getContext() { return {}; } }), /TypeError/);
  a.throws(() => surfaceContext({ getContext() { return 42; } }), /TypeError/);
  a.throws(() => surfaceContext({ getContext() { throw new Error('native-context-failure'); } }), /native-context-failure/);
  a.throws(() => offscreenSurface(-1, 8), /TypeError|RangeError/);
}
