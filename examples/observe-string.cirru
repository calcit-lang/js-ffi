quote $ defn observe-string! (host ready! failed!)
  shared/promise-observe! host
    fn (raw)
      hint-fn $ {} (:return 'Unit) (:features (#{} :js-ffi))
        :args $ [] $ :: 'JsNullish 'JsObject
      ready! $ contract/expect-string |Promise.payload raw
    fn (raw-error)
      hint-fn $ {} (:return 'Unit) (:features (#{} :js-ffi))
        :args $ [] $ :: 'JsNullish 'JsObject
      failed! $ shared/normalize-error raw-error
