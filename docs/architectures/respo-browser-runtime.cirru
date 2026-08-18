{}
  :schema-version 1
  :feature 'respo-browser-runtime
  :doc "|Small typed browser adapters required by Respo core. Each wrapper keeps raw global JavaScript access inside js-ffi and exposes concrete callback or DOM-host types to consumers."
  :roots $ #{} 'js-ffi.shared/queue-microtask! 'js-ffi.browser/create-element 'js-ffi.browser/remove-event-listener! 'js-ffi.browser/set-before-unload!
  :definitions $ {}
    'js-ffi.shared/queue-microtask! $ {}
      :mode :ensure
      :kind :fn
      :doc "|Queue a Unit callback in the JavaScript microtask queue."
      :schema $ :: 'Fn $ {} (:return 'Unit)
        :args $ []
          :: 'Fn $ {} (:return 'Unit) (:args $ [])
      :params $ [] 'callback
    'js-ffi.browser/create-element $ {}
      :mode :ensure
      :kind :fn
      :doc "|Create a DOM element through DocumentHost and return its typed host capability."
      :schema $ :: 'Fn $ {}
        :args $ [] 'String
        :return 'js-ffi.browser/DomElementHost
      :params $ [] 'tag-name
    'js-ffi.browser/remove-event-listener! $ {}
      :mode :ensure
      :kind :fn
      :doc "|Remove a previously registered typed browser window listener."
      :schema $ :: 'Fn $ {} (:return 'Unit)
        :args $ [] 'String
          :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.browser/EventHost
      :params $ [] 'event-name 'callback
    'js-ffi.browser/set-before-unload! $ {}
      :mode :ensure
      :kind :fn
      :doc "|Install a typed browser beforeunload callback."
      :schema $ :: 'Fn $ {} (:return 'Unit)
        :args $ []
          :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.browser/EventHost
      :params $ [] 'callback
  :edges $ #{}
