# Public API catalog

Generated from Calcit definitions by `yarn api:generate`. Do not edit directly.

149 public definitions, including host traits and data types. Search without running Calcit: `yarn api:search storage browser`. Machine-readable source: [api.json](api.json).

Runtime availability follows the four public namespaces. Schemas and host metadata are declarations, not proof of arbitrary host values. Recipe links show demonstrated use, not exhaustive API coverage. Exception and lifecycle details: [adapter reference](standard-host-adapters.md).

## js-ffi.browser

### BrowserProbe

Typed browser smoke result replacing the former heterogeneous Map<Dynamic>.

Runtime: browser. Kind: struct.

```text
'Enum
```

Inspect: `calcit query def js-ffi.browser/BrowserProbe --raw --json`

### DocumentHost

External Document capability with typed state, title, and small selector/creation surface.

Runtime: browser. Kind: trait.

```text
'Trait
```

Inspect: `calcit query def js-ffi.browser/DocumentHost --raw --json`

### DocumentReadyState

Typed document.readyState values with an unknown String variant for forward compatibility.

Runtime: browser. Kind: enum.

```text
'Enum
```

Inspect: `calcit query def js-ffi.browser/DocumentReadyState --raw --json`

### DomChildrenHost

External DOM children collection with typed length and nullable indexed element lookup.

Runtime: browser. Kind: trait.

```text
'Trait
```

Inspect: `calcit query def js-ffi.browser/DomChildrenHost --raw --json`

### DomElementHost

External DOM Element capability with stable fields, selector methods, attributes, and focus effects.

Runtime: browser. Kind: trait.

```text
'Trait
```

Inspect: `calcit query def js-ffi.browser/DomElementHost --raw --json`

### DomInputHost

External HTML input capability. Mutable fields are declared in FFI metadata, not in the core trait type.

Runtime: browser. Kind: trait.

```text
'Trait
```

Inspect: `calcit query def js-ffi.browser/DomInputHost --raw --json`

### ElementSnapshot

Calcit-owned subset of DOM element data suitable for business code without retaining host identity.

Runtime: browser. Kind: struct.

```text
'Enum
```

Inspect: `calcit query def js-ffi.browser/ElementSnapshot --raw --json`

### EventHost

External Event capability. Targets stay nullable opaque objects unless a specific adapter narrows them.

Runtime: browser. Kind: trait.

```text
'Trait
```

Inspect: `calcit query def js-ffi.browser/EventHost --raw --json`

### KeyModifiers

Normalized keyboard or pointer modifier state shared by event adapters.

Runtime: browser. Kind: struct.

```text
'Enum
```

Inspect: `calcit query def js-ffi.browser/KeyModifiers --raw --json`

### KeyboardEventHost

External KeyboardEvent capability without trait inheritance; adapters normalize keys and modifiers into Calcit data.

Runtime: browser. Kind: trait.

```text
'Trait
```

Inspect: `calcit query def js-ffi.browser/KeyboardEventHost --raw --json`

### LocationHost

External browser Location capability. Navigation methods are explicit effects; URL fields are readable.

Runtime: browser. Kind: trait.

```text
'Trait
```

Inspect: `calcit query def js-ffi.browser/LocationHost --raw --json`

### MediaQueryListHost

External matchMedia result with stable media and matches fields. Listener APIs remain adapter-specific.

Runtime: browser. Kind: trait.

```text
'Trait
```

Inspect: `calcit query def js-ffi.browser/MediaQueryListHost --raw --json`

### MouseEventHost

External MouseEvent capability exposing coordinates, button, and modifier fields used by adapters.

Runtime: browser. Kind: trait.

```text
'Trait
```

Inspect: `calcit query def js-ffi.browser/MouseEventHost --raw --json`

### PointerPosition

Normalized pointer coordinates and button index copied from a MouseEvent-like object.

Runtime: browser. Kind: struct.

```text
'Enum
```

Inspect: `calcit query def js-ffi.browser/PointerPosition --raw --json`

### StorageHost

External Web Storage capability with nullish lookup and explicit String mutation methods.

Runtime: browser. Kind: trait.

```text
'Trait
```

Inspect: `calcit query def js-ffi.browser/StorageHost --raw --json`

### Viewport

Normalized viewport dimensions and device pixel ratio copied from Window.

Runtime: browser. Kind: struct.

```text
'Enum
```

Inspect: `calcit query def js-ffi.browser/Viewport --raw --json`

### VisibilityState

Typed document.visibilityState values with an unknown String variant.

Runtime: browser. Kind: enum.

```text
'Enum
```

Inspect: `calcit query def js-ffi.browser/VisibilityState --raw --json`

### WindowHost

|External browser Window capability restricted to stable viewport fields, matchMedia, and typed global event listeners.

Runtime: browser. Kind: trait.

```text
'Trait
```

Inspect: `calcit query def js-ffi.browser/WindowHost --raw --json`

### add-event-listener!

