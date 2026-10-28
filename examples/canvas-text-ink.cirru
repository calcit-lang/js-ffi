quote $ defn canvas-text-ink (context text)
  hint-fn $ Fn js-ffi.canvas-batches/CanvasContextHost String (-> (List Number)) (:features :js-ffi)
  let
      metrics $ canvas/measure-text-ink context text
    [] (metrics :width) (metrics :actual-bounding-box-left) (metrics :actual-bounding-box-right) (metrics :actual-bounding-box-ascent) (metrics :actual-bounding-box-descent)
