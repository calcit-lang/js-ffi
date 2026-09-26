# 平台 API 归属与宿主实现清单

0.2.0-alpha.1 至 0.2.0-alpha.2 按当前实际消费者与能力边界重新审查。判断“只有 Quamolit 使用”依据为工作区源码和公开 GitHub 代码检索；不能证明不存在未公开消费者，因此删除入口使用新的 alpha 版本，旧 0.1.x 与 0.2.0-alpha.1 tag 保持不变。`nodeLinker` 继续使用 `node-modules`。

| 文件/能力 | 归属与证据 | js-ffi Calcit 入口 | 处理 |
| --- | --- | --- | --- |
| `typed-arrays.mjs` | Float32Array 的校验、快照和有界复制，属于通用 TypedArray 平台边界 | `js-ffi.typed-arrays` | 保留，宿主操作仍由本包 JS 完成 |
| `webgpu-capabilities.mjs` | 原生 adapter/device 获取、失败和释放的浏览器能力边界 | `js-ffi.webgpu-capabilities` | 保留 |
| Canvas2D 原生方法 | 浏览器 CanvasRenderingContext2D 的类型化映射，含文字绘制、TextMetrics 宽度投影及字体/对齐字段 | `js-ffi.canvas-batches` | 保留 Calcit trait 与基础组合，无专属 JS 文件；字体加载及非法值沿用浏览器语义 |
| `canvas-rect-batches.mjs` | 当前真实消费者为 Quamolit 的 10k 实例；循环、预检和指标不是原生 Canvas 方法 | Quamolit `quamolit.instance-ffi/draw-canvas!` | 迁至 Quamolit `src/host/`；0.2.0-alpha.2 移除旧指标类型 |
| `webgpu-rect-batches.mjs` | 当前真实消费者为 Quamolit；内含矩形 shader、Vec2 tween 与图层策略，不是原生 WebGPU 方法 | Quamolit `quamolit.webgpu-batches` | 迁至 Quamolit `src/host/`；0.2.0-alpha.2 移除旧 Calcit 类型/封送命名空间 |
| `canvas-scene-commands.mjs` | 场景命令解释器；当前 Quamolit 运行代码无消费者，格式不等于现行 Scene IR | 无 | 从 js-ffi 移除，不在 Quamolit 新增无人调用的旧实现 |

矩形类型现由 Quamolit 的自有 Struct/Trait 承担。性能结论必须附设备、帧时间、调用次数及复制/上传字节；本轮只验证归属和语义，没有宣称提速。
