{}
  :schema-version 1
  :feature 'element-scroll
  :doc "|为 HN Reader 与 Termina 复用最小 DOM 内容高度及到底操作，不用 clientHeight 替代 scrollHeight，不增加强转或检查器。"
  :roots $ #{} 'js-ffi.browser/element-scroll-height 'js-ffi.browser/element-scroll-to-bottom!
  :definitions $ {}
    'js-ffi.browser/element-scroll-height $ {}
      :mode :ensure
      :kind :fn
      :params $ [] 'element
      :schema $ :: 'Fn $ {} (:args $ [] 'js-ffi.browser/DomElementHost) (:return 'Number) (:features $ #{} :js-ffi)
      :doc "|Read DOM scrollHeight after a Number check; this is content height, not clientHeight. Host getter exceptions propagate."
      :code $ quote $ defn element-scroll-height (element)
        contract/expect-number |DOM.element.scrollHeight $ element :scroll-height
    'js-ffi.browser/element-scroll-to-bottom! $ {}
      :mode :ensure
      :kind :fn
      :params $ [] 'element
      :schema $ :: 'Fn $ {} (:args $ [] 'js-ffi.browser/DomElementHost) (:return 'Unit) (:features $ #{} :js-ffi)
      :doc "|Assign checked scrollHeight to scrollTop immediately. Native DOM clamps the value; no smooth scrolling, viewport scroll or exception fallback."
      :code $ quote $ defn element-scroll-to-bottom! (element)
        js-set element :scroll-top $ element-scroll-height element
        , &unit
  :edges $ #{}
    :: :call 'js-ffi.browser/element-scroll-to-bottom! 'js-ffi.browser/element-scroll-height
