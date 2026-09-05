import assert from 'node:assert/strict';
import { execFileSync, spawnSync } from 'node:child_process';
import { copyFileSync, mkdtempSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';

// Each invalid consumer uses a separate snapshot. Never mutate library sources.
const cases = [
  ['node', 'node/path-basename 42', /W_FN_ARG_TYPE_MISMATCH/],
  ['node', 'shared/headers-get (shared/url-create |\/ |https:\/\/example.com) |x', /W_FN_ARG_TYPE_MISMATCH/],
  ['browser', 'browser/clear-timeout! |not-a-handle', /W_FN_ARG_TYPE_MISMATCH/],
  ['browser', 'browser/request-animation-frame! 42', /W_FN_ARG_TYPE_MISMATCH/],
];
for (const [runtime, expression, diagnostic] of cases) {
  const dir = mkdtempSync(join(tmpdir(), 'js-ffi-types-'));
  try {
    const snapshot = join(dir, 'calcit.cirru');
    copyFileSync(new URL('../calcit.cirru', import.meta.url), snapshot);
    copyFileSync(new URL('../deps.cirru', import.meta.url), join(dir, 'deps.cirru'));
    const target = `js-ffi.${runtime}-test/invalid-call!`;
    const mutate = args => execFileSync('calcit', [snapshot, ...args], { cwd: dir, stdio: 'pipe' });
    mutate(['edit', 'def', target, '--code', `quote $ defn invalid-call! ()\n  do (${expression}) &unit`]);
    mutate(['edit', 'schema', target, '--code', "quote $ :: 'Fn $ {} (:args $ []) (:return 'Unit)"]);
    const result = spawnSync('calcit', [snapshot, '--entry', runtime, '--init-fn', target, '--check-only'], { cwd: dir, encoding: 'utf8' });
    assert.ifError(result.error);
    assert.notEqual(result.status, 0, `Invalid consumer unexpectedly passed: ${expression}`);
    assert.match(result.stdout + result.stderr, diagnostic, `Expected type mismatch for ${expression}`);
  } finally { rmSync(dir, { recursive: true, force: true }); }
}
console.log(`Type contracts: ${cases.length} invalid consumers rejected`);
