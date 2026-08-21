import assert from "node:assert/strict";

import { cwd } from "./js-out/js-ffi.node.mjs";

const originalCwd = process.cwd;

try {
  process.cwd = () => 42;

  assert.throws(
    () => cwd(),
    /JS FFI contract violation: process\.cwd expected String, got number/,
  );

  process.cwd = () => null;

  assert.throws(
    () => cwd(),
    /JS FFI contract violation: process\.cwd expected String, got nullish/,
  );

  console.log("js-ffi-node-contract-passed");
} finally {
  process.cwd = originalCwd;
}
