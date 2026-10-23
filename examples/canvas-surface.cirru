quote $ defn canvas-surface (context offscreen? mode)
  let
      surface $ if offscreen? (canvas/offscreen-canvas-create 32 24) (canvas/dom-canvas-create 32 24)
      source $ match (canvas/surface-2d-context surface)
        (:some value) value
        (:none) (raise |2d-context-unavailable)
    js-set source :fill-style |#ff0000
    source .fill-rect! 0 0 24 24
    js-set source :fill-style |#0000ff
    source .fill-rect! 16 0 16 24
    context .save!
    js-set context :global-alpha 0.5
    match mode
      0 $ canvas/draw-surface-at! context surface 4 5
      1 $ canvas/draw-surface-sized! context surface 4 5 40 30
      2 $ canvas/draw-surface-crop! context surface 16 0 16 24 4 5 20 30
      _ $ do
        context .restore!
        raise |invalid-surface-mode
    context .restore!
    , surface