Register a typed browser window event listener. The callback receives an EventHost and the wrapper returns Unit.

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:return,'Unit,:args,[],'String,::,'Fn,{},:return,'Unit,:args,[],'js-ffi.browser/EventHost,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.browser/add-event-listener! --raw --json`

Recipes: [examples/listen.cirru](../examples/listen.cirru).

### append-child!

Appends one typed DOM host element to another and returns the child. This keeps DOM insertion inside the browser FFI boundary.

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:return,'js-ffi.browser/DomElementHost,:args,[],'js-ffi.browser/DomElementHost,'js-ffi.browser/DomElementHost,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.browser/append-child! --raw --json`

### cancel-animation-frame!

Cancel a browser numeric handle; unknown handles are harmless.

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:return,'Unit,:args,[],'Number,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.browser/cancel-animation-frame! --raw --json`

### child-element-at

Return the indexed child element as Option, normalizing the host nullish result.

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:args,[],'js-ffi.browser/DomChildrenHost,'Number,:features,#{},:js-ffi,:return,::,'Option,'js-ffi.browser/DomElementHost
```

Inspect: `calcit query def js-ffi.browser/child-element-at --raw --json`

### clear-interval!

Cancel a browser numeric handle; unknown handles are harmless.

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:return,'Unit,:args,[],'Number,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.browser/clear-interval! --raw --json`

### clear-timeout!

Cancel a browser numeric handle; unknown handles are harmless.

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:return,'Unit,:args,[],'Number,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.browser/clear-timeout! --raw --json`

### console-error!

Compatibility wrapper for shared/console-error!. It accepts one String and returns Unit.

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:return,'Unit,:args,[],'String
```

Inspect: `calcit query def js-ffi.browser/console-error! --raw --json`

### console-log!

Compatibility wrapper for shared/console-log!. It accepts one String and returns Unit instead of leaking host undefined.

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:return,'Unit,:args,[],'String
```

Inspect: `calcit query def js-ffi.browser/console-log! --raw --json`

### create-element

Create a DOM element through DocumentHost and return its typed host capability.

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:return,'js-ffi.browser/DomElementHost,:args,[],'String,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.browser/create-element --raw --json`

### decode-document-ready-state

Decode document.readyState String to DocumentReadyState while preserving unknown values.

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:return,'js-ffi.browser/DocumentReadyState,:args,[],'String
```

Inspect: `calcit query def js-ffi.browser/decode-document-ready-state --raw --json`

### decode-visibility-state

Decode document.visibilityState String to VisibilityState while preserving unknown values.

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:return,'js-ffi.browser/VisibilityState,:args,[],'String
```

Inspect: `calcit query def js-ffi.browser/decode-visibility-state --raw --json`

### document-available?

Return whether document is present. Use this guard before touching DOM objects so shared code can be checked in both Node.js and browsers. Example: (document-available?) => true

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:return,'Bool,:args,[],:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.browser/document-available? --raw --json`

### document-ready-state

Read and decode document.readyState through the typed DocumentHost contract.

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:return,'js-ffi.browser/DocumentReadyState,:args,[],:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.browser/document-ready-state --raw --json`

### document-title

Read document.title through DocumentHost. Returns an empty String when document is unavailable.

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:return,'String,:args,[],:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.browser/document-title --raw --json`

### element-blur!

Blur an HTML element with blur capability.

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:return,'Unit,:args,[],'js-ffi.browser/DomElementHost,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.browser/element-blur! --raw --json`

### element-dataset

Returns the DOM element dataset object through the browser host contract. Use with js-set/js-delete for data-* attributes.

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:return,'JsObject,:args,[],'js-ffi.browser/DomElementHost,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.browser/element-dataset --raw --json`

### element-focus!

Focus an HTML element with focus capability.

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:return,'Unit,:args,[],'js-ffi.browser/DomElementHost,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.browser/element-focus! --raw --json`

### element-get-attribute

Read a DOM attribute as Option<String>.

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:args,[],'js-ffi.browser/DomElementHost,'String,:features,#{},:js-ffi,:return,::,'Option,'String
```

Inspect: `calcit query def js-ffi.browser/element-get-attribute --raw --json`

### element-matches?

Match a CSS selector; invalid selectors raise DOMException.

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:return,'Bool,:args,[],'js-ffi.browser/DomElementHost,'String,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.browser/element-matches? --raw --json`

### element-query-selector

Find a descendant or return Option.none.

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:args,[],'js-ffi.browser/DomElementHost,'String,:features,#{},:js-ffi,:return,::,'Option,'js-ffi.browser/DomElementHost
```

Inspect: `calcit query def js-ffi.browser/element-query-selector --raw --json`

### element-remove-attribute!

Remove a DOM attribute.

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:return,'Unit,:args,[],'js-ffi.browser/DomElementHost,'String,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.browser/element-remove-attribute! --raw --json`

### element-set-attribute!

