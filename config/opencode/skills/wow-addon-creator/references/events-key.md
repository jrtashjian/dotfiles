# Key Events for Classic Addons

Register only what you need. Unregister when no longer required.

## Lifecycle

| Event                  | When it fires                          | Notes |
|------------------------|----------------------------------------|-------|
| ADDON_LOADED           | After an addon finishes loading        | arg1 = addon name. Use for init + SV defaults |
| PLAYER_LOGIN           | After player data is available         | Safe for most UI setup |
| PLAYER_ENTERING_WORLD  | Zoning / login / reload               | Also fires on UI reload |
| PLAYER_LEAVING_WORLD   | Before logout / zoning                 | Cleanup opportunity |
| VARIABLES_LOADED       | Older synonym / related to SV load     | Prefer ADDON_LOADED on these clients |

## Unit & Combat

- UNIT_AURA, UNIT_HEALTH, UNIT_POWER* (power tokens differ slightly by expansion)
- PLAYER_REGEN_DISABLED / PLAYER_REGEN_ENABLED (enter/leave combat)
- PLAYER_TARGET_CHANGED
- UNIT_SPELLCAST_* family (start, stop, failed, succeeded, channel...) — more complete in later clients
- COMBAT_LOG_EVENT_UNFILTERED (available; parsing differs)

## UI & Bags

- BAG_UPDATE, BAG_CLOSED, PLAYERBANKSLOTS_CHANGED
- MERCHANT_SHOW / MERCHANT_CLOSED
- GOSSIP_SHOW, QUEST_DETAIL, etc.
- ACTIONBAR_SLOT_CHANGED, ACTIONBAR_UPDATE_STATE, ACTIONBAR_UPDATE_COOLDOWN
- UPDATE_BINDINGS

## Other Useful

- ZONE_CHANGED, ZONE_CHANGED_NEW_AREA, ZONE_CHANGED_INDOORS
- PLAYER_LEVEL_UP
- SKILL_LINES_CHANGED
- SPELLS_CHANGED
- FRIENDLIST_UPDATE, GUILD_ROSTER_UPDATE
- CHAT_MSG_* family (many variants)

On 1.12 many events still push data through the global `arg1`…`arg9`. Prefer capturing via the OnEvent signature `(self, event, ...)` which is supported.

Always check the exact arguments for the target client when writing handlers — small differences exist between 1.12 and 3.3.5.