---
title: "Discover and validate the public API"
summary: "Search generated host API contracts and run all-definition checks plus executable Calcit recipes"
scope: "module"
kind: "guide"
category: "ffi"
aliases:
  - "API catalog"
  - "agent workflow"
  - "executable recipes"
---

# Discover and validate the public API

Start with [the API catalog](api.md), [machine-readable records](api.json), or
[executable recipes](recipes.md). The catalog includes every definition in the
four public namespaces: browser, node, shared and contract. Test namespaces are
excluded. New definitions in those namespaces are discovered automatically;
adding a new public namespace requires an explicit update to `publicNamespaces`
and its runtime policy in `scripts/api-lib.mjs`.

## Agent and human workflow

1. Search by task and runtime: `yarn api:search storage browser` or
   `yarn api:search read-text node`. The result is JSON with an import rule,
   full Calcit schema, documentation, runtime policy, host metadata and any
   associated recipes. Use `node scripts/api-catalog.mjs search storage browser`
   when a caller requires stdout to contain only JSON without package-manager
   output. Search reads the committed catalog and does not invoke Calcit.
2. Inspect an exact definition using the record's `inspect` command, or use
   `calcit query context js-ffi.browser/storage-get --format json` for semantic
   context. Read exception behavior before using a host effect.
3. Copy a recipe's imports and definition, retaining its schema. Each `.cirru`
   recipe is a quoted definition accepted by `calcit edit def --file`; the JSON
   recipe manifest supplies the schema and imports. This is ordinary Calcit
   syntax, not a new FFI type language.
4. After editing definitions or recipes, run `yarn api:generate`,
   `yarn check:api`, and `yarn test`. Commit the generated catalog with its
   source changes. CI's `yarn api:check` rejects stale generated files.

## What the checks prove

`yarn check:api` uses structured `analyze check-types` output to enumerate all
public definitions, including data definitions and external traits. It then
copies the snapshot and pinned deps into a temporary directory and uses
Calcit's edit/tree commands to inject a complete reference root. Node checks
node/shared/contract; browser checks browser/shared/contract. Preprocessing
validates the function bodies even when normal smoke entries never use them.
No host effects execute, and the original snapshot is not rewritten.

Both compile scripts use the same temporary-root process, so runtime tests
exercise compiled recipes and the full public API surface. Generated modules
remain in ignored `js-out/`. The checker intentionally fails when a namespace
contains an invalid unused definition; `tests/api-tooling.mjs` verifies this by
inserting a broken function into a separate test snapshot.

The catalog is an inventory of declarations. It does not certify arbitrary
JavaScript values, validate external services, or claim every API has an
executable recipe. A `recipes` link means the function is demonstrated by that
recipe; its `validation` link names the test that exercises the compiled
recipe. Existing host contract tests remain necessary.

The `schemaData` field preserves the CLI's tagged EDN representation, while
`schema` is readable Calcit syntax. `ffi` uses plain keys and tag values;
writable sets are sorted arrays for deterministic generation. Trait declarations
retain the complete field and method AST. JSON consumers should check
`schemaVersion` before relying on this representation.

## Current CLI workarounds and upstream requests

- [Calcit #873](https://github.com/calcit-lang/calcit/issues/873): enforce async
  invocation contracts before an unawaited result is treated as its logical type.
  Async networking is deferred here until the calling convention is reliable.
- [Calcit #874](https://github.com/calcit-lang/calcit/issues/874): provide a
  supported target-aware all-public-definition check. Temporary roots are the
  local workaround; no hand-maintained per-function list is retained.
- [Calcit #875](https://github.com/calcit-lang/calcit/issues/875): return complete
  machine-readable FFI metadata. On 0.13.77, even `query def --raw --json` may
  truncate the FFI display string. The generator takes full metadata from the
  snapshot via `calcit cirru parse-edn` instead of parsing that preview.

The tooling is pinned to the repository's Calcit 0.13.77 JSON conventions.
The CLI EDN parser currently takes source text as a command argument; very large
snapshots may eventually require a file/stdin-capable parser interface. Generation
fails on parser errors rather than emitting an incomplete catalog.
