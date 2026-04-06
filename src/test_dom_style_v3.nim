import engine/core/dom, engine/style/resolver, tables, chroma

proc test() =
  let root = newNode("body")
  root.id = "app"
  root.style.color = parseHtmlColor("white")

  let sidebar = newNode("div")
  sidebar.classes.add("sidebar")
  root.addChild(sidebar)

  var sheet: StyleSheet = @[]
  sheet.add StyleRule(selector: parseSelector("#app"), properties: {"background-color": "#111"}.toTable)
  sheet.add StyleRule(selector: parseSelector(".sidebar"), properties: {"width": "200", "background-color": "#222"}.toTable)

  resolveStyle(root, sheet)

  assert root.style.backgroundColor == parseHtmlColor("#111")
  assert sidebar.style.width == 200
  assert sidebar.style.color == parseHtmlColor("white") # Inherited
  echo "DOM/Style V3 Test Passed"

test()
