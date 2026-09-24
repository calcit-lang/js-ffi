# WebGPU 能力探测与设备所有权

公开入口是浏览器 Calcit 命名空间 `js-ffi.webgpu-capabilities/probe-device!`，接收 `NavigatorHost`（或 nullish 测试宿主），异步返回封闭 `DeviceProbe`：`:unavailable ProbeUnavailable`、`:failed ProbeFailure` 或 `:ready ReadyDeviceHost`。`webgpu-capabilities.mjs` 只是同包内部宿主实现，下游 Calcit 项目不应直接导入它。`probeWebGpuDevice` 导入模块时不读取宿主，只请求默认 adapter/device，不猜测性能等级，也不自动重试。

Node 或无 WebGPU 的浏览器返回 `:unavailable`，阶段为 `gpu`；adapter 返回 `null` 时阶段为 `adapter`。同步异常、Promise 拒绝和损坏的宿主形状返回 `:failed`，字段为 `stage/message`，`stage` 可为 `gpu`、`adapter`、`format`、`device`、`device-shape`。这些状态应让调用方选择并记录 Canvas 回退，而不是把不可用当作 GPU 测试通过。

`:ready` 携带 `ReadyDeviceHost`，包含 `adapter/device/format/lost/state/release`。`format` 仅接受 `rgba8unorm` 或 `bgra8unorm`。调用方拥有这次探测创建的 device，完成使用后必须调用 `release()`；重复调用返回 `false`。`state` 从 `ready` 变为 `lost` 或 `released`。`lost` Promise 归一化为 `{reason, message}`，包括异常的拒绝值。主动释放后的 `lost` 通知不会把状态从 `released` 改回去。设备形状校验失败时，若对象有 `destroy()`，边界尝试清理。

此接口只提供探测与所有权协议，不配置 canvas、不创建 buffer/pipeline，也不进行绘制。设备丢失后的重建、资源表重放、Canvas/WebGPU 切换属于调用方。`ready` 也不证明硬件吞吐，或保证设备在下一帧仍可用。真实 WebGPU 渲染必须另外验证 GPU 画面、错误作用域和回退。

`tests/webgpu-capabilities.mjs` 保留底层宿主行为测试；`tests/webgpu-calcit-capabilities.mjs` 在 Node 与 Chromium 检查编译后的 Calcit 三分支、设备丢失和幂等释放，浏览器另做实际宿主探测。真实宿主不可用时保留明确的不可用状态。规范依据：[GPU](https://gpuweb.github.io/types/interfaces/GPU.html)、[GPUAdapter](https://gpuweb.github.io/types/interfaces/GPUAdapter.html)、[GPUDevice](https://gpuweb.github.io/types/interfaces/GPUDevice.html)。
