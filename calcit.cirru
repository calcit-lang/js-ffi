
{} (:about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --full` first. Manual edits must follow format and schema conventions, then run `calcit edit format`.") (:package |js-ffi)
  :entries $ {}
    :browser $ {} (:description |) (:init-fn 'js-ffi.browser-test/main!) (:mode :js) (:reload-fn 'js-ffi.browser-test/reload!) (:target :browser)
      :feature-policy $ {} (:js-ffi :error)
      :modules $ []
      :type-slots $ {}
    :default $ {} (:description |) (:init-fn 'js-ffi.node-test/main!) (:mode :native) (:reload-fn 'js-ffi.node-test/reload!) (:target :node)
      :feature-policy $ {} (:js-ffi :error)
      :modules $ []
      :type-slots $ {}
    :node $ {} (:description |) (:init-fn 'js-ffi.node-test/main!) (:mode :native) (:reload-fn 'js-ffi.node-test/reload!) (:target :node)
      :feature-policy $ {} (:js-ffi :error)
      :modules $ []
      :type-slots $ {}
  :files $ {}
    'js-ffi.browser $ %{} 'FileEntry
      :defs $ {}
        'BrowserProbe $ %{} 'CodeEntry (:doc "|Typed browser smoke result replacing the former heterogeneous Map<Dynamic>.")
          :code $ quote
            defstruct BrowserProbe (:runtime 'js-ffi.shared/Runtime) (:document? 'Bool) (:storage 'String) (:viewport 'js-ffi.browser/Viewport)
          :examples $ []
            quote $ &%{} BrowserProbe :runtime (%:: shared/Runtime :browser) :document? true :storage |ok :viewport (&%{} Viewport :width 1024 :height 768 :device-pixel-ratio 2)
          :schema $ :: 'Enum
        'DocumentHost $ %{} 'CodeEntry (:doc "|External Document capability with typed state, title, and small selector/creation surface.")
          :code $ quote
            deftrait DocumentHost (:title 'String) (:ready-state 'String) (:visibility-state 'String)
              .query-selector $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.browser/DocumentHost 'String
                  :return $ :: 'JsNullish 'js-ffi.browser/DomElementHost
              .create-element $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.browser/DocumentHost 'String
                  :return 'js-ffi.browser/DomElementHost
          :examples $ [] (quote DocumentHost)
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} (:create-element |createElement) (:query-selector |querySelector) (:ready-state |readyState) (:visibility-state |visibilityState)
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'DocumentReadyState $ %{} 'CodeEntry (:doc "|Typed document.readyState values with an unknown String variant for forward compatibility.")
          :code $ quote
            defenum DocumentReadyState (:loading) (:interactive) (:complete) (:unknown 'String)
          :examples $ []
            quote $ %:: DocumentReadyState :complete
          :schema $ :: 'Enum
        'DomChildrenHost $ %{} 'CodeEntry (:doc "|External DOM children collection with typed length and nullable indexed element lookup.")
          :code $ quote
            deftrait DomChildrenHost (:length 'Number)
              .item $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.browser/DomChildrenHost 'Number
                  :return $ :: 'JsNullish 'js-ffi.browser/DomElementHost
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {}
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'DomElementHost $ %{} 'CodeEntry (:doc "|External DOM Element capability with stable fields, selector methods, attributes, and focus effects.")
          :code $ quote
            deftrait DomElementHost (:id 'String) (:class-name 'String)
              :text-content $ :: 'JsNullish 'String
              :child-element-count 'Number
              :dataset 'JsObject
              :style 'JsObject
              .append-child! $ :: 'Fn
                {}
                  :generics $ [] 'T
                  :args $ [] 'T 'T
                  :return 'T
              .matches? $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.browser/DomElementHost 'String
                  :return 'Bool
              .query-selector $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.browser/DomElementHost 'String
                  :return $ :: 'JsNullish 'js-ffi.browser/DomElementHost
              .get-attribute $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.browser/DomElementHost 'String
                  :return $ :: 'JsNullish 'String
              .set-attribute! $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.browser/DomElementHost 'String 'String
                  :return 'Unit
              .remove-attribute! $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.browser/DomElementHost 'String
                  :return 'Unit
              .focus! $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.browser/DomElementHost
                  :return 'Unit
              .blur! $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.browser/DomElementHost
                  :return 'Unit
              :children 'js-ffi.browser/DomChildrenHost
              :inner-html 'String
              :local-name 'String
          :examples $ [] (quote DomElementHost)
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} (:inner-html |innerHTML)
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'DomInputHost $ %{} 'CodeEntry (:doc "|External HTML input capability. Mutable fields are declared in FFI metadata, not in the core trait type.")
          :code $ quote
            deftrait DomInputHost (:value 'String) (:checked 'Bool) (:disabled 'Bool) (:name 'String) (:input-type 'String)
              .focus! $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.browser/DomInputHost
                  :return 'Unit
              .blur! $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.browser/DomInputHost
                  :return 'Unit
          :examples $ [] (quote DomInputHost)
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} (:blur! |blur) (:focus! |focus) (:input-type |type)
            :writable $ #{} :checked :disabled :input-type :name :value
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'ElementSnapshot $ %{} 'CodeEntry (:doc "|Calcit-owned subset of DOM element data suitable for business code without retaining host identity.")
          :code $ quote
            defstruct ElementSnapshot (:id 'String) (:class-name 'String)
              :text-content $ :: 'Option 'String
              :child-count 'Number
          :examples $ []
            quote $ &%{} ElementSnapshot :id |main :class-name |panel :text-content (%some |Ready) :child-count 1
          :schema $ :: 'Enum
        'EventHost $ %{} 'CodeEntry (:doc "|External Event capability. Targets stay nullable opaque objects unless a specific adapter narrows them.")
          :code $ quote
            deftrait EventHost (:event-type 'String)
              :target $ :: 'JsNullish 'JsObject
              :current-target $ :: 'JsNullish 'JsObject
              :default-prevented? 'Bool
              :event-phase 'Number
              .prevent-default! $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.browser/EventHost
                  :return 'Unit
              .stop-propagation! $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.browser/EventHost
                  :return 'Unit
          :examples $ [] (quote EventHost)
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} (:current-target |currentTarget) (:default-prevented? |defaultPrevented) (:event-phase |eventPhase) (:event-type |type) (:prevent-default! |preventDefault) (:stop-propagation! |stopPropagation)
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'KeyModifiers $ %{} 'CodeEntry (:doc "|Normalized keyboard or pointer modifier state shared by event adapters.")
          :code $ quote
            defstruct KeyModifiers (:alt? 'Bool) (:ctrl? 'Bool) (:meta? 'Bool) (:shift? 'Bool)
          :examples $ []
            quote $ &%{} KeyModifiers :alt? false :ctrl? true :meta? false :shift? false
          :schema $ :: 'Enum
        'KeyboardEventHost $ %{} 'CodeEntry (:doc "|External KeyboardEvent capability without trait inheritance; adapters normalize keys and modifiers into Calcit data.")
          :code $ quote
            deftrait KeyboardEventHost (:key 'String) (:code 'String) (:repeat? 'Bool) (:alt-key? 'Bool) (:ctrl-key? 'Bool) (:meta-key? 'Bool) (:shift-key? 'Bool)
              .prevent-default! $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.browser/KeyboardEventHost
                  :return 'Unit
          :examples $ [] (quote KeyboardEventHost)
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} (:alt-key? |altKey) (:ctrl-key? |ctrlKey) (:meta-key? |metaKey) (:prevent-default! |preventDefault) (:repeat? |repeat) (:shift-key? |shiftKey)
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'LocationHost $ %{} 'CodeEntry (:doc "|External browser Location capability. Navigation methods are explicit effects; URL fields are readable.")
          :code $ quote
            deftrait LocationHost (:href 'String) (:protocol 'String) (:host 'String) (:hostname 'String) (:port 'String) (:pathname 'String) (:search 'String) (:hash 'String)
              .assign! $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.browser/LocationHost 'String
                  :return 'Unit
              .replace! $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.browser/LocationHost 'String
                  :return 'Unit
              .reload! $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.browser/LocationHost
                  :return 'Unit
          :examples $ [] (quote LocationHost)
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} (:assign! |assign) (:reload! |reload) (:replace! |replace)
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'MediaQueryListHost $ %{} 'CodeEntry (:doc "|External matchMedia result with stable media and matches fields. Listener APIs remain adapter-specific.")
          :code $ quote
            deftrait MediaQueryListHost (:media 'String) (:matches? 'Bool)
          :examples $ [] (quote MediaQueryListHost)
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} (:matches? |matches)
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'MouseEventHost $ %{} 'CodeEntry (:doc "|External MouseEvent capability exposing coordinates, button, and modifier fields used by adapters.")
          :code $ quote
            deftrait MouseEventHost (:client-x 'Number) (:client-y 'Number) (:button 'Number) (:alt-key? 'Bool) (:ctrl-key? 'Bool) (:meta-key? 'Bool) (:shift-key? 'Bool)
              .prevent-default! $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.browser/MouseEventHost
                  :return 'Unit
          :examples $ [] (quote MouseEventHost)
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} (:alt-key? |altKey) (:client-x |clientX) (:client-y |clientY) (:ctrl-key? |ctrlKey) (:meta-key? |metaKey) (:prevent-default! |preventDefault) (:shift-key? |shiftKey)
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'PointerPosition $ %{} 'CodeEntry (:doc "|Normalized pointer coordinates and button index copied from a MouseEvent-like object.")
          :code $ quote
            defstruct PointerPosition (:client-x 'Number) (:client-y 'Number) (:button 'Number)
          :examples $ []
            quote $ &%{} PointerPosition :client-x 20 :client-y 30 :button 0
          :schema $ :: 'Enum
        'StorageHost $ %{} 'CodeEntry (:doc "|External Web Storage capability with nullish lookup and explicit String mutation methods.")
          :code $ quote
            deftrait StorageHost (:length 'Number)
              .get-item $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.browser/StorageHost 'String
                  :return $ :: 'JsNullish 'String
              .key-at $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.browser/StorageHost 'Number
                  :return $ :: 'JsNullish 'String
              .set-item! $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.browser/StorageHost 'String 'String
                  :return 'Unit
              .remove-item! $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.browser/StorageHost 'String
                  :return 'Unit
              .clear! $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.browser/StorageHost
                  :return 'Unit
          :examples $ [] (quote StorageHost)
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} (:clear! |clear) (:get-item |getItem) (:key-at |key) (:remove-item! |removeItem) (:set-item! |setItem)
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'Viewport $ %{} 'CodeEntry (:doc "|Normalized viewport dimensions and device pixel ratio copied from Window.")
          :code $ quote
            defstruct Viewport (:width 'Number) (:height 'Number) (:device-pixel-ratio 'Number)
          :examples $ []
            quote $ &%{} Viewport :width 1024 :height 768 :device-pixel-ratio 2
          :schema $ :: 'Enum
        'VisibilityState $ %{} 'CodeEntry (:doc "|Typed document.visibilityState values with an unknown String variant.")
          :code $ quote
            defenum VisibilityState (:visible) (:hidden) (:prerender) (:unknown 'String)
          :examples $ []
            quote $ %:: VisibilityState :visible
          :schema $ :: 'Enum
        'WindowHost $ %{} 'CodeEntry (:doc "||External browser Window capability restricted to stable viewport fields, matchMedia, and typed global event listeners.")
          :code $ quote
            deftrait WindowHost (:inner-width 'Number) (:inner-height 'Number) (:device-pixel-ratio 'Number)
              .match-media $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.browser/WindowHost 'String
                  :return 'js-ffi.browser/MediaQueryListHost
              .add-event-listener! $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.browser/WindowHost 'String
                    :: 'Fn $ {}
                      :args $ [] 'js-ffi.browser/EventHost
                      :return 'Unit
                  :return 'Unit
              .remove-event-listener! $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.browser/WindowHost 'String
                    :: 'Fn $ {}
                      :args $ [] 'js-ffi.browser/EventHost
                      :return 'Unit
                  :return 'Unit
          :examples $ [] (quote WindowHost)
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} (:add-event-listener! |addEventListener) (:device-pixel-ratio |devicePixelRatio) (:inner-height |innerHeight) (:inner-width |innerWidth) (:match-media |matchMedia) (:remove-event-listener! |removeEventListener)
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'add-event-listener! $ %{} 'CodeEntry (:doc "|Register a typed browser window event listener. The callback receives an EventHost and the wrapper returns Unit.")
          :code $ quote
            defn add-event-listener! (event-name callback)
              let
                  host-window $ unsafe-coerce js/window WindowHost
                host-window .add-event-listener! event-name callback
          :examples $ []
            quote $ add-event-listener! |visibilitychange
            quote $ add-event-listener! |beforeunload
              fn (event) nil
          :schema $ :: 'Fn
            {} (:return 'Unit)
              :args $ [] 'String
                :: 'Fn $ {} (:return 'Unit)
                  :args $ [] 'js-ffi.browser/EventHost
              :features $ #{} :js-ffi
        'append-child! $ %{} 'CodeEntry (:doc "|Appends one typed DOM host element to another and returns the child. This keeps DOM insertion inside the browser FFI boundary.")
          :code $ quote
            defn append-child! (parent child)
              unsafe-coerce (parent .append-child! child) DomElementHost
          :examples $ []
          :schema $ :: 'Fn
            {} (:return 'js-ffi.browser/DomElementHost)
              :args $ [] 'js-ffi.browser/DomElementHost 'js-ffi.browser/DomElementHost
              :features $ #{} :js-ffi
        'child-element-at $ %{} 'CodeEntry (:doc "|Return the indexed child element as Option, normalizing the host nullish result.")
          :code $ quote
            defn child-element-at (children idx)
              js-nullish->option $ children .item idx
          :examples $ []
          :schema $ :: 'Fn
            {}
              :args $ [] 'js-ffi.browser/DomChildrenHost 'Number
              :features $ #{} :js-ffi
              :return $ :: 'Option 'js-ffi.browser/DomElementHost
        'console-error! $ %{} 'CodeEntry (:doc "|Compatibility wrapper for shared/console-error!. It accepts one String and returns Unit.")
          :code $ quote
            defn console-error! (message) (shared/console-error! message)
          :examples $ []
            quote $ console-error! |failed
          :schema $ :: 'Fn
            {} (:return 'Unit)
              :args $ [] 'String
        'console-log! $ %{} 'CodeEntry (:doc "|Compatibility wrapper for shared/console-log!. It accepts one String and returns Unit instead of leaking host undefined.")
          :code $ quote
            defn console-log! (message) (shared/console-log! message)
          :examples $ []
            quote $ console-log! |ready
          :schema $ :: 'Fn
            {} (:return 'Unit)
              :args $ [] 'String
        'create-element $ %{} 'CodeEntry (:doc "|Create a DOM element through DocumentHost and return its typed host capability.")
          :code $ quote
            defn create-element (tag-name)
              let
                  host-document $ unsafe-coerce js/document DocumentHost
                host-document .create-element tag-name
          :examples $ []
          :schema $ :: 'Fn
            {} (:return 'js-ffi.browser/DomElementHost)
              :args $ [] 'String
              :features $ #{} :js-ffi
        'decode-document-ready-state $ %{} 'CodeEntry (:doc "|Decode document.readyState String to DocumentReadyState while preserving unknown values.")
          :code $ quote
            defn decode-document-ready-state (raw)
              case-default raw (%:: DocumentReadyState :unknown raw)
                |loading $ %:: DocumentReadyState :loading
                |interactive $ %:: DocumentReadyState :interactive
                |complete $ %:: DocumentReadyState :complete
          :examples $ []
            quote $ decode-document-ready-state |complete
            quote $ decode-document-ready-state |future-state
          :schema $ :: 'Fn
            {} (:return 'js-ffi.browser/DocumentReadyState)
              :args $ [] 'String
        'decode-visibility-state $ %{} 'CodeEntry (:doc "|Decode document.visibilityState String to VisibilityState while preserving unknown values.")
          :code $ quote
            defn decode-visibility-state (raw)
              case-default raw (%:: VisibilityState :unknown raw)
                |visible $ %:: VisibilityState :visible
                |hidden $ %:: VisibilityState :hidden
                |prerender $ %:: VisibilityState :prerender
          :examples $ []
            quote $ decode-visibility-state |hidden
          :schema $ :: 'Fn
            {} (:return 'js-ffi.browser/VisibilityState)
              :args $ [] 'String
        'document-available? $ %{} 'CodeEntry (:doc "|Return whether document is present. Use this guard before touching DOM objects so shared code can be checked in both Node.js and browsers. Example: (document-available?) => true")
          :code $ quote
            defn document-available? () $ exists? js/document
          :examples $ [] (quote "(document-available?)")
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn
            {} (:return 'Bool)
              :args $ []
              :features $ #{} :js-ffi
        'document-ready-state $ %{} 'CodeEntry (:doc "|Read and decode document.readyState through the typed DocumentHost contract.")
          :code $ quote
            defn document-ready-state () $ let
                host-document $ unsafe-coerce js/document DocumentHost
              decode-document-ready-state $ host-document :ready-state
          :examples $ []
            quote $ document-ready-state
          :schema $ :: 'Fn
            {} (:return 'js-ffi.browser/DocumentReadyState)
              :args $ []
              :features $ #{} :js-ffi
        'document-title $ %{} 'CodeEntry (:doc "|Read document.title through DocumentHost. Returns an empty String when document is unavailable.")
          :code $ quote
            defn document-title () $ if (document-available?)
              let
                  host-document $ unsafe-coerce js/document DocumentHost
                host-document :title
              , |
          :examples $ []
            quote $ document-title
          :schema $ :: 'Fn
            {} (:return 'String)
              :args $ []
              :features $ #{} :js-ffi
        'dom-element-host $ %{} 'CodeEntry (:doc "|Attach the declared static DomElementHost contract to a raw browser Element without runtime validation.")
          :code $ quote
            defn dom-element-host (element) (unsafe-coerce element 'DomElementHost)
          :examples $ []
          :schema $ :: 'Fn
            {} (:return 'js-ffi.browser/DomElementHost)
              :args $ [] 'JsObject
              :features $ #{} :js-ffi
        'element-dataset $ %{} 'CodeEntry (:doc "|Returns the DOM element dataset object through the browser host contract. Use with js-set/js-delete for data-* attributes.")
          :code $ quote
            defn element-dataset (element)
              unsafe-coerce (element :dataset) JsObject
          :examples $ []
          :schema $ :: 'Fn
            {} (:return 'JsObject)
              :args $ [] 'js-ffi.browser/DomElementHost
              :features $ #{} :js-ffi
        'element-snapshot $ %{} 'CodeEntry (:doc "|Copy a typed DOM element into ElementSnapshot, converting nullish textContent to Option<String>.")
          :code $ quote
            defn element-snapshot (element)
              &%{} ElementSnapshot :id (element :id) :class-name (element :class-name) :text-content
                js-nullish->option $ element :text-content
                , :child-count $ element :child-element-count
          :examples $ [] (quote ElementSnapshot)
          :schema $ :: 'Fn
            {} (:return 'js-ffi.browser/ElementSnapshot)
              :args $ [] 'js-ffi.browser/DomElementHost
              :features $ #{} :js-ffi
        'element-style $ %{} 'CodeEntry (:doc "|Returns the DOM element style declaration through the browser host contract. Use with aset for normalized CSS property names.")
          :code $ quote
            defn element-style (element)
              unsafe-coerce (element :style) JsObject
          :examples $ []
          :schema $ :: 'Fn
            {} (:return 'JsObject)
              :args $ [] 'js-ffi.browser/DomElementHost
              :features $ #{} :js-ffi
        'local-storage-available? $ %{} 'CodeEntry (:doc "|Return whether localStorage is available. Browsers may deny storage in privacy or sandboxed modes, so callers should branch on this Boolean. Example: (local-storage-available?) => true")
          :code $ quote
            defn local-storage-available? () $ exists? js/localStorage
          :examples $ [] (quote "(local-storage-available?)")
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn
            {} (:return 'Bool)
              :args $ []
              :features $ #{} :js-ffi
        'location-href $ %{} 'CodeEntry (:doc "|Read location.href through the typed LocationHost contract.")
          :code $ quote
            defn location-href () $ let
                host-location $ unsafe-coerce js/location LocationHost
              host-location :href
          :examples $ []
            quote $ location-href
          :schema $ :: 'Fn
            {} (:return 'String)
              :args $ []
              :features $ #{} :js-ffi
        'probe $ %{} 'CodeEntry (:doc "|Run the browser capability smoke probe and return typed BrowserProbe data.")
          :code $ quote
            defn probe () $ &%{} BrowserProbe :runtime (runtime) :document? (document-available?) :storage (storage-roundtrip!) :viewport (viewport)
          :examples $ []
            quote $ probe
          :schema $ :: 'Fn
            {} (:return 'js-ffi.browser/BrowserProbe)
              :args $ []
        'query-selector $ %{} 'CodeEntry (:doc "|Query document for a selector and normalize a missing element into Option<DomElementHost>.")
          :code $ quote
            defn query-selector (selector)
              let
                  host-document $ unsafe-coerce js/document DocumentHost
                js-nullish->option $ host-document .query-selector selector
          :examples $ []
            quote $ query-selector |.app
            quote $ option:unwrap-or (query-selector |#main) nil
          :schema $ :: 'Fn
            {}
              :args $ [] 'String
              :features $ #{} :js-ffi
              :return $ :: 'Option 'js-ffi.browser/DomElementHost
        'random $ %{} 'CodeEntry (:doc "|Return a browser-compatible random number in the range 0 inclusive to 1 exclusive. The concrete return type is Number. Example: (random) => 0.42")
          :code $ quote
            defn random () $ unsafe-coerce (js/Math.random) Number
          :examples $ [] (quote "(random)")
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn
            {} (:return 'Number)
              :args $ []
              :features $ #{} :js-ffi
        'remove-event-listener! $ %{} 'CodeEntry (:doc "|Remove a previously registered typed browser window listener.")
          :code $ quote
            defn remove-event-listener! (event-name callback)
              let
                  host-window $ unsafe-coerce js/window WindowHost
                host-window .remove-event-listener! event-name callback
                , &unit
          :examples $ []
          :schema $ :: 'Fn
            {} (:return 'Unit)
              :args $ [] 'String
                :: 'Fn $ {} (:return 'Unit)
                  :args $ [] 'js-ffi.browser/EventHost
              :features $ #{} :js-ffi
        'runtime $ %{} 'CodeEntry (:doc "|Return the normalized Runtime browser enum variant.")
          :code $ quote
            defn runtime () $ %:: shared/Runtime :browser
          :examples $ []
            quote $ runtime
          :schema $ :: 'Fn
            {} (:return 'js-ffi.shared/Runtime)
              :args $ []
        'runtime-name $ %{} 'CodeEntry (:doc "|Return the literal runtime identifier |browser. This is useful for environment contracts and keeps callers independent from host-specific globals. Example: (runtime-name) => |browser")
          :code $ quote
            defn runtime-name () |browser
          :examples $ [] (quote "(runtime-name)")
          :schema $ :: 'Fn
            {} (:return 'String)
              :args $ []
        'set-before-unload! $ %{} 'CodeEntry (:doc "|Install a typed browser beforeunload callback.")
          :code $ quote
            defn set-before-unload! (callback)
              let
                  host-window $ unsafe-coerce js/window JsObject
                aset host-window |onbeforeunload callback
                , &unit
          :examples $ []
          :schema $ :: 'Fn
            {} (:return 'Unit)
              :args $ []
                :: 'Fn $ {} (:return 'Unit)
                  :args $ [] 'js-ffi.browser/EventHost
              :features $ #{} :js-ffi
        'set-interval! $ %{} 'CodeEntry (:doc "|Schedule a repeated browser callback and return the numeric timer identifier. The callback receives no arguments and returns Unit.")
          :code $ quote
            defn set-interval! (callback delay)
              unsafe-coerce (js/setInterval callback delay) Number
          :examples $ []
            quote $ set-interval!
              fn () $ console-log! |heartbeat
              , 60000
          :schema $ :: 'Fn
            {} (:return 'Number)
              :args $ []
                :: 'Fn $ {} (:return 'Unit)
                  :args $ []
                , 'Number
              :features $ #{} :js-ffi
        'set-timeout! $ %{} 'CodeEntry (:doc "|Schedule a Unit callback and return the browser numeric timer id. Node timer handles intentionally use a separate contract.")
          :code $ quote
            defn set-timeout! (callback delay)
              unsafe-coerce (js/setTimeout callback delay) Number
          :examples $ []
            quote $ set-timeout!
              fn () nil
              , 10
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn
            {} (:return 'Number)
              :args $ []
                :: 'Fn $ {} (:return 'Unit)
                  :args $ []
                , 'Number
              :features $ #{} :js-ffi
        'storage-get $ %{} 'CodeEntry (:doc "|Read one localStorage key as Option<String>; missing and JavaScript nullish values become none. Host exceptions remain an adapter concern.")
          :code $ quote
            defn storage-get (key)
              let
                  storage $ unsafe-coerce js/localStorage StorageHost
                js-nullish->option $ storage .get-item key
          :examples $ []
            quote $ storage-get |theme
          :schema $ :: 'Fn
            {}
              :args $ [] 'String
              :features $ #{} :js-ffi
              :return $ :: 'Option 'String
        'storage-get-or $ %{} 'CodeEntry (:doc "|Read localStorage as Option<String> internally and return the supplied fallback for a missing key.")
          :code $ quote
            defn storage-get-or (key fallback)
              option:unwrap-or (storage-get key) fallback
          :examples $ []
            quote $ storage-get-or |theme |light
          :schema $ :: 'Fn
            {} (:return 'String)
              :args $ [] 'String 'String
        'storage-remove! $ %{} 'CodeEntry (:doc "|Remove a localStorage key through StorageHost and return Unit.")
          :code $ quote
            defn storage-remove! (key)
              when (local-storage-available?)
                let
                    storage $ unsafe-coerce js/localStorage StorageHost
                  storage .remove-item! key
              , &unit
          :examples $ []
            quote $ storage-remove! |js-ffi-smoke
          :schema $ :: 'Fn
            {} (:return 'Unit)
              :args $ [] 'String
              :features $ #{} :js-ffi
        'storage-roundtrip! $ %{} 'CodeEntry (:doc "|Exercise localStorage with a deterministic String result for smoke tests. It writes |ok, reads it back, and returns |unavailable when storage is missing. Example: (storage-roundtrip!) => |ok")
          :code $ quote
            defn storage-roundtrip! () $ if (local-storage-available?)
              do (storage-set! |js-ffi-smoke |ok) (storage-get-or |js-ffi-smoke |unavailable)
              , |unavailable
          :examples $ [] (quote "(storage-roundtrip!)")
          :schema $ :: 'Fn
            {} (:return 'String)
              :args $ []
              :features $ #{} :js-ffi
        'storage-set! $ %{} 'CodeEntry (:doc "|Write a String key/value pair through StorageHost and normalize the host return to Unit.")
          :code $ quote
            defn storage-set! (key value)
              when (local-storage-available?)
                let
                    storage $ unsafe-coerce js/localStorage StorageHost
                  storage .set-item! key value
              , &unit
          :examples $ []
            quote $ storage-set! |theme |dark
          :schema $ :: 'Fn
            {} (:return 'Unit)
              :args $ [] 'String 'String
              :features $ #{} :js-ffi
        'viewport $ %{} 'CodeEntry (:doc "|Read Window viewport fields once and return normalized Viewport data.")
          :code $ quote
            defn viewport () $ let
                host-window $ unsafe-coerce js/window WindowHost
              &%{} Viewport :width (host-window :inner-width) :height (host-window :inner-height) :device-pixel-ratio $ host-window :device-pixel-ratio
          :examples $ []
            quote $ viewport
          :schema $ :: 'Fn
            {} (:return 'js-ffi.browser/Viewport)
              :args $ []
              :features $ #{} :js-ffi
        'viewport-height $ %{} 'CodeEntry (:doc "|Return the height field from normalized Viewport data.")
          :code $ quote
            defn viewport-height () $ :height (viewport)
          :examples $ []
            quote $ viewport-height
          :schema $ :: 'Fn
            {} (:return 'Number)
              :args $ []
        'viewport-width $ %{} 'CodeEntry (:doc "|Return the width field from normalized Viewport data.")
          :code $ quote
            defn viewport-width () $ :width (viewport)
          :examples $ []
            quote $ viewport-width
          :schema $ :: 'Fn
            {} (:return 'Number)
              :args $ []
        'visibility-state $ %{} 'CodeEntry (:doc "|Read and decode document.visibilityState through the typed DocumentHost contract.")
          :code $ quote
            defn visibility-state () $ let
                host-document $ unsafe-coerce js/document DocumentHost
              decode-visibility-state $ host-document :visibility-state
          :examples $ []
            quote $ visibility-state
          :schema $ :: 'Fn
            {} (:return 'js-ffi.browser/VisibilityState)
              :args $ []
              :features $ #{} :js-ffi
      :ns $ %{} 'NsEntry (:doc "|Typed browser JavaScript FFI with normalized Struct/Enum results and explicit external-object contracts for Window, Document, Location, Storage, DOM elements, and events.")
        :code $ quote
          ns js-ffi.browser $ :require (js-ffi.shared :as shared)
    'js-ffi.browser-test $ %{} 'FileEntry
      :defs $ {}
        'main! $ %{} 'CodeEntry (:doc "|Run the typed browser smoke probe and verify its Runtime enum.")
          :code $ quote
            defn main! () $ let
                result $ browser/probe
                element $ browser/create-element |div
                on-resize $ fn (event) &unit
              assert-type result js-ffi.browser/BrowserProbe
              assert-type element js-ffi.browser/DomElementHost
              browser/add-event-listener! |resize on-resize
              browser/remove-event-listener! |resize on-resize
              browser/set-before-unload! $ fn (event) &unit
              shared/queue-microtask! $ fn () (shared/console-log! |js-ffi-browser-microtask-passed)
              shared/console-log! |js-ffi-browser-smoke
              if
                contract/valid-runtime? (%:: shared/Runtime :browser) (:runtime result)
                shared/console-log! |js-ffi-browser-smoke-passed
                shared/console-error! |js-ffi-browser-smoke-failed
              , &unit
          :examples $ []
            quote $ main!
          :schema $ :: 'Fn
            {} (:return 'Unit)
              :args $ []
        'reload! $ %{} 'CodeEntry (:doc "|No-op browser reload hook returning Unit.")
          :code $ quote
            defn reload! () &unit
          :examples $ []
            quote $ reload!
          :schema $ :: 'Fn
            {} (:return 'Unit)
              :args $ []
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns js-ffi.browser-test $ :require (js-ffi.browser :as browser) (js-ffi.contract :as contract) (js-ffi.shared :as shared)
    'js-ffi.contract $ %{} 'FileEntry
      :defs $ {}
        'expect-bool $ %{} 'CodeEntry (:doc "|Decode an opaque JavaScript value as Bool after a runtime kind check. Null and undefined are reported as nullish; other mismatches raise a stable JS FFI contract violation.")
          :code $ quote
            defn expect-bool (label value)
              let
                  kind $ if (js-nullish? value) |nullish (js/typeof value)
                if (= |boolean kind) (unsafe-coerce value Bool)
                  raise $ str "|JS FFI contract violation: " label "| expected Bool, got " kind
          :examples $ []
          :schema $ :: 'Fn
            {} (:return 'Bool)
              :args $ [] 'String (:: 'JsNullish 'JsObject)
              :features $ #{} :js-ffi
        'expect-function $ %{} 'CodeEntry (:doc "|Validate that an opaque JavaScript value is a non-null JavaScript function and return its opaque host identity. Use a small typed adapter for its call schema and receiver contract.")
          :code $ quote
            defn expect-function (label value)
              let
                  kind $ if (js-nullish? value) |nullish (js/typeof value)
                if (= |function kind) (unsafe-coerce value JsObject)
                  raise $ str "|JS FFI contract violation: " label "| expected Function, got " kind
          :examples $ []
          :schema $ :: 'Fn
            {} (:return 'JsObject)
              :args $ [] 'String (:: 'JsNullish 'JsObject)
              :features $ #{} :js-ffi
        'expect-number $ %{} 'CodeEntry (:doc "|Decode an opaque JavaScript value as Number after a runtime kind check. Null and undefined are reported as nullish; other mismatches raise a stable JS FFI contract violation.")
          :code $ quote
            defn expect-number (label value)
              let
                  kind $ if (js-nullish? value) |nullish (js/typeof value)
                if (= |number kind) (unsafe-coerce value Number)
                  raise $ str "|JS FFI contract violation: " label "| expected Number, got " kind
          :examples $ []
          :schema $ :: 'Fn
            {} (:return 'Number)
              :args $ [] 'String (:: 'JsNullish 'JsObject)
              :features $ #{} :js-ffi
        'expect-object $ %{} 'CodeEntry (:doc "|Validate that an opaque JavaScript value is a non-null object and return it as JsObject. This proves only the shallow host kind; decode or check members before exposing concrete data.")
          :code $ quote
            defn expect-object (label value)
              let
                  kind $ if (js-nullish? value) |nullish (js/typeof value)
                if (= |object kind) (unsafe-coerce value JsObject)
                  raise $ str "|JS FFI contract violation: " label "| expected Object, got " kind
          :examples $ []
          :schema $ :: 'Fn
            {} (:return 'JsObject)
              :args $ [] 'String (:: 'JsNullish 'JsObject)
              :features $ #{} :js-ffi
        'expect-string $ %{} 'CodeEntry (:doc "|Decode an opaque JavaScript value as String after a runtime kind check. Null and undefined are reported as nullish; other mismatches raise a stable JS FFI contract violation.")
          :code $ quote
            defn expect-string (label value)
              let
                  kind $ if (js-nullish? value) |nullish (js/typeof value)
                if (= |string kind) (unsafe-coerce value String)
                  raise $ str "|JS FFI contract violation: " label "| expected String, got " kind
          :examples $ []
          :schema $ :: 'Fn
            {} (:return 'String)
              :args $ [] 'String (:: 'JsNullish 'JsObject)
              :features $ #{} :js-ffi
        'object-field $ %{} 'CodeEntry (:doc "|Read one named field from an opaque JavaScript object after checking the receiver. The result remains JsNullish<JsObject>; pass it through an expect primitive guard or explicitly normalize absence before returning concrete data.")
          :code $ quote
            defn object-field (label object key)
              aget (expect-object label object) key
          :examples $ []
          :schema $ :: 'Fn
            {}
              :args $ [] 'String (:: 'JsNullish 'JsObject) 'String
              :features $ #{} :js-ffi
              :return $ :: 'JsNullish 'JsObject
        'valid-runtime? $ %{} 'CodeEntry (:doc "|Compare two normalized Runtime values without relying on open String identifiers.")
          :code $ quote
            defn valid-runtime? (expected actual) (= expected actual)
          :examples $ []
            quote $ valid-runtime? (shared/Runtime :node) (shared/Runtime :node)
          :schema $ :: 'Fn
            {} (:return 'Bool)
              :args $ [] 'js-ffi.shared/Runtime 'js-ffi.shared/Runtime
      :ns $ %{} 'NsEntry (:doc "|Environment-independent typed contracts shared by Node.js and browser smoke tests.")
        :code $ quote
          ns js-ffi.contract $ :require (js-ffi.shared :as shared)
    'js-ffi.node $ %{} 'FileEntry
      :defs $ {}
        'NodeProbe $ %{} 'CodeEntry (:doc "|Typed Node smoke result replacing the former heterogeneous Map<Dynamic>.")
          :code $ quote
            defstruct NodeProbe (:runtime 'js-ffi.shared/Runtime) (:cwd 'String) (:argv-count 'Number)
          :examples $ []
            quote $ &%{} NodeProbe :runtime (%:: shared/Runtime :node) :cwd |/tmp :argv-count 2
          :schema $ :: 'Enum
        'argv-count $ %{} 'CodeEntry (:doc "|Return process.argv.length as Number. This deliberately narrows the host array at the boundary. Example: (argv-count) => 3")
          :code $ quote
            defn argv-count () $ let
                argv $ unsafe-coerce js/process.argv JsObject
              contract/expect-number |process.argv.length $ .-length argv
          :examples $ [] (quote "(argv-count)")
          :ffi $ {} (:backend :js) (:target :node)
          :schema $ :: 'Fn
            {} (:return 'Number)
              :args $ []
              :features $ #{} :js-ffi
        'cwd $ %{} 'CodeEntry (:doc "|Return process.cwd() as String. This is a Node-only API and is emitted through the node entry. Example: (cwd) => |/workspace/project")
          :code $ quote
            defn cwd () $ contract/expect-string |process.cwd (js/process.cwd)
          :examples $ [] (quote "(cwd)")
          :ffi $ {} (:backend :js) (:target :node)
          :schema $ :: 'Fn
            {} (:return 'String)
              :args $ []
              :features $ #{} :js-ffi
        'env-or $ %{} 'CodeEntry (:doc "|Read a process.env value with a typed String fallback. Example: (env-or |NODE_ENV |development) => |development")
          :code $ quote
            defn env-or (key fallback)
              let
                  env $ unsafe-coerce js/process.env JsObject
                  raw $ aget env key
                if (js-present? raw)
                  contract/expect-string (str |process.env[ key |]) raw
                  , fallback
          :examples $ [] (quote "(env-or |NODE_ENV |development)")
          :ffi $ {} (:backend :js) (:target :node)
          :schema $ :: 'Fn
            {} (:return 'String)
              :args $ [] 'String 'String
              :features $ #{} :js-ffi
        'exit! $ %{} 'CodeEntry (:doc "|Terminate the Node.js process with a numeric exit code. This effectful escape hatch has the Unit contract because it has no business result. Example: (exit! 1)")
          :code $ quote
            defn exit! (code)
              do (js/process.exit code) &unit
          :examples $ [] (quote "(exit! 1)")
          :ffi $ {} (:backend :js) (:target :node)
          :schema $ :: 'Fn
            {} (:return 'Unit)
              :args $ [] 'Number
              :features $ #{} :js-ffi
        'file-exists? $ %{} 'CodeEntry (:doc "|Return whether a local filesystem path exists as Bool. The fs module is kept behind the Node namespace. Example: (file-exists? |package.json) => true")
          :code $ quote
            defn file-exists? (file-path) (fs/existsSync file-path)
          :examples $ [] (quote "(file-exists? |package.json)")
          :ffi $ {} (:backend :js) (:target :node)
          :schema $ :: 'Fn
            {} (:return 'Bool)
              :args $ [] 'String
              :features $ #{} :js-ffi
        'path-join $ %{} 'CodeEntry (:doc "|Join two path segments using node:path and return String. Example: (path-join |src |index.js) => |src/index.js")
          :code $ quote
            defn path-join (base child) (path/join base child)
          :examples $ [] (quote "(path-join |src |index.js)")
          :ffi $ {} (:backend :js) (:target :node)
          :schema $ :: 'Fn
            {} (:return 'String)
              :args $ [] 'String 'String
              :features $ #{} :js-ffi
        'probe $ %{} 'CodeEntry (:doc "|Run the Node capability smoke probe and return typed NodeProbe data.")
          :code $ quote
            defn probe () $ &%{} NodeProbe :runtime (runtime) :cwd (cwd) :argv-count (argv-count)
          :examples $ []
            quote $ probe
          :schema $ :: 'Fn
            {} (:return 'js-ffi.node/NodeProbe)
              :args $ []
        'runtime $ %{} 'CodeEntry (:doc "|Return the normalized Runtime node enum variant.")
          :code $ quote
            defn runtime () $ %:: shared/Runtime :node
          :examples $ []
            quote $ runtime
          :schema $ :: 'Fn
            {} (:return 'js-ffi.shared/Runtime)
              :args $ []
        'runtime-name $ %{} 'CodeEntry (:doc "|Return the literal runtime identifier |node. Example: (runtime-name) => |node")
          :code $ quote
            defn runtime-name () |node
          :examples $ [] (quote "(runtime-name)")
          :schema $ :: 'Fn
            {} (:return 'String)
              :args $ []
      :ns $ %{} 'NsEntry (:doc "|Typed Node.js JavaScript FFI. Node-only modules remain isolated while runtime identity and cross-runtime host contracts come from js-ffi.shared.")
        :code $ quote
          ns js-ffi.node $ :require (|node:fs :as fs) (|node:path :as path) (js-ffi.contract :as contract) (js-ffi.shared :as shared)
    'js-ffi.node-test $ %{} 'FileEntry
      :defs $ {}
        'main! $ %{} 'CodeEntry (:doc "|Run the typed Node smoke probe and verify its Runtime enum.")
          :code $ quote
            defn main! () $ let
                result $ node/probe
              assert-type result js-ffi.node/NodeProbe
              shared/console-log! |js-ffi-node-smoke
              if
                contract/valid-runtime? (%:: shared/Runtime :node) (:runtime result)
                shared/console-log! |js-ffi-node-smoke-passed
                do (shared/console-error! |js-ffi-node-smoke-failed) (node/exit! 1)
              , &unit
          :examples $ []
            quote $ main!
          :schema $ :: 'Fn
            {} (:return 'Unit)
              :args $ []
        'reload! $ %{} 'CodeEntry (:doc "|No-op Node reload hook returning Unit.")
          :code $ quote
            defn reload! () &unit
          :examples $ []
            quote $ reload!
          :schema $ :: 'Fn
            {} (:return 'Unit)
              :args $ []
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns js-ffi.node-test $ :require (js-ffi.node :as node) (js-ffi.contract :as contract) (js-ffi.shared :as shared)
    'js-ffi.shared $ %{} 'FileEntry
      :defs $ {}
        'AbortControllerHost $ %{} 'CodeEntry (:doc "|External AbortController capability with a typed signal and parameterless abort wrapper contract.")
          :code $ quote
            deftrait AbortControllerHost (:signal 'js-ffi.shared/AbortSignalHost)
              .abort! $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.shared/AbortControllerHost
                  :return 'Unit
          :examples $ [] (quote AbortControllerHost)
          :ffi $ {} (:backend :js) (:kind :external-object)
            :names $ {} (:abort! |abort)
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'AbortSignalHost $ %{} 'CodeEntry (:doc "|External AbortSignal capability. Reason stays an opaque nullable host object because JavaScript permits arbitrary values.")
          :code $ quote
            deftrait AbortSignalHost (:aborted 'Bool)
              :reason $ :: 'JsNullish 'JsObject
              .throw-if-aborted! $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.shared/AbortSignalHost
                  :return 'Unit
          :examples $ [] (quote AbortSignalHost)
          :ffi $ {} (:backend :js) (:kind :external-object)
            :names $ {} (:throw-if-aborted! |throwIfAborted)
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'ConsoleHost $ %{} 'CodeEntry (:doc "|External console capability shared by browser and Node. Methods intentionally accept one String to avoid modeling host varargs.")
          :code $ quote
            deftrait ConsoleHost
              .log! $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.shared/ConsoleHost 'String
                  :return 'Unit
              .warn! $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.shared/ConsoleHost 'String
                  :return 'Unit
              .error! $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.shared/ConsoleHost 'String
                  :return 'Unit
          :examples $ [] (quote ConsoleHost)
          :ffi $ {} (:backend :js) (:kind :external-object)
            :names $ {} (:error! |error) (:log! |log) (:warn! |warn)
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'DateHost $ %{} 'CodeEntry (:doc "|External JavaScript Date capability exposing only stable read methods needed for normalization.")
          :code $ quote
            deftrait DateHost
              .get-time $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.shared/DateHost
                  :return 'Number
              .to-iso-string $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.shared/DateHost
                  :return 'String
          :examples $ [] (quote DateHost)
          :ffi $ {} (:backend :js) (:kind :external-object)
            :names $ {} (:get-time |getTime) (:to-iso-string |toISOString)
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'DateSnapshot $ %{} 'CodeEntry (:doc "|Immutable normalized view of a host Date with epoch milliseconds and ISO text.")
          :code $ quote
            defstruct DateSnapshot (:timestamp 'Number) (:iso 'String)
          :examples $ []
            quote $ &%{} DateSnapshot :timestamp 0 :iso |1970-01-01T00:00:00.000Z
          :schema $ :: 'Enum
        'HeadersHost $ %{} 'CodeEntry (:doc "|External Headers capability with typed String keys and values; iteration is deliberately normalized elsewhere.")
          :code $ quote
            deftrait HeadersHost
              .get $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.shared/HeadersHost 'String
                  :return $ :: 'JsNullish 'String
              .has? $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.shared/HeadersHost 'String
                  :return 'Bool
              .set! $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.shared/HeadersHost 'String 'String
                  :return 'Unit
              .append! $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.shared/HeadersHost 'String 'String
                  :return 'Unit
              .delete! $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.shared/HeadersHost 'String
                  :return 'Unit
          :examples $ [] (quote HeadersHost)
          :ffi $ {} (:backend :js) (:kind :external-object)
            :names $ {} (:append! |append) (:delete! |delete) (:get |get) (:has? |has) (:set! |set)
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'HttpMethod $ %{} 'CodeEntry (:doc "|Closed HTTP method set used by typed request options; custom methods remain an explicit adapter concern.")
          :code $ quote
            defenum HttpMethod (:get) (:post) (:put) (:patch) (:delete) (:head) (:options)
          :examples $ []
            quote $ %:: HttpMethod :get
            quote $ %:: HttpMethod :post
          :schema $ :: 'Enum
        'JsError $ %{} 'CodeEntry (:doc "|Normalized JavaScript exception data. Stack is optional because hosts may omit it.")
          :code $ quote
            defstruct JsError (:kind 'js-ffi.shared/JsErrorKind) (:name 'String) (:message 'String)
              :stack $ :: 'Option 'String
          :examples $ []
            quote $ &%{} JsError :kind (%:: JsErrorKind :type-error) :name |TypeError :message |invalid
          :schema $ :: 'Enum
        'JsErrorKind $ %{} 'CodeEntry (:doc "|Stable error categories shared by browser and Node adapters; unknown host names retain their String payload.")
          :code $ quote
            defenum JsErrorKind (:type-error) (:range-error) (:permission) (:quota) (:network) (:abort) (:unknown 'String)
          :examples $ []
            quote $ %:: JsErrorKind :network
            quote $ %:: JsErrorKind :unknown |DataCloneError
          :schema $ :: 'Enum
        'RequestOptions $ %{} 'CodeEntry (:doc "|Calcit-owned request configuration converted to a JavaScript object only inside an adapter.")
          :code $ quote
            defstruct RequestOptions (:method 'js-ffi.shared/HttpMethod)
              :headers $ :: 'Map 'String 'String
              :body $ :: 'Option 'String
          :examples $ []
            quote $ &%{} RequestOptions :method (%:: HttpMethod :get) :headers ({})
          :schema $ :: 'Enum
        'ResponseHost $ %{} 'CodeEntry (:doc "|External Response metadata capability. Async body readers are omitted until adapters normalize their Promise results.")
          :code $ quote
            deftrait ResponseHost (:status 'Number) (:status-text 'String) (:ok? 'Bool) (:url 'String) (:redirected? 'Bool) (:headers 'js-ffi.shared/HeadersHost) (:body-used? 'Bool)
          :examples $ [] (quote ResponseHost)
          :ffi $ {} (:backend :js) (:kind :external-object)
            :names $ {} (:body-used? |bodyUsed) (:ok? |ok) (:redirected? |redirected) (:status-text |statusText)
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'ResponseSnapshot $ %{} 'CodeEntry (:doc "|Normalized response metadata after a host Response has been inspected and its headers copied.")
          :code $ quote
            defstruct ResponseSnapshot (:status 'Number) (:status-text 'String) (:ok? 'Bool) (:url 'String) (:redirected? 'Bool)
              :headers $ :: 'Map 'String 'String
          :examples $ []
            quote $ &%{} ResponseSnapshot :status 200 :status-text |OK :ok? true :url |https://example.test :redirected? false :headers ({})
          :schema $ :: 'Enum
        'Runtime $ %{} 'CodeEntry (:doc "|Runtime identity normalized as a Calcit enum instead of an open String.")
          :code $ quote
            defenum Runtime (:browser) (:node) (:unknown 'String)
          :examples $ []
            quote $ %:: Runtime :browser
            quote $ %:: Runtime :unknown |worker
          :schema $ :: 'Enum
        'UrlHost $ %{} 'CodeEntry (:doc "|External URL-like capability shared by URL and browser Location objects. Fields are read-only in this contract.")
          :code $ quote
            deftrait UrlHost (:href 'String) (:protocol 'String) (:host 'String) (:hostname 'String) (:port 'String) (:pathname 'String) (:search 'String) (:hash 'String)
              .to-string $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.shared/UrlHost
                  :return 'String
          :examples $ [] (quote UrlHost)
          :ffi $ {} (:backend :js) (:kind :external-object)
            :names $ {} (:to-string |toString)
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'UrlSearchParamsHost $ %{} 'CodeEntry (:doc "|External URLSearchParams capability. Nullable lookup remains JsNullish<String> until an adapter converts it to Option.")
          :code $ quote
            deftrait UrlSearchParamsHost (:size 'Number)
              .get $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.shared/UrlSearchParamsHost 'String
                  :return $ :: 'JsNullish 'String
              .has? $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.shared/UrlSearchParamsHost 'String
                  :return 'Bool
              .set! $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.shared/UrlSearchParamsHost 'String 'String
                  :return 'Unit
              .delete! $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.shared/UrlSearchParamsHost 'String
                  :return 'Unit
              .to-string $ :: 'Fn
                {}
                  :args $ [] 'js-ffi.shared/UrlSearchParamsHost
                  :return 'String
          :examples $ [] (quote UrlSearchParamsHost)
          :ffi $ {} (:backend :js) (:kind :external-object)
            :names $ {} (:delete! |delete) (:get |get) (:has? |has) (:set! |set) (:to-string |toString)
          :schema $ :: 'Trait
          :tags $ #{} :ffi :js-host
        'UrlSnapshot $ %{} 'CodeEntry (:doc "|Immutable URL fields copied out of a host URL or Location object.")
          :code $ quote
            defstruct UrlSnapshot (:href 'String) (:protocol 'String) (:host 'String) (:hostname 'String) (:port 'String) (:pathname 'String) (:search 'String) (:hash 'String)
          :examples $ []
            quote $ &%{} UrlSnapshot :href |https://example.test/a :protocol |https: :host |example.test :hostname |example.test :port | :pathname |/a :search | :hash |
          :schema $ :: 'Enum
        'console-error! $ %{} 'CodeEntry (:doc "|Write one error String to the host console and return Unit in browser or Node.")
          :code $ quote
            defn console-error! (message)
              let
                  host-console $ unsafe-coerce js/console ConsoleHost
                host-console .error! message
                , &unit
          :examples $ []
            quote $ console-error! |failed
          :schema $ :: 'Fn
            {} (:return 'Unit)
              :args $ [] 'String
              :features $ #{} :js-ffi
        'console-log! $ %{} 'CodeEntry (:doc "|Write one String to the host console and normalize the host undefined return to Unit.")
          :code $ quote
            defn console-log! (message)
              let
                  host-console $ unsafe-coerce js/console ConsoleHost
                host-console .log! message
                , &unit
          :examples $ []
            quote $ console-log! |ready
          :schema $ :: 'Fn
            {} (:return 'Unit)
              :args $ [] 'String
              :features $ #{} :js-ffi
        'console-warn! $ %{} 'CodeEntry (:doc "|Write one warning String to the host console and return Unit in browser or Node.")
          :code $ quote
            defn console-warn! (message)
              let
                  host-console $ unsafe-coerce js/console ConsoleHost
                host-console .warn! message
                , &unit
          :examples $ []
            quote $ console-warn! |deprecated
          :schema $ :: 'Fn
            {} (:return 'Unit)
              :args $ [] 'String
              :features $ #{} :js-ffi
        'date-now-snapshot $ %{} 'CodeEntry (:doc "|Create a host Date and immediately normalize it to DateSnapshot in browser or Node.")
          :code $ quote
            defn date-now-snapshot () $ date-snapshot
              unsafe-coerce (new js/Date) DateHost
          :examples $ []
            quote $ date-now-snapshot
          :schema $ :: 'Fn
            {} (:return 'js-ffi.shared/DateSnapshot)
              :args $ []
              :features $ #{} :js-ffi
        'date-snapshot $ %{} 'CodeEntry (:doc "|Copy a typed host Date into Calcit-owned DateSnapshot data.")
          :code $ quote
            defn date-snapshot (date)
              &%{} DateSnapshot :timestamp (date .get-time) :iso $ date .to-iso-string
          :examples $ []
            quote $ date-now-snapshot
          :schema $ :: 'Fn
            {} (:return 'js-ffi.shared/DateSnapshot)
              :args $ [] 'js-ffi.shared/DateHost
              :features $ #{} :js-ffi
        'http-method-label $ %{} 'CodeEntry (:doc "|Convert HttpMethod to the uppercase token expected by JavaScript request APIs.")
          :code $ quote
            defn http-method-label (method)
              match method
                (:get) |GET
                (:post) |POST
                (:put) |PUT
                (:patch) |PATCH
                (:delete) |DELETE
                (:head) |HEAD
                (:options) |OPTIONS
          :examples $ []
            quote $ http-method-label (HttpMethod :post)
          :schema $ :: 'Fn
            {} (:return 'String)
              :args $ [] 'js-ffi.shared/HttpMethod
        'queue-microtask! $ %{} 'CodeEntry (:doc "|Queue a Unit callback in the JavaScript microtask queue.")
          :code $ quote
            defn queue-microtask! (callback)
              do (js/queueMicrotask callback) &unit
          :examples $ []
          :schema $ :: 'Fn
            {} (:return 'Unit)
              :args $ []
                :: 'Fn $ {} (:return 'Unit)
                  :args $ []
              :features $ #{} :js-ffi
        'runtime-label $ %{} 'CodeEntry (:doc "|Convert Runtime to the stable host label used in logs and compatibility checks.")
          :code $ quote
            defn runtime-label (runtime)
              match runtime
                (:browser) |browser
                (:node) |node
                (:unknown label) label
          :examples $ []
            quote $ runtime-label (Runtime :browser)
          :schema $ :: 'Fn
            {} (:return 'String)
              :args $ [] 'js-ffi.shared/Runtime
        'url-snapshot $ %{} 'CodeEntry (:doc "|Copy a URL-like host object into immutable UrlSnapshot data without retaining host identity.")
          :code $ quote
            defn url-snapshot (url)
              &%{} UrlSnapshot :href (url :href) :protocol (url :protocol) :host (url :host) :hostname (url :hostname) :port (url :port) :pathname (url :pathname) :search (url :search) :hash $ url :hash
          :examples $ [] (quote UrlSnapshot)
          :schema $ :: 'Fn
            {} (:return 'js-ffi.shared/UrlSnapshot)
              :args $ [] 'js-ffi.shared/UrlHost
              :features $ #{} :js-ffi
      :ns $ %{} 'NsEntry (:doc "|Shared JavaScript FFI data types, normalized snapshots, and explicit external-object capabilities that work in browser and Node targets.")
        :code $ quote (ns js-ffi.shared)
