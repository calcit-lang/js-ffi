# js-ffi

Typed JavaScript FFI definitions for Calcit. This package is independent: it exists to make the boundary between Calcit and host
JavaScript explicit, checkable, and reusable across Calcit projects.

## 0.2.0 模块内 inline 与文件实现

此版本要求 Calcit `0.22.0`。`js-ffi.browser/document-available?` 的实现位于模块根目录的 `js-ffi-assets/document-available.js`，仍带有 `Fn [] -> Bool` schema 与 `:js-ffi` 标记。`js-ffi.node/path-basename` 则使用模块内 inline JS 表达式和显式 `node:path` 注入，保持原有 `Fn(String) -> String` 契约。Calcit 把两种表达式嵌入各自的生成命名空间；下游继续通过普通 Calcit `:require` 调用，不需要单独引用 JS 文件或安装片段专用 npm 包。

文件修改后请显式重新运行 Calcit JS 构建，不把外部文件的 watch 事件视为稳定契约。验证命令为 `yarn test:contract:browser-node`；Respo 的 `yarn test-dom-host` 另行检查从已安装模块跨仓库调用的行为。发布与兼容性以 `deps.cirru` 中的精确版本和 GitHub release tag 为准。

## Node 路径适配器

`js-ffi.node/path-join` 保持 `Fn(String, String) -> String` 公共契约，内部改由模块根目录的 `js-ffi-assets/path-join.js` 提供单个函数表达式，并通过 `:modules` 显式注入 Node 内置 `node:path`。使用者仍以普通 Calcit `:require` 调用它；不需要在应用中引用该 JS 文件或另装片段包。`examples/text-file.cirru` 的文件读写示例实际使用这个适配器，`yarn test:node` 检查路径结果、宿主参数异常和完整文件读写。

`js-ffi.node/path-basename` 使用同一个 `node:path` 模块的 inline 表达式，返回值仍由精确 `Fn(String) -> String` 声明约束；`js-ffi.node-test/path-label` 在 Calcit 代码中通过正常引用组合 inline 与 file 两个适配器。查看声明、来源和外部模块时分别运行 `calcit query def js-ffi.node/path-basename` 与 `calcit query context js-ffi.node/path-join --format edn`。这些查询不会执行 JavaScript；运行时参数/异常仍须由 `yarn test:node` 验证。

Calcit [#1372](https://github.com/calcit-lang/calcit/pull/1372) 修复了同一 Snapshot 中 Node/browser entry 的异宿主构建隔离。本版本使用从 crates.io 干净安装的 Calcit `0.22.0` 和 npm 公开包验证。修改 JS 文件后显式重新构建；排错时用 `calcit query context js-ffi.node/path-join --format edn` 找到模块版本、来源文件和外部模块，再用 Node source map 定位原始行。

## Design

`0.2.1-alpha.2` 为 Canvas2D 增加 Calcit 类型化文字绘制、宽度测量及字体/对齐字段；
独立模块消费者示例见 [`examples/canvas-text.cirru`](examples/canvas-text.cirru)。该版本不含
Quamolit Scene 逻辑，也不发布 npm；安装前请以 Git tag 与
[发布说明](docs/releases/0.2.1-alpha.2.md) 核对。

`0.2.1-alpha.2` adds typed Canvas2D text drawing, width measurement, and font/alignment fields.
The independent Calcit consumer is [`examples/canvas-text.cirru`](examples/canvas-text.cirru).
It does not include Quamolit Scene logic or an npm publication; verify the Git tag and
[release notes](docs/releases/0.2.1-alpha.2.md) before installing.

`0.2.1-alpha.1` 增加 Calcit 类型化 Canvas2D 原生路径描边：`moveTo/lineTo/closePath/stroke` 与描边样式、宽度、线帽、连接字段。无需额外 JS wrapper；见 [原生路径契约与检验](docs/canvas-rect-batches.md) 和 `examples/canvas-path.cirru`。下游须等对应 tag 发布后再安装；已发布的 `0.2.0` 不包含这些接口。发布检验见 [alpha 发布说明](docs/releases/0.2.1-alpha.1.md)。

`0.2.1-alpha.1` adds typed native Canvas2D path/stroke members in Calcit, without a JavaScript wrapper. Wait for the corresponding tag before installing. See the [contract and validation](docs/canvas-rect-batches.md) and [release checklist](docs/releases/0.2.1-alpha.1.md); these additions are not part of `0.2.0`.

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
- `js-ffi.canvas-batches` 保留 Calcit 类型化 Canvas2D 原生宿主方法、文字绘制/测量和单矩形变换/裁剪组合；Quamolit 的 Float32 批量绘制已迁出。见 [Canvas2D 接口与迁移](docs/canvas-rect-batches.md)。未发布的能力请以对应 PR/版本为准，不要从本地 main 推断已发布 tag。
- 0.2.0-alpha.1 移除了实验性 `js-ffi.canvas-scene` 整场景命令解释器；已发布的 0.1.x tag 不改写。See [Canvas scene migration](docs/canvas-scene-commands.md).
- `js-ffi.webgpu-capabilities` 公开带封闭结果分支和显式设备所有权的 Calcit WebGPU 探测；`webgpu-capabilities.mjs` 仅为内部宿主实现。See [WebGPU capability probe](docs/webgpu-capabilities.md).
- 0.2.0-alpha.2 移除了 Quamolit 专属的矩形批次 Calcit 类型与封送辅助；新项目使用 `js-ffi.webgpu` 的原生能力，Quamolit 使用自有类型。See [WebGPU migration](docs/webgpu-rect-batches.md).
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
It also records 65 reviewed `unsafe-coerce` sites per
definition. These assertions are expected only inside small host adapters; a
new assertion or moving one into another definition fails the quality gate and
requires an explicit review. Run `yarn audit:unsafe` to inspect their runtime
contract evidence.

The remaining assertions stay at reviewed Calcit/JS platform boundaries,
including Float32 snapshots and the typed WebGPU capability probe. The
public API checks every definition and Node/Chromium exercise compiled
wrappers. Two assertions in `probe-device!` type this package's named async
probe import and narrow its validated `ready` host result; the public return
remains a closed Calcit enum rather than a nullable catch-all object.

本地命令要求 `PATH` 中的 Calcit 与 `deps.cirru` 声明的 `0.22.0` 一致，并安装 Node.js 24 和 Yarn。CI 也使用同一精确版本：

```bash
yarn install
caps --strict --ci
caps verify --toolchain
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
