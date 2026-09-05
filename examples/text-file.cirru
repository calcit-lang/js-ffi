quote $ defn text-file (directory text)
  let
      target $ node/path-join directory |example.txt
    node/write-text! target text
    node/read-text! target
