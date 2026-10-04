quote $ defn promise-string (text)
  shared/promise-create $ fn (resolve reject)
    hint-fn $ {} (:return 'Unit)
      :args $ []
        :: 'Fn $ {} (:return 'Unit) (:args ([] 'String))
        :: 'Fn $ {} (:return 'Unit) (:args ([] 'String))
    resolve text
    , &unit
