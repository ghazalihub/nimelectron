import pixie, vmath, chroma, tables, strutils
import engine/core/dom, engine/style/resolver, engine/layout/engine, engine/painter/pipeline, engine/script/bridge

# Ultimate Sciter Clone Showcase
# Architected for modularity, high performance (ARC/ORC), and advanced UI features.

proc main() =
  echo "--- Sciter Engine Showcase Starting ---"

  # 1. Initialize DOM Tree
  let root = newNode("body")
  root.id = "app"
  root.style.width = 1024
  root.style.height = 768
  root.style.backgroundColor = parseHtmlColor("#121212")
  root.style.flexDirection = "column"

  # Navigation Bar
  let nav = newNode("nav")
  nav.style.height = 70
  nav.style.backgroundColor = parseHtmlColor("#1f1f1f")
  nav.style.flexDirection = "row"
  nav.style.paddingLeft = 30
  root.addChild(nav)

  let brand = newTextNode("SCITER ENGINE V3")
  brand.style.color = parseHtmlColor("#03dac6")
  brand.style.marginTop = 25
  nav.addChild(brand)

  # Main Layout
  let container = newNode("div")
  container.style.flexGrow = 1
  container.style.flexDirection = "row"
  root.addChild(container)

  # Sidebar
  let sidebar = newNode("div")
  sidebar.style.width = 240
  sidebar.style.backgroundColor = parseHtmlColor("#181818")
  sidebar.style.paddingTop = 20
  container.addChild(sidebar)

  for i in 1..5:
    let btn = newNode("div")
    btn.id = "btn-" & $i
    btn.style.width = 200
    btn.style.height = 40
    btn.style.backgroundColor = parseHtmlColor("#2c2c2c")
    btn.style.borderRadius = 5
    btn.style.marginLeft = 20
    btn.style.marginTop = 10
    sidebar.addChild(btn)

    let txt = newTextNode("Dashboard Module " & $i)
    txt.style.color = parseHtmlColor("#888")
    txt.style.marginLeft = 15
    txt.style.marginTop = 12
    btn.addChild(txt)

  # Content
  let content = newNode("div")
  content.id = "main-content"
  content.style.flexGrow = 1
  content.style.backgroundColor = parseHtmlColor("#121212")
  content.style.paddingLeft = 40
  content.style.paddingTop = 40
  container.addChild(content)

  let header = newTextNode("Active Performance Metrics")
  header.style.color = parseHtmlColor("#ffffff")
  content.addChild(header)

  # Performance Cards
  let grid = newNode("div")
  grid.style.flexDirection = "row"
  grid.style.marginTop = 30
  content.addChild(grid)

  for i in 1..2:
    let card = newNode("div")
    card.id = "card-" & $i
    card.style.width = 300
    card.style.height = 150
    card.style.backgroundColor = parseHtmlColor("#1e1e1e")
    card.style.borderRadius = 12
    card.style.borderColor = parseHtmlColor("#333")
    card.style.borderWidth = 1
    card.style.marginRight = 20
    grid.addChild(card)

  # 2. Integrate Scripting
  let engine = newScriptEngine(root)
  engine.registerBuiltins()

  echo "Executing Scripts..."
  discard engine.eval("""
    print('Sciter: Engine fully loaded.');
    function onMouseEvent(x, y, btn, pressed) {
       if (pressed) {
         print('Interacting with native DOM...');
         setStyle('card-1', 'background-color', '#bb86fc');
         setStyle('card-2', 'opacity', '0.7');
         print('UI state updated via JS callback.');
       }
    }
  """)

  # 3. Simulate User Interaction
  echo "Simulating click event..."
  engine.injectMouseEvent(500, 500, 0, true)

  # 4. Final Processing and Rendering
  echo "Running Layout Pipeline..."
  computeLayout(root, 0, 0, 1024, 768)

  echo "Running Painting Pipeline..."
  try:
    pipeline.defaultFont = readFont("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf")
  except:
    echo "Warning: Font not found, skipping text rendering"

  let image = newImage(1024, 768)
  let ctx = image.newContext()
  paint(root, ctx)

  image.writeFile("sciter_v3_final_showcase.png")
  echo "Showcase image generated: sciter_v3_final_showcase.png"

  engine.free()
  echo "--- Showcase Finished ---"

if isMainModule:
  main()
