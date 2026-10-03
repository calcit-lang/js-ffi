import assert from "node:assert/strict";
import { spawnSync } from "node:child_process";
import { mkdirSync, mkdtempSync, rmSync, symlinkSync, utimesSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";

import {
  argv_count,
  cwd,
  env_get,
  env_or,
  file_mtime_ms_$x_,
  file_size_$x_,
  is_directory_$q_,
  read_dir_$x_,
  read_stdin_text_$x_,
  stderr_write_$x_,
  stdout_write_$x_,
} from "./js-out/js-ffi.node.mjs";
import { base64_decode, base64_encode, random_uuid } from "./js-out/js-ffi.shared.mjs";
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
  assert.throws(() => env_get("CALCIT_CONTRACT_TEST"), /process\.env\[CALCIT_CONTRACT_TEST\] expected String, got number/);
  assert.throws(() => env_or("CALCIT_CONTRACT_TEST", "fallback"), /process\.env\[CALCIT_CONTRACT_TEST\] expected String, got number/);

} finally {
  process.cwd = originalCwd;
  process.argv = originalArgv;
  process.env = originalEnv;
}

// Filesystem adapters run against a real temporary directory.
const sandbox = mkdtempSync(join(tmpdir(), "js-ffi-node-contract-"));
try {
  const file = join(sandbox, "note.txt");
  writeFileSync(file, "héllo");
  mkdirSync(join(sandbox, "sub"));
  writeFileSync(join(sandbox, "sub", "inner.txt"), "x");
  utimesSync(file, new Date(1_700_000_000_000), new Date(1_700_000_000_000));

  assert.deepEqual(read_dir_$x_(sandbox).toArray().sort(), ["note.txt", "sub"]);
  assert.deepEqual(read_dir_$x_(join(sandbox, "sub")).toArray(), ["inner.txt"]);
  assert.throws(() => read_dir_$x_(join(sandbox, "missing")), /ENOENT/);
  assert.throws(() => read_dir_$x_(file), /ENOTDIR/);

  assert.equal(is_directory_$q_(sandbox), true);
  assert.equal(is_directory_$q_(file), false);
  assert.equal(is_directory_$q_(join(sandbox, "missing")), false);
  const loop = join(sandbox, "loop");
  symlinkSync(loop, loop);
  assert.throws(() => is_directory_$q_(loop), /ELOOP/);
  assert.equal(is_directory_$q_(join(file, "child")), false); // a file used as a directory prefix counts as missing

  assert.equal(file_size_$x_(file), Buffer.byteLength("héllo"));
  assert.throws(() => file_size_$x_(join(sandbox, "missing")), /ENOENT/);
  assert.equal(file_mtime_ms_$x_(file), 1_700_000_000_000);
  assert.throws(() => file_mtime_ms_$x_(join(sandbox, "missing")), /ENOENT/);
} finally {
  rmSync(sandbox, { recursive: true, force: true });
}

// Stream writers add no newline and normalize the host result to Unit.
const originalStdoutWrite = process.stdout.write;
const originalStderrWrite = process.stderr.write;
const written = [];
try {
  process.stdout.write = chunk => { written.push(["out", chunk]); return true; };
  process.stderr.write = chunk => { written.push(["err", chunk]); return false; };
  assert.equal(stdout_write_$x_("a"), undefined);
  assert.equal(stderr_write_$x_("b\n"), undefined);
} finally {
  process.stdout.write = originalStdoutWrite;
  process.stderr.write = originalStderrWrite;
}
assert.deepEqual(written, [["out", "a"], ["err", "b\n"]]);
process.stdout.write = () => { throw new Error("stream closed"); };
try {
  assert.throws(() => stdout_write_$x_("x"), /stream closed/);
} finally {
  process.stdout.write = originalStdoutWrite;
}

// Standard input is read synchronously as UTF-8 in a child process fed through a pipe.
const stdinProbe = `import { read_stdin_text_$x_ } from ${JSON.stringify(new URL("./js-out/js-ffi.node.mjs", import.meta.url).href)};
process.stdout.write(JSON.stringify(read_stdin_text_$x_()));`;
const piped = spawnSync(process.execPath, ["--input-type=module", "-e", stdinProbe], { input: "line one\nzażółć\n", encoding: "utf8" });
assert.equal(piped.status, 0, piped.stderr);
assert.equal(JSON.parse(piped.stdout), "line one\nzażółć\n");
assert.equal(typeof read_stdin_text_$x_, "function");

// Shared helpers: UUIDs are fresh v4 strings; Base64 round-trips UTF-8 and rejects invalid input.
const uuidPattern = /^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/;
const first = random_uuid();
assert.match(first, uuidPattern);
assert.notEqual(first, random_uuid());
const originalCrypto = Object.getOwnPropertyDescriptor(globalThis, "crypto");
try {
  Object.defineProperty(globalThis, "crypto", { configurable: true, value: { randomUUID: () => 7 } });
  assert.throws(() => random_uuid(), /crypto\.randomUUID expected String, got number/);
} finally {
  if (originalCrypto) Object.defineProperty(globalThis, "crypto", originalCrypto);
  else Reflect.deleteProperty(globalThis, "crypto");
}
assert.equal(base64_encode(""), "");
assert.equal(base64_encode("hello"), "aGVsbG8=");
assert.equal(base64_encode("héllo wörld ✓ 😀"), Buffer.from("héllo wörld ✓ 😀", "utf8").toString("base64"));
assert.equal(base64_decode("aGVsbG8="), "hello");
assert.equal(base64_decode(base64_encode("日本語 ✓ 😀")), "日本語 ✓ 😀");
const big = "ab😀".repeat(50_000);
assert.equal(base64_decode(base64_encode(big)), big);
assert.throws(() => base64_decode("***not base64***"), /./);
assert.throws(() => base64_decode("a"), /./);
assert.throws(() => base64_decode(Buffer.from([0xff, 0xfe, 0xfd]).toString("base64")), /./);

console.log("js-ffi-node-contract-passed");
