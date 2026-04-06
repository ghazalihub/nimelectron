import ../core/dom, tables, pixie, vmath, algorithm

proc computeLayout*(node: Node, x, y, maxWidth, maxHeight: float32) =
  if node.style.display == "none": return

  node.computedLayout.x = x + node.style.marginLeft
  node.computedLayout.y = y + node.style.marginTop

  if node.style.position == "relative":
    node.computedLayout.x += node.style.left
    node.computedLayout.y += node.style.top

  # Base dimensions
  if node.style.width > 0:
    node.computedLayout.width = node.style.width
  else:
    node.computedLayout.width = maxWidth - node.style.marginLeft - node.style.marginRight

  if node.style.height > 0:
    node.computedLayout.height = node.style.height
  else:
    node.computedLayout.height = maxHeight # Simplified, real engine would auto-size

  var contentX = node.computedLayout.x + node.style.paddingLeft
  var contentY = node.computedLayout.y + node.style.paddingTop
  let availW = node.computedLayout.width - node.style.paddingLeft - node.style.paddingRight

  var flexItems: seq[Node] = @[]
  var totalGrow: float32 = 0
  var fixedW: float32 = 0

  for child in node.children:
    if child.style.display != "none" and child.style.position != "absolute":
      flexItems.add(child)
      totalGrow += child.style.flexGrow
      if child.style.width > 0:
        fixedW += child.style.width + child.style.marginLeft + child.style.marginRight

  let growW = availW - fixedW
  var curX = contentX
  var curY = contentY

  if node.style.flexDirection == "column" or node.style.flexDirection == "":
    for child in flexItems:
      computeLayout(child, curX, curY, availW, 0)
      curY += child.computedLayout.height + child.style.marginTop + child.style.marginBottom
  elif node.style.flexDirection == "row":
    for child in flexItems:
      var cw = child.style.width
      if totalGrow > 0 and child.style.flexGrow > 0:
        cw = (child.style.flexGrow / totalGrow) * growW
      computeLayout(child, curX, curY, if cw > 0: cw else: availW, 0)
      curX += child.computedLayout.width + child.style.marginLeft + child.style.marginRight

  # Absolute
  for child in node.children:
    if child.style.position == "absolute":
      computeLayout(child, node.computedLayout.x + child.style.left, node.computedLayout.y + child.style.top, node.computedLayout.width, node.computedLayout.height)

  if node.kind == nkText:
    if node.style.width > 0: node.computedLayout.width = node.style.width
    else: node.computedLayout.width = float32(node.text.len * 8)
    node.computedLayout.height = 16
