# Crate RP Events NPC IDs - Verified

**Date:** 2025-01-23  
**Source:** ScriptDevAI backup file + Database verification

---

## NPC IDs Verified

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
   - **NPC ID:** **TO BE FOUND** - Need to search database for dog NPCs near Malcolm Moore
   - **Action:** Smells crate, told to stay at house

6. **Bartleby Battson** (Crate 5)
   - **NPC ID:** 27907
   - **Action:** Loads crates back into cart, observes plague, complains, goes to inn for guard

7. **Lordaeron Crier** (After all 5 crates)
   - **NPC ID:** 27913
   - **Action:** Yells for all guards to come to Stratholme for orders

---

## Source

These IDs were found in:
- `mod-playerbots.backup/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/culling_of_stratholme/culling_of_stratholme.h`

```cpp
// Grain Event NPCs
NPC_ROGER_OWENS                 = 27903,
NPC_SERGEANT_MORIGAN            = 27877,
NPC_JENA_ANDERSON               = 27885,
NPC_MALCOM_MOORE                = 27891,                // Not (yet?) spawned
NPC_BARTLEBY_BATTSON            = 27907,
NPC_LORDAERON_CRIER             = 27913,
```

---

## Next Steps

1. **Find Scruffy NPC ID** - Search database for dog NPCs or check nearby entry IDs
2. **Add NPC IDs to header file** - Add to `culling_of_stratholme.h` enum Creatures
3. **Create SmartAI scripts** - SQL scripts for each NPC's RP sequence
4. **Implement TriggerCrateRPEvent** - Complete the function with NPC lookups and actions

---

**Last Updated:** 2025-01-23

