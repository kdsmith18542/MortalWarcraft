# Culling of Stratholme Comprehensive Fix Plan

**Date:** 2025-01-23  
**Purpose:** Fix all related Culling of Stratholme issues together

---

## Issues to Fix Together

### ✅ Phase 1: Wave System (IN PROGRESS)
1. ✅ **#23830** - Wave spawn positions randomized (DONE)
2. **#21766** - Waves are not patrolling (NEXT - HIGH PRIORITY)

### Phase 2: RP Events (HIGH PRIORITY)
3. **#15630** - Arthas should not be spawned until "this city must be purged" RP speech
4. **#15632** - Footmen, Mage-Priests, and Sorceresses do not emote at end of Arthas' speech
5. **#15629** - No RP events in response to revealing the crates being plagued

### Phase 3: NPC Behavior
6. **#15626** - First pack of Stratholme Citizens/Residents do not gossip about "the situation"
7. **#15621** - Brandon Eiredeck's crowd of Agitated Stratholme Citizens are not very agitated
8. **#15620** - Patricia O'Reilly's crowd of Agitated Stratholme Citizens are not very agitated
9. **#15623** - Stephanie Sindree is not being harassed

### Phase 4: Chromie/Dialog
10. **#21767** - Chromie has wrong dialog options at beginning
11. **#18561** - Chromie (ID: 26527) no action support for Gossip Menu 9586 option 1

### Phase 5: Visual/Other
12. **#15627** - Arcane Disruption visual effect too large
13. **#16465** - Problem npc [gitated stratholme resident]

---

## Detailed Issue Analysis

### #21766 - Waves are not patrolling
**Problem:** Waves stand in place after spawning  
**Expected:** All waves should patrol Stratholme (bosses included)  
**Evidence:** YouTube video shows packs patrolling  
**Fix:** Add waypoint movement to spawned wave creatures

### #15630 - Arthas spawn timing
**Problem:** Arthas is spawned on bridge from moment you enter instance  
**Expected:** Arthas should only spawn when Chromie gossip is used (after "this city must be purged" speech)  
**Fix:** Move Arthas spawn to Chromie gossip handler, spawn closer to Stratholme

### #15632 - Troops don't emote
**Problem:** Footmen, Mage-Priests, Sorceresses don't cheer after Arthas' speech  
**Expected:** All troops should do cheering emote  
**Fix:** Add emote command to troops after Arthas finishes speech

### #15629 - No RP events for crates
**Problem:** Revealing crates only shows visual effect, no RP events  
**Expected:** Each crate should trigger specific RP event:
- Crate 1: Roger Owens discovers crate, runs to find guard
- Crate 2: Sergeant Morigan inspects, leaves to alert Arthas
- Crate 3: Jena Anderson borrows grain, discovers plague, leaves
- Crate 4: Malcolm Moore and Scruffy approach, dog smells crate, Malcolm goes to guard tower
- Crate 5: Bartleby Battson loads crates, discovers plague, goes to inn
- After all 5: Lordaeron Crier yells for guards

**Fix:** Add SmartAI scripts for each NPC to trigger on crate reveal

### #15626 - Citizens don't gossip
**Problem:** First pack of Citizens/Residents are silent  
**Expected:** They should talk about illness and poor days  
**Fix:** Add gossip/emote system to citizens

### #21767 - Chromie dialog wrong
**Problem:** "Yes, please!" option appears even if quest chain not done  
**Expected:** Should only appear after quest 13151 (A Royal Escort) and after choosing other dialog option  
**Fix:** Add quest check to Chromie gossip menu

---

## Implementation Plan

### Step 1: Fix Wave Patrolling (#21766)
- Add waypoint movement to `SummonNextWave()` function
- Create waypoint paths for each wave type
- Ensure bosses also patrol

### Step 2: Fix Arthas Spawn (#15630)
- Remove Arthas spawn from instance initialization
- Add Arthas spawn to Chromie gossip handler
- Adjust spawn position to be closer to Stratholme

### Step 3: Fix Troop Emotes (#15632)
- Find where Arthas finishes speech
- Add emote command to all Footmen, Mage-Priests, Sorceresses
- Use EMOTE_ONESHOT_CHEER or similar

### Step 4: Fix Crate RP Events (#15629)
- Create SmartAI scripts for each NPC:
  - Roger Owens (crate 1)
  - Sergeant Morigan (crate 2)
  - Jena Anderson (crate 3)
  - Malcolm Moore + Scruffy (crate 4)
  - Bartleby Battson (crate 5)
  - Lordaeron Crier (after all 5)
- Link scripts to crate reveal events

### Step 5: Fix Citizens Gossip (#15626)
- Add gossip/emote system to Stratholme Citizens/Residents
- Use random gossip or emote on spawn/timer

### Step 6: Fix Chromie Dialog (#21767)
- Add quest check (13151) to Chromie gossip menu
- Conditionally show "Yes, please!" option

---

## Files to Modify

1. **`culling_of_stratholme.cpp`**
   - `SummonNextWave()` - Add patrolling
   - `npc_arthas::npc_arthasAI` - Fix spawn timing, add troop emotes
   - Chromie gossip handler - Fix dialog, add Arthas spawn

2. **`instance_culling_of_stratholme.cpp`**
   - Remove Arthas spawn from initialization
   - Add crate reveal event handlers

3. **SQL Files (SmartAI)**
   - Create SmartAI scripts for crate RP NPCs
   - Add gossip/emote to citizens
   - Add waypoints for wave patrolling

---

## Testing Plan

1. **Wave Patrolling:**
   - Enter dungeon, start waves
   - Verify waves patrol instead of standing still
   - Verify bosses patrol

2. **Arthas Spawn:**
   - Enter dungeon, verify Arthas NOT on bridge
   - Talk to Chromie, verify Arthas spawns after gossip
   - Verify spawn position is correct

3. **Troop Emotes:**
   - Complete intro RP
   - Verify troops cheer after Arthas' speech

4. **Crate RP Events:**
   - Reveal each crate one by one
   - Verify correct NPC reacts for each crate
   - Verify Lordaeron Crier yells after all 5

5. **Citizens Gossip:**
   - Enter Stratholme
   - Verify first pack of citizens gossip/talk

6. **Chromie Dialog:**
   - Test with character that hasn't done quest chain
   - Test with character that has done quest chain
   - Verify "Yes, please!" only appears when appropriate

---

## Priority Order

**Immediate (Fix with Wave Spawns):**
1. #21766 - Wave patrolling (directly related)
2. #15630 - Arthas spawn timing (affects intro)
3. #15632 - Troop emotes (affects intro)

**Next Batch:**
4. #15629 - Crate RP events (major RP content)
5. #15626 - Citizens gossip (immersion)

**Later:**
6. #21767 - Chromie dialog (polish)
7. Other NPC behavior issues

---

**Last Updated:** 2025-01-23

