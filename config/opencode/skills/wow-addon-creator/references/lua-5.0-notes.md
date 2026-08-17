# Lua 5.0 Notes for WoW Classic Addons

These clients (especially 1.12.1) run a customized Lua 5.0 environment. Treat the Lua 5.0 Reference Manual as the language specification. Modern Lua (5.1+) features will break on Vanilla and can cause subtle issues even on TBC/WotLK private servers.

## Length & Tables

- **No `#` operator.** Use `table.getn(t)` to get the length of an array-like table.
- `table.setn(t, n)` exists but is rarely needed.
- Prefer `table.insert` / `table.remove` over manual index management.
- `pairs(t)` and `ipairs(t)` are available and preferred over `table.foreach` / `table.foreachi`.

```lua
local n = table.getn(myList)
for i = 1, n do
  -- ...
end
```

## Varargs

In pure Lua 5.0 a function declared with `...` receives an implicit `arg` table:

```lua
function foo(a, b, ...)
  -- arg is a table: { [1]=..., [2]=..., n = number of extra args }
  local extra = arg.n
end
```

On WoW it is safer (and more portable) to write:

```lua
function foo(a, b, ...)
  local n = select("#", ...)
  local first = select(1, ...)
  -- or pack when needed:
  local args = { n = select("#", ...), ... }
end
```

Event handlers should always use the modern signature even on 1.12:

```lua
frame:SetScript("OnEvent", function(self, event, ...)
  -- ...
end)
```

## Scoping & Closures

- Full lexical scoping (Lua 5.0 introduced proper upvalues).
- `local function f() ... end` is sugar for `local f; f = function() ... end` and is safe.
- Each execution of a `local` statement creates new variables (important inside loops that create closures).

## Operators & Control Flow

- Relational: `==`, `~=`, `<`, `>`, `<=`, `>=`
- Logical: `and`, `or`, `not` (short-circuit, return the operand)
- Concatenation: `..`
- No ternary operator → use `and`/`or` carefully or an if.
- No `continue` → use nested ifs or a flag.
- `break` only exits the innermost loop; must be the last statement of a block (use `do break end` if needed mid-block).

## Metatables

Fully supported. Common events used in addons:

- `__index`, `__newindex`
- `__eq`, `__lt`, `__le`
- `__add`, `__sub`, `__mul`, `__div`, `__pow`, `__unm`, `__concat`
- `__call`
- `__gc` (userdata finalizers — limited usefulness in pure addon code)

Remember: metamethod lookup itself does not trigger other metamethods.

## Error Handling

```lua
local ok, result = pcall(myFunction, arg1, arg2)
if not ok then
  -- result is the error message
end
```

`error(msg [, level])` and `assert` work as documented.

## Standard Libraries Available (subset)

- `string.*` (most functions; some later additions like `string.match` patterns may vary by client)
- `table.*` (`insert`, `remove`, `sort`, `concat`, `getn`, `setn`, `foreach`, `foreachi`)
- `math.*`
- `coroutine.*` (present but rarely useful / restricted in the WoW sandbox)
- Limited `os` and almost no `io` / `debug` (the environment is heavily sandboxed)

## WoW-Specific Globals (prefer these)

| Helper              | Purpose                          |
|---------------------|----------------------------------|
| `getglobal(name)`   | Safer global lookup              |
| `setglobal(name, v)`| Safer global assignment          |
| `strsplit(delim, str)` | Split string                   |
| `strjoin(delim, ...)`  | Join strings                   |
| `strtrim(str)`      | Trim whitespace                  |
| `wipe(t)` / `table.wipe(t)` | Empty a table in place   |
| `debugstack([start[, count]])` | Stack traceback          |

## Things That Will Break on 1.12

- Any use of the `#` operator
- `bit.*` library (not present)
- Assuming `select` always exists in the exact same form (it does, but be careful)
- Secure templates / `InCombatLockdown` / `hooksecurefunc`
- Many later Frame methods and events

When targeting multiple clients, write the lowest common denominator (1.12) first, then gate later features behind version checks:

```lua
local _, _, _, tocversion = GetBuildInfo()
if tocversion >= 20000 then
  -- TBC+ code
end
```

## Quick Checklist Before Shipping

- [ ] No `#` operator anywhere
- [ ] All length queries use `table.getn`
- [ ] Event handlers use `(self, event, ...)`
- [ ] SavedVariables defaults set inside `ADDON_LOADED`
- [ ] Correct `## Interface:` number
- [ ] No retail-only APIs or templates
- [ ] Tested (or at least reviewed) against the matching Gethe/wow-ui-source tree
