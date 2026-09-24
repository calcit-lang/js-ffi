# Canvas2D 整场景命令批次

公开 Calcit 入口 `js-ffi.canvas-scene/draw-scene!` 接收 Canvas 宿主句柄、`CanvasSceneCommandsHost`、逻辑宽高与 DPR，返回类型化 `CanvasSceneMetrics`。原始 `canvas-scene-commands.mjs` 只在 js-ffi 包内实现宿主效果，下游项目经 Calcit 模块消费。命令数组在宿主边界做完整预检；非法图元、非有限坐标、错误实例长度、失衡 group 等在更改画布前拒绝。

命令按预序平铺：`push` 带六个仿射系数、`none|rect` 局部裁剪和 opacity=1；`pop` 关闭最近 group；`rect` 带逻辑像素几何及 `[0,1]` 直通道 RGBA；`instances` 带交错 Float32 x/y、count、共享宽高和颜色。调用方保持 Scene IR 的绘制顺序，不能为合批重排透明对象。宿主在一个边界调用中调整实际画布像素宽高、清白底、按 DPR 设变换、执行组的 transform/clip 和绘制。每帧逐个实例 `fillRect`，所以边界调用 1 不等于 Canvas 绘制调用 1，也不代表 GPU draw call。

组 opacity<1 需要离屏隔离；当前明确抛错，不将其下推到重叠子节点。图片、圆、文字、路径及复杂 clip 尚不支持，调用方不得静默漏绘。`CanvasSceneMetrics` 记录 boundary/canvas 调用、group/rect/实例数和读取位置字节；不是 GPU 上传、执行时间或帧率。资源引用、版本快照和 Scene IR 降低属于消费方；js-ffi 不持有逻辑资源或 Model。
