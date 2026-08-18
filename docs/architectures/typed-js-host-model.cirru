{}
  :schema-version 1
  :feature 'typed-js-host-model
  :doc "|Shared-first nominal data and explicit external-object capabilities for JavaScript FFI. Data-definition CodeEntry schemas stay Dynamic for current JS codegen compatibility; field, variant, member, and function schemas carry the concrete contracts."
  :roots $ #{} 'js-ffi.shared/date-now-snapshot 'js-ffi.browser/viewport 'js-ffi.browser/element-snapshot
  :definitions $ {}
    'js-ffi.shared/Runtime $ {}
      :mode :ensure
      :kind :data
      :doc "|Runtime identity normalized as a Calcit enum instead of an open String."
      :schema $ :: 'Dynamic
      :code $ quote
        defenum Runtime (:browser) (:node) (:unknown 'String)
      :examples $ []
        quote $ %:: Runtime :browser
        quote $ %:: Runtime :unknown |worker
    'js-ffi.shared/JsErrorKind $ {}
      :mode :ensure
      :kind :data
      :doc "|Stable error categories shared by browser and Node adapters; unknown host names retain their String payload."
      :schema $ :: 'Dynamic
      :code $ quote
        defenum JsErrorKind (:type-error) (:range-error) (:permission) (:quota) (:network) (:abort) (:unknown 'String)
      :examples $ []
        quote $ %:: JsErrorKind :network
        quote $ %:: JsErrorKind :unknown |DataCloneError
    'js-ffi.shared/JsError $ {}
      :mode :ensure
      :kind :data
      :doc "|Normalized JavaScript exception data. Stack is optional because hosts may omit it."
      :schema $ :: 'Dynamic
      :code $ quote
        defstruct JsError
          :kind 'js-ffi.shared/JsErrorKind
          :name 'String
          :message 'String
          :stack $ :: 'Option 'String
      :examples $ []
        quote $ &%{} JsError :kind (%:: JsErrorKind :type-error) :name |TypeError :message |invalid
    'js-ffi.shared/DateSnapshot $ {}
      :mode :ensure
      :kind :data
      :doc "|Immutable normalized view of a host Date with epoch milliseconds and ISO text."
      :schema $ :: 'Dynamic
      :code $ quote
        defstruct DateSnapshot (:timestamp 'Number) (:iso 'String)
      :examples $ []
        quote $ &%{} DateSnapshot :timestamp 0 :iso |1970-01-01T00:00:00.000Z
    'js-ffi.shared/UrlSnapshot $ {}
      :mode :ensure
      :kind :data
      :doc "|Immutable URL fields copied out of a host URL or Location object."
      :schema $ :: 'Dynamic
      :code $ quote
        defstruct UrlSnapshot
          :href 'String
          :protocol 'String
          :host 'String
          :hostname 'String
          :port 'String
          :pathname 'String
          :search 'String
          :hash 'String
      :examples $ []
        quote $ &%{} UrlSnapshot :href |https://example.test/a :protocol |https: :host |example.test :hostname |example.test :port | :pathname |/a :search | :hash |
    'js-ffi.shared/HttpMethod $ {}
      :mode :ensure
      :kind :data
      :doc "|Closed HTTP method set used by typed request options; custom methods remain an explicit adapter concern."
      :schema $ :: 'Dynamic
      :code $ quote
        defenum HttpMethod (:get) (:post) (:put) (:patch) (:delete) (:head) (:options)
      :examples $ []
        quote $ %:: HttpMethod :get
        quote $ %:: HttpMethod :post
    'js-ffi.shared/RequestOptions $ {}
      :mode :ensure
      :kind :data
      :doc "|Calcit-owned request configuration converted to a JavaScript object only inside an adapter."
      :schema $ :: 'Dynamic
      :code $ quote
        defstruct RequestOptions
          :method 'js-ffi.shared/HttpMethod
          :headers $ :: 'Map 'String 'String
          :body $ :: 'Option 'String
      :examples $ []
        quote $ &%{} RequestOptions :method (%:: HttpMethod :get) :headers ({})
    'js-ffi.shared/ResponseSnapshot $ {}
      :mode :ensure
      :kind :data
      :doc "|Normalized response metadata after a host Response has been inspected and its headers copied."
      :schema $ :: 'Dynamic
      :code $ quote
        defstruct ResponseSnapshot
          :status 'Number
          :status-text 'String
          :ok? 'Bool
          :url 'String
          :redirected? 'Bool
          :headers $ :: 'Map 'String 'String
      :examples $ []
        quote $ &%{} ResponseSnapshot :status 200 :status-text |OK :ok? true :url |https://example.test :redirected? false :headers ({})
    'js-ffi.shared/ConsoleHost $ {}
      :mode :ensure
      :kind :data
      :doc "|External console capability shared by browser and Node. Methods intentionally accept one String to avoid modeling host varargs."
      :schema $ :: 'Dynamic
      :tags $ #{} :ffi :js-host
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
      :examples $ []
        quote ConsoleHost
    'js-ffi.shared/DateHost $ {}
      :mode :ensure
      :kind :data
      :doc "|External JavaScript Date capability exposing only stable read methods needed for normalization."
      :schema $ :: 'Dynamic
      :tags $ #{} :ffi :js-host
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
      :examples $ []
        quote DateHost
    'js-ffi.shared/UrlHost $ {}
      :mode :ensure
      :kind :data
      :doc "|External URL-like capability shared by URL and browser Location objects. Fields are read-only in this contract."
      :schema $ :: 'Dynamic
      :tags $ #{} :ffi :js-host
      :code $ quote
        deftrait UrlHost
          :href 'String
          :protocol 'String
          :host 'String
          :hostname 'String
          :port 'String
          :pathname 'String
          :search 'String
          :hash 'String
          .to-string $ :: 'Fn
            {}
              :args $ [] 'js-ffi.shared/UrlHost
              :return 'String
      :examples $ []
        quote UrlHost
    'js-ffi.shared/UrlSearchParamsHost $ {}
      :mode :ensure
      :kind :data
      :doc "|External URLSearchParams capability. Nullable lookup remains JsNullish<String> until an adapter converts it to Option."
      :schema $ :: 'Dynamic
      :tags $ #{} :ffi :js-host
      :code $ quote
        deftrait UrlSearchParamsHost
          :size 'Number
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
      :examples $ []
        quote UrlSearchParamsHost
    'js-ffi.shared/AbortSignalHost $ {}
      :mode :ensure
      :kind :data
      :doc "|External AbortSignal capability. Reason stays an opaque nullable host object because JavaScript permits arbitrary values."
      :schema $ :: 'Dynamic
      :tags $ #{} :ffi :js-host
      :code $ quote
        deftrait AbortSignalHost
          :aborted 'Bool
          :reason $ :: 'JsNullish 'JsObject
          .throw-if-aborted! $ :: 'Fn
            {}
              :args $ [] 'js-ffi.shared/AbortSignalHost
              :return 'Unit
      :examples $ []
        quote AbortSignalHost
    'js-ffi.shared/AbortControllerHost $ {}
      :mode :ensure
      :kind :data
      :doc "|External AbortController capability with a typed signal and parameterless abort wrapper contract."
      :schema $ :: 'Dynamic
      :tags $ #{} :ffi :js-host
      :code $ quote
        deftrait AbortControllerHost
          :signal 'js-ffi.shared/AbortSignalHost
          .abort! $ :: 'Fn
            {}
              :args $ [] 'js-ffi.shared/AbortControllerHost
              :return 'Unit
      :examples $ []
        quote AbortControllerHost
    'js-ffi.shared/HeadersHost $ {}
      :mode :ensure
      :kind :data
      :doc "|External Headers capability with typed String keys and values; iteration is deliberately normalized elsewhere."
      :schema $ :: 'Dynamic
      :tags $ #{} :ffi :js-host
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
      :examples $ []
        quote HeadersHost
    'js-ffi.shared/ResponseHost $ {}
      :mode :ensure
      :kind :data
      :doc "|External Response metadata capability. Async body readers are omitted until adapters normalize their Promise results."
      :schema $ :: 'Dynamic
      :tags $ #{} :ffi :js-host
      :code $ quote
        deftrait ResponseHost
          :status 'Number
          :status-text 'String
          :ok? 'Bool
          :url 'String
          :redirected? 'Bool
          :headers 'js-ffi.shared/HeadersHost
          :body-used? 'Bool
      :examples $ []
        quote ResponseHost
    'js-ffi.shared/runtime-label $ {}
      :mode :ensure
      :kind :fn
      :doc "|Convert Runtime to the stable host label used in logs and compatibility checks."
      :params $ [] 'runtime
      :schema $ :: :fn
        {}
          :args $ [] 'js-ffi.shared/Runtime
          :return 'String
      :code $ quote
        defn runtime-label (runtime)
          tag-match runtime
            (:browser) |browser
            (:node) |node
            (:unknown label) label
      :examples $ []
        quote $ runtime-label (%:: Runtime :browser)
    'js-ffi.shared/console-log! $ {}
      :mode :ensure
      :kind :fn
      :doc "|Write one String to the host console and normalize the host undefined return to Unit."
      :params $ [] 'message
      :schema $ :: :fn
        {}
          :args $ [] 'String
          :return 'Unit
          :features $ #{} :js-ffi
      :code $ quote
        defn console-log! (message)
          let
              host-console $ unsafe-coerce js/console ConsoleHost
            host-console .log! message
            , nil
      :examples $ []
        quote $ console-log! |ready
    'js-ffi.shared/console-warn! $ {}
      :mode :ensure
      :kind :fn
      :doc "|Write one warning String to the host console and return Unit in browser or Node."
      :params $ [] 'message
      :schema $ :: :fn
        {}
          :args $ [] 'String
          :return 'Unit
          :features $ #{} :js-ffi
      :code $ quote
        defn console-warn! (message)
          let
              host-console $ unsafe-coerce js/console ConsoleHost
            host-console .warn! message
            , nil
      :examples $ []
        quote $ console-warn! |deprecated
    'js-ffi.shared/console-error! $ {}
      :mode :ensure
      :kind :fn
      :doc "|Write one error String to the host console and return Unit in browser or Node."
      :params $ [] 'message
      :schema $ :: :fn
        {}
          :args $ [] 'String
          :return 'Unit
          :features $ #{} :js-ffi
      :code $ quote
        defn console-error! (message)
          let
              host-console $ unsafe-coerce js/console ConsoleHost
            host-console .error! message
            , nil
      :examples $ []
        quote $ console-error! |failed
    'js-ffi.shared/http-method-label $ {}
      :mode :ensure
      :kind :fn
      :doc "|Convert HttpMethod to the uppercase token expected by JavaScript request APIs."
      :params $ [] 'method
      :schema $ :: :fn
        {}
          :args $ [] 'js-ffi.shared/HttpMethod
          :return 'String
      :code $ quote
        defn http-method-label (method)
          tag-match method
            (:get) |GET
            (:post) |POST
            (:put) |PUT
            (:patch) |PATCH
            (:delete) |DELETE
            (:head) |HEAD
            (:options) |OPTIONS
      :examples $ []
        quote $ http-method-label (%:: HttpMethod :post)
    'js-ffi.shared/date-snapshot $ {}
      :mode :ensure
      :kind :fn
      :doc "|Copy a typed host Date into Calcit-owned DateSnapshot data."
      :params $ [] 'date
      :schema $ :: :fn
        {}
          :args $ [] 'js-ffi.shared/DateHost
          :return 'js-ffi.shared/DateSnapshot
          :features $ #{} :js-ffi
      :code $ quote
        defn date-snapshot (date)
          &%{} DateSnapshot
            , :timestamp
            date .get-time
            , :iso
            date .to-iso-string
      :examples $ []
        quote $ date-now-snapshot
    'js-ffi.shared/date-now-snapshot $ {}
      :mode :ensure
      :kind :fn
      :doc "|Create a host Date and immediately normalize it to DateSnapshot in browser or Node."
      :params $ []
      :schema $ :: :fn
        {}
          :args $ []
          :return 'js-ffi.shared/DateSnapshot
          :features $ #{} :js-ffi
      :code $ quote
        defn date-now-snapshot ()
          date-snapshot $ unsafe-coerce (new js/Date) DateHost
      :examples $ []
        quote $ date-now-snapshot
    'js-ffi.shared/url-snapshot $ {}
      :mode :ensure
      :kind :fn
      :doc "|Copy a URL-like host object into immutable UrlSnapshot data without retaining host identity."
      :params $ [] 'url
      :schema $ :: :fn
        {}
          :args $ [] 'js-ffi.shared/UrlHost
          :return 'js-ffi.shared/UrlSnapshot
          :features $ #{} :js-ffi
      :code $ quote
        defn url-snapshot (url)
          &%{} UrlSnapshot
            , :href
            url :href
            , :protocol
            url :protocol
            , :host
            url :host
            , :hostname
            url :hostname
            , :port
            url :port
            , :pathname
            url :pathname
            , :search
            url :search
            , :hash
            url :hash
      :examples $ []
        quote UrlSnapshot
    'js-ffi.browser/Viewport $ {}
      :mode :ensure
      :kind :data
      :doc "|Normalized viewport dimensions and device pixel ratio copied from Window."
      :schema $ :: 'Dynamic
      :code $ quote
        defstruct Viewport (:width 'Number) (:height 'Number) (:device-pixel-ratio 'Number)
      :examples $ []
        quote $ &%{} Viewport :width 1024 :height 768 :device-pixel-ratio 2
    'js-ffi.browser/BrowserProbe $ {}
      :mode :ensure
      :kind :data
      :doc "|Typed browser smoke result replacing the former heterogeneous Map<Dynamic>."
      :schema $ :: 'Dynamic
      :code $ quote
        defstruct BrowserProbe
          :runtime 'js-ffi.shared/Runtime
          :document? 'Bool
          :storage 'String
          :viewport 'js-ffi.browser/Viewport
      :examples $ []
        quote $ &%{} BrowserProbe :runtime (%:: shared/Runtime :browser) :document? true :storage |ok :viewport (&%{} Viewport :width 1024 :height 768 :device-pixel-ratio 2)
    'js-ffi.browser/ElementSnapshot $ {}
      :mode :ensure
      :kind :data
      :doc "|Calcit-owned subset of DOM element data suitable for business code without retaining host identity."
      :schema $ :: 'Dynamic
      :code $ quote
        defstruct ElementSnapshot
          :id 'String
          :class-name 'String
          :text-content $ :: 'Option 'String
          :child-count 'Number
      :examples $ []
        quote $ &%{} ElementSnapshot :id |main :class-name |panel :text-content (%some |Ready) :child-count 1
    'js-ffi.browser/KeyModifiers $ {}
      :mode :ensure
      :kind :data
      :doc "|Normalized keyboard or pointer modifier state shared by event adapters."
      :schema $ :: 'Dynamic
      :code $ quote
        defstruct KeyModifiers (:alt? 'Bool) (:ctrl? 'Bool) (:meta? 'Bool) (:shift? 'Bool)
      :examples $ []
        quote $ &%{} KeyModifiers :alt? false :ctrl? true :meta? false :shift? false
    'js-ffi.browser/PointerPosition $ {}
      :mode :ensure
      :kind :data
      :doc "|Normalized pointer coordinates and button index copied from a MouseEvent-like object."
      :schema $ :: 'Dynamic
      :code $ quote
        defstruct PointerPosition (:client-x 'Number) (:client-y 'Number) (:button 'Number)
      :examples $ []
        quote $ &%{} PointerPosition :client-x 20 :client-y 30 :button 0
    'js-ffi.browser/DocumentReadyState $ {}
      :mode :ensure
      :kind :data
      :doc "|Typed document.readyState values with an unknown String variant for forward compatibility."
      :schema $ :: 'Dynamic
      :code $ quote
        defenum DocumentReadyState (:loading) (:interactive) (:complete) (:unknown 'String)
      :examples $ []
        quote $ %:: DocumentReadyState :complete
    'js-ffi.browser/VisibilityState $ {}
      :mode :ensure
      :kind :data
      :doc "|Typed document.visibilityState values with an unknown String variant."
      :schema $ :: 'Dynamic
      :code $ quote
        defenum VisibilityState (:visible) (:hidden) (:prerender) (:unknown 'String)
      :examples $ []
        quote $ %:: VisibilityState :visible
    'js-ffi.browser/WindowHost $ {}
      :mode :ensure
      :kind :data
      :doc "|External browser Window capability restricted to stable viewport fields and matchMedia."
      :schema $ :: 'Dynamic
      :tags $ #{} :ffi :js-host
      :code $ quote
        deftrait WindowHost
          :inner-width 'Number
          :inner-height 'Number
          :device-pixel-ratio 'Number
          .match-media $ :: 'Fn
            {}
              :args $ [] 'js-ffi.browser/WindowHost 'String
              :return 'js-ffi.browser/MediaQueryListHost
      :examples $ []
        quote WindowHost
    'js-ffi.browser/DocumentHost $ {}
      :mode :ensure
      :kind :data
      :doc "|External Document capability with typed state, title, and small selector/creation surface."
      :schema $ :: 'Dynamic
      :tags $ #{} :ffi :js-host
      :code $ quote
        deftrait DocumentHost
          :title 'String
          :ready-state 'String
          :visibility-state 'String
          .query-selector $ :: 'Fn
            {}
              :args $ [] 'js-ffi.browser/DocumentHost 'String
              :return $ :: 'JsNullish 'js-ffi.browser/DomElementHost
          .create-element $ :: 'Fn
            {}
              :args $ [] 'js-ffi.browser/DocumentHost 'String
              :return 'js-ffi.browser/DomElementHost
      :examples $ []
        quote DocumentHost
    'js-ffi.browser/LocationHost $ {}
      :mode :ensure
      :kind :data
      :doc "|External browser Location capability. Navigation methods are explicit effects; URL fields are readable."
      :schema $ :: 'Dynamic
      :tags $ #{} :ffi :js-host
      :code $ quote
        deftrait LocationHost
          :href 'String
          :protocol 'String
          :host 'String
          :hostname 'String
          :port 'String
          :pathname 'String
          :search 'String
          :hash 'String
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
      :examples $ []
        quote LocationHost
    'js-ffi.browser/StorageHost $ {}
      :mode :ensure
      :kind :data
      :doc "|External Web Storage capability with nullish lookup and explicit String mutation methods."
      :schema $ :: 'Dynamic
      :tags $ #{} :ffi :js-host
      :code $ quote
        deftrait StorageHost
          :length 'Number
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
      :examples $ []
        quote StorageHost
    'js-ffi.browser/DomElementHost $ {}
      :mode :ensure
      :kind :data
      :doc "|External DOM Element capability with stable fields, selector methods, attributes, and focus effects."
      :schema $ :: 'Dynamic
      :tags $ #{} :ffi :js-host
      :code $ quote
        deftrait DomElementHost
          :id 'String
          :class-name 'String
          :text-content $ :: 'JsNullish 'String
          :child-element-count 'Number
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
      :examples $ []
        quote DomElementHost
    'js-ffi.browser/DomInputHost $ {}
      :mode :ensure
      :kind :data
      :doc "|External HTML input capability. Mutable fields are declared in FFI metadata, not in the core trait type."
      :schema $ :: 'Dynamic
      :tags $ #{} :ffi :js-host
      :code $ quote
        deftrait DomInputHost
          :value 'String
          :checked 'Bool
          :disabled 'Bool
          :name 'String
          :input-type 'String
          .focus! $ :: 'Fn
            {}
              :args $ [] 'js-ffi.browser/DomInputHost
              :return 'Unit
          .blur! $ :: 'Fn
            {}
              :args $ [] 'js-ffi.browser/DomInputHost
              :return 'Unit
      :examples $ []
        quote DomInputHost
    'js-ffi.browser/EventHost $ {}
      :mode :ensure
      :kind :data
      :doc "|External Event capability. Targets stay nullable opaque objects unless a specific adapter narrows them."
      :schema $ :: 'Dynamic
      :tags $ #{} :ffi :js-host
      :code $ quote
        deftrait EventHost
          :event-type 'String
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
      :examples $ []
        quote EventHost
    'js-ffi.browser/KeyboardEventHost $ {}
      :mode :ensure
      :kind :data
      :doc "|External KeyboardEvent capability without trait inheritance; adapters normalize keys and modifiers into Calcit data."
      :schema $ :: 'Dynamic
      :tags $ #{} :ffi :js-host
      :code $ quote
        deftrait KeyboardEventHost
          :key 'String
          :code 'String
          :repeat? 'Bool
          :alt-key? 'Bool
          :ctrl-key? 'Bool
          :meta-key? 'Bool
          :shift-key? 'Bool
          .prevent-default! $ :: 'Fn
            {}
              :args $ [] 'js-ffi.browser/KeyboardEventHost
              :return 'Unit
      :examples $ []
        quote KeyboardEventHost
    'js-ffi.browser/MouseEventHost $ {}
      :mode :ensure
      :kind :data
      :doc "|External MouseEvent capability exposing coordinates, button, and modifier fields used by adapters."
      :schema $ :: 'Dynamic
      :tags $ #{} :ffi :js-host
      :code $ quote
        deftrait MouseEventHost
          :client-x 'Number
          :client-y 'Number
          :button 'Number
          :alt-key? 'Bool
          :ctrl-key? 'Bool
          :meta-key? 'Bool
          :shift-key? 'Bool
          .prevent-default! $ :: 'Fn
            {}
              :args $ [] 'js-ffi.browser/MouseEventHost
              :return 'Unit
      :examples $ []
        quote MouseEventHost
    'js-ffi.browser/MediaQueryListHost $ {}
      :mode :ensure
      :kind :data
      :doc "|External matchMedia result with stable media and matches fields. Listener APIs remain adapter-specific."
      :schema $ :: 'Dynamic
      :tags $ #{} :ffi :js-host
      :code $ quote
        deftrait MediaQueryListHost (:media 'String) (:matches? 'Bool)
      :examples $ []
        quote MediaQueryListHost
    'js-ffi.browser/viewport $ {}
      :mode :ensure
      :kind :fn
      :doc "|Read Window viewport fields once and return normalized Viewport data."
      :params $ []
      :schema $ :: :fn
        {}
          :args $ []
          :return 'js-ffi.browser/Viewport
          :features $ #{} :js-ffi
      :code $ quote
        defn viewport ()
          let
              host-window $ unsafe-coerce js/window WindowHost
            &%{} Viewport
              , :width
              host-window :inner-width
              , :height
              host-window :inner-height
              , :device-pixel-ratio
              host-window :device-pixel-ratio
      :examples $ []
        quote $ viewport
    'js-ffi.browser/runtime $ {}
      :mode :ensure
      :kind :fn
      :doc "|Return the normalized Runtime browser enum variant."
      :params $ []
      :schema $ :: :fn
        {}
          :args $ []
          :return 'js-ffi.shared/Runtime
      :code $ quote
        defn runtime () $ %:: shared/Runtime :browser
      :examples $ []
        quote $ runtime
    'js-ffi.browser/storage-get $ {}
      :mode :ensure
      :kind :fn
      :doc "|Read one localStorage key as Option<String>; missing and JavaScript nullish values become none. Host exceptions remain an adapter concern."
      :params $ [] 'key
      :schema $ :: :fn
        {}
          :args $ [] 'String
          :return $ :: 'Option 'String
          :features $ #{} :js-ffi
      :code $ quote
        defn storage-get (key)
          let
              storage $ unsafe-coerce js/localStorage StorageHost
            js-nullish->option $ storage .get-item key
      :examples $ []
        quote $ storage-get |theme
    'js-ffi.browser/decode-document-ready-state $ {}
      :mode :ensure
      :kind :fn
      :doc "|Decode document.readyState String to DocumentReadyState while preserving unknown values."
      :params $ [] 'raw
      :schema $ :: :fn
        {}
          :args $ [] 'String
          :return 'js-ffi.browser/DocumentReadyState
      :code $ quote
        defn decode-document-ready-state (raw)
          case-default raw (%:: DocumentReadyState :unknown raw)
            |loading $ %:: DocumentReadyState :loading
            |interactive $ %:: DocumentReadyState :interactive
            |complete $ %:: DocumentReadyState :complete
      :examples $ []
        quote $ decode-document-ready-state |complete
        quote $ decode-document-ready-state |future-state
    'js-ffi.browser/decode-visibility-state $ {}
      :mode :ensure
      :kind :fn
      :doc "|Decode document.visibilityState String to VisibilityState while preserving unknown values."
      :params $ [] 'raw
      :schema $ :: :fn
        {}
          :args $ [] 'String
          :return 'js-ffi.browser/VisibilityState
      :code $ quote
        defn decode-visibility-state (raw)
          case-default raw (%:: VisibilityState :unknown raw)
            |visible $ %:: VisibilityState :visible
            |hidden $ %:: VisibilityState :hidden
            |prerender $ %:: VisibilityState :prerender
      :examples $ []
        quote $ decode-visibility-state |hidden
    'js-ffi.browser/document-ready-state $ {}
      :mode :ensure
      :kind :fn
      :doc "|Read and decode document.readyState through the typed DocumentHost contract."
      :params $ []
      :schema $ :: :fn
        {}
          :args $ []
          :return 'js-ffi.browser/DocumentReadyState
          :features $ #{} :js-ffi
      :code $ quote
        defn document-ready-state ()
          let
              host-document $ unsafe-coerce js/document DocumentHost
            decode-document-ready-state $ host-document :ready-state
      :examples $ []
        quote $ document-ready-state
    'js-ffi.browser/visibility-state $ {}
      :mode :ensure
      :kind :fn
      :doc "|Read and decode document.visibilityState through the typed DocumentHost contract."
      :params $ []
      :schema $ :: :fn
        {}
          :args $ []
          :return 'js-ffi.browser/VisibilityState
          :features $ #{} :js-ffi
      :code $ quote
        defn visibility-state ()
          let
              host-document $ unsafe-coerce js/document DocumentHost
            decode-visibility-state $ host-document :visibility-state
      :examples $ []
        quote $ visibility-state
    'js-ffi.browser/element-snapshot $ {}
      :mode :ensure
      :kind :fn
      :doc "|Copy a typed DOM element into ElementSnapshot, converting nullish textContent to Option<String>."
      :params $ [] 'element
      :schema $ :: :fn
        {}
          :args $ [] 'js-ffi.browser/DomElementHost
          :return 'js-ffi.browser/ElementSnapshot
          :features $ #{} :js-ffi
      :code $ quote
        defn element-snapshot (element)
          &%{} ElementSnapshot
            , :id
            element :id
            , :class-name
            element :class-name
            , :text-content
            js-nullish->option $ element :text-content
            , :child-count
            element :child-element-count
      :examples $ []
        quote ElementSnapshot
    'js-ffi.node/NodeProbe $ {}
      :mode :ensure
      :kind :data
      :doc "|Typed Node smoke result replacing the former heterogeneous Map<Dynamic>."
      :schema $ :: 'Dynamic
      :code $ quote
        defstruct NodeProbe (:runtime 'js-ffi.shared/Runtime) (:cwd 'String) (:argv-count 'Number)
      :examples $ []
        quote $ &%{} NodeProbe :runtime (%:: shared/Runtime :node) :cwd |/tmp :argv-count 2
    'js-ffi.node/runtime $ {}
      :mode :ensure
      :kind :fn
      :doc "|Return the normalized Runtime node enum variant."
      :params $ []
      :schema $ :: :fn
        {}
          :args $ []
          :return 'js-ffi.shared/Runtime
      :code $ quote
        defn runtime () $ %:: shared/Runtime :node
      :examples $ []
        quote $ runtime
  :edges $ #{}
    :: :call 'js-ffi.shared/date-now-snapshot 'js-ffi.shared/date-snapshot
    :: :type 'js-ffi.shared/date-snapshot 'js-ffi.shared/DateHost
    :: :type 'js-ffi.shared/date-snapshot 'js-ffi.shared/DateSnapshot
    :: :type 'js-ffi.shared/console-log! 'js-ffi.shared/ConsoleHost
    :: :type 'js-ffi.shared/console-warn! 'js-ffi.shared/ConsoleHost
    :: :type 'js-ffi.shared/console-error! 'js-ffi.shared/ConsoleHost
    :: :type 'js-ffi.shared/url-snapshot 'js-ffi.shared/UrlHost
    :: :type 'js-ffi.shared/url-snapshot 'js-ffi.shared/UrlSnapshot
    :: :type 'js-ffi.browser/viewport 'js-ffi.browser/WindowHost
    :: :type 'js-ffi.browser/viewport 'js-ffi.browser/Viewport
    :: :call 'js-ffi.browser/document-ready-state 'js-ffi.browser/decode-document-ready-state
    :: :type 'js-ffi.browser/document-ready-state 'js-ffi.browser/DocumentHost
    :: :call 'js-ffi.browser/visibility-state 'js-ffi.browser/decode-visibility-state
    :: :type 'js-ffi.browser/visibility-state 'js-ffi.browser/DocumentHost
    :: :type 'js-ffi.browser/element-snapshot 'js-ffi.browser/DomElementHost
    :: :type 'js-ffi.browser/element-snapshot 'js-ffi.browser/ElementSnapshot
    :: :type 'js-ffi.browser/storage-get 'js-ffi.browser/StorageHost
