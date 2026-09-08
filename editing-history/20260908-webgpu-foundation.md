# WebGPU foundation

First browser-only WebGPU slice on released Calcit/procs 0.14.2. Adds 16 public
definitions: four host traits, DeviceLost, and eleven functions. No version bump
or release before review/merge. All code lives in the single calcit.cirru snapshot,
edited through Calcit CLI; no compact.cirru or compatibility mode was introduced.

API catalog now discovers 165 definitions (86 Node / 133 browser, overlapping
shared types), and four executable recipes. Added adapter/device callback APIs,
device-loss observation, validation scopes, and unmapped buffer lifecycle.
Canvas, shader, queue, pipeline and buffer mapping remain follow-up work.

Reviewed unsafe budget changes are exactly one each in the five internal
gpu-host, adapter-host, device-host, buffer-host and promise-host decoders.
Each checks an object and every required callable method before coercion. Tests
reject null, empty objects and individually non-callable members. Host fields
are checked when consumed. Other quality budgets remain zero; unsafe total 34 -> 39.

Validation: full yarn test passes, including seven invalid consumer type cases,
Node and shared contracts, and 149 Chromium assertions. Native GPU smoke is
explicitly SKIP (no adapter on this headless host), not counted as GPU validation.
The deterministic tests cover Promise success/rejection, null adapter, malformed
resolved values, missing globals, receiver binding, callbacks, loss struct fields,
error scopes, invalid buffer numbers, cleanup, and the compiled Calcit recipe.

Reported core js-object strict-check regression as
https://github.com/calcit-lang/calcit/issues/920 with a reproduced minimal case.
Descriptors use the supported &js-object primitive until the macro is fixed.
