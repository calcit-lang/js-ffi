import { execFileSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import { resolve } from 'node:path';

export const root = fileURLToPath(new URL('../', import.meta.url));
export const publicNamespaces = ['js-ffi.browser', 'js-ffi.contract', 'js-ffi.node', 'js-ffi.shared'];

/** Run the pinned Calcit CLI without a shell; preserve diagnostics on failure. */
export function calcit(args, cwd = root) {
  try {
    return execFileSync('calcit', args, { cwd, encoding: 'utf8', maxBuffer: 32 * 1024 * 1024, stdio: ['ignore', 'pipe', 'pipe'] });
  } catch (error) {
    throw new Error(`calcit ${args.join(' ')} failed\n${error.stdout ?? ''}${error.stderr ?? ''}`, { cause: error });
  }
}

/** Discover every definition in the four public namespaces using structured CLI output. */
export function inventory(snapshot = resolve(root, 'calcit.cirru')) {
  const report = JSON.parse(calcit([snapshot, 'analyze', 'check-types', '--format', 'json']));
  if (report.schema_version !== 2) throw new Error('Unsupported Calcit type report version');
  return report.data.definitions.filter(def => publicNamespaces.includes(def.namespace)).sort((a, b) => a.id < b.id ? -1 : a.id > b.id ? 1 : 0);
}

/** Calcit 0.13.77 exposes definition metadata after a documented legacy JSON marker. */
export function definition(id) {
  const output = calcit(['query', 'def', id, '--raw', '--json']);
  const marker = '\nJSON:\n';
  const offset = output.lastIndexOf(marker);
  if (offset < 0) throw new Error(`Missing definition JSON for ${id}`);
  return JSON.parse(output.slice(offset + marker.length));
}

/** Namespace policy is explicit: host capability discovery must not infer runtime from names of functions. */
export function runtimes(namespace) {
  if (namespace === 'js-ffi.browser') return ['browser'];
  if (namespace === 'js-ffi.node') return ['node'];
  return ['browser', 'node'];
}
