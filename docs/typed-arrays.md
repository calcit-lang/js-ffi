# Float32 宿主数据快照

公开入口是 Calcit 命名空间 `js-ffi.typed-arrays`：`snapshot-float32`、`float32-length`、`float32-byte-length`、`float32-at`、`float32-copy-range`，并定义 `Float32ArrayHost` 与 `Float32SnapshotHost` 宿主类型。它在 Node 和浏览器共用；`typed-arrays.mjs` 只是同包内部的复制与校验实现，不是下游 Calcit 模块的直接依赖入口。

`snapshot-float32` 要求同一 realm 的 `Float32Array`，拒绝 NaN/Infinity 和 `SharedArrayBuffer` 背板，然后复制数据。返回冻结的不透明 token；调用方之后修改原数组，不会改变已登记的快照。

`float32Length`、`float32ByteLength`、`float32At` 提供只读信息。`float32CopyRange(snapshot, start, count)` 为有界上传生成新的可变 `Float32Array`；修改这个副本也不会改变快照。所有索引与数量必须是范围内的非负安全整数。此通用 API 不管理资源 ID、版本或脏范围；调用方替换快照时必须自行递增版本。它也不执行 WebGPU 上传，更不声称零拷贝性能。

`tests/shared.mjs` 在 Node 和 Chromium 都运行相同断言。当前品牌检查不接收跨 realm 的 typed array，调用方需先复制到本 realm。输入复制消耗 O(n) 时间和内存，是明确的正确性取舍，而不是生产级流式方案。