Set a DOM attribute.

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:return,'Unit,:args,[],'js-ffi.browser/DomElementHost,'String,'String,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.browser/element-set-attribute! --raw --json`

### element-snapshot

Copy a typed DOM element into ElementSnapshot, converting nullish textContent to Option<String>.

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:return,'js-ffi.browser/ElementSnapshot,:args,[],'js-ffi.browser/DomElementHost,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.browser/element-snapshot --raw --json`

### element-style

Returns the DOM element style declaration through the browser host contract. Use with aset for normalized CSS property names.

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:return,'JsObject,:args,[],'js-ffi.browser/DomElementHost,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.browser/element-style --raw --json`

### local-storage-available?

Return whether localStorage is available. Browsers may deny storage in privacy or sandboxed modes, so callers should branch on this Boolean. Example: (local-storage-available?) => true

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:return,'Bool,:args,[],:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.browser/local-storage-available? --raw --json`

### location-href

Read location.href through the typed LocationHost contract.

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:return,'String,:args,[],:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.browser/location-href --raw --json`

### probe

Run the browser capability smoke probe and return typed BrowserProbe data.

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:return,'js-ffi.browser/BrowserProbe,:args,[]
```

Inspect: `calcit query def js-ffi.browser/probe --raw --json`

### query-selector

Query document for a selector and normalize a missing element into Option<DomElementHost>.

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:args,[],'String,:features,#{},:js-ffi,:return,::,'Option,'js-ffi.browser/DomElementHost
```

Inspect: `calcit query def js-ffi.browser/query-selector --raw --json`

### random

Return a browser-compatible random number in the range 0 inclusive to 1 exclusive. The concrete return type is Number. Example: (random) => 0.42

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:return,'Number,:args,[],:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.browser/random --raw --json`

### remove-event-listener!

Remove a previously registered typed browser window listener.

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:return,'Unit,:args,[],'String,::,'Fn,{},:return,'Unit,:args,[],'js-ffi.browser/EventHost,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.browser/remove-event-listener! --raw --json`

Recipes: [examples/listen.cirru](../examples/listen.cirru).

### request-animation-frame!

Schedule a frame callback receiving a timestamp; returns a cancellable numeric handle.

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:return,'Number,:args,[],::,'Fn,{},:return,'Unit,:args,[],'Number,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.browser/request-animation-frame! --raw --json`

### runtime

Return the normalized Runtime browser enum variant.

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:return,'js-ffi.shared/Runtime,:args,[]
```

Inspect: `calcit query def js-ffi.browser/runtime --raw --json`

### runtime-name

Return the literal runtime identifier |browser. This is useful for environment contracts and keeps callers independent from host-specific globals. Example: (runtime-name) => |browser

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:return,'String,:args,[]
```

Inspect: `calcit query def js-ffi.browser/runtime-name --raw --json`

### set-before-unload!

Install a typed browser beforeunload callback.

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:return,'Unit,:args,[],::,'Fn,{},:return,'Unit,:args,[],'js-ffi.browser/EventHost,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.browser/set-before-unload! --raw --json`

### set-interval!

Schedule a repeated browser callback and return the numeric timer identifier. The callback receives no arguments and returns Unit.

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:return,'Number,:args,[],::,'Fn,{},:return,'Unit,:args,[],'Number,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.browser/set-interval! --raw --json`

### set-timeout!

Schedule a Unit callback and return the browser numeric timer id. Node timer handles intentionally use a separate contract.

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:return,'Number,:args,[],::,'Fn,{},:return,'Unit,:args,[],'Number,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.browser/set-timeout! --raw --json`

### storage-get

Read one localStorage key as Option<String>; missing and JavaScript nullish values become none. Host exceptions remain an adapter concern.

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:args,[],'String,:features,#{},:js-ffi,:return,::,'Option,'String
```

Inspect: `calcit query def js-ffi.browser/storage-get --raw --json`

### storage-get-or

Read localStorage as Option<String> internally and return the supplied fallback for a missing key.

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:return,'String,:args,[],'String,'String
```

Inspect: `calcit query def js-ffi.browser/storage-get-or --raw --json`

### storage-remove!

Remove a localStorage key through StorageHost and return Unit.

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:return,'Unit,:args,[],'String,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.browser/storage-remove! --raw --json`

### storage-roundtrip!

Exercise localStorage with a deterministic String result for smoke tests. It writes |ok, reads it back, and returns |unavailable when storage is missing. Example: (storage-roundtrip!) => |ok

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:return,'String,:args,[],:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.browser/storage-roundtrip! --raw --json`

### storage-set!

Write a String key/value pair through StorageHost and normalize the host return to Unit.

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:return,'Unit,:args,[],'String,'String,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.browser/storage-set! --raw --json`

### viewport

Read Window viewport fields once and return normalized Viewport data.

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:return,'js-ffi.browser/Viewport,:args,[],:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.browser/viewport --raw --json`

### viewport-height

