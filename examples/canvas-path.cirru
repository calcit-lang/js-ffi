quote $ defn canvas-path (context cap line-join closed)
  hint-fn $ {}
    :args $ [] 'js-ffi.canvas-batches/CanvasContextHost 'String 'String 'Bool
    :return 'Unit
    :features $ #{} :js-ffi
  context .save!
  context .transform! 1 0 0 1 7 9
  js-set context :stroke-style |#ea580c
  js-set context :line-width 10
  js-set context :line-cap cap
  js-set context :line-join line-join
  js-set context :miter-limit 8
  context .begin-path!
  context .move-to! 15 45
  context .line-to! 35 15
  context .line-to! 55 45
  when closed $ context .close-path!
  context .stroke!
  context .restore!
  , &unit
