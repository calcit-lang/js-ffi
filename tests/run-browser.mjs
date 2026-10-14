import assert from 'node:assert/strict';
import { createServer } from 'vite';
import { chromium } from 'playwright';

// Port 0 avoids collisions with developer servers and concurrent CI jobs.
const server = await createServer({ server: { host: '127.0.0.1', port: 0 }, logLevel: 'error' });
let browser;
try {
  await server.listen();
  browser = await chromium.launch({ headless: true });
  const page = await browser.newPage();
  const errors = [];
  page.on('pageerror', error => errors.push(String(error)));
  page.on('console', message => {
    if (message.type() === 'error') errors.push(message.text());
  });
  await page.goto(server.resolvedUrls.local[0], { waitUntil: 'load', timeout: 30000 });
  const result = await Promise.race([
    page.evaluate(async () => (await import('/tests/browser.mjs')).run()),
    new Promise((_, reject) => {
      const timer = setTimeout(() => reject(new Error('Browser FFI tests timed out after 30 seconds')), 30000);
      timer.unref();
    }),
  ]);
  assert.equal(result.passed, true);
  // Synthetic events cannot create an active native pointer; drive Chromium input.
  await page.evaluate(async () => {
    const api = await import('/js-out/js-ffi.browser.mjs');
    const recipe = await import('/js-out/js-ffi.pointer-capture-example.mjs');
    const core = await import('/js-out/calcit.core.mjs');
    const surface = document.createElement('div');
    surface.id = 'native-pointer-surface';
    surface.style.cssText = 'position:fixed;left:100px;top:100px;width:120px;height:80px;touch-action:none;z-index:10000;';
    document.body.append(surface);
    window.pointerEvidence = [];
    surface.addEventListener('pointerdown', event => {
      const sample = core.to_js_data(recipe.capture_from_event_$x_(surface, event));
      window.pointerEvidence.push({ phase: 'down', sample, owned: api.element_has_pointer_capture_$q_(surface, event.pointerId), prevented: event.defaultPrevented });
    });
    surface.addEventListener('pointermove', event => {
      if (event.buttons) window.pointerEvidence.push({ phase: 'move', x: event.clientX, owned: api.element_has_pointer_capture_$q_(surface, event.pointerId) });
    });
    surface.addEventListener('pointerup', event => {
      api.element_release_pointer_capture_$x_(surface, event.pointerId);
      window.pointerEvidence.push({ phase: 'up', owned: api.element_has_pointer_capture_$q_(surface, event.pointerId) });
    });
    surface.addEventListener('lostpointercapture', () => window.pointerEvidence.push({ phase: 'lost' }));
  });
  await page.mouse.move(110, 110); await page.mouse.down();
  await page.mouse.move(400, 300); await page.mouse.up();
  await page.waitForFunction(() => window.pointerEvidence.some(event => event.phase === 'lost'));
  const pointer = await page.evaluate(() => window.pointerEvidence), down = pointer.find(event => event.phase === 'down');
  assert.equal(down.owned, true); assert.equal(down.prevented, true);
  assert.ok(down.sample[0] >= 0);
  assert.deepEqual(down.sample.slice(1), [110, 110, 100, 100, 120, 80]);
  assert.ok(pointer.some(event => event.phase === 'move' && event.x === 400 && event.owned));
  assert.equal(pointer.find(event => event.phase === 'up').owned, false);
  assert.equal(pointer.filter(event => event.phase === 'lost').length, 1);
  await page.mouse.move(110, 110); await page.mouse.down();
  await page.mouse.move(115, 115);
  const removedId = await page.evaluate(() => {
    const id = window.pointerEvidence.filter(event => event.phase === 'down').at(-1).sample[0];
    window.removedPointerLosses = 0;
    document.addEventListener('lostpointercapture', event => { if (event.pointerId === id) window.removedPointerLosses++; }, { once: true });
    window.removedPointerSurface = document.querySelector('#native-pointer-surface');
    window.removedPointerSurface.remove();
    return id;
  });
  await page.mouse.move(400, 300);
  await page.waitForFunction(() => window.removedPointerLosses === 1);
  const removed = await page.evaluate(async id => {
    const api = await import('/js-out/js-ffi.browser.mjs');
    const element = window.removedPointerSurface;
    const owned = api.element_has_pointer_capture_$q_(element, id);
    api.element_release_pointer_capture_$x_(element, id);
    api.element_release_pointer_capture_$x_(element, id);
    return { owned, losses: window.removedPointerLosses };
  }, removedId);
  assert.deepEqual(removed, { owned: false, losses: 1 });
  await page.mouse.up();
  assert.deepEqual(errors, [], 'Browser must have no uncaught exceptions or console errors');
  console.log('Native PointerEvent: capture / outside movement / release / lost capture passed');
  console.log(`Browser: ${result.assertions} assertions passed (${result.runtime})`);
  console.log(`WebGPU: ${result.webgpu}`);
} finally {
  if (browser) await browser.close();
  await server.close();
}
