import pixie, vmath, chroma, tables, strutils
import engine/core/dom, engine/style/resolver, engine/layout/engine, engine/painter/pipeline, engine/script/bridge

# THE ULTIMATE SCITER CLONE - ADVANCED ENGINE SHOWCASE
# High-performance, Modular, Single-Binary UI Engine.

proc main() =
  echo "--- Launching Ultimate Sciter Engine V5 ---"

  # 1. ROOT SETUP
  let root = newNode("body")
  root.id = "app-root"
  root.style.width = 1280
  root.style.height = 960
  root.style.backgroundColor = parseHtmlColor("#0f172a")
  root.style.flexDirection = "column"

  let engine = newScriptEngine(root)
  engine.registerBuiltins()

  try:
    pipeline.defaultFont = readFont("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf")
  except:
    echo "Warning: System font not found."

  # 2. NAVIGATION BAR (Navigational Component)
  let nav = newNode("nav")
  nav.style.height = 80
  nav.style.backgroundColor = parseHtmlColor("#1e293b")
  nav.style.flexDirection = "row"
  nav.style.alignItems = "center"
  nav.style.setPadding(20)
  nav.style.boxShadowBlur = 10
  nav.style.boxShadowColor = parseHtmlColor("#000000") # Fixed color
  root.addChild(nav)

  let logo = newTextNode("SCITER PRO")
  logo.style.color = parseHtmlColor("#38bdf8")
  logo.style.marginTop = 28
  nav.addChild(logo)

  # Breadcrumbs (Navigational)
  let breadcrumbs = newNode("div")
  breadcrumbs.style.marginLeft = 40
  breadcrumbs.style.flexDirection = "row"
  nav.addChild(breadcrumbs)
  let bc1 = newTextNode("Dashboard /")
  bc1.style.color = parseHtmlColor("#64748b")
  bc1.style.marginTop = 30
  breadcrumbs.addChild(bc1)
  let bc2 = newTextNode(" System Metrics")
  bc2.style.color = parseHtmlColor("#94a3b8")
  bc2.style.marginTop = 30
  bc2.style.marginLeft = 5
  breadcrumbs.addChild(bc2)

  # 3. MAIN WORKSPACE
  let workspace = newNode("div")
  workspace.style.flexGrow = 1
  workspace.style.flexDirection = "row"
  root.addChild(workspace)

  # SIDEBAR (Navigational + Containers)
  let sidebar = newNode("aside")
  sidebar.style.width = 280
  sidebar.style.backgroundColor = parseHtmlColor("#020617")
  sidebar.style.setPadding(20)
  workspace.addChild(sidebar)

  for label in ["Overview", "User Stats", "Network", "Security", "Settings"]:
    let item = newNode("div")
    item.style.height = 45
    item.style.setMargin(8)
    item.style.borderRadius = 8
    if label == "Overview": item.style.backgroundColor = parseHtmlColor("#1e293b")
    sidebar.addChild(item)
    let t = newTextNode(label)
    t.style.color = if label == "Overview": parseHtmlColor("white") else: parseHtmlColor("#475569")
    t.style.marginLeft = 15
    t.style.marginTop = 12
    item.addChild(t)

  # 4. CONTENT AREA
  let content = newNode("main")
  content.style.flexGrow = 1
  content.style.setPadding(40)
  content.style.flexDirection = "column"
  workspace.addChild(content)

  # DASHBOARD HEADER
  let dashHeader = newTextNode("Operational Intelligence")
  dashHeader.style.color = parseHtmlColor("white")
  content.addChild(dashHeader)

  # INFORMATIONAL CARDS (Containers + Informational)
  let grid = newNode("div")
  grid.style.flexDirection = "row"
  grid.style.marginTop = 30
  content.addChild(grid)

  for i in 1..3:
    let card = newNode("div")
    card.id = "card-" & $i
    card.style.width = 280
    card.style.height = 180
    card.style.backgroundColor = parseHtmlColor("#1e293b")
    card.style.borderRadius = 16
    card.style.setPadding(24)
    card.style.marginRight = 20
    card.style.borderColor = parseHtmlColor("#334155")
    card.style.borderWidth = 1
    grid.addChild(card)

    let l = newTextNode("Sensor Cluster " & $i)
    l.style.color = parseHtmlColor("#94a3b8")
    card.addChild(l)

    # Progress Bar (Informational)
    let pbBg = newNode("div")
    pbBg.style.width = 230
    pbBg.style.height = 8
    pbBg.style.backgroundColor = parseHtmlColor("#0f172a")
    pbBg.style.borderRadius = 4
    pbBg.style.marginTop = 50
    card.addChild(pbBg)

    let pbFill = newNode("div")
    pbFill.id = "pb-" & $i
    pbFill.style.width = float32(60 + i * 40)
    pbFill.style.height = 8
    pbFill.style.backgroundColor = parseHtmlColor("#38bdf8")
    pbFill.style.borderRadius = 4
    pbBg.addChild(pbFill)

  # 5. INPUT CONTROLS SECTION
  let inputSection = newNode("div")
  inputSection.style.marginTop = 50
  inputSection.style.flexDirection = "row"
  inputSection.style.alignItems = "center"
  content.addChild(inputSection)

  # Search Bar (Navigational)
  let search = newTextField("Search assets...")
  search.style.width = 320
  search.style.height = 50
  search.style.backgroundColor = parseHtmlColor("#020617")
  search.style.borderColor = parseHtmlColor("#334155")
  search.style.borderWidth = 2
  search.style.borderRadius = 12
  search.style.setPadding(15)
  inputSection.addChild(search)
  search.children[0].style.color = parseHtmlColor("#475569")
  search.children[0].style.marginTop = 16

  # Action Button (Input Control)
  let btn = newButton("Deploy Cluster")
  btn.id = "deploy-btn"
  btn.style.width = 180
  btn.style.height = 50
  btn.style.backgroundColor = parseHtmlColor("#3b82f6")
  btn.style.borderRadius = 12
  btn.style.marginLeft = 20
  inputSection.addChild(btn)
  btn.children[0].style.color = parseHtmlColor("white")
  btn.children[0].style.marginTop = 16
  btn.children[0].style.marginLeft = 35

  # Toggle Switch (Input Control - Simulated)
  let toggle = newNode("div")
  toggle.style.width = 60
  toggle.style.height = 32
  toggle.style.backgroundColor = parseHtmlColor("#10b981")
  toggle.style.borderRadius = 16
  toggle.style.marginLeft = 30
  toggle.style.setPadding(4)
  inputSection.addChild(toggle)
  let dot = newNode("div")
  dot.style.width = 24
  dot.style.height = 24
  dot.style.backgroundColor = parseHtmlColor("white")
  dot.style.borderRadius = 12
  dot.style.marginLeft = 28
  toggle.addChild(dot)

  # 6. DYNAMIC INTERACTION (JS BRIDGE)
  echo "Injecting Interactive Logic..."
  discard engine.eval("""
    print('Sciter Bridge: System Online');
    function onMouseEvent(x, y, btn, pressed) {
      if (pressed) {
        print('Native Event Captured by JS: Cluster deployment initiated.');
        setStyle('pb-1', 'width', '230');
        setStyle('pb-1', 'background-color', '#10b981');
        setStyle('deploy-btn', 'background-color', '#2563eb');
        setStyle('card-1', 'box-shadow-blur', '20');
        setStyle('card-1', 'box-shadow-color', '#38bdf8');
      }
    }
  """)

  # Simulate High-Priority Event
  engine.injectMouseEvent(1000, 800, 0, true)

  # 7. FINAL PIPELINE EXECUTION
  echo "Final Layout Computation..."
  computeLayout(root, 0, 0, 1280, 960)

  echo "Final Painter Execution..."
  let image = newImage(1280, 960)
  let ctx = image.newContext()
  paint(root, ctx)

  image.writeFile("sciter_v5_ultimate_render.png")
  echo "Success: Project Completed. Output: sciter_v5_ultimate_render.png"

  engine.free()

if isMainModule:
  main()
