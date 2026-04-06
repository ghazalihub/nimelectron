import ../core/dom, tables, pixie, vmath, algorithm

proc computeLayout*(node: Node, x, y, maxWidth, maxHeight: float32) =
  node.computedLayout.x = x + node.style.marginLeft
  node.computedLayout.y = y + node.style.marginTop

  if node.style.position == "relative":
    node.computedLayout.x += node.style.left
    node.computedLayout.y += node.style.top

  # Final width/height to be used for children
  if node.style.width > 0:
    node.computedLayout.width = node.style.width
  else:
    node.computedLayout.width = maxWidth - node.style.marginLeft - node.style.marginRight

  if node.style.height > 0:
    node.computedLayout.height = node.style.height
  else:
    node.computedLayout.height = maxHeight # Simplified

  var contentX = node.computedLayout.x + node.style.paddingLeft
  var contentY = node.computedLayout.y + node.style.paddingTop
  let availableWidth = node.computedLayout.width - node.style.paddingLeft - node.style.paddingRight

  var flexItems: seq[Node] = @[]
  var totalFlexGrow: float32 = 0
  var fixedWidth: float32 = 0

  for child in node.children:
    if child.style.position != "absolute":
      flexItems.add(child)
      totalFlexGrow += child.style.flexGrow
      if child.style.width > 0:
        fixedWidth += child.style.width + child.style.marginLeft + child.style.marginRight

  let growableWidth = availableWidth - fixedWidth
  var currentX = contentX
  var currentY = contentY

  if node.style.flexDirection == "column" or node.style.flexDirection == "":
    for child in flexItems:
      computeLayout(child, currentX, currentY, availableWidth, 0)
      currentY += child.computedLayout.height + child.style.marginTop + child.style.marginBottom
  elif node.style.flexDirection == "row":
    for child in flexItems:
      var childW = child.style.width
      if totalFlexGrow > 0 and child.style.flexGrow > 0:
        childW = (child.style.flexGrow / totalFlexGrow) * growableWidth

      computeLayout(child, currentX, currentY, if childW > 0: childW else: availableWidth, 0)
      currentX += child.computedLayout.width + child.style.marginLeft + child.style.marginRight

  # Absolute positioning
  for child in node.children:
    if child.style.position == "absolute":
      computeLayout(child, node.computedLayout.x + child.style.left, node.computedLayout.y + child.style.top, node.computedLayout.width, node.computedLayout.height)

  if node.kind == nkText:
    if node.style.width > 0: node.computedLayout.width = node.style.width
    else: node.computedLayout.width = float32(node.text.len * 8)
    node.computedLayout.height = 16
