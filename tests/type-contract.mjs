import assert from 'node:assert/strict';
import { execFileSync, spawnSync } from 'node:child_process';
import { copyFileSync, mkdtempSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';

const calcitBin = process.env.CALCIT_BIN ?? 'calcit';

// Each invalid consumer uses a separate snapshot. Never mutate library sources.
const cases = [
  ['node', 'node/path-basename 42', /W_FN_ARG_TYPE_MISMATCH/],
  ['browser', 'node/path-basename |index.js', /E_JS_FFI_TARGET_MISMATCH/, 'js-ffi.node :as node'],
  ['node', 'node/path-join |src 42', /W_FN_ARG_TYPE_MISMATCH/],
  ['node', 'node/clear-timeout! 42', /W_FN_ARG_TYPE_MISMATCH/],
  ['node', 'node/clear-interval! 42', /W_FN_ARG_TYPE_MISMATCH/],
  ['node', 'node/set-interval! 42 1', /W_FN_ARG_TYPE_MISMATCH/],
  ['browser', 'node/clear-timeout! (node/set-timeout! (fn () &unit) 1)', /E_JS_FFI_TARGET_MISMATCH/, 'js-ffi.node :as node'],
  ['browser', 'node/clear-interval! (node/set-interval! (fn () &unit) 1)', /E_JS_FFI_TARGET_MISMATCH/, 'js-ffi.node :as node'],
  ['node', 'shared/console-info! 42', /W_FN_ARG_TYPE_MISMATCH/],
  ['browser', 'node/path-join |src |index.js', /E_JS_FFI_TARGET_MISMATCH/, 'js-ffi.node :as node'],
  ['node', 'shared/headers-get (shared/url-create |\/ |https:\/\/example.com) |x', /W_FN_ARG_TYPE_MISMATCH/],
  ['browser', 'browser/clear-timeout! |not-a-handle', /W_FN_ARG_TYPE_MISMATCH/],
  ['browser', 'browser/storage-get 42', /W_FN_ARG_TYPE_MISMATCH/],
  ['browser', 'js-set ((browser/create-element |div) :style) :css-text 42', /W_JS_FFI_FIELD_TYPE_MISMATCH/, undefined, true],
  ['browser', 'browser/request-animation-frame! 42', /W_FN_ARG_TYPE_MISMATCH/],
  ['browser', 'webgpu/destroy-device! 42', /W_FN_ARG_TYPE_MISMATCH/],
  ['browser', 'webgpu/buffer-size (option:unwrap (webgpu/gpu))', /W_FN_ARG_TYPE_MISMATCH/],
  ['browser', 'webgpu/request-adapter! (option:unwrap (webgpu/gpu)) 42 42', /W_FN_ARG_TYPE_MISMATCH/],
  ['browser', 'canvas-batches/clear-canvas! 42 40 30', /W_FN_ARG_TYPE_MISMATCH/],
  ['node', 'js-ffi.canvas-batches/draw-image-at! (raise |context) (raise |image) 0 0', /E_JS_FFI_TARGET_MISMATCH/],
  ['node', 'shared/response-host (shared/fetch-response |http:\/\/127.0.0.1)', /E_ASYNC_INVOCATION_REQUIRES_AWAIT/],
  ['node', 'let ((load shared/fetch-response)) (shared/response-host (load |http:\/\/127.0.0.1))', /E_ASYNC_INVOCATION_REQUIRES_AWAIT/],
];
for (const [runtime, expression, diagnostic, extraImport, hostFeature] of cases) {
  const dir = mkdtempSync(join(tmpdir(), 'js-ffi-types-'));
  try {
    const snapshot = join(dir, 'calcit.cirru');
    copyFileSync(new URL('../calcit.cirru', import.meta.url), snapshot);
    copyFileSync(new URL('../deps.cirru', import.meta.url), join(dir, 'deps.cirru'));
    const target = `js-ffi.${runtime}-test/invalid-call!`;
    const mutate = args => execFileSync(calcitBin, [snapshot, ...args], { cwd: dir, stdio: 'pipe' });
    if (runtime === 'browser') mutate(['edit', 'add-import', 'js-ffi.browser-test', '--code', 'quote $ js-ffi.canvas-batches :as canvas-batches']);
    if (extraImport) mutate(['edit', 'add-import', `js-ffi.${runtime}-test`, '--code', `quote $ ${extraImport}`]);
    mutate(['edit', 'def', target, '--code', `quote $ defn invalid-call! ()\n  do (${expression}) &unit`]);
    const feature = hostFeature ? ' (:features $ #{} :js-ffi)' : '';
    mutate(['edit', 'schema', target, '--code', `quote $ :: 'Fn $ {} (:args $ []) (:return 'Unit)${feature}`]);
    const result = spawnSync(calcitBin, [snapshot, '--entry', runtime, '--init-fn', target, '--check-only'], { cwd: dir, encoding: 'utf8' });
    assert.ifError(result.error);
    assert.notEqual(result.status, 0, `Invalid consumer unexpectedly passed: ${expression}`);
    assert.match(result.stdout + result.stderr, diagnostic, `Expected type mismatch for ${expression}`);
  } finally { rmSync(dir, { recursive: true, force: true }); }
}

// The generic predicate must accept distinct concrete input types while
// retaining a Boolean result at every call site.
{
  const dir = mkdtempSync(join(tmpdir(), 'js-ffi-promise-generic-'));
  try {
    const snapshot = join(dir, 'calcit.cirru');
    copyFileSync(new URL('../calcit.cirru', import.meta.url), snapshot);
    copyFileSync(new URL('../deps.cirru', import.meta.url), join(dir, 'deps.cirru'));
    const target = 'js-ffi.node-test/generic-promise-calls?';
    const mutate = args => execFileSync(calcitBin, [snapshot, ...args], { cwd: dir, stdio: 'pipe' });
    mutate(['edit', 'def', target, '--code', 'quote $ defn generic-promise-calls? ()\n  and\n    not $ shared/promise? 42\n    not $ shared/promise? |text\n    not $ shared/promise? $ {} (:x 1)']);
    mutate(['edit', 'schema', target, '--code', "quote $ :: 'Fn $ {} (:args $ []) (:return 'Bool)"]);
    const result = spawnSync(calcitBin, [snapshot, '--entry', 'node', '--init-fn', target, '--check-only'], { cwd: dir, encoding: 'utf8' });
    assert.ifError(result.error);
    assert.equal(result.status, 0, result.stdout + result.stderr);
  } finally { rmSync(dir, { recursive: true, force: true }); }
}

// Promise host handles do not prove the type of an awaited payload.
const stringCallback = ":: 'Fn $ {} (:args ([] 'String)) (:return 'Unit)";
const preciseExecutor = `shared/promise-create $ fn (resolve reject)\n    hint-fn $ {} (:args $ [] (${stringCallback}) (${stringCallback})) (:return 'Unit)\n    resolve |ok\n    , &unit`;
const hostSetup = `let\n      host $ shared/promise-create $ fn (resolve reject)\n        hint-fn $ {} (:args $ [] (${stringCallback}) (${stringCallback})) (:return 'Unit)\n        resolve |ok\n        , &unit`;
const promiseCases = [
  [preciseExecutor + '\n  , &unit', true],
  [preciseExecutor.replace(`(${stringCallback}) (${stringCallback})`, `(${stringCallback}) (:: 'Fn $ {} (:args $ [] (:: 'JsNullish 'JsObject)) (:return 'Unit))`) + '\n  , &unit', true],
  [preciseExecutor.replace('resolve |ok', 'resolve 42') + '\n  , &unit', false],
  [preciseExecutor.replace('resolve |ok', 'reject 42') + '\n  , &unit', false],
  [preciseExecutor.replace(`(${stringCallback}) (${stringCallback})`, `(${stringCallback}) 'DynFn`) + '\n  , &unit', false],
  ["shared/promise-create $ fn (resolve)\n    hint-fn $ {} (:args $ [] (" + stringCallback + ")) (:return 'Unit)\n    resolve |ok\n    , &unit\n  , &unit", false],
  ["fn (host)\n    hint-fn $ {} (:args ([] 'js-ffi.shared/PromiseHost)) (:return 'Unit) (:features (#{} :js-ffi))\n    shared/promise-observe! host\n      fn (value)\n        hint-fn $ {} (:args ([] 'js-ffi.shared/PromiseHost)) (:return 'Unit) (:features (#{} :js-ffi))\n        value .then! $ fn (item) &unit\n        , &unit\n      fn (error) &unit\n  , &unit", false],
  ["shared/promise-observe! |ok\n    fn (value)\n      hint-fn $ {} (:args ([] 'String)) (:return 'Unit)\n      , &unit\n    fn (error) &unit", false],
  ["shared/promise-observe! |ok\n    fn (value) &unit\n    fn (error)\n      hint-fn $ {} (:args ([] 'String)) (:return 'Unit)\n      , &unit", false],
  [hostSetup + "\n    host .then! $ fn (value)\n      hint-fn $ {} (:args ([] 'String)) (:return 'Unit)\n      , &unit\n    , &unit", false, /Method `\.then!` arg 2 expects type `fn\(js-nullish<:js-object>\) -> :unit`/],
  [hostSetup + "\n    host .catch! $ fn (error)\n      hint-fn $ {} (:args ([] 'String)) (:return 'Unit)\n      , &unit\n    , &unit", false, /Method `\.catch!` arg 2 expects type `fn\(js-nullish<:js-object>\) -> :unit`/],
];
for (const [body, accepted, diagnostic = /(?:TYPE_MISMATCH|ARITY_MISMATCH|CALL_ARGUMENT_UNPROVEN)/] of promiseCases) {
  const dir = mkdtempSync(join(tmpdir(), 'js-ffi-promise-contract-'));
  try {
    const snapshot = join(dir, 'calcit.cirru');
    copyFileSync(new URL('../calcit.cirru', import.meta.url), snapshot);
    copyFileSync(new URL('../deps.cirru', import.meta.url), join(dir, 'deps.cirru'));
    const target = 'js-ffi.node-test/promise-contract!';
    const mutate = args => execFileSync(calcitBin, [snapshot, ...args], { cwd: dir, stdio: 'pipe' });
    mutate(['edit', 'def', target, '--input-format', 'cirru', '--code', `quote $ defn promise-contract! ()\n  ${body}`]);
    mutate(['edit', 'schema', target, '--code', "quote $ :: 'Fn $ {} (:args ([])) (:return 'Unit) (:features (#{} :js-ffi))"]);
    const result = spawnSync(calcitBin, [snapshot, '--entry', 'node', '--init-fn', target, '--check-only'], { cwd: dir, encoding: 'utf8' });
    assert.ifError(result.error);
    if (accepted) assert.equal(result.status, 0, result.stdout + result.stderr);
    else {
      assert.notEqual(result.status, 0, `Unproven Promise consumer passed: ${body}`);
      assert.match(result.stdout + result.stderr, diagnostic, result.stdout + result.stderr);
    }
  } finally { rmSync(dir, { recursive: true, force: true }); }
}

// Invalid typed Canvas consumers are checked without executing host effects.
const invalidCanvas = [
  'context .move-to! |x 2',
  'context .line-to! 1 |y',
  'context .stroke! 42',
  'context .fill! 42',
  'context .arc! |x 0 12 0 3 false',
  'context .arc! 0 0 12 0 3 0',
  'context .bezier-curve-to! 1 2 3 4 5 |bad',
  'context .bezier-curve-to! 1 2 3 4 5',
  'context .close-path! 42',
  'js-set context :stroke-style 42',
  'js-set context :line-width |wide',
  'js-set context :line-cap 42',
  'js-set context :line-join 42',
  'js-set context :miter-limit |eight',
  'context .fill-text! 42 1 2',
  'context .fill-text! |hello |x 2',
  'context .measure-text 42',
  'js-set (context .measure-text |hello) :width 42',
  'js-set context :font 42',
  'js-set context :text-align 42',
  'js-set context :text-baseline 42',
  'js-set context :direction 42',
  'js-ffi.canvas-batches/draw-image-crop! context 42 0 0 1 1 0 0 1 1',
  'js-ffi.canvas-batches/draw-image-crop! context (js-ffi.browser/image-create) |x 0 1 1 0 0 1 1',
  'js-ffi.canvas-batches/draw-image-at! context (js-ffi.browser/image-create) |x 0',
  'js-ffi.canvas-batches/draw-image-sized! context (js-ffi.browser/image-create) 0 0 1',
];
for (const expression of invalidCanvas) {
  const dir = mkdtempSync(join(tmpdir(), 'js-ffi-canvas-types-'));
  try {
    const snapshot = join(dir, 'calcit.cirru');
    copyFileSync(new URL('../calcit.cirru', import.meta.url), snapshot);
    copyFileSync(new URL('../deps.cirru', import.meta.url), join(dir, 'deps.cirru'));
    const mutate = args => execFileSync(calcitBin, [snapshot, ...args], { cwd: dir, stdio: 'pipe' });
    const target = 'js-ffi.browser-test/invalid-canvas!';
    mutate(['edit', 'def', target, '--code', `quote $ defn invalid-canvas! (context)\n  do (${expression}) &unit`]);
    mutate(['edit', 'schema', target, '--code', "quote $ :: 'Fn $ {} (:args $ [] 'js-ffi.canvas-batches/CanvasContextHost) (:return 'Unit) (:features $ #{} :js-ffi)"]);
    mutate(['edit', 'def', 'js-ffi.browser-test/check-canvas!', '--code', 'quote $ defn check-canvas! ()\n  do invalid-canvas! &unit']);
    mutate(['edit', 'schema', 'js-ffi.browser-test/check-canvas!', '--code', "quote $ :: 'Fn $ {} (:args $ []) (:return 'Unit)"]);
    const result = spawnSync(calcitBin, [snapshot, '--entry', 'browser', '--init-fn', 'js-ffi.browser-test/check-canvas!', '--check-only'], { cwd: dir, encoding: 'utf8' });
    assert.ifError(result.error);
    assert.notEqual(result.status, 0, `Invalid Canvas consumer passed: ${expression}`);
    assert.match(result.stdout + result.stderr, /(?:TYPE_MISMATCH|ARITY_MISMATCH|FIELD_READONLY|expects type|expects \d+ args|expected \d+ args)/, expression);
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

console.log(`Type contracts: ${cases.length + invalidCanvas.length + 2 + promiseCases.filter(([, accepted]) => !accepted).length} invalid consumers rejected`);
