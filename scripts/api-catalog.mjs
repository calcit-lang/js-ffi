import { existsSync, mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import { createHash } from 'node:crypto';
import { execFileSync } from 'node:child_process';
import { join } from 'node:path';
import { calcit, definition, inventory, publicNamespaces, root, runtimes } from './api-lib.mjs';

const command = process.argv[2];
if (!['generate', 'check', 'search', 'cache'].includes(command)) throw new Error('Usage: api-catalog.mjs generate|check|search [query] [browser|node]');
const cacheDir = join(root, '.calcit/api');
const jsonPath = join(cacheDir, 'api.json');
const recipes = JSON.parse(readFileSync(join(root, 'examples/recipes.json'), 'utf8'));
// Cache identity includes every source that affects the generated records.
const hash = createHash('sha256');
for (const file of ['calcit.cirru', 'deps.cirru', 'package.json', 'scripts/api-lib.mjs', 'scripts/api-catalog.mjs', 'examples/recipes.json', ...recipes.map(recipe => recipe.source)]) {
  hash.update(file).update('\0').update(readFileSync(join(root, file))).update('\0');
}
const sourceFingerprint = hash.digest('hex');
if (command === 'search') {
  const query = (process.argv[3] ?? '').toLowerCase();
  const runtime = process.argv[4];
  if (runtime && !['browser', 'node'].includes(runtime)) throw new Error('Runtime must be browser or node');
  let catalog;
  try { catalog = JSON.parse(readFileSync(jsonPath, 'utf8')); } catch { /* Rebuild missing or corrupt generated data. */ }
  if (catalog?.schemaVersion !== 1 || !Array.isArray(catalog?.definitions) || catalog.sourceFingerprint !== sourceFingerprint) {
    // Keep search stdout JSON-only, including on a fresh checkout.
    execFileSync(process.execPath, [join(root, 'scripts/api-catalog.mjs'), 'cache'], { cwd: root, stdio: 'pipe' });
    catalog = JSON.parse(readFileSync(jsonPath, 'utf8'));
  }
  console.log(JSON.stringify(catalog.definitions.filter(def => (!runtime || def.runtimes.includes(runtime)) && `${def.id} ${def.doc}`.toLowerCase().includes(query)), null, 2));
} else {
  const defs = inventory();
  const ids = new Set(defs.map(def => def.id));
  for (const recipe of recipes) {
    for (const api of recipe.apis) {
      if (!ids.has(api)) throw new Error(`Unknown recipe API ${api}`);
      if (!recipe.runtimes.every(runtime => runtimes(api.split('/')[0]).includes(runtime))) throw new Error(`Wrong runtime for recipe API ${api}`);
    }
    readFileSync(join(root, recipe.source));
    readFileSync(join(root, recipe.validation));
  }
  // query def --json truncates long FFI metadata in Calcit 0.13.77, even with --raw.
  // Decode the authoritative snapshot through Calcit instead of using that display string.
  const snapshotSource = readFileSync(join(root, 'calcit.cirru'), 'utf8');
  // 0.13.77 parse-edn has no file/stdin input; leave room for executable and quoting.
  if (process.platform === 'win32' && snapshotSource.length > 24000) {
    throw new Error('Catalog generation needs Calcit parse-edn file/stdin support for this snapshot on Windows (command-line length limit). Generate the local cache under WSL, Linux or macOS; see Calcit issue #875.');
  }
  const snapshot = JSON.parse(calcit(['cirru', 'parse-edn', snapshotSource]));
  const decode = value => {
    if (Array.isArray(value)) return value.map(decode);
    if (!value || typeof value !== 'object') return value;
    if ('__edn_tag' in value) return value.__edn_tag;
    if ('__edn_set' in value) return value.__edn_set.map(decode).sort((a, b) => JSON.stringify(a).localeCompare(JSON.stringify(b), 'en'));
    return Object.fromEntries(Object.entries(value).map(([key, item]) => [key.replace(/^:/, ''), decode(item)]));
  };
  const records = defs.map(def => {
    const metadata = definition(def.id);
    if (!metadata.schema || !metadata.doc) throw new Error(`Missing schema/documentation: ${def.id}`);
    const source = snapshot[':files'][`'${def.namespace}`].defs[`'${def.name}`];
    return {
      id: def.id, namespace: def.namespace, name: def.name, kind: def.data_type ?? def.kind,
      runtimes: runtimes(def.namespace), import: `${def.namespace} :as ${def.namespace.split('.')[1]}`,
      schema: metadata.schema, doc: metadata.doc, tags: [...metadata.tags].sort(),
      ffi: source.ffi ? decode(source.ffi) : null,
      schemaData: source.schema,
      // Data declarations retain all field and method schemas, including external traits.
      declaration: def.kind === 'data' ? metadata.code : null,
      examples: metadata.examples,
      recipes: recipes.filter(recipe => recipe.apis.includes(def.id)).map(recipe => ({ source: recipe.source, validation: recipe.validation })),
      inspect: `calcit query def ${def.id} --raw --json`,
    };
  });
  const catalog = { schemaVersion: 1, sourceFingerprint, calcitVersion: calcit(['--version']).trim(), packageVersion: JSON.parse(readFileSync(join(root, 'package.json'), 'utf8')).version, publicNamespaces, definitions: records };
  let markdown = '# Public API catalog\n\nGenerated from Calcit definitions by `yarn api:generate`. Do not edit directly.\n\n';
  markdown += `${records.length} public definitions, including host traits and data types. Search (automatically refreshes a stale cache): \`yarn api:search storage browser\`. Machine-readable source: [api.json](api.json).\n\n`;
  markdown += 'Runtime availability follows the four public namespaces. Schemas and host metadata are declarations, not proof of arbitrary host values. Recipe links show demonstrated use, not exhaustive API coverage. Exception and lifecycle details: [adapter reference](../../docs/standard-host-adapters.md).\n\n';
  const esc = s => s.replaceAll('|', '\\|').replaceAll('\n', '<br>');
  for (const namespace of publicNamespaces) {
    markdown += `## ${namespace}\n\n`;
    for (const def of records.filter(def => def.namespace === namespace)) {
      markdown += `### ${def.name}\n\n${def.doc}\n\nRuntime: ${def.runtimes.join(', ')}. Kind: ${def.kind}.\n\n\`\`\`text\n${def.schema}\n\`\`\`\n\n`;
      markdown += `Inspect: \`${def.inspect}\`\n\n`;
      if (def.recipes.length) markdown += `Recipes: ${def.recipes.map(recipe => `[${esc(recipe.source)}](../../${recipe.source})`).join(', ')}.\n\n`;
    }
  }
  let cookbook = '# Executable Calcit recipes\n\nGenerated by `yarn api:generate` from `examples/recipes.json` and the Cirru source files.\n\n';
  cookbook += 'Each source is a quoted Calcit definition accepted by `calcit edit def --file`. The checker injects its imports and schema into a temporary snapshot, then compiles the actual recipe used by runtime tests.\n\nRun `yarn check:api`, `yarn test:node`, and `yarn test:browser`. Browser tests require Chromium (`yarn playwright install chromium`). Node file tests use a temporary directory and remove it in finally. The file recipe itself overwrites `example.txt` in the caller-provided directory.\n\n';
  for (const recipe of recipes) {
    cookbook += `## ${recipe.title}\n\nRuntime: ${recipe.runtimes.join(', ')}.\n\nImports:\n\n\`\`\`text\n${recipe.imports.join('\n')}\n\`\`\`\n\nSchema:\n\n\`\`\`text\n${recipe.schema}\n\`\`\`\n\nSource: [${recipe.source}](../${recipe.source})\n\n\`\`\`text\n${readFileSync(join(root, recipe.source), 'utf8').trim()}\n\`\`\`\n\nRuntime verification: [${recipe.validation}](../${recipe.validation}).\n\n`;
  }
  mkdirSync(cacheDir, { recursive: true });
  writeFileSync(jsonPath, JSON.stringify(catalog, null, 2) + '\n');
  writeFileSync(join(cacheDir, 'api.md'), markdown);
  const recipePath = join(root, 'docs/recipes.md');
  if (command === 'generate') writeFileSync(recipePath, cookbook);
  else if (command === 'check' && (!existsSync(recipePath) || readFileSync(recipePath, 'utf8') !== cookbook)) {
    throw new Error(`${recipePath} is stale; run yarn api:generate`);
  }
  console.log(`${records.length} public API records and ${recipes.length} recipes ${command === 'generate' ? 'generated' : 'verified'}`);
}
