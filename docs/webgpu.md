# WebGPU foundation

`js-ffi.webgpu` is browser-only. Import it as `webgpu`; importing the module
does not access `navigator`. Call `gpu` to get `Option<GpuHost>`: `none` means
the browser/context does not expose WebGPU (secure-context restrictions apply).
Availability is not a promise that an adapter or usable device can be allocated.

## Public operations

| API | Result / callback |
| --- | --- |
| `gpu ()` | `Option<GpuHost>` |
| `preferred-canvas-format (gpu)` | `String` |
| `request-adapter! (gpu ready! failed!)` | `ready!: Option<AdapterHost> -> Unit` |
| `request-device! (adapter ready! failed!)` | `ready!: DeviceHost -> Unit` |
| `watch-device-lost! (device ready! failed!)` | `ready!: DeviceLost -> Unit` |
| `create-buffer (device size usage)` | `BufferHost` |
| `buffer-size (buffer)` | byte size as `Number` |
| `destroy-buffer! (buffer)` | `Unit` |
| `destroy-device! (device)` | `Unit` |
| `push-validation-scope! (device)` | `Unit` |
| `pop-error-scope! (device ready! failed!)` | `ready!: Option<String> -> Unit` |

All callback APIs return `Unit`, not a device disguised as a Promise.
`failed!` accepts a `String` and returns `Unit`. Native Promise rejections and
success-value decoding failures are delivered there. Synchronous host throws
and malformed Promise capabilities throw synchronously. Callbacks must return
`Unit` and must not throw; a thrown success callback is routed to `failed!`,
but a throwing failure callback can cause an unhandled rejected Promise.
If a rejection value cannot be converted to a string, `failed!` receives the
stable fallback `WebGPU.error-unprintable`.

The buffer lifecycle recipe releases its buffer on both successful reads and
size-read failures. A read failure is reported as
`WebGPU.buffer-lifecycle.failed-to-read-size` after cleanup; cleanup errors
themselves propagate and are not retried.

Only default adapter/device options are supported in this first slice. Request
a device once per adapter. Observe `device.lost` with `watch-device-lost!`;
`DeviceLost` copies string `reason` and `message`, preserving future reason strings.
There is no automatic retry, recovery, or listener cancellation.

Buffer size is a nonnegative safe integer in bytes; usage is a nonzero mask of
known `GPUBufferUsage` bits (1 through 512). Buffers are initially unmapped.
WebGPU validates combinations and device limits. Pair push/pop validation scopes
even when buffer creation succeeds: an invalid GPU resource need not throw.
`pop-error-scope!` delivers `none` for no captured error, or its message; a
rejected pop is a failure, not a clean scope. Destroy buffers/devices explicitly.

## Boundary and verification

Five internal host decoders validate object identity and required callable
members before coercion to external traits. Fields are checked when consumed.
These are capability checks, not native brand checks; forged objects still need
to obey the documented methods. No `Dynamic`, compatibility mode, or unchecked
Promise-to-device conversion is introduced.

`tests/webgpu.mjs` covers deterministic host doubles separately from a native
browser device/buffer smoke test. Native availability skips are reported explicitly.
Shaders, canvas configuration, queues, pipelines, mapping and rendering examples
are follow-up work; this module does not yet provide a rendering abstraction.

Descriptors currently use the supported `&js-object` primitive: Calcit 0.14.2's
`js-object` macro triggers an `every?` predicate type mismatch under strict checking
([Calcit #920](https://github.com/calcit-lang/calcit/issues/920)).

References: [GPUWeb GPU](https://gpuweb.github.io/types/interfaces/GPU.html),
[GPUDevice](https://gpuweb.github.io/types/interfaces/GPUDevice.html),
[GPUBuffer](https://gpuweb.github.io/types/interfaces/GPUBuffer.html).
