import engine/core/dom, engine/layout/engine

proc test() =
  let root = newNode("div")
  root.style.width = 1000
  root.style.height = 800
  root.style.flexDirection = "row"

  let left = newNode("div")
  left.style.flexGrow = 1
  root.addChild(left)

  let right = newNode("div")
  right.style.width = 300
  root.addChild(right)

  computeLayout(root, 0, 0, 1000, 800)

  assert right.computedLayout.width == 300
  assert left.computedLayout.width == 700
  echo "Layout V3 Test Passed"

test()
