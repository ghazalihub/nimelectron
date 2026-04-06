import engine/core/dom, engine/script/bridge, tables

proc test() =
  let root = newNode("div")
  root.id = "app"

  let engine = newScriptEngine(root)
  engine.registerBuiltins()

  discard engine.eval("""
    var clickCount = 0;
    function onMouseEvent(x, y, btn, pressed) {
      if (pressed) {
        clickCount++;
        setStyle('app', 'background-color', clickCount > 1 ? 'blue' : 'red');
      }
    }
  """)

  engine.injectMouseEvent(100, 100, 0, true)
  assert root.style.backgroundColor.r > 0

  engine.injectMouseEvent(100, 100, 0, true)
  assert root.style.backgroundColor.b > 0

  echo "Event Loop Integration Passed"
  engine.free()

test()
