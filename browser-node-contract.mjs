import assert from "node:assert/strict";

import { _$n__$M_ as calcitMap } from "@calcit/procs";
import {
  child_element_at,
  document_append_body_$x_,
  document_available_$q_,
  element_host,
  event_host,
  event_target_element,
  host_kind_$q_,
  element_bounding_rect,
  element_checked_$q_,
  element_class_add_$x_,
  element_class_remove_$x_,
  element_class_toggle_$x_,
  element_has_class_$q_,
  element_scroll_into_view_$x_,
  element_set_checked_$x_,
  element_value,
  event_target_value,
  keyboard_event_host,
  local_storage_available_$q_,
  media_matches_$q_,
  session_storage_get,
  session_storage_set_$x_,
  storage_get,
  window_local_storage,
} from "./js-out/js-ffi.browser.mjs";
import {
  option_$o_none_$q_,
  option_$o_some_$q_,
  option_$o_unwrap,
} from "./js-out/calcit.core.mjs";

const originalDocument = Object.getOwnPropertyDescriptor(globalThis, "document");

try {
  assert.notEqual(originalDocument?.configurable, false);
  Reflect.deleteProperty(globalThis, "document");
  assert.equal(document_available_$q_(), false);

  Object.defineProperty(globalThis, "document", {
    configurable: true,
    value: {},
  });
  assert.equal(document_available_$q_(), true);
  assert.throws(() => document_append_body_$x_({}), /document\.body expected Object, got nullish/);

  const child = { localName: "span" };
  const children = {
    length: 1,
    item(index) {
      return index === 0 ? child : null;
    },
  };
  const found = child_element_at(children, 0);
  assert.equal(option_$o_some_$q_(found), true);
  assert.equal(option_$o_unwrap(found), child);
  assert.equal(option_$o_none_$q_(child_element_at(children, 1)), true);
} finally {
  if (originalDocument === undefined) {
    Reflect.deleteProperty(globalThis, "document");
  } else {
    Object.defineProperty(globalThis, "document", originalDocument);
  }
}

const originalNavigator = Object.getOwnPropertyDescriptor(globalThis, "navigator");
try {
  assert.notEqual(originalNavigator?.configurable, false);
  Reflect.deleteProperty(globalThis, "navigator");
  const webgpu = await import("./js-out/js-ffi.webgpu.mjs");
  assert.equal(option_$o_none_$q_(webgpu.gpu()), true);
} finally {
  if (originalNavigator) Object.defineProperty(globalThis, "navigator", originalNavigator);
  else Reflect.deleteProperty(globalThis, "navigator");
}

// A Calcit runtime value is a JavaScript object but never a host capability.
assert.throws(() => element_host(calcitMap("a", 1)), /DOM\.element-host expected host Object, got Calcit value :map/);
const hostElement = { nodeType: 1, tagName: "DIV", localName: "div" };
assert.equal(element_host(hostElement), hostElement);

// Host adapters check the documented shape of the expected host kind, not only typeof.
const textNode = { nodeType: 3, data: "text" };
const clickEvent = { type: "click", preventDefault() {}, target: hostElement };
const keyEvent = { type: "keydown", key: "Enter", preventDefault() {}, target: textNode };
assert.equal(host_kind_$q_("element", hostElement), true);
assert.equal(host_kind_$q_("element", textNode), false);
assert.equal(host_kind_$q_("event", clickEvent), true);
assert.equal(host_kind_$q_("keyboard-event", clickEvent), false);
assert.equal(host_kind_$q_("unknown-kind", hostElement), false);
assert.throws(() => element_host(textNode), /DOM\.element-host expected element host/);
assert.equal(event_host(clickEvent), clickEvent);
assert.throws(() => event_host(hostElement), /DOM\.event-host expected event host/);
assert.equal(keyboard_event_host(keyEvent), keyEvent);
assert.throws(() => keyboard_event_host(clickEvent), /DOM\.keyboard-event-host expected keyboard-event host/);

// Only element targets become Some; text nodes and missing targets are none.
assert.equal(option_$o_unwrap(event_target_element(clickEvent)), hostElement);
assert.equal(option_$o_none_$q_(event_target_element(keyEvent)), true);
assert.equal(option_$o_none_$q_(event_target_element({ type: "load", preventDefault() {}, target: null })), true);

