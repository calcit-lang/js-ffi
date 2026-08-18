# js-ffi

Typed JavaScript FFI definitions for Calcit. This package is intentionally
small and independent: it exists to make the boundary between Calcit and host
JavaScript explicit, checkable, and reusable across Calcit projects.

## Design

The public API is split by runtime:

- `js-ffi.shared` contains runtime enums, normalized error/URL/date/HTTP data,
  cross-runtime console helpers, and small external-object contracts for Date,
  URL, URLSearchParams, AbortController, Headers, and Response.
- `js-ffi.browser` contains DOM, URL, storage, viewport, console, timer, and
  browser-global helpers.
- `js-ffi.node` contains `process`, filesystem, and path helpers.
- `js-ffi.contract` contains runtime-independent checks shared by smoke tests.

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

## API examples

Node.js code can use typed helpers without touching raw JavaScript globals:

```cirru.no-check
(node/cwd)                       ; String
(node/argv-count)                ; Number
(node/env-or |NODE_ENV |dev)     ; String with fallback
(node/path-join |src |index.js)  ; String
(node/file-exists? |package.json); Bool
(node/runtime)                    ; shared/Runtime :node
```

Browser code can guard capabilities and keep nullable host results out of the
rest of the application:

```cirru.no-check
(when (browser/document-available?)
  (browser/console-log! (browser/document-title)))
(browser/storage-get-or |theme |light) ; String
(browser/viewport-width)               ; Number
(browser/viewport)                     ; browser/Viewport
(browser/storage-get |theme)           ; Option<String>
(browser/document-ready-state)         ; browser/DocumentReadyState
(browser/set-timeout! (fn [] (browser/console-log! |ready)) 10)
(browser/create-element |section)      ; browser/DomElementHost
(browser/add-event-listener! |resize on-resize)
(browser/remove-event-listener! |resize on-resize)
(browser/set-before-unload! (fn (event) (persist!)))
(shared/queue-microtask! (fn [] (flush-render!)))
```

The listener passed to `remove-event-listener!` must be the same function
value registered by `add-event-listener!`. `create-element` intentionally
returns the small `DomElementHost` contract; a renderer that needs a richer
element contract should narrow it once at its own adapter boundary rather than
expanding the shared browser host type.

Shared adapters and normalized data work in either JavaScript target:

```cirru.no-check
(shared/console-log! |ready)       ; Unit
(shared/date-now-snapshot)         ; shared/DateSnapshot
(shared/runtime-label
  (%:: shared/Runtime :browser))   ; String
```

Host identity can be retained only when needed through contracts such as
`shared/DateHost`, `shared/UrlHost`, `browser/DocumentHost`,
`browser/StorageHost`, and `browser/DomElementHost`. These contracts describe
small member sets and JavaScript name mappings; they do not introduce a second
trait solver or TypeScript-style structural types.

Every public adapter in `calcit.cirru` has a schema and a runtime feature marker
where its own body crosses the JavaScript boundary. Inline Calcit examples are
kept for target-independent helpers; examples that require a live browser or
Node host are exercised by the corresponding smoke runs. Struct fields, Enum
payloads, and external trait members carry concrete types. Data-definition
CodeEntry schemas remain unset for compatibility with current Calcit JS codegen;
this does not erase their field/member definitions.

## Checks and smoke runs

The commands assume `cr` and Yarn are available on `PATH`:

```bash
yarn install
yarn check
yarn check:node
yarn check:browser
yarn run:node
yarn build:browser
```

`yarn run:node` compiles the `node` entry and runs a real Node.js probe. It
checks `process.cwd()`, `process.argv`, and the runtime contract.

`yarn run:browser` starts Vite after compiling the `browser` entry. Open the
printed local URL and inspect the browser console for the runtime probe. The
browser probe checks `document` and performs a localStorage round trip.

`yarn format` applies Calcit's canonical formatting to `calcit.cirru`.

## Design RFC

The proposed type model, complete `:js-ffi` capability gate, isolated
capability validation, and compiler migration stages are documented in the
Calcit compiler repository's
[typed JavaScript FFI boundary RFC](https://github.com/calcit-lang/calcit/blob/main/RFCs/08-18-calcit-typed-js-ffi-boundary-rfc.md).
