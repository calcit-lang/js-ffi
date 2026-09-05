# Standard JavaScript host adapters

Added 54 typed public adapters: 22 shared Web APIs, 21 Node process/path/file
APIs, and 11 browser DOM/timer/frame APIs. All definitions declare concrete
schemas and the JavaScript FFI feature; DOM JavaScript member names are now
explicit. Both smoke entries reference the new surface so preprocessing checks
all added definitions without executing filesystem effects.

The four new unsafe assertions are confined to native URL, URLSearchParams,
Headers and AbortController construction. Runtime tests exercise their consumed
capabilities in Node and Chromium. The quality baseline increases from 30 to
34 assertions with one allowed site per new constructor; all other metrics
remain zero. Typed host member readers bind the field before returning it to
keep their emitted JavaScript return explicit.

Added reusable Node and real-browser tests, invalid-consumer type checks,
Playwright with a pinned lockfile, CI Chromium installation, and API reference
with signatures and exception behavior. File operations are synchronous UTF-8
adapters; native filesystem errors propagate and directory deletion is empty-only.

Validation on Calcit 0.13.77 and Node.js 24.19.0:

- `yarn install --immutable` passed.
- `yarn test` passed: default/Node/browser type checks and quality gate;
  4 invalid consumer fixtures rejected; existing smoke/contract checks;
  63 extended Node assertions and 67 real Chromium assertions.
- `yarn build:browser` passed.
- `calcit analyze check-types --summary-only`: all 155 definitions full.
- `calcit edit format` made no changes; `git diff --check` passed.

Run `yarn playwright install chromium` before the first local browser test.
See `docs/standard-host-adapters.md` for the public API and runtime contracts.
