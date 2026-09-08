# Consume complete definition-query metadata

- Replace the legacy `query def --raw --json` marker parser with Calcit's versioned `query.def` JSON envelope.
- Decode structured `data.ffi` directly from the query response; keep authoritative Snapshot parsing only for persisted `schemaData`, which the query contract does not expose.
- Fail closed on an unsupported envelope, command, or mismatched definition ID.
- Cover large host member maps, absent FFI metadata, Unicode, escaping, tagged values, sets, and nested keys.
- Keep the catalog schema and generated record fields stable while removing the truncated-metadata workaround tracked by calcit-lang/calcit#875 and #909.

Candidate verification against Calcit main `c1818fd4`: 165 public API records and 4 recipes; exact catalog parity with the legacy generator except the intentional inspect-command update; node 86/browser 133 definitions type-checked; 7 invalid consumers rejected; Node runtime checks and 151 system-Chrome assertions passed, including native WebGPU. `DomElementHost` query output is 2,597 bytes versus 3,712 legacy bytes, with same-profile process medians of 53.22 ms and 51.51 ms respectively.
