import { test } from 'node:test';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { createServer } from 'node:http';
import { syncBuiltinESMExports } from 'node:module';
import * as node from '../js-out/js-ffi.node.mjs';
import * as shared from '../js-out/js-ffi.shared.mjs';
import { result_$o_err_$q_ as isErr, result_$o_ok_$q_ as isOk } from '../js-out/calcit.core.mjs';
import { assertions, testShared } from './shared.mjs';

const structField = (value, name) => value.values[value.fields.findIndex(field => field.value === name)];

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

test('checked async fetch, Response body and filesystem adapters', async () => {
  const a = assertions();
  const unhandled = [];
  const onUnhandled = reason => unhandled.push(reason);
  process.on('unhandledRejection', onUnhandled);
  const server = createServer((_request, response) => {
    response.writeHead(200, { 'content-type': 'text/plain; charset=utf-8' });
    response.end('本地响应\n');
  });
  try {
    await new Promise(resolve => server.listen(0, '127.0.0.1', resolve));
    const address = server.address();
    const url = `http://127.0.0.1:${address.port}/body`;
    try {
      const fetched = await shared.fetch_response(url);
      a.equal(isOk(fetched), true);
      const response = fetched.extra[0];
      const body = await shared.response_text(response);
      a.equal(isOk(body), true);
      a.equal(body.extra[0], '本地响应\n');
      const consumed = await shared.response_text(response);
      a.equal(isErr(consumed), true);

      const syncThrow = await shared.response_text({ text() { throw new Error('sync body failure'); } });
      a.equal(isErr(syncThrow), true);
      const rejected = await shared.response_text({ text() { return Promise.reject(new Error('async body failure')); } });
      a.equal(isErr(rejected), true);

      a.throws(() => shared.response_host({ text() {} }), /Response\.headers expected Object, got nullish/);
      a.throws(() => shared.response_host({
        status: 200,
        statusText: 'OK',
        ok: true,
        url,
        redirected: false,
        bodyUsed: false,
        text() {},
        headers: {},
      }), /Response\.headers\.get expected Function, got nullish/);

      const fallback = shared.normalize_error({});
      a.equal(structField(fallback, 'name'), 'Error');
      a.equal(structField(fallback, 'message'), '[object Object]');
      const partial = shared.normalize_error({ name: 'CustomError', message: null });
      a.equal(structField(partial, 'name'), 'CustomError');
      a.equal(structField(partial, 'message'), '[object Object]');

      const root = node.make_temp_dir_$x_(path.join(os.tmpdir(), 'js-ffi-async-'));
      try {
        const file = path.join(root, 'text.txt');
        a.equal(isOk(await node.write_text_async_$x_(file, '异步文件\n')), true);
        const read = await node.read_text_async_$x_(file);
        a.equal(isOk(read), true);
        a.equal(read.extra[0], '异步文件\n');
        a.equal(isErr(await node.read_text_async_$x_(path.join(root, 'missing.txt'))), true);
      } finally {
        fs.rmSync(root, { recursive: true, force: true });
      }
    } finally {
      await new Promise((resolve, reject) => server.close(error => error ? reject(error) : resolve()));
    }
    a.equal(isErr(await shared.fetch_response(url)), true);
    await new Promise(resolve => setImmediate(resolve));
    a.equal(unhandled.length, 0);
    console.log(`Async Node: ${a.count} assertions`);
  } finally {
    process.off('unhandledRejection', onUnhandled);
  }
});
