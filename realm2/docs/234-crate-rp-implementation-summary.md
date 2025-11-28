# Crate RP Events Implementation Summary - Issue #15629

**Date:** 2025-01-23  
**Status:** Framework Complete, SmartAI Scripts Needed

---

## ✅ Completed

### 1. NPC IDs Found
All NPC IDs verified from ScriptDevAI backup:
- **Roger Owens:** 27903
- **Sergeant Morigan:** 27877
- **Jena Anderson:** 27885
- **Malcolm Moore:** 27891
- **Scruffy:** 27892 (TODO: verify)
- **Bartleby Battson:** 27907
- **Lordaeron Crier:** 27913

### 2. Code Framework
- ✅ Added NPC IDs to `culling_of_stratholme.h`
- ✅ Added `DATA_CRATE_REVEALED` to track which crate (1-5) was revealed
- ✅ Added `ACTION_CRATE_REVEALED = 100` to Actions enum
- ✅ Modified `npc_crate_helper` to identify crate number by position
- ✅ Implemented `TriggerCrateRPEvent(uint32 crateNumber)` function
- ✅ Implemented `TriggerCrierYell()` function
- ✅ Added `GetCreatureByEntry(uint32 entry)` helper function

### 3. Crate Identification
- Position-based identification using distance from entrance
- Adjustable thresholds for crate number determination

---

## 🔄 Remaining Work

### SmartAI Scripts (SQL)

Need to create SmartAI scripts for each NPC that:
1. Listen for `SMART_EVENT_ACTION_DONE` with `event_param1 = 100` (ACTION_CRATE_REVEALED)
2. Perform RP sequences:
   - Movement to destinations
   - Emotes (discover, inspect, complain, etc.)
   - Text (requires `creature_text` entries)
   - Final movement/despawn

### Required Data

1. **NPC Spawn Positions** - Where each NPC spawns
2. **Waypoint Paths** - Movement routes for each NPC
3. **Text IDs** - `creature_text` entries for each NPC's dialogue
4. **Emote IDs** - Appropriate emotes for each action
5. **Timing** - Delays between actions

### Scruffy Verification
- Need to verify NPC ID 27892 is correct for Scruffy (Malcolm Moore's dog)

---

## Files Modified

1. **`culling_of_stratholme.h`**
   - Added 7 NPC IDs to `enum Creatures`
   - Added `ACTION_CRATE_REVEALED` to `enum Actions`
   - Added `DATA_CRATE_REVEALED` to `enum Data`

2. **`culling_of_stratholme.cpp`**
   - Modified `npc_crate_helperAI::SpellHit()` to identify and report crate number
   - Added `IdentifyCrateNumber()` function

3. **`instance_culling_of_stratholme.cpp`**
   - Added `DATA_CRATE_REVEALED` handler
   - Implemented `TriggerCrateRPEvent()` function
   - Implemented `TriggerCrierYell()` function
   - Added `GetCreatureByEntry()` helper function
   - Modified `DATA_CRATE_COUNT` handler to call `TriggerCrierYell()` when all 5 crates revealed

4. **`2025_01_23_08_fix_cos_crate_rp_events.sql`**
   - Placeholder SQL file for SmartAI scripts
   - Ready for script implementation

---

## Next Steps

1. **Verify Scruffy NPC ID** - Confirm 27892 or find correct ID
2. **Research NPC Positions** - Find spawn positions and destinations
3. **Create creature_text Entries** - Add text for each NPC's dialogue
4. **Write SmartAI Scripts** - Complete SQL file with full RP sequences
5. **Test in Game** - Verify crate identification and RP events work correctly

---

**Last Updated:** 2025-01-23

