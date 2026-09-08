quote $ defn buffer-lifecycle (device)
  let
      buffer $ webgpu/create-buffer device 16 8
      size $ try (webgpu/buffer-size buffer)
        fn (error)
          webgpu/destroy-buffer! buffer
          raise |WebGPU.buffer-lifecycle.failed-to-read-size
    webgpu/destroy-buffer! buffer
    , size