// Denied or missing localStorage reports unavailable storage instead of throwing.
const originalLocalStorage = Object.getOwnPropertyDescriptor(globalThis, "localStorage");
const originalWindow = Object.getOwnPropertyDescriptor(globalThis, "window");
try {
  Object.defineProperty(globalThis, "window", { configurable: true, value: globalThis });
  const storageHost = {
    length: 0,
    getItem() { return "stored"; },
    key() { return null; },
    setItem() {},
    removeItem() {},
    clear() {},
  };
  Object.defineProperty(globalThis, "localStorage", { configurable: true, value: storageHost });
  assert.equal(window_local_storage(), storageHost);
  assert.equal(option_$o_unwrap(storage_get("key")), "stored");
  Object.defineProperty(globalThis, "localStorage", { configurable: true, value: {} });
  assert.throws(() => window_local_storage(), TypeError);
  assert.equal(option_$o_none_$q_(storage_get("key")), true);
  Object.defineProperty(globalThis, "localStorage", {
    configurable: true,
    get() {
      throw new DOMException("Access is denied for this document.", "SecurityError");
    },
  });
  assert.equal(local_storage_available_$q_(), false);
  assert.equal(option_$o_none_$q_(storage_get("missing")), true);
  Object.defineProperty(globalThis, "localStorage", {
    configurable: true,
    value: {
      ...storageHost,
      getItem() {
        throw new DOMException("Storage read failed.", "SecurityError");
      },
    },
  });
  assert.equal(option_$o_none_$q_(storage_get("blocked")), true);
  Reflect.deleteProperty(globalThis, "localStorage");
  assert.equal(local_storage_available_$q_(), false);
  assert.equal(option_$o_none_$q_(storage_get("missing")), true);
} finally {
  if (originalLocalStorage) Object.defineProperty(globalThis, "localStorage", originalLocalStorage);
  else Reflect.deleteProperty(globalThis, "localStorage");
  if (originalWindow) Object.defineProperty(globalThis, "window", originalWindow);
  else Reflect.deleteProperty(globalThis, "window");
}

// Class-list, geometry, scroll and form-state adapters read documented host fields only.
const tokenSet = new Set();
const classElement = {
  nodeType: 1,
  tagName: "DIV",
  classList: {
    add(name) { if (name === "" || /\s/.test(name)) throw new DOMException("bad token", "SyntaxError"); tokenSet.add(name); },
    remove(name) { tokenSet.delete(name); },
    toggle(name) { if (tokenSet.has(name)) { tokenSet.delete(name); return false; } tokenSet.add(name); return true; },
    contains(name) { return tokenSet.has(name); },
  },
};
assert.equal(element_class_add_$x_(classElement, "active"), undefined);
assert.equal(element_has_class_$q_(classElement, "active"), true);
assert.equal(element_has_class_$q_(classElement, "other"), false);
assert.equal(element_class_toggle_$x_(classElement, "other"), true);
assert.equal(element_class_toggle_$x_(classElement, "other"), false);
assert.equal(element_class_remove_$x_(classElement, "active"), undefined);
assert.equal(element_has_class_$q_(classElement, "active"), false);
assert.throws(() => element_class_add_$x_(classElement, "has space"), /bad token/);
assert.throws(() => element_class_add_$x_({ classList: null }, "x"), /element\.classList expected Object, got nullish/);
assert.throws(() => element_has_class_$q_({ classList: { contains: () => 1 } }, "x"), /element\.classList\.contains expected Bool, got number/);
assert.throws(() => element_class_toggle_$x_({ classList: { toggle: () => "yes" } }, "x"), /element\.classList\.toggle expected Bool, got string/);

const rect = element_bounding_rect({ getBoundingClientRect: () => ({ x: 1, y: 2, width: 30, height: 40 }) });
assert.deepEqual(["x", "y", "width", "height"].map(key => rect.get(key)), [1, 2, 30, 40]);
assert.throws(() => element_bounding_rect({ getBoundingClientRect: () => ({ x: "1", y: 2, width: 3, height: 4 }) }), /rect\.x expected Number, got string/);
assert.throws(() => element_bounding_rect({ getBoundingClientRect: () => null }), /expected Object, got nullish/);

let scrolled = 0;
assert.equal(element_scroll_into_view_$x_({ scrollIntoView(...args) { assert.equal(args.length, 0); scrolled += 1; } }), undefined);
assert.equal(scrolled, 1);

const field = { value: "typed", checked: false };
assert.equal(element_value(field), "typed");
assert.throws(() => element_value({ value: 42 }), /element\.value expected String, got number/);
assert.throws(() => element_value({}), /element\.value expected String, got nullish/);
assert.equal(element_checked_$q_(field), false);
assert.equal(element_set_checked_$x_(field, true), undefined);
assert.equal(field.checked, true);
assert.equal(element_checked_$q_(field), true);
assert.throws(() => element_checked_$q_({ checked: "true" }), /element\.checked expected Bool, got string/);

