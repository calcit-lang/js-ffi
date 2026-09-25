quote $ defn canvas-batch-card (context positions)
  hint-fn $ {}
    :args $ [] 'js-ffi.canvas-batches/CanvasContextHost 'js-ffi.typed-arrays/Float32ArrayHost
    :return 'js-ffi.canvas-batches/CanvasRectMetrics
    :features $ #{} :js-ffi
  let
      transform $ canvas/CanvasAffine2D :a 1 :b 0 :c 0 :d 1 :e 5 :f 0
      clip $ canvas/CanvasRect :x 2 :y 2 :width 10 :height 10
    canvas/draw-transformed-clipped-rects! context transform clip positions 0 2 4 4 |#ea580c 1
