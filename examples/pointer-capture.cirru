quote $ defn capture-from-event! (element event)
  let
      surface $ browser/pointer-capture-element-host element
      pointer $ browser/pointer-input-event-host event
      bounds $ browser/element-bounding-client-rect surface
    browser/element-set-pointer-capture! surface $ pointer :pointer-id
    pointer .prevent-default!
    [] (pointer :pointer-id) (pointer :client-x) (pointer :client-y) (bounds :left) (bounds :top) (bounds :width) (bounds :height)