// event-target-value never throws for a null target and ignores non-String values.
assert.equal(option_$o_unwrap(event_target_value({ type: "input", target: { value: "abc" } })), "abc");
assert.equal(option_$o_unwrap(event_target_value({ type: "input", target: { value: "" } })), "");
assert.equal(option_$o_none_$q_(event_target_value({ type: "input", target: null })), true);
assert.equal(option_$o_none_$q_(event_target_value({ type: "input" })), true);
assert.equal(option_$o_none_$q_(event_target_value({ type: "input", target: { value: 3 } })), true);
assert.equal(option_$o_none_$q_(event_target_value({ type: "input", target: {} })), true);

// matchMedia is optional; absence or a null list is false and a non-Bool matches is rejected.
const originalMatchMedia = Object.getOwnPropertyDescriptor(globalThis, "matchMedia");
const savedWindow = Object.getOwnPropertyDescriptor(globalThis, "window");
try {
  Reflect.deleteProperty(globalThis, "window");
  assert.equal(media_matches_$q_("(min-width: 1px)"), false);
  Object.defineProperty(globalThis, "window", { configurable: true, value: globalThis });
  Reflect.deleteProperty(globalThis, "matchMedia");
  assert.equal(media_matches_$q_("(min-width: 1px)"), false);
  const queries = [];
  Object.defineProperty(globalThis, "matchMedia", { configurable: true, writable: true, value(query) { queries.push(query); return { matches: query.includes("dark") }; } });
  assert.equal(media_matches_$q_("(prefers-color-scheme: dark)"), true);
  assert.equal(media_matches_$q_("(prefers-color-scheme: light)"), false);
  assert.deepEqual(queries, ["(prefers-color-scheme: dark)", "(prefers-color-scheme: light)"]);
  globalThis.matchMedia = () => null;
  assert.equal(media_matches_$q_("x"), false);
  globalThis.matchMedia = () => ({ matches: "yes" });
  assert.throws(() => media_matches_$q_("x"), /matchMedia\.matches expected Bool, got string/);
} finally {
  if (originalMatchMedia) Object.defineProperty(globalThis, "matchMedia", originalMatchMedia);
  else Reflect.deleteProperty(globalThis, "matchMedia");
  if (savedWindow) Object.defineProperty(globalThis, "window", savedWindow);
  else Reflect.deleteProperty(globalThis, "window");
}

// sessionStorage mirrors localStorage: denied or missing storage reads as none and writes are skipped.
const originalSessionStorage = Object.getOwnPropertyDescriptor(globalThis, "sessionStorage");
try {
  Reflect.deleteProperty(globalThis, "sessionStorage");
  assert.equal(option_$o_none_$q_(session_storage_get("missing")), true);
  assert.equal(session_storage_set_$x_("k", "v"), undefined);
  Object.defineProperty(globalThis, "sessionStorage", {
    configurable: true,
    get() { throw new DOMException("Access is denied for this document.", "SecurityError"); },
  });
  assert.equal(option_$o_none_$q_(session_storage_get("blocked")), true);
  assert.equal(session_storage_set_$x_("k", "v"), undefined);
  const backing = new Map();
  Object.defineProperty(globalThis, "sessionStorage", {
    configurable: true,
    value: {
      getItem: key => (backing.has(key) ? backing.get(key) : null),
      setItem: (key, value) => { backing.set(key, value); },
    },
  });
  assert.equal(option_$o_none_$q_(session_storage_get("absent")), true);
  backing.set("null", "null");
  assert.equal(option_$o_unwrap(session_storage_get("null")), "null");
  assert.equal(session_storage_set_$x_("draft", "text"), undefined);
  assert.equal(option_$o_unwrap(session_storage_get("draft")), "text");
  session_storage_set_$x_("empty", "");
  assert.equal(option_$o_unwrap(session_storage_get("empty")), "");
  Object.defineProperty(globalThis, "sessionStorage", { configurable: true, value: { getItem() { throw new DOMException("Storage read failed.", "SecurityError"); } } });
  assert.equal(option_$o_none_$q_(session_storage_get("blocked")), true);
  Object.defineProperty(globalThis, "sessionStorage", { configurable: true, value: { getItem: () => 42 } });
  assert.throws(() => session_storage_get("number"), /sessionStorage\.getItem expected String, got number/);
  Object.defineProperty(globalThis, "sessionStorage", { configurable: true, value: { setItem() { throw new DOMException("quota", "QuotaExceededError"); } } });
  assert.throws(() => session_storage_set_$x_("k", "v"), /quota/);
} finally {
  if (originalSessionStorage) Object.defineProperty(globalThis, "sessionStorage", originalSessionStorage);
  else Reflect.deleteProperty(globalThis, "sessionStorage");
}

console.log("js-ffi-browser-node-contract-passed");
