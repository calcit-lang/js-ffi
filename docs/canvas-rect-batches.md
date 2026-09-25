# Canvas2D Float32 矩形批量边界

公开入口是浏览器 Calcit 命名空间 `js-ffi.canvas-batches/draw-rects!`，接受 `CanvasContextHost`、`js-ffi.typed-arrays/Float32ArrayHost`、实例范围和矩形样式，返回类型化 `CanvasRectMetrics`。`canvas-rect-batches.mjs` 仅为同包内部宿主实现，下游 Calcit 模块不应直接引用它。

同一 `CanvasContextHost` 类型化浏览器原生的 `save`、`restore`、`fillRect`、`clearRect`、`setTransform`、`transform`、`beginPath`、`rect`、`clip` 和可写纯色 `fillStyle`。Calcit 可直接调用这些方法编排绘制；`fill-solid-rect!`、`fill-transformed-clipped-rect!` 与 `clear-canvas!` 是通用 Calcit 组合，不解释 Quamolit 的 Scene IR。`CanvasAffine2D` 保存六系数矩阵，`CanvasRect` 保存基础矩形。裁剪组合按当前变换定义局部矩形，随后恢复变换、裁剪和 fillStyle；但 Canvas 当前路径不属于 save/restore 状态，组合调用会改写当前路径。调用方负责提供有效坐标/尺寸，它不是“整场景预检后原子绘制”的接口。浏览器测试用真实 Canvas 像素、裁剪外背景、样式及变换恢复验证方法映射。图像、复杂路径与隔离组透明度仍待独立宿主契约。

`positions` 是交错 x/y 的 `Float32Array`，`start` 与 `count` 按矩形计数；一次 JavaScript 边界调用绘制一个连续范围。宿主实现校验范围、有限坐标、尺寸和透明度，拒绝共享内存，然后在 `save/restore` 作用域内按输入顺序调用 Canvas2D `fillRect`，不改变调用者的样式状态。返回的 `CanvasRectMetrics` 含 `boundary-calls`、`canvas-calls`、`instances`、`position-bytes-read`；其中 `boundary-calls=1`、`canvas-calls=count`、`position-bytes-read=count*8` 是本次读取量，**不是 GPU 上传字节数**。

本 API 只合并 Calcit/应用到 JavaScript 宿主的跨边界调用，**不减少 Canvas2D 的逐矩形调用**，不提供自动合批、裁剪或组透明度，也不承诺 WebGPU 性能。适合基础 Canvas 参考路径和 #35 调用量验证；真正低 draw-call 的 WebGPU instances 路径由后续工作项建立。调用者可将 `typed-arrays.mjs` 的不可变快照在版本切换时复制一次、缓存副本，再逐帧按范围绘制；不要每帧重新复制或逐标量跨边界读取。

`yarn test` 在 Node 假上下文检查参数、调用次数与状态恢复，在固定 Chromium 中检查实际像素。浏览器缺失会使测试失败；WebGPU 另行声明 skip，不能由本测试替代。
