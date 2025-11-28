# Culling of Stratholme Fixes - Implementation Summary

**Date:** 2025-01-23  
**Status:** Partially Implemented

---

## Fixes Implemented

### ✅ #21766 - Waves are not patrolling
**Status:** ✅ **IMPLEMENTED**

**Changes:**
- Modified `SummonNextWave()` in `culling_of_stratholme.cpp`
- Added `MoveRandom(15.0f)` to spawned wave creatures
- Set `SetWanderDistance(15.0f)` to allow patrolling within 15 yards of spawn point

**Files Modified:**
- `realm2/azerothcore/src/server/scripts/Kalimdor/CavernsOfTime/CullingOfStratholme/culling_of_stratholme.cpp`

**Code:**
```cpp
// After summoning each creature:
summoned->SetWanderDistance(15.0f);
summoned->GetMotionMaster()->MoveRandom(15.0f);
```

---

### ✅ #15630 - Arthas spawn timing
**Status:** ✅ **IMPLEMENTED**

**Changes:**
- Modified `OnCreatureCreate()` in `instance_culling_of_stratholme.cpp` to hide Arthas initially
- Modified `SetData()` for `DATA_ARTHAS_EVENT` to make Arthas visible when intro starts
- Reposition Arthas to `LeaderIntroPos1` (closer to Stratholme) when intro begins

**Files Modified:**
- `realm2/azerothcore/src/server/scripts/Kalimdor/CavernsOfTime/CullingOfStratholme/instance_culling_of_stratholme.cpp`

**Code:**
```cpp
// In OnCreatureCreate:
else if (_encounterState == COS_PROGRESS_NOT_STARTED || _encounterState == COS_PROGRESS_CRATES_FOUND)
    creature->SetVisible(false);

// In SetData when COS_PROGRESS_START_INTRO:
arthas->SetVisible(true);
arthas->UpdatePosition(LeaderIntroPos1, true);
arthas->SetHomePosition(LeaderIntroPos1);
arthas->SetFacingTo(LeaderIntroPos1.GetOrientation());
```

---

### ⚠️ #15632 - Troops don't emote
**Status:** ⚠️ **PARTIALLY IMPLEMENTED** (Needs NPC ID verification)

**Changes:**
- Added code structure to find and emote troops after Arthas' speech (SAY_PHASE118)
- Code is ready but NPC IDs need to be verified

**Files Modified:**
- `realm2/azerothcore/src/server/scripts/Kalimdor/CavernsOfTime/CullingOfStratholme/culling_of_stratholme.cpp`

**What's Needed:**
1. Find correct NPC IDs for:
   - Lordaeron Footman
   - Lordaeron Mage-Priest (NOT 26499, that's Arthas)
   - Lordaeron Sorceress
2. Verify if these are static spawns or dynamically spawned
3. Test the emote range (currently 50.0f)

**Next Steps:**
- Query database for NPCs in Culling of Stratholme with "Footman", "Mage", "Sorceress" in name
- Or use Wowhead to find the correct NPC IDs
- Update the code with correct IDs and test

---

## Testing Checklist

### #21766 - Wave Patrolling
- [ ] Enter Culling of Stratholme
- [ ] Start waves by talking with Arthas
- [ ] Wait before pulling waves
- [ ] Verify waves patrol/move instead of standing still
- [ ] Verify bosses also patrol

### #15630 - Arthas Spawn Timing
- [ ] Enter dungeon
- [ ] Verify Arthas is NOT visible on bridge initially
- [ ] Complete crate reveal
- [ ] Talk to Chromie and use gossip to start intro
- [ ] Verify Arthas spawns/becomes visible after Chromie gossip
- [ ] Verify Arthas spawns closer to Stratholme (at LeaderIntroPos1)

### #15632 - Troop Emotes
- [ ] Complete intro RP event
- [ ] Wait for Arthas to finish SAY_PHASE118 speech
- [ ] Verify Footmen, Mage-Priests, and Sorceresses cheer
- [ ] Note: Requires NPC ID verification first

---

## Remaining Issues to Fix

### High Priority
1. **#15629** - No RP events in response to revealing crates (5 different NPCs)
2. **#15626** - First pack of Citizens/Residents don't gossip

### Medium Priority
3. **#21767** - Chromie wrong dialog options
4. **#15621, #15620, #15623** - NPCs not agitated/harassed

### Lower Priority
5. **#15627** - Arcane Disruption visual too large
6. **#16465** - Agitated resident problem

---

## Notes

- All code changes compile without errors
- Need to verify NPC IDs for troop emotes (#15632)
- Wave patrolling uses random movement which should work well for patrolling behavior
- Arthas spawn fix ensures he only appears after Chromie gossip, matching retail behavior

---

**Last Updated:** 2025-01-23

