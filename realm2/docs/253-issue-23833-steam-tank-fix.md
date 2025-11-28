# Issue #23833 - Alliance Steam Tank Despawn Fix

**Date:** 2025-01-23  
**Status:** ✅ Fixed

---

## Issue Description

**Problem:** Alliance Steam Tank does not disappear after player dismounts from it during quest "Steamtank Surprise" (12326). Tanks pile up outside the mausoleum because they don't despawn.

**Expected Behavior:** Steam tank should despawn when the player exits it (within a few seconds).

**Source:** https://github.com/azerothcore/azerothcore-wotlk/issues/23833

---

## Root Cause

The vehicle despawn logic in `Unit::_ExitVehicle()` only despawns vehicles if:
1. The vehicle base has `UNIT_MASK_MINION` flag
2. The owner of the minion is the exiting player

Quest vehicles like the Steam Tank are spawned via `SUMMON_CATEGORY_VEHICLE` spells, which create temporary summons. These temporary summons have the player as the summoner, but they may not be set up as minions with the proper owner relationship. As a result, they don't get despawned when the player exits.

---

## Fix

**File:** `realm2/azerothcore/src/server/game/Entities/Unit/Unit.cpp`

**Changes:**
- Added check for temporary summon vehicles before the existing minion check
- If the vehicle is a `TempSummon` with the exiting player as the summoner, despawn it
- This handles quest vehicles that are spawned via spells but aren't set up as minions

**Code:**
```cpp
// Fix for issue #23833: Despawn quest vehicles (like Steam Tank) when player exits
// Check if vehicle is a temporary summon with the exiting player as summoner
if (player && vehicleBase->IsCreature())
{
    if (TempSummon const* tempSummon = vehicleBase->ToTempSummon())
    {
        if (Unit* summoner = tempSummon->GetSummonerUnit())
        {
            if (summoner == player && !(player->GetDelayedOperations() & DELAYED_VEHICLE_TELEPORT))
            {
                // Despawn quest vehicles when the summoning player exits
                vehicle->Uninstall();
                vehicleBase->m_Events.AddEventAtOffset(new VehicleDespawnEvent(*vehicleBase, 2s), 2s);
            }
        }
    }
}
```

---

## Testing

**Test Steps:**
1. Accept quest "Steamtank Surprise" (12326)
2. Enter a Steam Tank
3. Move around
4. Exit the Steam Tank
5. Verify the tank despawns within 2 seconds

**Expected Results:**
- Steam Tank despawns when player exits
- No tanks pile up outside the mausoleum
- Works for all quest vehicles spawned via spells

---

## Related Files

- `realm2/azerothcore/src/server/game/Entities/Unit/Unit.cpp` - `_ExitVehicle()` function
- `realm2/azerothcore/src/server/game/Entities/Creature/TemporarySummon.h` - TempSummon class

---

## Notes

- The fix uses a 2-second delay before despawn (same as existing VehicleDespawnEvent)
- This fix applies to all temporary summon vehicles, not just Steam Tank
- The fix doesn't affect vehicles that are already handled by the minion despawn logic
- Vehicles spawned by other players or NPCs are not affected

---

**Last Updated:** 2025-01-23