Return the height field from normalized Viewport data.

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:return,'Number,:args,[]
```

Inspect: `calcit query def js-ffi.browser/viewport-height --raw --json`

### viewport-width

Return the width field from normalized Viewport data.

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:return,'Number,:args,[]
```

Inspect: `calcit query def js-ffi.browser/viewport-width --raw --json`

### visibility-state

Read and decode document.visibilityState through the typed DocumentHost contract.

Runtime: browser. Kind: fn.

```text
{},:kind,:fn,:return,'js-ffi.browser/VisibilityState,:args,[],:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.browser/visibility-state --raw --json`

## js-ffi.contract

### expect-bool

Decode an opaque JavaScript value as Bool after a runtime kind check. Null and undefined are reported as nullish; other mismatches raise a stable JS FFI contract violation.

Runtime: browser, node. Kind: fn.

```text
{},:kind,:fn,:return,'Bool,:args,[],'String,::,'JsNullish,'JsObject,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.contract/expect-bool --raw --json`

### expect-function

Validate that an opaque JavaScript value is a non-null JavaScript function and return its opaque host identity. Use a small typed adapter for its call schema and receiver contract.

Runtime: browser, node. Kind: fn.

```text
{},:kind,:fn,:return,'JsObject,:args,[],'String,::,'JsNullish,'JsObject,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.contract/expect-function --raw --json`

### expect-number

Decode an opaque JavaScript value as Number after a runtime kind check. Null and undefined are reported as nullish; other mismatches raise a stable JS FFI contract violation.

Runtime: browser, node. Kind: fn.

```text
{},:kind,:fn,:return,'Number,:args,[],'String,::,'JsNullish,'JsObject,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.contract/expect-number --raw --json`

### expect-object

Validate that an opaque JavaScript value is a non-null object and return it as JsObject. This proves only the shallow host kind; decode or check members before exposing concrete data.

Runtime: browser, node. Kind: fn.

```text
{},:kind,:fn,:return,'JsObject,:args,[],'String,::,'JsNullish,'JsObject,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.contract/expect-object --raw --json`

### expect-string

Decode an opaque JavaScript value as String after a runtime kind check. Null and undefined are reported as nullish; other mismatches raise a stable JS FFI contract violation.

Runtime: browser, node. Kind: fn.

```text
{},:kind,:fn,:return,'String,:args,[],'String,::,'JsNullish,'JsObject,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.contract/expect-string --raw --json`

### object-field

Read one named field from an opaque JavaScript object after checking the receiver. The result remains JsNullish<JsObject>; pass it through an expect primitive guard or explicitly normalize absence before returning concrete data.

Runtime: browser, node. Kind: fn.

```text
{},:kind,:fn,:args,[],'String,::,'JsNullish,'JsObject,'String,:features,#{},:js-ffi,:return,::,'JsNullish,'JsObject
```

Inspect: `calcit query def js-ffi.contract/object-field --raw --json`

### valid-runtime?

Compare two normalized Runtime values without relying on open String identifiers.

Runtime: browser, node. Kind: fn.

```text
{},:kind,:fn,:return,'Bool,:args,[],'js-ffi.shared/Runtime,'js-ffi.shared/Runtime
```

Inspect: `calcit query def js-ffi.contract/valid-runtime? --raw --json`

## js-ffi.node

### NodeProbe

Typed Node smoke result replacing the former heterogeneous Map<Dynamic>.

Runtime: node. Kind: struct.

```text
'Enum
```

Inspect: `calcit query def js-ffi.node/NodeProbe --raw --json`

### ProcessArgvHost

External process.argv capability exposing only an opaque/nullish length that argv-count validates at runtime.

Runtime: node. Kind: trait.

```text
'Trait
```

Inspect: `calcit query def js-ffi.node/ProcessArgvHost --raw --json`

### append-text!

Synchronous node:fs.appendFileSync adapter. Text uses UTF-8; filesystem failures raise the original host exception. No recursive deletion.

Runtime: node. Kind: fn.

```text
{},:kind,:fn,:return,'Unit,:args,[],'String,'String,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.node/append-text! --raw --json`

### argv-count

Return process.argv.length as Number. This deliberately narrows the host array at the boundary. Example: (argv-count) => 3

Runtime: node. Kind: fn.

```text
{},:kind,:fn,:return,'Number,:args,[],:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.node/argv-count --raw --json`

### copy-file!

Synchronous node:fs.copyFileSync adapter. Text uses UTF-8; filesystem failures raise the original host exception. No recursive deletion.

Runtime: node. Kind: fn.

```text
{},:kind,:fn,:return,'Unit,:args,[],'String,'String,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.node/copy-file! --raw --json`

### cwd

Return process.cwd() as String. This is a Node-only API and is emitted through the node entry. Example: (cwd) => |/workspace/project

Runtime: node. Kind: fn.

```text
{},:kind,:fn,:return,'String,:args,[],:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.node/cwd --raw --json`

### env-or

Read a process.env value with a typed String fallback. Example: (env-or |NODE_ENV |development) => |development

