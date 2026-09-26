# Canvas2D 类型化基础接口与批次迁移

## 原生路径描边（待下一版本发布）

`CanvasContextHost` 新增 `.move-to!` / `.line-to!`（两个 Number）、`.close-path!` / `.stroke!`（无参数），均返回 Unit。新增可读写字段 `:stroke-style`、`:line-cap`、`:line-join`（String）和 `:line-width`、`:miter-limit`（Number）。它们直接映射浏览器原生属性和方法，不增加 JS wrapper、路径解释器、动画采样或 Quamolit 类型。

`examples/canvas-path.cirru` 是独立 Calcit 消费者：通过类型化方法调用和 `js-set` 绘制折线，可以选择线帽、连接与闭合。无需引用任何 JS 文件。它是测试/使用示例，不是新增公共场景渲染接口。

边界约定：

- `stroke-style` 和既有 `fill-style` 只声明纯色字符串子集，不覆盖 CanvasGradient/CanvasPattern。
- `line-cap` 原生有效值为 `butt/round/square`，`line-join` 为 `miter/round/bevel`。字符串拼写、CSS 颜色及有限正数宽度/斜接限制由调用方负责；类型检查不等于值域校验，非法值沿用浏览器忽略赋值等原生语义。
- `.begin-path!` 清空当前路径；`save/restore` 恢复样式、变换和裁剪，**不恢复路径**。调用方需要独占当前路径或明确约定其生命周期。例程执行正常合法调用，不提供任意宿主异常下的事务保证。
- 新成员是原生对象能力扩展；手写 Canvas 假宿主若使用新能力，必须补齐相应方法/属性。旧矩形 API 的签名和调用行为不变。

检验：`yarn test:browser` 对三种线帽 × 三种连接 × 开放/闭合的 18 种组合，在非恒等外部变换与裁剪下逐像素对照独立原生 Canvas；检查调用前后状态、当前路径重描与九种开放路径形状的可区分性。`yarn test:types` 拒绝新方法的错误类型/参数数量和字段错误写入。`yarn api:generate && yarn test` 覆盖 API 目录、全公共入口和已有功能。

Quamolit 应在本改动合并、发布新 tag 后更新依赖，再将原树每个分叉作为一条连接路径恢复圆头/圆连接；其树形采样、Scene IR、保留计划和 GPU 降级策略仍属于 Quamolit。本切片不宣称动画完整恢复或性能提升。

从 0.2.0-alpha.1 起，`js-ffi.canvas-batches` 只提供 Calcit 类型化的 `CanvasContextHost`、`CanvasAffine2D`、`CanvasRect` 和基础组合 `fill-solid-rect!`、`fill-transformed-clipped-rect!`、`clear-canvas!`。这些操作直接映射浏览器 Canvas2D 的 save/restore、fillRect、clearRect、setTransform、transform、beginPath、rect、clip、fillStyle，不解释 Quamolit Scene IR。

旧 `draw-rects!`、`draw-transformed-clipped-rects!` 和 `canvas-rect-batches.mjs` 已迁出 js-ffi。Quamolit 的真实 10k 实例消费者现在通过 Calcit `quamolit.instance-ffi/draw-canvas!` 调用 Quamolit 仓库的 `src/host/canvas-rect-batches.mjs`；该宿主循环保留一次批次提交、预检、状态恢复和逐矩形 Canvas 调用。0.2.0-alpha.2 起，`CanvasRectMetrics` 也由 Quamolit 自行定义。

`fill-transformed-clipped-rect!` 会改写 Canvas 当前 path；path 不属于 save/restore 状态。调用方负责有效坐标和尺寸，它不是“整场景预检后原子绘制”接口。js-ffi 的浏览器测试验证基础原语的像素、样式和变换；批次/脏范围/10k 实例测试迁到 Quamolit。此归属迁移不声称性能提升。0.1.x 已发布 tag 保持不变。
