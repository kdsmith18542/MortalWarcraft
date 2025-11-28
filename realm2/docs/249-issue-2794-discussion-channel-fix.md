# Issue #2794 - Discussion Channel Bug Fix

**Date:** 2025-01-23  
**Status:** ✅ Fixed

---

## Issue Description

**Problem:** New characters are not automatically joined to channels /1 (General) and /3 (LocalDefense) on first login, except for Undead and Tauren races.

**Expected Behavior:** All new characters should be automatically joined to General and LocalDefense channels on first login, regardless of race.

**Source:** https://github.com/azerothcore/azerothcore-wotlk/issues/2794

---

## Root Cause

The `UpdateLocalChannels()` function in `PlayerUpdates.cpp` has an early return when `PlayerLoading()` is true:

```cpp
if (GetSession()->PlayerLoading() && !IsBeingTeleportedFar())
    return; // The client handles it automatically after loading, but not
            // after teleporting
```

This assumes the client will automatically join channels, but this doesn't work reliably for most races (only Undead and Tauren seem to work, possibly due to client-side race-specific handling).

The issue occurs because:
1. `UpdateLocalChannels()` is called from `UpdateZone()` during `SendInitialPacketsAfterAddToMap()`
2. At that point, `PlayerLoading()` is still `true`
3. The function returns early without joining channels
4. `PlayerLoading()` is set to `false` later, but channels are never joined

---

## Fix

**File:** `realm2/azerothcore/src/server/game/Handlers/CharacterHandler.cpp`

**Changes:**
- Added explicit call to `UpdateLocalChannels()` after `m_playerLoading` is set to `false`
- This ensures channels are joined even if the client doesn't handle it automatically

**Code:**
```cpp
m_playerLoading = false;

// Fix for issue #2794: Ensure new characters are joined to General and LocalDefense channels
// UpdateLocalChannels was returning early during PlayerLoading, assuming client handles it
// but this doesn't work for most races. Force channel join after loading completes.
uint32 currZone, currArea;
pCurrChar->GetZoneAndAreaId(currZone, currArea);
pCurrChar->UpdateLocalChannels(currZone);

// Handle Login-Achievements (should be handled after loading)
_player->UpdateAchievementCriteria(ACHIEVEMENT_CRITERIA_TYPE_ON_LOGIN, 1);
```

---

## Testing

**Test Steps:**
1. Create a new character (any race except Undead/Tauren)
2. Log in for the first time
3. Check chat channels
4. Verify /1 (General) and /3 (LocalDefense) are automatically joined

**Expected Results:**
- All new characters are automatically joined to General and LocalDefense channels
- Works for all races, not just Undead and Tauren
- Channels appear in chat window on first login

---

## Related Files

- `realm2/azerothcore/src/server/game/Handlers/CharacterHandler.cpp` - Main fix
- `realm2/azerothcore/src/server/game/Entities/Player/PlayerUpdates.cpp` - `UpdateLocalChannels()` function

---

## Notes

- The fix ensures channels are joined server-side after loading completes
- This is more reliable than relying on client-side auto-join
- The fix doesn't break existing behavior for Undead/Tauren (they still work)
- All races now consistently join channels on first login

---

**Last Updated:** 2025-01-23

