# js-ffi

Typed JavaScript FFI definitions for Calcit. This package is intentionally
small and independent: it exists to make the boundary between Calcit and host
JavaScript explicit, checkable, and reusable across Calcit projects.

## Design

The public API is split by runtime:

- `js-ffi.browser` contains DOM, URL, storage, viewport, console, timer, and
  browser-global helpers.
- `js-ffi.node` contains `process`, filesystem, and path helpers.
- `js-ffi.contract` contains runtime-independent checks shared by smoke tests.

Browser and Node namespaces should not be imported into each other. A project
can therefore choose the `browser` or `node` Calcit entry without silently
pulling in the wrong host API. Host objects are kept as internal `JsObject`
values; public helpers narrow values to `String`, `Number`, or `Bool` and use a
fallback where JavaScript can return `null` or `undefined`.

The package has no runtime npm dependencies. `@calcit/procs` is only the
Calcit compiler/runtime support package, and Vite is a development tool for
the browser smoke page. The Calcit and package versions are recorded in
`deps.cirru` and `package.json`.

## API examples

Node.js code can use typed helpers without touching raw JavaScript globals:

```cirru
(node/cwd)                       ; String
(node/argv-count)                ; Number
(node/env-or |NODE_ENV |dev)     ; String with fallback
(node/path-join |src |index.js)  ; String
(node/file-exists? |package.json); Bool
```

Browser code can guard capabilities and keep nullable host results out of the
rest of the application:

```cirru
(when (browser/document-available?)
  (browser/console-log! (browser/document-title)))
(browser/storage-get-or |theme |light) ; String
(browser/viewport-width)               ; Number
(browser/set-timeout! (fn [] (browser/console-log! |ready)) 10)
```

Every public definition in `calcit.cirru` has a schema, a runtime feature
marker where it crosses the JavaScript boundary, and a doc/example entry.
`Dynamic` is reserved for opaque host handles or effect return values such as
console, timer, storage mutation, and process exit.

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
