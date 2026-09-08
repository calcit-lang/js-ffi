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

Start with [executable recipes](recipes.md) or `yarn api:search`. Run
`yarn api:generate` to build `.calcit/api/api.md` and `.calcit/api/api.json`
locally. These full catalogs are reproducible caches, excluded by the existing
`.calcit/` ignore rule. The catalog includes every definition in the
five public namespaces: browser, WebGPU, node, shared and contract. Test namespaces are
excluded. New definitions in those namespaces are discovered automatically;
adding a new public namespace requires an explicit update to `publicNamespaces`
and its runtime policy in `scripts/api-lib.mjs`.

## Agent and human workflow

1. Search by task and runtime: `yarn api:search storage browser` or
   `yarn api:search read-text node`. The result is JSON with an import rule,
   full Calcit schema, documentation, runtime policy, host metadata and any
   associated recipes. Use `node scripts/api-catalog.mjs search storage browser`
   when a caller requires stdout to contain only JSON without package-manager
   output. Search builds a missing or stale cache automatically using local
   Calcit, then reuses it while the source fingerprint matches. A warm cache
   requires no Calcit invocation and no network access.
2. Inspect an exact definition using the record's `inspect` command, or use
   `calcit query context js-ffi.browser/storage-get --format json` for semantic
   context. Read exception behavior before using a host effect.
3. Copy a recipe's imports and definition, retaining its schema. Each `.cirru`
   recipe is a quoted definition accepted by `calcit edit def --file`; the JSON
   recipe manifest supplies the schema and imports. This is ordinary Calcit
   syntax, not a new FFI type language.
4. After editing definitions or recipes, run `yarn api:generate`,
   `yarn check:api`, and `yarn test`. Commit source changes and any changes to
   the short `docs/recipes.md` guide. This guide stays in Git for direct GitHub
   reading and is marked `text linguist-generated` in `.gitattributes`.
   CI's `yarn api:check` regenerates local catalogs and rejects a stale recipe
   guide; it does not compare or commit the full catalogs.

## What the checks prove

`yarn check:api` calls `calcit analyze check-public` separately for the Node and
browser entries. Node checks node/shared/contract; browser checks
browser/webgpu/shared/contract. The command discovers definitions directly, so
new public functions require no symbol list or synthetic reference root. It
checks 92 Node definitions and 137 browser definitions in the current snapshot,
including data definitions and external traits. Preprocessing validates bodies
that normal smoke entries never use, no host effects execute, and the snapshot
is not copied or rewritten.

Compile commands retain their separate temporary-root process because recipe
definitions and imports must still be added to the generated program. Runtime
tests therefore continue to exercise compiled recipes and the full public API
surface, while checking no longer depends on that generation path. Generated
modules remain in ignored `js-out/`. The tooling tests verify complete checked
IDs, target isolation, data declarations, and rejection of an invalid unused
definition without mutating the source snapshot.

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

## Upstream requests and remaining workarounds

- [Calcit #873](https://github.com/calcit-lang/calcit/issues/873) now enforces
  async invocation contracts before an unawaited result is treated as its
  logical type. `fetch-response`, `response-text`, `read-text-async!`, and
  `write-text-async!` consume that contract; see the
  [checked async migration](checked-async-adapters.md).
- [Calcit #874](https://github.com/calcit-lang/calcit/issues/874) provides the
  supported target-aware all-public-definition check. This migration uses the
  released [Calcit 0.14.5](https://github.com/calcit-lang/calcit/releases/tag/0.14.5)
  toolchain.
- [Calcit #875](https://github.com/calcit-lang/calcit/issues/875) provides the
  versioned `query def --format json` envelope consumed by the catalog. Its
  structured `data.ffi` field is lossless even for large host traits. Snapshot
  parsing remains only for persisted `schemaData`, which is not part of the
  definition-query contract.

The tooling requires Calcit's query.def envelope v1 and fails closed on another
schema version, command, definition ID, malformed JSON, or missing metadata.
The CLI EDN parser still takes Snapshot source text as a command argument for
`schemaData`; this exceeds the Windows command-line limit and requires WSL,
Linux or macOS until a file/stdin parser interface is available. Generation
fails on parser errors rather than emitting an incomplete catalog.
