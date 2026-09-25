
{}
  :about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --contract` before mutations; use `--full` for first orientation or changed contract digest. Manual edits must follow format and schema conventions, then run `calcit edit format`."
  :package |js-ffi
  :entries $ {}
    :browser $ {} (:description |) (:init-fn 'js-ffi.browser-test/main!) (:mode :js) (:reload-fn 'js-ffi.browser-test/reload!) (:target :browser)
      :feature-policy $ {} $ :js-ffi :error
      :modules $ []
      :type-slots $ {}
    :default $ {} (:description |) (:init-fn 'js-ffi.node-test/main!) (:mode :native) (:reload-fn 'js-ffi.node-test/reload!) (:target :node)
      :feature-policy $ {} $ :js-ffi :error
      :modules $ []
      :type-slots $ {}
    :node $ {} (:description |) (:init-fn 'js-ffi.node-test/main!) (:mode :native) (:reload-fn 'js-ffi.node-test/reload!) (:target :node)
      :feature-policy $ {} $ :js-ffi :error
      :modules $ []
      :type-slots $ {}
  :files $ {}
    'js-ffi.browser $ %{} 'FileEntry
      :defs $ {}
        'BlobHost $ %{} 'CodeEntry
          :doc "|External Blob capability exposing size, type, and an async UTF-8 text reader."
          :code $ quote $ deftrait BlobHost (:size 'Number) (:type 'String)
            .text $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/BlobHost
              :return 'JsObject
          :examples $ [] $ quote BlobHost
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} $ :text |text
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'BrowserProbe $ %{} 'CodeEntry
          :doc "|Typed browser smoke result replacing the former heterogeneous Map<Dynamic>."
          :code $ quote $ defstruct BrowserProbe (:runtime 'js-ffi.shared/Runtime) (:document? 'Bool) (:storage 'String) (:viewport 'js-ffi.browser/Viewport)
          :examples $ [] $ quote
            &%{} BrowserProbe :runtime (%:: shared/Runtime :browser) :document? true :storage |ok :viewport $ &%{} Viewport :width 1024 :height 768 :device-pixel-ratio 2
          :schema $ :: 'Enum
        'DocumentHost $ %{} 'CodeEntry
          :doc "|External Document capability with typed state, title, and small selector/creation surface."
          :code $ quote $ deftrait DocumentHost (:title 'String) (:ready-state 'String) (:visibility-state 'String)
            :body $ :: 'JsNullish 'js-ffi.browser/DomElementHost
            :document-element $ :: 'JsNullish 'js-ffi.browser/DomElementHost
            :active-element $ :: 'JsNullish 'js-ffi.browser/DomElementHost
            .query-selector $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/DocumentHost 'String
              :return $ :: 'JsNullish 'js-ffi.browser/DomElementHost
            .create-element $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/DocumentHost 'String
              :return 'js-ffi.browser/DomElementHost
            .create-element-ns $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/DocumentHost 'String 'String
              :return 'js-ffi.browser/DomElementHost
          :examples $ [] $ quote DocumentHost
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} (:active-element |activeElement) (:body |body) (:create-element |createElement) (:create-element-ns |createElementNS) (:document-element |documentElement) (:query-selector |querySelector) (:ready-state |readyState) (:visibility-state |visibilityState)
            :writable $ #{} :title
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'DocumentReadyState $ %{} 'CodeEntry
          :doc "|Typed document.readyState values with an unknown String variant for forward compatibility."
          :code $ quote $ defenum DocumentReadyState (:loading) (:interactive) (:complete) (:unknown 'String)
          :examples $ [] $ quote (%:: DocumentReadyState :complete)
          :schema $ :: 'Enum
        'DomChildrenHost $ %{} 'CodeEntry
          :doc "|External DOM children collection with typed length and nullable indexed element lookup."
          :code $ quote $ deftrait DomChildrenHost (:length 'Number)
            .item $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/DomChildrenHost 'Number
              :return $ :: 'JsNullish 'js-ffi.browser/DomElementHost
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {}
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'DomElementHost $ %{} 'CodeEntry
          :doc "|External DOM Element capability with stable fields, selector methods, attributes, and focus effects."
          :code $ quote $ deftrait DomElementHost (:id 'String) (:class-name 'String) (:hidden 'Bool)
            :text-content $ :: 'JsNullish 'String
            :child-element-count 'Number
            :offset-left 'Number
            :offset-top 'Number
            :client-width 'Number
            :client-height 'Number
            :dataset 'JsObject
            :style 'JsObject
            :parent-element $ :: 'JsNullish 'js-ffi.browser/DomElementHost
            .append-child! $ :: 'Fn $ {}
              :generics $ [] 'T
              :args $ [] 'T 'T
              :return 'T
            .clone-node $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/DomElementHost 'Bool
              :return 'js-ffi.browser/DomElementHost
            .remove! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/DomElementHost
              :return 'Unit
            .matches? $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/DomElementHost 'String
              :return 'Bool
            .query-selector $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/DomElementHost 'String
              :return $ :: 'JsNullish 'js-ffi.browser/DomElementHost
            .get-attribute $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/DomElementHost 'String
              :return $ :: 'JsNullish 'String
            .set-attribute! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/DomElementHost 'String 'String
              :return 'Unit
            .remove-attribute! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/DomElementHost 'String
              :return 'Unit
            .focus! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/DomElementHost
              :return 'Unit
            .blur! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/DomElementHost
              :return 'Unit
            .request-fullscreen! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/DomElementHost
              :return 'Unit
            .add-event-listener! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/DomElementHost 'String $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.browser/EventHost
                  :return 'Unit
              :return 'Unit
            .remove-event-listener! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/DomElementHost 'String $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.browser/EventHost
                  :return 'Unit
              :return 'Unit
            :value $ :: 'JsNullish 'String
            :placeholder $ :: 'JsNullish 'String
            :children 'js-ffi.browser/DomChildrenHost
            :inner-html 'String
            :local-name 'String
          :examples $ [] $ quote DomElementHost
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} (:add-event-listener! |addEventListener) (:append-child! |appendChild) (:blur! |blur) (:child-element-count |childElementCount) (:class-name |className) (:client-height |clientHeight) (:client-width |clientWidth) (:clone-node |cloneNode) (:focus! |focus) (:get-attribute |getAttribute) (:hidden |hidden) (:inner-html |innerHTML) (:local-name |localName) (:matches? |matches) (:offset-left |offsetLeft) (:offset-top |offsetTop) (:parent-element |parentElement) (:placeholder |placeholder) (:query-selector |querySelector) (:remove! |remove) (:remove-attribute! |removeAttribute) (:remove-event-listener! |removeEventListener) (:request-fullscreen! |requestFullscreen) (:set-attribute! |setAttribute) (:text-content |textContent) (:value |value)
            :writable $ #{} :class-name :hidden :inner-html :placeholder :text-content :value
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'DomInputHost $ %{} 'CodeEntry
          :doc "|External HTML input capability. Mutable fields are declared in FFI metadata, not in the core trait type."
          :code $ quote $ deftrait DomInputHost (:value 'String) (:checked 'Bool) (:disabled 'Bool) (:name 'String) (:input-type 'String)
            .focus! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/DomInputHost
              :return 'Unit
            .blur! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/DomInputHost
              :return 'Unit
          :examples $ [] $ quote DomInputHost
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} (:blur! |blur) (:focus! |focus) (:input-type |type)
            :writable $ #{} :checked :disabled :input-type :name :value
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'DomSelectableHost $ %{} 'CodeEntry
          :doc "|External selectable text-control capability shared by input and textarea elements."
          :code $ quote $ deftrait DomSelectableHost
            .select! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/DomSelectableHost
              :return 'Unit
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} $ :select! |select
          :schema $ :: 'Trait
        'ElementSnapshot $ %{} 'CodeEntry
          :doc "|Calcit-owned subset of DOM element data suitable for business code without retaining host identity."
          :code $ quote $ defstruct ElementSnapshot (:id 'String) (:class-name 'String)
            :text-content $ :: 'Option 'String
            :child-count 'Number
          :examples $ [] $ quote
            &%{} ElementSnapshot :id |main :class-name |panel :text-content (%some |Ready) :child-count 1
          :schema $ :: 'Enum
        'EventHost $ %{} 'CodeEntry
          :doc "|External Event capability. Targets stay nullable opaque objects unless a specific adapter narrows them."
          :code $ quote $ deftrait EventHost (:event-type 'String)
            :target $ :: 'JsNullish 'JsObject
            :current-target $ :: 'JsNullish 'JsObject
            :default-prevented? 'Bool
            :event-phase 'Number
            .prevent-default! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/EventHost
              :return 'Unit
            .stop-propagation! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/EventHost
              :return 'Unit
          :examples $ [] $ quote EventHost
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} (:current-target |currentTarget) (:default-prevented? |defaultPrevented) (:event-phase |eventPhase) (:event-type |type) (:prevent-default! |preventDefault) (:stop-propagation! |stopPropagation)
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'FormDataHost $ %{} 'CodeEntry
          :doc "|External FormData capability for building multipart request bodies from String fields."
          :code $ quote $ deftrait FormDataHost
            .append! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/FormDataHost 'String 'String
              :return 'Unit
            .delete! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/FormDataHost 'String
              :return 'Unit
            .has? $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/FormDataHost 'String
              :return 'Bool
          :examples $ [] $ quote FormDataHost
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} (:append! |append) (:delete! |delete) (:has? |has)
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'ImageHost $ %{} 'CodeEntry
          :doc "|External HTMLImageElement capability with source, natural size, and a decode promise."
          :code $ quote $ deftrait ImageHost (:natural-width 'Number) (:natural-height 'Number)
            :src $ :: 'JsNullish 'String
            .decode $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/ImageHost
              :return 'JsObject
          :examples $ [] $ quote ImageHost
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} (:decode |decode) (:natural-height |naturalHeight) (:natural-width |naturalWidth) (:src |src)
            :writable $ #{} :src
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'KeyModifiers $ %{} 'CodeEntry
          :doc "|Normalized keyboard or pointer modifier state shared by event adapters."
          :code $ quote $ defstruct KeyModifiers (:alt? 'Bool) (:ctrl? 'Bool) (:meta? 'Bool) (:shift? 'Bool)
          :examples $ [] $ quote
            &%{} KeyModifiers :alt? false :ctrl? true :meta? false :shift? false
          :schema $ :: 'Enum
        'KeyboardEventHost $ %{} 'CodeEntry
          :doc "|External KeyboardEvent capability without trait inheritance; adapters normalize keys and modifiers into Calcit data."
          :code $ quote $ deftrait KeyboardEventHost (:key 'String) (:code 'String) (:key-code 'Number) (:repeat? 'Bool) (:alt-key? 'Bool) (:ctrl-key? 'Bool) (:meta-key? 'Bool) (:shift-key? 'Bool)
            .prevent-default! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/KeyboardEventHost
              :return 'Unit
          :examples $ [] $ quote KeyboardEventHost
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} (:alt-key? |altKey) (:ctrl-key? |ctrlKey) (:key-code |keyCode) (:meta-key? |metaKey) (:prevent-default! |preventDefault) (:repeat? |repeat) (:shift-key? |shiftKey)
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'LocationHost $ %{} 'CodeEntry
          :doc "|External browser Location capability. Navigation methods are explicit effects; URL fields are readable."
          :code $ quote $ deftrait LocationHost (:href 'String) (:origin 'String) (:protocol 'String) (:host 'String) (:hostname 'String) (:port 'String) (:pathname 'String) (:search 'String) (:hash 'String)
            .assign! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/LocationHost 'String
              :return 'Unit
            .replace! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/LocationHost 'String
              :return 'Unit
            .reload! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/LocationHost
              :return 'Unit
          :examples $ [] $ quote LocationHost
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} (:assign! |assign) (:origin |origin) (:reload! |reload) (:replace! |replace)
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'LocationSnapshot $ %{} 'CodeEntry
          :doc "|Typed copy of the stable browser Location URL fields."
          :code $ quote $ defstruct LocationSnapshot (:href 'String) (:origin 'String) (:protocol 'String) (:host 'String) (:hostname 'String) (:port 'String) (:pathname 'String) (:search 'String) (:hash 'String)
          :examples $ []
          :schema $ :: 'Enum
        'MediaQueryListHost $ %{} 'CodeEntry
          :doc "|External matchMedia result with stable media and matches fields. Listener APIs remain adapter-specific."
          :code $ quote $ deftrait MediaQueryListHost (:media 'String) (:matches? 'Bool)
          :examples $ [] $ quote MediaQueryListHost
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} $ :matches? |matches
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'MouseEventHost $ %{} 'CodeEntry
          :doc "|External MouseEvent capability exposing coordinates, button, and modifier fields used by adapters."
          :code $ quote $ deftrait MouseEventHost (:client-x 'Number) (:client-y 'Number) (:button 'Number) (:alt-key? 'Bool) (:ctrl-key? 'Bool) (:meta-key? 'Bool) (:shift-key? 'Bool)
            .prevent-default! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/MouseEventHost
              :return 'Unit
          :examples $ [] $ quote MouseEventHost
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} (:alt-key? |altKey) (:client-x |clientX) (:client-y |clientY) (:ctrl-key? |ctrlKey) (:meta-key? |metaKey) (:prevent-default! |preventDefault) (:shift-key? |shiftKey)
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'PointerEventHost $ %{} 'CodeEntry
          :doc "|External PointerEvent capability exposing target-relative layer coordinates used by gesture code."
          :code $ quote $ deftrait PointerEventHost (:layer-x 'Number) (:layer-y 'Number)
          :examples $ [] $ quote PointerEventHost
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} (:layer-x |layerX) (:layer-y |layerY)
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'PointerPosition $ %{} 'CodeEntry
          :doc "|Normalized pointer coordinates and button index copied from a MouseEvent-like object."
          :code $ quote $ defstruct PointerPosition (:client-x 'Number) (:client-y 'Number) (:button 'Number)
          :examples $ [] $ quote (&%{} PointerPosition :client-x 20 :client-y 30 :button 0)
          :schema $ :: 'Enum
        'StorageHost $ %{} 'CodeEntry
          :doc "|External Web Storage capability with nullish lookup and explicit String mutation methods."
          :code $ quote $ deftrait StorageHost (:length 'Number)
            .get-item $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/StorageHost 'String
              :return $ :: 'JsNullish 'String
            .key-at $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/StorageHost 'Number
              :return $ :: 'JsNullish 'String
            .set-item! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/StorageHost 'String 'String
              :return 'Unit
            .remove-item! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/StorageHost 'String
              :return 'Unit
            .clear! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/StorageHost
              :return 'Unit
          :examples $ [] $ quote StorageHost
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} (:clear! |clear) (:get-item |getItem) (:key-at |key) (:remove-item! |removeItem) (:set-item! |setItem)
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'StyleHost $ %{} 'CodeEntry
          :doc "|External CSSStyleDeclaration capability exposing cssText and property accessors."
          :code $ quote $ deftrait StyleHost (:css-text 'String)
          :examples $ [] $ quote StyleHost
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} $ :css-text |cssText
            :writable $ #{} :css-text
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'Viewport $ %{} 'CodeEntry
          :doc "|Normalized viewport dimensions and device pixel ratio copied from Window."
          :code $ quote $ defstruct Viewport (:width 'Number) (:height 'Number) (:device-pixel-ratio 'Number)
          :examples $ [] $ quote (&%{} Viewport :width 1024 :height 768 :device-pixel-ratio 2)
          :schema $ :: 'Enum
        'VisibilityState $ %{} 'CodeEntry
          :doc "|Typed document.visibilityState values with an unknown String variant."
          :code $ quote $ defenum VisibilityState (:visible) (:hidden) (:prerender) (:unknown 'String)
          :examples $ [] $ quote (%:: VisibilityState :visible)
          :schema $ :: 'Enum
        'WebSocketHost $ %{} 'CodeEntry
          :doc "|External WebSocket capability with readyState, typed event callbacks, and String send/close effects."
          :code $ quote $ deftrait WebSocketHost (:ready-state 'Number)
            :on-open $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/EventHost
              :return 'Unit
            :on-message $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/EventHost
              :return 'Unit
            :on-close $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/EventHost
              :return 'Unit
            :on-error $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/EventHost
              :return 'Unit
            .send! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/WebSocketHost 'String
              :return 'Unit
            .close! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/WebSocketHost
              :return 'Unit
          :examples $ [] $ quote WebSocketHost
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} (:close! |close) (:on-close |onclose) (:on-error |onerror) (:on-message |onmessage) (:on-open |onopen) (:ready-state |readyState) (:send! |send)
            :writable $ #{} :on-close :on-error :on-message :on-open
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'WindowHost $ %{} 'CodeEntry
          :doc "|External browser Window capability restricted to stable viewport fields, matchMedia, and typed global event listeners."
          :code $ quote $ deftrait WindowHost (:inner-width 'Number) (:inner-height 'Number) (:device-pixel-ratio 'Number) (:document 'js-ffi.browser/DocumentHost)
            :on-before-unload $ :: 'Fn $ {} (:return 'Unit)
              :args $ [] 'js-ffi.browser/EventHost
            .match-media $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/WindowHost 'String
              :return 'js-ffi.browser/MediaQueryListHost
            .add-event-listener! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/WindowHost 'String $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.browser/EventHost
                  :return 'Unit
              :return 'Unit
            .remove-event-listener! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/WindowHost 'String $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.browser/EventHost
                  :return 'Unit
              :return 'Unit
            .post-message! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/WindowHost 'Dynamic 'String
              :return 'Unit
            .open $ :: 'Fn $ {}
              :args $ [] 'js-ffi.browser/WindowHost 'String
              :return $ :: 'JsNullish 'js-ffi.browser/WindowHost
          :examples $ [] $ quote WindowHost
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} (:add-event-listener! |addEventListener) (:device-pixel-ratio |devicePixelRatio) (:document |document) (:inner-height |innerHeight) (:inner-width |innerWidth) (:match-media |matchMedia) (:on-before-unload |onbeforeunload) (:open |open) (:post-message! |postMessage) (:remove-event-listener! |removeEventListener)
            :writable $ #{} :on-before-unload
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'add-event-listener! $ %{} 'CodeEntry
          :doc "|Register a typed browser window event listener. The callback receives an EventHost and the wrapper returns Unit."
          :code $ quote $ defn add-event-listener! (event-name callback)
            let
                host-window $ unsafe-coerce js/window WindowHost
              host-window .add-event-listener! event-name callback
          :examples $ []
            quote $ add-event-listener! |visibilitychange
            quote $ add-event-listener! |beforeunload $ fn (event) nil
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'String $ :: 'Fn
              {} (:return 'Unit)
                :args $ [] 'js-ffi.browser/EventHost
            :features $ #{} :js-ffi
        'alert! $ %{} 'CodeEntry
          :doc "|Show one blocking browser alert String and return Unit."
          :code $ quote $ defn alert! (message) (js/alert message) &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'String
            :features $ #{} :js-ffi
        'append-child! $ %{} 'CodeEntry
          :doc "|Appends one typed DOM host element to another and returns the child. This keeps DOM insertion inside the browser FFI boundary."
          :code $ quote $ defn append-child! (parent child)
            unsafe-coerce (parent .append-child! child) DomElementHost
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'js-ffi.browser/DomElementHost)
            :args $ [] 'js-ffi.browser/DomElementHost 'js-ffi.browser/DomElementHost
            :features $ #{} :js-ffi
        'blob-create $ %{} 'CodeEntry
          :doc "|Create a browser Blob containing one UTF-8 String part."
          :code $ quote $ defn blob-create (text)
            unsafe-coerce
              new js/Blob $ js/Array.of text
              , BlobHost
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'js-ffi.browser/BlobHost)
            :args $ [] 'String
            :features $ #{} :js-ffi
        'blob-text $ %{} 'CodeEntry
          :doc "|Await Blob.text once and decode the UTF-8 String or normalize a JsError."
          :code $ quote $ defn blob-text (blob)
            hint-fn $ {} (:async true)
              :args $ [] 'js-ffi.browser/BlobHost
              :features $ #{} :js-ffi
              :return $ :: 'Result 'String 'js-ffi.shared/JsError
            try
              %:: Result :ok $ contract/expect-string |blob.text $ js-await (blob .text)
              fn (error)
                %:: Result :err $ shared/normalize-error error
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'js-ffi.browser/BlobHost
            :features $ #{} :js-ffi
            :return $ :: 'calcit.core/Result 'String 'js-ffi.shared/JsError
        'cancel-animation-frame! $ %{} 'CodeEntry
          :doc "|Cancel a browser numeric handle; unknown handles are harmless."
          :code $ quote $ defn cancel-animation-frame! (handle) (js/cancelAnimationFrame handle) &unit
          :examples $ []
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'Number
            :features $ #{} :js-ffi
        'child-element-at $ %{} 'CodeEntry
          :doc "|Return the indexed child element as Option, normalizing the host nullish result."
          :code $ quote $ defn child-element-at (children idx)
            js-nullish->option $ children .item idx
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'js-ffi.browser/DomChildrenHost 'Number
            :features $ #{} :js-ffi
            :return $ :: 'calcit.core/Option 'js-ffi.browser/DomElementHost
        'clear-interval! $ %{} 'CodeEntry
          :doc "|Cancel a browser numeric handle; unknown handles are harmless."
          :code $ quote $ defn clear-interval! (handle) (js/clearInterval handle) &unit
          :examples $ []
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'Number
            :features $ #{} :js-ffi
        'clear-timeout! $ %{} 'CodeEntry
          :doc "|Cancel a browser numeric handle; unknown handles are harmless."
          :code $ quote $ defn clear-timeout! (handle) (js/clearTimeout handle) &unit
          :examples $ []
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'Number
            :features $ #{} :js-ffi
        'clipboard-read-text! $ %{} 'CodeEntry
          :doc "|Await navigator.clipboard.readText exactly once and normalize failures as Result.err<JsError>."
          :code $ quote $ defn clipboard-read-text! ()
            hint-fn $ {} (:async true)
              :args $ []
              :features $ #{} :js-ffi
              :return $ :: 'Result 'String 'js-ffi.shared/JsError
            try
              %:: Result :ok $ contract/expect-string |navigator.clipboard.readText $ js-await (js/navigator.clipboard.readText)
              fn (error)
                %:: Result :err $ shared/normalize-error error
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ []
            :features $ #{} :js-ffi
            :return $ :: 'calcit.core/Result 'String 'js-ffi.shared/JsError
        'clipboard-write-text! $ %{} 'CodeEntry
          :doc "|Write text to the browser clipboard through navigator.clipboard. The host Promise is not awaited and the adapter returns Unit."
          :code $ quote $ defn clipboard-write-text! (text) (js/navigator.clipboard.writeText text) &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'String
            :features $ #{} :js-ffi
        'console-error! $ %{} 'CodeEntry
          :doc "|Compatibility wrapper for shared/console-error!. It accepts one String and returns Unit."
          :code $ quote $ defn console-error! (message) (shared/console-error! message)
          :examples $ [] $ quote (console-error! |failed)
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'String
        'console-log! $ %{} 'CodeEntry
          :doc "|Compatibility wrapper for shared/console-log!. It accepts one String and returns Unit instead of leaking host undefined."
          :code $ quote $ defn console-log! (message) (shared/console-log! message)
          :examples $ [] $ quote (console-log! |ready)
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'String
        'create-element $ %{} 'CodeEntry
          :doc "|Create a DOM element through DocumentHost and return its typed host capability."
          :code $ quote $ defn create-element (tag-name)
            let
                host-document $ unsafe-coerce js/document DocumentHost
              host-document .create-element tag-name
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'js-ffi.browser/DomElementHost)
            :args $ [] 'String
            :features $ #{} :js-ffi
        'create-element-ns $ %{} 'CodeEntry
          :doc "|Create a namespaced DOM element (for example SVG) through DocumentHost."
          :code $ quote $ defn create-element-ns (namespace tag-name)
            let
                host $ document-host
              host .create-element-ns namespace tag-name
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'js-ffi.browser/DomElementHost)
            :args $ [] 'String 'String
            :features $ #{} :js-ffi
        'decode-document-ready-state $ %{} 'CodeEntry
          :doc "|Decode document.readyState String to DocumentReadyState while preserving unknown values."
          :code $ quote $ defn decode-document-ready-state (raw)
            case-default raw (DocumentReadyState :unknown raw)
              |loading $ DocumentReadyState :loading
              |interactive $ DocumentReadyState :interactive
              |complete $ DocumentReadyState :complete
          :examples $ []
            quote $ decode-document-ready-state |complete
            quote $ decode-document-ready-state |future-state
          :schema $ :: 'Fn $ {} (:return 'js-ffi.browser/DocumentReadyState)
            :args $ [] 'String
        'decode-visibility-state $ %{} 'CodeEntry
          :doc "|Decode document.visibilityState String to VisibilityState while preserving unknown values."
          :code $ quote $ defn decode-visibility-state (raw)
            case-default raw (VisibilityState :unknown raw)
              |visible $ VisibilityState :visible
              |hidden $ VisibilityState :hidden
              |prerender $ VisibilityState :prerender
          :examples $ [] $ quote (decode-visibility-state |hidden)
          :schema $ :: 'Fn $ {} (:return 'js-ffi.browser/VisibilityState)
            :args $ [] 'String
        'document-active-element $ %{} 'CodeEntry
          :doc "|Return the focused element as Option<DomElementHost>; an absent active element yields none."
          :code $ quote $ defn document-active-element ()
            let
                host $ document-host
              js-nullish->option $ host :active-element
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ []
            :features $ #{} :js-ffi
            :return $ :: 'calcit.core/Option 'js-ffi.browser/DomElementHost
        'document-append-body! $ %{} 'CodeEntry
          :doc "|Append an element to document.body and return Unit."
          :code $ quote $ defn document-append-body! (element) (js/document.body.appendChild element) &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.browser/DomElementHost
            :features $ #{} :js-ffi
        'document-available? $ %{} 'CodeEntry
          :doc "|Return whether document is present. Use this guard before touching DOM objects so shared code can be checked in both Node.js and browsers. Example: (document-available?) => true"
          :code $ quote $ defn document-available? () (exists? js/document)
          :examples $ [] $ quote "(document-available?)"
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {} (:return 'Bool)
            :args $ []
            :features $ #{} :js-ffi
        'document-body $ %{} 'CodeEntry
          :doc "|Return document.body as a typed DomElementHost through DocumentHost."
          :code $ quote $ defn document-body ()
            let
                host $ document-host
              js-nullish->option $ host :body
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ []
            :features $ #{} :js-ffi
            :return $ :: 'calcit.core/Option 'js-ffi.browser/DomElementHost
        'document-element $ %{} 'CodeEntry
          :doc "|Return document.documentElement as Option<DomElementHost>."
          :code $ quote $ defn document-element ()
            let
                host $ document-host
              js-nullish->option $ host :document-element
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ []
            :features $ #{} :js-ffi
            :return $ :: 'calcit.core/Option 'js-ffi.browser/DomElementHost
        'document-host $ %{} 'CodeEntry
          :doc "|Return the typed DocumentHost capability for the current browser document."
          :code $ quote $ defn document-host () (unsafe-coerce js/document DocumentHost)
          :examples $ []
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {} (:return 'js-ffi.browser/DocumentHost)
            :args $ []
            :features $ #{} :js-ffi
        'document-ready-state $ %{} 'CodeEntry
          :doc "|Read and decode document.readyState through the typed DocumentHost contract."
          :code $ quote $ defn document-ready-state ()
            let
                host-document $ unsafe-coerce js/document DocumentHost
              decode-document-ready-state $ host-document :ready-state
          :examples $ [] $ quote (document-ready-state)
          :schema $ :: 'Fn $ {} (:return 'js-ffi.browser/DocumentReadyState)
            :args $ []
            :features $ #{} :js-ffi
        'document-title $ %{} 'CodeEntry
          :doc "|Read document.title through DocumentHost. Returns an empty String when document is unavailable."
          :code $ quote $ defn document-title () (str js/document.title)
          :examples $ [] $ quote (document-title)
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ []
            :features $ #{} :js-ffi
        'document-title! $ %{} 'CodeEntry (:doc "|Set document.title through DocumentHost.")
          :code $ quote $ defn document-title! (title)
            let
                host $ document-host
              js-set host :title title
              , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'String
            :features $ #{} :js-ffi
        'element-add-event-listener! $ %{} 'CodeEntry (:doc "|Register a typed event listener on one element.")
          :code $ quote $ defn element-add-event-listener! (element event-name callback) (element .add-event-listener! event-name callback) &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.browser/DomElementHost 'String $ :: 'Fn
              {} (:return 'Unit)
                :args $ [] 'js-ffi.browser/EventHost
            :features $ #{} :js-ffi
        'element-blur! $ %{} 'CodeEntry (:doc "|Blur an HTML element with blur capability.")
          :code $ quote $ defn element-blur! (element) (element .blur!) &unit
          :examples $ []
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.browser/DomElementHost
            :features $ #{} :js-ffi
        'element-clone $ %{} 'CodeEntry
          :doc "|Clone a DOM element, optionally including its descendants."
          :code $ quote $ defn element-clone (element deep?)
            assert-type (.!cloneNode element deep?) 'js-ffi.browser/DomElementHost
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'js-ffi.browser/DomElementHost)
            :args $ [] 'js-ffi.browser/DomElementHost 'Bool
            :features $ #{} :js-ffi
        'element-data-get $ %{} 'CodeEntry
          :doc "|Read one data-* attribute as Option<String> through element.dataset."
          :code $ quote $ defn element-data-get (element key)
            let
                dataset $ contract/expect-object |element.dataset $ js-get element |dataset
                value $ js-get dataset key
              if (js-nullish? value) (%none)
                %some $ contract/expect-string |element.dataset value
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'js-ffi.browser/DomElementHost 'String
            :features $ #{} :js-ffi
            :return $ :: 'calcit.core/Option 'String
        'element-data-remove! $ %{} 'CodeEntry
          :doc "|Remove one data-* attribute through element.dataset."
          :code $ quote $ defn element-data-remove! (element key)
            js-delete (js-get element |dataset) key
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.browser/DomElementHost 'String
            :features $ #{} :js-ffi
        'element-data-set! $ %{} 'CodeEntry
          :doc "|Set one data-* attribute through element.dataset."
          :code $ quote $ defn element-data-set! (element key value)
            js-set (js-get element |dataset) key value
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.browser/DomElementHost 'String 'String
            :features $ #{} :js-ffi
        'element-dataset $ %{} 'CodeEntry
          :doc "|Returns the raw DOM element dataset object. Prefer element-data-get / element-data-set! / element-data-remove! for typed access; this raw accessor is deprecated and will be removed in a future release."
          :code $ quote $ defn element-dataset (element)
            unsafe-coerce (element :dataset) JsObject
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'JsObject)
            :args $ [] 'js-ffi.browser/DomElementHost
            :features $ #{} :js-ffi
        'element-dispatch-event! $ %{} 'CodeEntry
          :doc "|Dispatch a host Event through an element and return whether it was not canceled."
          :code $ quote $ defn element-dispatch-event! (element event)
            assert-type (.!dispatchEvent element event) 'Bool
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Bool)
            :args $ [] 'js-ffi.browser/DomElementHost 'js-ffi.browser/EventHost
            :features $ #{} :js-ffi
        'element-first-child $ %{} 'CodeEntry
          :doc "|Return the first child element as Option, normalizing a missing child."
          :code $ quote $ defn element-first-child (element)
            js-nullish->option $ assert-type (.-firstElementChild element) (:: 'JsNullish 'js-ffi.browser/DomElementHost)
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'js-ffi.browser/DomElementHost
            :features $ #{} :js-ffi
            :return $ :: 'calcit.core/Option 'js-ffi.browser/DomElementHost
        'element-focus! $ %{} 'CodeEntry (:doc "|Focus an HTML element with focus capability.")
          :code $ quote $ defn element-focus! (element) (element .focus!) &unit
          :examples $ []
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.browser/DomElementHost
            :features $ #{} :js-ffi
        'element-get-attribute $ %{} 'CodeEntry (:doc "|Read a DOM attribute as Option<String>.")
          :code $ quote $ defn element-get-attribute (element key)
            js-nullish->option $ element .get-attribute key
          :examples $ []
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {}
            :args $ [] 'js-ffi.browser/DomElementHost 'String
            :features $ #{} :js-ffi
            :return $ :: 'calcit.core/Option 'String
        'element-host $ %{} 'CodeEntry
          :doc "|Validate an opaque host value as an object and expose the shared DOM element capability."
          :code $ quote $ defn element-host (value)
            assert-type (contract/expect-object |DOM.element-host value) 'js-ffi.browser/DomElementHost
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'js-ffi.browser/DomElementHost)
            :args $ [] 'T
            :features $ #{} :js-ffi
            :generics $ [] 'T
        'element-matches? $ %{} 'CodeEntry
          :doc "|Match a CSS selector; invalid selectors raise DOMException."
          :code $ quote $ defn element-matches? (element selector) (element .matches? selector)
          :examples $ []
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {} (:return 'Bool)
            :args $ [] 'js-ffi.browser/DomElementHost 'String
            :features $ #{} :js-ffi
        'element-query-selector $ %{} 'CodeEntry (:doc "|Find a descendant or return Option.none.")
          :code $ quote $ defn element-query-selector (element selector)
            js-nullish->option $ element .query-selector selector
          :examples $ []
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {}
            :args $ [] 'js-ffi.browser/DomElementHost 'String
            :features $ #{} :js-ffi
            :return $ :: 'calcit.core/Option 'js-ffi.browser/DomElementHost
        'element-remove! $ %{} 'CodeEntry
          :doc "|Remove a DOM element from its current parent and return Unit."
          :code $ quote $ defn element-remove! (element) (.!remove element) &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.browser/DomElementHost
            :features $ #{} :js-ffi
        'element-remove-attribute! $ %{} 'CodeEntry (:doc "|Remove a DOM attribute.")
          :code $ quote $ defn element-remove-attribute! (element key) (element .remove-attribute! key) &unit
          :examples $ []
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.browser/DomElementHost 'String
            :features $ #{} :js-ffi
        'element-remove-event-listener! $ %{} 'CodeEntry (:doc "|Remove a typed event listener from one element.")
          :code $ quote $ defn element-remove-event-listener! (element event-name callback) (element .remove-event-listener! event-name callback) &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.browser/DomElementHost 'String $ :: 'Fn
              {} (:return 'Unit)
                :args $ [] 'js-ffi.browser/EventHost
            :features $ #{} :js-ffi
        'element-request-fullscreen! $ %{} 'CodeEntry
          :doc "|Request fullscreen for a typed element. The host Promise is not awaited and the adapter returns Unit."
          :code $ quote $ defn element-request-fullscreen! (element) (element .request-fullscreen!) &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.browser/DomElementHost
            :features $ #{} :js-ffi
        'element-select! $ %{} 'CodeEntry
          :doc "|Select the editable text of an input or textarea element and return Unit."
          :code $ quote $ defn element-select! (element) (element .select!) &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.browser/DomSelectableHost
            :features $ #{} :js-ffi
        'element-set-attribute! $ %{} 'CodeEntry (:doc "|Set a DOM attribute.")
          :code $ quote $ defn element-set-attribute! (element key text) (element .set-attribute! key text) &unit
          :examples $ []
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.browser/DomElementHost 'String 'String
            :features $ #{} :js-ffi
        'element-set-class-name! $ %{} 'CodeEntry
          :doc "|Replace one element className through DomElementHost.className."
          :code $ quote $ defn element-set-class-name! (element class-name) (js-set element :class-name class-name) &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.browser/DomElementHost 'String
            :features $ #{} :js-ffi
        'element-set-css-text! $ %{} 'CodeEntry
          :doc "|Replace one element full inline style text through element.style.cssText."
          :code $ quote $ defn element-set-css-text! (element text)
            let
                style $ element-style element
              js-set style :css-text text
              , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.browser/DomElementHost 'String
            :features $ #{} :js-ffi
        'element-set-hidden! $ %{} 'CodeEntry
          :doc "|Toggle one element hidden flag through DomElementHost.hidden."
          :code $ quote $ defn element-set-hidden! (element hidden) (js-set element :hidden hidden) &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.browser/DomElementHost 'Bool
            :features $ #{} :js-ffi
        'element-set-inner-html! $ %{} 'CodeEntry
          :doc "|Replace one element HTML through DomElementHost.innerHTML."
          :code $ quote $ defn element-set-inner-html! (element html) (js-set element :inner-html html) &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.browser/DomElementHost 'String
            :features $ #{} :js-ffi
        'element-set-placeholder! $ %{} 'CodeEntry
          :doc "|Set an input-like element placeholder through DomElementHost.placeholder."
          :code $ quote $ defn element-set-placeholder! (element text) (js-set element :placeholder text) &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.browser/DomElementHost 'String
            :features $ #{} :js-ffi
        'element-set-style! $ %{} 'CodeEntry
          :doc "|Set one inline CSS property on an element and return Unit."
          :code $ quote $ defn element-set-style! (element property value)
            aset (.-style element) property value
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.browser/DomElementHost 'String 'String
            :features $ #{} :js-ffi
        'element-set-text-content! $ %{} 'CodeEntry
          :doc "|Replace one element text content through DomElementHost.textContent."
          :code $ quote $ defn element-set-text-content! (element text) (js-set element :text-content text) &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.browser/DomElementHost 'String
            :features $ #{} :js-ffi
        'element-set-value! $ %{} 'CodeEntry
          :doc "|Set an input-like element value through DomElementHost.value."
          :code $ quote $ defn element-set-value! (element value) (js-set element :value value) &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.browser/DomElementHost 'String
            :features $ #{} :js-ffi
        'element-snapshot $ %{} 'CodeEntry
          :doc "|Copy a typed DOM element into ElementSnapshot, converting nullish textContent to Option<String>."
          :code $ quote $ defn element-snapshot (element)
            &%{} ElementSnapshot :id (element :id) :class-name (element :class-name) :text-content
              js-nullish->option $ element :text-content
              , :child-count $ element :child-element-count
          :examples $ [] $ quote ElementSnapshot
          :schema $ :: 'Fn $ {} (:return 'js-ffi.browser/ElementSnapshot)
            :args $ [] 'js-ffi.browser/DomElementHost
            :features $ #{} :js-ffi
        'element-style $ %{} 'CodeEntry
          :doc "|Returns the raw DOM element style object. Prefer element-style-get / element-set-style! for typed access; this raw accessor is deprecated and will be removed in a future release."
          :code $ quote $ defn element-style (element)
            unsafe-coerce (element :style) StyleHost
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'js-ffi.browser/StyleHost)
            :args $ [] 'js-ffi.browser/DomElementHost
            :features $ #{} :js-ffi
        'element-style-get $ %{} 'CodeEntry
          :doc "|Read one inline CSS property as Option<String> through element.style."
          :code $ quote $ defn element-style-get (element key)
            let
                style $ contract/expect-object |element.style $ js-get element |style
                value $ js-get style key
              if (js-nullish? value) (%none)
                %some $ contract/expect-string |element.style value
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'js-ffi.browser/DomElementHost 'String
            :features $ #{} :js-ffi
            :return $ :: 'calcit.core/Option 'String
        'event-host $ %{} 'CodeEntry
          :doc "|Validate an opaque host value as an object and expose the shared browser Event capability."
          :code $ quote $ defn event-host (value)
            assert-type (contract/expect-object |DOM.event-host value) 'js-ffi.browser/EventHost
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'js-ffi.browser/EventHost)
            :args $ [] 'T
            :features $ #{} :js-ffi
            :generics $ [] 'T
        'event-listener-host $ %{} 'CodeEntry
          :doc "|Validate an opaque host value as a browser Event listener callback."
          :code $ quote $ defn event-listener-host (value)
            assert-type (contract/expect-function |DOM.event-listener-host value)
              :: 'Fn $ {}
                :args $ [] 'js-ffi.browser/EventHost
                :return 'Unit
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'T
            :features $ #{} :js-ffi
            :generics $ [] 'T
            :return $ :: 'Fn $ {} (:return 'Unit)
              :args $ [] 'js-ffi.browser/EventHost
        'event-stop-propagation! $ %{} 'CodeEntry
          :doc "|Stop propagation of a browser Event and return Unit."
          :code $ quote $ defn event-stop-propagation! (event) (event .stop-propagation!) &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.browser/EventHost
            :features $ #{} :js-ffi
        'event-target-element $ %{} 'CodeEntry
          :doc "|Decode the event target as Option<DomElementHost>; non-element or absent targets yield none."
          :code $ quote $ defn event-target-element (event)
            let
                target $ js-get event |target
              if (js-nullish? target) (%none)
                %some $ assert-type (contract/expect-object |event.target target) (quote js-ffi.browser/DomElementHost)
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'js-ffi.browser/EventHost
            :features $ #{} :js-ffi
            :return $ :: 'calcit.core/Option 'js-ffi.browser/DomElementHost
        'form-data-append! $ %{} 'CodeEntry
          :doc "|Append one String field to a FormData capability."
          :code $ quote $ defn form-data-append! (form name value) (form .append! name value) &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.browser/FormDataHost 'String 'String
            :features $ #{} :js-ffi
        'form-data-create $ %{} 'CodeEntry
          :doc "|Create an empty FormData capability for multipart request bodies."
          :code $ quote $ defn form-data-create ()
            unsafe-coerce (new js/FormData) FormDataHost
          :examples $ []
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {} (:return 'js-ffi.browser/FormDataHost)
            :args $ []
            :features $ #{} :js-ffi
        'history-push-state! $ %{} 'CodeEntry
          :doc "|Push a history entry through history.pushState without reloading the document."
          :code $ quote $ defn history-push-state! (url) (js/history.pushState 0 | url) &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'String
            :features $ #{} :js-ffi
        'history-replace-state! $ %{} 'CodeEntry
          :doc "|Replace the current history entry through history.replaceState without reloading the document."
          :code $ quote $ defn history-replace-state! (url) (js/history.replaceState 0 | url) &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'String
            :features $ #{} :js-ffi
        'image-create $ %{} 'CodeEntry
          :doc "|Create an empty HTMLImageElement host capability."
          :code $ quote $ defn image-create ()
            unsafe-coerce (new js/Image) ImageHost
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'js-ffi.browser/ImageHost)
            :args $ []
            :features $ #{} :js-ffi
        'image-decode! $ %{} 'CodeEntry
          :doc "|Await image.decode once so the natural size is available, or normalize a JsError."
          :code $ quote $ defn image-decode! (image)
            hint-fn $ {} (:async true)
              :args $ [] 'js-ffi.browser/ImageHost
              :features $ #{} :js-ffi
              :return $ :: 'Result 'Unit 'js-ffi.shared/JsError
            try
              do
                js-await $ image .decode
                %:: Result :ok &unit
              fn (error)
                %:: Result :err $ shared/normalize-error error
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'js-ffi.browser/ImageHost
            :features $ #{} :js-ffi
            :return $ :: 'calcit.core/Result 'Unit 'js-ffi.shared/JsError
        'image-natural-height $ %{} 'CodeEntry
          :doc "|Return image.naturalHeight after the image has decoded."
          :code $ quote $ defn image-natural-height (image)
            identity $ image :natural-height
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Number)
            :args $ [] 'js-ffi.browser/ImageHost
            :features $ #{} :js-ffi
        'image-natural-width $ %{} 'CodeEntry
          :doc "|Return image.naturalWidth after the image has decoded."
          :code $ quote $ defn image-natural-width (image)
            identity $ image :natural-width
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Number)
            :args $ [] 'js-ffi.browser/ImageHost
            :features $ #{} :js-ffi
        'image-src! $ %{} 'CodeEntry (:doc "|Set the image source URL.")
          :code $ quote $ defn image-src! (image src) (js-set image :src src) &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.browser/ImageHost 'String
            :features $ #{} :js-ffi
        'keyboard-event-host $ %{} 'CodeEntry
          :doc "|Validate an opaque host value as an object and expose keyboard-event fields."
          :code $ quote $ defn keyboard-event-host (value)
            assert-type (contract/expect-object |DOM.keyboard-event-host value) 'js-ffi.browser/KeyboardEventHost
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'js-ffi.browser/KeyboardEventHost)
            :args $ [] 'T
            :features $ #{} :js-ffi
            :generics $ [] 'T
        'keyboard-event-key $ %{} 'CodeEntry
          :doc "|Read KeyboardEvent.key through the typed host capability."
          :code $ quote $ defn keyboard-event-key (event)
            let
                key $ event :key
              , key
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ [] 'js-ffi.browser/KeyboardEventHost
            :features $ #{} :js-ffi
        'local-storage-available? $ %{} 'CodeEntry
          :doc "|Return whether localStorage is available. Browsers may deny storage in privacy or sandboxed modes, so callers should branch on this Boolean. Example: (local-storage-available?) => true"
          :code $ quote $ defn local-storage-available? () (exists? js/localStorage)
          :examples $ [] $ quote "(local-storage-available?)"
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {} (:return 'Bool)
            :args $ []
            :features $ #{} :js-ffi
        'location-host $ %{} 'CodeEntry
          :doc "|Return the typed LocationHost capability for browser navigation fields and effects."
          :code $ quote $ defn location-host () (unsafe-coerce js/location LocationHost)
          :examples $ []
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {} (:return 'js-ffi.browser/LocationHost)
            :args $ []
            :features $ #{} :js-ffi
        'location-href $ %{} 'CodeEntry
          :doc "|Read location.href through the typed LocationHost contract."
          :code $ quote $ defn location-href () (str js/location.href)
          :examples $ [] $ quote (location-href)
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ []
            :features $ #{} :js-ffi
        'location-replace! $ %{} 'CodeEntry
          :doc "|Replace the current history entry with the given URL through LocationHost.replace."
          :code $ quote $ defn location-replace! (url)
            let
                host $ location-host
              host .replace! url
              , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'String
            :features $ #{} :js-ffi
        'location-snapshot $ %{} 'CodeEntry
          :doc "|Read the stable Location URL fields once and return a typed LocationSnapshot."
          :code $ quote $ defn location-snapshot ()
            let
                host $ location-host
              &%{} LocationSnapshot :href (host :href) :origin (host :origin) :protocol (host :protocol) :host (host :host) :hostname (host :hostname) :port (host :port) :pathname (host :pathname) :search (host :search) :hash $ host :hash
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'js-ffi.browser/LocationSnapshot)
            :args $ []
            :features $ #{} :js-ffi
        'mouse-event-from-event $ %{} 'CodeEntry
          :doc "|Create a MouseEvent that preserves the source Event type and compatible initialization fields."
          :code $ quote $ defn mouse-event-from-event (event)
            assert-type
              new js/MouseEvent (event :event-type) event
              quote js-ffi.browser/EventHost
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'js-ffi.browser/EventHost)
            :args $ [] 'js-ffi.browser/EventHost
            :features $ #{} :js-ffi
        'mouse-event-host $ %{} 'CodeEntry
          :doc "|Validate an opaque host value as a MouseEvent capability."
          :code $ quote $ defn mouse-event-host (value)
            assert-type (contract/expect-object |MouseEvent.host value) (quote js-ffi.browser/MouseEventHost)
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'js-ffi.browser/MouseEventHost)
            :args $ [] 'T
            :features $ #{} :js-ffi
            :generics $ [] 'T
        'notification-request-permission! $ %{} 'CodeEntry
          :doc "|Await Notification.requestPermission once and normalize the String permission or JsError."
          :code $ quote $ defn notification-request-permission! ()
            hint-fn $ {} (:async true)
              :args $ []
              :features $ #{} :js-ffi
              :return $ :: 'Result 'String 'js-ffi.shared/JsError
            try
              %:: Result :ok $ contract/expect-string |Notification.requestPermission $ js-await (js/Notification.requestPermission)
              fn (error)
                %:: Result :err $ shared/normalize-error error
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ []
            :features $ #{} :js-ffi
            :return $ :: 'calcit.core/Result 'String 'js-ffi.shared/JsError
        'object-url-create $ %{} 'CodeEntry
          :doc "|Create an object URL for a Blob after a runtime String check."
          :code $ quote $ defn object-url-create (blob)
            contract/expect-string |URL.createObjectURL $ js/URL.createObjectURL blob
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ [] 'js-ffi.browser/BlobHost
            :features $ #{} :js-ffi
        'object-url-revoke! $ %{} 'CodeEntry
          :doc "|Revoke an object URL created by object-url-create."
          :code $ quote $ defn object-url-revoke! (url) (js/URL.revokeObjectURL url) &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'String
            :features $ #{} :js-ffi
        'pointer-event-host $ %{} 'CodeEntry
          :doc "|Validate an opaque host value as a PointerEvent capability (layerX/layerY)."
          :code $ quote $ defn pointer-event-host (value)
            assert-type (contract/expect-object |PointerEvent.host value) (quote js-ffi.browser/PointerEventHost)
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'js-ffi.browser/PointerEventHost)
            :args $ [] 'T
            :features $ #{} :js-ffi
            :generics $ [] 'T
        'probe $ %{} 'CodeEntry
          :doc "|Run the browser capability smoke probe and return typed BrowserProbe data."
          :code $ quote $ defn probe ()
            &%{} BrowserProbe :runtime (runtime) :document? (document-available?) :storage (storage-roundtrip!) :viewport $ viewport
          :examples $ [] $ quote (probe)
          :schema $ :: 'Fn $ {} (:return 'js-ffi.browser/BrowserProbe)
            :args $ []
        'prompt! $ %{} 'CodeEntry
          :doc "|Show a blocking browser prompt and return the entered text as Option<String>; cancellation yields none."
          :code $ quote $ defn prompt! (message)
            let
                raw $ js/prompt message
              if (js-nullish? raw) (%none)
                %some $ contract/expect-string |prompt raw
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'String
            :features $ #{} :js-ffi
            :return $ :: 'calcit.core/Option 'String
        'query-selector $ %{} 'CodeEntry
          :doc "|Query document for a selector and normalize a missing element into Option<DomElementHost>."
          :code $ quote $ defn query-selector (selector)
            let
                host-document $ unsafe-coerce js/document DocumentHost
              js-nullish->option $ host-document .query-selector selector
          :examples $ []
            quote $ query-selector |.app
            quote $ option:unwrap-or (query-selector |#main) nil
          :schema $ :: 'Fn $ {}
            :args $ [] 'String
            :features $ #{} :js-ffi
            :return $ :: 'calcit.core/Option 'js-ffi.browser/DomElementHost
        'random $ %{} 'CodeEntry
          :doc "|Return a browser-compatible random number in the range 0 inclusive to 1 exclusive. The concrete return type is Number. Example: (random) => 0.42"
          :code $ quote $ defn random ()
            unsafe-coerce (js/Math.random) Number
          :examples $ [] $ quote "(random)"
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {} (:return 'Number)
            :args $ []
            :features $ #{} :js-ffi
        'remove-event-listener! $ %{} 'CodeEntry
          :doc "|Remove a previously registered typed browser window listener."
          :code $ quote $ defn remove-event-listener! (event-name callback)
            let
                host-window $ unsafe-coerce js/window WindowHost
              host-window .remove-event-listener! event-name callback
              , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'String $ :: 'Fn
              {} (:return 'Unit)
                :args $ [] 'js-ffi.browser/EventHost
            :features $ #{} :js-ffi
        'request-animation-frame! $ %{} 'CodeEntry
          :doc "|Schedule a frame callback receiving a timestamp; returns a cancellable numeric handle."
          :code $ quote $ defn request-animation-frame! (callback)
            contract/expect-number |requestAnimationFrame $ js/requestAnimationFrame callback
          :examples $ []
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {} (:return 'Number)
            :args $ [] $ :: 'Fn
              {} (:return 'Unit)
                :args $ [] 'Number
            :features $ #{} :js-ffi
        'runtime $ %{} 'CodeEntry
          :doc "|Return the normalized Runtime browser enum variant."
          :code $ quote $ defn runtime () (shared/Runtime :browser)
          :examples $ [] $ quote (runtime)
          :schema $ :: 'Fn $ {} (:return 'js-ffi.shared/Runtime)
            :args $ []
        'runtime-name $ %{} 'CodeEntry
          :doc "|Return the literal runtime identifier |browser. This is useful for environment contracts and keeps callers independent from host-specific globals. Example: (runtime-name) => |browser"
          :code $ quote $ defn runtime-name () |browser
          :examples $ [] $ quote "(runtime-name)"
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ []
        'screen-height $ %{} 'CodeEntry
          :doc "|Read screen.height after a runtime Number check."
          :code $ quote $ defn screen-height () (contract/expect-number |screen.height js/window.screen.height)
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Number)
            :args $ []
            :features $ #{} :js-ffi
        'screen-width $ %{} 'CodeEntry (:doc "|Read screen.width after a runtime Number check.")
          :code $ quote $ defn screen-width () (contract/expect-number |screen.width js/window.screen.width)
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Number)
            :args $ []
            :features $ #{} :js-ffi
        'selectable-element-host $ %{} 'CodeEntry
          :doc "|Validate an opaque host value as an object and expose the selectable input or textarea capability."
          :code $ quote $ defn selectable-element-host (value)
            assert-type (contract/expect-object |DOM.selectable-element-host value) DomSelectableHost
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'js-ffi.browser/DomSelectableHost)
            :args $ [] 'T
            :features $ #{} :js-ffi
            :generics $ [] 'T
        'set-before-unload! $ %{} 'CodeEntry (:doc "|Install a typed browser beforeunload callback.")
          :code $ quote $ defn set-before-unload! (callback)
            let
                host-window $ unsafe-coerce js/window WindowHost
              js-set host-window :on-before-unload callback
              , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] $ :: 'Fn
              {} (:return 'Unit)
                :args $ [] 'js-ffi.browser/EventHost
            :features $ #{} :js-ffi
        'set-interval! $ %{} 'CodeEntry
          :doc "|Schedule a repeated browser callback and return the numeric timer identifier. The callback receives no arguments and returns Unit."
          :code $ quote $ defn set-interval! (callback delay)
            unsafe-coerce (js/setInterval callback delay) Number
          :examples $ [] $ quote
            set-interval!
              fn () $ console-log! |heartbeat
              , 60000
          :schema $ :: 'Fn $ {} (:return 'Number)
            :args $ []
              :: 'Fn $ {} (:return 'Unit)
                :args $ []
              , 'Number
            :features $ #{} :js-ffi
        'set-timeout! $ %{} 'CodeEntry
          :doc "|Schedule a Unit callback and return the browser numeric timer id. Node timer handles intentionally use a separate contract."
          :code $ quote $ defn set-timeout! (callback delay)
            unsafe-coerce (js/setTimeout callback delay) Number
          :examples $ [] $ quote
            set-timeout!
              fn () nil
              , 10
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {} (:return 'Number)
            :args $ []
              :: 'Fn $ {} (:return 'Unit)
                :args $ []
              , 'Number
            :features $ #{} :js-ffi
        'speech-synthesis-cancel! $ %{} 'CodeEntry
          :doc "|Cancel all pending browser speech synthesis utterances."
          :code $ quote $ defn speech-synthesis-cancel! () (js/speechSynthesis.cancel) &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'speech-synthesis-speak! $ %{} 'CodeEntry
          :doc "|Speak one String through the browser SpeechSynthesis API."
          :code $ quote $ defn speech-synthesis-speak! (text)
            js/speechSynthesis.speak $ new js/SpeechSynthesisUtterance text
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'String
            :features $ #{} :js-ffi
        'storage-get $ %{} 'CodeEntry
          :doc "|Read one localStorage key as Option<String>; missing and JavaScript nullish values become none. Host exceptions remain an adapter concern."
          :code $ quote $ defn storage-get (key)
            let
                storage $ unsafe-coerce js/localStorage StorageHost
              js-nullish->option $ storage .get-item key
          :examples $ [] $ quote (storage-get |theme)
          :schema $ :: 'Fn $ {}
            :args $ [] 'String
            :features $ #{} :js-ffi
            :return $ :: 'calcit.core/Option 'String
        'storage-get-or $ %{} 'CodeEntry
          :doc "|Read localStorage as Option<String> internally and return the supplied fallback for a missing key."
          :code $ quote $ defn storage-get-or (key fallback)
            option:unwrap-or (storage-get key) fallback
          :examples $ [] $ quote (storage-get-or |theme |light)
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ [] 'String 'String
        'storage-remove! $ %{} 'CodeEntry
          :doc "|Remove a localStorage key through StorageHost and return Unit."
          :code $ quote $ defn storage-remove! (key)
            when (local-storage-available?)
              let
                  storage $ unsafe-coerce js/localStorage StorageHost
                storage .remove-item! key
            , &unit
          :examples $ [] $ quote (storage-remove! |js-ffi-smoke)
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'String
            :features $ #{} :js-ffi
        'storage-roundtrip! $ %{} 'CodeEntry
          :doc "|Exercise localStorage with a deterministic String result for smoke tests. It writes |ok, reads it back, and returns |unavailable when storage is missing. Example: (storage-roundtrip!) => |ok"
          :code $ quote $ defn storage-roundtrip! ()
            if (local-storage-available?)
              do (storage-set! |js-ffi-smoke |ok) (storage-get-or |js-ffi-smoke |unavailable)
              , |unavailable
          :examples $ [] $ quote "(storage-roundtrip!)"
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ []
            :features $ #{} :js-ffi
        'storage-set! $ %{} 'CodeEntry
          :doc "|Write a String key/value pair through StorageHost and normalize the host return to Unit."
          :code $ quote $ defn storage-set! (key value)
            when (local-storage-available?)
              let
                  storage $ unsafe-coerce js/localStorage StorageHost
                storage .set-item! key value
            , &unit
          :examples $ [] $ quote (storage-set! |theme |dark)
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'String 'String
            :features $ #{} :js-ffi
        'user-agent $ %{} 'CodeEntry
          :doc "|Read navigator.userAgent after a runtime String check."
          :code $ quote $ defn user-agent () (contract/expect-string |navigator.userAgent js/window.navigator.userAgent)
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ []
            :features $ #{} :js-ffi
        'viewport $ %{} 'CodeEntry
          :doc "|Read Window viewport fields once and return normalized Viewport data."
          :code $ quote $ defn viewport ()
            let
                host-window $ unsafe-coerce js/window WindowHost
              &%{} Viewport :width (host-window :inner-width) :height (host-window :inner-height) :device-pixel-ratio $ host-window :device-pixel-ratio
          :examples $ [] $ quote (viewport)
          :schema $ :: 'Fn $ {} (:return 'js-ffi.browser/Viewport)
            :args $ []
            :features $ #{} :js-ffi
        'viewport-height $ %{} 'CodeEntry
          :doc "|Return the height field from normalized Viewport data."
          :code $ quote $ defn viewport-height ()
            :height $ viewport
          :examples $ [] $ quote (viewport-height)
          :schema $ :: 'Fn $ {} (:return 'Number)
            :args $ []
        'viewport-width $ %{} 'CodeEntry
          :doc "|Return the width field from normalized Viewport data."
          :code $ quote $ defn viewport-width ()
            :width $ viewport
          :examples $ [] $ quote (viewport-width)
          :schema $ :: 'Fn $ {} (:return 'Number)
            :args $ []
        'visibility-state $ %{} 'CodeEntry
          :doc "|Read and decode document.visibilityState through the typed DocumentHost contract."
          :code $ quote $ defn visibility-state ()
            let
                host-document $ unsafe-coerce js/document DocumentHost
              decode-visibility-state $ host-document :visibility-state
          :examples $ [] $ quote (visibility-state)
          :schema $ :: 'Fn $ {} (:return 'js-ffi.browser/VisibilityState)
            :args $ []
            :features $ #{} :js-ffi
        'web-socket-close! $ %{} 'CodeEntry (:doc "|Close the socket.")
          :code $ quote $ defn web-socket-close! (socket) (socket .close!) &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.browser/WebSocketHost
            :features $ #{} :js-ffi
        'web-socket-create $ %{} 'CodeEntry
          :doc "|Create a WebSocket connection to the given ws:// or wss:// URL."
          :code $ quote $ defn web-socket-create (url)
            unsafe-coerce (new js/WebSocket url) WebSocketHost
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'js-ffi.browser/WebSocketHost)
            :args $ [] 'String
            :features $ #{} :js-ffi
        'web-socket-on-close! $ %{} 'CodeEntry (:doc "|Install a typed close-event callback.")
          :code $ quote $ defn web-socket-on-close! (socket callback) (js-set socket :on-close callback) &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.browser/WebSocketHost $ :: 'Fn
              {} (:return 'Unit)
                :args $ [] 'js-ffi.browser/EventHost
            :features $ #{} :js-ffi
        'web-socket-on-error! $ %{} 'CodeEntry (:doc "|Install a typed error-event callback.")
          :code $ quote $ defn web-socket-on-error! (socket callback) (js-set socket :on-error callback) &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.browser/WebSocketHost $ :: 'Fn
              {} (:return 'Unit)
                :args $ [] 'js-ffi.browser/EventHost
            :features $ #{} :js-ffi
        'web-socket-on-message! $ %{} 'CodeEntry
          :doc "|Install a callback receiving each incoming message decoded as String."
          :code $ quote $ defn web-socket-on-message! (socket callback)
            js-set socket :on-message $ fn (event)
              callback $ contract/expect-string |ws.message $ js-get event |data
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.browser/WebSocketHost $ :: 'Fn
              {} (:return 'Unit)
                :args $ [] 'String
            :features $ #{} :js-ffi
        'web-socket-on-open! $ %{} 'CodeEntry (:doc "|Install a typed open-event callback.")
          :code $ quote $ defn web-socket-on-open! (socket callback) (js-set socket :on-open callback) &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.browser/WebSocketHost $ :: 'Fn
              {} (:return 'Unit)
                :args $ [] 'js-ffi.browser/EventHost
            :features $ #{} :js-ffi
        'web-socket-ready-state $ %{} 'CodeEntry
          :doc "|Return the numeric readyState: 0 connecting, 1 open, 2 closing, 3 closed."
          :code $ quote $ defn web-socket-ready-state (socket)
            identity $ socket :ready-state
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Number)
            :args $ [] 'js-ffi.browser/WebSocketHost
            :features $ #{} :js-ffi
        'web-socket-send! $ %{} 'CodeEntry (:doc "|Send one String frame through the socket.")
          :code $ quote $ defn web-socket-send! (socket text) (socket .send! text) &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.browser/WebSocketHost 'String
            :features $ #{} :js-ffi
        'window-host $ %{} 'CodeEntry
          :doc "|Return the typed WindowHost capability for the current browser window."
          :code $ quote $ defn window-host () (unsafe-coerce js/window WindowHost)
          :examples $ []
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {} (:return 'js-ffi.browser/WindowHost)
            :args $ []
            :features $ #{} :js-ffi
        'window-local-storage $ %{} 'CodeEntry
          :doc "|Return window.localStorage as the typed StorageHost capability."
          :code $ quote $ defn window-local-storage () (unsafe-coerce js/window.localStorage StorageHost)
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'js-ffi.browser/StorageHost)
            :args $ []
            :features $ #{} :js-ffi
        'window-open $ %{} 'CodeEntry
          :doc "|Open a browser window or tab through WindowHost and return the typed WindowHost as Option; popup blocking yields none."
          :code $ quote $ defn window-open (url)
            let
                host $ window-host
              js-nullish->option $ host .open url
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'String
            :features $ #{} :js-ffi
            :return $ :: 'calcit.core/Option 'js-ffi.browser/WindowHost
      :ns $ %{} 'NsEntry
        :doc "|Typed browser JavaScript FFI with normalized Struct/Enum results and explicit external-object contracts for Window, Document, Location, Storage, DOM elements, and events."
        :code $ quote $ ns js-ffi.browser
          :require (js-ffi.shared :as shared) (js-ffi.contract :as contract)
    'js-ffi.browser-test $ %{} 'FileEntry
      :defs $ {}
        'main! $ %{} 'CodeEntry
          :doc "|Run the typed browser smoke probe and verify its Runtime enum."
          :code $ quote $ defn main! ()
            let
                result $ browser/probe
                element $ browser/create-element |div
                on-resize $ fn (event)
                  hint-fn $ {}
                    :args $ [] 'js-ffi.browser/EventHost
                    :return 'Unit
                  , &unit
              assert-type result js-ffi.browser/BrowserProbe
              assert-type element js-ffi.browser/DomElementHost
              browser/add-event-listener! |resize on-resize
              browser/remove-event-listener! |resize on-resize
              browser/set-before-unload! $ fn (event)
                hint-fn $ {}
                  :args $ [] 'js-ffi.browser/EventHost
                  :return 'Unit
                , &unit
              shared/queue-microtask! $ fn ()
                hint-fn $ {}
                  :args $ []
                  :return 'Unit
                shared/console-log! |js-ffi-browser-microtask-passed
              shared/console-log! |js-ffi-browser-smoke
              if
                contract/valid-runtime? (shared/Runtime :browser) (:runtime result)
                shared/console-log! |js-ffi-browser-smoke-passed
                shared/console-error! |js-ffi-browser-smoke-failed
              , &unit
          :examples $ [] $ quote (main!)
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
        'reload! $ %{} 'CodeEntry (:doc "|No-op browser reload hook returning Unit.")
          :code $ quote $ defn reload! () &unit
          :examples $ [] $ quote (reload!)
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns js-ffi.browser-test
          :require (js-ffi.browser :as browser) (js-ffi.contract :as contract) (js-ffi.shared :as shared) (js-ffi.webgpu :as webgpu)
    'js-ffi.canvas-batches $ %{} 'FileEntry
      :defs $ {}
        'CanvasAffine2D $ %{} 'CodeEntry (:doc "|Canvas2D 六系数仿射矩阵；传给原生 transform，单位和坐标系由调用方决定。")
          :code $ quote $ defstruct CanvasAffine2D (:a 'Number) (:b 'Number) (:c 'Number) (:d 'Number) (:e 'Number) (:f 'Number)
          :examples $ []
          :schema $ :: 'StructDef
        'CanvasContextHost $ %{} 'CodeEntry
          :doc "|浏览器 CanvasRenderingContext2D 类型化宿主能力；提供 save/restore、fillRect/clearRect、仿射变换和基础矩形路径裁剪。fillStyle 当前仅覆盖纯色 String 子集。"
          :code $ quote $ deftrait CanvasContextHost (:fill-style 'String)
            .save! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.canvas-batches/CanvasContextHost
              :return 'Unit
            .restore! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.canvas-batches/CanvasContextHost
              :return 'Unit
            .fill-rect! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.canvas-batches/CanvasContextHost 'Number 'Number 'Number 'Number
              :return 'Unit
            .set-transform! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.canvas-batches/CanvasContextHost 'Number 'Number 'Number 'Number 'Number 'Number
              :return 'Unit
            .transform! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.canvas-batches/CanvasContextHost 'Number 'Number 'Number 'Number 'Number 'Number
              :return 'Unit
            .begin-path! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.canvas-batches/CanvasContextHost
              :return 'Unit
            .rect! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.canvas-batches/CanvasContextHost 'Number 'Number 'Number 'Number
              :return 'Unit
            .clip! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.canvas-batches/CanvasContextHost
              :return 'Unit
            .clear-rect! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.canvas-batches/CanvasContextHost 'Number 'Number 'Number 'Number
              :return 'Unit
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} (:begin-path! |beginPath) (:clear-rect! |clearRect) (:clip! |clip) (:fill-rect! |fillRect) (:fill-style |fillStyle) (:rect! |rect) (:restore! |restore) (:save! |save) (:set-transform! |setTransform) (:transform! |transform)
            :writable $ #{} :fill-style
          :schema $ :: 'Trait
        'CanvasRect $ %{} 'CodeEntry
          :doc "|Canvas2D 矩形的 x/y/width/height 基础数据，不绑定任何 Scene IR。"
          :code $ quote $ defstruct CanvasRect (:x 'Number) (:y 'Number) (:width 'Number) (:height 'Number)
          :examples $ []
          :schema $ :: 'StructDef
        'CanvasRectMetrics $ %{} 'CodeEntry
          :doc "|一次批次边界调用和逐矩形 Canvas 调用计数；position-bytes-read 并非 GPU 上传字节。"
          :code $ quote $ defstruct CanvasRectMetrics (:boundary-calls 'Number) (:canvas-calls 'Number) (:instances 'Number) (:position-bytes-read 'Number)
          :examples $ []
          :schema $ :: 'StructDef
        'clear-canvas! $ %{} 'CodeEntry (:doc "|在单位变换下清除给定实际像素区域，再恢复 Canvas 绘制状态；调用方传入像素宽高。")
          :code $ quote $ defn clear-canvas! (context pixel-width pixel-height)
            hint-fn $ {}
              :args $ [] 'js-ffi.canvas-batches/CanvasContextHost 'Number 'Number
              :return 'Unit
              :features $ #{} :js-ffi
            context .save!
            context .set-transform! 1 0 0 1 0 0
            context .clear-rect! 0 0 pixel-width pixel-height
            context .restore!
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.canvas-batches/CanvasContextHost 'Number 'Number
            :features $ #{} :js-ffi
        'draw-rects! $ %{} 'CodeEntry (:doc "|按输入顺序绘制一个 Float32 x/y 范围并返回类型化指标；宿主仅跨界一次。")
          :code $ quote $ defn draw-rects! (context positions start amount width height fill-style alpha)
            hint-fn $ {}
              :args $ [] 'js-ffi.canvas-batches/CanvasContextHost 'js-ffi.typed-arrays/Float32ArrayHost 'Number 'Number 'Number 'Number 'String 'Number
              :return 'js-ffi.canvas-batches/CanvasRectMetrics
              :features $ #{} :js-ffi
            let
                draw-batch $ unsafe-coerce drawFloat32RectBatch $ :: 'Fn
                  {}
                    :args $ [] 'js-ffi.canvas-batches/CanvasContextHost 'js-ffi.typed-arrays/Float32ArrayHost 'Number 'Number 'Number 'Number 'String 'Number
                    :return 'JsObject
                result $ draw-batch context positions start amount width height fill-style alpha
                boundary-calls $ contract/expect-number |CanvasRect.boundaryCalls $ contract/object-field |CanvasRect.draw result |boundaryCalls
                canvas-calls $ contract/expect-number |CanvasRect.canvasCalls $ contract/object-field |CanvasRect.draw result |canvasCalls
                instances $ contract/expect-number |CanvasRect.instances $ contract/object-field |CanvasRect.draw result |instances
                bytes-read $ contract/expect-number |CanvasRect.positionBytesRead $ contract/object-field |CanvasRect.draw result |positionBytesRead
              CanvasRectMetrics :boundary-calls boundary-calls :canvas-calls canvas-calls :instances instances :position-bytes-read bytes-read
          :examples $ []
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {} (:return 'js-ffi.canvas-batches/CanvasRectMetrics)
            :args $ [] 'js-ffi.canvas-batches/CanvasContextHost 'js-ffi.typed-arrays/Float32ArrayHost 'Number 'Number 'Number 'Number 'String 'Number
            :features $ #{} :js-ffi
        'fill-solid-rect! $ %{} 'CodeEntry (:doc "|通过 Calcit 类型化 Canvas2D 基础方法绘制一个纯色矩形，并恢复绘制状态。")
          :code $ quote $ defn fill-solid-rect! (context x y width height fill-style)
            hint-fn $ {}
              :args $ [] 'js-ffi.canvas-batches/CanvasContextHost 'Number 'Number 'Number 'Number 'String
              :return 'Unit
              :features $ #{} :js-ffi
            context .save!
            js-set context :fill-style fill-style
            context .fill-rect! x y width height
            context .restore!
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.canvas-batches/CanvasContextHost 'Number 'Number 'Number 'Number 'String
            :features $ #{} :js-ffi
        'fill-transformed-clipped-rect! $ %{} 'CodeEntry
          :doc "|通用 Calcit 组合：在 save/restore 作用域内应用变换、矩形裁剪并绘制纯色矩形；当前路径不是 Canvas 保存状态的一部分，调用后路径会变更。"
          :code $ quote $ defn fill-transformed-clipped-rect! (context transform clip rect fill-style)
            hint-fn $ {}
              :args $ [] 'js-ffi.canvas-batches/CanvasContextHost 'js-ffi.canvas-batches/CanvasAffine2D 'js-ffi.canvas-batches/CanvasRect 'js-ffi.canvas-batches/CanvasRect 'String
              :return 'Unit
              :features $ #{} :js-ffi
            context .save!
            context .transform! (:a transform) (:b transform) (:c transform) (:d transform) (:e transform) (:f transform)
            context .begin-path!
            context .rect! (:x clip) (:y clip) (:width clip) (:height clip)
            context .clip!
            js-set context :fill-style fill-style
            context .fill-rect! (:x rect) (:y rect) (:width rect) (:height rect)
            context .restore!
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.canvas-batches/CanvasContextHost 'js-ffi.canvas-batches/CanvasAffine2D 'js-ffi.canvas-batches/CanvasRect 'js-ffi.canvas-batches/CanvasRect 'String
            :features $ #{} :js-ffi
      :ns $ %{} 'NsEntry
        :doc "|浏览器 Canvas2D 类型化基础操作与 Float32 矩形批次；通用批量宿主绘制由包内 JS 实现，Scene 遍历由调用方负责。"
        :code $ quote $ ns js-ffi.canvas-batches
          :require
            |@calcit/js-ffi/canvas-rect-batches.mjs :refer $ drawFloat32RectBatch
            js-ffi.contract :as contract
            js-ffi.typed-arrays :as typed-arrays
    'js-ffi.canvas-scene $ %{} 'FileEntry
      :defs $ {}
        'CanvasSceneCommandsHost $ %{} 'CodeEntry
          :doc "|0.1.45 实验兼容的 push/pop/rect/instances 宿主命令数组；命令格式不作为新 Calcit 项目的通用 Scene IR。调用方负责专属场景 lowering，包内先全量校验再绘制。"
          :code $ quote $ deftrait CanvasSceneCommandsHost
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
          :schema $ :: 'Trait
        'CanvasSceneMetrics $ %{} 'CodeEntry (:doc "|一次边界调用的 Canvas 绘制数与实例读取字节；不是 GPU 上传或执行时间。")
          :code $ quote $ defstruct CanvasSceneMetrics (:boundary-calls 'Number) (:canvas-calls 'Number) (:groups 'Number) (:rectangles 'Number) (:instances 'Number) (:position-bytes-read 'Number)
          :examples $ []
          :schema $ :: 'StructDef
        'draw-scene! $ %{} 'CodeEntry
          :doc "|实验兼容入口：一次宿主边界调用执行旧命令格式；非法命令在清屏前拒绝，组隔离透明度不支持。新项目优先使用类型化 Canvas 基础方法与通用矩形批次。"
          :code $ quote $ defn draw-scene! (context commands width height dpr)
            hint-fn $ {}
              :args $ [] 'js-ffi.canvas-batches/CanvasContextHost 'js-ffi.canvas-scene/CanvasSceneCommandsHost 'Number 'Number 'Number
              :return 'js-ffi.canvas-scene/CanvasSceneMetrics
              :features $ #{} :js-ffi
            let
                draw-batch $ unsafe-coerce drawCanvasSceneCommands $ :: 'Fn
                  {}
                    :args $ [] 'js-ffi.canvas-batches/CanvasContextHost 'js-ffi.canvas-scene/CanvasSceneCommandsHost 'Number 'Number 'Number
                    :return 'JsObject
                result $ draw-batch context commands width height dpr
                boundary-calls $ contract/expect-number |CanvasScene.boundaryCalls $ contract/object-field |CanvasScene.draw result |boundaryCalls
                canvas-calls $ contract/expect-number |CanvasScene.canvasCalls $ contract/object-field |CanvasScene.draw result |canvasCalls
                groups $ contract/expect-number |CanvasScene.groups $ contract/object-field |CanvasScene.draw result |groups
                rectangles $ contract/expect-number |CanvasScene.rectangles $ contract/object-field |CanvasScene.draw result |rectangles
                instances $ contract/expect-number |CanvasScene.instances $ contract/object-field |CanvasScene.draw result |instances
                bytes-read $ contract/expect-number |CanvasScene.positionBytesRead $ contract/object-field |CanvasScene.draw result |positionBytesRead
              CanvasSceneMetrics :boundary-calls boundary-calls :canvas-calls canvas-calls :groups groups :rectangles rectangles :instances instances :position-bytes-read bytes-read
          :examples $ []
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {} (:return 'js-ffi.canvas-scene/CanvasSceneMetrics)
            :args $ [] 'js-ffi.canvas-batches/CanvasContextHost 'js-ffi.canvas-scene/CanvasSceneCommandsHost 'Number 'Number 'Number
            :features $ #{} :js-ffi
      :ns $ %{} 'NsEntry
        :doc "|0.1.45 起的 Canvas 整场景命令实验兼容入口；保留旧消费者，不鼓励新项目把命令格式当通用 Scene IR。"
        :code $ quote $ ns js-ffi.canvas-scene
          :require
            |@calcit/js-ffi/canvas-scene-commands.mjs :refer $ drawCanvasSceneCommands
            js-ffi.canvas-batches :as canvas-batches
            js-ffi.contract :as contract
    'js-ffi.contract $ %{} 'FileEntry
      :defs $ {}
        'expect-bool $ %{} 'CodeEntry
          :doc "|Decode an opaque JavaScript value as Bool after a runtime kind check. Null and undefined are reported as nullish; other mismatches raise a stable JS FFI contract violation."
          :code $ quote $ defn expect-bool (label value)
            let
                kind $ if (js-nullish? value) |nullish $ js/typeof value
              if (= |boolean kind) (unsafe-coerce value Bool)
                raise $ str "|JS FFI contract violation: " label "| expected Bool, got " kind
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Bool)
            :args $ [] 'String $ :: 'JsNullish 'JsObject
            :features $ #{} :js-ffi
        'expect-function $ %{} 'CodeEntry
          :doc "|Validate that an opaque JavaScript value is a non-null JavaScript function and return its opaque host identity. Use a small typed adapter for its call schema and receiver contract."
          :code $ quote $ defn expect-function (label value)
            let
                kind $ if (js-nullish? value) |nullish $ js/typeof value
              if (= |function kind) (unsafe-coerce value JsObject)
                raise $ str "|JS FFI contract violation: " label "| expected Function, got " kind
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'JsObject)
            :args $ [] 'String $ :: 'JsNullish 'JsObject
            :features $ #{} :js-ffi
        'expect-number $ %{} 'CodeEntry
          :doc "|Decode an opaque JavaScript value as Number after a runtime kind check. Null and undefined are reported as nullish; other mismatches raise a stable JS FFI contract violation."
          :code $ quote $ defn expect-number (label value)
            let
                kind $ if (js-nullish? value) |nullish $ js/typeof value
              if (= |number kind) (unsafe-coerce value Number)
                raise $ str "|JS FFI contract violation: " label "| expected Number, got " kind
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Number)
            :args $ [] 'String $ :: 'JsNullish 'JsObject
            :features $ #{} :js-ffi
        'expect-object $ %{} 'CodeEntry
          :doc "|Validate that an opaque JavaScript value is a non-null object and return it as JsObject. This proves only the shallow host kind; decode or check members before exposing concrete data."
          :code $ quote $ defn expect-object (label value)
            let
                kind $ if (js-nullish? value) |nullish $ js/typeof value
              if (= |object kind) (unsafe-coerce value JsObject)
                raise $ str "|JS FFI contract violation: " label "| expected Object, got " kind
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'JsObject)
            :args $ [] 'String $ :: 'JsNullish 'JsObject
            :features $ #{} :js-ffi
        'expect-string $ %{} 'CodeEntry
          :doc "|Decode an opaque JavaScript value as String after a runtime kind check. Null and undefined are reported as nullish; other mismatches raise a stable JS FFI contract violation."
          :code $ quote $ defn expect-string (label value)
            let
                kind $ if (js-nullish? value) |nullish $ js/typeof value
              if (= |string kind) (unsafe-coerce value String)
                raise $ str "|JS FFI contract violation: " label "| expected String, got " kind
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ [] 'String $ :: 'JsNullish 'JsObject
            :features $ #{} :js-ffi
        'object-field $ %{} 'CodeEntry
          :doc "|Read one named field from an opaque JavaScript object after checking the receiver. The result remains JsNullish<JsObject>; pass it through an expect primitive guard or explicitly normalize absence before returning concrete data."
          :code $ quote $ defn object-field (label object key)
            aget (expect-object label object) key
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'String (:: 'JsNullish 'JsObject) 'String
            :features $ #{} :js-ffi
            :return $ :: 'JsNullish 'JsObject
        'valid-runtime? $ %{} 'CodeEntry
          :doc "|Compare two normalized Runtime values without relying on open String identifiers."
          :code $ quote $ defn valid-runtime? (expected actual) (= expected actual)
          :examples $ [] $ quote
            valid-runtime? (shared/Runtime :node) (shared/Runtime :node)
          :schema $ :: 'Fn $ {} (:return 'Bool)
            :args $ [] 'js-ffi.shared/Runtime 'js-ffi.shared/Runtime
      :ns $ %{} 'NsEntry
        :doc "|Environment-independent typed contracts shared by Node.js and browser smoke tests."
        :code $ quote $ ns js-ffi.contract
          :require $ js-ffi.shared :as shared
    'js-ffi.node $ %{} 'FileEntry
      :defs $ {}
        'BufferHost $ %{} 'CodeEntry
          :doc "|External Node Buffer capability exposing UTF-8 decoding and byte length."
          :code $ quote $ deftrait BufferHost
            .to-string $ :: 'Fn $ {}
              :args $ [] 'js-ffi.node/BufferHost 'String
              :return 'String
            .byte-length $ :: 'Fn $ {}
              :args $ [] 'js-ffi.node/BufferHost
              :return 'Number
          :examples $ [] $ quote BufferHost
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :node)
            :names $ {} (:byte-length |length) (:to-string |toString)
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'NodeIncomingResponseHost $ %{} 'CodeEntry
          :doc "|External Node client IncomingMessage capability with status, headers and body hooks."
          :code $ quote $ deftrait NodeIncomingResponseHost
            :status-code $ :: 'JsNullish 'Number
            :status-message $ :: 'JsNullish 'String
            :headers 'JsObject
            .set-encoding! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.node/NodeIncomingResponseHost 'String
              :return 'Unit
            .on! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.node/NodeIncomingResponseHost 'String $ :: 'Fn
                {}
                  :args $ [] 'JsObject
                  :return 'Unit
              :return 'js-ffi.node/NodeIncomingResponseHost
          :examples $ [] $ quote NodeIncomingResponseHost
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :node)
            :names $ {} (:on! |on) (:set-encoding! |setEncoding) (:status-code |statusCode) (:status-message |statusMessage)
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'NodeProbe $ %{} 'CodeEntry
          :doc "|Typed Node smoke result replacing the former heterogeneous Map<Dynamic>."
          :code $ quote $ defstruct NodeProbe (:runtime 'js-ffi.shared/Runtime) (:cwd 'String) (:argv-count 'Number)
          :examples $ [] $ quote
            &%{} NodeProbe :runtime (%:: shared/Runtime :node) :cwd |/tmp :argv-count 2
          :schema $ :: 'Enum
        'NodeRequestHost $ %{} 'CodeEntry
          :doc "|External Node IncomingMessage capability with request fields and an event hook."
          :code $ quote $ deftrait NodeRequestHost
            :url $ :: 'JsNullish 'String
            :method $ :: 'JsNullish 'String
            :headers 'JsObject
            .set-encoding! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.node/NodeRequestHost 'String
              :return 'Unit
            .on! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.node/NodeRequestHost 'String $ :: 'Fn
                {}
                  :args $ [] 'JsObject
                  :return 'Unit
              :return 'js-ffi.node/NodeRequestHost
          :examples $ [] $ quote NodeRequestHost
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :node)
            :names $ {} (:on! |on) (:set-encoding! |setEncoding)
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'NodeServerHost $ %{} 'CodeEntry
          :doc "|External Node HTTP server capability exposing listen and close."
          :code $ quote $ deftrait NodeServerHost
            .listen! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.node/NodeServerHost 'Number 'String $ :: 'Fn
                {}
                  :args $ []
                  :return 'Unit
              :return 'js-ffi.node/NodeServerHost
            .close! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.node/NodeServerHost
              :return 'Unit
          :examples $ [] $ quote NodeServerHost
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :node)
            :names $ {} (:close! |close) (:listen! |listen)
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'NodeServerResponseHost $ %{} 'CodeEntry
          :doc "|External Node ServerResponse capability with writable status and send helpers."
          :code $ quote $ deftrait NodeServerResponseHost
            :status-code $ :: 'JsNullish 'Number
            :status-message $ :: 'JsNullish 'String
            .set-header! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.node/NodeServerResponseHost 'String 'String
              :return 'Unit
            .end! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.node/NodeServerResponseHost 'String
              :return 'Unit
          :examples $ [] $ quote NodeServerResponseHost
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :node)
            :names $ {} (:end! |end) (:set-header! |setHeader) (:status-code |statusCode) (:status-message |statusMessage)
            :writable $ #{} :status-code :status-message
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'ProcessArgvHost $ %{} 'CodeEntry
          :doc "|External process.argv capability exposing only an opaque/nullish length that argv-count validates at runtime."
          :code $ quote $ deftrait ProcessArgvHost
            :length $ :: 'JsNullish 'JsObject
          :examples $ [] $ quote ProcessArgvHost
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :node)
            :names $ {}
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'append-text! $ %{} 'CodeEntry
          :doc "|Synchronous node:fs.appendFileSync adapter. Text uses UTF-8; filesystem failures raise the original host exception. No recursive deletion."
          :code $ quote $ defn append-text! (file-path text) (fs/appendFileSync file-path text |utf8) &unit
          :examples $ []
          :ffi $ {} (:backend :js) (:target :node)
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'String 'String
            :features $ #{} :js-ffi
        'argv-count $ %{} 'CodeEntry
          :doc "|Return process.argv.length as Number. This deliberately narrows the host array at the boundary. Example: (argv-count) => 3"
          :code $ quote $ defn argv-count ()
            let
                argv $ unsafe-coerce js/process.argv ProcessArgvHost
              contract/expect-number |process.argv.length $ .-length argv
          :examples $ [] $ quote "(argv-count)"
          :ffi $ {} (:backend :js) (:target :node)
          :schema $ :: 'Fn $ {} (:return 'Number)
            :args $ []
            :features $ #{} :js-ffi
        'buffer->string $ %{} 'CodeEntry (:doc "|Decode a typed BufferHost as a UTF-8 String.")
          :code $ quote $ defn buffer->string (value) (value .to-string |utf8)
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ [] 'js-ffi.node/BufferHost
            :features $ #{} :js-ffi
        'buffer-from-string $ %{} 'CodeEntry
          :doc "|Create a Node Buffer from a UTF-8 String and return a typed BufferHost."
          :code $ quote $ defn buffer-from-string (text)
            unsafe-coerce (js/Buffer.from text |utf8) BufferHost
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'js-ffi.node/BufferHost)
            :args $ [] 'String
            :features $ #{} :js-ffi
        'copy-file! $ %{} 'CodeEntry
          :doc "|Synchronous node:fs.copyFileSync adapter. Text uses UTF-8; filesystem failures raise the original host exception. No recursive deletion."
          :code $ quote $ defn copy-file! (source destination) (fs/copyFileSync source destination) &unit
          :examples $ []
          :ffi $ {} (:backend :js) (:target :node)
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'String 'String
            :features $ #{} :js-ffi
        'cwd $ %{} 'CodeEntry
          :doc "|Return process.cwd() as String. This is a Node-only API and is emitted through the node entry. Example: (cwd) => |/workspace/project"
          :code $ quote $ defn cwd ()
            contract/expect-string |process.cwd $ js/process.cwd
          :examples $ [] $ quote "(cwd)"
          :ffi $ {} (:backend :js) (:target :node)
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ []
            :features $ #{} :js-ffi
        'env-get $ %{} 'CodeEntry
          :doc "|Read one process.env variable as Option<String>."
          :code $ quote $ defn env-get (key)
            let
                env $ contract/expect-object |process.env js/process.env
                raw $ js-get env key
              if (js-nullish? raw) (%none)
                %some $ contract/expect-string |process.env raw
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'String
            :features $ #{} :js-ffi
            :return $ :: 'calcit.core/Option 'String
        'env-or $ %{} 'CodeEntry
          :doc "|Read a process.env value with a typed String fallback. Example: (env-or |NODE_ENV |development) => |development"
          :code $ quote $ defn env-or (key fallback)
            let
                env $ unsafe-coerce js/process.env JsObject
                raw $ aget env key
              if (js-present? raw)
                contract/expect-string (str |process.env[ key |]) raw
                , fallback
          :examples $ [] $ quote "(env-or |NODE_ENV |development)"
          :ffi $ {} (:backend :js) (:target :node)
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ [] 'String 'String
            :features $ #{} :js-ffi
        'exit! $ %{} 'CodeEntry
          :doc "|Terminate the Node.js process with a numeric exit code. This effectful escape hatch has the Unit contract because it has no business result. Example: (exit! 1)"
          :code $ quote $ defn exit! (code) (js/process.exit code) &unit
          :examples $ [] $ quote "(exit! 1)"
          :ffi $ {} (:backend :js) (:target :node)
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'Number
            :features $ #{} :js-ffi
        'file-exists? $ %{} 'CodeEntry
          :doc "|Return whether a local filesystem path exists as Bool. The fs module is kept behind the Node namespace. Example: (file-exists? |package.json) => true"
          :code $ quote $ defn file-exists? (file-path) (fs/existsSync file-path)
          :examples $ [] $ quote "(file-exists? |package.json)"
          :ffi $ {} (:backend :js) (:target :node)
          :schema $ :: 'Fn $ {} (:return 'Bool)
            :args $ [] 'String
            :features $ #{} :js-ffi
        'http-create-server $ %{} 'CodeEntry
          :doc "|Create a Node HTTP server from a typed request/response handler."
          :code $ quote $ defn http-create-server (handler)
            unsafe-coerce
              http/createServer $ fn (raw-request raw-response)
                hint-fn $ {} (:return 'Unit)
                  :args $ [] 'JsObject 'JsObject
                handler (unsafe-coerce raw-request NodeRequestHost) (unsafe-coerce raw-response NodeServerResponseHost)
              , NodeServerHost
          :examples $ []
          :ffi $ {} (:backend :js) (:target :node)
          :schema $ :: 'Fn $ {} (:return 'js-ffi.node/NodeServerHost)
            :args $ [] $ :: 'Fn
              {} (:return 'Unit)
                :args $ [] 'js-ffi.node/NodeRequestHost 'js-ffi.node/NodeServerResponseHost
            :features $ #{} :js-ffi
        'http-get! $ %{} 'CodeEntry
          :doc "|Start a Node HTTP GET and return the opaque client request object."
          :code $ quote $ defn http-get! (url callback)
            unsafe-coerce
              http/get url $ fn (raw-response)
                callback $ unsafe-coerce raw-response NodeIncomingResponseHost
              , JsObject
          :examples $ []
          :ffi $ {} (:backend :js) (:target :node)
          :schema $ :: 'Fn $ {} (:return 'JsObject)
            :args $ [] 'String $ :: 'Fn
              {} (:return 'Unit)
                :args $ [] 'js-ffi.node/NodeIncomingResponseHost
            :features $ #{} :js-ffi
        'import-meta-url $ %{} 'CodeEntry
          :doc "|Read import.meta.url after a runtime String check."
          :code $ quote $ defn import-meta-url () (contract/expect-string |import.meta.url js/import.meta.url)
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ []
            :features $ #{} :js-ffi
        'make-temp-dir! $ %{} 'CodeEntry
          :doc "|Synchronous node:fs.mkdtempSync adapter. Text uses UTF-8; filesystem failures raise the original host exception. No recursive deletion."
          :code $ quote $ defn make-temp-dir! (prefix)
            contract/expect-string |fs.mkdtempSync $ fs/mkdtempSync prefix
          :examples $ []
          :ffi $ {} (:backend :js) (:target :node)
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ [] 'String
            :features $ #{} :js-ffi
        'mkdir! $ %{} 'CodeEntry
          :doc "|Synchronous node:fs.mkdirSync adapter. Text uses UTF-8; filesystem failures raise the original host exception. No recursive deletion."
          :code $ quote $ defn mkdir! (directory) (fs/mkdirSync directory) &unit
          :examples $ []
          :ffi $ {} (:backend :js) (:target :node)
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'String
            :features $ #{} :js-ffi
        'node-version $ %{} 'CodeEntry (:doc "|Read and validate Node process metadata.")
          :code $ quote $ defn node-version () (contract/expect-string |process.version js/process.version)
          :examples $ []
          :ffi $ {} (:backend :js) (:target :node)
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ []
            :features $ #{} :js-ffi
        'path-absolute? $ %{} 'CodeEntry
          :doc "|Call node:path.isAbsolute using native platform path rules and validate its result."
          :code $ quote $ defn path-absolute? (value)
            contract/expect-bool |path.isAbsolute $ path/isAbsolute value
          :examples $ []
          :ffi $ {} (:backend :js) (:target :node)
          :schema $ :: 'Fn $ {} (:return 'Bool)
            :args $ [] 'String
            :features $ #{} :js-ffi
        'path-basename $ %{} 'CodeEntry
          :doc "|Call node:path.basename using native platform path rules and validate its result."
          :code $ quote $ defn path-basename (value)
            contract/expect-string |path.basename $ path/basename value
          :examples $ []
          :ffi $ {} (:backend :js) (:target :node)
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ [] 'String
            :features $ #{} :js-ffi
        'path-dirname $ %{} 'CodeEntry
          :doc "|Call node:path.dirname using native platform path rules and validate its result."
          :code $ quote $ defn path-dirname (value)
            contract/expect-string |path.dirname $ path/dirname value
          :examples $ []
          :ffi $ {} (:backend :js) (:target :node)
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ [] 'String
            :features $ #{} :js-ffi
        'path-extname $ %{} 'CodeEntry
          :doc "|Call node:path.extname using native platform path rules and validate its result."
          :code $ quote $ defn path-extname (value)
            contract/expect-string |path.extname $ path/extname value
          :examples $ []
          :ffi $ {} (:backend :js) (:target :node)
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ [] 'String
            :features $ #{} :js-ffi
        'path-join $ %{} 'CodeEntry
          :doc "|Join two path segments using node:path and return String. Example: (path-join |src |index.js) => |src/index.js"
          :code $ quote $ defn path-join (base child) (path/join base child)
          :examples $ [] $ quote "(path-join |src |index.js)"
          :ffi $ {} (:backend :js) (:target :node)
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ [] 'String 'String
            :features $ #{} :js-ffi
        'path-normalize $ %{} 'CodeEntry
          :doc "|Call node:path.normalize using native platform path rules and validate its result."
          :code $ quote $ defn path-normalize (value)
            contract/expect-string |path.normalize $ path/normalize value
          :examples $ []
          :ffi $ {} (:backend :js) (:target :node)
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ [] 'String
            :features $ #{} :js-ffi
        'path-relative $ %{} 'CodeEntry
          :doc "|Call node:path.relative using native platform path rules and validate its result."
          :code $ quote $ defn path-relative (base child)
            contract/expect-string |path.relative $ path/relative base child
          :examples $ []
          :ffi $ {} (:backend :js) (:target :node)
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ [] 'String 'String
            :features $ #{} :js-ffi
        'path-resolve $ %{} 'CodeEntry
          :doc "|Call node:path.resolve using native platform path rules and validate its result."
          :code $ quote $ defn path-resolve (base child)
            contract/expect-string |path.resolve $ path/resolve base child
          :examples $ []
          :ffi $ {} (:backend :js) (:target :node)
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ [] 'String 'String
            :features $ #{} :js-ffi
        'pid $ %{} 'CodeEntry (:doc "|Read and validate Node process metadata.")
          :code $ quote $ defn pid () (contract/expect-number |process.pid js/process.pid)
          :examples $ []
          :ffi $ {} (:backend :js) (:target :node)
          :schema $ :: 'Fn $ {} (:return 'Number)
            :args $ []
            :features $ #{} :js-ffi
        'platform $ %{} 'CodeEntry (:doc "|Read and validate Node process metadata.")
          :code $ quote $ defn platform () (contract/expect-string |process.platform js/process.platform)
          :examples $ []
          :ffi $ {} (:backend :js) (:target :node)
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ []
            :features $ #{} :js-ffi
        'probe $ %{} 'CodeEntry
          :doc "|Run the Node capability smoke probe and return typed NodeProbe data."
          :code $ quote $ defn probe ()
            &%{} NodeProbe :runtime (runtime) :cwd (cwd) :argv-count $ argv-count
          :examples $ [] $ quote (probe)
          :schema $ :: 'Fn $ {} (:return 'js-ffi.node/NodeProbe)
            :args $ []
        'read-text! $ %{} 'CodeEntry
          :doc "|Synchronous node:fs.readFileSync adapter. Text uses UTF-8; filesystem failures raise the original host exception. No recursive deletion."
          :code $ quote $ defn read-text! (file-path)
            contract/expect-string |fs.readFileSync $ fs/readFileSync file-path |utf8
          :examples $ []
          :ffi $ {} (:backend :js) (:target :node)
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ [] 'String
            :features $ #{} :js-ffi
        'read-text-async! $ %{} 'CodeEntry
          :doc "|Await node:fs/promises.readFile exactly once and return UTF-8 text or normalized JsError."
          :code $ quote $ defn read-text-async! (file-path)
            hint-fn $ {} (:async true)
              :args $ [] 'String
              :features $ #{} :js-ffi
              :return $ :: 'Result 'String 'js-ffi.shared/JsError
            try
              %:: Result :ok $ contract/expect-string |fs.promises.readFile $ js-await (fs-promises/readFile file-path |utf8)
              fn (error)
                %:: Result :err $ shared/normalize-error error
          :examples $ []
          :ffi $ {} (:backend :js) (:target :node)
          :schema $ :: 'Fn $ {}
            :args $ [] 'String
            :features $ #{} :js-ffi
            :return $ :: 'calcit.core/Result 'String 'js-ffi.shared/JsError
        'real-path! $ %{} 'CodeEntry
          :doc "|Synchronous node:fs.realpathSync adapter. Text uses UTF-8; filesystem failures raise the original host exception. No recursive deletion."
          :code $ quote $ defn real-path! (file-path)
            contract/expect-string |fs.realpathSync $ fs/realpathSync file-path
          :examples $ []
          :ffi $ {} (:backend :js) (:target :node)
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ [] 'String
            :features $ #{} :js-ffi
        'rename! $ %{} 'CodeEntry
          :doc "|Synchronous node:fs.renameSync adapter. Text uses UTF-8; filesystem failures raise the original host exception. No recursive deletion."
          :code $ quote $ defn rename! (source destination) (fs/renameSync source destination) &unit
          :examples $ []
          :ffi $ {} (:backend :js) (:target :node)
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'String 'String
            :features $ #{} :js-ffi
        'request-body-text $ %{} 'CodeEntry
          :doc "|Collect a Node request body into UTF-8 text and resolve a PromiseHost, optionally invoking a callback."
          :code $ quote $ defn request-body-text (request callback)
            unsafe-coerce
              new js/Promise $ fn (resolve reject)
                let
                    chunks $ atom |
                  request .set-encoding! |utf8
                  request .on! |error $ fn (error) (reject error)
                  request .on! |data $ fn (data) (swap! chunks str data)
                  request .on! |end $ fn () $ let
                      text @chunks
                    match callback
                      (:some cb) (cb text)
                      (:none) &unit
                    resolve text
              , 'js-ffi.shared/PromiseHost
          :examples $ []
          :ffi $ {} (:backend :js) (:target :node)
          :schema $ :: 'Fn $ {} (:return 'js-ffi.shared/PromiseHost)
            :args $ [] 'js-ffi.node/NodeRequestHost $ :: 'calcit.core/Option
              :: 'Fn $ {} (:return 'Unit)
                :args $ [] 'String
            :features $ #{} :js-ffi
        'request-header $ %{} 'CodeEntry (:doc "|Read one Node request header as Option<String>.")
          :code $ quote $ defn request-header (request key)
            let
                headers $ request :headers
                value $ contract/object-field |request.header headers key
              if (js-nullish? value) (%none)
                %some $ contract/expect-string |request.header value
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'js-ffi.node/NodeRequestHost 'String
            :features $ #{} :js-ffi
            :return $ :: 'calcit.core/Option 'String
        'response-body-text $ %{} 'CodeEntry
          :doc "|Collect a Node response body as UTF-8 text and invoke the callback."
          :code $ quote $ defn response-body-text (response callback)
            let
                chunks $ atom |
              response .set-encoding! |utf8
              response .on! |data $ fn (chunk) (swap! chunks str chunk)
              response .on! |end $ fn () $ callback @chunks
            , &unit
          :examples $ []
          :ffi $ {} (:backend :js) (:target :node)
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.node/NodeIncomingResponseHost $ :: 'Fn
              {} (:return 'Unit)
                :args $ [] 'String
            :features $ #{} :js-ffi
        'response-header $ %{} 'CodeEntry
          :doc "|Read one Node response header as Option<String>."
          :code $ quote $ defn response-header (response key)
            let
                headers $ response :headers
                value $ contract/object-field |response.header headers key
              if (js-nullish? value) (%none)
                %some $ contract/expect-string |response.header value
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'js-ffi.node/NodeIncomingResponseHost 'String
            :features $ #{} :js-ffi
            :return $ :: 'calcit.core/Option 'String
        'rmdir! $ %{} 'CodeEntry
          :doc "|Synchronous node:fs.rmdirSync adapter. Text uses UTF-8; filesystem failures raise the original host exception. No recursive deletion."
          :code $ quote $ defn rmdir! (directory) (fs/rmdirSync directory) &unit
          :examples $ []
          :ffi $ {} (:backend :js) (:target :node)
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'String
            :features $ #{} :js-ffi
        'runtime $ %{} 'CodeEntry
          :doc "|Return the normalized Runtime node enum variant."
          :code $ quote $ defn runtime () (shared/Runtime :node)
          :examples $ [] $ quote (runtime)
          :schema $ :: 'Fn $ {} (:return 'js-ffi.shared/Runtime)
            :args $ []
        'runtime-name $ %{} 'CodeEntry
          :doc "|Return the literal runtime identifier |node. Example: (runtime-name) => |node"
          :code $ quote $ defn runtime-name () |node
          :examples $ [] $ quote "(runtime-name)"
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ []
        'server-close! $ %{} 'CodeEntry (:doc "|Close a Node HTTP server.")
          :code $ quote $ defn server-close! (server) (server .close!) &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.node/NodeServerHost
            :features $ #{} :js-ffi
        'server-listen! $ %{} 'CodeEntry
          :doc "|Bind a Node HTTP server to a port and host, invoking the callback after start."
          :code $ quote $ defn server-listen! (server port host callback) (server .listen! port host callback)
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'js-ffi.node/NodeServerHost)
            :args $ [] 'js-ffi.node/NodeServerHost 'Number 'String $ :: 'Fn
              {} (:return 'Unit)
                :args $ []
            :features $ #{} :js-ffi
        'set-timeout! $ %{} 'CodeEntry
          :doc "|Schedule a callback after a delay and return the numeric handle."
          :code $ quote $ defn set-timeout! (callback millis)
            unsafe-coerce (js/setTimeout callback millis) Number
          :examples $ []
          :ffi $ {} (:backend :js) (:target :node)
          :schema $ :: 'Fn $ {} (:return 'Number)
            :args $ []
              :: 'Fn $ {} (:return 'Unit)
                :args $ []
              , 'Number
            :features $ #{} :js-ffi
        'unlink! $ %{} 'CodeEntry
          :doc "|Synchronous node:fs.unlinkSync adapter. Text uses UTF-8; filesystem failures raise the original host exception. No recursive deletion."
          :code $ quote $ defn unlink! (file-path) (fs/unlinkSync file-path) &unit
          :examples $ []
          :ffi $ {} (:backend :js) (:target :node)
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'String
            :features $ #{} :js-ffi
        'uptime $ %{} 'CodeEntry (:doc "|Read and validate Node process metadata.")
          :code $ quote $ defn uptime ()
            contract/expect-number |process.uptime $ js/process.uptime
          :examples $ []
          :ffi $ {} (:backend :js) (:target :node)
          :schema $ :: 'Fn $ {} (:return 'Number)
            :args $ []
            :features $ #{} :js-ffi
        'write-text! $ %{} 'CodeEntry
          :doc "|Synchronous node:fs.writeFileSync adapter. Text uses UTF-8; filesystem failures raise the original host exception. No recursive deletion."
          :code $ quote $ defn write-text! (file-path text) (fs/writeFileSync file-path text |utf8) &unit
          :examples $ []
          :ffi $ {} (:backend :js) (:target :node)
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'String 'String
            :features $ #{} :js-ffi
        'write-text-async! $ %{} 'CodeEntry
          :doc "|Await node:fs/promises.writeFile exactly once and return Unit or normalized JsError."
          :code $ quote $ defn write-text-async! (file-path text)
            hint-fn $ {} (:async true)
              :args $ [] 'String 'String
              :features $ #{} :js-ffi
              :return $ :: 'Result 'Unit 'js-ffi.shared/JsError
            try
              do
                js-await $ fs-promises/writeFile file-path text |utf8
                %:: Result :ok &unit
              fn (error)
                %:: Result :err $ shared/normalize-error error
          :examples $ []
          :ffi $ {} (:backend :js) (:target :node)
          :schema $ :: 'Fn $ {}
            :args $ [] 'String 'String
            :features $ #{} :js-ffi
            :return $ :: 'calcit.core/Result 'Unit 'js-ffi.shared/JsError
      :ns $ %{} 'NsEntry
        :doc "|Typed Node.js JavaScript FFI. Node-only modules remain isolated while runtime identity and cross-runtime host contracts come from js-ffi.shared."
        :code $ quote $ ns js-ffi.node
          :require (|node:fs :as fs) (|node:path :as path) (js-ffi.contract :as contract) (js-ffi.shared :as shared) (|node:fs/promises :as fs-promises) (|node:http :as http)
    'js-ffi.node-test $ %{} 'FileEntry
      :defs $ {}
        'main! $ %{} 'CodeEntry
          :doc "|Run the typed Node smoke probe and verify its Runtime enum."
          :code $ quote $ defn main! ()
            let
                result $ node/probe
              assert-type result js-ffi.node/NodeProbe
              shared/console-log! |js-ffi-node-smoke
              if
                contract/valid-runtime? (shared/Runtime :node) (:runtime result)
                shared/console-log! |js-ffi-node-smoke-passed
                do (shared/console-error! |js-ffi-node-smoke-failed) (node/exit! 1)
              , &unit
          :examples $ [] $ quote (main!)
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
        'reload! $ %{} 'CodeEntry (:doc "|No-op Node reload hook returning Unit.")
          :code $ quote $ defn reload! () &unit
          :examples $ [] $ quote (reload!)
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns js-ffi.node-test
          :require (js-ffi.node :as node) (js-ffi.contract :as contract) (js-ffi.shared :as shared)
    'js-ffi.shared $ %{} 'FileEntry
      :defs $ {}
        'AbortControllerHost $ %{} 'CodeEntry
          :doc "|External AbortController capability with a typed signal and parameterless abort wrapper contract."
          :code $ quote $ deftrait AbortControllerHost (:signal 'js-ffi.shared/AbortSignalHost)
            .abort! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.shared/AbortControllerHost
              :return 'Unit
          :examples $ [] $ quote AbortControllerHost
          :ffi $ {} (:backend :js) (:kind :external-object)
            :names $ {} $ :abort! |abort
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'AbortSignalHost $ %{} 'CodeEntry
          :doc "|External AbortSignal capability. Reason stays an opaque nullable host object because JavaScript permits arbitrary values."
          :code $ quote $ deftrait AbortSignalHost (:aborted 'Bool)
            :reason $ :: 'JsNullish 'JsObject
            .throw-if-aborted! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.shared/AbortSignalHost
              :return 'Unit
          :examples $ [] $ quote AbortSignalHost
          :ffi $ {} (:backend :js) (:kind :external-object)
            :names $ {} $ :throw-if-aborted! |throwIfAborted
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'ConsoleHost $ %{} 'CodeEntry
          :doc "|External console capability shared by browser and Node. Methods intentionally accept one String to avoid modeling host varargs."
          :code $ quote $ deftrait ConsoleHost
            .log! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.shared/ConsoleHost 'String
              :return 'Unit
            .warn! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.shared/ConsoleHost 'String
              :return 'Unit
            .error! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.shared/ConsoleHost 'String
              :return 'Unit
            .clear! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.shared/ConsoleHost
              :return 'Unit
          :examples $ [] $ quote ConsoleHost
          :ffi $ {} (:backend :js) (:kind :external-object)
            :names $ {} (:clear! |clear) (:error! |error) (:info! |info) (:log! |log) (:warn! |warn)
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'DateHost $ %{} 'CodeEntry
          :doc "|External JavaScript Date capability exposing only stable read methods needed for normalization."
          :code $ quote $ deftrait DateHost
            .get-time $ :: 'Fn $ {}
              :args $ [] 'js-ffi.shared/DateHost
              :return 'Number
            .to-iso-string $ :: 'Fn $ {}
              :args $ [] 'js-ffi.shared/DateHost
              :return 'String
            .to-locale-string $ :: 'Fn $ {}
              :args $ [] 'js-ffi.shared/DateHost
              :return 'String
          :examples $ [] $ quote DateHost
          :ffi $ {} (:backend :js) (:kind :external-object)
            :names $ {} (:get-time |getTime) (:to-iso-string |toISOString) (:to-locale-string |toLocaleString)
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'DateSnapshot $ %{} 'CodeEntry
          :doc "|Immutable normalized view of a host Date with epoch milliseconds and ISO text."
          :code $ quote $ defstruct DateSnapshot (:timestamp 'Number) (:iso 'String)
          :examples $ [] $ quote (&%{} DateSnapshot :timestamp 0 :iso |1970-01-01T00:00:00.000Z)
          :schema $ :: 'Enum
        'HeadersHost $ %{} 'CodeEntry
          :doc "|External Headers capability with typed String keys and values; iteration is deliberately normalized elsewhere."
          :code $ quote $ deftrait HeadersHost
            .get $ :: 'Fn $ {}
              :args $ [] 'js-ffi.shared/HeadersHost 'String
              :return $ :: 'JsNullish 'String
            .has? $ :: 'Fn $ {}
              :args $ [] 'js-ffi.shared/HeadersHost 'String
              :return 'Bool
            .set! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.shared/HeadersHost 'String 'String
              :return 'Unit
            .append! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.shared/HeadersHost 'String 'String
              :return 'Unit
            .delete! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.shared/HeadersHost 'String
              :return 'Unit
          :examples $ [] $ quote HeadersHost
          :ffi $ {} (:backend :js) (:kind :external-object)
            :names $ {} (:append! |append) (:delete! |delete) (:get |get) (:has? |has) (:set! |set)
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'HttpMethod $ %{} 'CodeEntry
          :doc "|Closed HTTP method set used by typed request options; custom methods remain an explicit adapter concern."
          :code $ quote $ defenum HttpMethod (:get) (:post) (:put) (:patch) (:delete) (:head) (:options)
          :examples $ []
            quote $ %:: HttpMethod :get
            quote $ %:: HttpMethod :post
          :schema $ :: 'Enum
        'JsError $ %{} 'CodeEntry
          :doc "|Normalized JavaScript exception data. Stack is optional because hosts may omit it."
          :code $ quote $ defstruct JsError (:kind 'js-ffi.shared/JsErrorKind) (:name 'String) (:message 'String)
            :stack $ :: 'Option 'String
          :examples $ [] $ quote
            &%{} JsError :kind (%:: JsErrorKind :type-error) :name |TypeError :message |invalid
          :schema $ :: 'Enum
        'JsErrorKind $ %{} 'CodeEntry
          :doc "|Stable error categories shared by browser and Node adapters; unknown host names retain their String payload."
          :code $ quote $ defenum JsErrorKind (:type-error) (:range-error) (:permission) (:quota) (:network) (:abort) (:unknown 'String)
          :examples $ []
            quote $ %:: JsErrorKind :network
            quote $ %:: JsErrorKind :unknown |DataCloneError
          :schema $ :: 'Enum
        'PromiseHost $ %{} 'CodeEntry
          :doc "|External Promise capability exposing typed fulfillment and rejection callbacks."
          :code $ quote $ deftrait PromiseHost
            .then! $ :: 'Fn $ {}
              :generics $ [] 'T
              :args $ [] 'js-ffi.shared/PromiseHost $ :: 'Fn
                {}
                  :args $ [] 'T
                  :return 'Unit
              :return 'js-ffi.shared/PromiseHost
            .catch! $ :: 'Fn $ {}
              :generics $ [] 'E
              :args $ [] 'js-ffi.shared/PromiseHost $ :: 'Fn
                {}
                  :args $ [] 'E
                  :return 'Unit
              :return 'js-ffi.shared/PromiseHost
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object)
            :names $ {} (:catch! |catch) (:then! |then)
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'RequestOptions $ %{} 'CodeEntry
          :doc "|Calcit-owned request configuration converted to a JavaScript object only inside an adapter."
          :code $ quote $ defstruct RequestOptions (:method 'js-ffi.shared/HttpMethod)
            :headers $ :: 'Map 'String 'String
            :body $ :: 'Option 'String
          :examples $ [] $ quote
            &%{} RequestOptions :method (%:: HttpMethod :get) :headers $ {}
          :schema $ :: 'Enum
        'ResponseHost $ %{} 'CodeEntry
          :doc "|External Response capability with metadata and an opaque Promise-like text-body reader consumed by response-text."
          :code $ quote $ deftrait ResponseHost (:status 'Number) (:status-text 'String) (:ok? 'Bool) (:url 'String) (:redirected? 'Bool) (:headers 'js-ffi.shared/HeadersHost) (:body-used? 'Bool)
            .text $ :: 'Fn $ {}
              :args $ [] 'js-ffi.shared/ResponseHost
              :return 'JsObject
          :examples $ [] $ quote ResponseHost
          :ffi $ {} (:backend :js) (:kind :external-object)
            :names $ {} (:body-used? |bodyUsed) (:ok? |ok) (:redirected? |redirected) (:status-text |statusText)
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'ResponseSnapshot $ %{} 'CodeEntry
          :doc "|Normalized response metadata after a host Response has been inspected and its headers copied."
          :code $ quote $ defstruct ResponseSnapshot (:status 'Number) (:status-text 'String) (:ok? 'Bool) (:url 'String) (:redirected? 'Bool)
            :headers $ :: 'Map 'String 'String
          :examples $ [] $ quote
            &%{} ResponseSnapshot :status 200 :status-text |OK :ok? true :url |https://example.test :redirected? false :headers $ {}
          :schema $ :: 'Enum
        'Runtime $ %{} 'CodeEntry
          :doc "|Runtime identity normalized as a Calcit enum instead of an open String."
          :code $ quote $ defenum Runtime (:browser) (:node) (:unknown 'String)
          :examples $ []
            quote $ %:: Runtime :browser
            quote $ %:: Runtime :unknown |worker
          :schema $ :: 'Enum
        'UrlHost $ %{} 'CodeEntry
          :doc "|External URL-like capability shared by URL and browser Location objects. Fields are read-only in this contract."
          :code $ quote $ deftrait UrlHost (:href 'String) (:protocol 'String) (:host 'String) (:hostname 'String) (:port 'String) (:pathname 'String) (:search 'String) (:hash 'String)
            .to-string $ :: 'Fn $ {}
              :args $ [] 'js-ffi.shared/UrlHost
              :return 'String
          :examples $ [] $ quote UrlHost
          :ffi $ {} (:backend :js) (:kind :external-object)
            :names $ {} $ :to-string |toString
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'UrlSearchParamsHost $ %{} 'CodeEntry
          :doc "|External URLSearchParams capability. Nullable lookup remains JsNullish<String> until an adapter converts it to Option."
          :code $ quote $ deftrait UrlSearchParamsHost (:size 'Number)
            .get $ :: 'Fn $ {}
              :args $ [] 'js-ffi.shared/UrlSearchParamsHost 'String
              :return $ :: 'JsNullish 'String
            .has? $ :: 'Fn $ {}
              :args $ [] 'js-ffi.shared/UrlSearchParamsHost 'String
              :return 'Bool
            .set! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.shared/UrlSearchParamsHost 'String 'String
              :return 'Unit
            .delete! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.shared/UrlSearchParamsHost 'String
              :return 'Unit
            .for-each! $ :: 'Fn $ {}
              :args $ [] 'js-ffi.shared/UrlSearchParamsHost $ :: 'Fn
                {}
                  :args $ [] 'String 'String 'js-ffi.shared/UrlSearchParamsHost
                  :return 'Unit
              :return 'Unit
            .to-string $ :: 'Fn $ {}
              :args $ [] 'js-ffi.shared/UrlSearchParamsHost
              :return 'String
          :examples $ [] $ quote UrlSearchParamsHost
          :ffi $ {} (:backend :js) (:kind :external-object)
            :names $ {} (:delete! |delete) (:for-each! |forEach) (:get |get) (:has? |has) (:set! |set) (:to-string |toString)
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'UrlSnapshot $ %{} 'CodeEntry
          :doc "|Immutable URL fields copied out of a host URL or Location object."
          :code $ quote $ defstruct UrlSnapshot (:href 'String) (:protocol 'String) (:host 'String) (:hostname 'String) (:port 'String) (:pathname 'String) (:search 'String) (:hash 'String)
          :examples $ [] $ quote
            &%{} UrlSnapshot :href |https://example.test/a :protocol |https: :host |example.test :hostname |example.test :port | :pathname |/a :search | :hash |
          :schema $ :: 'Enum
        'abort! $ %{} 'CodeEntry (:doc "|Abort the controller. Repeated aborts are safe.")
          :code $ quote $ defn abort! (controller) (controller .abort!) &unit
          :examples $ []
          :ffi $ {} $ :backend :js
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.shared/AbortControllerHost
            :features $ #{} :js-ffi
        'abort-controller-create $ %{} 'CodeEntry
          :doc "|Construct a native AbortController and retain its typed host identity. Invalid constructor inputs raise host exceptions."
          :code $ quote $ defn abort-controller-create ()
            unsafe-coerce (new js/AbortController) AbortControllerHost
          :examples $ []
          :ffi $ {} $ :backend :js
          :schema $ :: 'Fn $ {} (:return 'js-ffi.shared/AbortControllerHost)
            :args $ []
            :features $ #{} :js-ffi
        'abort-signal $ %{} 'CodeEntry
          :doc "|Return the controller signal, preserving identity."
          :code $ quote $ defn abort-signal (controller)
            let
                result $ controller :signal
              , result
          :examples $ []
          :ffi $ {} $ :backend :js
          :schema $ :: 'Fn $ {} (:return 'js-ffi.shared/AbortSignalHost)
            :args $ [] 'js-ffi.shared/AbortControllerHost
            :features $ #{} :js-ffi
        'aborted? $ %{} 'CodeEntry (:doc "|Read whether a signal has been aborted.")
          :code $ quote $ defn aborted? (signal)
            let
                result $ signal :aborted
              , result
          :examples $ []
          :ffi $ {} $ :backend :js
          :schema $ :: 'Fn $ {} (:return 'Bool)
            :args $ [] 'js-ffi.shared/AbortSignalHost
            :features $ #{} :js-ffi
        'console-clear! $ %{} 'CodeEntry
          :doc "|Clear the shared console through ConsoleHost.clear."
          :code $ quote $ defn console-clear! ()
            let
                host-console $ unsafe-coerce js/console ConsoleHost
              host-console .clear!
              , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'console-error! $ %{} 'CodeEntry
          :doc "|Write one error String to the host console and return Unit in browser or Node."
          :code $ quote $ defn console-error! (message)
            let
                host-console $ unsafe-coerce js/console ConsoleHost
              host-console .error! message
              , &unit
          :examples $ [] $ quote (console-error! |failed)
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'String
            :features $ #{} :js-ffi
        'console-host $ %{} 'CodeEntry
          :doc "|Return the shared ConsoleHost capability for method-style calls such as (.log! message)."
          :code $ quote $ defn console-host () (unsafe-coerce js/console ConsoleHost)
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'js-ffi.shared/ConsoleHost)
            :args $ []
            :features $ #{} :js-ffi
        'console-info! $ %{} 'CodeEntry
          :doc "|Write one informational String to the host console and return Unit in browser or Node."
          :code $ quote $ defn console-info! (message) (js/console.info message) &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'String
            :features $ #{} :js-ffi
        'console-log! $ %{} 'CodeEntry
          :doc "|Write one String to the host console and normalize the host undefined return to Unit."
          :code $ quote $ defn console-log! (message)
            let
                host-console $ unsafe-coerce js/console ConsoleHost
              host-console .log! message
              , &unit
          :examples $ [] $ quote (console-log! |ready)
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'String
            :features $ #{} :js-ffi
        'console-warn! $ %{} 'CodeEntry
          :doc "|Write one warning String to the host console and return Unit in browser or Node."
          :code $ quote $ defn console-warn! (message)
            let
                host-console $ unsafe-coerce js/console ConsoleHost
              host-console .warn! message
              , &unit
          :examples $ [] $ quote (console-warn! |deprecated)
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'String
            :features $ #{} :js-ffi
        'date-from-ms $ %{} 'CodeEntry
          :doc "|Construct a typed host Date from a finite, in-range Unix timestamp in milliseconds. Invalid timestamps raise a stable FFI contract error."
          :code $ quote $ defn date-from-ms (timestamp)
            if
              and (>= timestamp -8640000000000000) (<= timestamp 8640000000000000)
              let
                  date $ unsafe-coerce (new js/Date timestamp) DateHost
                  validated-timestamp $ date .get-time
                if (= validated-timestamp validated-timestamp) date $ raise $ str "|JS FFI contract violation: date-from-ms expected a valid Date timestamp, got " timestamp
              raise $ str "|JS FFI contract violation: date-from-ms expected a finite in-range timestamp, got " timestamp
          :examples $ [] $ quote (date-from-ms 0)
          :ffi $ {} $ :backend :js
          :schema $ :: 'Fn $ {} (:return 'js-ffi.shared/DateHost)
            :args $ [] 'Number
            :features $ #{} :js-ffi
        'date-local-string $ %{} 'CodeEntry
          :doc "|Format a typed host Date using the runtime locale and default formatting options."
          :code $ quote $ defn date-local-string (date) (date .to-locale-string)
          :examples $ [] $ quote
            date-local-string $ date-from-ms 0
          :ffi $ {} $ :backend :js
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ [] 'js-ffi.shared/DateHost
            :features $ #{} :js-ffi
        'date-now-snapshot $ %{} 'CodeEntry
          :doc "|Create a host Date and immediately normalize it to DateSnapshot in browser or Node."
          :code $ quote $ defn date-now-snapshot ()
            date-snapshot $ unsafe-coerce (new js/Date) DateHost
          :examples $ [] $ quote (date-now-snapshot)
          :schema $ :: 'Fn $ {} (:return 'js-ffi.shared/DateSnapshot)
            :args $ []
            :features $ #{} :js-ffi
        'date-snapshot $ %{} 'CodeEntry
          :doc "|Copy a typed host Date into Calcit-owned DateSnapshot data."
          :code $ quote $ defn date-snapshot (date)
            &%{} DateSnapshot :timestamp (date .get-time) :iso $ date .to-iso-string
          :examples $ [] $ quote (date-now-snapshot)
          :schema $ :: 'Fn $ {} (:return 'js-ffi.shared/DateSnapshot)
            :args $ [] 'js-ffi.shared/DateHost
            :features $ #{} :js-ffi
        'decode-uri-component $ %{} 'CodeEntry
          :doc "|Read the native result through a checked primitive boundary. Invalid input may raise a host exception."
          :code $ quote $ defn decode-uri-component (text)
            contract/expect-string |decode-uri-component $ js/decodeURIComponent text
          :examples $ []
          :ffi $ {} $ :backend :js
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ [] 'String
            :features $ #{} :js-ffi
        'encode-uri-component $ %{} 'CodeEntry
          :doc "|Read the native result through a checked primitive boundary. Invalid input may raise a host exception."
          :code $ quote $ defn encode-uri-component (text)
            contract/expect-string |encode-uri-component $ js/encodeURIComponent text
          :examples $ []
          :ffi $ {} $ :backend :js
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ [] 'String
            :features $ #{} :js-ffi
        'fetch-request $ %{} 'CodeEntry
          :doc "|Await one fetch built from a typed HttpMethod, HeadersHost and optional String body; normalize throws and rejections as Result.err<JsError>."
          :code $ quote $ defn fetch-request (url method headers body)
            hint-fn $ {} (:async true)
              :args $ [] 'String 'js-ffi.shared/HttpMethod 'js-ffi.shared/HeadersHost $ :: 'calcit.core/Option 'String
              :features $ #{} :js-ffi
              :return $ :: 'calcit.core/Result 'js-ffi.shared/ResponseHost 'js-ffi.shared/JsError
            let
                method-label $ http-method-label method
              try
                %:: Result :ok $ response-host $ js-await
                  if (option:some? body)
                    js/fetch url $ js-object (:method method-label) (:headers headers)
                      :body $ option:unwrap body
                    js/fetch url $ js-object (:method method-label) (:headers headers)
                fn (error)
                  %:: Result :err $ normalize-error error
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'String 'js-ffi.shared/HttpMethod 'js-ffi.shared/HeadersHost $ :: 'calcit.core/Option 'String
            :features $ #{} :js-ffi
            :return $ :: 'calcit.core/Result 'js-ffi.shared/ResponseHost 'js-ffi.shared/JsError
        'fetch-response $ %{} 'CodeEntry
          :doc "|Await fetch exactly once and normalize synchronous throws or Promise rejections as Result.err."
          :code $ quote $ defn fetch-response (url)
            hint-fn $ {} (:async true)
              :args $ [] 'String
              :features $ #{} :js-ffi
              :return $ :: 'Result 'js-ffi.shared/ResponseHost 'js-ffi.shared/JsError
            try
              %:: Result :ok $ response-host $ js-await (js/fetch url)
              fn (error)
                %:: Result :err $ normalize-error error
          :examples $ []
          :ffi $ {} $ :backend :js
          :schema $ :: 'Fn $ {}
            :args $ [] 'String
            :features $ #{} :js-ffi
            :return $ :: 'calcit.core/Result 'js-ffi.shared/ResponseHost 'js-ffi.shared/JsError
        'headers-append! $ %{} 'CodeEntry
          :doc "|Append a header value using native Headers normalization."
          :code $ quote $ defn headers-append! (value key text) (value .append! key text) &unit
          :examples $ []
          :ffi $ {} $ :backend :js
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.shared/HeadersHost 'String 'String
            :features $ #{} :js-ffi
        'headers-create $ %{} 'CodeEntry
          :doc "|Construct a native Headers and retain its typed host identity. Invalid constructor inputs raise host exceptions."
          :code $ quote $ defn headers-create ()
            unsafe-coerce (new js/Headers) HeadersHost
          :examples $ []
          :ffi $ {} $ :backend :js
          :schema $ :: 'Fn $ {} (:return 'js-ffi.shared/HeadersHost)
            :args $ []
            :features $ #{} :js-ffi
        'headers-delete! $ %{} 'CodeEntry (:doc "|Remove a key and return Unit.")
          :code $ quote $ defn headers-delete! (value key) (value .delete! key) &unit
          :examples $ []
          :ffi $ {} $ :backend :js
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.shared/HeadersHost 'String
            :features $ #{} :js-ffi
        'headers-get $ %{} 'CodeEntry
          :doc "|Lookup a key; missing values become Option.none."
          :code $ quote $ defn headers-get (value key)
            js-nullish->option $ value .get key
          :examples $ []
          :ffi $ {} $ :backend :js
          :schema $ :: 'Fn $ {}
            :args $ [] 'js-ffi.shared/HeadersHost 'String
            :features $ #{} :js-ffi
            :return $ :: 'calcit.core/Option 'String
        'headers-has? $ %{} 'CodeEntry (:doc "|Check whether a key exists.")
          :code $ quote $ defn headers-has? (value key) (value .has? key)
          :examples $ []
          :ffi $ {} $ :backend :js
          :schema $ :: 'Fn $ {} (:return 'Bool)
            :args $ [] 'js-ffi.shared/HeadersHost 'String
            :features $ #{} :js-ffi
        'headers-set! $ %{} 'CodeEntry (:doc "|Replace the values for a key.")
          :code $ quote $ defn headers-set! (value key text) (value .set! key text) &unit
          :examples $ []
          :ffi $ {} $ :backend :js
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.shared/HeadersHost 'String 'String
            :features $ #{} :js-ffi
        'http-method-label $ %{} 'CodeEntry
          :doc "|Convert HttpMethod to the uppercase token expected by JavaScript request APIs."
          :code $ quote $ defn http-method-label (method)
            match method
              (:get) |GET
              (:post) |POST
              (:put) |PUT
              (:patch) |PATCH
              (:delete) |DELETE
              (:head) |HEAD
              (:options) |OPTIONS
          :examples $ [] $ quote
            http-method-label $ HttpMethod :post
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ [] 'js-ffi.shared/HttpMethod
        'normalize-error $ %{} 'CodeEntry
          :doc "|Normalize a synchronous throw or Promise rejection into JsError."
          :code $ quote $ defn normalize-error (error)
            let
                name $ try
                  let
                      raw-name $ contract/object-field |Error error |name
                    if (js-nullish? raw-name) |Error $ contract/expect-string |Error.name raw-name
                  fn (_) |Error
                message $ try
                  let
                      raw-message $ contract/object-field |Error error |message
                    if (js-nullish? raw-message)
                      contract/expect-string |Error $ js/String error
                      contract/expect-string |Error.message raw-message
                  fn (_)
                    contract/expect-string |Error $ js/String error
                kind $ case-default name (%:: JsErrorKind :unknown name)
                  |TypeError $ %:: JsErrorKind :type-error
                  |RangeError $ %:: JsErrorKind :range-error
                  |NotAllowedError $ %:: JsErrorKind :permission
                  |SecurityError $ %:: JsErrorKind :permission
                  |QuotaExceededError $ %:: JsErrorKind :quota
                  |NetworkError $ %:: JsErrorKind :network
                  |AbortError $ %:: JsErrorKind :abort
              JsError :kind kind :name name :message message :stack $ %none
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'js-ffi.shared/JsError)
            :args $ [] $ :: 'JsNullish 'JsObject
            :features $ #{} :js-ffi
        'now-ms $ %{} 'CodeEntry
          :doc "|Read the native result through a checked primitive boundary. Invalid input may raise a host exception."
          :code $ quote $ defn now-ms ()
            contract/expect-number |now-ms $ js/Date.now
          :examples $ []
          :ffi $ {} $ :backend :js
          :schema $ :: 'Fn $ {} (:return 'Number)
            :args $ []
            :features $ #{} :js-ffi
        'performance-now $ %{} 'CodeEntry
          :doc "|Read the native result through a checked primitive boundary. Invalid input may raise a host exception."
          :code $ quote $ defn performance-now ()
            contract/expect-number |performance-now $ js/performance.now
          :examples $ []
          :ffi $ {} $ :backend :js
          :schema $ :: 'Fn $ {} (:return 'Number)
            :args $ []
            :features $ #{} :js-ffi
        'promise-create $ %{} 'CodeEntry
          :doc "|Create a PromiseHost from a (resolve reject) executor function."
          :code $ quote $ defn promise-create (executor)
            unsafe-coerce (new js/Promise executor) PromiseHost
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'js-ffi.shared/PromiseHost)
            :args $ [] 'DynFn
            :features $ #{} :js-ffi
        'promise-observe! $ %{} 'CodeEntry
          :doc "|Resolve a value through the host Promise queue and deliver exactly one fulfillment or rejection callback."
          :code $ quote $ defn promise-observe! (value ready! failed!)
            let
                host $ assert-type (js/Promise.resolve value) 'js-ffi.shared/PromiseHost
                handled $ host .then! ready!
              handled .catch! failed!
              , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'T
              :: 'Fn $ {} (:return 'Unit)
                :args $ [] 'T
              :: 'Fn $ {} (:return 'Unit)
                :args $ [] 'E
            :features $ #{} :js-ffi
            :generics $ [] 'T 'E
        'promise? $ %{} 'CodeEntry
          :doc "|Detect a thenable that resolves to itself, matching the Promise contract."
          :code $ quote $ defn promise? (value)
            if (nil? value) false $ let
                resolved $ js/Promise.resolve value
              and
                fn? $ .-then value
                identical? value resolved
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Bool)
            :args $ [] 'Dynamic
            :features $ #{} :js-ffi
        'queue-microtask! $ %{} 'CodeEntry
          :doc "|Queue a Unit callback in the JavaScript microtask queue."
          :code $ quote $ defn queue-microtask! (callback) (js/queueMicrotask callback) &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] $ :: 'Fn
              {} (:return 'Unit)
                :args $ []
            :features $ #{} :js-ffi
        'response-host $ %{} 'CodeEntry
          :doc "|Validate a host Response object and expose its typed capability."
          :code $ quote $ defn response-host (value)
            let
                object $ contract/expect-object |Response value
                headers $ contract/expect-object |Response.headers $ contract/object-field |Response object |headers
              contract/expect-number |Response.status $ contract/object-field |Response object |status
              contract/expect-string |Response.statusText $ contract/object-field |Response object |statusText
              contract/expect-bool |Response.ok $ contract/object-field |Response object |ok
              contract/expect-string |Response.url $ contract/object-field |Response object |url
              contract/expect-bool |Response.redirected $ contract/object-field |Response object |redirected
              contract/expect-bool |Response.bodyUsed $ contract/object-field |Response object |bodyUsed
              contract/expect-function |Response.text $ contract/object-field |Response object |text
              contract/expect-function |Response.headers.get $ contract/object-field |Response.headers headers |get
              contract/expect-function |Response.headers.has $ contract/object-field |Response.headers headers |has
              contract/expect-function |Response.headers.set $ contract/object-field |Response.headers headers |set
              contract/expect-function |Response.headers.append $ contract/object-field |Response.headers headers |append
              contract/expect-function |Response.headers.delete $ contract/object-field |Response.headers headers |delete
              unsafe-coerce object ResponseHost
          :examples $ []
          :ffi $ {} $ :backend :js
          :schema $ :: 'Fn $ {} (:return 'js-ffi.shared/ResponseHost)
            :args $ [] $ :: 'JsNullish 'JsObject
            :features $ #{} :js-ffi
        'response-json $ %{} 'CodeEntry
          :doc "|Await one response text, parse JSON, and expose the resulting object as Result<JsObject, JsError>."
          :code $ quote $ defn response-json (response)
            hint-fn $ {} (:async true)
              :args $ [] 'js-ffi.shared/ResponseHost
              :features $ #{} :js-ffi
              :return $ :: 'calcit.core/Result 'JsObject 'js-ffi.shared/JsError
            try
              let
                  text $ js-await $ response .text
                %:: Result :ok $ contract/expect-object |response.json $ js/JSON.parse (contract/expect-string |response.text text)
              fn (error)
                %:: Result :err $ normalize-error error
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'js-ffi.shared/ResponseHost
            :features $ #{} :js-ffi
            :return $ :: 'calcit.core/Result 'JsObject 'js-ffi.shared/JsError
        'response-text $ %{} 'CodeEntry
          :doc "|Await Response.text exactly once and normalize synchronous throws or Promise rejections as Result.err."
          :code $ quote $ defn response-text (response)
            hint-fn $ {} (:async true)
              :args $ [] 'js-ffi.shared/ResponseHost
              :features $ #{} :js-ffi
              :return $ :: 'Result 'String 'js-ffi.shared/JsError
            try
              %:: Result :ok $ contract/expect-string |Response.text $ js-await (response .text)
              fn (error)
                %:: Result :err $ normalize-error error
          :examples $ []
          :ffi $ {} $ :backend :js
          :schema $ :: 'Fn $ {}
            :args $ [] 'js-ffi.shared/ResponseHost
            :features $ #{} :js-ffi
            :return $ :: 'calcit.core/Result 'String 'js-ffi.shared/JsError
        'runtime-label $ %{} 'CodeEntry
          :doc "|Convert Runtime to the stable host label used in logs and compatibility checks."
          :code $ quote $ defn runtime-label (runtime)
            match runtime
              (:browser) |browser
              (:node) |node
              (:unknown label) label
          :examples $ [] $ quote
            runtime-label $ Runtime :browser
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ [] 'js-ffi.shared/Runtime
        'search-params->map $ %{} 'CodeEntry
          :doc "|Collect URLSearchParams entries into a Map<String, String>; duplicate keys keep the last value."
          :code $ quote $ defn search-params->map (value)
            let
                result $ atom $ {}
              value .for-each! $ fn (item key _parent) (swap! result assoc key item)
              deref result
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'js-ffi.shared/UrlSearchParamsHost
            :features $ #{} :js-ffi
            :return $ :: 'Map 'String 'String
        'search-params->pairs $ %{} 'CodeEntry
          :doc "|Collect URLSearchParams entries as a list of [key value] pairs, preserving duplicates and order."
          :code $ quote $ defn search-params->pairs (value)
            let
                result $ atom $ []
              value .for-each! $ fn (item key _parent)
                swap! result append $ [] key item
              deref result
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'js-ffi.shared/UrlSearchParamsHost
            :features $ #{} :js-ffi
            :return $ :: 'List $ :: 'List 'String
        'search-params-create $ %{} 'CodeEntry
          :doc "|Construct a native URLSearchParams and retain its typed host identity. Invalid constructor inputs raise host exceptions."
          :code $ quote $ defn search-params-create (query)
            unsafe-coerce (new js/URLSearchParams query) UrlSearchParamsHost
          :examples $ []
          :ffi $ {} $ :backend :js
          :schema $ :: 'Fn $ {} (:return 'js-ffi.shared/UrlSearchParamsHost)
            :args $ [] 'String
            :features $ #{} :js-ffi
        'search-params-delete! $ %{} 'CodeEntry (:doc "|Remove a key and return Unit.")
          :code $ quote $ defn search-params-delete! (value key) (value .delete! key) &unit
          :examples $ []
          :ffi $ {} $ :backend :js
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.shared/UrlSearchParamsHost 'String
            :features $ #{} :js-ffi
        'search-params-get $ %{} 'CodeEntry
          :doc "|Lookup a key; missing values become Option.none."
          :code $ quote $ defn search-params-get (value key)
            js-nullish->option $ value .get key
          :examples $ []
          :ffi $ {} $ :backend :js
          :schema $ :: 'Fn $ {}
            :args $ [] 'js-ffi.shared/UrlSearchParamsHost 'String
            :features $ #{} :js-ffi
            :return $ :: 'calcit.core/Option 'String
        'search-params-has? $ %{} 'CodeEntry (:doc "|Check whether a key exists.")
          :code $ quote $ defn search-params-has? (value key) (value .has? key)
          :examples $ []
          :ffi $ {} $ :backend :js
          :schema $ :: 'Fn $ {} (:return 'Bool)
            :args $ [] 'js-ffi.shared/UrlSearchParamsHost 'String
            :features $ #{} :js-ffi
        'search-params-set! $ %{} 'CodeEntry (:doc "|Replace the values for a key.")
          :code $ quote $ defn search-params-set! (value key text) (value .set! key text) &unit
          :examples $ []
          :ffi $ {} $ :backend :js
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.shared/UrlSearchParamsHost 'String 'String
            :features $ #{} :js-ffi
        'search-params-size $ %{} 'CodeEntry (:doc "|Count query entries, including duplicate keys.")
          :code $ quote $ defn search-params-size (value)
            let
                result $ value :size
              , result
          :examples $ []
          :ffi $ {} $ :backend :js
          :schema $ :: 'Fn $ {} (:return 'Number)
            :args $ [] 'js-ffi.shared/UrlSearchParamsHost
            :features $ #{} :js-ffi
        'search-params-string $ %{} 'CodeEntry
          :doc "|Serialize query parameters with standard percent encoding."
          :code $ quote $ defn search-params-string (value) (value .to-string)
          :examples $ []
          :ffi $ {} $ :backend :js
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ [] 'js-ffi.shared/UrlSearchParamsHost
            :features $ #{} :js-ffi
        'url-create $ %{} 'CodeEntry
          :doc "|Construct a native URL and retain its typed host identity. Invalid constructor inputs raise host exceptions."
          :code $ quote $ defn url-create (input base)
            unsafe-coerce (new js/URL input base) UrlHost
          :examples $ []
          :ffi $ {} $ :backend :js
          :schema $ :: 'Fn $ {} (:return 'js-ffi.shared/UrlHost)
            :args $ [] 'String 'String
            :features $ #{} :js-ffi
        'url-snapshot $ %{} 'CodeEntry
          :doc "|Copy a URL-like host object into immutable UrlSnapshot data without retaining host identity."
          :code $ quote $ defn url-snapshot (url)
            &%{} UrlSnapshot :href (url :href) :protocol (url :protocol) :host (url :host) :hostname (url :hostname) :port (url :port) :pathname (url :pathname) :search (url :search) :hash $ url :hash
          :examples $ [] $ quote UrlSnapshot
          :schema $ :: 'Fn $ {} (:return 'js-ffi.shared/UrlSnapshot)
            :args $ [] 'js-ffi.shared/UrlHost
            :features $ #{} :js-ffi
      :ns $ %{} 'NsEntry
        :doc "|Shared JavaScript FFI data types, normalized snapshots, and explicit external-object capabilities that work in browser and Node targets."
        :code $ quote $ ns js-ffi.shared
          :require $ js-ffi.contract :as contract
    'js-ffi.typed-arrays $ %{} 'FileEntry
      :defs $ {}
        'Float32ArrayHost $ %{} 'CodeEntry (:doc "|同 realm Float32Array 宿主句柄，调用方不得把共享内存当稳定快照。")
          :code $ quote $ deftrait Float32ArrayHost (:length 'Number) (:byteLength 'Number)
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object)
          :schema $ :: 'Trait
        'Float32SnapshotHost $ %{} 'CodeEntry (:doc "|不可变不透明快照；由 snapshot-float32 构造，不能直接访问底层数组。")
          :code $ quote $ deftrait Float32SnapshotHost
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object)
          :schema $ :: 'Trait
        'float32-at $ %{} 'CodeEntry (:doc "|读取一个有界索引；索引必须为范围内非负安全整数。")
          :code $ quote $ defn float32-at (snapshot index)
            hint-fn $ {}
              :args $ [] 'js-ffi.typed-arrays/Float32SnapshotHost 'Number
              :return 'Number
              :features $ #{} :js-ffi
            let
                read-at $ unsafe-coerce float32At $ :: 'Fn
                  {}
                    :args $ [] 'js-ffi.typed-arrays/Float32SnapshotHost 'Number
                    :return 'Number
              read-at snapshot index
          :examples $ []
          :ffi $ {} $ :backend :js
          :schema $ :: 'Fn $ {} (:return 'Number)
            :args $ [] 'js-ffi.typed-arrays/Float32SnapshotHost 'Number
            :features $ #{} :js-ffi
        'float32-byte-length $ %{} 'CodeEntry (:doc "|读取快照字节数；每个 Float32 元素为四字节。")
          :code $ quote $ defn float32-byte-length (snapshot)
            hint-fn $ {}
              :args $ [] 'js-ffi.typed-arrays/Float32SnapshotHost
              :return 'Number
              :features $ #{} :js-ffi
            let
                read-byte-length $ unsafe-coerce float32ByteLength $ :: 'Fn
                  {}
                    :args $ [] 'js-ffi.typed-arrays/Float32SnapshotHost
                    :return 'Number
              read-byte-length snapshot
          :examples $ []
          :ffi $ {} $ :backend :js
          :schema $ :: 'Fn $ {} (:return 'Number)
            :args $ [] 'js-ffi.typed-arrays/Float32SnapshotHost
            :features $ #{} :js-ffi
        'float32-copy-range $ %{} 'CodeEntry
          :doc "|按元素范围复制快照为新的可变 Float32Array；调用方可缓存用于 Canvas/GPU 上传。"
          :code $ quote $ defn float32-copy-range (snapshot start amount)
            hint-fn $ {}
              :args $ [] 'js-ffi.typed-arrays/Float32SnapshotHost 'Number 'Number
              :return 'js-ffi.typed-arrays/Float32ArrayHost
              :features $ #{} :js-ffi
            let
                copy-range $ unsafe-coerce float32CopyRange $ :: 'Fn
                  {}
                    :args $ [] 'js-ffi.typed-arrays/Float32SnapshotHost 'Number 'Number
                    :return 'js-ffi.typed-arrays/Float32ArrayHost
              copy-range snapshot start amount
          :examples $ []
          :ffi $ {} $ :backend :js
          :schema $ :: 'Fn $ {} (:return 'js-ffi.typed-arrays/Float32ArrayHost)
            :args $ [] 'js-ffi.typed-arrays/Float32SnapshotHost 'Number 'Number
            :features $ #{} :js-ffi
        'float32-length $ %{} 'CodeEntry (:doc "|读取快照的 Float32 元素数，不暴露原数组。")
          :code $ quote $ defn float32-length (snapshot)
            hint-fn $ {}
              :args $ [] 'js-ffi.typed-arrays/Float32SnapshotHost
              :return 'Number
              :features $ #{} :js-ffi
            let
                read-length $ unsafe-coerce float32Length $ :: 'Fn
                  {}
                    :args $ [] 'js-ffi.typed-arrays/Float32SnapshotHost
                    :return 'Number
              read-length snapshot
          :examples $ []
          :ffi $ {} $ :backend :js
          :schema $ :: 'Fn $ {} (:return 'Number)
            :args $ [] 'js-ffi.typed-arrays/Float32SnapshotHost
            :features $ #{} :js-ffi
        'snapshot-float32 $ %{} 'CodeEntry
          :doc "|校验并复制 Float32Array 为不可变快照；拒绝非有限值和 SharedArrayBuffer。"
          :code $ quote $ defn snapshot-float32 (source)
            hint-fn $ {}
              :args $ [] 'js-ffi.typed-arrays/Float32ArrayHost
              :return 'js-ffi.typed-arrays/Float32SnapshotHost
              :features $ #{} :js-ffi
            let
                snapshot $ unsafe-coerce snapshotFloat32 $ :: 'Fn
                  {}
                    :args $ [] 'js-ffi.typed-arrays/Float32ArrayHost
                    :return 'js-ffi.typed-arrays/Float32SnapshotHost
              snapshot source
          :examples $ []
          :ffi $ {} $ :backend :js
          :schema $ :: 'Fn $ {} (:return 'js-ffi.typed-arrays/Float32SnapshotHost)
            :args $ [] 'js-ffi.typed-arrays/Float32ArrayHost
            :features $ #{} :js-ffi
      :ns $ %{} 'NsEntry
        :doc "|跨 Node 与浏览器的 Float32 宿主快照边界；公开入口是 Calcit，JS 文件只保留底层复制和校验。"
        :code $ quote $ ns js-ffi.typed-arrays
          :require $ |@calcit/js-ffi/typed-arrays.mjs :refer $ snapshotFloat32 float32Length float32ByteLength float32At float32CopyRange
    'js-ffi.webgpu $ %{} 'FileEntry
      :defs $ {}
        'AdapterHost $ %{} 'CodeEntry
          :doc "|Small browser WebGPU host capability; use the checked public adapters to acquire it."
          :code $ quote $ deftrait AdapterHost
            .request-device $ :: 'Fn $ {}
              :args $ [] 'js-ffi.webgpu/AdapterHost 'JsObject
              :return $ :: 'JsNullish 'JsObject
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} $ :request-device |requestDevice
          :schema $ :: 'Trait
        'BufferHost $ %{} 'CodeEntry
          :doc "|Small browser WebGPU host capability; use the checked public adapters to acquire it."
          :code $ quote $ deftrait BufferHost
            :size $ :: 'JsNullish 'JsObject
            :usage $ :: 'JsNullish 'JsObject
            .destroy $ :: 'Fn $ {}
              :args $ [] 'js-ffi.webgpu/BufferHost
              :return 'Unit
            .unmap $ :: 'Fn $ {}
              :args $ [] 'js-ffi.webgpu/BufferHost
              :return 'Unit
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {}
          :schema $ :: 'Trait
        'DeviceHost $ %{} 'CodeEntry
          :doc "|Small browser WebGPU host capability; use the checked public adapters to acquire it."
          :code $ quote $ deftrait DeviceHost
            :lost $ :: 'JsNullish 'JsObject
            .destroy $ :: 'Fn $ {}
              :args $ [] 'js-ffi.webgpu/DeviceHost
              :return 'Unit
            .create-buffer $ :: 'Fn $ {}
              :args $ [] 'js-ffi.webgpu/DeviceHost 'JsObject
              :return $ :: 'JsNullish 'JsObject
            .push-error-scope $ :: 'Fn $ {}
              :args $ [] 'js-ffi.webgpu/DeviceHost 'String
              :return 'Unit
            .pop-error-scope $ :: 'Fn $ {}
              :args $ [] 'js-ffi.webgpu/DeviceHost
              :return $ :: 'JsNullish 'JsObject
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} (:create-buffer |createBuffer) (:pop-error-scope |popErrorScope) (:push-error-scope |pushErrorScope)
          :schema $ :: 'Trait
        'DeviceLost $ %{} 'CodeEntry
          :doc "|Copied device-loss reason and message. Unknown future reason strings are preserved."
          :code $ quote $ defstruct DeviceLost (:reason 'String) (:message 'String)
          :examples $ []
          :schema $ :: 'StructDef
        'GpuHost $ %{} 'CodeEntry
          :doc "|Small browser WebGPU host capability; use the checked public adapters to acquire it."
          :code $ quote $ deftrait GpuHost
            .request-adapter $ :: 'Fn $ {}
              :args $ [] 'js-ffi.webgpu/GpuHost 'JsObject
              :return $ :: 'JsNullish 'JsObject
            .preferred-format $ :: 'Fn $ {}
              :args $ [] 'js-ffi.webgpu/GpuHost
              :return $ :: 'JsNullish 'JsObject
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} (:preferred-format |getPreferredCanvasFormat) (:request-adapter |requestAdapter)
          :schema $ :: 'Trait
        'buffer-size $ %{} 'CodeEntry
          :doc "|Read buffer byte size through a checked host field."
          :code $ quote $ defn buffer-size (buffer) (contract/expect-number |GPUBuffer.size buffer.:size)
          :examples $ []
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {} (:return 'Number)
            :args $ [] 'js-ffi.webgpu/BufferHost
            :features $ #{} :js-ffi
        'create-buffer $ %{} 'CodeEntry
          :doc "|Create an unmapped buffer. size is bytes; usage is the WebGPU GPUBufferUsage bitmask. Device limits and usage combinations are validated by WebGPU; surround calls with an error scope."
          :code $ quote $ defn create-buffer (device size usage)
            when
              or
                not $ js/Number.isSafeInteger size
                < size 0
              raise |WebGPU.buffer.size-must-be-a-nonnegative-safe-integer
            when
              or
                not $ js/Number.isSafeInteger usage
                <= usage 0
                > usage 1023
              raise |WebGPU.buffer.usage-must-be-a-nonzero-known-bitmask
            internal/buffer-host $ device .create-buffer $ &js-object :size size :usage usage :mappedAtCreation false
          :examples $ []
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {} (:return 'js-ffi.webgpu/BufferHost)
            :args $ [] 'js-ffi.webgpu/DeviceHost 'Number 'Number
            :features $ #{} :js-ffi
        'destroy-buffer! $ %{} 'CodeEntry
          :doc "|Release buffer resources; mapped views are detached by WebGPU."
          :code $ quote $ defn destroy-buffer! (buffer) (buffer .destroy)
          :examples $ []
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.webgpu/BufferHost
            :features $ #{} :js-ffi
        'destroy-device! $ %{} 'CodeEntry
          :doc "|Destroy a device explicitly. Multiple calls are allowed by WebGPU; later GPU work is invalid."
          :code $ quote $ defn destroy-device! (device) (device .destroy)
          :examples $ []
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.webgpu/DeviceHost
            :features $ #{} :js-ffi
        'gpu $ %{} 'CodeEntry
          :doc "|Return Option<GpuHost>. Absence (including non-browser/insecure hosts) is none; malformed non-null capabilities raise a contract violation."
          :code $ quote $ defn gpu ()
            if (exists? js/navigator)
              let
                  value $ contract/object-field |navigator js/navigator |gpu
                if (js-nullish? value) (%none)
                  %some $ internal/gpu-host value
              %none
          :examples $ []
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {}
            :args $ []
            :features $ #{} :js-ffi
            :return $ :: 'calcit.core/Option 'js-ffi.webgpu/GpuHost
        'pop-error-scope! $ %{} 'CodeEntry
          :doc "|Pop a scope: none means no captured error; some contains the error message. A rejected pop (such as empty scope stack) goes to failed!."
          :code $ quote $ defn pop-error-scope! (device ready! failed!)
            internal/observe! (device .pop-error-scope)
              fn (value)
                if (js-nullish? value)
                  ready! $ %none
                  ready! $ %some $ contract/expect-string |GPUError.message (contract/object-field |GPUError value |message)
              , failed!
          :examples $ []
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.webgpu/DeviceHost
              :: 'Fn $ {} (:return 'Unit)
                :args $ [] $ :: 'calcit.core/Option 'String
              :: 'Fn $ {} (:return 'Unit)
                :args $ [] 'String
            :features $ #{} :js-ffi
        'preferred-canvas-format $ %{} 'CodeEntry
          :doc "|Return the browser-preferred canvas format; does not configure a canvas."
          :code $ quote $ defn preferred-canvas-format (gpu)
            contract/expect-string |GPU.getPreferredCanvasFormat $ gpu .preferred-format
          :examples $ []
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ [] 'js-ffi.webgpu/GpuHost
            :features $ #{} :js-ffi
        'push-validation-scope! $ %{} 'CodeEntry
          :doc "|Push a validation error scope. Pair with pop-error-scope!; scopes belong to the device and are stack ordered."
          :code $ quote $ defn push-validation-scope! (device) (device .push-error-scope |validation)
          :examples $ []
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.webgpu/DeviceHost
            :features $ #{} :js-ffi
        'request-adapter! $ %{} 'CodeEntry
          :doc "|Request a default adapter. Callback receives none if unavailable. Promise rejection/decoder failure goes to failed! as String. No Promise is exposed as an adapter."
          :code $ quote $ defn request-adapter! (gpu ready! failed!)
            internal/observe!
              gpu .request-adapter $ &js-object
              fn (value)
                if (js-nullish? value)
                  ready! $ %none
                  ready! $ %some $ internal/adapter-host value
              , failed!
          :examples $ []
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.webgpu/GpuHost
              :: 'Fn $ {} (:return 'Unit)
                :args $ [] $ :: 'calcit.core/Option 'js-ffi.webgpu/AdapterHost
              :: 'Fn $ {} (:return 'Unit)
                :args $ [] 'String
            :features $ #{} :js-ffi
        'request-device! $ %{} 'CodeEntry
          :doc "|Request a default device once per adapter. No extra features or limits are requested. Register device loss separately; successful allocation does not imply an indefinitely usable device."
          :code $ quote $ defn request-device! (adapter ready! failed!)
            internal/observe!
              adapter .request-device $ &js-object
              fn (value)
                ready! $ internal/device-host value
              , failed!
          :examples $ []
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.webgpu/AdapterHost
              :: 'Fn $ {} (:return 'Unit)
                :args $ [] 'js-ffi.webgpu/DeviceHost
              :: 'Fn $ {} (:return 'Unit)
                :args $ [] 'String
            :features $ #{} :js-ffi
        'watch-device-lost! $ %{} 'CodeEntry
          :doc "|Observe device.lost without retrying or reusing the adapter. Listener lives until the promise settles; no cancellation is provided."
          :code $ quote $ defn watch-device-lost! (device ready! failed!)
            internal/observe! device.:lost
              fn (value)
                ready! $ DeviceLost :reason
                  contract/expect-string |GPUDeviceLostInfo.reason $ contract/object-field |GPUDeviceLostInfo value |reason
                  , :message $ contract/expect-string |GPUDeviceLostInfo.message (contract/object-field |GPUDeviceLostInfo value |message)
              , failed!
          :examples $ []
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.webgpu/DeviceHost
              :: 'Fn $ {} (:return 'Unit)
                :args $ [] 'js-ffi.webgpu/DeviceLost
              :: 'Fn $ {} (:return 'Unit)
                :args $ [] 'String
            :features $ #{} :js-ffi
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns js-ffi.webgpu
          :require (js-ffi.webgpu-internal :as internal) (js-ffi.contract :as contract)
    'js-ffi.webgpu-batches $ %{} 'FileEntry
      :defs $ {}
        'Float32PositionsHost $ %{} 'CodeEntry (:doc "|浏览器 Float32Array 宿主句柄；只由本模块构造或经明确 FFI 边界传入。")
          :code $ quote $ deftrait Float32PositionsHost (:length 'Number)
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
          :schema $ :: 'Trait
        'RectBatchHost $ %{} 'CodeEntry (:doc "|浏览器 WebGPU 矩形图层宿主句柄；所有权由调用者管理。")
          :code $ quote $ deftrait RectBatchHost
            .upload $ :: 'Fn $ {}
              :args $ [] 'js-ffi.webgpu-batches/RectBatchHost 'js-ffi.webgpu-batches/Float32PositionsHost 'Number 'Number
              :return 'JsObject
            .draw $ :: 'Fn $ {}
              :args $ [] 'js-ffi.webgpu-batches/RectBatchHost 'JsObject
              :return 'JsObject
            .read-translation $ :: 'Fn $ {}
              :args $ [] 'js-ffi.webgpu-batches/RectBatchHost
              :return 'JsObject
            .read-pixel $ :: 'Fn $ {}
              :args $ [] 'js-ffi.webgpu-batches/RectBatchHost 'Number 'Number
              :return 'JsObject
            .dispose $ :: 'Fn $ {}
              :args $ [] 'js-ffi.webgpu-batches/RectBatchHost
              :return 'Bool
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
          :schema $ :: 'Trait
        'RectColor $ %{} 'CodeEntry (:doc "|直通道 RGBA 颜色；绘制 shader 输出时转为预乘 alpha。")
          :code $ quote $ defstruct RectColor (:r 'Number) (:g 'Number) (:b 'Number) (:a 'Number)
          :examples $ []
          :schema $ :: 'StructDef
        'RectFrame $ %{} 'CodeEntry (:doc "|单次矩形批次绘制参数；可选 count=0 可提交空帧清屏，可选位移动画按绝对时间采样。")
          :code $ quote $ defstruct RectFrame (:width 'Number) (:height 'Number) (:fill 'js-ffi.webgpu-batches/RectColor) (:alpha 'Number)
            :translation $ :: 'calcit.core/Option 'js-ffi.webgpu-batches/RectTranslation
            :count $ :: 'calcit.core/Option 'Number
          :examples $ []
          :schema $ :: 'StructDef
        'RectMetrics $ %{} 'CodeEntry (:doc "|单次绘制的批次、实例、位置和 uniform 上传及保留资源创建计数。")
          :code $ quote $ defstruct RectMetrics (:draw-calls 'Number) (:instances 'Number) (:position-bytes-uploaded 'Number) (:uniform-bytes-uploaded 'Number) (:pipelines-created 'Number) (:buffers-created 'Number)
          :examples $ []
          :schema $ :: 'StructDef
        'RectPixel $ %{} 'CodeEntry (:doc "|诊断读回的一个 RGBA 像素，四通道均为 0..255 整数。")
          :code $ quote $ defstruct RectPixel (:r 'Number) (:g 'Number) (:b 'Number) (:a 'Number)
          :examples $ []
          :schema $ :: 'StructDef
        'RectTranslation $ %{} 'CodeEntry (:doc "|共享的 Vec2 起止位置、绝对时间、起点、持续时间和缓动。")
          :code $ quote $ defstruct RectTranslation (:from 'js-ffi.webgpu-batches/RectVec2) (:to 'js-ffi.webgpu-batches/RectVec2) (:time 'Number) (:start 'Number) (:duration 'Number) (:easing 'String)
          :examples $ []
          :schema $ :: 'StructDef
        'RectTranslationSample $ %{} 'CodeEntry (:doc "|GPU 诊断读回的一个 f32 Vec2 位移样本。")
          :code $ quote $ defstruct RectTranslationSample (:x 'Number) (:y 'Number)
          :examples $ []
          :schema $ :: 'StructDef
        'RectVec2 $ %{} 'CodeEntry (:doc "|矩形图层使用的实际像素坐标二维向量。")
          :code $ quote $ defstruct RectVec2 (:x 'Number) (:y 'Number)
          :examples $ []
          :schema $ :: 'StructDef
        'create-rect-batch! $ %{} 'CodeEntry (:doc "|异步创建保留式矩形图层；断言同包底层 JS 构造器的契约，调用者负责释放。")
          :code $ quote $ defn create-rect-batch! (canvas device format capacity)
            hint-fn $ {} (:async true)
              :args $ [] 'js-ffi.browser/DomElementHost 'js-ffi.webgpu/DeviceHost 'String 'Number
              :return 'js-ffi.webgpu-batches/RectBatchHost
              :features $ #{} :js-ffi
            let
                create $ unsafe-coerce createFloat32RectBatch $ :: 'Fn
                  {} (:async true)
                    :args $ [] 'js-ffi.browser/DomElementHost 'js-ffi.webgpu/DeviceHost 'String 'Number
                    :return 'js-ffi.webgpu-batches/RectBatchHost
              js-await $ create canvas device format capacity
          :examples $ []
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {} (:async true) (:return 'js-ffi.webgpu-batches/RectBatchHost)
            :args $ [] 'js-ffi.browser/DomElementHost 'js-ffi.webgpu/DeviceHost 'String 'Number
            :features $ #{} :js-ffi
        'dispose-batch! $ %{} 'CodeEntry (:doc "|幂等释放矩形图层的 GPU 资源并解除 canvas 配置。")
          :code $ quote $ defn dispose-batch! (batch)
            hint-fn $ {}
              :args $ [] 'js-ffi.webgpu-batches/RectBatchHost
              :return 'Bool
              :features $ #{} :js-ffi
            batch .dispose
          :examples $ []
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {} (:return 'Bool)
            :args $ [] 'js-ffi.webgpu-batches/RectBatchHost
            :features $ #{} :js-ffi
        'draw-rects! $ %{} 'CodeEntry (:doc "|把类型化 Calcit 帧转成一次 WebGPU draw，并解码计数；时间帧不重传静态位置。")
          :code $ quote $ defn draw-rects! (batch frame)
            hint-fn $ {}
              :args $ [] 'js-ffi.webgpu-batches/RectBatchHost 'js-ffi.webgpu-batches/RectFrame
              :return 'js-ffi.webgpu-batches/RectMetrics
              :features $ #{} :js-ffi
            let
                color $ :fill frame
                maybe-translation $ :translation frame
                translation $ if (option:some? maybe-translation)
                  let
                      motion $ option:unwrap maybe-translation
                      from $ :from motion
                      to $ :to motion
                    js-object
                      :from $ js-object
                        :x $ :x from
                        :y $ :y from
                      :to $ js-object
                        :x $ :x to
                        :y $ :y to
                      :time $ :time motion
                      :start $ :start motion
                      :duration $ :duration motion
                      :easing $ :easing motion
                  , js/undefined
                maybe-count $ :count frame
                draw-count $ if (option:some? maybe-count) (option:unwrap maybe-count) js/undefined
                options $ js-object
                  :width $ :width frame
                  :height $ :height frame
                  :fill $ js-object
                    :r $ :r color
                    :g $ :g color
                    :b $ :b color
                    :a $ :a color
                  :alpha $ :alpha frame
                  :translation translation
                  :count draw-count
                result $ batch .draw options
              let
                  draws $ contract/expect-number |RectBatch.drawCalls $ contract/object-field |RectBatch.draw result |drawCalls
                  instances $ contract/expect-number |RectBatch.instances $ contract/object-field |RectBatch.draw result |instances
                  uploaded $ contract/expect-number |RectBatch.positionBytesUploaded $ contract/object-field |RectBatch.draw result |positionBytesUploaded
                  uniform $ contract/expect-number |RectBatch.uniformBytesUploaded $ contract/object-field |RectBatch.draw result |uniformBytesUploaded
                  pipelines $ contract/expect-number |RectBatch.pipelinesCreated $ contract/object-field |RectBatch.draw result |pipelinesCreated
                  buffers $ contract/expect-number |RectBatch.buffersCreated $ contract/object-field |RectBatch.draw result |buffersCreated
                RectMetrics :draw-calls draws :instances instances :position-bytes-uploaded uploaded :uniform-bytes-uploaded uniform :pipelines-created pipelines :buffers-created buffers
          :examples $ []
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {} (:return 'js-ffi.webgpu-batches/RectMetrics)
            :args $ [] 'js-ffi.webgpu-batches/RectBatchHost 'js-ffi.webgpu-batches/RectFrame
            :features $ #{} :js-ffi
        'positions-from-list $ %{} 'CodeEntry
          :doc "|将 Calcit 数值列表一次性复制成浏览器 Float32Array；用于初始上传，不用于逐帧重建。"
          :code $ quote $ defn positions-from-list (values)
            hint-fn $ {}
              :args $ [] $ :: 'List 'Number
              :return 'js-ffi.webgpu-batches/Float32PositionsHost
              :features $ #{} :js-ffi
            unsafe-coerce
              new js/Float32Array $ to-js-data values
              , 'js-ffi.webgpu-batches/Float32PositionsHost
          :examples $ []
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {} (:return 'js-ffi.webgpu-batches/Float32PositionsHost)
            :args $ [] $ :: 'List 'Number
            :features $ #{} :js-ffi
        'read-pixel! $ %{} 'CodeEntry (:doc "|诊断专用：异步读取一个画布像素；正常播放不要调用。")
          :code $ quote $ defn read-pixel! (batch x y)
            hint-fn $ {} (:async true)
              :args $ [] 'js-ffi.webgpu-batches/RectBatchHost 'Number 'Number
              :return 'js-ffi.webgpu-batches/RectPixel
              :features $ #{} :js-ffi
            let
                raw $ js-await $ batch .read-pixel x y
                r $ contract/expect-number |RectBatch.pixel.r $ contract/object-field |RectBatch.pixel raw |0
                g $ contract/expect-number |RectBatch.pixel.g $ contract/object-field |RectBatch.pixel raw |1
                b $ contract/expect-number |RectBatch.pixel.b $ contract/object-field |RectBatch.pixel raw |2
                a $ contract/expect-number |RectBatch.pixel.a $ contract/object-field |RectBatch.pixel raw |3
              RectPixel :r r :g g :b b :a a
          :examples $ []
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {} (:async true) (:return 'js-ffi.webgpu-batches/RectPixel)
            :args $ [] 'js-ffi.webgpu-batches/RectBatchHost 'Number 'Number
            :features $ #{} :js-ffi
        'read-translation! $ %{} 'CodeEntry (:doc "|诊断专用：异步读回与顶点 shader 共用函数的 f32 位移；正常播放不要调用。")
          :code $ quote $ defn read-translation! (batch)
            hint-fn $ {} (:async true)
              :args $ [] 'js-ffi.webgpu-batches/RectBatchHost
              :return 'js-ffi.webgpu-batches/RectTranslationSample
              :features $ #{} :js-ffi
            let
                raw $ js-await $ batch .read-translation
                x $ contract/expect-number |RectBatch.translation.x $ contract/object-field |RectBatch.translation raw |x
                y $ contract/expect-number |RectBatch.translation.y $ contract/object-field |RectBatch.translation raw |y
              RectTranslationSample :x x :y y
          :examples $ []
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {} (:async true) (:return 'js-ffi.webgpu-batches/RectTranslationSample)
            :args $ [] 'js-ffi.webgpu-batches/RectBatchHost
            :features $ #{} :js-ffi
        'upload-positions! $ %{} 'CodeEntry (:doc "|按实例范围上传 Float32 位置数据，返回本次上传字节数。")
          :code $ quote $ defn upload-positions! (batch positions start instance-count)
            hint-fn $ {}
              :args $ [] 'js-ffi.webgpu-batches/RectBatchHost 'js-ffi.webgpu-batches/Float32PositionsHost 'Number 'Number
              :return 'Number
              :features $ #{} :js-ffi
            let
                result $ batch .upload positions start instance-count
              contract/expect-number |RectBatch.positionBytesUploaded $ contract/object-field |RectBatch.upload result |positionBytesUploaded
          :examples $ []
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {} (:return 'Number)
            :args $ [] 'js-ffi.webgpu-batches/RectBatchHost 'js-ffi.webgpu-batches/Float32PositionsHost 'Number 'Number
            :features $ #{} :js-ffi
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns js-ffi.webgpu-batches
          :require
            |@calcit/js-ffi/webgpu-rect-batches.mjs :refer $ createFloat32RectBatch
            js-ffi.contract :as contract
            js-ffi.browser :as browser
            js-ffi.webgpu :as webgpu
    'js-ffi.webgpu-capabilities $ %{} 'FileEntry
      :defs $ {}
        'DeviceProbe $ %{} 'CodeEntry (:doc "|能力探测的封闭分支；只有 ready 携带需显式释放的设备句柄。")
          :code $ quote $ defenum DeviceProbe (:ready 'js-ffi.webgpu-capabilities/ReadyDeviceHost) (:unavailable 'js-ffi.webgpu-capabilities/ProbeUnavailable) (:failed 'js-ffi.webgpu-capabilities/ProbeFailure)
          :examples $ []
          :schema $ :: 'Enum
        'NavigatorHost $ %{} 'CodeEntry (:doc "|浏览器 navigator 或测试宿主；gpu 访问异常由探测函数归入失败阶段。")
          :code $ quote $ deftrait NavigatorHost
            :gpu $ :: 'JsNullish 'JsObject
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
          :schema $ :: 'Trait
        'ProbeFailure $ %{} 'CodeEntry (:doc "|探测失败阶段和归一化错误消息。")
          :code $ quote $ defstruct ProbeFailure (:stage 'String) (:message 'String)
          :examples $ []
          :schema $ :: 'StructDef
        'ProbeUnavailable $ %{} 'CodeEntry (:doc "|宿主或 adapter 不可用的阶段。")
          :code $ quote $ defstruct ProbeUnavailable (:stage 'String)
          :examples $ []
          :schema $ :: 'StructDef
        'ReadyDeviceHost $ %{} 'CodeEntry
          :doc "|持有 adapter/device 的 ready 句柄；release 幂等，lost 为诊断 Promise；设备生命周期不属于 Scene IR。"
          :code $ quote $ deftrait ReadyDeviceHost (:adapter 'js-ffi.webgpu/AdapterHost) (:device 'js-ffi.webgpu/DeviceHost) (:format 'String) (:state 'String) (:lost 'js-ffi.shared/PromiseHost)
            .release $ :: 'Fn $ {}
              :args $ [] 'js-ffi.webgpu-capabilities/ReadyDeviceHost
              :return 'Bool
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
          :schema $ :: 'Trait
        'probe-device! $ %{} 'CodeEntry
          :doc "|异步探测宿主 GPU，返回封闭的 ready/unavailable/failed 分支；ready 的设备由调用方释放。"
          :code $ quote $ defn probe-device! (navigator-host)
            hint-fn $ {} (:async true)
              :args $ [] $ :: 'JsNullish 'js-ffi.webgpu-capabilities/NavigatorHost
              :return 'js-ffi.webgpu-capabilities/DeviceProbe
              :features $ #{} :js-ffi
            let
                probe $ unsafe-coerce probeWebGpuDevice $ :: 'Fn
                  {} (:async true)
                    :args $ [] $ :: 'JsNullish 'js-ffi.webgpu-capabilities/NavigatorHost
                    :return 'JsObject
                result $ js-await $ probe navigator-host
                kind $ contract/expect-string |WebGPU.probe.kind $ contract/object-field |WebGPU.probe result |kind
              if (= kind |ready)
                DeviceProbe :ready $ unsafe-coerce result ReadyDeviceHost
                if (= kind |unavailable)
                  let
                      stage $ contract/expect-string |WebGPU.probe.stage $ contract/object-field |WebGPU.probe result |stage
                    DeviceProbe :unavailable $ ProbeUnavailable :stage stage
                  if (= kind |failed)
                    let
                        stage $ contract/expect-string |WebGPU.probe.stage $ contract/object-field |WebGPU.probe result |stage
                        message $ contract/expect-string |WebGPU.probe.message $ contract/object-field |WebGPU.probe result |message
                      DeviceProbe :failed $ ProbeFailure :stage stage :message message
                    raise $ str "|Unexpected WebGPU probe kind: " kind
          :examples $ []
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {} (:async true) (:return 'js-ffi.webgpu-capabilities/DeviceProbe)
            :args $ [] $ :: 'JsNullish 'js-ffi.webgpu-capabilities/NavigatorHost
            :features $ #{} :js-ffi
      :ns $ %{} 'NsEntry (:doc "|WebGPU 能力探测、失败阶段与显式设备所有权的 Calcit 公共契约。")
        :code $ quote $ ns js-ffi.webgpu-capabilities
          :require
            |@calcit/js-ffi/webgpu-capabilities.mjs :refer $ probeWebGpuDevice
            js-ffi.contract :as contract
    'js-ffi.webgpu-internal $ %{} 'FileEntry
      :defs $ {}
        'PromiseHost $ %{} 'CodeEntry (:doc |)
          :code $ quote $ deftrait PromiseHost
            .then $ :: 'Fn $ {}
              :args $ [] 'js-ffi.webgpu-internal/PromiseHost
                :: 'Fn $ {}
                  :args $ [] $ :: 'JsNullish 'JsObject
                  :return 'Unit
                :: 'Fn $ {}
                  :args $ [] $ :: 'JsNullish 'JsObject
                  :return 'Unit
              :return 'JsObject
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
          :schema $ :: 'Trait
        'adapter-host $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn adapter-host (value)
            let
                object $ contract/expect-object |WebGPU.adapter-host value
              contract/expect-function |WebGPU.adapter-host.requestDevice $ contract/object-field |WebGPU.adapter-host object |requestDevice
              unsafe-coerce object 'js-ffi.webgpu/AdapterHost
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'js-ffi.webgpu/AdapterHost)
            :args $ [] $ :: 'JsNullish 'JsObject
            :features $ #{} :js-ffi
        'buffer-host $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn buffer-host (value)
            let
                object $ contract/expect-object |WebGPU.buffer-host value
              contract/expect-function |WebGPU.buffer-host.destroy $ contract/object-field |WebGPU.buffer-host object |destroy
              contract/expect-function |WebGPU.buffer-host.unmap $ contract/object-field |WebGPU.buffer-host object |unmap
              unsafe-coerce object 'js-ffi.webgpu/BufferHost
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'js-ffi.webgpu/BufferHost)
            :args $ [] $ :: 'JsNullish 'JsObject
            :features $ #{} :js-ffi
        'device-host $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn device-host (value)
            let
                object $ contract/expect-object |WebGPU.device-host value
              contract/expect-function |WebGPU.device-host.destroy $ contract/object-field |WebGPU.device-host object |destroy
              contract/expect-function |WebGPU.device-host.createBuffer $ contract/object-field |WebGPU.device-host object |createBuffer
              contract/expect-function |WebGPU.device-host.pushErrorScope $ contract/object-field |WebGPU.device-host object |pushErrorScope
              contract/expect-function |WebGPU.device-host.popErrorScope $ contract/object-field |WebGPU.device-host object |popErrorScope
              unsafe-coerce object 'js-ffi.webgpu/DeviceHost
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'js-ffi.webgpu/DeviceHost)
            :args $ [] $ :: 'JsNullish 'JsObject
            :features $ #{} :js-ffi
        'error-message $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn error-message (value)
            try
              contract/expect-string |WebGPU.error $ js/String value
              fn (error) |WebGPU.error-unprintable
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ [] $ :: 'JsNullish 'JsObject
            :features $ #{} :js-ffi
        'gpu-host $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn gpu-host (value)
            let
                object $ contract/expect-object |WebGPU.gpu-host value
              contract/expect-function |WebGPU.gpu-host.requestAdapter $ contract/object-field |WebGPU.gpu-host object |requestAdapter
              contract/expect-function |WebGPU.gpu-host.getPreferredCanvasFormat $ contract/object-field |WebGPU.gpu-host object |getPreferredCanvasFormat
              unsafe-coerce object 'js-ffi.webgpu/GpuHost
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'js-ffi.webgpu/GpuHost)
            :args $ [] $ :: 'JsNullish 'JsObject
            :features $ #{} :js-ffi
        'observe! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn observe! (promise ready! failed!)
            let
                host $ promise-host promise
              host .then
                fn (value)
                  try (ready! value)
                    fn (error)
                      failed! $ error-message error
                fn (error)
                  failed! $ error-message error
              , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] (:: 'JsNullish 'JsObject)
              :: 'Fn $ {} (:return 'Unit)
                :args $ [] $ :: 'JsNullish 'JsObject
              :: 'Fn $ {} (:return 'Unit)
                :args $ [] 'String
            :features $ #{} :js-ffi
        'promise-host $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn promise-host (value)
            let
                object $ contract/expect-object |WebGPU.promise-host value
              contract/expect-function |WebGPU.promise-host.then $ contract/object-field |WebGPU.promise-host object |then
              unsafe-coerce object 'js-ffi.webgpu-internal/PromiseHost
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'js-ffi.webgpu-internal/PromiseHost)
            :args $ [] $ :: 'JsNullish 'JsObject
            :features $ #{} :js-ffi
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns js-ffi.webgpu-internal
          :require $ js-ffi.contract :as contract
