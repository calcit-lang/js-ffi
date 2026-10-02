(kind, value) => {
  if (value === null || typeof value !== "object") return false;
  switch (kind) {
    case "element":
      return value.nodeType === 1 && typeof value.tagName === "string";
    case "event":
      return typeof value.type === "string" && typeof value.preventDefault === "function";
    case "keyboard-event":
      return typeof value.key === "string" && typeof value.preventDefault === "function";
    case "mouse-event":
      return typeof value.clientX === "number" && typeof value.button === "number";
    case "pointer-event":
      return typeof value.pointerId === "number" && typeof value.clientX === "number";
    case "selectable":
      return typeof value.setSelectionRange === "function" && typeof value.value === "string";
    default:
      return false;
  }
}
