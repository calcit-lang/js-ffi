---
title: "Checked async adapters"
summary: "Await fetch, Response bodies and Node filesystem promises exactly once and handle failures as Result"
scope: "module"
kind: "guide"
category: "ffi"
entry_for:
  - "js-ffi.shared"
  - "js-ffi.node"
---

# Checked async adapters

Async adapter schemas describe the logical value after awaiting. Calling one
produces a pending value, so use `js-await` before matching its `Result`.
Direct calls, aliases, and callback values retain this contract; using the
pending value as `T` fails with `E_ASYNC_INVOCATION_REQUIRES_AWAIT`.

```cirru
defn fetch-text (url)
  hint-fn $ {} (:async true)
  tag-match
      js-await $ shared/fetch-response url
    (:ok response)
      js-await $ shared/response-text response
    (:err error)
      %:: Result :err error
```

Node text I/O follows the same rule:

```cirru
defn replace-text! (path text)
  hint-fn $ {} (:async true)
  tag-match
      js-await $ node/write-text-async! path text
    (:ok _)
      js-await $ node/read-text-async! path
    (:err error)
      %:: Result :err error
```

Each adapter invokes its host operation once. Fetch rejection, Response body
failure (including a second read), and filesystem rejection become
`Result.err<JsError>`; no adapter retries. Synchronous `read-text!` and
`write-text!` remain available with their native throw behavior.

`response-host` checks every concrete `ResponseHost` member, including the
Headers method capability, before exposing the typed host value. Error objects
with absent names use `Error`; absent messages fall back to `String(error)`.

Validation uses the released Calcit 0.14.4 CLI and matching
`@calcit/procs` 0.14.4 package. The release is built from
`383917609c3adeeb575c7eb3f55aa37926619df4`; the async invocation fixes were
completed by Calcit PR #924.

Runtime evidence uses a local HTTP server, Vite on a random loopback port,
Playwright Chromium, and temporary files. It covers Node and browser success,
network rejection, synchronous body throw, Promise body rejection, consumed
body failure, ENOENT, and the absence of unhandled rejections.
