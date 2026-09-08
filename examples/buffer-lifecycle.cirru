quote $ defn buffer-lifecycle (device)
  let
      buffer $ webgpu/create-buffer device 16 8
      size $ webgpu/buffer-size buffer
    webgpu/destroy-buffer! buffer
    , size
