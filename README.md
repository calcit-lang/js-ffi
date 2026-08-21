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
- `js-ffi.contract` contains runtime-independent checks and boundary decoders
  shared by smoke tests and host adapters.

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

browser/add-event-listener! |resize on-resize

browser/remove-event-listener! |resize on-resize

browser/set-before-unload! $ fn (event) (persist!)

shared/queue-microtask! $ fn () (flush-render!)
```

The listener passed to `remove-event-listener!` must be the same function
value registered by `add-event-listener!`. `create-element` intentionally
returns the small `DomElementHost` contract; a renderer that needs a richer
element contract should narrow it once at its own adapter boundary rather than
expanding the shared browser host type.

Shared adapters and normalized data work in either JavaScript target:

```cirru
; Unit

shared/console-log! |ready

; shared/DateSnapshot

shared/date-now-snapshot

; String

shared/runtime-label $ %:: shared/Runtime :browser
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
CodeEntry schemas use Calcit’s explicit `StructDef`, `EnumDef`, `Trait`, or
`Impl` marker, so definition roots do not inflate Dynamic-type hygiene counts.

At an untrusted host-value boundary, an adapter must decode the value before it
returns a concrete Calcit type. `contract/expect-string`, `expect-number`,
`expect-bool`, `expect-object`, `expect-function`, and `object-field` provide shallow primitive
and capability guards with a stable failure identity. For example, `node/cwd`
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
The static gate does not replace the host smoke tests below.

The commands assume `cr` and Yarn are available on `PATH`:

```bash
yarn install
caps --ci
cr calcit.cirru --check-only
cr calcit.cirru analyze quality --baseline config/calcit-quality.json --format json
yarn check:node
yarn check:browser
yarn run:node
yarn test:contract:node
yarn build:browser
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

`yarn format` applies Calcit's canonical formatting to `calcit.cirru`.

## Design RFC

The proposed type model, complete `:js-ffi` capability gate, isolated
capability validation, and compiler migration stages are documented in the
Calcit compiler repository's
[typed JavaScript FFI boundary RFC](https://github.com/calcit-lang/calcit/blob/main/RFCs/08-18-calcit-typed-js-ffi-boundary-rfc.md).
