# js-ffi

Typed JavaScript FFI definitions for Calcit. This package is independent: it exists to make the boundary between Calcit and host
JavaScript explicit, checkable, and reusable across Calcit projects.

## Design

The public API is split by runtime:

- `js-ffi.shared` contains runtime enums, normalized error/URL/date/HTTP data,
  cross-runtime console helpers, and small external-object contracts for Date,
  URL, URLSearchParams, AbortController, Headers, and Response.
- `js-ffi.browser` contains DOM, URL, storage, viewport, console, timer, and
  browser-global helpers.
- `js-ffi.node` contains `process`, filesystem, and path helpers.
- `js-ffi.webgpu` contains browser-only adapter/device requests, device loss,
  validation scopes, and buffer lifecycle APIs. See [WebGPU foundation](docs/webgpu.md).
- `js-ffi.contract` contains runtime-independent checks and boundary decoders
  shared by smoke tests and host adapters.
- `js-ffi.typed-arrays` 是跨 Node/浏览器的 Calcit Float32 快照 API：登记时复制、校验有限数值、只读索引和按范围再复制；`typed-arrays.mjs` 只做内部宿主实现。See [Float32 snapshots](docs/typed-arrays.md).
- `js-ffi.canvas-batches` 保留 Calcit 类型化 Canvas2D 原生宿主方法及单矩形变换/裁剪组合；Quamolit 的 Float32 批量绘制已迁出。See [Canvas2D migration](docs/canvas-rect-batches.md).
- 0.2.0-alpha.1 移除了实验性 `js-ffi.canvas-scene` 整场景命令解释器；已发布的 0.1.x tag 不改写。See [Canvas scene migration](docs/canvas-scene-commands.md).
- `js-ffi.webgpu-capabilities` 公开带封闭结果分支和显式设备所有权的 Calcit WebGPU 探测；`webgpu-capabilities.mjs` 仅为内部宿主实现。See [WebGPU capability probe](docs/webgpu-capabilities.md).
- `js-ffi.webgpu-batches` 暂保留 Calcit 类型、封送和诊断辅助；矩形 renderer 的 WGSL、资源和创建实现已迁往 Quamolit。新项目使用 `js-ffi.webgpu` 的原生能力。See [WebGPU migration](docs/webgpu-rect-batches.md).
- [平台 API 归属清单](docs/platform-api-inventory.md) 列出每个 JS 实现为何仍保留、Calcit 公共入口、失败/释放语义及下一步迁移边界。

Browser and Node namespaces should not be imported into each other; both may
depend on `js-ffi.shared`. A project
can therefore choose the `browser` or `node` Calcit entry without silently
pulling in the wrong host API. Stable host objects use explicit, non-generic
external-object traits. Public adapters normalize them to Struct, Enum,
`Option<T>`, `Result<T, E>`, or `Unit`; unmodeled values remain `JsObject`.

The package has no runtime npm dependencies. `@calcit/procs` is only the
Calcit compiler/runtime support package, and Vite is a development tool for
the browser smoke page. The Calcit and package versions are recorded in
`deps.cirru` and `package.json`.

See [Typed JavaScript host boundary](docs/typed-host-boundary.md) for the
runtime split, decoding policy, and guidance for keeping host effects outside
pure application logic. The page is indexed for `calcit docs read` and
`calcit docs search` when this module is installed.

See [Standard host adapters](docs/standard-host-adapters.md) for 133 additional
URL, fetch/Response, Node HTTP client/server, query string, headers,
cancellation, DOM, timer, process, path and UTF-8 filesystem adapters with
signatures and error semantics. The
[checked async migration](docs/checked-async-adapters.md) shows the required
`js-await` boundary and `Result` handling.

## Find APIs and runnable examples

- `yarn api:generate` builds the complete API catalog in `.calcit/api/`
  (`api.md` and `api.json`); these reproducible files are not committed.
- [Executable Calcit recipes](docs/recipes.md) demonstrate URL query encoding,
  UTF-8 file access, and browser event cleanup.
- Search by runtime with `yarn api:search storage browser`.
- `yarn check:api` uses Calcit's target-aware public checker to preprocess every
  public definition without executing host effects; `yarn api:check`
  validates catalog generation and checks the committed recipe guide for drift.

