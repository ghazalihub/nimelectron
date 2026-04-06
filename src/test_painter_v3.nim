import engine/core/dom, engine/layout/engine, engine/painter/pipeline, pixie, chroma, vmath

proc test() =
  let image = newImage(800, 600)
  let ctx = image.newContext()

  pipeline.defaultFont = readFont("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf")

  let root = newNode("div")
  root.style.width = 500
  root.style.height = 400
  root.style.backgroundColor = parseHtmlColor("#eee")
  root.style.borderColor = parseHtmlColor("#000")
  root.style.borderWidth = 2
  root.style.borderRadius = 10

  let inner = newNode("div")
  inner.style.width = 200
  inner.style.height = 100
  inner.style.backgroundColor = parseHtmlColor("red")
  inner.style.opacity = 0.5
  inner.style.marginLeft = 50
  inner.style.marginTop = 50
  root.addChild(inner)

  computeLayout(root, 10, 10, 800, 600)
  paint(root, ctx)
  echo "Painter V3 Test Passed"

test()
