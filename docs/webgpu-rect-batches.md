# WebGPU 矩形渲染器归属迁移

`webgpu-rect-batches.mjs` 不只是浏览器 WebGPU 原生对象包装：它内置矩形 WGSL、线性/smoothstep Vec2 时间位移、白底清屏、单层资源与有界诊断读回。公开代码检索和工作区消费点均指向 Quamolit 的实例图层。因此 0.2.0-alpha.1 将该 JS 渲染器迁往 Quamolit `src/host/webgpu-rect-batches.mjs`，由 Calcit `quamolit.webgpu-batches/create!` 创建和管理；js-ffi 不再导出 `create-rect-batch!` 或底层 JS 文件。

0.2.0-alpha.2 进一步移除旧 `js-ffi.webgpu-batches` 命名空间及其 `RectBatchHost`、`RectColor`、`RectFrame`、`RectMetrics` 等类型和封送辅助。Quamolit 已在 `quamolit.webgpu-batches` 定义自己的 Calcit Struct/Trait，并继续通过 `js-ffi.typed-arrays` 和 `js-ffi.webgpu` 使用原生浏览器能力。新项目不应把历史矩形图层契约当成通用 WebGPU 框架；原生 GPU 能力由 `js-ffi.webgpu` 与 `js-ffi.webgpu-capabilities` 提供。

Quamolit 保留 10k 实例、脏范围上传、资源释放和 GPU 诊断测试。没有真实非软件 adapter 时，跳过的 GPU 测试不是硬件正确性或性能证明。历史 0.1.x 和 0.2.0-alpha.1 tag 不改写；升级到 0.2.0-alpha.2 的消费者需迁移类型和构造入口。
