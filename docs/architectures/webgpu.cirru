{}
  :schema-version 1
  :feature 'webgpu-foundation
  :doc "|Browser-only WebGPU foundation: explicit optional availability, typed callback delivery for adapter/device promises, validated host capabilities, device-loss/error-scope handling, and buffer lifecycle. No renderer, shader DSL, automatic device retry, or fake Promise-as-value return types."
  :roots $ #{} 'js-ffi.webgpu/gpu
  :definitions $ {}
    'js-ffi.webgpu/gpu $ {}
      :mode :ensure
      :kind :fn
      :doc "|Return Option<GpuHost>. Absence (including non-browser/insecure hosts) is none; malformed non-null capabilities raise a contract violation."
      :schema $ :: 'Fn $ {} (:args $ [])
        :return $ :: 'Option 'js-ffi.webgpu/GpuHost
        :features $ #{} :js-ffi
      :params $ []
  :edges $ #{}
