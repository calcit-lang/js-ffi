# 平台 API 归属与宿主实现清单

本清单审查 0.1.47 的公共 Calcit 入口与包内 JavaScript。判定依据是可否独立于 Quamolit 的 Scene/Motion 数据格式复用，不是 JS 行数。Calcit 消费方只导入公共命名空间；`.mjs` 是本包内部宿主实现，除入口/测试外不要求下游直接导入。`nodeLinker` 保持 `node-modules`。已发布的 0.1.45/0.1.46 tag 不改写。

| 能力 | 公共 Calcit 入口 | 包内 JS 与保留原因 | 失败、状态或释放契约 | 结论 |
| --- | --- | --- | --- | --- |
| DOM、事件、定时器、Fetch、Node 基础 API | `js-ffi.browser`、`js-ffi.shared`、`js-ffi.node` 等 | 大部分直接类型化原生对象/方法；少量宿主桥接由运行时提供 | 按 `Option`/`Result` 与显式 cleanup 处理缺失、异常和监听释放 | 通用基础 API，继续在 js-ffi |
| Float32 快照 | `js-ffi.typed-arrays` | `typed-arrays.mjs` 检验同 realm、共享内存、有限值并复制；运行时 Float32Array/ArrayBuffer 语义不能靠纯数据 Struct 代替 | 原源修改不影响快照；越界拒绝；拷贝范围明确 | 通用基础 API，JS 只保留宿主数据操作 |
| Canvas2D 原生操作与矩形批次 | `js-ffi.canvas-batches` | save/restore、仿射变换、路径矩形、裁剪、清屏与简单矩形由 Calcit 类型化/编排；`canvas-rect-batches.mjs` 保留一次边界的 Float32 循环和预检 | 简单方法遵循原生 Canvas 语义；批次先校验再绘制，恢复绘制状态；调用次数不是 GPU draw call | 通用基础 API；不包含 Scene 遍历 |
| Canvas 整场景命令 | `js-ffi.canvas-scene` | `canvas-scene-commands.mjs` 同时实现通用画布操作和特定 `push/pop/rect/instances` 命令解释 | 先整单校验；不支持隔离组透明度；保留旧兼容，不建议新消费者依赖格式 | 实验兼容债务；后续拆分，专属场景 lowering 留给下游 |
| WebGPU 能力探测 | `js-ffi.webgpu-capabilities` | `webgpu-capabilities.mjs` 处理异步 adapter/device、丢失与异常；浏览器 GPU 句柄无法作为普通 Calcit 数据重建 | `ready/unavailable/failed` 封闭结果；ready 设备所有权与 release 显式 | 通用基础 API |
| WebGPU 矩形实例资源 | `js-ffi.webgpu-batches` | `webgpu-rect-batches.mjs` 创建 pipeline/buffer、上传 Float32 范围、提交 draw 与有界诊断读回；Shader/GPU 资源操作需宿主实现 | 显式 dispose；脏范围上传与逐帧 uniform 字节数可测；无硬件时不得宣称 GPU 验收 | 通用矩形实例原语；Quamolit 的资源版本、动画 lowering 和后端策略不进入本包 |

本次在 Quamolit 当前源码中检索 `js-ffi.canvas-scene`、`draw-scene!` 与 `canvas-scene-commands`，只发现架构文档提及，没有运行时代码导入；这不证明其他下游无人使用，故旧接口继续兼容。下一步调查其他真实消费者并提供迁移样例，再决定实验接口的弃用期限；扩展 WebGPU 时优先补原生 GPU 对象的 Calcit 类型化能力，只有实际需要的资源/异步操作保留 JS。新增通用接口至少需严格公共类型检查、非 Quamolit 的 Calcit 用例、Node/浏览器错误路径及像素/资源测试。任何性能说法需附帧时间、调用次数和复制/上传字节，不从语言实现比例推断。
