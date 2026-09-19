---
title: "Standard host adapters"
summary: "Typed URL, fetch/Response, Headers, abort, DOM, timers, process, paths and UTF-8 filesystem adapters"
scope: "module"
kind: "reference"
category: "ffi"
entry_for:
  - "js-ffi.shared"
  - "js-ffi.browser"
  - "js-ffi.node"
---

# Standard host adapters

These 126 adapters extend the existing host contracts. Import `js-ffi.shared`
with either `js-ffi.browser` or `js-ffi.node`. The package retains no native
objects in application state automatically; constructors explicitly return
named host capabilities, and missing lookups return `Option`.

Development and CI use Node.js 24 (Vite requires Node.js >=22.12 here) and
Playwright Chromium. Runtime helpers use standard APIs; the browser needs
URLSearchParams.size, Headers, AbortController, performance and requestAnimationFrame.

## Shared APIs (30 adapters)

| Function | Parameters → result | Behavior |
| --- | --- | --- |
| `url-create` | String input, String base → UrlHost | Resolve absolute or relative URLs against an explicit base. |
| `search-params-create` | String query → UrlSearchParamsHost | Parse an optional leading `?`; preserve duplicate keys. |
| `search-params-get` | UrlSearchParamsHost, String key → Option<String> | First value; an empty string remains some. |
| `search-params-has?` | UrlSearchParamsHost, String key → Bool | Check key existence. |
| `search-params-set!` | UrlSearchParamsHost, String key, String value → Unit | Replace all values for a key. |
| `search-params-delete!` | UrlSearchParamsHost, String key → Unit | Remove all entries for a key. |
| `search-params-string` | UrlSearchParamsHost → String | Serialize using native percent encoding. |
| `search-params-size` | UrlSearchParamsHost → Number | Count entries, including duplicate keys. |
| `headers-create` | () → HeadersHost | Create mutable empty headers. |
| `headers-get` | HeadersHost, String key → Option<String> | Case-insensitive lookup. |
| `headers-has?` | HeadersHost, String key → Bool | Case-insensitive existence check. |
| `headers-set!` | HeadersHost, String key, String value → Unit | Replace a header value. |
| `headers-append!` | HeadersHost, String key, String value → Unit | Append using native header normalization. |
| `headers-delete!` | HeadersHost, String key → Unit | Remove a header. |
| `abort-controller-create` | () → AbortControllerHost | Create a fresh controller. |
| `abort-signal` | AbortControllerHost → AbortSignalHost | Return the same signal on each call. |
| `abort!` | AbortControllerHost → Unit | Abort; repeated calls are harmless. |
| `aborted?` | AbortSignalHost → Bool | Read cancellation state. |
| `encode-uri-component` | String → String | Encode one URI component, including Unicode. |
| `decode-uri-component` | String → String | Decode one component; malformed escapes raise URIError. |
| `now-ms` | () → Number | Epoch milliseconds from Date.now. |
| `performance-now` | () → Number | Monotonic milliseconds relative to the host time origin. |
| `response-host` | JsObject → ResponseHost | Validate Response metadata, Headers methods, and its async text reader. |
| `fetch-response` | String → async Result<ResponseHost, JsError> | Await one fetch; normalize throw/rejection. |
| `fetch-request` | String, HttpMethod, HeadersHost, Option<String> → async Result<ResponseHost, JsError> | Build a request from typed method, headers and optional String body. |
| `response-text` | ResponseHost → async Result<String, JsError> | Await one body read; repeated/failed reads are errors. |
| `response-json` | ResponseHost → async Result<JsObject, JsError> | Await the body, parse JSON, and expose the resulting object. |
| `normalize-error` | JsObject → JsError | Normalize a caught host failure. |
| `console-info!` | String → Unit | Write one informational line through the shared console contract. |
| `console-host` | () → ConsoleHost | Return the console external-object for method-style calls. |

## Browser document, location, window, screen, clipboard, data and socket adapters (58 adapters)

