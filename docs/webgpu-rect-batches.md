# WebGPU Float32 矩形实例批次

公开给 Calcit 消费者的入口是 `js-ffi.webgpu-batches` 命名空间，而非直接导入 `.mjs`。应用在 `deps.cirru` 引入 js-ffi 模块后，使用 `:require (js-ffi.webgpu-batches :as batches)`，以 `RectFrame`、`RectTranslation`、`RectColor` 和 `RectVec2` 构造参数，调用 `create-rect-batch!`、`positions-from-list`、`upload-positions!`、`draw-rects!`、`read-pixel!`、`read-translation!` 和 `dispose-batch!`。`RectFrame` 的可选 `count=0` 可提交空帧清屏；`RectMetrics` 保留了 draw、上传、pipeline 和 buffer 创建计数。`create-rect-batch!` 异步返回 `RectBatchHost`；生产帧不要调用诊断读回。`positions-from-list` 仅适合初始或脏范围上传，不应逐帧分配列表。

下面的 `.mjs` 是同包内部宿主实现，用于 WGSL、Canvas 配置和 GPU 资源管理。Calcit 编译后的代码会通过 `@calcit/js-ffi/webgpu-rect-batches.mjs` 引用它，因此 JS 包也须安装为同版本依赖；应用代码不应越过 Calcit API 直接引用底层实现。JS 宿主测试可以直接调用它，以隔离 WebGPU 机制与 Calcit 数据边界。

`createFloat32RectBatch(canvas, device, format, capacity)` 创建一个保留式矩形图层：一个异步编译的 WGSL pipeline、一个实例位置 vertex buffer、一个参数 uniform buffer和一个 bind group。实例以交错 `Float32Array` 的 `(x,y)` 表达；一次完整 `upload` 建立活跃数量，后续 `upload(positions,start,count)` 只写入脏范围。`draw({start,count,width,height,fill,alpha,clear,translation})` 使用六个顶点和 `count` 个实例进行一次 draw，保留输入顺序，以预乘 alpha 的 source-over 混合绘制到 WebGPU Canvas。尺寸和坐标均为 canvas 实际像素，不自动处理 CSS 尺寸/DPR。

位置缓冲和 pipeline 不随时间帧重建；每帧写入 64 字节参数 uniform，创建一次命令编码器并提交一次 render pass。可选 `translation` 用 `{from:{x,y},to:{x,y},time,start,duration,easing}` 描述整个实例图层的绝对时间平移；`easing` 为 `linear` 或 `smoothstep`，`duration=0` 在 `time>=start` 跳到终点。无 `translation` 时保持原坐标。位移进度在 vertex shader 中采样，单个时间帧不重传实例位置；这里的输入是通用数字参数，不依赖 Quamolit Motion IR。返回计数区分 `positionBytesUploaded`、累计上传、`uniformBytesUploaded`、`drawCalls`、`pipelinesCreated` 和 `buffersCreated`；计数不等于 GPU 执行耗时。局部上传必须处于已完成的活跃范围内。当前颜色是直通道 RGBA 输入，在 fragment 输出时预乘；背景默认为不透明白。`dispose()` 幂等释放两个 buffer 并解除 canvas 配置；调用方负责 device 所有权以及 device lost 后重新创建图层。

`readPixel(x,y)` 是测试/诊断专用：配置的 canvas texture 带 `COPY_SRC`，每次读回暂时分配 256 字节 staging buffer，经 GPU 拷贝和 `mapAsync` 返回 RGBA 四通道。它不是普通帧路径，也不得拿其分配量代表稳定动画资源数量。需要读同一帧的多个像素时，先同步发起所有调用，再 `Promise.all` 等待；跨 `await` 或浏览器呈现后，`getCurrentTexture()` 可能属于下一帧。

`readTranslation()` 同样只用于诊断，要求先 `draw`，并在下一次 `draw` 前等待结果。它按需创建 compute pipeline，复用顶点 shader 的同一段 `sampledTranslation()` WGSL 函数和当前 64 字节 uniform，将一个 vec2f 写入 8 字节结果缓冲，再读回 `{x,y}`。每次读取临时分配结果和 staging buffer，随后释放；这些 buffer 与 compute pass 不在稳态绘制计数中。此方法可证明 GPU 上的 f32 位移采样，而不需要由像素覆盖率反推连续数值；它不验证后续投影、光栅化或颜色混合。正常播放不得调用它。

边界：此模块只绘制同尺寸/颜色的矩形图层，没有纹理、圆、剪裁、变换、组隔离、自动合批或跨层排序；调用方须在完整图层边界选择 Canvas 回退。`tests/webgpu-calcit-batches.mjs` 验证类型化 Calcit 参数的编解码，`tests/webgpu-rect-batches.mjs` 的宿主双重测试验证 10k 实例一次 draw、脏范围 8 字节、缓存稳定及诊断读回；真实浏览器有 adapter 时额外核对 GPU 画布像素、固定/乱序/固定 seed 时间的 f32 位移和零持续时间边界，无 adapter 时明确 SKIP。手动页面 `tests/webgpu-rect-batch.html` 可用于截图，但浏览器显示结果不替代正式跨设备性能测量。

接口依据：[GPUQueue.writeBuffer](https://gpuweb.github.io/types/interfaces/GPUQueue.html)、[GPUCanvasContext](https://gpuweb.github.io/types/interfaces/GPUCanvasContext)、[GPURenderPassEncoder](https://gpuweb.github.io/types/interfaces/GPURenderPassEncoder.html)。
