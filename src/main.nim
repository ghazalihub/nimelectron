import pixie, vmath, chroma, tables, strutils
import engine/core/dom, engine/style/resolver, engine/layout/engine, engine/painter/pipeline, engine/script/bridge

# THE ULTIMATE SCITER CLONE - ADVANCED ENGINE SHOWCASE V5
# Single-Binary, Professional High-Performance UI Engine.

proc main() =
  echo "--- Initializing Ultimate Sciter Engine V5 (Professional Edition) ---"

  # 1. CORE ENGINE SETUP
  let root = newNode("body")
  root.id = "app-root"
  root.style.width = 1280
  root.style.height = 960
  root.style.backgroundColor = parseHtmlColor("#0a0f1e")
  root.style.flexDirection = "column"

  let engine = newScriptEngine(root)
  engine.registerBuiltins()

  try:
    pipeline.defaultFont = readFont("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf")
  except:
    echo "Warning: Default font not available."

  # 2. NAVIGATION BAR
  let nav = newNode("nav")
  nav.style.height = 70
  nav.style.backgroundColor = parseHtmlColor("#111827")
  nav.style.flexDirection = "row"
  nav.style.alignItems = "center"
  nav.style.setPadding(20)
  nav.style.boxShadowBlur = 10
  nav.style.boxShadowColor = parseHtmlColor("#000000")
  root.addChild(nav)

  let brand = newTextNode("SCITER ULTIMATE PRO")
  brand.style.color = parseHtmlColor("#60a5fa")
  brand.style.marginTop = 25
  nav.addChild(brand)

  # 3. WORKSPACE LAYOUT
  let workspace = newNode("div")
  workspace.style.flexGrow = 1
  workspace.style.flexDirection = "row"
  root.addChild(workspace)

  # SIDEBAR
  let sidebar = newNode("aside")
  sidebar.style.width = 240
  sidebar.style.backgroundColor = parseHtmlColor("#030712")
  sidebar.style.setPadding(20)
  workspace.addChild(sidebar)

  for label in ["DASHBOARD", "ANALYTICS", "NETWORK", "SECURITY", "SETTINGS"]:
    let item = newNode("div")
    item.style.height = 40
    item.style.setMargin(10)
    item.style.borderRadius = 6
    if label == "DASHBOARD": item.style.backgroundColor = parseHtmlColor("#1e293b")
    sidebar.addChild(item)
    let t = newTextNode(label)
    t.style.color = if label == "DASHBOARD": parseHtmlColor("white") else: parseHtmlColor("#4b5563")
    t.style.marginLeft = 15
    t.style.marginTop = 12
    item.addChild(t)

  # 4. CONTENT VIEW
  let content = newNode("main")
  content.style.flexGrow = 1
  content.style.setPadding(40)
  content.style.flexDirection = "column"
  workspace.addChild(content)

  let header = newTextNode("System Intelligence Feed")
  header.style.color = parseHtmlColor("white")
  content.addChild(header)

  # DASHBOARD GRID
  let grid = newNode("div")
  grid.style.flexDirection = "row"
  grid.style.marginTop = 40
  content.addChild(grid)

  for i in 1..3:
    let card = newNode("div")
    card.id = "stat-card-" & $i
    card.style.width = 300
    card.style.height = 160
    card.style.backgroundColor = parseHtmlColor("#111827")
    card.style.borderRadius = 12
    card.style.setPadding(24)
    card.style.marginRight = 20
    card.style.borderColor = parseHtmlColor("#1f2937")
    card.style.borderWidth = 1
    grid.addChild(card)

    let l = newTextNode("Node Cluster " & $i)
    l.style.color = parseHtmlColor("#9ca3af")
    card.addChild(l)

    # Progress Bar
    let pbBg = newNode("div")
    pbBg.style.width = 250
    pbBg.style.height = 10
    pbBg.style.backgroundColor = parseHtmlColor("#030712")
    pbBg.style.borderRadius = 5
    pbBg.style.marginTop = 40
    card.addChild(pbBg)

    let pbFill = newNode("div")
    pbFill.id = "progress-" & $i
    pbFill.style.width = float32(80 + i * 40)
    pbFill.style.height = 10
    pbFill.style.backgroundColor = parseHtmlColor("#60a5fa")
    pbFill.style.borderRadius = 5
    pbBg.addChild(pbFill)

  # 5. INPUTS AND CONTROLS
  let controls = newNode("div")
  controls.style.marginTop = 60
  controls.style.flexDirection = "row"
  content.addChild(controls)

  let deployBtn = newNode("button")
  deployBtn.id = "deploy-btn"
  deployBtn.style.width = 180
  deployBtn.style.height = 45
  deployBtn.style.backgroundColor = parseHtmlColor("#2563eb")
  deployBtn.style.borderRadius = 8
  controls.addChild(deployBtn)
  let btnText = newTextNode("DEPLOY SYSTEM")
  btnText.style.color = parseHtmlColor("white")
  btnText.style.marginTop = 14
  btnText.style.marginLeft = 30
  deployBtn.addChild(btnText)

  # 6. DYNAMIC SCRIPTING
  echo "Executing Scripting Pass..."
  discard engine.eval("""
    print('Engine: Link Established.');
    function onMouseEvent(x, y, btn, pressed) {
      if (pressed) {
        print('Signal: User interaction intercepted by QuickJS.');
        setStyle('progress-1', 'width', '250');
        setStyle('progress-1', 'background-color', '#10b981');
        setStyle('deploy-btn', 'background-color', '#059669');
        setStyle('stat-card-1', 'box-shadow-blur', '15');
        setStyle('stat-card-1', 'box-shadow-color', '#10b981');
        print('Action: Dynamic UI mutation complete.');
      }
    }
  """)

  # Trigger event to show dynamic state
  engine.injectMouseEvent(640, 480, 0, true)

  # 7. FINAL RENDER PIPELINE
  echo "Running Advanced Multi-Pass Layout..."
  measureNode(root, 1280)
  computeLayout(root, 0, 0, 1280, 960)

  echo "Running High-Fidelity Painter..."
  let image = newImage(1280, 960)
  let ctx = image.newContext()
  paint(root, ctx)

  image.writeFile("sciter_v5_pro_render.png")
  echo "Success: Ultimate Showcase generated: sciter_v5_pro_render.png"

  bridge.free(engine)

if isMainModule:
  main()
