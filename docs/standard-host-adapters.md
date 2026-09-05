---
title: "Standard host adapters"
summary: "Typed URL, Headers, abort, DOM, timers, process, paths and synchronous UTF-8 filesystem adapters"
scope: "module"
kind: "reference"
category: "ffi"
entry_for:
  - "js-ffi.shared"
  - "js-ffi.browser"
  - "js-ffi.node"
---

# Standard host adapters

These 54 adapters extend the existing host contracts. Import `js-ffi.shared`
with either `js-ffi.browser` or `js-ffi.node`. The package retains no native
objects in application state automatically; constructors explicitly return
named host capabilities, and missing lookups return `Option`.

Development and CI use Node.js 24 (Vite requires Node.js >=22.12 here) and
Playwright Chromium. Runtime helpers use standard APIs; the browser needs
URLSearchParams.size, Headers, AbortController, performance and requestAnimationFrame.

## Shared APIs (22 adapters)

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

## Node APIs (21 adapters)

| Function | Parameters → result |
| --- | --- |
| `path-basename`, `path-dirname`, `path-extname`, `path-normalize` | String path → String |
| `path-resolve`, `path-relative` | String base, String child → String |
| `path-absolute?` | String path → Bool |
| `read-text!` | String path → String |
| `write-text!`, `append-text!` | String path, String text → Unit |
| `copy-file!`, `rename!` | String source, String destination → Unit |
| `unlink!` | String file path → Unit |
| `mkdir!`, `rmdir!` | String directory → Unit |
| `make-temp-dir!` | String prefix → String created path |
| `real-path!` | String path → String |
| `pid`, `uptime` | () → Number |
| `platform`, `node-version` | () → String |

Filesystem calls are synchronous and use UTF-8 for text. They preserve native
exceptions (including ENOENT and ENOTEMPTY). `write-text!` overwrites existing
files; `copy-file!` follows Node's default overwrite behavior. `mkdir!` creates
one directory and `rmdir!` removes only empty directories. `unlink!` unlinks a
file or symlink. No adapter performs recursive deletion. `make-temp-dir!`
appends a random suffix to its prefix; join the system temporary directory
with a filename prefix first. Path operations follow the running platform's rules.

## Boundary and validation policy

Primitive values from untyped globals and Node module functions pass through
`contract/expect-*`. Typed trait members rely on the declared host capability;
they do not turn arbitrary caller-provided JavaScript objects into validated
objects. Only the four constructors add `unsafe-coerce`: URL, URLSearchParams,
Headers and AbortController. Their native constructors establish the host
identity, and the tests exercise the consumed members in both environments.
The baseline allows one assertion in each constructor and preserves every
zero-tolerance metric.

`yarn check:api` automatically discovers all public definitions and makes them
reachable in temporary check snapshots without running filesystem or browser
effects. No per-function reference list is maintained by hand. Runtime
tests call the compiled adapters and check native effects, nullish lookup,
Unicode, exception propagation, callback identity and cancellation. Negative
consumer fixtures ensure four invalid calls fail type checking.

Run all checks with `yarn test`. Install Chromium once using
`yarn playwright install chromium` (`--with-deps` on Linux CI). Individual
commands are `yarn test:types`, `yarn test:node`, and `yarn test:browser`.
Browser tests start a local Vite server on an available port, launch Chromium,
assert in a real page, and close both resources even when assertions fail.
They require no external service or internet request.

API semantics follow the [Node filesystem documentation](https://nodejs.org/api/fs.html),
[URLSearchParams reference](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams),
and [AbortController reference](https://developer.mozilla.org/en-US/docs/Web/API/AbortController).
