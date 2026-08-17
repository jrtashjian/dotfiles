local addonName, addon = ...

MyAddonDB = MyAddonDB or {}

local frame = MyAddonFrame

local function OnEvent(self, event, ...)
  if event == "ADDON_LOADED" and ... == addonName then
    if MyAddonDB.enabled == nil then
      MyAddonDB.enabled = true
    end
    self:UnregisterEvent("ADDON_LOADED")
  elseif event == "PLAYER_LOGIN" then
    -- ready
  end
end

local eventFrame = CreateFrame("Frame")
eventFrame:SetScript("OnEvent", OnEvent)
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")

SLASH_MYADDON1 = "/myaddon"
SlashCmdList["MYADDON"] = function(msg)
  if frame:IsShown() then
    frame:Hide()
  else
    frame:Show()
  end
end

print("|cff00ff00MyAddon|r loaded. Type /myaddon to toggle.")
