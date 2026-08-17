---
name: wow-addon-creator
description: Create high-quality Lua addons for World of Warcraft private server clients 1.12.1 (Vanilla), 2.4.3 (TBC), and 3.3.5 (WotLK). Use when building, debugging, or iterating on classic-era addons — covers TOC structure, FrameXML widgets, event registration, hooks, UI templates, version differences, Lua 5.0 language constraints, and UX patterns for clean, performant interfaces.
---

# WoW Classic Addon Creator (1.12.1 / 2.4.3 / 3.3.5)

Build complete, production-ready addons for the three most common private-server client versions. Prioritize correct API usage for the target version, strict Lua 5.0 compatibility, clean FrameXML patterns, and excellent user experience.

## Supported Clients & Interface Versions

| Client  | Patch | TOC Interface | Notes |
|---------|-------|---------------|-------|
| Vanilla | 1.12.1| 11200         | Lua 5.0, no secure templates, arg1/arg2 globals common |
| TBC     | 2.4.3 | 20400         | SecureActionButtonTemplate, better Frame methods, hooksecurefunc |
| WotLK   | 3.3.5 | 30300         | HybridScrollFrame, richer events, improved options/tooltips |

Always set the correct `## Interface:` value. Private-server users usually leave "Load out of date addons" unchecked.

## Lua 5.0 Constraints (Critical)

These clients run a customized Lua 5.0 environment (see the Lua 5.0 Reference Manual). Write only language features that exist in 5.0.

### Forbidden or Dangerous in 1.12 / early clients
- `#` length operator → use `table.getn(t)`
- `table.maxn` / modern length edge cases
- `goto`, labels, bitwise operators, `_ENV`
- `module()`, `require()` for arbitrary modules (use TOC + LibStub pattern instead)
- Assuming `...` works exactly like 5.1+ in every context; prefer the classic `arg` table for varargs when targeting 1.12
- Creating functions that close over too many upvalues in hot paths (memory)

### Preferred 5.0 idioms
```lua
-- Length
local n = table.getn(myTable)

-- Safe iteration
for k, v in pairs(t) do ... end
for i, v in ipairs(t) do ... end

-- Vararg function (classic style still safest on 1.12)
function foo(a, b, ...)
  local arg = {n = select("#", ...), ...}  -- or rely on implicit arg table in pure 5.0
  -- ...
end

-- Multiple returns and adjustment work exactly as documented in §2.5.7 of the Lua 5.0 manual
```

Closures, lexical scoping, metatables, coroutines (limited), and the standard libraries that exist in 5.0 all work. When in doubt, consult the provided Lua 5.0 Reference Manual for exact semantics of operators, visibility, error handling, and the base libraries.

WoW also injects many global helpers (`getglobal`, `setglobal`, `strsplit`, `strjoin`, `wipe`, `debugstack`, etc.). Prefer those when they exist.

See `references/lua-5.0-notes.md` for a condensed language reference tailored to addon work.

## Core Addon Structure

```
MyAddon/
├── MyAddon.toc
├── MyAddon.lua          # main logic / event frame
├── MyAddon.xml          # preferred for complex static UI
└── (optional libs, textures, fonts)
```

### Minimal TOC (adapt Interface number)

```
## Interface: 30300
## Title: My Addon
## Notes: Short description shown in the AddOns list
## Author: YourName
## Version: 1.0.0
## SavedVariables: MyAddonDB
## OptionalDeps: Ace3
MyAddon.xml
MyAddon.lua
```

- Use backslashes for subfolders.
- List files in load order. XML before the Lua that references its frames is safest.
- `## SavedVariables:` (account) or `## SavedVariablesPerCharacter:`.

### Preferred Event Frame Pattern (all versions)

```lua
local addonName, addon = ...
local frame = CreateFrame("Frame")

local function OnEvent(self, event, ...)
  if event == "ADDON_LOADED" and ... == addonName then
    -- initialize SavedVariables defaults here
    self:UnregisterEvent("ADDON_LOADED")
  elseif event == "PLAYER_LOGIN" then
    -- most setup after full load
  end
end

frame:SetScript("OnEvent", OnEvent)
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")
```

In 1.12 many older examples still use the global `event` / `arg1`…`arg9`. Prefer the modern `(self, event, ...)` signature — it works on all three clients.

