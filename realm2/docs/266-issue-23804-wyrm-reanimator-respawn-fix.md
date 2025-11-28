# Fix for #23804 - Wyrm Reanimators Respawn Issue

**Issue:** [#23804](https://github.com/azerothcore/azerothcore-wotlk/issues/23804)  
**Status:** ✅ Fixed  
**Date:** 2025-01-23

## Problem

Wyrm Reanimators (NPC 31731) in Sindragosa's Fall sometimes fail to respawn after being despawned by the Frostbrood Spawn (NPC 31702) script. This can lead to complete absence of Wyrm Reanimators in the area, breaking the quest flow for "Cradle of the Frostbrood" (13349 Horde) and "Sindragosa's Fall" (13397 Alliance).

## Root Cause

The existing Frostbrood Spawn script (entry 3170200) despawns the Wyrm Reanimator using `SMART_ACTION_DESPAWN_SELF` (action 41) after 15 seconds when the Frostbrood Spawn reaches its destination. However, this action might not always properly set the respawn timer when called from a script context, causing the Wyrm Reanimator to despawn but never respawn.

## Solution

Modified the Frostbrood Spawn script to use `SMART_ACTION_FORCE_DESPAWN` (action 41) with explicit respawn timer parameters instead of relying on the default despawn behavior. This ensures the Wyrm Reanimator always respawns after 300 seconds (5 minutes), matching the `spawntimesecs` value in the creature spawn data.

## Implementation

**File:** `realm2/azerothcore/data/sql/updates/db_world/2025_01_23_19_fix_wyrm_reanimator_respawn.sql`

- Deleted the existing despawn action (id 4) in the Frostbrood Spawn script (entry 3170200)
- Replaced it with `SMART_ACTION_FORCE_DESPAWN` (action 41) with:
  - `action_param1` = 1 (despawn delay in ms, minimum 1ms for safety)
  - `action_param2` = 300 (respawn delay in seconds, matching spawntimesecs)
  - `action_param3` = 0 (removeObjectFromWorld flag, 0 = use respawn timer)

## Technical Details

The `SMART_ACTION_FORCE_DESPAWN` action calls `Creature::DespawnOrUnsummon()` with both a despawn delay and a forced respawn timer. This ensures that even if the creature's spawn data doesn't have a respawn timer set, it will still respawn after the specified delay.

## Testing

1. Complete the quest event that spawns a Frostbrood Spawn
2. Wait for the Frostbrood Spawn to reach its destination (15 seconds)
3. Verify the Wyrm Reanimator despawns
4. Wait 5 minutes (300 seconds)
5. Verify the Wyrm Reanimator respawns at its original location

## Related Files

- `realm2/azerothcore/data/sql/updates/db_world/2025_01_23_19_fix_wyrm_reanimator_respawn.sql`
- `realm2/azerothcore/data/sql/updates/db_world/2025_09_20_00.sql` (original script)

