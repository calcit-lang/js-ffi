# Canvas2D 类型化基础接口与批次迁移

从 0.2.0-alpha.1 起，`js-ffi.canvas-batches` 只提供 Calcit 类型化的 `CanvasContextHost`、`CanvasAffine2D`、`CanvasRect` 和基础组合 `fill-solid-rect!`、`fill-transformed-clipped-rect!`、`clear-canvas!`。这些操作直接映射浏览器 Canvas2D 的 save/restore、fillRect、clearRect、setTransform、transform、beginPath、rect、clip、fillStyle，不解释 Quamolit Scene IR。

旧 `draw-rects!`、`draw-transformed-clipped-rects!` 和 `canvas-rect-batches.mjs` 已迁出 js-ffi。Quamolit 的真实 10k 实例消费者现在通过 Calcit `quamolit.instance-ffi/draw-canvas!` 调用 Quamolit 仓库的 `src/host/canvas-rect-batches.mjs`；该宿主循环保留一次批次提交、预检、状态恢复和逐矩形 Canvas 调用。0.2.0-alpha.2 起，`CanvasRectMetrics` 也由 Quamolit 自行定义。

`fill-transformed-clipped-rect!` 会改写 Canvas 当前 path；path 不属于 save/restore 状态。调用方负责有效坐标和尺寸，它不是“整场景预检后原子绘制”接口。js-ffi 的浏览器测试验证基础原语的像素、样式和变换；批次/脏范围/10k 实例测试迁到 Quamolit。此归属迁移不声称性能提升。0.1.x 已发布 tag 保持不变。
