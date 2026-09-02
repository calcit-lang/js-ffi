import assert from "node:assert/strict";

import {
  child_element_at,
  document_available_$q_,
  dom_element_host,
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

  const child = { localName: "span" };
  const children = {
    length: 1,
    item(index) {
      return index === 0 ? child : null;
    },
  };
  const element = {
    children,
    childElementCount: 1,
    innerHTML: "<span></span>",
    localName: "div",
  };

  assert.equal(dom_element_host(element), element);
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

console.log("js-ffi-browser-node-contract-passed");
