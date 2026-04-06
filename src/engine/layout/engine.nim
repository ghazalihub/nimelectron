import ../core/dom, tables, pixie, vmath, algorithm

# Professional Multi-Pass Flexbox-lite Layout Engine

proc measureNode*(node: Node, maxWidth: float32) =
  # Pass 1: Intrinsic sizing
  if node.style.display == "none":
    node.computedLayout.width = 0
    node.computedLayout.height = 0
    return

  if node.kind == nkText:
    node.computedLayout.width = float32(node.text.len * 8) # Simplified, real uses font metrics
    node.computedLayout.height = 16
    return

  var maxChildWidth: float32 = 0
  var totalChildHeight: float32 = 0
  var totalChildWidth: float32 = 0
  var maxChildHeight: float32 = 0

  for child in node.children:
    if child.style.display != "none" and child.style.position != "absolute":
      measureNode(child, maxWidth)
      maxChildWidth = max(maxChildWidth, child.computedLayout.width + child.style.marginLeft + child.style.marginRight)
      totalChildHeight += child.computedLayout.height + child.style.marginTop + child.style.marginBottom
      totalChildWidth += child.computedLayout.width + child.style.marginLeft + child.style.marginRight
      maxChildHeight = max(maxChildHeight, child.computedLayout.height + child.style.marginTop + child.style.marginBottom)

  if node.style.width > 0:
    node.computedLayout.width = node.style.width
  else:
    node.computedLayout.width = if node.style.flexDirection == "row": totalChildWidth else: maxChildWidth
    node.computedLayout.width += node.style.paddingLeft + node.style.paddingRight

  if node.style.height > 0:
    node.computedLayout.height = node.style.height
  else:
    node.computedLayout.height = if node.style.flexDirection == "column": totalChildHeight else: maxChildHeight
    node.computedLayout.height += node.style.paddingTop + node.style.paddingBottom

proc computeLayout*(node: Node, x, y, maxWidth, maxHeight: float32) =
  # Pass 2: Positioning and space distribution
  if node.style.display == "none": return

  node.computedLayout.x = x + node.style.marginLeft
  node.computedLayout.y = y + node.style.marginTop

  if node.style.position == "relative":
    node.computedLayout.x += node.style.left
    node.computedLayout.y += node.style.top

  # Finalize node size based on constraints
  if node.style.width == 0:
    node.computedLayout.width = max(node.computedLayout.width, maxWidth - node.style.marginLeft - node.style.marginRight)
  if node.style.height == 0:
    node.computedLayout.height = max(node.computedLayout.height, maxHeight)

  var contentX = node.computedLayout.x + node.style.paddingLeft
  var contentY = node.computedLayout.y + node.style.paddingTop
  let availableWidth = node.computedLayout.width - node.style.paddingLeft - node.style.paddingRight
  let availableHeight = node.computedLayout.height - node.style.paddingTop - node.style.paddingBottom

  var flexItems: seq[Node] = @[]
  var totalFlexGrow: float32 = 0
  var usedMainSpace: float32 = 0

  for child in node.children:
    if child.style.display != "none" and child.style.position != "absolute":
      flexItems.add(child)
      totalFlexGrow += child.style.flexGrow
      if node.style.flexDirection == "row":
        usedMainSpace += child.computedLayout.width + child.style.marginLeft + child.style.marginRight
      else:
        usedMainSpace += child.computedLayout.height + child.style.marginTop + child.style.marginBottom

  let freeMainSpace = (if node.style.flexDirection == "row": availableWidth else: availableHeight) - usedMainSpace
  var currentX = contentX
  var currentY = contentY

  for child in flexItems:
    var childWidth = child.computedLayout.width
    var childHeight = child.computedLayout.height

    if totalFlexGrow > 0 and child.style.flexGrow > 0:
      let grow = (child.style.flexGrow / totalFlexGrow) * max(0.0, freeMainSpace)
      if node.style.flexDirection == "row":
        childWidth += grow
      else:
        childHeight += grow

    # Recurse with finalized constraints
    computeLayout(child, currentX, currentY, childWidth, childHeight)

    if node.style.flexDirection == "row":
      currentX += child.computedLayout.width + child.style.marginLeft + child.style.marginRight
    else:
      currentY += child.computedLayout.height + child.style.marginTop + child.style.marginBottom

  # Absolute Positioning Pass
  for child in node.children:
    if child.style.position == "absolute":
      computeLayout(child, node.computedLayout.x + child.style.left, node.computedLayout.y + child.style.top, child.computedLayout.width, child.computedLayout.height)