Runtime: node. Kind: fn.

```text
{},:kind,:fn,:return,'String,:args,[],'String,'String,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.node/env-or --raw --json`

### exit!

Terminate the Node.js process with a numeric exit code. This effectful escape hatch has the Unit contract because it has no business result. Example: (exit! 1)

Runtime: node. Kind: fn.

```text
{},:kind,:fn,:return,'Unit,:args,[],'Number,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.node/exit! --raw --json`

### file-exists?

Return whether a local filesystem path exists as Bool. The fs module is kept behind the Node namespace. Example: (file-exists? |package.json) => true

Runtime: node. Kind: fn.

```text
{},:kind,:fn,:return,'Bool,:args,[],'String,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.node/file-exists? --raw --json`

### make-temp-dir!

Synchronous node:fs.mkdtempSync adapter. Text uses UTF-8; filesystem failures raise the original host exception. No recursive deletion.

Runtime: node. Kind: fn.

```text
{},:kind,:fn,:return,'String,:args,[],'String,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.node/make-temp-dir! --raw --json`

### mkdir!

Synchronous node:fs.mkdirSync adapter. Text uses UTF-8; filesystem failures raise the original host exception. No recursive deletion.

Runtime: node. Kind: fn.

```text
{},:kind,:fn,:return,'Unit,:args,[],'String,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.node/mkdir! --raw --json`

### node-version

Read and validate Node process metadata.

Runtime: node. Kind: fn.

```text
{},:kind,:fn,:return,'String,:args,[],:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.node/node-version --raw --json`

### path-absolute?

Call node:path.isAbsolute using native platform path rules and validate its result.

Runtime: node. Kind: fn.

```text
{},:kind,:fn,:return,'Bool,:args,[],'String,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.node/path-absolute? --raw --json`

### path-basename

Call node:path.basename using native platform path rules and validate its result.

Runtime: node. Kind: fn.

```text
{},:kind,:fn,:return,'String,:args,[],'String,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.node/path-basename --raw --json`

### path-dirname

Call node:path.dirname using native platform path rules and validate its result.

Runtime: node. Kind: fn.

```text
{},:kind,:fn,:return,'String,:args,[],'String,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.node/path-dirname --raw --json`

### path-extname

Call node:path.extname using native platform path rules and validate its result.

Runtime: node. Kind: fn.

```text
{},:kind,:fn,:return,'String,:args,[],'String,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.node/path-extname --raw --json`

### path-join

Join two path segments using node:path and return String. Example: (path-join |src |index.js) => |src/index.js

Runtime: node. Kind: fn.

```text
{},:kind,:fn,:return,'String,:args,[],'String,'String,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.node/path-join --raw --json`

Recipes: [examples/text-file.cirru](../examples/text-file.cirru).

### path-normalize

Call node:path.normalize using native platform path rules and validate its result.

Runtime: node. Kind: fn.

```text
{},:kind,:fn,:return,'String,:args,[],'String,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.node/path-normalize --raw --json`

### path-relative

Call node:path.relative using native platform path rules and validate its result.

Runtime: node. Kind: fn.

```text
{},:kind,:fn,:return,'String,:args,[],'String,'String,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.node/path-relative --raw --json`

### path-resolve

Call node:path.resolve using native platform path rules and validate its result.

Runtime: node. Kind: fn.

```text
{},:kind,:fn,:return,'String,:args,[],'String,'String,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.node/path-resolve --raw --json`

### pid

Read and validate Node process metadata.

Runtime: node. Kind: fn.

```text
{},:kind,:fn,:return,'Number,:args,[],:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.node/pid --raw --json`

### platform

Read and validate Node process metadata.

Runtime: node. Kind: fn.

```text
{},:kind,:fn,:return,'String,:args,[],:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.node/platform --raw --json`

### probe

Run the Node capability smoke probe and return typed NodeProbe data.

Runtime: node. Kind: fn.

```text
{},:kind,:fn,:return,'js-ffi.node/NodeProbe,:args,[]
```

Inspect: `calcit query def js-ffi.node/probe --raw --json`

### read-text!

Synchronous node:fs.readFileSync adapter. Text uses UTF-8; filesystem failures raise the original host exception. No recursive deletion.

Runtime: node. Kind: fn.

```text
{},:kind,:fn,:return,'String,:args,[],'String,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.node/read-text! --raw --json`

Recipes: [examples/text-file.cirru](../examples/text-file.cirru).

### real-path!

Synchronous node:fs.realpathSync adapter. Text uses UTF-8; filesystem failures raise the original host exception. No recursive deletion.

Runtime: node. Kind: fn.

```text
{},:kind,:fn,:return,'String,:args,[],'String,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.node/real-path! --raw --json`

### rename!

Synchronous node:fs.renameSync adapter. Text uses UTF-8; filesystem failures raise the original host exception. No recursive deletion.

Runtime: node. Kind: fn.

