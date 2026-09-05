{} (:schema-version 1) (:feature 'standard-host-adapters)
  :doc "|Reusable synchronous shared, DOM and Node adapters. Constructors retain host identity; optional lookups normalize nullish values; effects return Unit."
  :roots $ #{} 'js-ffi.shared/url-create 'js-ffi.shared/search-params-create 'js-ffi.shared/headers-create 'js-ffi.shared/abort-controller-create 'js-ffi.shared/search-params-get 'js-ffi.shared/search-params-has? 'js-ffi.shared/search-params-set! 'js-ffi.shared/search-params-delete! 'js-ffi.shared/headers-get 'js-ffi.shared/headers-has? 'js-ffi.shared/headers-set! 'js-ffi.shared/headers-delete! 'js-ffi.shared/search-params-string 'js-ffi.shared/search-params-size 'js-ffi.shared/headers-append! 'js-ffi.shared/abort-signal 'js-ffi.shared/abort! 'js-ffi.shared/aborted? 'js-ffi.shared/encode-uri-component 'js-ffi.shared/decode-uri-component 'js-ffi.shared/now-ms 'js-ffi.shared/performance-now 'js-ffi.node/path-basename 'js-ffi.node/path-dirname 'js-ffi.node/path-extname 'js-ffi.node/path-normalize 'js-ffi.node/path-resolve 'js-ffi.node/path-relative 'js-ffi.node/path-absolute? 'js-ffi.node/read-text! 'js-ffi.node/write-text! 'js-ffi.node/append-text! 'js-ffi.node/copy-file! 'js-ffi.node/rename! 'js-ffi.node/unlink! 'js-ffi.node/mkdir! 'js-ffi.node/rmdir! 'js-ffi.node/make-temp-dir! 'js-ffi.node/real-path! 'js-ffi.node/pid 'js-ffi.node/platform 'js-ffi.node/node-version 'js-ffi.node/uptime 'js-ffi.browser/element-get-attribute 'js-ffi.browser/element-set-attribute! 'js-ffi.browser/element-remove-attribute! 'js-ffi.browser/element-matches? 'js-ffi.browser/element-query-selector 'js-ffi.browser/element-focus! 'js-ffi.browser/element-blur! 'js-ffi.browser/clear-timeout! 'js-ffi.browser/clear-interval! 'js-ffi.browser/cancel-animation-frame! 'js-ffi.browser/request-animation-frame!
  :definitions $ {}
    'js-ffi.shared/url-create $ {} (:mode :ensure) (:kind :fn)
      :doc "|Construct a native URL and retain its typed host identity. Invalid constructor inputs raise host exceptions."
      :schema $ :: 'Fn $ {} (:return 'js-ffi.shared/UrlHost) (:args $ [] 'String 'String) (:features $ #{} :js-ffi)
      :params $ [] 'input 'base
    'js-ffi.shared/search-params-create $ {} (:mode :ensure) (:kind :fn)
      :doc "|Construct a native URLSearchParams and retain its typed host identity. Invalid constructor inputs raise host exceptions."
      :schema $ :: 'Fn $ {} (:return 'js-ffi.shared/UrlSearchParamsHost) (:args $ [] 'String) (:features $ #{} :js-ffi)
      :params $ [] 'query
    'js-ffi.shared/headers-create $ {} (:mode :ensure) (:kind :fn)
      :doc "|Construct a native Headers and retain its typed host identity. Invalid constructor inputs raise host exceptions."
      :schema $ :: 'Fn $ {} (:return 'js-ffi.shared/HeadersHost) (:args $ [] ) (:features $ #{} :js-ffi)
      :params $ [] 
    'js-ffi.shared/abort-controller-create $ {} (:mode :ensure) (:kind :fn)
      :doc "|Construct a native AbortController and retain its typed host identity. Invalid constructor inputs raise host exceptions."
      :schema $ :: 'Fn $ {} (:return 'js-ffi.shared/AbortControllerHost) (:args $ [] ) (:features $ #{} :js-ffi)
      :params $ [] 
    'js-ffi.shared/search-params-get $ {} (:mode :ensure) (:kind :fn)
      :doc "|Lookup a key; missing values become Option.none."
      :schema $ :: 'Fn $ {} (:return (:: 'Option 'String)) (:args $ [] 'js-ffi.shared/UrlSearchParamsHost 'String) (:features $ #{} :js-ffi)
      :params $ [] 'value 'key
    'js-ffi.shared/search-params-has? $ {} (:mode :ensure) (:kind :fn)
      :doc "|Check whether a key exists."
      :schema $ :: 'Fn $ {} (:return 'Bool) (:args $ [] 'js-ffi.shared/UrlSearchParamsHost 'String) (:features $ #{} :js-ffi)
      :params $ [] 'value 'key
    'js-ffi.shared/search-params-set! $ {} (:mode :ensure) (:kind :fn)
      :doc "|Replace the values for a key."
      :schema $ :: 'Fn $ {} (:return 'Unit) (:args $ [] 'js-ffi.shared/UrlSearchParamsHost 'String 'String) (:features $ #{} :js-ffi)
      :params $ [] 'value 'key 'text
    'js-ffi.shared/search-params-delete! $ {} (:mode :ensure) (:kind :fn)
      :doc "|Remove a key and return Unit."
      :schema $ :: 'Fn $ {} (:return 'Unit) (:args $ [] 'js-ffi.shared/UrlSearchParamsHost 'String) (:features $ #{} :js-ffi)
      :params $ [] 'value 'key
    'js-ffi.shared/headers-get $ {} (:mode :ensure) (:kind :fn)
      :doc "|Lookup a key; missing values become Option.none."
      :schema $ :: 'Fn $ {} (:return (:: 'Option 'String)) (:args $ [] 'js-ffi.shared/HeadersHost 'String) (:features $ #{} :js-ffi)
      :params $ [] 'value 'key
    'js-ffi.shared/headers-has? $ {} (:mode :ensure) (:kind :fn)
      :doc "|Check whether a key exists."
      :schema $ :: 'Fn $ {} (:return 'Bool) (:args $ [] 'js-ffi.shared/HeadersHost 'String) (:features $ #{} :js-ffi)
      :params $ [] 'value 'key
    'js-ffi.shared/headers-set! $ {} (:mode :ensure) (:kind :fn)
      :doc "|Replace the values for a key."
      :schema $ :: 'Fn $ {} (:return 'Unit) (:args $ [] 'js-ffi.shared/HeadersHost 'String 'String) (:features $ #{} :js-ffi)
      :params $ [] 'value 'key 'text
    'js-ffi.shared/headers-delete! $ {} (:mode :ensure) (:kind :fn)
      :doc "|Remove a key and return Unit."
      :schema $ :: 'Fn $ {} (:return 'Unit) (:args $ [] 'js-ffi.shared/HeadersHost 'String) (:features $ #{} :js-ffi)
      :params $ [] 'value 'key
    'js-ffi.shared/search-params-string $ {} (:mode :ensure) (:kind :fn)
      :doc "|Serialize query parameters with standard percent encoding."
      :schema $ :: 'Fn $ {} (:return 'String) (:args $ [] 'js-ffi.shared/UrlSearchParamsHost) (:features $ #{} :js-ffi)
      :params $ [] 'value
    'js-ffi.shared/search-params-size $ {} (:mode :ensure) (:kind :fn)
      :doc "|Count query entries, including duplicate keys."
      :schema $ :: 'Fn $ {} (:return 'Number) (:args $ [] 'js-ffi.shared/UrlSearchParamsHost) (:features $ #{} :js-ffi)
      :params $ [] 'value
    'js-ffi.shared/headers-append! $ {} (:mode :ensure) (:kind :fn)
      :doc "|Append a header value using native Headers normalization."
      :schema $ :: 'Fn $ {} (:return 'Unit) (:args $ [] 'js-ffi.shared/HeadersHost 'String 'String) (:features $ #{} :js-ffi)
      :params $ [] 'value 'key 'text
    'js-ffi.shared/abort-signal $ {} (:mode :ensure) (:kind :fn)
      :doc "|Return the controller signal, preserving identity."
      :schema $ :: 'Fn $ {} (:return 'js-ffi.shared/AbortSignalHost) (:args $ [] 'js-ffi.shared/AbortControllerHost) (:features $ #{} :js-ffi)
      :params $ [] 'controller
    'js-ffi.shared/abort! $ {} (:mode :ensure) (:kind :fn)
      :doc "|Abort the controller. Repeated aborts are safe."
      :schema $ :: 'Fn $ {} (:return 'Unit) (:args $ [] 'js-ffi.shared/AbortControllerHost) (:features $ #{} :js-ffi)
      :params $ [] 'controller
    'js-ffi.shared/aborted? $ {} (:mode :ensure) (:kind :fn)
      :doc "|Read whether a signal has been aborted."
      :schema $ :: 'Fn $ {} (:return 'Bool) (:args $ [] 'js-ffi.shared/AbortSignalHost) (:features $ #{} :js-ffi)
      :params $ [] 'signal
    'js-ffi.shared/encode-uri-component $ {} (:mode :ensure) (:kind :fn)
      :doc "|Read the native result through a checked primitive boundary. Invalid input may raise a host exception."
      :schema $ :: 'Fn $ {} (:return 'String) (:args $ [] 'String) (:features $ #{} :js-ffi)
      :params $ [] 'text
    'js-ffi.shared/decode-uri-component $ {} (:mode :ensure) (:kind :fn)
      :doc "|Read the native result through a checked primitive boundary. Invalid input may raise a host exception."
      :schema $ :: 'Fn $ {} (:return 'String) (:args $ [] 'String) (:features $ #{} :js-ffi)
      :params $ [] 'text
    'js-ffi.shared/now-ms $ {} (:mode :ensure) (:kind :fn)
      :doc "|Read the native result through a checked primitive boundary. Invalid input may raise a host exception."
      :schema $ :: 'Fn $ {} (:return 'Number) (:args $ [] ) (:features $ #{} :js-ffi)
      :params $ [] 
    'js-ffi.shared/performance-now $ {} (:mode :ensure) (:kind :fn)
      :doc "|Read the native result through a checked primitive boundary. Invalid input may raise a host exception."
      :schema $ :: 'Fn $ {} (:return 'Number) (:args $ [] ) (:features $ #{} :js-ffi)
      :params $ [] 
    'js-ffi.node/path-basename $ {} (:mode :ensure) (:kind :fn)
      :doc "|Call node:path.basename using native platform path rules and validate its result."
      :schema $ :: 'Fn $ {} (:return 'String) (:args $ [] 'String) (:features $ #{} :js-ffi)
      :params $ [] 'value
    'js-ffi.node/path-dirname $ {} (:mode :ensure) (:kind :fn)
      :doc "|Call node:path.dirname using native platform path rules and validate its result."
      :schema $ :: 'Fn $ {} (:return 'String) (:args $ [] 'String) (:features $ #{} :js-ffi)
      :params $ [] 'value
    'js-ffi.node/path-extname $ {} (:mode :ensure) (:kind :fn)
      :doc "|Call node:path.extname using native platform path rules and validate its result."
      :schema $ :: 'Fn $ {} (:return 'String) (:args $ [] 'String) (:features $ #{} :js-ffi)
      :params $ [] 'value
    'js-ffi.node/path-normalize $ {} (:mode :ensure) (:kind :fn)
      :doc "|Call node:path.normalize using native platform path rules and validate its result."
      :schema $ :: 'Fn $ {} (:return 'String) (:args $ [] 'String) (:features $ #{} :js-ffi)
      :params $ [] 'value
    'js-ffi.node/path-resolve $ {} (:mode :ensure) (:kind :fn)
      :doc "|Call node:path.resolve using native platform path rules and validate its result."
      :schema $ :: 'Fn $ {} (:return 'String) (:args $ [] 'String 'String) (:features $ #{} :js-ffi)
      :params $ [] 'base 'child
    'js-ffi.node/path-relative $ {} (:mode :ensure) (:kind :fn)
      :doc "|Call node:path.relative using native platform path rules and validate its result."
      :schema $ :: 'Fn $ {} (:return 'String) (:args $ [] 'String 'String) (:features $ #{} :js-ffi)
      :params $ [] 'base 'child
    'js-ffi.node/path-absolute? $ {} (:mode :ensure) (:kind :fn)
      :doc "|Call node:path.isAbsolute using native platform path rules and validate its result."
      :schema $ :: 'Fn $ {} (:return 'Bool) (:args $ [] 'String) (:features $ #{} :js-ffi)
      :params $ [] 'value
    'js-ffi.node/read-text! $ {} (:mode :ensure) (:kind :fn)
      :doc "|Synchronous node:fs.readFileSync adapter. Text uses UTF-8; filesystem failures raise the original host exception. No recursive deletion."
      :schema $ :: 'Fn $ {} (:return 'String) (:args $ [] 'String) (:features $ #{} :js-ffi)
      :params $ [] 'file-path
    'js-ffi.node/write-text! $ {} (:mode :ensure) (:kind :fn)
      :doc "|Synchronous node:fs.writeFileSync adapter. Text uses UTF-8; filesystem failures raise the original host exception. No recursive deletion."
      :schema $ :: 'Fn $ {} (:return 'Unit) (:args $ [] 'String 'String) (:features $ #{} :js-ffi)
      :params $ [] 'file-path 'text
    'js-ffi.node/append-text! $ {} (:mode :ensure) (:kind :fn)
      :doc "|Synchronous node:fs.appendFileSync adapter. Text uses UTF-8; filesystem failures raise the original host exception. No recursive deletion."
      :schema $ :: 'Fn $ {} (:return 'Unit) (:args $ [] 'String 'String) (:features $ #{} :js-ffi)
      :params $ [] 'file-path 'text
    'js-ffi.node/copy-file! $ {} (:mode :ensure) (:kind :fn)
      :doc "|Synchronous node:fs.copyFileSync adapter. Text uses UTF-8; filesystem failures raise the original host exception. No recursive deletion."
      :schema $ :: 'Fn $ {} (:return 'Unit) (:args $ [] 'String 'String) (:features $ #{} :js-ffi)
      :params $ [] 'source 'destination
    'js-ffi.node/rename! $ {} (:mode :ensure) (:kind :fn)
      :doc "|Synchronous node:fs.renameSync adapter. Text uses UTF-8; filesystem failures raise the original host exception. No recursive deletion."
      :schema $ :: 'Fn $ {} (:return 'Unit) (:args $ [] 'String 'String) (:features $ #{} :js-ffi)
      :params $ [] 'source 'destination
    'js-ffi.node/unlink! $ {} (:mode :ensure) (:kind :fn)
      :doc "|Synchronous node:fs.unlinkSync adapter. Text uses UTF-8; filesystem failures raise the original host exception. No recursive deletion."
      :schema $ :: 'Fn $ {} (:return 'Unit) (:args $ [] 'String) (:features $ #{} :js-ffi)
      :params $ [] 'file-path
    'js-ffi.node/mkdir! $ {} (:mode :ensure) (:kind :fn)
      :doc "|Synchronous node:fs.mkdirSync adapter. Text uses UTF-8; filesystem failures raise the original host exception. No recursive deletion."
      :schema $ :: 'Fn $ {} (:return 'Unit) (:args $ [] 'String) (:features $ #{} :js-ffi)
      :params $ [] 'directory
    'js-ffi.node/rmdir! $ {} (:mode :ensure) (:kind :fn)
      :doc "|Synchronous node:fs.rmdirSync adapter. Text uses UTF-8; filesystem failures raise the original host exception. No recursive deletion."
      :schema $ :: 'Fn $ {} (:return 'Unit) (:args $ [] 'String) (:features $ #{} :js-ffi)
      :params $ [] 'directory
    'js-ffi.node/make-temp-dir! $ {} (:mode :ensure) (:kind :fn)
      :doc "|Synchronous node:fs.mkdtempSync adapter. Text uses UTF-8; filesystem failures raise the original host exception. No recursive deletion."
      :schema $ :: 'Fn $ {} (:return 'String) (:args $ [] 'String) (:features $ #{} :js-ffi)
      :params $ [] 'prefix
    'js-ffi.node/real-path! $ {} (:mode :ensure) (:kind :fn)
      :doc "|Synchronous node:fs.realpathSync adapter. Text uses UTF-8; filesystem failures raise the original host exception. No recursive deletion."
      :schema $ :: 'Fn $ {} (:return 'String) (:args $ [] 'String) (:features $ #{} :js-ffi)
      :params $ [] 'file-path
    'js-ffi.node/pid $ {} (:mode :ensure) (:kind :fn)
      :doc "|Read and validate Node process metadata."
      :schema $ :: 'Fn $ {} (:return 'Number) (:args $ [] ) (:features $ #{} :js-ffi)
      :params $ [] 
    'js-ffi.node/platform $ {} (:mode :ensure) (:kind :fn)
      :doc "|Read and validate Node process metadata."
      :schema $ :: 'Fn $ {} (:return 'String) (:args $ [] ) (:features $ #{} :js-ffi)
      :params $ [] 
    'js-ffi.node/node-version $ {} (:mode :ensure) (:kind :fn)
      :doc "|Read and validate Node process metadata."
      :schema $ :: 'Fn $ {} (:return 'String) (:args $ [] ) (:features $ #{} :js-ffi)
      :params $ [] 
    'js-ffi.node/uptime $ {} (:mode :ensure) (:kind :fn)
      :doc "|Read and validate Node process metadata."
      :schema $ :: 'Fn $ {} (:return 'Number) (:args $ [] ) (:features $ #{} :js-ffi)
      :params $ [] 
    'js-ffi.browser/element-get-attribute $ {} (:mode :ensure) (:kind :fn)
      :doc "|Read a DOM attribute as Option<String>."
      :schema $ :: 'Fn $ {} (:return (:: 'Option 'String)) (:args $ [] 'js-ffi.browser/DomElementHost 'String) (:features $ #{} :js-ffi)
      :params $ [] 'element 'key
    'js-ffi.browser/element-set-attribute! $ {} (:mode :ensure) (:kind :fn)
      :doc "|Set a DOM attribute."
      :schema $ :: 'Fn $ {} (:return 'Unit) (:args $ [] 'js-ffi.browser/DomElementHost 'String 'String) (:features $ #{} :js-ffi)
      :params $ [] 'element 'key 'text
    'js-ffi.browser/element-remove-attribute! $ {} (:mode :ensure) (:kind :fn)
      :doc "|Remove a DOM attribute."
      :schema $ :: 'Fn $ {} (:return 'Unit) (:args $ [] 'js-ffi.browser/DomElementHost 'String) (:features $ #{} :js-ffi)
      :params $ [] 'element 'key
    'js-ffi.browser/element-matches? $ {} (:mode :ensure) (:kind :fn)
      :doc "|Match a CSS selector; invalid selectors raise DOMException."
      :schema $ :: 'Fn $ {} (:return 'Bool) (:args $ [] 'js-ffi.browser/DomElementHost 'String) (:features $ #{} :js-ffi)
      :params $ [] 'element 'selector
    'js-ffi.browser/element-query-selector $ {} (:mode :ensure) (:kind :fn)
      :doc "|Find a descendant or return Option.none."
      :schema $ :: 'Fn $ {} (:return (:: 'Option 'js-ffi.browser/DomElementHost)) (:args $ [] 'js-ffi.browser/DomElementHost 'String) (:features $ #{} :js-ffi)
      :params $ [] 'element 'selector
    'js-ffi.browser/element-focus! $ {} (:mode :ensure) (:kind :fn)
      :doc "|Focus an HTML element with focus capability."
      :schema $ :: 'Fn $ {} (:return 'Unit) (:args $ [] 'js-ffi.browser/DomElementHost) (:features $ #{} :js-ffi)
      :params $ [] 'element
    'js-ffi.browser/element-blur! $ {} (:mode :ensure) (:kind :fn)
      :doc "|Blur an HTML element with blur capability."
      :schema $ :: 'Fn $ {} (:return 'Unit) (:args $ [] 'js-ffi.browser/DomElementHost) (:features $ #{} :js-ffi)
      :params $ [] 'element
    'js-ffi.browser/clear-timeout! $ {} (:mode :ensure) (:kind :fn)
      :doc "|Cancel a browser numeric handle; unknown handles are harmless."
      :schema $ :: 'Fn $ {} (:return 'Unit) (:args $ [] 'Number) (:features $ #{} :js-ffi)
      :params $ [] 'handle
    'js-ffi.browser/clear-interval! $ {} (:mode :ensure) (:kind :fn)
      :doc "|Cancel a browser numeric handle; unknown handles are harmless."
      :schema $ :: 'Fn $ {} (:return 'Unit) (:args $ [] 'Number) (:features $ #{} :js-ffi)
      :params $ [] 'handle
    'js-ffi.browser/cancel-animation-frame! $ {} (:mode :ensure) (:kind :fn)
      :doc "|Cancel a browser numeric handle; unknown handles are harmless."
      :schema $ :: 'Fn $ {} (:return 'Unit) (:args $ [] 'Number) (:features $ #{} :js-ffi)
      :params $ [] 'handle
    'js-ffi.browser/request-animation-frame! $ {} (:mode :ensure) (:kind :fn)
      :doc "|Schedule a frame callback receiving a timestamp; returns a cancellable numeric handle."
      :schema $ :: 'Fn $ {} (:return 'Number) (:args $ [] (:: 'Fn ({} (:args $ [] 'Number) (:return 'Unit)))) (:features $ #{} :js-ffi)
      :params $ [] 'callback
  :edges $ #{}
