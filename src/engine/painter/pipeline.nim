import ../core/dom, pixie, chroma, vmath

var defaultFont*: Font

proc paint*(node: Node, ctx: Context) =
  if node.kind == nkElement:
    # 1. Paint Box Shadow (Gaussian Blur-like simplified with multiple layers)
    if node.style.boxShadowBlur > 0:
      let shadowColor = node.style.boxShadowColor
      for i in 1..int(node.style.boxShadowBlur / 2):
        ctx.fillStyle = Color(r: shadowColor.r, g: shadowColor.g, b: shadowColor.b, a: shadowColor.a / float32(i))
        ctx.fillRect(
          node.computedLayout.x - float32(i),
          node.computedLayout.y - float32(i),
          node.computedLayout.width + float32(i*2),
          node.computedLayout.height + float32(i*2)
        )

    # 2. Paint background with border-radius
    if node.style.backgroundColor.a > 0:
      ctx.fillStyle = node.style.backgroundColor
      if node.style.borderRadius > 0:
        ctx.fillRoundedRect(
          rect(node.computedLayout.x, node.computedLayout.y, node.computedLayout.width, node.computedLayout.height),
          node.style.borderRadius
        )
      else:
        ctx.fillRect(node.computedLayout.x, node.computedLayout.y, node.computedLayout.width, node.computedLayout.height)

    # 3. Recursively paint children
    for child in node.children:
      paint(child, ctx)

  elif node.kind == nkText:
    if node.style.color.a > 0:
      ctx.fillStyle = node.style.color
      if defaultFont != nil:
        defaultFont.size = 14
        ctx.image.fillText(defaultFont, node.text, translate(vec2(node.computedLayout.x, node.computedLayout.y)))
