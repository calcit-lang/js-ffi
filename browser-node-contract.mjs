import assert from "node:assert/strict";

import { _$n__$M_ as calcitMap } from "@calcit/procs";
import {
  child_element_at,
  document_append_body_$x_,
  document_available_$q_,
  element_host,
  local_storage_available_$q_,
  storage_get,
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
const hostElement = { localName: "div" };
assert.equal(element_host(hostElement), hostElement);

// Denied or missing localStorage reports unavailable storage instead of throwing.
const originalLocalStorage = Object.getOwnPropertyDescriptor(globalThis, "localStorage");
const originalWindow = Object.getOwnPropertyDescriptor(globalThis, "window");
try {
  Object.defineProperty(globalThis, "window", { configurable: true, value: globalThis });
  Object.defineProperty(globalThis, "localStorage", {
    configurable: true,
    get() {
      throw new DOMException("Access is denied for this document.", "SecurityError");
    },
  });
  assert.equal(local_storage_available_$q_(), false);
  assert.equal(option_$o_none_$q_(storage_get("missing")), true);
  Reflect.deleteProperty(globalThis, "localStorage");
  assert.equal(local_storage_available_$q_(), false);
  assert.equal(option_$o_none_$q_(storage_get("missing")), true);
} finally {
  if (originalLocalStorage) Object.defineProperty(globalThis, "localStorage", originalLocalStorage);
  else Reflect.deleteProperty(globalThis, "localStorage");
  if (originalWindow) Object.defineProperty(globalThis, "window", originalWindow);
  else Reflect.deleteProperty(globalThis, "window");
}

console.log("js-ffi-browser-node-contract-passed");
