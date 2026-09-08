import assert from 'node:assert/strict';
import { execFileSync, spawnSync } from 'node:child_process';
import { copyFileSync, mkdtempSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';

const calcitBin = process.env.CALCIT_BIN ?? 'calcit';

// Each invalid consumer uses a separate snapshot. Never mutate library sources.
const cases = [
  ['node', 'node/path-basename 42', /W_FN_ARG_TYPE_MISMATCH/],
  ['node', 'shared/headers-get (shared/url-create |\/ |https:\/\/example.com) |x', /W_FN_ARG_TYPE_MISMATCH/],
  ['browser', 'browser/clear-timeout! |not-a-handle', /W_FN_ARG_TYPE_MISMATCH/],
  ['browser', 'browser/request-animation-frame! 42', /W_FN_ARG_TYPE_MISMATCH/],
  ['browser', 'webgpu/destroy-device! 42', /W_FN_ARG_TYPE_MISMATCH/],
  ['browser', 'webgpu/buffer-size (option:unwrap (webgpu/gpu))', /W_FN_ARG_TYPE_MISMATCH/],
  ['browser', 'webgpu/request-adapter! (option:unwrap (webgpu/gpu)) 42 42', /W_FN_ARG_TYPE_MISMATCH/],
  ['node', 'shared/response-host (shared/fetch-response |http:\/\/127.0.0.1)', /E_ASYNC_INVOCATION_REQUIRES_AWAIT/],
  ['node', 'let ((load shared/fetch-response)) (shared/response-host (load |http:\/\/127.0.0.1))', /E_ASYNC_INVOCATION_REQUIRES_AWAIT/],
];
for (const [runtime, expression, diagnostic] of cases) {
  const dir = mkdtempSync(join(tmpdir(), 'js-ffi-types-'));
  try {
    const snapshot = join(dir, 'calcit.cirru');
    copyFileSync(new URL('../calcit.cirru', import.meta.url), snapshot);
    copyFileSync(new URL('../deps.cirru', import.meta.url), join(dir, 'deps.cirru'));
    const target = `js-ffi.${runtime}-test/invalid-call!`;
    const mutate = args => execFileSync(calcitBin, [snapshot, ...args], { cwd: dir, stdio: 'pipe' });
    mutate(['edit', 'def', target, '--code', `quote $ defn invalid-call! ()\n  do (${expression}) &unit`]);
    mutate(['edit', 'schema', target, '--code', "quote $ :: 'Fn $ {} (:args $ []) (:return 'Unit)"]);
    const result = spawnSync(calcitBin, [snapshot, '--entry', runtime, '--init-fn', target, '--check-only'], { cwd: dir, encoding: 'utf8' });
    assert.ifError(result.error);
    assert.notEqual(result.status, 0, `Invalid consumer unexpectedly passed: ${expression}`);
    assert.match(result.stdout + result.stderr, diagnostic, `Expected type mismatch for ${expression}`);
  } finally { rmSync(dir, { recursive: true, force: true }); }
}

// Passing an async definition to a synchronous callback slot must retain the
// invocation contract instead of silently treating its logical Result as sync.
{
  const dir = mkdtempSync(join(tmpdir(), 'js-ffi-async-callback-'));
  try {
    const snapshot = join(dir, 'calcit.cirru');
    copyFileSync(new URL('../calcit.cirru', import.meta.url), snapshot);
    copyFileSync(new URL('../deps.cirru', import.meta.url), join(dir, 'deps.cirru'));
    const mutate = args => execFileSync(calcitBin, [snapshot, ...args], { cwd: dir, stdio: 'pipe' });
    mutate(['edit', 'def', 'js-ffi.node-test/accept-sync-loader', '--code', 'quote $ defn accept-sync-loader (loader) &unit']);
    mutate(['edit', 'schema', 'js-ffi.node-test/accept-sync-loader', '--code', "quote $ :: 'Fn $ {} (:args $ [] (:: 'Fn $ {} (:args $ [] 'String) (:return $ :: 'Result 'js-ffi.shared/ResponseHost 'js-ffi.shared/JsError))) (:return 'Unit)"]);
    mutate(['edit', 'def', 'js-ffi.node-test/invalid-call!', '--code', 'quote $ defn invalid-call! ()\n  accept-sync-loader shared/fetch-response']);
    mutate(['edit', 'schema', 'js-ffi.node-test/invalid-call!', '--code', "quote $ :: 'Fn $ {} (:args $ []) (:return 'Unit)"]);
    const result = spawnSync(calcitBin, [snapshot, '--entry', 'node', '--init-fn', 'js-ffi.node-test/invalid-call!', '--check-only'], { cwd: dir, encoding: 'utf8' });
    assert.ifError(result.error);
    assert.notEqual(result.status, 0, 'Async callback unexpectedly passed a synchronous callback slot');
    assert.match(result.stdout + result.stderr, /W_FN_ARG_TYPE_MISMATCH/);
  } finally { rmSync(dir, { recursive: true, force: true }); }
}

// The response-text wrapper carries the checked async contract while the raw
// trait member remains an opaque Promise-like JsObject.
{
  const dir = mkdtempSync(join(tmpdir(), 'js-ffi-async-method-'));
  try {
    const snapshot = join(dir, 'calcit.cirru');
    copyFileSync(new URL('../calcit.cirru', import.meta.url), snapshot);
    copyFileSync(new URL('../deps.cirru', import.meta.url), join(dir, 'deps.cirru'));
    const mutate = args => execFileSync(calcitBin, [snapshot, ...args], { cwd: dir, stdio: 'pipe' });
    mutate(['edit', 'def', 'js-ffi.node-test/fake-response', '--code', 'quote $ defn fake-response ()\n  raise |not-executed']);
    mutate(['edit', 'schema', 'js-ffi.node-test/fake-response', '--code', "quote $ :: 'Fn $ {} (:args $ []) (:return 'js-ffi.shared/ResponseHost)"]);
    mutate(['edit', 'def', 'js-ffi.node-test/invalid-call!', '--code', 'quote $ defn invalid-call! ()\n  shared/normalize-error $ shared/response-text (fake-response)']);
    mutate(['edit', 'schema', 'js-ffi.node-test/invalid-call!', '--code', "quote $ :: 'Fn $ {} (:args $ []) (:return 'js-ffi.shared/JsError)"]);
    const result = spawnSync(calcitBin, [snapshot, '--entry', 'node', '--init-fn', 'js-ffi.node-test/invalid-call!', '--check-only'], { cwd: dir, encoding: 'utf8' });
    assert.ifError(result.error);
    assert.notEqual(result.status, 0, 'Unawaited response-text unexpectedly passed');
    assert.match(result.stdout + result.stderr, /E_ASYNC_INVOCATION_REQUIRES_AWAIT/);
  } finally { rmSync(dir, { recursive: true, force: true }); }
}

console.log(`Type contracts: ${cases.length + 2} invalid consumers rejected`);
