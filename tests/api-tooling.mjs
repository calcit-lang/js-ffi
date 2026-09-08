import { test } from 'node:test';
import assert from 'node:assert/strict';
import { copyFileSync, mkdtempSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { spawnSync } from 'node:child_process';
import { calcit, decodeEdnJson, definition, parseDefinitionReport, root } from '../scripts/api-lib.mjs';

test('definition query consumes one complete versioned JSON envelope', () => {
  const element = definition('js-ffi.browser/DomElementHost');
  const ffi = decodeEdnJson(element.ffi);
  assert.equal(element.id, 'js-ffi.browser/DomElementHost');
  assert.equal(ffi.names['text-content'], 'textContent');
  assert.equal(ffi.names['class-name'], 'className');
  assert.ok(Object.keys(ffi.names).length >= 13, 'large host metadata must not be truncated');

  const plain = definition('js-ffi.browser/add-event-listener!');
  assert.equal(plain.ffi, null, 'definitions without FFI metadata stay explicit');
});

test('tagged query metadata preserves Unicode, escaping, sets, and nested keys', () => {
  const decoded = decodeEdnJson({
    ':label': '引号 " 和换行\n',
    ':target': { __edn_tag: '浏览器' },
    ':members': { ':méthod': 'méthod' },
    ':writable': { __edn_set: [{ __edn_tag: 'β' }, { __edn_tag: 'α' }] },
  });
  assert.deepEqual(decoded, {
    label: '引号 " 和换行\n',
    target: '浏览器',
    members: { méthod: 'méthod' },
    writable: ['α', 'β'],
  });
});

test('definition query rejects malformed or incompatible envelopes', () => {
  assert.throws(() => parseDefinitionReport('demo/main!', '{'), SyntaxError);
  assert.throws(
    () => parseDefinitionReport('demo/main!', JSON.stringify({ schema_version: 2, command: 'query.def', data: { id: 'demo/main!' } })),
    /Unsupported Calcit definition query envelope/,
  );
  assert.throws(
    () => parseDefinitionReport('demo/main!', JSON.stringify({ schema_version: 1, command: 'query.context', data: { id: 'demo/main!' } })),
    /Unsupported Calcit definition query envelope/,
  );
  assert.throws(
    () => parseDefinitionReport('demo/main!', JSON.stringify({ schema_version: 1, command: 'query.def', data: { id: 'demo/other' } })),
    /returned demo\/other for demo\/main!/,
  );
});

test('API check discovers an unused new definition and rejects its invalid call', () => {
  const dir = mkdtempSync(join(tmpdir(), 'js-ffi-discovery-'));
  try {
    const snapshot = join(dir, 'calcit.cirru');
    copyFileSync(join(root, 'calcit.cirru'), snapshot);
    copyFileSync(join(root, 'deps.cirru'), join(dir, 'deps.cirru'));
    calcit([snapshot, 'edit', 'def', 'js-ffi.node/unused-invalid', '--code', 'quote $ defn unused-invalid () $ path-basename 42'], dir);
    calcit([snapshot, 'edit', 'schema', 'js-ffi.node/unused-invalid', '--code', "quote $ :: 'Fn $ {} (:args $ []) (:return 'String)"], dir);
    const before = readFileSync(snapshot, 'utf8');
    const result = spawnSync(process.execPath, [join(root, 'scripts/check-api.mjs'), '--snapshot', snapshot], { cwd: root, encoding: 'utf8' });
    assert.ifError(result.error);
    assert.notEqual(result.status, 0);
    assert.match(result.stderr, /W_FN_ARG_TYPE_MISMATCH/);
    assert.match(result.stderr, /unused-invalid/);
    assert.equal(readFileSync(snapshot, 'utf8'), before, 'Checking must leave the input snapshot unchanged');
  } finally { rmSync(dir, { recursive: true, force: true }); }
});

test('catalog builds on first search, refreshes stale data, and preserves host metadata', () => {
  const cachePath = join(root, '.calcit/api/api.json');
  rmSync(cachePath, { force: true });
  const search = (...args) => spawnSync(process.execPath, [join(root, 'scripts/api-catalog.mjs'), 'search', ...args], { cwd: root, encoding: 'utf8' });
  const cold = search('DomElementHost', 'browser');
  assert.equal(cold.status, 0, cold.stderr);
  assert.equal(JSON.parse(cold.stdout)[0].id, 'js-ffi.browser/DomElementHost');
  const catalog = JSON.parse(readFileSync(cachePath, 'utf8'));
  writeFileSync(cachePath, JSON.stringify({ ...catalog, sourceFingerprint: 'stale' }));
  const refreshed = search('DomElementHost', 'browser');
  assert.equal(refreshed.status, 0, refreshed.stderr);
  assert.equal(JSON.parse(readFileSync(cachePath, 'utf8')).sourceFingerprint, catalog.sourceFingerprint);
  const element = catalog.definitions.find(def => def.id === 'js-ffi.browser/DomElementHost');
  assert.equal(element.ffi.names['text-content'], 'textContent');
  assert.equal(element.ffi.names['class-name'], 'className');
  assert.equal(element.declaration[0], 'deftrait');
  const result = spawnSync(process.execPath, [join(root, 'scripts/api-catalog.mjs'), 'search', 'storage', 'node'], { cwd: root, encoding: 'utf8' });
  assert.equal(result.status, 0, result.stderr);
  assert.deepEqual(JSON.parse(result.stdout), []);
});
