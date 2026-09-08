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

Candidate validation used Calcit PR #924 head
`8a26fe854d654c5b44e0f70eb3befed753f20e50` (merged to main as
`79b51b8b930059979d4184bf0f44319cd3c86a92`) against js-ffi main
`072f7a48c5cfdeea8c3e089b215718a081118c83`. The candidate CLI still reports
0.14.3; final dependency pins are intentionally deferred until Calcit 0.14.4
and the matching `@calcit/procs` package are published.

Runtime evidence uses a local HTTP server, Vite on a random loopback port,
Playwright Chromium, and temporary files. It covers Node and browser success,
network rejection, synchronous body throw, Promise body rejection, consumed
body failure, ENOENT, and the absence of unhandled rejections.
