# Key API & Behavior Differences

## 1.12.1 (Vanilla)

- No secure action templates or combat lockdown system as known later.
- Many protected unit functions simply do not exist or behave differently.
- `hooksecurefunc` not present — use direct replacement or libraries.
- Fewer events overall; combat log is more limited.
- CreateFrame works but some convenience methods and inheritance behaviors are older.
- Global `arg1`… style is very common in contemporary example code.
- Options panels are custom-built; no standard InterfaceOptionsFrame integration.

## 2.4.3 (TBC)

- Secure templates and the action-button attribute system arrive.
- `InCombatLockdown()` available.
- `hooksecurefunc` and improved script hooking.
- Better unit events and aura handling.
- Drop-down menus and many FrameXML utilities more mature.
- Still no HybridScrollFrame.

## 3.3.5 (WotLK)

- HybridScrollFrame for efficient lists.
- Richer set of UNIT_ and PLAYER_ events.
- Improved tooltip APIs and comparison tooltips.
- More complete options / interface panel support.
- Achievement, glyph, calendar related APIs and events appear.
- Chat frame changes (tabs, etc.) but core addon API remains compatible with careful coding.

## Cross-Version Advice

- Write for the oldest client you must support, then add later-only features behind version checks.
- Prefer events and explicit registration over polling.
- Test on the real client (or a faithful private-server build) — documentation from retail is often wrong for these versions.
- Extracted FrameXML from the exact client (available on GitHub for these three patches) is the ultimate reference for templates and available globals.