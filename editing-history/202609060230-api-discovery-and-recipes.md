# API discovery and executable recipes

Replaced the two hand-maintained check-api! lists with target-aware discovery
of all 149 public definitions. The checker copies the snapshot and deps into a
temporary directory, injects complete references with Calcit edit/tree, and
preprocesses or compiles without modifying the checked-in snapshot. Node checks
86 definitions and browser checks 117; the shared/contract definitions overlap.

Added a deterministic JSON and Markdown catalog containing import rules,
schemas, full host traits/FFI metadata and recipe links. Offline JSON search
filters by task and runtime. Generation also builds a cookbook from three
ordinary Calcit recipes: query-string encoding, UTF-8 file access and browser
event cleanup. Tests run the compiled recipe definitions in Node and Chromium.

Validation: yarn test passed, including catalog drift checks, discovery of an
unused invalid definition, all-public preprocessing, static quality, existing
negative consumer fixtures, five Node runtime tests, and 71 browser assertions.
The production browser build, snapshot formatting and git diff --check passed.
Generated catalog equality was checked across separate CLI processes.

Calcit requests were filed without modifying the compiler:

- https://github.com/calcit-lang/calcit/issues/873 — async invocation contracts.
- https://github.com/calcit-lang/calcit/issues/874 — all-public-definition checks.
- https://github.com/calcit-lang/calcit/issues/875 — full machine-readable FFI metadata.

The metadata generator works around truncated query-def FFI strings by using
Calcit's own EDN parser on the authoritative snapshot. Toolchain remains 0.13.77;
no additional npm dependency or new FFI type syntax was introduced.
