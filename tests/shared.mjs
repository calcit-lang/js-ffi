import * as shared from '../js-out/js-ffi.shared.mjs';
import { option_$o_none_$q_ as isNone, option_$o_unwrap as unwrap } from '../js-out/calcit.core.mjs';

export function assertions() {
  let count = 0;
  return {
    equal(actual, expected, label = '') {
      count++;
      if (!Object.is(actual, expected)) throw new Error(`${label}: expected ${String(expected)}, got ${String(actual)}`);
    },
    throws(fn, pattern) {
      count++;
      try { fn(); } catch (error) {
        if (pattern.test(String(error))) return;
        throw error;
      }
      throw new Error(`Expected exception matching ${pattern}`);
    },
    get count() { return count; },
  };
}

export async function testShared(a) {
  const url = shared.url_create('../路径?q=a%20b#part', 'https://example.com/base/index');
  a.equal(url.href, 'https://example.com/%E8%B7%AF%E5%BE%84?q=a%20b#part');
  a.throws(() => shared.url_create('/', 'invalid base'), /TypeError/);
  const params = shared.search_params_create('?a=1&a=2&empty=');
  a.equal(shared.search_params_size(params), 3);
  a.equal(unwrap(shared.search_params_get(params, 'a')), '1');
  a.equal(unwrap(shared.search_params_get(params, 'empty')), '');
  a.equal(isNone(shared.search_params_get(params, 'missing')), true);
  a.equal(shared.search_params_has_$q_(params, 'a'), true);
  a.equal(shared.search_params_set_$x_(params, 'a', '中文 +&'), undefined);
  a.equal(shared.search_params_size(params), 2);
  a.equal(unwrap(shared.search_params_get(params, 'a')), '中文 +&');
  a.equal(shared.search_params_string(params), 'a=%E4%B8%AD%E6%96%87+%2B%26&empty=');
  a.equal(shared.search_params_delete_$x_(params, 'a'), undefined);
  a.equal(shared.search_params_has_$q_(params, 'a'), false);
  const headers = shared.headers_create();
  a.equal(isNone(shared.headers_get(headers, 'missing')), true);
  a.equal(shared.headers_set_$x_(headers, 'X-Test', ' one '), undefined);
  a.equal(shared.headers_append_$x_(headers, 'x-test', 'two'), undefined);
  a.equal(unwrap(shared.headers_get(headers, 'X-TEST')), 'one, two');
  a.equal(shared.headers_has_$q_(headers, 'x-test'), true);
  a.equal(shared.headers_delete_$x_(headers, 'X-Test'), undefined);
  a.equal(shared.headers_has_$q_(headers, 'x-test'), false);
  a.throws(() => shared.headers_set_$x_(headers, 'bad header', 'x'), /TypeError/);
  const controller = shared.abort_controller_create();
  const signal = shared.abort_signal(controller);
  a.equal(signal, controller.signal);
  a.equal(shared.aborted_$q_(signal), false);
  a.equal(shared.abort_$x_(controller), undefined);
  a.equal(shared.aborted_$q_(signal), true);
  a.equal(shared.abort_$x_(controller), undefined);
  const input = '中文 /?=+&';
  const encoded = shared.encode_uri_component(input);
  a.equal(encoded, '%E4%B8%AD%E6%96%87%20%2F%3F%3D%2B%26');
  a.equal(shared.decode_uri_component(encoded), input);
  a.throws(() => shared.decode_uri_component('%E0%A4'), /URIError/);
  const before = Date.now();
  const now = shared.now_ms();
  a.equal(now >= before && now <= Date.now(), true);
  a.equal(shared.performance_now() >= 0, true);
  let flushed = false;
  a.equal(shared.queue_microtask_$x_(() => { flushed = true; }), undefined);
  a.equal(flushed, false);
  await Promise.resolve();
  a.equal(flushed, true);
}
