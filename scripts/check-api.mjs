import { copyFileSync, mkdtempSync, mkdirSync, readFileSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join, dirname, resolve } from 'node:path';
import { calcit, inventory, root, runtimes } from './api-lib.mjs';

const args = process.argv.slice(2);
let compile;
let sourceSnapshot = join(root, 'calcit.cirru');
while (args.length) {
  const flag = args.shift();
  if (flag === '--compile' && ['node', 'browser'].includes(args[0])) compile = args.shift();
  else if (flag === '--snapshot' && args[0]) sourceSnapshot = resolve(args.shift());
  else throw new Error('Usage: check-api.mjs [--compile node|browser] [--snapshot path]');
}
const definitions = inventory(sourceSnapshot);
const recipes = JSON.parse(readFileSync(join(root, 'examples/recipes.json'), 'utf8'));
for (const runtime of compile ? [compile] : ['node', 'browser']) {
  const dir = mkdtempSync(join(tmpdir(), 'js-ffi-api-'));
  try {
    const snapshot = join(dir, 'calcit.cirru');
    copyFileSync(sourceSnapshot, snapshot);
    copyFileSync(join(dirname(sourceSnapshot), 'deps.cirru'), join(dir, 'deps.cirru'));
    const edit = args => calcit([snapshot, ...args], dir);
    const selected = definitions.filter(def => runtimes(def.namespace).includes(runtime));
    const refs = selected.map(def => def.id.replace('js-ffi.', ''));
    const target = `js-ffi.${runtime}-test/check-api!`;
    edit(['edit', 'def', target, '--code', `quote $ defn check-api! ()\n  do ${refs.join(' ')} &unit`]);
    edit(['edit', 'schema', target, '--code', "quote $ :: 'Fn $ {} (:args $ []) (:return 'Unit)"]);
    edit(['tree', 'insert-before', `js-ffi.${runtime}-test/main!`, '--path', '@3', '--code', 'quote $ check-api!']);
    // Recipes are normal Calcit consumers, injected only into the temporary build snapshot.
    for (const recipe of recipes.filter(recipe => recipe.runtimes.includes(runtime))) {
      edit(['edit', 'add-ns', recipe.namespace]);
      for (const rule of recipe.imports) edit(['edit', 'add-import', recipe.namespace, '--code', `quote $ ${rule}`]);
      edit(['edit', 'def', `${recipe.namespace}/${recipe.name}`, '--file', join(root, recipe.source)]);
      edit(['edit', 'schema', `${recipe.namespace}/${recipe.name}`, '--code', `quote $ ${recipe.schema}`]);
      edit(['edit', 'add-import', `js-ffi.${runtime}-test`, '--code', `quote $ ${recipe.namespace} :refer $ ${recipe.name}`]);
      edit(['tree', 'insert-before', `js-ffi.${runtime}-test/main!`, '--path', '@3', '--code', `quote ${recipe.name}`]);
    }
    if (compile) {
      mkdirSync(join(root, 'js-out'), { recursive: true });
      edit(['--entry', runtime, '--emit-path', join(root, 'js-out'), 'js']);
    } else {
      edit(['--entry', runtime, '--check-only']);
    }
    console.log(`${runtime}: ${selected.length} public definitions and consumer recipes ${compile ? 'compiled' : 'type-checked'}`);
  } finally { rmSync(dir, { recursive: true, force: true }); }
}
