import pixie, vmath, chroma, tables, strutils
import engine/core/dom, engine/style/resolver, engine/layout/engine, engine/painter/pipeline, engine/script/bridge

# Ultimate Sciter Clone Showcase
# Complete set of UI elements: Input Controls, Navigation, Information, and Containers.

proc main() =
  echo "--- Initializing Ultimate Sciter Engine ---"

  # 1. Core State
  let root = newNode("body")
  root.id = "app"
  root.style.width = 1200
  root.style.height = 900
  root.style.backgroundColor = parseHtmlColor("#0f172a")
  root.style.flexDirection = "column"

  let engine = newScriptEngine(root)
  engine.registerBuiltins()

  try:
    pipeline.defaultFont = readFont("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf")
  except:
    echo "Font warning"

  # 2. Navigation Component
  let nav = newNode("nav")
  nav.style.height = 80
  nav.style.backgroundColor = parseHtmlColor("#1e293b")
  nav.style.flexDirection = "row"
  nav.style.alignItems = "center"
  nav.style.paddingLeft = 40
  root.addChild(nav)

  let logo = newTextNode("SCITER ULTIMATE")
  logo.style.color = parseHtmlColor("#38bdf8")
  nav.addChild(logo)

  # 3. Main Container
  let main = newNode("div")
  main.style.flexGrow = 1
  main.style.flexDirection = "row"
  root.addChild(main)

  # Sidebar (Navigational)
  let sidebar = newNode("aside")
  sidebar.style.width = 280
  sidebar.style.backgroundColor = parseHtmlColor("#0f172a")
  sidebar.style.borderColor = parseHtmlColor("#334155")
  sidebar.style.borderWidth = 1
  sidebar.style.paddingTop = 20
  main.addChild(sidebar)

  for i in 1..6:
    let item = newNode("div")
    item.style.height = 45
    item.style.marginLeft = 20
    item.style.marginRight = 20
    item.style.marginTop = 10
    item.style.borderRadius = 8
    if i == 1:
       item.style.backgroundColor = parseHtmlColor("#334155")
    sidebar.addChild(item)

    let label = newTextNode("Menu Option " & $i)
    label.style.color = if i == 1: parseHtmlColor("white") else: parseHtmlColor("#94a3b8")
    label.style.marginLeft = 15
    label.style.marginTop = 12
    item.addChild(label)

  # Content Area
  let content = newNode("main")
  content.style.flexGrow = 1
  content.style.setPadding(40)
  content.style.flexDirection = "column"
  main.addChild(content)

  # 4. UI Elements Showcase

  # Row 1: Informational (Progress Bar, Cards)
  let row1 = newNode("div")
  row1.style.flexDirection = "row"
  content.addChild(row1)

  let card = newNode("div")
  card.style.width = 400
  card.style.height = 200
  card.style.backgroundColor = parseHtmlColor("#1e293b")
  card.style.borderRadius = 16
  card.style.setPadding(24)
  card.style.marginRight = 30
  row1.addChild(card)

  let cardTitle = newTextNode("System Performance")
  cardTitle.style.color = parseHtmlColor("white")
  card.addChild(cardTitle)

  let progressBarBg = newNode("div")
  progressBarBg.style.width = 350
  progressBarBg.style.height = 12
  progressBarBg.style.backgroundColor = parseHtmlColor("#334155")
  progressBarBg.style.borderRadius = 6
  progressBarBg.style.marginTop = 40
  card.addChild(progressBarBg)

  let progressBarFill = newNode("div")
  progressBarFill.id = "perf-progress"
  progressBarFill.style.width = 250 # 70%
  progressBarFill.style.height = 12
  progressBarFill.style.backgroundColor = parseHtmlColor("#38bdf8")
  progressBarFill.style.borderRadius = 6
  progressBarBg.addChild(progressBarFill)

  # Row 2: Input Controls (Buttons, Inputs)
  let row2 = newNode("div")
  row2.style.flexDirection = "row"
  row2.style.marginTop = 40
  content.addChild(row2)

  let button = newNode("button")
  button.id = "action-btn"
  button.style.width = 160
  button.style.height = 50
  button.style.backgroundColor = parseHtmlColor("#3b82f6")
  button.style.borderRadius = 10
  button.style.justifyContent = "center"
  button.style.alignItems = "center"
  button.style.marginRight = 20
  row2.addChild(button)

  let btnTxt = newTextNode("Click Me")
  btnTxt.style.color = parseHtmlColor("white")
  btnTxt.style.marginLeft = 45 # Center manual for now
  btnTxt.style.marginTop = 16
  button.addChild(btnTxt)

  let textField = newNode("input")
  textField.style.width = 300
  textField.style.height = 50
  textField.style.backgroundColor = parseHtmlColor("#0f172a")
  textField.style.borderColor = parseHtmlColor("#334155")
  textField.style.borderWidth = 2
  textField.style.borderRadius = 10
  textField.style.paddingLeft = 15
  row2.addChild(textField)

  let inputPlaceholder = newTextNode("Search metrics...")
  inputPlaceholder.style.color = parseHtmlColor("#475569")
  inputPlaceholder.style.marginTop = 16
  inputPlaceholder.style.marginLeft = 15
  textField.addChild(inputPlaceholder)

  # 5. Interactive Scripting
  echo "Executing Scripting Pass..."
  discard engine.eval("""
    print('Engine: Ultimate Sciter Ready.');
    function onMouseEvent(x, y, btn, pressed) {
      if (pressed) {
        print('Interactivity triggered at: ' + x + ',' + y);
        setStyle('perf-progress', 'width', '320');
        setStyle('perf-progress', 'background-color', '#fbbf24');
        setStyle('action-btn', 'background-color', '#2563eb');
        print('Engine: UI dynamically updated.');
      }
    }
  """)

  # Trigger event
  engine.injectMouseEvent(600, 450, 0, true)

  # 6. Final Pipeline
  echo "Computing Ultimate Layout..."
  computeLayout(root, 0, 0, 1200, 900)

  echo "Painting Ultimate Rendering..."
  let image = newImage(1200, 900)
  let ctx = image.newContext()
  paint(root, ctx)

  image.writeFile("sciter_ultimate_showcase.png")
  echo "Success: sciter_ultimate_showcase.png generated."

  engine.free()

if isMainModule:
  main()