These accessors expose the stable browser globals as typed host capabilities
without letting callers read raw `js/...` paths. `document-host`, `location-host`
and `window-host` return the existing external-object contracts; `location-snapshot`
copies the stable Location fields into one struct; the remaining helpers read a
single validated host value. **All 14 accessors require `:js-ffi`** because they
cross the host border, including `document-host`, `user-agent`, `screen-width`,
and `screen-height`. `document-body` returns `Option<DomElementHost>` because
`document.body` can be null before a body or frameset exists.

| Function | Parameters → result |
| --- | --- |
| `document-host` | () → DocumentHost |
| `document-body` | () → DomElementHost |
| `location-host` | () → LocationHost |
| `location-snapshot` | () → LocationSnapshot |
| `window-host` | () → WindowHost |
| `user-agent` | () → String |
| `screen-width`, `screen-height` | () → Number |
| `window-open` | String → Option<WindowHost> |
| `location-replace!` | String → Unit |
| `element-request-fullscreen!` | DomElementHost → Unit |
| `create-element-ns` | String namespace, String tag → DomElementHost |
| `form-data-create` | () → FormDataHost |
| `form-data-append!` | FormDataHost, String name, String value → Unit |
| `document-active-element` | () → Option<DomElementHost> |
| `clipboard-write-text!` | String → Unit |
| `clipboard-read-text!` | () → async Result<String, JsError> |
| `speech-synthesis-speak!` | String → Unit |
| `speech-synthesis-cancel!` | () → Unit |
| `window-local-storage` | () → StorageHost |
| `history-push-state!` | String → Unit |
| `history-replace-state!` | String → Unit |
| `alert!` | String → Unit |
| `prompt!` | String → Option<String> |
| `notification-request-permission!` | () → async Result<String, JsError> |
| `blob-create` | String → BlobHost |
| `blob-text` | BlobHost → async Result<String, JsError> |
| `object-url-create` | BlobHost → String |
| `object-url-revoke!` | String → Unit |
| `image-create` | () → ImageHost |
| `image-src!` | ImageHost, String → Unit |
| `image-decode!` | ImageHost → async Result<Unit, JsError> |
| `image-natural-width`, `image-natural-height` | ImageHost → Number |
| `web-socket-create` | String → WebSocketHost |
| `web-socket-send!` | WebSocketHost, String → Unit |
| `web-socket-close!` | WebSocketHost → Unit |
| `web-socket-ready-state` | WebSocketHost → Number |
| `web-socket-on-open!`, `web-socket-on-close!`, `web-socket-on-error!` | WebSocketHost, Fn(EventHost) → Unit |
| `web-socket-on-message!` | WebSocketHost, Fn(String) → Unit |
| `element-data-get` | DomElementHost, String → Option<String> |
| `element-data-set!`, `element-data-remove!` | DomElementHost, String [, String] → Unit |
| `element-style-get` | DomElementHost, String → Option<String> |
| `mouse-event-host` | T → MouseEventHost |
| `pointer-event-host` | T → PointerEventHost |
| `event-target-element` | EventHost → Option<DomElementHost> |
| `document-title!` | String → Unit |
| `element-set-inner-html!` | DomElementHost, String → Unit |
| `element-set-text-content!` | DomElementHost, String → Unit |
| `element-set-class-name!` | DomElementHost, String → Unit |
| `element-set-hidden!` | DomElementHost, Bool → Unit |
| `element-set-value!`, `element-set-placeholder!` | DomElementHost, String → Unit |
| `element-set-css-text!` | DomElementHost, String → Unit |
| `element-add-event-listener!`, `element-remove-event-listener!` | DomElementHost, String, Fn(EventHost) → Unit |

## Browser APIs (11 adapters)

DOM functions accept `DomElementHost`. Use focus/blur with an HTML element
that supplies those methods (for example an input).

