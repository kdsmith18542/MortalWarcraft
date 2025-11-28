# Crate RP Events NPC IDs - Found

**Date:** 2025-01-23  
**Source:** ScriptDevAI backup file (`mod-playerbots.backup/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/culling_of_stratholme/culling_of_stratholme.h`)

---

## NPC IDs Found

### Crate Event NPCs

1. **Roger Owens** (Crate 1)
   - **NPC ID:** 27903
   - **Action:** Goes to inn, discovers crate, runs to find guard

2. **Sergeant Morigan** (Crate 2)
   - **NPC ID:** 27877
   - **Action:** Inspects crate next to Perelli, discovers plague, leaves to alert Arthas

3. **Jena Anderson** (Crate 3)
   - **NPC ID:** 27885
   - **Action:** Asks to borrow grain from Martha Goslin, discovers plague, leaves to find guard

4. **Malcolm Moore** (Crate 4)
   - **NPC ID:** 27891
   - **Note:** Comment in ScriptDevAI says "Not (yet?) spawned" - may need to be spawned dynamically
   - **Action:** Approaches from side of house, dog smells crate, tells Scruffy to stay, walks to eastern guard tower

5. **Scruffy** (Crate 4 - dog)
   - **NPC ID:** **NOT FOUND YET** - Need to search for this
   - **Action:** Smells crate, told to stay at house

6. **Bartleby Battson** (Crate 5)
   - **NPC ID:** 27907
   - **Action:** Loads crates back into cart, observes plague, complains, goes to inn for guard

7. **Lordaeron Crier** (After all 5 crates)
   - **NPC ID:** 27913
   - **Action:** Yells for all guards to come to Stratholme for orders

---

## Next Steps

1. **Find Scruffy NPC ID** - Search database or Wowhead
2. **Add NPC IDs to header file** - Add to `culling_of_stratholme.h` enum Creatures
3. **Create SmartAI scripts** - SQL scripts for each NPC's RP sequence
4. **Implement TriggerCrateRPEvent** - Complete the function with NPC lookups and actions

---

**Last Updated:** 2025-01-23

