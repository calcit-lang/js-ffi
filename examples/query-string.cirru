quote $ defn query-string (term)
  let
      params $ shared/search-params-create |page=1
    shared/search-params-set! params |q term
    shared/search-params-string params
