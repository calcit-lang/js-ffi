# Adopt target-aware public checks

Calcit issue: https://github.com/calcit-lang/calcit/issues/913

Candidate core: `e5141efaf75492ed60474d8202580143dae82893` (merged implementation for calcit-lang/calcit#874; still reports version 0.14.4 before the 0.14.5 release).

## Changes

- Replaced the check-only temporary Snapshot copy and synthetic reference-root injection with `calcit analyze check-public` for the Node and browser entry targets.
- Kept temporary recipe/reference generation only in `compile:node` and `compile:browser`, where generated consumer code is still required.
- Added fail-closed envelope validation, complete checked-ID comparison against discovery, unused invalid-definition coverage, wrong-target rejection including data/trait rows, and candidate-aware type-contract tests.
- Pinned CI temporarily to the exact unreleased core commit. Before merging this consumer change, replace that build with the published 0.14.5 toolchain and matching `@calcit/procs`/`deps.cirru` pins.

## Candidate evidence

Measured on macOS with the candidate debug binary and the same 171-definition Snapshot:

- Previous synthetic-root check: 92 Node + 137 browser definitions, 3176.7 ms, 128 stdout bytes.
- New direct check wrapper: the same 92 Node + 137 browser definitions, 615.8 ms, 112 stdout bytes (about 81% less wall time).
- Raw structured reports: Node 16,505 bytes / 55.5 ms analysis; browser 25,802 bytes / 104.3 ms analysis.
- Both reports include all discovered IDs and data/trait declarations. A Node check of the browser namespace rejects the scope before checking any definition.

Validation:

- `CALCIT_BIN=/private/tmp/calcit-874/target/debug/calcit yarn check:api`
- `CALCIT_BIN=/private/tmp/calcit-874/target/debug/calcit yarn test:tooling` (8/8)
- `CALCIT_BIN=/private/tmp/calcit-874/target/debug/calcit yarn test:types` (11 invalid consumers rejected, including async contracts)
- `CALCIT_BIN=/private/tmp/calcit-874/target/debug/calcit yarn compile:node`
- `CALCIT_BIN=/private/tmp/calcit-874/target/debug/calcit yarn compile:browser`
- `CALCIT_BIN=/private/tmp/calcit-874/target/debug/calcit yarn test`: all checks through Node runtime passed; local browser launch is unavailable under Node 20, while the repository and CI require Node 24.
