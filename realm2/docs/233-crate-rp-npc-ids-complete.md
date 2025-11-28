# Crate RP Events - NPC IDs Complete

**Date:** 2025-01-23  
**Status:** NPC IDs Found and Added to Code

---

## NPC IDs Verified

### Crate Event NPCs

1. **Roger Owens** (Crate 1)
   - **NPC ID:** 27903
   - **Action:** Goes to inn, discovers crate, runs to find guard
   - **Status:** ✅ Added to header file

2. **Sergeant Morigan** (Crate 2)
   - **NPC ID:** 27877
   - **Action:** Inspects crate next to Perelli, discovers plague, leaves to alert Arthas
   - **Status:** ✅ Added to header file

3. **Jena Anderson** (Crate 3)
   - **NPC ID:** 27885
   - **Action:** Asks to borrow grain from Martha Goslin, discovers plague, leaves to find guard
   - **Status:** ✅ Added to header file

4. **Malcolm Moore** (Crate 4)
   - **NPC ID:** 27891
   - **Action:** Approaches from side of house, dog smells crate, tells Scruffy to stay, walks to eastern guard tower
   - **Status:** ✅ Added to header file

5. **Scruffy** (Crate 4 - dog)
   - **NPC ID:** 27892 (TODO: Verify - assumed based on proximity to Malcolm Moore)
   - **Action:** Smells crate, told to stay at house
   - **Status:** ⚠️ Added but needs verification

6. **Bartleby Battson** (Crate 5)
   - **NPC ID:** 27907
   - **Action:** Loads crates back into cart, observes plague, complains, goes to inn for guard
   - **Status:** ✅ Added to header file

7. **Lordaeron Crier** (After all 5 crates)
   - **NPC ID:** 27913
   - **Action:** Yells for all guards to come to Stratholme for orders
   - **Status:** ✅ Added to header file

---

## Code Changes

### Files Modified:

1. **`culling_of_stratholme.h`**
   - Added NPC IDs to `enum Creatures`:
     - `NPC_ROGER_OWENS = 27903`
     - `NPC_SERGEANT_MORIGAN = 27877`
     - `NPC_JENA_ANDERSON = 27885`
     - `NPC_MALCOLM_MOORE = 27891`
     - `NPC_SCRUFFY = 27892`
     - `NPC_BARTLEBY_BATTSON = 27907`
     - `NPC_LORDAERON_CRIER = 27913`
   - Added `ACTION_CRATE_REVEALED = 100` to `enum Actions`

2. **`instance_culling_of_stratholme.cpp`**
   - Implemented `TriggerCrateRPEvent(uint32 crateNumber)` function
   - Implemented `TriggerCrierYell()` function
   - Added `GetCreatureByEntry(uint32 entry)` helper function

3. **`culling_of_stratholme.cpp`**
   - Modified `npc_crate_helperAI::SpellHit()` to identify crate number
   - Added `IdentifyCrateNumber()` function

---

## Next Steps

1. **Verify Scruffy NPC ID** - Confirm 27892 is correct (or find correct ID)
2. **Create SmartAI Scripts** - Write SQL scripts with:
   - Waypoint paths for movement
   - Text IDs from `creature_text` table
   - Emote IDs
   - Timing/delays
3. **Test RP Sequences** - Verify each NPC performs correct actions
4. **Adjust Crate Positions** - Verify crate identification thresholds match retail

---

## SmartAI Script Requirements

Each NPC needs SmartAI scripts that:
- Listen for `SMART_EVENT_ACTION_DONE` with `event_param1 = 100` (ACTION_CRATE_REVEALED)
- Perform movement using `SMART_ACTION_MOVE_TO_POS` or waypoints
- Display text using `SMART_ACTION_TALK` (requires `creature_text` entries)
- Play emotes using `SMART_ACTION_PLAY_EMOTE`
- Despawn or move to final destination after RP

---

**Last Updated:** 2025-01-23

