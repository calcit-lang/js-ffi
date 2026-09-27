quote $ defn canvas-filled-path (context)
  hint-fn $ {}
    :args $ [] 'js-ffi.canvas-batches/CanvasContextHost
    :return 'Unit
    :features $ #{} :js-ffi
  context .save!
  context .begin-path!
  context .move-to! 18 74
  context .bezier-curve-to! 18 20 82 20 82 74
  context .arc! 70 68 12 0 3.141592653589793 false
  context .close-path!
  js-set context :fill-style |#0ea5e9
  js-set context :stroke-style |#ea580c
  context .fill!
  context .stroke!
  context .restore!
  , &unit
