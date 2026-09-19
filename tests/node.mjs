import { test } from 'node:test';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { createServer } from 'node:http';
import { syncBuiltinESMExports } from 'node:module';
import * as node from '../js-out/js-ffi.node.mjs';
import * as shared from '../js-out/js-ffi.shared.mjs';
import { result_$o_err_$q_ as isErr, result_$o_ok_$q_ as isOk, option_$o_unwrap as unwrap, option_$o_none_$q_ as isNone, option_$o_some_$q_ as isSome, _PCT_some, _PCT_none } from '../js-out/calcit.core.mjs';
import * as procs from '@calcit/procs';
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

test('shared fetch-request sends method, headers and optional body', async () => {
  const a = assertions();
  const tags = procs.init_tags(['get', 'post', 'put', 'patch', 'delete', 'head', 'options']);
  const postMethod = procs._PCT__$o__$o_(shared.HttpMethod, tags.post);
  const server = createServer((request, response) => {
    let body = '';
    request.on('data', chunk => { body += chunk; });
    request.on('end', () => {
      response.writeHead(200, { 'content-type': 'text/plain; charset=utf-8' });
      response.end(`${request.method}:${request.headers['x-test'] || ''}:${body}`);
    });
  });
  try {
    await new Promise(resolve => server.listen(0, '127.0.0.1', resolve));
    const url = `http://127.0.0.1:${server.address().port}/echo`;
    const headers = shared.headers_create();
    a.equal(shared.headers_set_$x_(headers, 'X-Test', 'yes'), undefined);
    const withBody = await shared.fetch_request(url, postMethod, headers, _PCT_some('payload'));
    a.equal(isOk(withBody), true);
    const body = await shared.response_text(withBody.extra[0]);
    a.equal(isOk(body), true);
    a.equal(body.extra[0], 'POST:yes:payload');
    const withoutBody = await shared.fetch_request(url, postMethod, headers, _PCT_none());
    a.equal(isOk(withoutBody), true);
    const empty = await shared.response_text(withoutBody.extra[0]);
    a.equal(empty.extra[0], 'POST:yes:');
    console.log(`Fetch request: ${a.count} assertions`);
  } finally {
    await new Promise(resolve => server.close(resolve));
  }
});

test('Node HTTP client helpers', async () => {
  const a = assertions();
  const server = node.http_create_server((request, response) => {
    response.setHeader('X-Test', 'ok');
    response.end('client-body');
  });
  await new Promise((resolve) => node.server_listen_$x_(server, 0, '127.0.0.1', () => resolve()));
  try {
    const port = server.address().port;
    const result = await new Promise((resolve) => {
      node.http_get_$x_(`http://127.0.0.1:${port}/`, (response) => {
        const header = node.response_header(response, 'x-test');
        node.response_body_text(response, (text) => resolve({ text, header }));
      });
    });
    a.equal(result.text, 'client-body');
    a.equal(isSome(result.header), true);
    a.equal(unwrap(result.header), 'ok');
  } finally {
    node.server_close_$x_(server);
  }
  a.equal(isNone(node.response_header({ headers: {} }, 'missing')), true);
  console.log(`Node http client: ${a.count} assertions`);
});

test('Node HTTP server, request header and timers', async () => {
  const a = assertions();
  const server = node.http_create_server((request, response) => {
    response.setHeader('X-Test', 'yes');
    response.end('hello-http');
  });
  await new Promise((resolve, reject) => {
    try {
      node.server_listen_$x_(server, 0, '127.0.0.1', () => resolve());
    } catch (error) { reject(error); }
  });
  try {
    const port = server.address().port;
    const response = await fetch(`http://127.0.0.1:${port}/`);
    a.equal(await response.text(), 'hello-http');
    a.equal(response.headers.get('x-test'), 'yes');
  } finally {
    node.server_close_$x_(server);
  }
  const echoServer = node.http_create_server((request, response) => {
    node.request_body_text(request, _PCT_some((text) => response.end(`echo:${text}`)));
  });
  await new Promise((resolve) => node.server_listen_$x_(echoServer, 0, '127.0.0.1', () => resolve()));
  const echoPort = echoServer.address().port;
  const posted = await fetch(`http://127.0.0.1:${echoPort}/`, { method: 'POST', body: 'payload' });
  a.equal(await posted.text(), 'echo:payload');
  node.server_close_$x_(echoServer);
  const headerValue = node.request_header({ headers: { 'content-type': 'text/plain' } }, 'content-type');
  a.equal(isSome(headerValue), true);
  a.equal(unwrap(headerValue), 'text/plain');
  a.equal(isNone(node.request_header({ headers: {} }, 'missing')), true);
  await new Promise(resolve => node.set_timeout_$x_(() => resolve(), 5));
  a.equal(shared.console_clear_$x_(), undefined);
  console.log(`Node http: ${a.count} assertions`);
});

test('shared promise? detects real promises and rejects plain values', () => {
  const a = assertions();
  a.equal(shared.promise_$q_(Promise.resolve(1)), true);
  a.equal(shared.promise_$q_(new Promise(() => {})), true);
  a.equal(shared.promise_$q_(42), false);
  a.equal(shared.promise_$q_('text'), false);
  a.equal(shared.promise_$q_(null), false);
  a.equal(shared.promise_$q_({}), false);
  a.equal(shared.promise_$q_({ then: () => {} }), false);
  console.log(`Promise predicate: ${a.count} assertions`);
});

test('shared response-json parses object bodies', async () => {
  const a = assertions();
  const server = createServer((_request, response) => {
    response.writeHead(200, { 'content-type': 'application/json' });
    response.end('{"ok":true,"n":1}');
  });
  try {
    await new Promise(resolve => server.listen(0, '127.0.0.1', resolve));
    const url = `http://127.0.0.1:${server.address().port}/json`;
    const fetched = await shared.fetch_response(url);
    a.equal(isOk(fetched), true);
    const parsed = await shared.response_json(fetched.extra[0]);
    a.equal(isOk(parsed), true);
    a.equal(parsed.extra[0].ok, true);
    a.equal(parsed.extra[0].n, 1);
    console.log(`Response json: ${a.count} assertions`);
  } finally {
    await new Promise(resolve => server.close(resolve));
  }
});

test('shared console-host exposes the host console for method calls', () => {
  const a = assertions();
  a.equal(shared.console_host(), console);
  console.log(`Console host: ${a.count} assertions`);
});

test('Node env-get reads optional process.env values', () => {
  const a = assertions();
  a.equal(isNone(node.env_get('JS_FFI_MISSING_KEY')), true);
  process.env.JS_FFI_TEST_KEY = '值';
  try {
    a.equal(unwrap(node.env_get('JS_FFI_TEST_KEY')), '值');
  } finally {
    delete process.env.JS_FFI_TEST_KEY;
  }
  console.log(`Node env: ${a.count} assertions`);
});

test('Node import.meta and Buffer adapters', () => {
  const a = assertions();
  a.equal(node.import_meta_url().includes('js-ffi.node.mjs'), true);
  const buffer = node.buffer_from_string('你好');
  a.equal(node.buffer__GT_string(buffer), '你好');
  console.log(`Node FFI basics: ${a.count} assertions`);
});
