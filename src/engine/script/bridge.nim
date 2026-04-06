import monoucha/quickjs, ../core/dom, ../style/resolver, tables, strutils

type
  ScriptEngine* = ref object
    rt*: JSRuntime
    ctx*: JSContext
    root*: Node

var currentEngine: ScriptEngine

proc newScriptEngine*(root: Node): ScriptEngine =
  let rt = JS_NewRuntime()
  let ctx = JS_NewContext(rt)
  result = ScriptEngine(rt: rt, ctx: ctx, root: root)
  currentEngine = result

proc free*(engine: ScriptEngine) =
  JS_FreeContext(engine.ctx)
  JS_FreeRuntime(engine.rt)

proc eval*(engine: ScriptEngine, script: string): string =
  let val = JS_Eval(engine.ctx, script.cstring, script.len.csize_t, "script.js".cstring, 0)
  if (val.tag == JS_TAG_EXCEPTION):
    let ex = JS_GetException(engine.ctx)
    let str = JS_ToCString(engine.ctx, ex)
    echo "JS Exception: ", str
    JS_FreeCString(engine.ctx, str)
    JS_FreeValue(engine.ctx, ex)
    return "Exception"
  JS_FreeValue(engine.ctx, val)
  return "Evaluated"

proc findNodeById(node: Node, id: string): Node =
  if node.kind == nkElement and node.id == id:
    return node
  for child in node.children:
    let found = findNodeById(child, id)
    if found != nil: return found
  return nil

proc native_print(ctx: JSContext; this_val: JSValueConst; argc: cint; argv: JSValueConstArray): JSValue {.cdecl, raises: [].} =
  try:
    for i in 0..<argc:
      let str = JS_ToCString(ctx, argv[i])
      if i > 0: stdout.write " "
      stdout.write str
      JS_FreeCString(ctx, str)
    stdout.write "\n"
  except: discard
  return JS_UNDEFINED

proc native_setStyle(ctx: JSContext; this_val: JSValueConst; argc: cint; argv: JSValueConstArray): JSValue {.cdecl, raises: [].} =
  try:
    if argc >= 3:
      let id = $JS_ToCString(ctx, argv[0])
      let key = $JS_ToCString(ctx, argv[1])
      let value = $JS_ToCString(ctx, argv[2])
      let node = findNodeById(currentEngine.root, id)
      if node != nil:
        node.style.applyProperty(key, value)
  except: discard
  return JS_UNDEFINED

proc registerBuiltins*(engine: ScriptEngine) =
  let global = JS_GetGlobalObject(engine.ctx)
  discard JS_SetPropertyStr(engine.ctx, global, "print", JS_NewCFunction(engine.ctx, native_print, "print", 1))
  discard JS_SetPropertyStr(engine.ctx, global, "setStyle", JS_NewCFunction(engine.ctx, native_setStyle, "setStyle", 3))
  JS_FreeValue(engine.ctx, global)

proc injectMouseEvent*(engine: ScriptEngine, x, y: float32, button: int, pressed: bool) =
  let script = "if (typeof onMouseEvent === 'function') onMouseEvent(" & $x & ", " & $y & ", " & $button & ", " & $pressed & ");"
  discard engine.eval(script)

proc injectKeyEvent*(engine: ScriptEngine, key: int, pressed: bool) =
  let script = "if (typeof onKeyEvent === 'function') onKeyEvent(" & $key & ", " & $pressed & ");"
  discard engine.eval(script)
