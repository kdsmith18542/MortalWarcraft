# Fix for #23803 - The Lodestone Quest - Image of Stone Giants Do Not Despawn

**Issue:** [#23803](https://github.com/azerothcore/azerothcore-wotlk/issues/23803)  
**Status:** ✅ Fixed  
**Date:** 2025-01-23

## Problem

During "The Lodestone" quest (11358 Alliance, 11366 Horde), when players use the Rune Sample (item 33819) to cast "Compare Runes" (spell 43692) on the Broken Tablet (gameobject 66102), the spell sends script event 15939 to the gameobject. This event should summon Image of Megalith (NPC 24381) for an RP event, but the Image does not despawn after the RP event completes, leaving it in the world permanently.

## Root Cause

The Broken Tablet gameobject did not have a SmartAI script to handle the script event 15939. When the event was triggered, the Image of Megalith was not being summoned as a temporary creature with a despawn timer.

## Solution

Created a SmartAI script for the Broken Tablet (gameobject 66102) that:
1. Listens for `SMART_EVENT_GO_EVENT_INFORM` (event 71) with event ID 15939
2. Summons Image of Megalith (NPC 24381) as a temporary creature
3. Sets a despawn timer of 60 seconds (enough time for the RP event to complete)

## Implementation

**File:** `realm2/azerothcore/data/sql/updates/db_world/2025_01_23_17_fix_lodestone_image_despawn.sql`

- Updated `gameobject_template` to use `SmartGameObjectAI` for entry 66102
- Added SmartAI script:
  - Event: `SMART_EVENT_GO_EVENT_INFORM` (71) with event_param1 = 15939
  - Action: `SMART_ACTION_SUMMON_CREATURE` (12) with:
    - `action_param1` = 24381 (Image of Megalith)
    - `action_param2` = 4 (TEMPSUMMON_TIMED_DESPAWN)
    - `action_param3` = 60000 (60 seconds despawn timer)

## Testing

1. Accept "The Lodestone" quest (11358 or 11366)
2. Use Rune Sample on the Broken Tablet
3. Verify Image of Megalith spawns and performs RP
4. Verify Image of Megalith despawns after 60 seconds

## Related Files

- `realm2/azerothcore/data/sql/updates/db_world/2025_01_23_17_fix_lodestone_image_despawn.sql`