```text
{},:kind,:fn,:return,'Unit,:args,[],'String,'String,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.node/rename! --raw --json`

### rmdir!

Synchronous node:fs.rmdirSync adapter. Text uses UTF-8; filesystem failures raise the original host exception. No recursive deletion.

Runtime: node. Kind: fn.

```text
{},:kind,:fn,:return,'Unit,:args,[],'String,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.node/rmdir! --raw --json`

### runtime

Return the normalized Runtime node enum variant.

Runtime: node. Kind: fn.

```text
{},:kind,:fn,:return,'js-ffi.shared/Runtime,:args,[]
```

Inspect: `calcit query def js-ffi.node/runtime --raw --json`

### runtime-name

Return the literal runtime identifier |node. Example: (runtime-name) => |node

Runtime: node. Kind: fn.

```text
{},:kind,:fn,:return,'String,:args,[]
```

Inspect: `calcit query def js-ffi.node/runtime-name --raw --json`

### unlink!

Synchronous node:fs.unlinkSync adapter. Text uses UTF-8; filesystem failures raise the original host exception. No recursive deletion.

Runtime: node. Kind: fn.

```text
{},:kind,:fn,:return,'Unit,:args,[],'String,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.node/unlink! --raw --json`

### uptime

Read and validate Node process metadata.

Runtime: node. Kind: fn.

```text
{},:kind,:fn,:return,'Number,:args,[],:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.node/uptime --raw --json`

### write-text!

Synchronous node:fs.writeFileSync adapter. Text uses UTF-8; filesystem failures raise the original host exception. No recursive deletion.

Runtime: node. Kind: fn.

```text
{},:kind,:fn,:return,'Unit,:args,[],'String,'String,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.node/write-text! --raw --json`

Recipes: [examples/text-file.cirru](../examples/text-file.cirru).

## js-ffi.shared

### AbortControllerHost

External AbortController capability with a typed signal and parameterless abort wrapper contract.

Runtime: browser, node. Kind: trait.

```text
'Trait
```

Inspect: `calcit query def js-ffi.shared/AbortControllerHost --raw --json`

### AbortSignalHost

External AbortSignal capability. Reason stays an opaque nullable host object because JavaScript permits arbitrary values.

Runtime: browser, node. Kind: trait.

```text
'Trait
```

Inspect: `calcit query def js-ffi.shared/AbortSignalHost --raw --json`

### ConsoleHost

External console capability shared by browser and Node. Methods intentionally accept one String to avoid modeling host varargs.

Runtime: browser, node. Kind: trait.

```text
'Trait
```

Inspect: `calcit query def js-ffi.shared/ConsoleHost --raw --json`

### DateHost

External JavaScript Date capability exposing only stable read methods needed for normalization.

Runtime: browser, node. Kind: trait.

```text
'Trait
```

Inspect: `calcit query def js-ffi.shared/DateHost --raw --json`

### DateSnapshot

Immutable normalized view of a host Date with epoch milliseconds and ISO text.

Runtime: browser, node. Kind: struct.

```text
'Enum
```

Inspect: `calcit query def js-ffi.shared/DateSnapshot --raw --json`

### HeadersHost

External Headers capability with typed String keys and values; iteration is deliberately normalized elsewhere.

Runtime: browser, node. Kind: trait.

```text
'Trait
```

Inspect: `calcit query def js-ffi.shared/HeadersHost --raw --json`

### HttpMethod

Closed HTTP method set used by typed request options; custom methods remain an explicit adapter concern.

Runtime: browser, node. Kind: enum.

```text
'Enum
```

Inspect: `calcit query def js-ffi.shared/HttpMethod --raw --json`

### JsError

Normalized JavaScript exception data. Stack is optional because hosts may omit it.

Runtime: browser, node. Kind: struct.

```text
'Enum
```

Inspect: `calcit query def js-ffi.shared/JsError --raw --json`

### JsErrorKind

Stable error categories shared by browser and Node adapters; unknown host names retain their String payload.

Runtime: browser, node. Kind: enum.

```text
'Enum
```

Inspect: `calcit query def js-ffi.shared/JsErrorKind --raw --json`

### RequestOptions

Calcit-owned request configuration converted to a JavaScript object only inside an adapter.

Runtime: browser, node. Kind: struct.

```text
'Enum
```

Inspect: `calcit query def js-ffi.shared/RequestOptions --raw --json`

### ResponseHost

External Response metadata capability. Async body readers are omitted until adapters normalize their Promise results.

Runtime: browser, node. Kind: trait.

```text
'Trait
```

Inspect: `calcit query def js-ffi.shared/ResponseHost --raw --json`

### ResponseSnapshot

Normalized response metadata after a host Response has been inspected and its headers copied.

Runtime: browser, node. Kind: struct.

```text
'Enum
```

Inspect: `calcit query def js-ffi.shared/ResponseSnapshot --raw --json`

### Runtime

Runtime identity normalized as a Calcit enum instead of an open String.

