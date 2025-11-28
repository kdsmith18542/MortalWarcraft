# Fix for #23806 - Flying Vehicle Movement Issues

**Date:** 2025-01-23  
**Status:** ✅ Fixed

---

## Problem

Flying vehicles (e.g., Flying Machine quest 11390) cannot angle downward until you jump. The vehicle thinks it's on solid ground until you jump, preventing downward movement.

## Root Cause

When a player enters a flying vehicle (one with `VEHICLE_FLAG_ALLOW_PITCHING`), the vehicle doesn't have the proper movement flags set immediately. The vehicle needs `MOVEMENTFLAG_DISABLE_GRAVITY` set to allow immediate downward pitching without requiring a jump first.

## Solution

Modified `Vehicle::AddPassenger()` in `Vehicle.cpp` to check if the vehicle has `VEHICLE_FLAG_ALLOW_PITCHING` flag. If so, immediately set `MOVEMENTFLAG_DISABLE_GRAVITY` on the vehicle when a player enters and takes control.

This ensures that:
1. Flying vehicles are immediately recognized as being in "flying mode"
2. Players can pitch down immediately without needing to jump first
3. The vehicle behaves correctly from the moment the player enters

## Files Changed

1. **`realm2/azerothcore/src/server/game/Entities/Vehicle/Vehicle.cpp`**
   - Modified `Vehicle::AddPassenger()` function
   - Added check for `VEHICLE_FLAG_ALLOW_PITCHING` flag
   - Sets `MOVEMENTFLAG_DISABLE_GRAVITY` immediately when player enters flying vehicle

2. **`realm2/azerothcore/data/sql/updates/db_world/2025_01_23_13_fix_flying_vehicle_movement.sql`**
   - Documentation file noting the C++ fix

## Code Changes

```cpp
// In Vehicle::AddPassenger(), after SetCharmedBy()
// Fix for #23806: Flying vehicles cannot angle downward until you jump
uint32 vehicleFlags = GetVehicleInfo()->m_flags;
if (vehicleFlags & VEHICLE_FLAG_ALLOW_PITCHING)
{
    // Flying vehicles need DISABLE_GRAVITY set immediately
    // This allows immediate downward pitching without needing to jump first
    if (!_me->HasUnitMovementFlag(MOVEMENTFLAG_DISABLE_GRAVITY))
    {
        _me->SetDisableGravity(true);
        LOG_DEBUG("vehicles", "Vehicle {} (entry {}) - Set DISABLE_GRAVITY for flying vehicle", _vehicleInfo->m_ID, _me->GetEntry());
    }
}
```

## Affected Vehicles

This fix affects all vehicles with `VEHICLE_FLAG_ALLOW_PITCHING` flag, including:
- Vehicle ID 113 - Flying Machine (quest 11390)
- Vehicle ID 290 - Flying Machine (other quests)
- Vehicle ID 298 - Flying Machine (other quests)
- Vehicle ID 8 - Flying Machine (other quests)
- Vehicle ID 341 - Flying Machine (other quests)
- Any other flying vehicles with the ALLOW_PITCHING flag

## Testing

1. Enter a flying vehicle (e.g., Flying Machine from quest 11390)
2. Try to angle downward immediately - should work without jumping
3. Verify vehicle movement feels natural and responsive
4. Test with multiple flying vehicle types to ensure fix works universally