See [API tooling](docs/api-tooling.md) for the editing workflow and upstream
Calcit requests. After API changes, run `yarn api:generate` before `yarn test`.

## Method-style host access

Every host capability is an external-object trait, so adapters that return one
can be used with JavaScript-like method and field syntax. Trait methods compile
to the mapped native calls (`:ffi :names`), and fields compile to property reads.
Writable fields are assigned through `js-set` inside a `:js-ffi` adapter.

```cirru
; Method call on a DocumentHost capability.
let
    document $ browser/document-host
  document .query-selector |.app

; Read a trait field; normalize nullish values when a concrete type is needed.
let
    element $ browser/query-selector |.app
  element :text-content

; Writable fields (inner-html, text-content, class-name, hidden) via js-set.
defn relabel! (element text)
  js-set element :text-content text
  , &unit

; WebSocketHost methods.
let
    socket $ browser/web-socket-create |ws://127.0.0.1:1/
  do (socket .close!) &unit
```

Typed free helpers (`storage-get`, `query-selector`, `fetch-request`, ...) decode
host values into Calcit `Option`/`Result` at the boundary, while method calls
stay closer to the host and may return `JsNullish` or trait values. Use method
style for direct host operations and the typed helpers when you want normalized
Calcit data.

## API examples

Node.js code can use typed helpers without touching raw JavaScript globals:

```cirru
; String

node/cwd

; Number

node/argv-count

; String with fallback

node/env-or |NODE_ENV |dev

; String

node/path-join |src |index.js

; Bool

node/file-exists? |package.json

; shared/Runtime :node

node/runtime
```

Browser code can guard capabilities and keep nullable host results out of the
rest of the application:

```cirru
when browser/document-available? $ browser/console-log! (browser/document-title)

; String

browser/storage-get-or |theme |light

; Number

browser/viewport-width

; browser/Viewport

browser/viewport

; Option<String>

browser/storage-get |theme

; browser/DocumentReadyState

browser/document-ready-state

browser/set-timeout!
  fn () $ browser/console-log! |ready
  10

; browser/DomElementHost

browser/create-element |section

browser/document-append-body! element

browser/element-first-child element

browser/element-clone element true

browser/element-set-style! element |opacity |0.5

browser/element-select! $ browser/selectable-element-host input

browser/element-dispatch-event! element event

browser/event-stop-propagation! event

browser/element-remove! element

browser/add-event-listener! |resize on-resize

browser/remove-event-listener! |resize on-resize

browser/set-before-unload! $ fn (event) (persist!)

shared/queue-microtask! $ fn () (flush-render!)
```

The listener passed to `remove-event-listener!` must be the same function
value registered by `add-event-listener!`. `create-element` intentionally
returns the small `DomElementHost` contract; a renderer that needs a richer
element contract should narrow it once at its own adapter boundary rather than
expanding the shared browser host type. Text selection is intentionally exposed
through `DomSelectableHost`, which covers selectable input and textarea nodes.

Shared adapters and normalized data work in either JavaScript target:

```cirru
; Unit

shared/console-log! |ready

; shared/DateSnapshot

shared/date-now-snapshot

; DateHost -> String

shared/date-local-string $ shared/date-from-ms 0

; String

shared/runtime-label $ %:: shared/Runtime :browser
```

Host identity can be retained only when needed through contracts such as
`shared/DateHost`, `shared/UrlHost`, `browser/DocumentHost`,
`browser/StorageHost`, and `browser/DomElementHost`. These contracts describe
small member sets and JavaScript name mappings; they do not introduce a second
trait solver or TypeScript-style structural types.

The Node adapter applies the same rule to `process.argv`: `ProcessArgvHost`
exposes only its opaque/nullish `length`, so `node/argv-count` can read a declared
member and then validate it with `contract/expect-number` instead of performing
a literal access on a bare `JsObject` or trusting an unchecked numeric value.

Every public adapter in `calcit.cirru` has a schema and a runtime feature marker
where its own body crosses the JavaScript boundary. Inline Calcit examples are
kept for target-independent helpers; examples that require a live browser or
Node host are exercised by the corresponding smoke runs. Struct fields, Enum
payloads, and external trait members carry concrete types. Data-definition
CodeEntry schemas use Calcit’s explicit `StructDef`, `EnumDef`, `Trait`, or
`Impl` marker, so definition roots do not inflate Dynamic-type hygiene counts.

