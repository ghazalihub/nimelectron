import chroma, tables

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
    justifyContent*: string # "start", "center", "end", "space-between"
    alignItems*: string # "start", "center", "end", "stretch"
    flexGrow*: float32
    flexShrink*: float32
    flexBasis*: float32
    position*: string # "static", "relative", "absolute"
    top*, right*, bottom*, left*: float32
    overflow*: string # "visible", "hidden"
    opacity*: float32
    # Additional state properties (simplified for current engine scope)
    isHovered*: bool
    isActive*: bool
    isFocused*: bool

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
  Node(kind: nkElement, tagName: tagName, attributes: initTable[string, string](), style: Style(opacity: 1.0))

proc newTextNode*(text: string): Node =
  Node(kind: nkText, text: text, style: Style(opacity: 1.0))

proc addChild*(parent, child: Node) =
  child.parent = parent
  parent.children.add(child)
