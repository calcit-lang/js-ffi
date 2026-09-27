import * as browser from '../js-out/js-ffi.browser.mjs';
import {
  draw_image_at_$x_ as drawImageAt,
  draw_image_crop_$x_ as drawImageCrop,
  draw_image_sized_$x_ as drawImageSized,
} from '../js-out/js-ffi.canvas-batches.mjs';
import { result_$o_ok_$q_ as isOk } from '../js-out/calcit.core.mjs';

/** Compare the typed crop adapter with actual browser Canvas pixels and errors. */
export async function testCanvasImage(a) {
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
