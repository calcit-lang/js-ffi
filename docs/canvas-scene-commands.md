# Canvas Scene 实验接口迁移

`js-ffi.canvas-scene` 与 `canvas-scene-commands.mjs` 在 0.1.45–0.1.48 中提供了 `push/pop/rect/instances` 命令解释。该格式不是浏览器原生 API，也不是通用 Calcit 语言功能；它把场景命令、Canvas 绘制和 DPR/背景策略捆在一起。

在检查当前 Quamolit 运行代码、同工作区项目与可检索的公开使用后，没有发现 Quamolit 实际消费这个旧命令接口。因此 0.2.0-alpha.1 从 js-ffi 移除它，**不把无人使用的解释器复制进 Quamolit**。Quamolit 的 Scene IR 与 Canvas 参考路径继续由 Quamolit 的 Calcit 代码定义；若未来需要完整组语义，在 Quamolit 按现有 Scene IR 实现，而不是复活旧命令格式。

外部消费者若仍依赖历史接口，可以固定 0.1.48；已发布 tag 不改写。此次移除属于破坏性变化，需按新版本显式迁移。Canvas 原生操作仍可通过 `js-ffi.canvas-batches` 的 Calcit 类型化接口访问。
