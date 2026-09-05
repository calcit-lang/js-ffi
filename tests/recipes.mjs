import { test } from 'node:test';
import assert from 'node:assert/strict';
import { mkdtempSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { query_string } from '../js-out/js-ffi.query-example.mjs';
import { text_file } from '../js-out/js-ffi.file-example.mjs';

test('compiled Calcit query recipe encodes Unicode, spaces, and reserved characters', () => {
  assert.equal(query_string('中文 +&'), 'page=1&q=%E4%B8%AD%E6%96%87+%2B%26');
});

test('compiled Calcit file recipe reads back UTF-8 content and preserves errors', () => {
  const dir = mkdtempSync(join(tmpdir(), 'js-ffi-recipe-'));
  try { assert.equal(text_file(dir, '你好 🌍\n'), '你好 🌍\n'); }
  finally { rmSync(dir, { recursive: true, force: true }); }
  assert.throws(() => text_file(join(dir, 'missing'), 'text'), /ENOENT/);
});