## Version Differences (Critical)

- **Secure templates & protected functions**: Available from 2.0+. Do not use `SecureActionButtonTemplate`, `InCombatLockdown`, or most unit-frame secure attributes on 1.12.
- **CreateFrame**: Fully usable on all three. Prefer Lua `CreateFrame` for dynamic UI; use XML for static complex hierarchies and templates.
- **Event args**: Prefer vararg `...`. Older 1.12 code often relies on globals `arg1`–`arg9`.
- **Hooking**:
  - `hooksecurefunc` exists from 2.0+.
  - On 1.12 use careful function replacement or libraries.
  - `HookScript` is later; on 1.12 replace or wrap carefully.
- **Scroll frames**: Basic ScrollFrame on all. HybridScrollFrame appears in WotLK.
- **Options / config**: `InterfaceOptions` panels on 2.4+/3.3.5. On 1.12 build custom frames or simple slash-command toggles.
- **Tooltips**: `GameTooltip:SetOwner`, `SetText`, `AddLine`, `Show` work everywhere.

## Authoritative Reference — Blizzard UI Source

The extracted FrameXML trees are the ground truth for available templates, global functions, event argument order, and real Blizzard patterns:

- https://github.com/Gethe/wow-ui-source/tree/1.12.1
- https://github.com/Gethe/wow-ui-source/tree/2.4.3
- https://github.com/Gethe/wow-ui-source/tree/3.3.5

When you need the exact inheritance of a template, the arguments of an event, or how Blizzard themselves solved a UI problem, look there first. Retail documentation and modern wiki pages are frequently wrong or incomplete for these clients.

## UX Best Practices for Classic Clients

1. Minimal OnUpdate — register only when needed and unregister when idle. Prefer events.
2. Clean anchoring — `SetPoint` with clear relative frames. Avoid absolute pixel positions that break on different resolutions.
3. Reuse Blizzard templates — `UIPanelButtonTemplate`, `UIPanelCloseButton`, `UICheckButtonTemplate`, `UIDropDownMenuTemplate`, `InputBoxTemplate`, `UIPanelScrollBarTemplate`, etc.
4. Tooltips on everything interactive — OnEnter/OnLeave that call `GameTooltip:SetOwner(self, "ANCHOR_RIGHT")` then populate and Show.
5. Slash commands — `SlashCmdList["MYADDON"] = handler` + `SLASH_MYADDON1 = "/myaddon"`.
6. SavedVariables defaults — always initialize missing keys inside the ADDON_LOADED handler for your addon.
7. Combat safety — on 2.4+/3.3.5 check `InCombatLockdown()` before protected actions.
8. Memory & CPU — avoid creating frames or textures in tight loops. Pool if necessary. Never leave debug prints in release.
9. Localization ready — put user-visible strings in a table; support at least enUS.
10. Visual polish — consistent padding, classic dialog backdrop textures, correct strata/levels (`"HIGH"`, `"DIALOG"`).

## Common Patterns

### Simple Config Toggle
```lua
SLASH_MYADDON1 = "/myaddon"
SlashCmdList["MYADDON"] = function(msg)
  MyAddonDB.enabled = not MyAddonDB.enabled
  print("MyAddon: " .. (MyAddonDB.enabled and "enabled" or "disabled"))
end
```

### Draggable Frame
```lua
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
```

### Using XML + Lua
Define the visual hierarchy and templates in `.xml`, then wire behavior and event registration in `.lua`. Name frames clearly so they appear as globals (or use `getglobal`).

## Reference Files

- `references/toc-and-structure.md` — full TOC tags and multi-version tips
- `references/events-key.md` — frequently used events across the three versions
- `references/widgets-and-templates.md` — available Frame types, common templates, script handlers
- `references/version-differences.md` — detailed API deltas
- `references/lua-5.0-notes.md` — condensed language constraints and WoW-specific globals

## Assets

- `assets/boilerplate/` — ready-to-copy minimal addon (TOC + XML frame + Lua) targeting 3.3.5. Adjust Interface number and extend as needed.

When generating code, always state the target client(s) and produce a complete, drop-in-ready addon folder structure. Prefer one clean implementation that works on the requested version rather than heavy multi-version branching unless the user asks for cross-compatibility.
