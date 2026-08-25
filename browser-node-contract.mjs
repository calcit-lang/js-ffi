import assert from "node:assert/strict";

import { document_available_$q_ } from "./js-out/js-ffi.browser.mjs";

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
} finally {
  if (originalDocument === undefined) {
    Reflect.deleteProperty(globalThis, "document");
  } else {
    Object.defineProperty(globalThis, "document", originalDocument);
  }
}

console.log("js-ffi-browser-node-contract-passed");