| Function | Parameters → result |
| --- | --- |
| `element-get-attribute` | element, String key → Option<String> |
| `element-set-attribute!` | element, String key, String value → Unit |
| `element-remove-attribute!` | element, String key → Unit |
| `element-matches?` | element, String selector → Bool |
| `element-query-selector` | element, String selector → Option<DomElementHost> |
| `element-focus!`, `element-blur!` | element → Unit |
| `clear-timeout!`, `clear-interval!` | Number handle → Unit |
| `request-animation-frame!` | (Number timestamp → Unit) callback → Number handle |
| `cancel-animation-frame!` | Number handle → Unit |

Missing attributes and selector results become none; invalid CSS selectors
raise the native DOMException. Keep timer/frame handles and cancel them during
teardown. Browser handles are numeric and must not be used as Node timer handles.

## Node APIs (27 adapters)

| Function | Parameters → result |
| --- | --- |
| `path-basename`, `path-dirname`, `path-extname`, `path-normalize` | String path → String |
| `path-resolve`, `path-relative` | String base, String child → String |
| `path-absolute?` | String path → Bool |
| `read-text!` | String path → String |
| `write-text!`, `append-text!` | String path, String text → Unit |
| `read-text-async!` | String path → async Result<String, JsError> |
| `write-text-async!` | String path, String text → async Result<Unit, JsError> |
| `copy-file!`, `rename!` | String source, String destination → Unit |
| `unlink!` | String file path → Unit |
| `mkdir!`, `rmdir!` | String directory → Unit |
| `make-temp-dir!` | String prefix → String created path |
| `real-path!` | String path → String |
| `pid`, `uptime` | () → Number |
| `platform`, `node-version` | () → String |
| `env-get` | String → Option<String> |
| `import-meta-url` | () → String |
| `buffer-from-string` | String → BufferHost |
| `buffer->string` | BufferHost → String |

The original filesystem calls are synchronous and use UTF-8 for text. They preserve native
exceptions (including ENOENT and ENOTEMPTY). `write-text!` overwrites existing
files; `copy-file!` follows Node's default overwrite behavior. `mkdir!` creates
one directory and `rmdir!` removes only empty directories. `unlink!` unlinks a
file or symlink. No adapter performs recursive deletion. `make-temp-dir!`
appends a random suffix to its prefix; join the system temporary directory
with a filename prefix first. Path operations follow the running platform's rules.
The two async text adapters await `node:fs/promises` exactly once and normalize
both synchronous throws and Promise rejections into `Result.err<JsError>`.

## Boundary and validation policy

Primitive values from untyped globals and Node module functions pass through
`contract/expect-*`. Typed trait members rely on the declared host capability;
they do not turn arbitrary caller-provided JavaScript objects into validated
objects. Only five small boundary adapters add `unsafe-coerce`: URL,
URLSearchParams, Headers, AbortController and Response. Their native values
establish the host
identity, and the tests exercise the consumed members in both environments.
The baseline allows one assertion in each constructor and preserves every
zero-tolerance metric.

`yarn check:api` uses Calcit's target-aware public checker to discover and
preprocess all public definitions directly, without running filesystem or
browser effects or creating a synthetic reference root. Runtime tests call the
compiled adapters and check native effects, nullish lookup,
Unicode, exception propagation, callback identity and cancellation. Negative
consumer fixtures ensure direct and aliased missing-await calls, an
async-to-sync callback mismatch, and the existing invalid host calls fail type
checking.

Run all checks with `yarn test`. Install Chromium once using
`yarn playwright install chromium` (`--with-deps` on Linux CI). Individual
commands are `yarn test:types`, `yarn test:node`, and `yarn test:browser`.
Browser tests start a local Vite server on an available port, launch Chromium,
assert in a real page, and close both resources even when assertions fail.
They require no external service or internet request.

API semantics follow the [Node filesystem documentation](https://nodejs.org/api/fs.html),
[URLSearchParams reference](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams),
and [AbortController reference](https://developer.mozilla.org/en-US/docs/Web/API/AbortController).
