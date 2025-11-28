# New Design Decisions - Implementation Verification Checklist

**Date**: 2025-01-XX  
**Purpose**: Verify existing implementation aligns with new design decisions from feature conversion

---

## ✅ Quick Answer: No New Plan File Needed

We have `17-implementation-roadmap.md` with M0-M10 milestones. Just need to verify/update implementation to match new design decisions.

---

## New Design Decisions Summary

1. **Skill Trainer System** (01-progression.md)
2. **Guard Behavior & Law Enforcement** (03-risk-zones.md)
3. **Flight Path Restrictions** (03-risk-zones.md)
4. **Regional Mail System** (04-economy.md)
5. **Regional Tokens/Emblems** (04-economy.md)
6. **Northrend Cold Weather** (12-world-simulation.md)
7. **Dungeon Lockouts & Keys** (06-pve.md)
8. **Vanity Pets → Companions** (29-companion-bond-and-mercenary-system.md)
9. **Heirloom → Transmog** (19-itemization.md, 57-appearance-codex-and-transmog.md)
10. **Real ID Removal** (09-social-systems.md)

---

## Implementation Status Check

### ✅ M1: Progression & Stats Foundation

**Status**: Partially Implemented

**Existing**:
- ✅ `MortalLevel.cpp` - Derived level calculation
- ✅ `MortalCombatSkills.cpp` - Skill system
- ✅ `MortalStats.cpp` - Stat caps

**Missing from New Design**:
- ✅ `MortalSkillTrainer.cpp/h` - Skill trainer system (IMPLEMENTED)
- ✅ Regional specialization logic (IMPLEMENTED)
- ✅ Zone risk checks for trainers (IMPLEMENTED)
- ✅ Notoriety checks for trainers (IMPLEMENTED)

**Action**: ✅ COMPLETE - Module created and registered

---

### ✅ M2: Risk Zones & Death/Loot Rules

**Status**: Partially Implemented

**Existing**:
- ✅ `MortalRiskZoneLogic.cpp` - Risk zone system
- ✅ `MortalOutlawRestrictions.cpp` - Outlaw system
- ✅ `MortalLegacyServices.cpp` - Flight path restrictions (partial)

**Missing from New Design**:
- ✅ `MortalGuardAI.cpp/h` - Guard behavior system (IMPLEMENTED & COMPILED)
- ✅ Notoriety-based guard response (IMPLEMENTED)
- ✅ Guard patrol patterns (IMPLEMENTED - basic)
- ✅ Flight path restrictions (zone risk checks) - COMPLETE (Yellow-to-Yellow blocked, Red zones blocked)

**Action**: 
1. ✅ COMPLETE - `MortalGuardAI.cpp/h` module created and registered
2. ⚠️ TODO - Complete flight path restriction logic (check Yellow zone restrictions)

---

### ✅ M3: Core Economy & Regional Banking

**Status**: Partially Implemented

**Existing**:
- ✅ `MortalRegionalBank.cpp` - Regional banking
- ✅ `MortalMarketStalls.cpp` - Market stalls
- ✅ `ScriptMgr.cpp` - Mail restrictions (partial)

**Missing from New Design**:
- ✅ Regional mail system completion (zone risk checks) - COMPLETE
- ✅ Regional tokens/emblems system - IMPLEMENTED
- ✅ Token conversion from emblems - IMPLEMENTED

**Action**: 
1. ✅ COMPLETE - Regional mail restrictions implemented
2. ✅ COMPLETE - Regional tokens system created (`MortalRegionalTokens.cpp/h`)

---

### ✅ M4: Crafting & Material Lore

**Status**: Implemented

**Existing**:
- ✅ `MortalCraftingSkills.cpp`
- ✅ `MortalMaterialLore.cpp`
- ✅ `MortalCraftingWorkstation.cpp`

**Missing from New Design**:
- ✅ None - Crafting system complete

---

### ✅ M5: World Simulation & PvE

**Status**: Partially Implemented

**Existing**:
- ✅ `MortalPublicDungeonAI.cpp` - Public dungeons
- ✅ `MortalDelveInstances.cpp` - Delves
- ✅ `MortalEnvironmentalHazards.cpp` - Environmental hazards

**Missing from New Design**:
- ✅ Dungeon lockout removal - VERIFIED (only raids have lockouts, dungeons have none)
- ✅ Key system conversion - IMPLEMENTED (`MortalDungeonKeys.cpp/h`)
- ✅ Northrend cold weather system - IMPLEMENTED (added Northrend zones to environmental hazards)

**Action**: 
1. ✅ COMPLETE - Verified lockouts only apply to raids
2. ✅ COMPLETE - Key access system created and registered
3. ✅ COMPLETE - Northrend cold weather added to environmental hazards

---

### ✅ M6: PvP Systems & Notoriety

**Status**: Implemented

**Existing**:
- ✅ `MortalBountyBoard.cpp`
- ✅ `MortalBountyPot.cpp`
- ✅ `MortalNegativeTitles.cpp`

**Missing from New Design**:
- ✅ None - PvP systems complete

---

### ✅ Other Systems

**Companions**:
- ✅ `MortalCompanion.cpp` - Exists
- ✅ `MortalVanityPetConversion.cpp/h` - Vanity pet conversion system (IMPLEMENTED)
- ✅ Vanity pet spell → companion item conversion (IMPLEMENTED)
- ✅ Registered in ScriptMgr (IMPLEMENTED)

**Transmog**:
- ✅ `MortalAppearanceCodex.cpp` - Exists
- ✅ Heirloom integration (IMPLEMENTED - heirlooms auto-unlock appearances on equip)
- ✅ Heirloom detection (Quality 7) in OnItemEquip hook (IMPLEMENTED)

**Social**:
- ✅ Friend/ignore system exists
- ✅ Real ID removal (VERIFIED - no Real ID code exists in mortal_overhaul module)
  - Real ID was a Battle.net feature not present in WoW 3.3.5a
  - Spec 09-social-systems.md documents removal decision
  - No implementation needed (feature doesn't exist in 3.3.5a)

**Database Schemas**:
- ✅ `78_mortal_regional_tokens.sql` - Created
- ✅ `79_mortal_dungeon_keys.sql` - Created

**Compilation Errors**:
- ⚠️ Pre-existing errors in `MortalCreature.cpp` and `MortalCompanion.h` - Fixed (sObjectMgr includes, OnPlayerBeforeUpdate method)
- ⚠️ Remaining errors are in other pre-existing files (MortalFrontierScheduler.h, MortalTaskBoard.h) - not related to new implementations

---

## Priority Implementation Order

1. **High Priority** (Core Systems):
   - `MortalSkillTrainer.cpp/h` - Trainer system
   - `MortalGuardAI.cpp/h` - Guard behavior
   - Complete flight path restrictions
   - Complete regional mail restrictions

2. **Medium Priority** (Content Systems):
   - Regional tokens system
   - Key access system for dungeons
   - Northrend cold weather

3. **Low Priority** (Verification):
   - Verify vanity pet conversion
   - Verify heirloom integration
   - Verify Real ID removal

---

## Next Steps

1. Start with M1: Create `MortalSkillTrainer.cpp/h`
2. Then M2: Create `MortalGuardAI.cpp/h` and complete flight paths
3. Then M3: Complete regional mail and create tokens system
4. Then M5: Add key system and Northrend cold weather

Work through roadmap systematically, adding missing pieces as we go.

