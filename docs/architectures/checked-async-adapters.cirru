{} (:schema-version 1) (:feature 'checked-async-adapters)
  :doc "|Checked async fetch, Response body, and Node UTF-8 filesystem boundaries. Logical return types are available only after js-await; failures are normalized to Result.err<JsError>."
  :roots $ #{} 'js-ffi.shared/fetch-response 'js-ffi.shared/response-text 'js-ffi.node/read-text-async! 'js-ffi.node/write-text-async!
  :definitions $ {}
    'js-ffi.shared/ResponseHost $ {} (:mode :ensure) (:kind :data)
      :doc "|External Response capability with metadata and an opaque Promise-like text-body reader consumed by response-text."
      :schema $ :: 'Trait
      :code $ quote
        deftrait ResponseHost (:status 'Number) (:status-text 'String) (:ok? 'Bool) (:url 'String) (:redirected? 'Bool) (:headers 'js-ffi.shared/HeadersHost) (:body-used? 'Bool)
          .text $ :: 'Fn $ {} (:args $ [] 'js-ffi.shared/ResponseHost) (:return 'JsObject)
    'js-ffi.shared/normalize-error $ {} (:mode :ensure) (:kind :fn)
      :doc "|Normalize a synchronous throw or Promise rejection into JsError."
      :schema $ :: 'Fn $ {} (:args $ [] (:: 'JsNullish 'JsObject)) (:return 'js-ffi.shared/JsError) (:features $ #{} :js-ffi)
      :params $ [] 'error
    'js-ffi.shared/response-host $ {} (:mode :ensure) (:kind :fn)
      :doc "|Validate a host Response object and expose its typed capability."
      :schema $ :: 'Fn $ {} (:args $ [] (:: 'JsNullish 'JsObject)) (:return 'js-ffi.shared/ResponseHost) (:features $ #{} :js-ffi)
      :params $ [] 'value
    'js-ffi.shared/fetch-response $ {} (:mode :ensure) (:kind :fn)
      :doc "|Await fetch exactly once and normalize synchronous throws or Promise rejections as Result.err."
      :schema $ :: 'Fn $ {} (:args $ [] 'String) (:return $ :: 'Result 'js-ffi.shared/ResponseHost 'js-ffi.shared/JsError) (:features $ #{} :js-ffi)
      :params $ [] 'url
    'js-ffi.shared/response-text $ {} (:mode :ensure) (:kind :fn)
      :doc "|Await Response.text exactly once and normalize synchronous throws or Promise rejections as Result.err."
      :schema $ :: 'Fn $ {} (:args $ [] 'js-ffi.shared/ResponseHost) (:return $ :: 'Result 'String 'js-ffi.shared/JsError) (:features $ #{} :js-ffi)
      :params $ [] 'response
    'js-ffi.node/read-text-async! $ {} (:mode :ensure) (:kind :fn)
      :doc "|Await node:fs/promises.readFile exactly once and return UTF-8 text or normalized JsError."
      :schema $ :: 'Fn $ {} (:args $ [] 'String) (:return $ :: 'Result 'String 'js-ffi.shared/JsError) (:features $ #{} :js-ffi)
      :params $ [] 'file-path
    'js-ffi.node/write-text-async! $ {} (:mode :ensure) (:kind :fn)
      :doc "|Await node:fs/promises.writeFile exactly once and return Unit or normalized JsError."
      :schema $ :: 'Fn $ {} (:args $ [] 'String 'String) (:return $ :: 'Result 'Unit 'js-ffi.shared/JsError) (:features $ #{} :js-ffi)
      :params $ [] 'file-path 'text
