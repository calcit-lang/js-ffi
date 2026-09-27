# Canvas2D 类型化基础接口与批次迁移

## 图像绘制与裁剪（#141）

`js-ffi.canvas-batches` 为 `CanvasContextHost` 与 `js-ffi.browser/ImageHost` 提供三个浏览器目标的类型化入口，分别对应原生 `drawImage` 的三、五、九参数形式：

- `draw-image-at! context image x y`：按图像固有尺寸绘制。
- `draw-image-sized! context image x y width height`：把完整图像缩放到目标矩形。
- `draw-image-crop! context image sx sy sw sh dx dy dw dh`：从来源矩形裁剪，并绘制到目标矩形。

公共 schema 使用 `CanvasContextHost`、`ImageHost`、`Number` 和 `Unit`，带 `:js-ffi` feature。实现直接经 external-object trait 降为浏览器原生 `context.drawImage(...)`，不增加 Scene、时间、切片或 JS snippet。调用方先用 `image-create`、`image-src!`、`image-decode!` 管理来源；`image-decode!` 的 `Result` 仍需显式处理。数值有效性、尚未就绪的图像及宿主异常保持浏览器行为，不由这里伪造默认值或额外包装异常。

Chromium 像素测试覆盖三个重载的红蓝色块、九参数裁剪和透明边界。测试还确认当前 Chromium 对零宽来源矩形、没有 `src` 的图像不绘制也不抛错，而把 `null` 当作图像参数会抛 `TypeError`；这些是浏览器实测结果，不是 Calcit 类型检查对运行时值域的保证。`yarn test:types` 验证错误图像类型、错误数值类型和缺参均在严格预处理阶段拒绝。

## 原生文字绘制与测量（#124）

`CanvasContextHost` 提供 `.fill-text! text x y`（`String, Number, Number -> Unit`）和
`.measure-text text`（`String -> CanvasTextMetricsHost`）。后者只公开只读的 `:width`，
类型为 `Number`，单位是 CSS 像素；不把浏览器的其他 `TextMetrics` 字段误写成稳定契约。
`:font`、`:text-align`、`:text-baseline`、`:direction` 是可读写的原生 String 字段，
通过 `js-set` 赋值。接口直接映射浏览器 Canvas2D，没有 JS wrapper、Scene 命令或批量策略。

完整的独立 Calcit 调用见 [`examples/canvas-text.cirru`](../examples/canvas-text.cirru)。
它保存状态、设置字体与对齐、读取 `metrics :width`、绘制后恢复状态；浏览器测试把其测量值、
像素和恢复后的样式与独立原生 Canvas 调用比较。作为调用方示例，它只覆盖合法输入和正常返回，
不承诺任意宿主异常下自动恢复状态。字体解析、非法对齐值及字体加载时序沿用浏览器语义；
`String` 类型不保证字体已经加载或字符串属于浏览器支持的枚举值。需要在字体加载后重新测量。

## 原生路径描边（0.2.1-alpha.1；以发布 tag 为准）

`CanvasContextHost` 新增 `.move-to!` / `.line-to!`（两个 Number）、`.close-path!` / `.stroke!`（无参数），均返回 Unit。新增可读写字段 `:stroke-style`、`:line-cap`、`:line-join`（String）和 `:line-width`、`:miter-limit`（Number）。它们直接映射浏览器原生属性和方法，不增加 JS wrapper、路径解释器、动画采样或 Quamolit 类型。

`examples/canvas-path.cirru` 是独立 Calcit 消费者：通过类型化方法调用和 `js-set` 绘制折线，可以选择线帽、连接与闭合。无需引用任何 JS 文件。它是测试/使用示例，不是新增公共场景渲染接口。

边界约定：

