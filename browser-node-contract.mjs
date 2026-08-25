import assert from "node:assert/strict";

import { document_available_$q_ } from "./js-out/js-ffi.browser.mjs";

assert.equal(document_available_$q_(), false);
console.log("js-ffi-browser-node-contract-passed");
