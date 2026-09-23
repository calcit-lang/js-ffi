import * as shared from '../js-out/js-ffi.shared.mjs';
import { option_$o_none_$q_ as isNone, option_$o_unwrap as unwrap } from '../js-out/calcit.core.mjs';
import { snapshotFloat32, float32Length, float32ByteLength, float32At, float32CopyRange } from '../typed-arrays.mjs';

/** Create browser-compatible equality/exception assertions with a running count. */
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

/** Verify compiled shared adapters against native Web APIs in either runtime. */
export async function testShared(a) {
  const source = new Float32Array([1.25, -2.5, 3]);
  const snapshot = snapshotFloat32(source);
  source[0] = 99;
  a.equal(Object.isFrozen(snapshot), true);
  a.equal(float32Length(snapshot), 3);
  a.equal(float32ByteLength(snapshot), 12);
  a.equal(float32At(snapshot, 0), 1.25);
  a.equal(float32At(snapshot, 1), -2.5);
  const copied = float32CopyRange(snapshot, 1, 2);
  a.equal(copied instanceof Float32Array, true);
  a.equal(copied[0], -2.5);
  copied[0] = 99;
  a.equal(float32At(snapshot, 1), -2.5);
  a.equal(float32CopyRange(snapshot, 3, 0).length, 0);
  a.throws(() => snapshotFloat32([1, 2]), /Float32Array source required/);
  a.throws(() => snapshotFloat32(new Float32Array([Number.NaN])), /non-finite/);
  a.throws(() => snapshotFloat32(new Float32Array([Number.POSITIVE_INFINITY])), /non-finite/);
  a.throws(() => float32Length({}), /snapshot required/);
  a.throws(() => float32At(snapshot, 3), /safe integer/);
  a.throws(() => float32At(snapshot, 0.5), /safe integer/);
  a.throws(() => float32CopyRange(snapshot, 2, 2), /safe integer/);
  if (typeof SharedArrayBuffer !== 'undefined') {
    a.throws(() => snapshotFloat32(new Float32Array(new SharedArrayBuffer(4))), /not a stable snapshot/);
  }
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
  const epoch = shared.date_from_ms(0);
  a.equal(epoch.getTime(), 0);
  a.equal(shared.date_local_string(epoch), new Date(0).toLocaleString());
  a.throws(() => shared.date_from_ms(Number.NaN), /finite in-range timestamp/);
  a.throws(() => shared.date_from_ms(Number.POSITIVE_INFINITY), /finite in-range timestamp/);
  a.throws(() => shared.date_from_ms(8_640_000_000_000_001), /finite in-range timestamp/);
  a.equal(shared.performance_now() >= 0, true);
  let flushed = false;
  a.equal(shared.queue_microtask_$x_(() => { flushed = true; }), undefined);
  a.equal(flushed, false);
  await Promise.resolve();
  a.equal(flushed, true);

  const fulfilled = await new Promise((resolve, reject) => {
    a.equal(shared.promise_observe_$x_('ready', resolve, reject), undefined);
  });
  a.equal(fulfilled, 'ready');
  const rejected = await new Promise((resolve, reject) => {
    shared.promise_observe_$x_(Promise.reject('failed'), reject, resolve);
  });
  a.equal(rejected, 'failed');
  const callbackError = await new Promise((resolve, reject) => {
    shared.promise_observe_$x_('ready', () => { throw new Error('callback failed'); }, resolve);
  });
  a.equal(callbackError.message, 'callback failed');
}
