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
  await page.goto(server.resolvedUrls.local[0], { waitUntil: 'networkidle', timeout: 30000 });
  const result = await Promise.race([
    page.evaluate(async () => (await import('/tests/browser.mjs')).run()),
    new Promise((_, reject) => {
      const timer = setTimeout(() => reject(new Error('Browser FFI tests timed out after 30 seconds')), 30000);
      timer.unref();
    }),
  ]);
  assert.equal(result.passed, true);
  assert.deepEqual(errors, [], 'Browser must have no uncaught exceptions or console errors');
  console.log(`Browser: ${result.assertions} assertions passed (${result.runtime})`);
} finally {
  if (browser) await browser.close();
  await server.close();
}
