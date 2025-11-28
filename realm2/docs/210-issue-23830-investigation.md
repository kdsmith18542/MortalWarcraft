# Issue #23830 Investigation: Culling of Stratholme Wave Spawn Positions

**Date:** 2025-01-23  
**Status:** Blocked - Needs Retail Verification Data

---

## Issue Summary

**Title:** [Culling of Stratholme] Wave spawn positions are fixed  
**Link:** https://github.com/azerothcore/azerothcore-wotlk/issues/23830  
**Priority:** Medium  
**Type:** DB/Dungeon

---

## Current Implementation

Wave spawn positions are hardcoded in the `WavesLocations` array in:
- `src/server/scripts/Kalimdor/CavernsOfTime/CullingOfStratholme/culling_of_stratholme.cpp`

### Wave Spawn System

1. **Array Definition** (lines 191-241):
   - `WavesLocations[ENCOUNTER_WAVES_NUMBER][ENCOUNTER_WAVES_MAX_SPAWNS][5]`
   - 8 waves total (`ENCOUNTER_WAVES_NUMBER = 8`)
   - 4 spawns per wave (`ENCOUNTER_WAVES_MAX_SPAWNS = 4`)
   - Each spawn has: `[NPC_ENTRY, X, Y, Z, ORIENTATION]`

2. **Spawn Logic** (lines 1218-1232):
   - `SummonNextWave()` function uses `waveGroupId` to index into `WavesLocations`
   - Special handling: if `waveGroupId > 4`, it decrements by 1 (skips wave 4 for boss spawns)
   - Spawns creatures at fixed coordinates from the array

3. **Wave Progression**:
   - Waves 0-3: Normal waves
   - Wave 4: Meathook boss spawn
   - Waves 5-7: Continue after Meathook (using indices 4-6 due to decrement)

---

## Problem

**From GitHub Issue #23830:**

**Actual Bug:**
- Waves and bosses **always spawn in the same place** (hardcoded)
- They should spawn at **randomized positions**

**Current Behavior:**
- Hardcoded positions in `WavesLocations` array
- Same spawns every time

**Expected Behavior:**
- Spawn positions should be **randomized**
- Bosses should appear at different positions each run

**Evidence:**
- YouTube videos showing 2nd boss at different positions:
  - https://youtu.be/2p5H5NH8LfE?t=505
  - https://youtu.be/mrkVP6BJEMw?t=11

---

## What We Need

1. **Watch YouTube Videos:**
   - https://youtu.be/2p5H5NH8LfE?t=505 (2nd boss position)
   - https://youtu.be/mrkVP6BJEMw?t=11 (different position)
   - Note the different spawn positions
   - Extract coordinate ranges if possible

2. **Implement Randomization:**
   - Create pool of possible spawn positions
   - Randomize selection from pool
   - Or use database spawns with randomization

---

## Current Status

**Ready to Fix** - Issue is clear: need to randomize spawn positions.

**Next Steps:**
1. Watch YouTube videos to see position variations
2. Create pool of possible spawn positions
3. Implement randomization in `SummonNextWave()` function
4. Test in-game to verify randomization works

---

## Code Location

- **File:** `realm2/azerothcore/src/server/scripts/Kalimdor/CavernsOfTime/CullingOfStratholme/culling_of_stratholme.cpp`
- **Lines:** 191-241 (array definition), 1218-1232 (spawn logic)
- **Function:** `npc_arthas::npc_arthasAI::SummonNextWave()`

---

## Notes

- This is a dungeon-specific issue, not a critical blocker
- May affect dungeon flow/immersion but doesn't block progression
- Can be deferred until retail data is available

