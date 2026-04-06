import pixie, vmath, chroma, tables, strutils
import engine/core/dom, engine/style/resolver, engine/layout/engine, engine/painter/pipeline, engine/script/bridge

# Advanced Sciter Clone - Final Showcase
# Single static binary with high-performance ARC/ORC memory management

proc main() =
  echo "Starting Sciter Engine V2 (Advanced Architecture)..."

  # 1. Initialize Engine State
  let root = newNode("app")
  root.style.width = 1000
  root.style.height = 800
  root.style.backgroundColor = parseHtmlColor("#0a0a0a")
  root.style.flexDirection = "column"

  let scriptEngine = newScriptEngine(root)
  scriptEngine.registerBuiltins()

  try:
    pipeline.defaultFont = readFont("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf")
  except:
    echo "Warning: Default font not found"

  # 2. Build Complex UI

  # Navbar
  let nav = newNode("nav")
  nav.style.width = 1000
  nav.style.height = 80
  nav.style.backgroundColor = parseHtmlColor("#161616")
  nav.style.boxShadowBlur = 15
  nav.style.boxShadowColor = parseHtmlColor("#000")
  nav.style.flexDirection = "row"
  nav.style.paddingLeft = 40
  root.addChild(nav)

  let logo = newTextNode("SCITER-CLONE")
  logo.style.color = parseHtmlColor("#00ffcc")
  logo.style.marginTop = 30
  nav.addChild(logo)

  # Body with Sidebar
  let body = newNode("div")
  body.style.flexGrow = 1
  body.style.flexDirection = "row"
  root.addChild(body)

  let sidebar = newNode("div")
  sidebar.style.width = 250
  sidebar.style.backgroundColor = parseHtmlColor("#121212")
  sidebar.style.paddingTop = 20
  body.addChild(sidebar)

  for i in 1..8:
    let link = newNode("div")
    link.style.width = 210
    link.style.height = 40
    link.style.backgroundColor = parseHtmlColor("#1a1a1a")
    link.style.borderRadius = 8
    link.style.marginLeft = 20
    link.style.marginTop = 10
    sidebar.addChild(link)

    let linkText = newTextNode("Module " & $i)
    linkText.style.color = parseHtmlColor("#888")
    linkText.style.marginLeft = 15
    linkText.style.marginTop = 10
    link.addChild(linkText)

  # Main Content View
  let main = newNode("div")
  main.style.flexGrow = 1
  main.style.backgroundColor = parseHtmlColor("#0d0d0d")
  main.style.paddingLeft = 40
  main.style.paddingTop = 40
  body.addChild(main)

  let title = newTextNode("Dashboard Analytics")
  title.style.color = parseHtmlColor("#ffffff")
  main.addChild(title)

  # Responsive-like Grid
  let grid = newNode("div")
  grid.style.flexDirection = "row"
  grid.style.marginTop = 30
  main.addChild(grid)

  for i in 1..2:
    let card = newNode("div")
    card.attributes["id"] = "card" & $i
    card.style.width = 300
    card.style.height = 180
    card.style.backgroundColor = parseHtmlColor("#1c1c1c")
    card.style.borderRadius = 12
    card.style.marginRight = 20
    card.style.paddingLeft = 20
    card.style.paddingTop = 20
    grid.addChild(card)

    let ct = newTextNode("Metric " & $i)
    ct.style.color = parseHtmlColor("#666")
    card.addChild(ct)

  # 3. Dynamic Scripting Interactivity
  echo "Executing UI Scripts..."
  discard scriptEngine.eval("""
    print('Engine: Running dynamic script updates...');
    setElementStyle('card1', 'background-color', '#252525');
    setElementStyle('card1', 'border-radius', '20');
    setElementStyle('card2', 'background-color', '#2d2d2d');
    print('Engine: Dynamic styles applied.');
  """)

  # 4. Final Layout Pass
  echo "Final Layout Pass..."
  computeLayout(root, 0, 0, 1000)

  # 5. Final Paint Pass
  echo "Final Paint Pass..."
  let image = newImage(1000, 800)
  let ctx = image.newContext()
  paint(root, ctx)

  # 6. Save Output
  image.writeFile("sciter_v2_final.png")
  echo "Engine: Render complete. Output: sciter_v2_final.png"

  scriptEngine.free()
  echo "Engine Shutdown."

if isMainModule:
  main()
