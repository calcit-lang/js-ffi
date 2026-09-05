quote $ defn listen (event-name callback)
  browser/add-event-listener! event-name callback
  fn () $ browser/remove-event-listener! event-name callback
