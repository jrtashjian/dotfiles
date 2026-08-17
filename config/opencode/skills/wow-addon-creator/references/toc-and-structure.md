# TOC Format & Addon Structure

## Standard Tags (all versions)

```
## Interface: 11200          # required — 11200 / 20400 / 30300
## Title: Display Name
## Notes: Longer description
## Author: Name
## Version: 1.0.0
## SavedVariables: MyDB
## SavedVariablesPerCharacter: MyCharDB
## Dependencies: RequiredAddon
## OptionalDeps: Ace3, LibStub
## DefaultState: enabled
## LoadOnDemand: 1
## LoadWith: AnotherAddon
```

Comments start with `#` (not `##`).

## File Listing

List every file the client should load, one per line, in order:

```
libs\LibStub\LibStub.lua
MyAddon.xml
MyAddon.lua
modules\Feature.lua
```

XML files can contain `<Script file="foo.lua"/>` or `<Include file="bar.xml"/>`.

## Multi-Client Notes

Private-server users almost always run a single client version. Prefer a dedicated TOC (and possibly separate code paths) per target rather than complex runtime detection unless the user explicitly wants one package for all three.

If supporting multiple:

- Ship separate folders or use version-specific files loaded via different TOC entries.
- Runtime check example (works on all three):

```lua
local _, _, _, tocversion = GetBuildInfo()
-- tocversion is a number: 11200, 20400, 30300 etc.
```

## SavedVariables Loading Order

1. Files listed in TOC execute.
2. After the last file, SavedVariables are loaded (overwriting any defaults you set earlier).
3. `ADDON_LOADED` fires with the addon name.
4. Later `PLAYER_LOGIN` / `PLAYER_ENTERING_WORLD`.

Always set defaults inside the `ADDON_LOADED` handler for your addon name.