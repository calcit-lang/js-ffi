import { query_string } from '../js-out/js-ffi.query-example.mjs';
import { listen } from '../js-out/js-ffi.listen-example.mjs';
import * as browser from '../js-out/js-ffi.browser.mjs';
import { option_$o_none_$q_ as isNone, option_$o_unwrap as unwrap } from '../js-out/calcit.core.mjs';
import { assertions, testShared } from './shared.mjs';

/** Exercise shared and browser adapters in a real page and return the test summary. */
export async function run() {
  const a = assertions();
  await testShared(a);
  a.equal(query_string('中文 +&'), 'page=1&q=%E4%B8%AD%E6%96%87+%2B%26');
  let recipeEvents = 0;
  const cleanup = listen('js-ffi-recipe', () => { recipeEvents++; });
  try { window.dispatchEvent(new Event('js-ffi-recipe')); }
  finally { a.equal(cleanup(), undefined); }
  window.dispatchEvent(new Event('js-ffi-recipe'));
  a.equal(recipeEvents, 1);
  a.equal(cleanup(), undefined);
  a.equal(browser.document_available_$q_(), true);
  const parent = browser.create_element('section');
  const input = browser.create_element('input');
  document.body.appendChild(parent);
  try {
    a.equal(browser.append_child_$x_(parent, input), input);
    a.equal(browser.element_set_attribute_$x_(input, 'data-test', '你好'), undefined);
    a.equal(unwrap(browser.element_get_attribute(input, 'data-test')), '你好');
    a.equal(isNone(browser.element_get_attribute(input, 'missing')), true);
    a.equal(browser.element_matches_$q_(input, 'input[data-test]'), true);
    a.equal(unwrap(browser.element_query_selector(parent, 'input')), input);
    a.equal(isNone(browser.element_query_selector(parent, '.missing')), true);
    a.throws(() => browser.element_query_selector(parent, '['), /SyntaxError/);
    a.equal(browser.element_remove_attribute_$x_(input, 'data-test'), undefined);
    a.equal(isNone(browser.element_get_attribute(input, 'data-test')), true);
    a.equal(browser.element_focus_$x_(input), undefined);
    a.equal(document.activeElement, input);
    a.equal(browser.element_blur_$x_(input), undefined);
    a.equal(document.activeElement === input, false);
    a.equal(unwrap(browser.child_element_at(parent.children, 0)), input);
    a.equal(isNone(browser.child_element_at(parent.children, 1)), true);
    a.equal(browser.element_dataset(input), input.dataset);
    a.equal(browser.element_style(input), input.style);
  } finally {
    parent.remove();
  }
  const key = `js-ffi-test-${crypto.randomUUID()}`;
  try {
    a.equal(isNone(browser.storage_get(key)), true);
    a.equal(browser.storage_set_$x_(key, '中文'), undefined);
    a.equal(unwrap(browser.storage_get(key)), '中文');
    a.equal(browser.storage_remove_$x_(key), undefined);
    a.equal(browser.storage_get_or(key, 'fallback'), 'fallback');
  } finally { localStorage.removeItem(key); }

  let events = 0;
  const listener = () => { events++; };
  browser.add_event_listener_$x_('js-ffi-test', listener);
  try { window.dispatchEvent(new Event('js-ffi-test')); }
  finally { browser.remove_event_listener_$x_('js-ffi-test', listener); }
  window.dispatchEvent(new Event('js-ffi-test'));
  a.equal(events, 1);

  let fired = 0;
  const timeout = browser.set_timeout_$x_(() => { fired++; }, 0);
  const interval = browser.set_interval_$x_(() => { fired++; }, 1);
  const frame = browser.request_animation_frame_$x_(() => { fired++; });
  a.equal(typeof timeout, 'number');
  a.equal(typeof interval, 'number');
  a.equal(typeof frame, 'number');
  a.equal(browser.clear_timeout_$x_(timeout), undefined);
  a.equal(browser.clear_interval_$x_(interval), undefined);
  a.equal(browser.cancel_animation_frame_$x_(frame), undefined);
  await new Promise(resolve => setTimeout(resolve, 50));
  a.equal(fired, 0);
  await new Promise(resolve => browser.set_timeout_$x_(() => { resolve(); }, 0));
  await new Promise(resolve => browser.request_animation_frame_$x_(timestamp => {
    a.equal(typeof timestamp, 'number');
    resolve();
  }));
  return { passed: true, assertions: a.count, runtime: navigator.userAgent };
}
