---
title: "Typed JavaScript host boundary"
summary: "Choose browser, Node, and shared adapters while decoding JavaScript values into typed Calcit data at one explicit boundary"
scope: "module"
kind: "guide"
category: "features"
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

Browser adapters that turn an opaque value into a DOM external trait check its kind first. `browser/host-kind?` reports whether a value has the documented shape of an element, event, keyboard event, mouse event, pointer event, or selectable text control, and `browser/expect-host-kind` raises a contract violation otherwise. `element-host`, `event-host` and the other `*-host` adapters use it, so a text node, a plain object, or a Calcit value is rejected at the boundary instead of failing later inside a DOM method. `event-target-element` returns none when the event target is not an element.

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

Even small built-in objects should expose a named capability when a literal
member is used. For example, `ProcessArgvHost` declares only an opaque/nullish
`:length`; `node/argv-count` coerces `process.argv` to that trait inside its
adapter, reads the declared member, and validates it with `contract/expect-number`.

## Validation layers

### URLSearchParams 的受检转换

`shared/search-params-create` 构造原生 URLSearchParams 后，通过 `js-cast` 与现有 `UrlSearchParamsHost` 声明检查 `size` 字段是否存在、映射后的 `get/has/set/delete/forEach/toString` 是否可调用。成功返回同一宿主对象，字段检查不读取 getter，也不调用方法来探测能力。普通 Calcit 模块继续通过 `:require` 调用现有入口及方法，不增加 JS 包或新的转换 API。

原生构造器仍负责 URLSearchParams 的具体值语义，抛出的异常原样传播；`search-params-get` 继续把 nullish 结果归一化为 Option。受检转换会提早拒绝不完整的构造结果，但不验证任意替代构造器的字段值、方法签名或返回值。方法 getter 失败时，错误保留原始 cause。声明的 `:js-ffi` 边界没有变成 native/WASM 的执行支持。

用 `calcit test js-ffi.shared/search-params-create --require-match` 验证附带的类型/方法合同；用 `yarn test:node` 与 `yarn test:browser` 执行真实宿主和已有 query-string recipe，核对冻结对象身份、this、单次构造、非法成员和错误。附带测试检查函数合同，不执行 native 中不可用的 JavaScript 构造器；实际执行证据由 Node/Chromium 提供。

Static schemas prove the Calcit-facing API. Node and browser smoke tests prove that real host objects still satisfy the declared contracts. Run both: a concrete return schema cannot by itself prove the runtime shape of a JavaScript global.