- `stroke-style` 和既有 `fill-style` 只声明纯色字符串子集，不覆盖 CanvasGradient/CanvasPattern。
- `line-cap` 原生有效值为 `butt/round/square`，`line-join` 为 `miter/round/bevel`。字符串拼写、CSS 颜色及有限正数宽度/斜接限制由调用方负责；类型检查不等于值域校验，非法值沿用浏览器忽略赋值等原生语义。
- `.begin-path!` 清空当前路径；`save/restore` 恢复样式、变换和裁剪，**不恢复路径**。调用方需要独占当前路径或明确约定其生命周期。例程执行正常合法调用，不提供任意宿主异常下的事务保证。
- 新成员是原生对象能力扩展；手写 Canvas 假宿主若使用新能力，必须补齐相应方法/属性。旧矩形 API 的签名和调用行为不变。

检验：`yarn test:browser` 对三种线帽 × 三种连接 × 开放/闭合的 18 种组合，在非恒等外部变换与裁剪下逐像素对照独立原生 Canvas；检查调用前后状态、当前路径重描与九种开放路径形状的可区分性。`yarn test:types` 拒绝新方法的错误类型/参数数量和字段错误写入。`yarn api:generate && yarn test` 覆盖 API 目录、全公共入口和已有功能。

Quamolit 应在本改动合并、发布新 tag 后更新依赖，再将原树每个分叉作为一条连接路径恢复圆头/圆连接；其树形采样、Scene IR、保留计划和 GPU 降级策略仍属于 Quamolit。本切片不宣称动画完整恢复或性能提升。

## 类型化填充与原生曲线（待发布；#143）

`CanvasContextHost` 新增 `.fill!`（无参数）、`.arc! x y radius start-angle end-angle counterclockwise?`（五个 Number 与一个 Bool）及 `.bezier-curve-to! control1-x control1-y control2-x control2-y end-x end-y`（六个 Number），都返回 Unit，并直接映射浏览器的 `fill`、`arc`、`bezierCurveTo`。它们与已有的 `.stroke!`、`.save!` / `.restore!` 组合使用，不新增 JS wrapper 或 Quamolit Scene 解释器。`examples/canvas-filled-path.cirru` 是独立的 Calcit 消费者。

`fill` 使用当前路径和当前填充样式；`arc` 半径、角度与 Bézier 控制点遵从浏览器 Canvas2D 的运行时规则，Number 类型本身不保证半径非负或数值有限。`save/restore` 会恢复样式、变换与裁剪，但不会恢复当前路径；调用方仍须管理路径生命周期。发布新 tag 前，下游不要把本地 main 中的新增方法当作已发布 API。浏览器合同测试把 Calcit 调用与原生 Canvas 逐像素比较，并分别排除“只有填充”和“只有描边”的假阳性；类型负例拒绝错误参数类型与数量。

从 0.2.0-alpha.1 起，`js-ffi.canvas-batches` 只提供 Calcit 类型化的 `CanvasContextHost`、`CanvasAffine2D`、`CanvasRect` 和基础组合 `fill-solid-rect!`、`fill-transformed-clipped-rect!`、`clear-canvas!`。这些操作直接映射浏览器 Canvas2D 的 save/restore、fillRect、clearRect、setTransform、transform、beginPath、rect、clip、fillStyle，不解释 Quamolit Scene IR。

旧 `draw-rects!`、`draw-transformed-clipped-rects!` 和 `canvas-rect-batches.mjs` 已迁出 js-ffi。Quamolit 的真实 10k 实例消费者现在通过 Calcit `quamolit.instance-ffi/draw-canvas!` 调用 Quamolit 仓库的 `src/host/canvas-rect-batches.mjs`；该宿主循环保留一次批次提交、预检、状态恢复和逐矩形 Canvas 调用。0.2.0-alpha.2 起，`CanvasRectMetrics` 也由 Quamolit 自行定义。

`fill-transformed-clipped-rect!` 会改写 Canvas 当前 path；path 不属于 save/restore 状态。调用方负责有效坐标和尺寸，它不是“整场景预检后原子绘制”接口。js-ffi 的浏览器测试验证基础原语的像素、样式和变换；批次/脏范围/10k 实例测试迁到 Quamolit。此归属迁移不声称性能提升。0.1.x 已发布 tag 保持不变。
