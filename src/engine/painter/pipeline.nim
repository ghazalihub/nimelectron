import ../core/dom, pixie, chroma, vmath

var defaultFont*: Font

proc paint*(node: Node, ctx: Context) =
  if node.style.display == "none": return

  let parentOpacity = if node.parent != nil: node.parent.style.opacity else: 1.0
  let curOpacity = node.style.opacity * parentOpacity

  if node.kind == nkElement:
    # Handle Box Shadow
    if node.style.boxShadowBlur > 0:
      let shadowColor = node.style.boxShadowColor
      for i in 1..int(node.style.boxShadowBlur / 2):
        ctx.fillStyle = Color(r: shadowColor.r, g: shadowColor.g, b: shadowColor.b, a: shadowColor.a / float32(i))
        ctx.fillRoundedRect(
          rect(node.computedLayout.x - float32(i), node.computedLayout.y - float32(i), node.computedLayout.width + float32(i*2), node.computedLayout.height + float32(i*2)),
          node.style.borderRadius
        )

    # Handle Background (fillPath)
    if node.style.backgroundColor.a > 0:
      var bg = node.style.backgroundColor
      bg.a *= curOpacity
      ctx.fillStyle = bg
      if node.style.borderRadius > 0:
        ctx.fillRoundedRect(
          rect(node.computedLayout.x, node.computedLayout.y, node.computedLayout.width, node.computedLayout.height),
          node.style.borderRadius
        )
      else:
        ctx.fillRect(node.computedLayout.x, node.computedLayout.y, node.computedLayout.width, node.computedLayout.height)

    # Handle Border (strokePath)
    if node.style.borderWidth > 0 and node.style.borderColor.a > 0:
      var bc = node.style.borderColor
      bc.a *= curOpacity
      ctx.strokeStyle = bc
      ctx.lineWidth = node.style.borderWidth
      if node.style.borderRadius > 0:
        ctx.strokeRoundedRect(
          rect(node.computedLayout.x, node.computedLayout.y, node.computedLayout.width, node.computedLayout.height),
          node.style.borderRadius
        )
      else:
        ctx.strokeRect(rect(node.computedLayout.x, node.computedLayout.y, node.computedLayout.width, node.computedLayout.height))

    # Support overflow: hidden with masking
    if node.style.overflow == "hidden":
       # In a real engine we'd push a clipping mask here
       discard

    for child in node.children:
      paint(child, ctx)

  elif node.kind == nkText:
    if node.style.color.a > 0:
      var tc = node.style.color
      tc.a *= curOpacity
      ctx.fillStyle = tc
      if defaultFont != nil:
        defaultFont.size = 14
        ctx.image.fillText(defaultFont, node.text, translate(vec2(node.computedLayout.x, node.computedLayout.y)))