At an untrusted host-value boundary, an adapter must decode the value before it
returns a concrete Calcit type. `contract/expect-string`,
`contract/expect-number`, `contract/expect-bool`, `contract/expect-object`,
`contract/expect-function`, and `contract/object-field` provide shallow
primitive and capability guards with a stable failure identity. For example, `node/cwd`
and `node/argv-count` decode the opaque host results before returning `String`
or `Number`; a mismatched host value fails with a `JS FFI contract violation`
instead of escaping as an incorrectly typed value. Object and function guards
only prove the immediate host kind: adapters must still validate required
members, receiver behavior, and copy stable data into Calcit-owned structures.
See the compiler's
[JavaScript interop guide](https://github.com/calcit-lang/calcit/blob/main/docs/features/js-interop.md)
for the decoder and capability policy.

## Checks and smoke runs

This module adopts the RFC quality levels through Q3: its CI validates the
Snapshot and zero-tolerance static quality, then runs Node and browser-host
contracts. Calcit is installed from `deps.cirru` with
[`calcit-lang/setup-calcit@v1`](https://github.com/calcit-lang/setup-calcit).
The static gate does not replace the host smoke tests below. CI also runs
real Chromium tests, synchronous filesystem tests, shared Web API tests,
and invalid-consumer type checks.

The checked-in v2 baseline keeps Dynamic, nil, and unresolved types at zero.
It also records 68 reviewed `unsafe-coerce` sites per
definition. These assertions are expected only inside small host adapters; a
new assertion or moving one into another definition fails the quality gate and
requires an explicit review. Run `yarn audit:unsafe` to inspect their runtime
contract evidence.

The two additional sites in `js-ffi.webgpu-batches` are confined to the
Calcit/JS boundary: one asserts this package's named async batch constructor,
the other asserts the browser's `Float32Array` constructor result. The public
API checks every definition and browser/Node host doubles exercise the typed
marshalling; a real WebGPU browser exercises the same Calcit entry points.
Six further assertions type this package's named Float32 snapshot and Canvas
batch functions at their Calcit-to-JavaScript import boundary. The host
implementations validate inputs, and Node/Chromium run the compiled wrappers.
Two further assertions in `probe-device!` type this package's named async
probe import and narrow its validated `ready` host result; the public return
remains a closed Calcit enum rather than a nullable catch-all object.

The commands assume the released Calcit 0.19.1 toolchain, Node.js 24 and Yarn
are available on `PATH`. CI installs the exact Calcit version declared in
`deps.cirru`:

```bash
yarn install
caps --ci
calcit calcit.cirru --check-only
yarn check:quality
yarn audit:unsafe
yarn check:node
yarn check:browser
yarn run:node
yarn test:contract:node
yarn build:browser
yarn playwright install chromium
yarn test
```

`yarn run:node` compiles the `node` entry and runs a real Node.js probe. It
checks `process.cwd()`, `process.argv`, and the runtime contract.

`yarn test:contract:node` replaces `process.cwd()` with an invalid JavaScript
value and verifies that the boundary decoder rejects it with the documented
contract error. This is intentionally separate from the smoke run: static
schemas alone cannot prove a host API continues to honour its runtime shape.

`yarn run:browser` starts Vite after compiling the `browser` entry. Open the
printed local URL and inspect the browser console for the runtime probe. The
browser probe checks `document` and performs a localStorage round trip.

`yarn test:node` runs the extended Node and shared tests. `yarn test:browser`
launches real Chromium and verifies shared APIs, DOM, storage, events, timers
and animation frames. `yarn test:types` verifies invalid consumers are rejected.

`yarn format` applies Calcit's canonical formatting to `calcit.cirru`.

Every function that performs a host operation or `unsafe-coerce` declares
`:features $ #{} :js-ffi`. `JsNullish<T>` stays at the host trait boundary and
is normalized with `js-nullish->option` or a checked `contract/expect-*`
decoder before ordinary application code sees a concrete value.

## Design RFC

The proposed type model, complete `:js-ffi` capability gate, isolated
capability validation, and compiler migration stages are documented in the
Calcit compiler repository's
[typed JavaScript FFI boundary RFC](https://github.com/calcit-lang/calcit/blob/main/RFCs/08-18-calcit-typed-js-ffi-boundary-rfc.md).
