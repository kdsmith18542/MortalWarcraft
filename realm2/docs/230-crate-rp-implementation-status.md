# Crate RP Events Implementation Status - Issue #15629

**Date:** 2025-01-23  
**Status:** Framework Complete, NPC IDs Needed

---

## Implementation Progress

### ✅ Completed

1. **Crate Identification System**
   - Added `DATA_CRATE_REVEALED` to track which crate (1-5) was revealed
   - Modified `npc_crate_helper` to identify crate number based on position
   - Position-based identification using distance from entrance

2. **Instance Script Framework**
   - Added `TriggerCrateRPEvent(uint32 crateNumber)` function
   - Added `TriggerCrierYell()` function for when all 5 crates are revealed
   - Framework ready for NPC scripts

3. **Code Structure**
   - Modified `culling_of_stratholme.h` to add `DATA_CRATE_REVEALED`
   - Modified `culling_of_stratholme.cpp` to identify crates by position
   - Modified `instance_culling_of_stratholme.cpp` to handle crate reveals

---

## Remaining Work

### 🔍 Need NPC IDs

The following NPCs need to be found (via database or Wowhead):

1. **Roger Owens** (Crate 1)
   - Action: Goes to inn, discovers crate, runs to find guard
   - Needs: NPC ID, spawn position, destination position

2. **Sergeant Morigan** (Crate 2)
   - Action: Inspects crate next to Perelli, discovers plague, leaves to alert Arthas
   - Needs: NPC ID, spawn position, destination position

3. **Jena Anderson** (Crate 3)
   - Action: Asks to borrow grain from Martha Goslin, discovers plague, leaves to find guard
   - Needs: NPC ID, spawn position, destination position

4. **Malcolm Moore** (Crate 4)
   - Action: Approaches from side of house, dog smells crate, tells Scruffy to stay, walks to eastern guard tower
   - Needs: NPC ID, spawn position, destination position

5. **Scruffy** (Crate 4 - dog)
   - Action: Smells crate, told to stay at house
   - Needs: NPC ID, spawn position

6. **Bartleby Battson** (Crate 5)
   - Action: Loads crates back into cart, observes plague, complains, goes to inn for guard
   - Needs: NPC ID, spawn position, destination position

7. **Lordaeron Crier** (After all 5 crates)
   - Action: Yells for all guards to come to Stratholme for orders
   - Needs: NPC ID, spawn position, text ID for yell

---

## Implementation Plan

Once NPC IDs are found:

1. **Create SmartAI Scripts** (SQL)
   - Each NPC will have SmartAI script that listens for `SMART_EVENT_DATA_SET` with `DATA_CRATE_REVEALED`
   - Scripts will trigger movement, emotes, and text based on crate number
   - Use `SMART_ACTION_MOVE_TO_POS` for movement
   - Use `SMART_ACTION_TALK` for text
   - Use `SMART_ACTION_PLAY_EMOTE` for emotes

2. **Alternative: C++ Scripts**
   - If SmartAI is insufficient, create C++ scripts for each NPC
   - Scripts will listen for instance data changes via `DoAction()` or similar

3. **Position Verification**
   - Verify crate positions match retail
   - Adjust `IdentifyCrateNumber()` thresholds if needed
   - Verify NPC spawn positions and destinations

---

## Code Changes Made

### Files Modified:
- `realm2/azerothcore/src/server/scripts/Kalimdor/CavernsOfTime/CullingOfStratholme/culling_of_stratholme.h`
  - Added `DATA_CRATE_REVEALED` to `enum Data`

- `realm2/azerothcore/src/server/scripts/Kalimdor/CavernsOfTime/CullingOfStratholme/culling_of_stratholme.cpp`
  - Modified `npc_crate_helperAI::SpellHit()` to identify crate number
  - Added `IdentifyCrateNumber()` function

- `realm2/azerothcore/src/server/scripts/Kalimdor/CavernsOfTime/CullingOfStratholme/instance_culling_of_stratholme.cpp`
  - Added `DATA_CRATE_REVEALED` handler
  - Added `TriggerCrateRPEvent()` function
  - Added `TriggerCrierYell()` function
  - Modified `DATA_CRATE_COUNT` handler to call `TriggerCrierYell()` when all 5 crates revealed

---

## Next Steps

1. **Find NPC IDs** - Search database or Wowhead for the 7 NPCs
2. **Verify Crate Positions** - Test crate identification in-game and adjust if needed
3. **Create SmartAI Scripts** - Write SQL scripts for each NPC's RP sequence
4. **Test RP Sequences** - Verify each NPC performs correct actions

---

**Last Updated:** 2025-01-23

