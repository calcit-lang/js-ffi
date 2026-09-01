---
title: "Typed JavaScript host boundary"
summary: "Choose browser, Node, and shared adapters while decoding JavaScript values into typed Calcit data at one explicit boundary"
scope: "module"
kind: "guide"
category: "ffi"
aliases:
  - "js ffi"
  - "JavaScript interop"
  - "browser host"
  - "Node host"
  - "external object trait"
  - "JS FFI contract violation"
  - "JavaScript 边界"
entry_for:
  - "js-ffi.shared"
  - "js-ffi.browser"
  - "js-ffi.node"
  - "js-ffi.contract"
---

# Typed JavaScript host boundary

`js-ffi` keeps JavaScript capabilities at a narrow, typed boundary. Application updaters, Recollect projections, and Respo render functions should consume Calcit-owned values rather than reading host globals directly.

## Pick one runtime surface

- `js-ffi.shared` provides normalized values and small host contracts available to both JavaScript targets.
- `js-ffi.browser` owns DOM, storage, viewport, browser events, and browser timers.
- `js-ffi.node` owns process, filesystem, environment, and path capabilities.
- `js-ffi.contract` validates opaque host values before an adapter promises a concrete Calcit type.

Do not import browser and Node namespaces into each other. Put cross-runtime data in `shared`, and keep target-specific effects in the corresponding adapter layer.

## Decode before returning typed data

External-object traits describe the smallest stable capability required from a host object. They preserve host identity without making arbitrary JavaScript objects structurally typed. Public adapters should then copy stable data into Struct, Enum, `Option<T>`, `Result<T, E>`, or another concrete Calcit value.

```cirru.no-check
ns app.main $ :require
  js-ffi.contract :as contract
  js-ffi.node :as node

def current-directory $ fn ()
  ; node/cwd validates the opaque process.cwd result before returning String.
  node/cwd
```

Use `contract/expect-string`, `expect-number`, `expect-bool`, `expect-object`, `expect-function`, and `object-field` when adding a new adapter. A failed contract reports `JS FFI contract violation` at the boundary instead of allowing an incorrectly typed value into business code.

Keep `JsNullish<T>` on external trait members whose JavaScript contract permits
`null` or `undefined`. Normalize it immediately with `js-nullish->option`, or
decode it through an `expect-*` guard when absence is itself a contract error.
Do not translate a host nullish value into Calcit `nil`, and do not let opaque
`JsObject` values flow into application state.

Any function containing a host operation or `unsafe-coerce` must declare
`:features $ #{} :js-ffi`. The quality baseline records every reviewed
assertion per definition, while runtime contract tests cover both accepted and
rejected host shapes.

## Realtime application placement

Browser event listeners, timers, storage, and network callbacks are asynchronous inputs. Decode them into typed operations or messages, dispatch them through the application's bounded event path, and let the serial updater own state transitions. Keep listener identity so teardown can remove the exact callback that was registered.

On the Node side, treat process and filesystem access as system capabilities. Convert failures and nullable results before they cross into persistent state or protocol messages. JavaScript callbacks are not durable state and must not bypass revision, acknowledgement, or resynchronization rules.

## Validation layers

Static schemas prove the Calcit-facing API. Node and browser smoke tests prove that real host objects still satisfy the declared contracts. Run both: a concrete return schema cannot by itself prove the runtime shape of a JavaScript global.
