# Widgets, Templates & Script Handlers

## Creating Frames

```lua
local f = CreateFrame("Frame", "MyAddonFrame", UIParent)
-- or Button, CheckButton, StatusBar, ScrollFrame, EditBox, MessageFrame, etc.
```

Common types available across all three clients: Frame, Button, CheckButton, ColorSelect, Cooldown, EditBox, GameTooltip, MessageFrame, Minimap, Model, ScrollFrame, SimpleHTML, Slider, StatusBar, PlayerModel.

## Useful Blizzard Templates (inherit=)

- UIPanelButtonTemplate / UIPanelButtonGrayTemplate
- UIPanelCloseButton
- UICheckButtonTemplate
- UIRadioButtonTemplate
- InputBoxTemplate
- UIPanelScrollBarTemplate
- UIDropDownMenuTemplate (more limited on 1.12)
- DialogBox special backgrounds and borders
- SecureActionButtonTemplate / SecureUnitButtonTemplate (2.0+ only)

Example XML:

```xml
<Button name="MyButton" inherits="UIPanelButtonTemplate" text="Click">
  <Size><AbsDimension x="100" y="22"/></Size>
  <Scripts>
    <OnClick>MyAddon_OnClick(self)</OnClick>
  </Scripts>
</Button>
```

## Script Handlers

Most common:

- OnLoad, OnEvent, OnUpdate
- OnShow, OnHide
- OnEnter, OnLeave (tooltips)
- OnClick, PreClick, PostClick (buttons)
- OnDragStart, OnDragStop, OnMouseUp, OnMouseDown
- OnValueChanged (sliders, etc.)
- OnTextChanged, OnEnterPressed (EditBox)

Set via XML `<OnXxx>` or Lua `frame:SetScript("OnXxx", func)`.

`HookScript` is available on later clients; on 1.12 prefer careful wrapping.

## Layout Tips

- Always parent to UIParent or another well-known frame unless intentionally layered.
- Use `SetFrameStrata("MEDIUM")` / `SetFrameLevel` for correct stacking.
- `SetBackdrop` with the classic dialog textures for polished panels.
- Enable mouse only when needed; set hit rects carefully for small buttons.