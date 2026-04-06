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

proc print(ctx: JSContext; this_val: JSValueConst; argc: cint; argv: JSValueConstArray): JSValue {.cdecl, raises: [].} =
  try:
    for i in 0..<argc:
      let str = JS_ToCString(ctx, argv[i])
      if i > 0: stdout.write " "
      stdout.write str
      JS_FreeCString(ctx, str)
    stdout.write "\n"
  except:
    discard
  return JS_UNDEFINED

proc findNodeById(node: Node, id: string): Node =
  if node.kind == nkElement and node.attributes.getOrDefault("id") == id:
    return node
  for child in node.children:
    let found = findNodeById(child, id)
    if found != nil: return found
  return nil

proc setElementStyle(ctx: JSContext; this_val: JSValueConst; argc: cint; argv: JSValueConstArray): JSValue {.cdecl, raises: [].} =
  try:
    if argc >= 3:
      let id = $JS_ToCString(ctx, argv[0])
      let key = $JS_ToCString(ctx, argv[1])
      let value = $JS_ToCString(ctx, argv[2])

      let node = findNodeById(currentEngine.root, id)
      if node != nil:
        node.style.applyProperty(key, value)
  except:
    discard
  return JS_UNDEFINED

proc registerBuiltins*(engine: ScriptEngine) =
  let global = JS_GetGlobalObject(engine.ctx)

  let funcPrint = JS_NewCFunction(engine.ctx, print, "print", 1)
  discard JS_SetPropertyStr(engine.ctx, global, "print", funcPrint)

  let funcSetStyle = JS_NewCFunction(engine.ctx, setElementStyle, "setElementStyle", 3)
  discard JS_SetPropertyStr(engine.ctx, global, "setElementStyle", funcSetStyle)

  JS_FreeValue(engine.ctx, global)
