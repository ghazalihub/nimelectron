import ../core/dom, pixie, chroma, vmath

var defaultFont*: Font

proc paint*(node: Node, ctx: Context) =
  # Handle complex transparency (opacity)
  let parentOpacity = if node.parent != nil: node.parent.style.opacity else: 1.0
  let currentOpacity = node.style.opacity * parentOpacity

  if node.kind == nkElement:
    # 1. Background
    if node.style.backgroundColor.a > 0:
      var bg = node.style.backgroundColor
      bg.a *= currentOpacity
      ctx.fillStyle = bg
      if node.style.borderRadius > 0:
        ctx.fillRoundedRect(
          rect(node.computedLayout.x, node.computedLayout.y, node.computedLayout.width, node.computedLayout.height),
          node.style.borderRadius
        )
      else:
        ctx.fillRect(node.computedLayout.x, node.computedLayout.y, node.computedLayout.width, node.computedLayout.height)

    # 2. Border
    if node.style.borderWidth > 0 and node.style.borderColor.a > 0:
      var bc = node.style.borderColor
      bc.a *= currentOpacity
      ctx.strokeStyle = bc
      ctx.lineWidth = node.style.borderWidth
      if node.style.borderRadius > 0:
        ctx.strokeRoundedRect(
          rect(node.computedLayout.x, node.computedLayout.y, node.computedLayout.width, node.computedLayout.height),
          node.style.borderRadius
        )
      else:
        ctx.strokeRect(rect(node.computedLayout.x, node.computedLayout.y, node.computedLayout.width, node.computedLayout.height))

    # 3. Recursively paint children
    for child in node.children:
      paint(child, ctx)

  elif node.kind == nkText:
    if node.style.color.a > 0:
      var tc = node.style.color
      tc.a *= currentOpacity
      ctx.fillStyle = tc
      if defaultFont != nil:
        defaultFont.size = 14
        ctx.image.fillText(defaultFont, node.text, translate(vec2(node.computedLayout.x, node.computedLayout.y)))
