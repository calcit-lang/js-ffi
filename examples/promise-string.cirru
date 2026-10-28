quote $ defn promise-string (text)
  shared/promise-create $ fn (resolve reject)
    hint-fn $ Fn (Fn String (-> Unit)) (Fn String (-> Unit)) (-> Unit)
    resolve text
    , &unit