Runtime: browser, node. Kind: enum.

```text
'Enum
```

Inspect: `calcit query def js-ffi.shared/Runtime --raw --json`

### UrlHost

External URL-like capability shared by URL and browser Location objects. Fields are read-only in this contract.

Runtime: browser, node. Kind: trait.

```text
'Trait
```

Inspect: `calcit query def js-ffi.shared/UrlHost --raw --json`

### UrlSearchParamsHost

External URLSearchParams capability. Nullable lookup remains JsNullish<String> until an adapter converts it to Option.

Runtime: browser, node. Kind: trait.

```text
'Trait
```

Inspect: `calcit query def js-ffi.shared/UrlSearchParamsHost --raw --json`

### UrlSnapshot

Immutable URL fields copied out of a host URL or Location object.

Runtime: browser, node. Kind: struct.

```text
'Enum
```

Inspect: `calcit query def js-ffi.shared/UrlSnapshot --raw --json`

### abort!

Abort the controller. Repeated aborts are safe.

Runtime: browser, node. Kind: fn.

```text
{},:kind,:fn,:return,'Unit,:args,[],'js-ffi.shared/AbortControllerHost,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.shared/abort! --raw --json`

### abort-controller-create

Construct a native AbortController and retain its typed host identity. Invalid constructor inputs raise host exceptions.

Runtime: browser, node. Kind: fn.

```text
{},:kind,:fn,:return,'js-ffi.shared/AbortControllerHost,:args,[],:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.shared/abort-controller-create --raw --json`

### abort-signal

Return the controller signal, preserving identity.

Runtime: browser, node. Kind: fn.

```text
{},:kind,:fn,:return,'js-ffi.shared/AbortSignalHost,:args,[],'js-ffi.shared/AbortControllerHost,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.shared/abort-signal --raw --json`

### aborted?

Read whether a signal has been aborted.

Runtime: browser, node. Kind: fn.

```text
{},:kind,:fn,:return,'Bool,:args,[],'js-ffi.shared/AbortSignalHost,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.shared/aborted? --raw --json`

### console-error!

Write one error String to the host console and return Unit in browser or Node.

Runtime: browser, node. Kind: fn.

```text
{},:kind,:fn,:return,'Unit,:args,[],'String,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.shared/console-error! --raw --json`

### console-log!

Write one String to the host console and normalize the host undefined return to Unit.

Runtime: browser, node. Kind: fn.

```text
{},:kind,:fn,:return,'Unit,:args,[],'String,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.shared/console-log! --raw --json`

### console-warn!

Write one warning String to the host console and return Unit in browser or Node.

Runtime: browser, node. Kind: fn.

```text
{},:kind,:fn,:return,'Unit,:args,[],'String,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.shared/console-warn! --raw --json`

### date-now-snapshot

Create a host Date and immediately normalize it to DateSnapshot in browser or Node.

Runtime: browser, node. Kind: fn.

```text
{},:kind,:fn,:return,'js-ffi.shared/DateSnapshot,:args,[],:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.shared/date-now-snapshot --raw --json`

### date-snapshot

Copy a typed host Date into Calcit-owned DateSnapshot data.

Runtime: browser, node. Kind: fn.

```text
{},:kind,:fn,:return,'js-ffi.shared/DateSnapshot,:args,[],'js-ffi.shared/DateHost,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.shared/date-snapshot --raw --json`

### decode-uri-component

Read the native result through a checked primitive boundary. Invalid input may raise a host exception.

Runtime: browser, node. Kind: fn.

```text
{},:kind,:fn,:return,'String,:args,[],'String,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.shared/decode-uri-component --raw --json`

### encode-uri-component

Read the native result through a checked primitive boundary. Invalid input may raise a host exception.

Runtime: browser, node. Kind: fn.

```text
{},:kind,:fn,:return,'String,:args,[],'String,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.shared/encode-uri-component --raw --json`

### headers-append!

Append a header value using native Headers normalization.

Runtime: browser, node. Kind: fn.

```text
{},:kind,:fn,:return,'Unit,:args,[],'js-ffi.shared/HeadersHost,'String,'String,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.shared/headers-append! --raw --json`

### headers-create

Construct a native Headers and retain its typed host identity. Invalid constructor inputs raise host exceptions.

Runtime: browser, node. Kind: fn.

```text
{},:kind,:fn,:return,'js-ffi.shared/HeadersHost,:args,[],:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.shared/headers-create --raw --json`

### headers-delete!

Remove a key and return Unit.

Runtime: browser, node. Kind: fn.

```text
{},:kind,:fn,:return,'Unit,:args,[],'js-ffi.shared/HeadersHost,'String,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.shared/headers-delete! --raw --json`

### headers-get

Lookup a key; missing values become Option.none.

Runtime: browser, node. Kind: fn.

```text
{},:kind,:fn,:args,[],'js-ffi.shared/HeadersHost,'String,:features,#{},:js-ffi,:return,::,'Option,'String
```

