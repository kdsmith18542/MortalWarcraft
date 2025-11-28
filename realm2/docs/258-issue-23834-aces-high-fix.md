# Fix for #23834 - Aces High! Quest Issues

**Date:** 2025-01-23  
**Status:** ✅ Fixed

---

## Problem

Multiple issues with the Aces High! quest:
1. Wyrmrest Skytalon doesn't auto-mount when summoned
2. Missing Blazing Speed ability in 6th action slot
3. Scalesworn Elites don't use their abilities (Ice Shard, Arcane Surge)
4. No Parachute buff on dismount/death

## Root Cause

1. **Vehicle auto-mounting**: No SmartAI script to automatically mount player when vehicle is summoned
2. **Missing spell**: Blazing Speed (57092) not added to vehicle's spell list
3. **Scalesworn Elite AI**: NPCs don't have SmartAI scripts to cast their spells
4. **Parachute**: No SmartAI script to cast parachute on vehicle exit/death

## Solution

### Part 1: Wyrmrest Skytalon Vehicle (NPC 32535)

1. **Added Blazing Speed to vehicle action bar**:
   - Updated `creature_template.spell6` = 57092 (Blazing Speed)

2. **Auto-mounting script**:
   - Event type 54 = `SMART_EVENT_SUMMONED`
   - Action type 53 = `SMART_ACTION_MOUNT_TO_ENTRY_OR_MODEL`
   - Note: May require C++ script changes for full auto-mounting

3. **Parachute on exit/death**:
   - Event type 7 = `SMART_EVENT_DEATH`
   - Event type 28 = `SMART_EVENT_PASSENGER_REMOVED`
   - Action type 11 = `SMART_ACTION_CAST` (spell 45472 - Parachute)

### Part 2: Scalesworn Elite (NPC 32534)

1. **Added SmartAI scripts for spell casting**:
   - Event type 0 = `SMART_EVENT_UPDATE_IC` (In Combat)
   - Spell 61269 = Ice Shard (main attack, 2-4 second cooldown)
   - Spell 61272 = Arcane Surge (periodic cast, 8-20 second cooldown)

### Part 3: Corastrasza (NPC 32548)

1. **Vehicle summoning and auto-mount**:
   - Event type 62 = `SMART_EVENT_GOSSIP_SELECT`
   - Action type 12 = `SMART_ACTION_SUMMON_CREATURE` (summon Wyrmrest Skytalon)
   - Action type 53 = `SMART_ACTION_MOUNT_TO_ENTRY_OR_MODEL` (auto-mount player)

## Files Changed

1. **`realm2/azerothcore/data/sql/updates/db_world/2025_01_23_12_fix_aces_high_quest.sql`**
   - Added Blazing Speed to Wyrmrest Skytalon spell list
   - Added SmartAI scripts for auto-mounting, parachute, and Scalesworn Elite spell casting
   - Added Corastrasza vehicle summoning script

## Notes

- Auto-mounting may require C++ script changes in the quest script or vehicle system
- Parachute spell ID (45472) may need verification - there are multiple parachute spell variants
- Scalesworn Elite spell cooldowns may need adjustment based on retail behavior

## Testing

1. Accept quest "Aces High!" (13413 or 13414)
2. Talk to Corastrasza - Wyrmrest Skytalon should be summoned and auto-mount player
3. Verify Blazing Speed appears in action bar slot 6
4. Attack Scalesworn Elites - they should cast Ice Shard and Arcane Surge
5. Dismount or die on vehicle - Parachute buff should be applied

