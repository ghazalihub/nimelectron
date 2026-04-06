import ../core/dom, chroma, tables, strutils, algorithm

type
  SelectorKind* = enum
    skTag, skClass, skId

  Selector* = object
    kind*: SelectorKind
    name*: string
    specificity*: int

  StyleRule* = object
    selector*: Selector
    properties*: Table[string, string]

  StyleSheet* = seq[StyleRule]

proc parseSelector*(s: string): Selector =
  if s.startsWith("#"):
    result = Selector(kind: skId, name: s[1..^1], specificity: 100)
  elif s.startsWith("."):
    result = Selector(kind: skClass, name: s[1..^1], specificity: 10)
  else:
    result = Selector(kind: skTag, name: s, specificity: 1)

proc matches*(node: Node, selector: Selector): bool =
  if node.kind != nkElement: return false
  case selector.kind:
  of skTag:
    return node.tagName == selector.name
  of skClass:
    return selector.name in node.classes
  of skId:
    return node.id == selector.name

proc applyProperty*(style: var Style, key, value: string) =
  try:
    case key:
    of "color": style.color = parseHtmlColor(value)
    of "background-color": style.backgroundColor = parseHtmlColor(value)
    of "border-color": style.borderColor = parseHtmlColor(value)
    of "border-width": style.borderWidth = parseFloat(value)
    of "border-radius": style.borderRadius = parseFloat(value)
    of "width": style.width = parseFloat(value)
    of "height": style.height = parseFloat(value)
    of "padding":
      let v = parseFloat(value)
      style.paddingTop = v; style.paddingRight = v; style.paddingBottom = v; style.paddingLeft = v
    of "margin":
      let v = parseFloat(value)
      style.marginTop = v; style.marginRight = v; style.marginBottom = v; style.marginLeft = v
    of "flex-direction": style.flexDirection = value
    of "justify-content": style.justifyContent = value
    of "align-items": style.alignItems = value
    of "flex-grow": style.flexGrow = parseFloat(value)
    of "flex-shrink": style.flexShrink = parseFloat(value)
    of "flex-basis": style.flexBasis = parseFloat(value)
    of "position": style.position = value
    of "top": style.top = parseFloat(value)
    of "left": style.left = parseFloat(value)
    of "overflow": style.overflow = value
    of "opacity": style.opacity = parseFloat(value)
  except:
    discard

proc resolveStyle*(node: Node, sheet: StyleSheet) =
  # 1. Inheritance (color, opacity)
  if node.parent != nil:
    if node.style.color.a == 0:
       node.style.color = node.parent.style.color
    node.style.opacity = node.parent.style.opacity # Simple inheritance multiplication is better in a real engine

  # 2. Match rules and sort by specificity
  var matchedRules: seq[StyleRule] = @[]
  for rule in sheet:
    if node.matches(rule.selector):
      matchedRules.add(rule)

  matchedRules.sort(proc(x, y: StyleRule): int = cmp(x.selector.specificity, y.selector.specificity))

  for rule in matchedRules:
    for key, value in rule.properties:
      node.style.applyProperty(key, value)

  for child in node.children:
    resolveStyle(child, sheet)
