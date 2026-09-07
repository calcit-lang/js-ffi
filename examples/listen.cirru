quote $ defn listen (event-name callback)
  browser/add-event-listener! event-name callback
  fn ()
    hint-fn $ {}
      :args $ []
      :return 'Unit
    browser/remove-event-listener! event-name callback
