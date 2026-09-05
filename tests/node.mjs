import { test } from 'node:test';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { syncBuiltinESMExports } from 'node:module';
import * as node from '../js-out/js-ffi.node.mjs';
import { assertions, testShared } from './shared.mjs';

test('shared Web API adapters on Node', async () => {
  const a = assertions();
  await testShared(a);
  console.log(`Shared: ${a.count} assertions`);
});

test('Node paths, process, UTF-8 files and error boundaries', () => {
  const a = assertions();
  a.equal(node.path_basename('/work/file.txt'), 'file.txt');
  a.equal(node.path_dirname('/work/file.txt'), '/work');
  a.equal(node.path_extname('archive.tar.gz'), '.gz');
  a.equal(node.path_extname('.env'), '');
  a.equal(node.path_normalize('/work/../data/./x'), path.normalize('/work/../data/./x'));
  a.equal(node.path_resolve('/work', '../data'), path.resolve('/work', '../data'));
  a.equal(node.path_relative('/work', '/work/data/file'), path.relative('/work', '/work/data/file'));
  a.equal(node.path_absolute_$q_('/work'), true);
  a.equal(node.path_absolute_$q_('work'), false);
  a.equal(node.pid(), process.pid);
  a.equal(node.platform(), process.platform);
  a.equal(node.node_version(), process.version);
  a.equal(node.uptime() >= 0, true);
  const root = node.make_temp_dir_$x_(path.join(os.tmpdir(), 'js-ffi-test-'));
  try {
    const dir = path.join(root, 'nested');
    a.equal(node.mkdir_$x_(dir), undefined);
    const file = path.join(dir, 'text.txt');
    a.equal(node.write_text_$x_(file, '你好\n'), undefined);
    a.equal(node.append_text_$x_(file, '🌍\n'), undefined);
    a.equal(node.read_text_$x_(file), '你好\n🌍\n');
    a.equal(node.real_path_$x_(file), fs.realpathSync(file));
    const copy = path.join(dir, 'copy');
    const renamed = path.join(dir, 'renamed');
    a.equal(node.copy_file_$x_(file, copy), undefined);
    a.equal(node.rename_$x_(copy, renamed), undefined);
    a.equal(node.file_exists_$q_(copy), false);
    a.equal(node.read_text_$x_(renamed), '你好\n🌍\n');
    a.throws(() => node.rmdir_$x_(dir), /ENOTEMPTY|EEXIST/);
    a.equal(node.unlink_$x_(file), undefined);
    a.equal(node.unlink_$x_(renamed), undefined);
    a.equal(node.rmdir_$x_(dir), undefined);
    a.throws(() => node.read_text_$x_(file), /ENOENT/);
    a.throws(() => node.unlink_$x_(file), /ENOENT/);
  } finally {
    fs.rmSync(root, { recursive: true, force: true });
  }
  // Verify a wrong host result cannot escape with a concrete String schema.
  const read = fs.readFileSync;
  try {
    fs.readFileSync = () => 42;
    syncBuiltinESMExports();
    a.throws(() => node.read_text_$x_('fixture'), /JS FFI contract violation: fs.readFileSync expected String, got number/);
  } finally {
    fs.readFileSync = read;
    syncBuiltinESMExports();
  }
  console.log(`Node: ${a.count} assertions`);
});

test('node-version reports the actual host member on invalid data', () => {
  const a = assertions();
  const descriptor = Object.getOwnPropertyDescriptor(process, 'version');
  try {
    Object.defineProperty(process, 'version', { ...descriptor, value: 42 });
    a.throws(() => node.node_version(), /JS FFI contract violation: process\.version expected String, got number/);
  } finally {
    Object.defineProperty(process, 'version', descriptor);
  }
});
