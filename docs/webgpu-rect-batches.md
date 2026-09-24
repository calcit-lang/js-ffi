# WebGPU Float32 矩形实例批次

`createFloat32RectBatch(canvas, device, format, capacity)` 创建一个保留式矩形图层：一个异步编译的 WGSL pipeline、一个实例位置 vertex buffer、一个参数 uniform buffer和一个 bind group。实例以交错 `Float32Array` 的 `(x,y)` 表达；一次完整 `upload` 建立活跃数量，后续 `upload(positions,start,count)` 只写入脏范围。`draw({start,count,width,height,fill,alpha,clear})` 使用六个顶点和 `count` 个实例进行一次 draw，保留输入顺序，以预乘 alpha 的 source-over 混合绘制到 WebGPU Canvas。尺寸和坐标均为 canvas 实际像素，不自动处理 CSS 尺寸/DPR。

位置缓冲和 pipeline 不随时间帧重建；每帧写入 32 字节参数 uniform，创建一次命令编码器并提交一次 render pass。返回计数区分 `positionBytesUploaded`、累计上传、`uniformBytesUploaded`、`drawCalls`、`pipelinesCreated` 和 `buffersCreated`；计数不等于 GPU 执行耗时。局部上传必须处于已完成的活跃范围内。当前颜色是直通道 RGBA 输入，在 fragment 输出时预乘；背景默认为不透明白。`dispose()` 幂等释放两个 buffer 并解除 canvas 配置；调用方负责 device 所有权以及 device lost 后重新创建图层。

`readPixel(x,y)` 是测试/诊断专用：配置的 canvas texture 带 `COPY_SRC`，每次读回暂时分配 256 字节 staging buffer，经 GPU 拷贝和 `mapAsync` 返回 RGBA 四通道。它不是普通帧路径，也不得拿其分配量代表稳定动画资源数量。需要读同一帧的多个像素时，先同步发起所有调用，再 `Promise.all` 等待；跨 `await` 或浏览器呈现后，`getCurrentTexture()` 可能属于下一帧。

边界：此模块只绘制同尺寸/颜色的矩形图层，没有纹理、圆、剪裁、变换、组隔离、自动合批或跨层排序；调用方须在完整图层边界选择 Canvas 回退。`tests/webgpu-rect-batches.mjs` 的宿主双重测试验证 10k 实例一次 draw、脏范围 8 字节、缓存稳定及诊断读回；真实浏览器有 adapter 时额外核对 GPU 画布内部/背景像素，无 adapter 时明确 SKIP。手动页面 `tests/webgpu-rect-batch.html` 可用于截图，但浏览器显示结果不替代正式跨设备性能测量。

接口依据：[GPUQueue.writeBuffer](https://gpuweb.github.io/types/interfaces/GPUQueue.html)、[GPUCanvasContext](https://gpuweb.github.io/types/interfaces/GPUCanvasContext)、[GPURenderPassEncoder](https://gpuweb.github.io/types/interfaces/GPURenderPassEncoder.html)。
