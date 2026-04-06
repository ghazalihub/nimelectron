import chroma, tables, strutils

type
  Style* = object
    color*: Color
    backgroundColor*: Color
    borderColor*: Color
    borderWidth*: float32
    borderRadius*: float32
    width*: float32
    height*: float32
    paddingTop*, paddingRight*, paddingBottom*, paddingLeft*: float32
    marginTop*, marginRight*, marginBottom*, marginLeft*: float32
    flexDirection*: string # "row", "column"
    justifyContent*: string # "start", "center", "end", "space-between", "space-around"
    alignItems*: string # "start", "center", "end", "stretch"
    flexGrow*: float32
    flexShrink*: float32
    flexBasis*: float32
    position*: string # "static", "relative", "absolute"
    top*, right*, bottom*, left*: float32
    overflow*: string # "visible", "hidden"
    opacity*: float32
    display*: string # "flex", "block", "inline", "none"

  NodeKind* = enum
    nkElement, nkText

  Node* = ref object
    kind*: NodeKind
    tagName*: string
    id*: string
    classes*: seq[string]
    attributes*: Table[string, string]
    text*: string
    children*: seq[Node]
    parent*: Node
    style*: Style
    computedLayout*: LayoutResult

  LayoutResult* = object
    x*, y*, width*, height*: float32

proc newNode*(tagName: string): Node =
  Node(
    kind: nkElement,
    tagName: tagName,
    classes: @[],
    attributes: initTable[string, string](),
    style: Style(opacity: 1.0, display: "flex")
  )

proc newTextNode*(text: string): Node =
  Node(
    kind: nkText,
    text: text,
    style: Style(opacity: 1.0, display: "inline")
  )

proc addChild*(parent, child: Node) =
  child.parent = parent
  parent.children.add(child)

proc getAttribute*(node: Node, name: string): string =
  node.attributes.getOrDefault(name, "")

proc setAttribute*(node: Node, name, value: string) =
  node.attributes[name] = value
  if name == "id": node.id = value
  elif name == "class":
    node.classes = value.splitWhitespace()

proc setPadding*(style: var Style, v: float32) =
  style.paddingTop = v; style.paddingRight = v; style.paddingBottom = v; style.paddingLeft = v

proc setMargin*(style: var Style, v: float32) =
  style.marginTop = v; style.marginRight = v; style.marginBottom = v; style.marginLeft = v