Inspect: `calcit query def js-ffi.shared/headers-get --raw --json`

### headers-has?

Check whether a key exists.

Runtime: browser, node. Kind: fn.

```text
{},:kind,:fn,:return,'Bool,:args,[],'js-ffi.shared/HeadersHost,'String,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.shared/headers-has? --raw --json`

### headers-set!

Replace the values for a key.

Runtime: browser, node. Kind: fn.

```text
{},:kind,:fn,:return,'Unit,:args,[],'js-ffi.shared/HeadersHost,'String,'String,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.shared/headers-set! --raw --json`

### http-method-label

Convert HttpMethod to the uppercase token expected by JavaScript request APIs.

Runtime: browser, node. Kind: fn.

```text
{},:kind,:fn,:return,'String,:args,[],'js-ffi.shared/HttpMethod
```

Inspect: `calcit query def js-ffi.shared/http-method-label --raw --json`

### now-ms

Read the native result through a checked primitive boundary. Invalid input may raise a host exception.

Runtime: browser, node. Kind: fn.

```text
{},:kind,:fn,:return,'Number,:args,[],:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.shared/now-ms --raw --json`

### performance-now

Read the native result through a checked primitive boundary. Invalid input may raise a host exception.

Runtime: browser, node. Kind: fn.

```text
{},:kind,:fn,:return,'Number,:args,[],:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.shared/performance-now --raw --json`

### queue-microtask!

Queue a Unit callback in the JavaScript microtask queue.

Runtime: browser, node. Kind: fn.

```text
{},:kind,:fn,:return,'Unit,:args,[],::,'Fn,{},:return,'Unit,:args,[],:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.shared/queue-microtask! --raw --json`

### runtime-label

Convert Runtime to the stable host label used in logs and compatibility checks.

Runtime: browser, node. Kind: fn.

```text
{},:kind,:fn,:return,'String,:args,[],'js-ffi.shared/Runtime
```

Inspect: `calcit query def js-ffi.shared/runtime-label --raw --json`

### search-params-create

Construct a native URLSearchParams and retain its typed host identity. Invalid constructor inputs raise host exceptions.

Runtime: browser, node. Kind: fn.

```text
{},:kind,:fn,:return,'js-ffi.shared/UrlSearchParamsHost,:args,[],'String,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.shared/search-params-create --raw --json`

Recipes: [examples/query-string.cirru](../examples/query-string.cirru).

### search-params-delete!

Remove a key and return Unit.

Runtime: browser, node. Kind: fn.

```text
{},:kind,:fn,:return,'Unit,:args,[],'js-ffi.shared/UrlSearchParamsHost,'String,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.shared/search-params-delete! --raw --json`

### search-params-get

Lookup a key; missing values become Option.none.

Runtime: browser, node. Kind: fn.

```text
{},:kind,:fn,:args,[],'js-ffi.shared/UrlSearchParamsHost,'String,:features,#{},:js-ffi,:return,::,'Option,'String
```

Inspect: `calcit query def js-ffi.shared/search-params-get --raw --json`

### search-params-has?

Check whether a key exists.

Runtime: browser, node. Kind: fn.

```text
{},:kind,:fn,:return,'Bool,:args,[],'js-ffi.shared/UrlSearchParamsHost,'String,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.shared/search-params-has? --raw --json`

### search-params-set!

Replace the values for a key.

Runtime: browser, node. Kind: fn.

```text
{},:kind,:fn,:return,'Unit,:args,[],'js-ffi.shared/UrlSearchParamsHost,'String,'String,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.shared/search-params-set! --raw --json`

Recipes: [examples/query-string.cirru](../examples/query-string.cirru).

### search-params-size

Count query entries, including duplicate keys.

Runtime: browser, node. Kind: fn.

```text
{},:kind,:fn,:return,'Number,:args,[],'js-ffi.shared/UrlSearchParamsHost,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.shared/search-params-size --raw --json`

### search-params-string

Serialize query parameters with standard percent encoding.

Runtime: browser, node. Kind: fn.

```text
{},:kind,:fn,:return,'String,:args,[],'js-ffi.shared/UrlSearchParamsHost,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.shared/search-params-string --raw --json`

Recipes: [examples/query-string.cirru](../examples/query-string.cirru).

### url-create

Construct a native URL and retain its typed host identity. Invalid constructor inputs raise host exceptions.

Runtime: browser, node. Kind: fn.

```text
{},:kind,:fn,:return,'js-ffi.shared/UrlHost,:args,[],'String,'String,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.shared/url-create --raw --json`

### url-snapshot

Copy a URL-like host object into immutable UrlSnapshot data without retaining host identity.

Runtime: browser, node. Kind: fn.

```text
{},:kind,:fn,:return,'js-ffi.shared/UrlSnapshot,:args,[],'js-ffi.shared/UrlHost,:features,#{},:js-ffi
```

Inspect: `calcit query def js-ffi.shared/url-snapshot --raw --json`

