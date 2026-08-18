
{} (:about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `cr query` to inspect and `cr edit`/`cr tree` to modify. Run `cr docs agents --full` first. Manual edits must follow format and schema conventions, then run `cr edit format`.") (:package |js-ffi) (:version |0.0.1)
  :entries $ {}
    :browser $ {} (:description |) (:init-fn 'js-ffi.browser-test/main!) (:mode :js) (:reload-fn 'js-ffi.browser-test/reload!)
      :modules $ []
      :type-slots $ {}
    :default $ {} (:description |) (:init-fn 'js-ffi.node-test/main!) (:mode :native) (:reload-fn 'js-ffi.node-test/reload!)
      :modules $ []
      :type-slots $ {}
    :node $ {} (:description |) (:init-fn 'js-ffi.node-test/main!) (:mode :native) (:reload-fn 'js-ffi.node-test/reload!)
      :modules $ []
      :type-slots $ {}
  :files $ {}
    |js-ffi.browser $ %{} 'FileEntry
      :defs $ {}
        |console-error! $ %{} 'CodeEntry (:doc "|Write a typed error message to the browser console. The return value is intentionally Dynamic because console APIs are host functions. Example: (console-error! |failed)")
          :code $ quote
            defn console-error! (message) (js/console.error message)
          :examples $ [] (quote "(console-error! |failed)")
          :schema $ :: 'Fn
            {} (:return 'Dynamic)
              :args $ [] 'String
              :features $ #{} :js-ffi
        |console-log! $ %{} 'CodeEntry (:doc "|Write a typed message to the browser console. Example: (console-log! |ready)")
          :code $ quote
            defn console-log! (message) (js/console.log message)
          :examples $ [] (quote "(console-log! |ready)")
          :schema $ :: 'Fn
            {} (:return 'Dynamic)
              :args $ [] 'String
              :features $ #{} :js-ffi
        |document-available? $ %{} 'CodeEntry (:doc "|Return whether document is present. Use this guard before touching DOM objects so shared code can be checked in both Node.js and browsers. Example: (document-available?) => true")
          :code $ quote
            defn document-available? () $ js-present? js/document
          :examples $ [] (quote "(document-available?)")
          :schema $ :: 'Fn
            {} (:return 'Bool)
              :args $ []
              :features $ #{} :js-ffi
        |document-title $ %{} 'CodeEntry (:doc "|Read document.title as String. Returns an empty string when document is unavailable. Example: (document-title) => |Calcit")
          :code $ quote
            defn document-title () $ if (document-available?)
              let
                  doc $ unsafe-coerce js/document JsObject
                  title $ .-title doc
                if (js-present? title) (unsafe-coerce title String) |
              , |
          :examples $ [] (quote "(document-title)")
          :schema $ :: 'Fn
            {} (:return 'String)
              :args $ []
              :features $ #{} :js-ffi
        |local-storage-available? $ %{} 'CodeEntry (:doc "|Return whether localStorage is available. Browsers may deny storage in privacy or sandboxed modes, so callers should branch on this Boolean. Example: (local-storage-available?) => true")
          :code $ quote
            defn local-storage-available? () $ js-present? js/localStorage
          :examples $ [] (quote "(local-storage-available?)")
          :schema $ :: 'Fn
            {} (:return 'Bool)
              :args $ []
              :features $ #{} :js-ffi
        |location-href $ %{} 'CodeEntry (:doc "|Read the current browser URL as String. Returns an empty string outside a browser. Example: (location-href) => |https://example.test/")
          :code $ quote
            defn location-href () $ let
                loc $ unsafe-coerce js/location JsObject
                href $ .-href loc
              if (js-present? href) (unsafe-coerce href String) |
          :examples $ [] (quote "(location-href)")
          :schema $ :: 'Fn
            {} (:return 'String)
              :args $ []
              :features $ #{} :js-ffi
        |probe $ %{} 'CodeEntry (:doc "|Run a small browser capability probe. The result is a map with String runtime, Bool document?, and String storage fields; storage is |unavailable when localStorage cannot be used. Example: (probe) => {:runtime |browser :document? true :storage |ok}")
          :code $ quote
            defn probe () $ {}
              :runtime $ runtime-name
              :document? $ document-available?
              :storage $ storage-roundtrip!
          :examples $ [] (quote "(probe)")
          :schema $ :: 'Map 'Map 'Dynamic
        |random $ %{} 'CodeEntry (:doc "|Return a browser-compatible random number in the range 0 inclusive to 1 exclusive. The concrete return type is Number. Example: (random) => 0.42")
          :code $ quote
            defn random () $ unsafe-coerce (js/Math.random) Number
          :examples $ [] (quote "(random)")
          :schema $ :: 'Fn
            {} (:return 'Number)
              :args $ []
              :features $ #{} :js-ffi
        |runtime-name $ %{} 'CodeEntry (:doc "|Return the literal runtime identifier |browser. This is useful for environment contracts and keeps callers independent from host-specific globals. Example: (runtime-name) => |browser")
          :code $ quote
            defn runtime-name () |browser
          :examples $ [] (quote "(runtime-name)")
          :schema $ :: 'Fn
            {} (:return 'String)
              :args $ []
        |set-timeout! $ %{} 'CodeEntry (:doc "|Schedule a typed callback in milliseconds. The timer handle is host-specific and therefore Dynamic. Example: (set-timeout! (fn [] (console-log! |later)) 10)")
          :code $ quote
            defn set-timeout! (callback delay) (js/setTimeout callback delay)
          :examples $ [] (quote "(set-timeout! (fn [] (console-log! |later)) 10)")
          :schema $ :: 'Fn
            {} (:return 'Dynamic)
              :args $ [] 'Fn 'Number
              :features $ #{} :js-ffi
        |storage-get-or $ %{} 'CodeEntry (:doc "|Read a localStorage value with a typed String fallback. It avoids leaking JavaScript null into Calcit callers. Example: (storage-get-or |theme |light) => |light")
          :code $ quote
            defn storage-get-or (key fallback)
              let
                  storage $ unsafe-coerce js/localStorage JsObject
                  raw $ .!getItem storage key
                if (js-present? raw) (unsafe-coerce raw String) fallback
          :examples $ [] (quote "(storage-get-or |theme |light)")
          :schema $ :: 'Fn
            {} (:return 'String)
              :args $ [] 'String 'String
              :features $ #{} :js-ffi
        |storage-remove! $ %{} 'CodeEntry (:doc "|Remove one localStorage key. The host return value is Dynamic because browser storage methods do not expose a stable Calcit value. Example: (storage-remove! |js-ffi-smoke)")
          :code $ quote
            defn storage-remove! (key)
              when (local-storage-available?)
                let
                    storage $ unsafe-coerce js/localStorage JsObject
                  .!removeItem storage key
          :examples $ [] (quote "(storage-remove! |js-ffi-smoke)")
          :schema $ :: 'Fn
            {} (:return 'Dynamic)
              :args $ [] 'String
              :features $ #{} :js-ffi
        |storage-roundtrip! $ %{} 'CodeEntry (:doc "|Exercise localStorage with a deterministic String result for smoke tests. It writes |ok, reads it back, and returns |unavailable when storage is missing. Example: (storage-roundtrip!) => |ok")
          :code $ quote
            defn storage-roundtrip! () $ if (js-present? js/localStorage)
              do (storage-set! |js-ffi-smoke |ok) (storage-get-or |js-ffi-smoke |unavailable)
              , |unavailable
          :examples $ [] (quote "(storage-roundtrip!)")
          :schema $ :: 'Fn
            {} (:return 'String)
              :args $ []
              :features $ #{} :js-ffi
        |storage-set! $ %{} 'CodeEntry (:doc "|Write a String key/value pair to localStorage. Call local-storage-available? first when storage failure must be distinguished. Example: (storage-set! |theme |dark)")
          :code $ quote
            defn storage-set! (key value)
              when (local-storage-available?)
                let
                    storage $ unsafe-coerce js/localStorage JsObject
                  .!setItem storage key value
          :examples $ [] (quote "(storage-set! |theme |dark)")
          :schema $ :: 'Fn
            {} (:return 'Dynamic)
              :args $ [] 'String 'String
              :features $ #{} :js-ffi
        |viewport-height $ %{} 'CodeEntry (:doc "|Read window.innerHeight as Number. Returns 0 outside a browser. Example: (viewport-height) => 768")
          :code $ quote
            defn viewport-height () $ if (js-present? js/window) (unsafe-coerce js/window.innerHeight Number) 0
          :examples $ [] (quote "(viewport-height)")
          :schema $ :: 'Fn
            {} (:return 'Number)
              :args $ []
              :features $ #{} :js-ffi
        |viewport-width $ %{} 'CodeEntry (:doc "|Read window.innerWidth as Number. Returns 0 outside a browser. Example: (viewport-width) => 1024")
          :code $ quote
            defn viewport-width () $ if (js-present? js/window) (unsafe-coerce js/window.innerWidth Number) 0
          :examples $ [] (quote "(viewport-width)")
          :schema $ :: 'Fn
            {} (:return 'Number)
              :args $ []
              :features $ #{} :js-ffi
      :ns $ %{} 'NsEntry (:doc "|Typed browser JavaScript FFI. Host objects remain internal JsObject values; public helpers expose String, Number, and Bool contracts.")
        :code $ quote (ns js-ffi.browser)
    |js-ffi.browser-test $ %{} 'FileEntry
      :defs $ {}
        |main! $ %{} 'CodeEntry (:doc "|Run the browser smoke test and report the capability probe in the console. Example: (main!)")
          :code $ quote
            defn main! () $ let
                result $ browser/probe
                runtime $ option:unwrap-or (get result :runtime) |unknown
              js/console.log |js-ffi-browser-smoke result
              if (contract/valid-runtime? |browser runtime) (js/console.log |js-ffi-browser-smoke-passed) (js/console.error |js-ffi-browser-smoke-failed)
          :examples $ [] (quote "(main!)")
          :schema $ :: 'Fn
            {} (:return 'Dynamic)
              :args $ []
              :features $ #{} :js-ffi
        |reload! $ %{} 'CodeEntry (:doc "|Browser entry reload hook. It is intentionally a no-op for the standalone smoke page. Example: (reload!)")
          :code $ quote
            defn reload! () nil
          :examples $ [] (quote "(reload!)")
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns js-ffi.browser-test $ :require (js-ffi.browser :as browser) (js-ffi.contract :as contract)
    |js-ffi.contract $ %{} 'FileEntry
      :defs $ {}
        |valid-runtime? $ %{} 'CodeEntry (:doc "|Compare an expected runtime identifier with an observed String. Keep this small and environment-independent so Node.js and browser tests share the same contract. Example: (valid-runtime? |node (runtime-name)) => true")
          :code $ quote
            defn valid-runtime? (expected actual) (= expected actual)
          :examples $ [] (quote "(valid-runtime? |node |node)")
          :schema $ :: 'Fn
            {} (:return 'Bool)
              :args $ [] 'String 'String
      :ns $ %{} 'NsEntry (:doc "|Environment-independent contracts shared by Node.js and browser smoke tests.")
        :code $ quote (ns js-ffi.contract)
    |js-ffi.node $ %{} 'FileEntry
      :defs $ {}
        |argv-count $ %{} 'CodeEntry (:doc "|Return process.argv.length as Number. This deliberately narrows the host array at the boundary. Example: (argv-count) => 3")
          :code $ quote
            defn argv-count () $ let
                argv $ unsafe-coerce js/process.argv JsObject
              unsafe-coerce (.-length argv) Number
          :examples $ [] (quote "(argv-count)")
          :schema $ :: 'Fn
            {} (:return 'Number)
              :args $ []
              :features $ #{} :js-ffi
        |cwd $ %{} 'CodeEntry (:doc "|Return process.cwd() as String. This is a Node-only API and is emitted through the node entry. Example: (cwd) => |/workspace/project")
          :code $ quote
            defn cwd () $ unsafe-coerce (js/process.cwd) String
          :examples $ [] (quote "(cwd)")
          :schema $ :: 'Fn
            {} (:return 'String)
              :args $ []
              :features $ #{} :js-ffi
        |env-or $ %{} 'CodeEntry (:doc "|Read a process.env value with a typed String fallback. Example: (env-or |NODE_ENV |development) => |development")
          :code $ quote
            defn env-or (key fallback)
              let
                  env $ unsafe-coerce js/process.env JsObject
                  raw $ aget env key
                if (js-present? raw) (unsafe-coerce raw String) fallback
          :examples $ [] (quote "(env-or |NODE_ENV |development)")
          :schema $ :: 'Fn
            {} (:return 'String)
              :args $ [] 'String 'String
              :features $ #{} :js-ffi
        |exit! $ %{} 'CodeEntry (:doc "|Terminate the Node.js process with a numeric exit code. This is an effectful escape hatch and returns Dynamic. Example: (exit! 1)")
          :code $ quote
            defn exit! (code) (js/process.exit code)
          :examples $ [] (quote "(exit! 1)")
          :schema $ :: 'Fn
            {} (:return 'Dynamic)
              :args $ [] 'Number
              :features $ #{} :js-ffi
        |file-exists? $ %{} 'CodeEntry (:doc "|Return whether a local filesystem path exists as Bool. The fs module is kept behind the Node namespace. Example: (file-exists? |package.json) => true")
          :code $ quote
            defn file-exists? (file-path) (fs/existsSync file-path)
          :examples $ [] (quote "(file-exists? |package.json)")
          :schema $ :: 'Fn
            {} (:return 'Bool)
              :args $ [] 'String
              :features $ #{} :js-ffi
        |path-join $ %{} 'CodeEntry (:doc "|Join two path segments using node:path and return String. Example: (path-join |src |index.js) => |src/index.js")
          :code $ quote
            defn path-join (base child) (path/join base child)
          :examples $ [] (quote "(path-join |src |index.js)")
          :schema $ :: 'Fn
            {} (:return 'String)
              :args $ [] 'String 'String
              :features $ #{} :js-ffi
        |probe $ %{} 'CodeEntry (:doc "|Run the Node.js capability probe. The result map contains String runtime, String cwd, and Number argv-count fields. Example: (probe) => {:runtime |node :cwd |/tmp :argv-count 2}")
          :code $ quote
            defn probe () $ {}
              :runtime $ runtime-name
              :cwd $ cwd
              :argv-count $ argv-count
          :examples $ [] (quote "(probe)")
          :schema $ :: 'Map 'Map 'Dynamic
        |runtime-name $ %{} 'CodeEntry (:doc "|Return the literal runtime identifier |node. Example: (runtime-name) => |node")
          :code $ quote
            defn runtime-name () |node
          :examples $ [] (quote "(runtime-name)")
          :schema $ :: 'Fn
            {} (:return 'String)
              :args $ []
      :ns $ %{} 'NsEntry (:doc "|Typed Node.js JavaScript FFI. Node-only modules are imported here so browser consumers can stay on the browser entry.")
        :code $ quote
          ns js-ffi.node $ :require (|node:fs :as fs) (|node:path :as path)
    |js-ffi.node-test $ %{} 'FileEntry
      :defs $ {}
        |main! $ %{} 'CodeEntry (:doc "|Run the Node.js smoke test, print the probe, and exit non-zero on a runtime contract failure. Example: (main!)")
          :code $ quote
            defn main! () $ let
                result $ node/probe
                runtime $ option:unwrap-or (get result :runtime) |unknown
              js/console.log |js-ffi-node-smoke result
              if (contract/valid-runtime? |node runtime) (println |js-ffi-node-smoke-passed)
                do (eprintln |js-ffi-node-smoke-failed) (js/process.exit 1)
          :examples $ [] (quote "(main!)")
          :schema $ :: 'Fn
            {} (:return 'Dynamic)
              :args $ []
              :features $ #{} :js-ffi
        |reload! $ %{} 'CodeEntry (:doc "|Node entry reload hook. It is a no-op for the standalone smoke command. Example: (reload!)")
          :code $ quote
            defn reload! () nil
          :examples $ [] (quote "(reload!)")
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns js-ffi.node-test $ :require (js-ffi.node :as node) (js-ffi.contract :as contract)
