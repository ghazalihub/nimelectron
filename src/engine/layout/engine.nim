import ../core/dom, tables, pixie, vmath, algorithm

proc computeLayout*(node: Node, x, y, maxWidth: float32) =
  # Improved Flexbox-lite with flex-grow
  node.computedLayout.x = x + node.style.marginLeft
  node.computedLayout.y = y + node.style.marginTop

  if node.style.position == "relative":
    node.computedLayout.x += node.style.left
    node.computedLayout.y += node.style.top

  var currentX = node.computedLayout.x + node.style.paddingLeft
  var currentY = node.computedLayout.y + node.style.paddingTop
  var maxChildWidth: float32 = 0
  var totalHeight: float32 = 0

  var flexItems: seq[Node] = @[]
  var totalFlexGrow: float32 = 0

  for child in node.children:
    if child.style.position != "absolute":
      flexItems.add(child)
      totalFlexGrow += child.style.flexGrow

  if node.style.flexDirection == "column" or node.style.flexDirection == "":
    for child in flexItems:
      var childMaxWidth = node.style.width - node.style.paddingLeft - node.style.paddingRight
      if childMaxWidth <= 0: childMaxWidth = maxWidth - node.style.paddingLeft - node.style.paddingRight

      computeLayout(child, currentX, currentY, childMaxWidth)
      currentY += child.computedLayout.height + child.style.marginTop + child.style.marginBottom
      totalHeight += child.computedLayout.height + child.style.marginTop + child.style.marginBottom
      maxChildWidth = max(maxChildWidth, child.computedLayout.width)
  elif node.style.flexDirection == "row":
    let availableWidth = if node.style.width > 0: node.style.width - node.style.paddingLeft - node.style.paddingRight else: maxWidth - node.style.paddingLeft - node.style.paddingRight
    for child in flexItems:
      var childWidth = child.style.width
      if totalFlexGrow > 0 and child.style.flexGrow > 0:
         childWidth = (child.style.flexGrow / totalFlexGrow) * availableWidth

      computeLayout(child, currentX, currentY, if childWidth > 0: childWidth else: availableWidth)
      currentX += child.computedLayout.width + child.style.marginLeft + child.style.marginRight
      maxChildWidth += child.computedLayout.width + child.style.marginLeft + child.style.marginRight
      totalHeight = max(totalHeight, child.computedLayout.height)

  # Finalize size
  if node.style.width > 0:
    node.computedLayout.width = node.style.width
  elif maxChildWidth > 0:
    node.computedLayout.width = maxChildWidth + node.style.paddingLeft + node.style.paddingRight
  elif node.kind == nkElement:
    node.computedLayout.width = maxWidth

  if node.style.height > 0:
    node.computedLayout.height = node.style.height
  elif totalHeight > 0:
    node.computedLayout.height = totalHeight + node.style.paddingTop + node.style.paddingBottom

  if node.kind == nkText:
    if node.style.width > 0:
       node.computedLayout.width = node.style.width
    else:
       node.computedLayout.width = float32(node.text.len * 8)

    if node.style.height > 0:
       node.computedLayout.height = node.style.height
    else:
       node.computedLayout.height = 16

  # Absolute positioning
  for child in node.children:
    if child.style.position == "absolute":
      computeLayout(child, node.computedLayout.x + child.style.left, node.computedLayout.y + child.style.top, maxWidth)
