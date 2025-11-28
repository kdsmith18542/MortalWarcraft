# Culling of Stratholme Fixes - Progress Update

**Date:** 2025-01-23  
**Status:** In Progress

---

## ✅ Completed Fixes

### 1. #23830 - Wave spawn positions randomized
- **Status:** ✅ **COMPLETE**
- **Implementation:** Fisher-Yates shuffle algorithm in `SummonNextWave()`
- **Files:** `culling_of_stratholme.cpp`

### 2. #21766 - Waves are not patrolling
- **Status:** ✅ **COMPLETE**
- **Implementation:** Added `MoveRandom(15.0f)` to spawned wave creatures
- **Files:** `culling_of_stratholme.cpp`

### 3. #15630 - Arthas spawn timing
- **Status:** ✅ **COMPLETE**
- **Implementation:** Hide Arthas initially, show after Chromie gossip, reposition closer to Stratholme
- **Files:** `instance_culling_of_stratholme.cpp`

### 4. #15632 - Troops don't emote
- **Status:** ✅ **COMPLETE**
- **Implementation:** Added cheer emote to Footmen (27745) and Mage-Priests (27747) after Arthas speech
- **Files:** `culling_of_stratholme.cpp`

### 5. #15626 - Citizens don't gossip
- **Status:** ✅ **COMPLETE**
- **Implementation:** Added periodic random emotes (Talk/Exclamation/Question) to citizens before city intro
- **Files:** `culling_of_stratholme.cpp`
- **Note:** Uses emotes to simulate gossip. For actual text, would need `creature_text` entries.

---

## 🔄 In Progress

### 6. #15629 - No RP events for crates
- **Status:** 🔄 **INVESTIGATION**
- **Required:**
  - Find NPC IDs for: Roger Owens, Sergeant Morigan, Jena Anderson, Malcolm Moore, Scruffy, Bartleby Battson, Lordaeron Crier
  - Modify crate system to track which crate (1-5) was revealed
  - Create SmartAI or C++ scripts for each NPC's RP sequence
- **Files:** `culling_of_stratholme.cpp`, `instance_culling_of_stratholme.cpp`, SQL SmartAI scripts

---

## 📋 Remaining Issues

### High Priority
- **#15629** - Crate RP events (in progress)

### Medium Priority
- **#21767** - Chromie wrong dialog options
- **#15621, #15620, #15623** - NPCs not agitated/harassed

### Lower Priority
- **#15627** - Arcane Disruption visual too large
- **#16465** - Agitated resident problem

---

## Summary

**Completed:** 5 fixes  
**In Progress:** 1 fix  
**Remaining:** 6+ issues

---

**Last Updated:** 2025-01-23

