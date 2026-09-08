import { execFileSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import { resolve } from 'node:path';

export const root = fileURLToPath(new URL('../', import.meta.url));
export const publicNamespaces = ['js-ffi.browser', 'js-ffi.contract', 'js-ffi.node', 'js-ffi.shared', 'js-ffi.webgpu'];

/** Run the pinned Calcit CLI without a shell; preserve diagnostics on failure. */
export function calcit(args, cwd = root) {
  const executable = process.env.CALCIT_BIN ?? 'calcit';
  try {
    return execFileSync(executable, args, { cwd, encoding: 'utf8', maxBuffer: 32 * 1024 * 1024, stdio: ['ignore', 'pipe', 'pipe'] });
  } catch (error) {
    throw new Error(`${executable} ${args.join(' ')} failed\n${error.stdout ?? ''}${error.stderr ?? ''}`, { cause: error });
  }
}

/** Discover every definition in the public namespaces using structured CLI output. */
export function inventory(snapshot = resolve(root, 'calcit.cirru')) {
  const report = JSON.parse(calcit([snapshot, 'analyze', 'check-types', '--format', 'json']));
  if (report.schema_version !== 2) throw new Error('Unsupported Calcit type report version');
  return report.data.definitions.filter(def => publicNamespaces.includes(def.namespace)).sort((a, b) => a.id < b.id ? -1 : a.id > b.id ? 1 : 0);
}

/** Decode the tagged JSON representation used by Calcit machine-query fields. */
export function decodeEdnJson(value) {
  if (Array.isArray(value)) return value.map(decodeEdnJson);
  if (!value || typeof value !== 'object') return value;
  if ('__edn_tag' in value) return value.__edn_tag;
  if ('__edn_set' in value) return value.__edn_set.map(decodeEdnJson).sort((a, b) => JSON.stringify(a).localeCompare(JSON.stringify(b), 'en'));
  return Object.fromEntries(Object.entries(value).map(([key, item]) => [key.replace(/^:/, ''), decodeEdnJson(item)]));
}

/** Validate one Calcit query.def envelope and return its definition payload. */
export function parseDefinitionReport(id, output) {
  const report = JSON.parse(output);
  if (report.schema_version !== 1 || report.command !== 'query.def') {
    throw new Error(`Unsupported Calcit definition query envelope for ${id}`);
  }
  if (report.data?.id !== id) throw new Error(`Calcit definition query returned ${report.data?.id ?? 'no definition'} for ${id}`);
  return report.data;
}

/** Read one definition from Calcit query.def envelope v1. */
export function definition(id) {
  return parseDefinitionReport(id, calcit(['query', 'def', id, '--format', 'json']));
}

/** Namespace policy is explicit: host capability discovery must not infer runtime from names of functions. */
export function runtimes(namespace) {
  if (namespace === 'js-ffi.browser' || namespace === 'js-ffi.webgpu') return ['browser'];
  if (namespace === 'js-ffi.node') return ['node'];
  return ['browser', 'node'];
}
