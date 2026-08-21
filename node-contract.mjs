import assert from "node:assert/strict";

import { argv_count, cwd, env_or } from "./js-out/js-ffi.node.mjs";
import {
  expect_bool,
  expect_function,
  expect_number,
  expect_object,
  expect_string,
  object_field,
} from "./js-out/js-ffi.contract.mjs";

const originalCwd = process.cwd;
const originalArgv = process.argv;
const originalEnv = process.env;

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

  assert.equal(expect_string("fixture.string", "ok"), "ok");
  assert.equal(expect_number("fixture.number", 42), 42);
  assert.equal(expect_bool("fixture.bool", true), true);
  assert.deepEqual(expect_object("fixture.object", { ready: true }), { ready: true });
  assert.equal(expect_function("fixture.function", () => null) instanceof Function, true);
  assert.equal(expect_number("fixture.object.count", object_field("fixture.object", { count: 2 }, "count")), 2);

  assert.throws(() => expect_number("fixture.number", "42"), /expected Number, got string/);
  assert.throws(() => expect_bool("fixture.bool", 1), /expected Bool, got number/);
  assert.throws(() => expect_object("fixture.object", null), /expected Object, got nullish/);
  assert.throws(() => expect_function("fixture.function", {}), /expected Function, got object/);
  assert.throws(() => expect_string("fixture.object.name", object_field("fixture.object", { name: null }, "name")), /expected String, got nullish/);

  process.argv = { length: "two" };
  assert.throws(() => argv_count(), /process\.argv\.length expected Number, got string/);

  process.env = { CALCIT_CONTRACT_TEST: 42 };
  assert.throws(() => env_or("CALCIT_CONTRACT_TEST", "fallback"), /process\.env\[CALCIT_CONTRACT_TEST\] expected String, got number/);

  console.log("js-ffi-node-contract-passed");
} finally {
  process.cwd = originalCwd;
  process.argv = originalArgv;
  process.env = originalEnv;
}
