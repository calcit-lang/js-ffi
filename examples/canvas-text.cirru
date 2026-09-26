quote $ defn canvas-text (context text)
  hint-fn $ {}
    :args $ [] 'js-ffi.canvas-batches/CanvasContextHost 'String
    :return 'Number
    :features $ #{} :js-ffi
  context .save!
  js-set context :font "|20px monospace"
  js-set context :text-align |left
  js-set context :text-baseline |alphabetic
  js-set context :direction |ltr
  let
      metrics $ context .measure-text text
      width $ metrics :width
    context .fill-text! text 8 28
    context .restore!
    , width
