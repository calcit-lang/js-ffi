quote $ defn canvas-card (context)
  hint-fn $ {}
    :args $ [] 'js-ffi.canvas-batches/CanvasContextHost
    :return 'Unit
    :features $ #{} :js-ffi
  let
      transform $ canvas/CanvasAffine2D :a 1 :b 0 :c 0 :d 1 :e 5 :f 0
      clip $ canvas/CanvasRect :x 2 :y 2 :width 10 :height 10
      rect $ canvas/CanvasRect :x 0 :y 0 :width 20 :height 20
    canvas/fill-transformed-clipped-rect! context transform clip rect |#ea580c
