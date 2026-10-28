quote $ defn observe-string! (host ready! failed!)
  shared/promise-observe! host
    fn (raw)
      hint-fn $ Fn (JsNullish JsObject) (-> Unit) (:features :js-ffi)
      ready! $ contract/expect-string |Promise.payload raw
    fn (raw-error)
      hint-fn $ Fn (JsNullish JsObject) (-> Unit) (:features :js-ffi)
      failed! $ shared/normalize-error raw-error
