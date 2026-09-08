# Validate checked async adapters

- Add `fetch-response` and `response-text` as checked async wrappers over the
  shared fetch/Response boundary. The raw `Response.text` member remains an
  opaque Promise-like `JsObject`; only the wrapper exposes the awaited String.
- Add Node `read-text-async!` and `write-text-async!` adapters over
  `node:fs/promises`, retaining the existing synchronous APIs.
- Normalize synchronous throws and Promise rejections into the existing
  `Result<T, JsError>` model without retries or duplicate host calls.
- Reject direct and aliased missing-await use, async-to-sync callback passing,
  and unawaited `response-text` during checking.
- Exercise local HTTP, consumed/synchronous/rejected body readers, temporary
  UTF-8 files, ENOENT, network rejection, and unhandled-rejection cleanup in
  Node and real Chromium.

Candidate verification used Calcit PR #924 head
`8a26fe854d654c5b44e0f70eb3befed753f20e50`, merged to main as
`79b51b8b930059979d4184bf0f44319cd3c86a92`, against js-ffi main
`072f7a48c5cfdeea8c3e089b215718a081118c83`. `yarn test` passed with
171 public API records, 92 Node and 137 browser public-definition checks, 11
invalid consumers rejected, 12 async Node assertions, and 165 Chromium
assertions. Static quality remains zero for Dynamic, nil, unresolved, and
other strict metrics; one validated Response host narrowing raises the audited
explicit-unsafe total from 39 to 40. Final Calcit and `@calcit/procs` 0.14.4
pins remain deferred until those artifacts are published.
