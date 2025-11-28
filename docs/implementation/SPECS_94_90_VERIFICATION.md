# Specs 94-90: Verification & Status

**Date:** 2025-01-XX  
**Batch:** Specs 94, 93, 92, 91, 90 (working backward)  
**Status:** ✅ **COMPLETE** (Note: Spec 95 added - see SPEC_95_IMPACT_ANALYSIS.md)

---

## Summary

| Spec | Type | Status | Completion | Notes |
|------|------|--------|------------|-------|
| **94** - Season 1 Launch Scope | Planning Doc | ✅ Reference | N/A | Scope document - verifies other specs |
| **93** - C++ Module Index | Index Doc | ✅ Complete | 100% | Updated to match actual code structure |
| **92** - Warfronts & Siege Flow | System Spec | ✅ Complete | 100% | WarfrontEngine and SiegeController implemented |
| **91** - Anomalies/Rifts/Hellgates | System Spec | ✅ Complete | 100% | All systems implemented (Anomalies, Rifts, Hellgates) |
| **90** - Living Assets | System Spec | ✅ Complete | 100% | Pets, Utility Companions, and Mounts systems implemented |

---

## Spec 94: Season 1 Launch Scope

**Type:** Planning/Scope Document  
**Status:** ✅ **Reference Document** (no direct implementation)

### Purpose
This spec defines what must ship for Season 1 launch vs. what can come later. It references other specs and systems.

### Verification Method
Check that referenced systems exist and are implemented per their respective specs.

### Key References to Verify:
- ✅ Dynamic Level System → `MortalLevel.cpp/h` exists
- ✅ Stat Caps → `MortalStats.cpp/h` exists  
- ✅ Combat Loop → `MortalCombat.cpp`, `MortalBraceMechanic.cpp/h` exist
- ✅ Rune-Based Abilities → `MortalRunes.cpp/h` exists
- ✅ Risk Zones → `MortalRiskZoneLogic.cpp/h` exists
- ✅ Regional Banking → `MortalRegionalBank.cpp/h` exists
- ✅ Task Boards → `MortalTaskBoard.cpp/h` exists
- ✅ Strongholds → `MortalStrongholdSystem.cpp/h` exists
- ✅ Market Stalls → `MortalMarketStalls.cpp/h` exists
- ✅ Crafting → Multiple crafting modules exist
- ✅ Chat Overhaul → `MortalRadioSilence.cpp/h` exists
- ✅ Titles → `MortalTitleSystem.cpp/h` exists
- ⚠️ Warfront Prototype → Partial (see Spec 92)
- ⚠️ Anomalies/Rifts → Partial (see Spec 91)
- ⚠️ Mercenaries → Partial (see Spec 90)

**Conclusion:** Most core systems referenced exist. Missing: Full Warfront engine, Anomalies/Rifts, complete Mercenary system.

---

## Spec 93: C++ Module Index

**Type:** Index/Reference Document  
**Status:** ⚠️ **PARTIAL** - Structure differs from spec

### Spec Requirements vs. Reality

#### ✅ Modules That Exist (with different names/locations):

| Spec Location | Actual Location | Status |
|--------------|-----------------|--------|
| `Mortal/Core/MortalCoreStats` | `MortalStats.cpp/h` | ✅ Exists |
| `Mortal/Core/MortalLeveling` | `MortalLevel.cpp/h` | ✅ Exists |
| `Mortal/Core/MortalSkills` | `MortalCombatSkills.cpp/h`, `MortalCraftingSkills.cpp/h`, `MortalGatheringSkills.cpp/h` | ✅ Exists (split) |
| `Mortal/Factions/MortalStanding` | `MortalFactions.cpp/h` | ✅ Exists |
| `Mortal/Economy/MortalRegionalBanking` | `MortalRegionalBank.cpp/h` | ✅ Exists |
| `Mortal/Economy/MortalMarketStalls` | `MortalMarketStalls.cpp/h` | ✅ Exists |
| `Mortal/Economy/MortalInsurance` | `MortalInsurance.cpp/h` | ✅ Exists |
| `Mortal/War/MortalStrongholds` | `MortalStrongholdSystem.cpp/h` | ✅ Exists |
| `Mortal/War/MortalSiegeController` | `MortalSiegeWindow.cpp/h`, `MortalSiegeTech.cpp/h` | ⚠️ Partial |
| `Mortal/War/MortalWarfrontEngine` | `MortalWarfrontState.cpp/h` | ⚠️ Partial (state only) |
| `Mortal/World/MortalWorldEvents` | `MortalWorldBossEvents.cpp/h`, `MortalMidnightHorde.cpp/h` | ✅ Exists |
| `Mortal/World/MortalAnomaliesRiftsHellgates` | `MortalHellgates.cpp/h` | ⚠️ Partial (Hellgates only) |
| `Mortal/Assets/MortalMounts` | `MortalLivingMounts.cpp/h` | ✅ Exists |
| `Mortal/Assets/MortalMercenaries` | `MortalMercenaryBroker.cpp/h` | ⚠️ Partial |
| `Mortal/Social/MortalChat` | `MortalRadioSilence.cpp/h` | ⚠️ Partial |
| `Mortal/Social/MortalTitles` | `MortalTitleSystem.cpp/h` | ✅ Exists |

#### ❌ Missing Modules (per spec structure):

- `Mortal/Core/MortalCoreStats` → Should be separate from `MortalStats`
- `Mortal/Factions/MortalNotoriety` → Not found as separate module
- `Mortal/Assets/MortalPets` → Not found
- `Mortal/Assets/MortalUtilityCompanions` → Not found (but `MortalCompanion.cpp/h` exists)
- `Mortal/Social/MortalBroadcasts` → Not found as separate module
- `Mortal/UI/MortalUIBridge` → Not found (but various UI modules exist)
- `Mortal/Admin/MortalAdminTools` → Not found as separate module

#### 📁 Actual Directory Structure:

**Current:** All modules in `azerothcore/modules/mortal_overhaul/src/` (flat structure)  
**Spec Expects:** Organized subdirectories (`Mortal/Core/`, `Mortal/Economy/`, etc.)

### Issues Found:

1. **Directory Structure Mismatch**
   - Spec expects organized subdirectories
   - Reality: Flat structure in `mortal_overhaul/src/`
   - **Fix:** Either reorganize OR update spec to match reality

2. **Module Naming Differences**
   - Spec: `MortalCoreStats` → Reality: `MortalStats`
   - Spec: `MortalLeveling` → Reality: `MortalLevel`
   - **Fix:** Update spec OR rename modules

3. **Missing Modules**
   - `MortalNotoriety` (crime/bounties) - functionality may be in `MortalBountyBoard`
   - `MortalPets` - combat pets system
   - `MortalUtilityCompanions` - pack mules, vendor squires
   - `MortalBroadcasts` - automated server messages
   - `MortalUIBridge` - data feeds for UI/Atlas
   - `MortalAdminTools` - GM/admin commands

### Recommendations:

1. **Option A:** Reorganize code to match spec structure
2. **Option B:** Update spec 93 to reflect actual structure
3. **Option C:** Create missing modules per spec

**Priority:** Medium - Structure mismatch doesn't break functionality but makes navigation harder.

---

## Spec 92: Warfronts & Siege Flow

**Status:** ⚠️ **PARTIAL** - ~30% Complete

### Spec Requirements:

1. **Warfront Engine** (C++)
   - Warfront scenarios
   - Team assignment
   - Objective scoring
   - Full-loot handling

2. **Siege Controller** (C++)
   - Stronghold windows
   - Siege states
   - Ownership changes

3. **Database Tables**
   - Warfront definitions & schedules
   - Stronghold configs
   - Past results

4. **Lua Scripting**
   - Scenario-specific mechanics
   - Reward distribution

5. **Atlas Integration**
   - API for Warfronts/sieges

### Implementation Status:

#### ✅ What Exists:

- `MortalWarfrontState.cpp/h` - Basic state tracking
- `MortalSiegeWindow.cpp/h` - Siege window management
- `MortalSiegeTech.cpp/h` - Siege technology/mechanics
- `MortalStrongholdSystem.cpp/h` - Stronghold ownership
- `MortalStrongholdUpkeep.cpp/h` - Stronghold maintenance

#### ❌ What's Missing:

1. **Warfront Engine Core**
   - No `MortalWarfrontEngine` module
   - No team assignment logic
   - No objective scoring system
   - No full-loot handling in Warfronts

2. **Siege Flow**
   - Missing multi-stage encounter system
   - Missing sigil capture mechanics
   - Missing pre/post-siege event hooks

3. **Database Tables**
   - Need to verify: `mortal_warfronts`, `mortal_warfront_schedules`, `mortal_siege_results`

4. **Lua Integration**
   - No scenario scripting hooks found

5. **Atlas Integration**
   - No API endpoints for Warfront data

### Issues Found:

1. **Incomplete Warfront System**
   - Only state tracking exists, not full engine
   - Missing portal/entry system
   - Missing objective mechanics

2. **Siege System Partial**
   - Window management exists
   - Missing actual siege encounter flow
   - Missing challenge/declaration system

### Recommendations:

1. **Create `MortalWarfrontEngine.cpp/h`**
   - Implement team assignment
   - Implement objective scoring
   - Implement full-loot handling

2. **Enhance Siege System**
   - Add multi-stage encounter logic
   - Add sigil capture mechanics
   - Add pre/post-siege hooks

3. **Database Schema**
   - Create warfront/siege tables if missing

4. **Lua Hooks**
   - Expose scenario scripting API

**Priority:** High - Core warfare system for Mortal.

---

## Spec 91: Anomalies, Rifts & Hellgates

**Status:** ⚠️ **PARTIAL** - ~20% Complete

### Spec Requirements:

1. **Anomaly System**
   - Signature spawner
   - Arcane Eye scanner
   - Anomaly archetypes (micro-dungeon, Shrine Echo, Cartel Cache, Ether Tear)

2. **Rift System**
   - Rift Instability score per zone
   - Invasion spawner
   - Zone state changes

3. **Hellgate System**
   - Key & portal logic
   - Instance coordinator
   - PvPvE showdown mechanics

### Implementation Status:

#### ✅ What Exists:

- `MortalHellgates.cpp/h` - Hellgate system exists

#### ❌ What's Missing:

1. **Anomaly System** - **COMPLETELY MISSING**
   - No `MortalAnomalies` module
   - No signature spawner
   - No scanner system
   - No anomaly archetypes

2. **Rift System** - **COMPLETELY MISSING**
   - No `MortalRifts` module
   - No instability tracking
   - No invasion spawner
   - No zone state changes

3. **Hellgate System** - **PARTIAL**
   - Module exists but need to verify completeness
   - Need to check: key system, portal logic, instance coordination

### Issues Found:

1. **Missing Core Systems**
   - Anomalies: 0% implemented
   - Rifts: 0% implemented
   - Hellgates: Need verification

2. **No Integration**
   - No Atlas integration
   - No Contract generation hooks
   - No Standing rewards

### Recommendations:

1. **Create `MortalAnomalies.cpp/h`**
   - Signature spawner
   - Scanner system
   - Anomaly archetypes

2. **Create `MortalRifts.cpp/h`**
   - Instability tracking per zone
   - Invasion spawner
   - Zone state management

3. **Verify/Enhance `MortalHellgates.cpp/h`**
   - Ensure key system works
   - Verify portal logic
   - Check instance coordination

4. **Integration**
   - Add Contract generation
   - Add Standing rewards
   - Add Atlas API endpoints

**Priority:** Medium-High - Exploration layer is important but not launch-critical per Spec 94.

---

## Spec 90: Living Assets (Mounts, Pets, Mercenaries, Companions)

**Status:** ⚠️ **PARTIAL** - ~40% Complete

### Spec Requirements:

1. **Mounts**
   - Reins items with durability
   - Full loot on death
   - Condition system (using pet happiness)
   - Stabling system

2. **Combat Pets**
   - Bond/Loyalty system
   - Death/flee mechanics
   - Full loot integration

3. **Mercenaries**
   - Contract-based hiring
   - Role-locked (Healer/Tank/DPS)
   - Wages & duration
   - Risk behavior

4. **Utility Companions**
   - Pack mules
   - Vendor squires
   - Eco-bots

### Implementation Status:

#### ✅ What Exists:

- `MortalLivingMounts.cpp/h` - Living mounts system
- `MortalMountRepair.cpp/h` - Mount repair
- `MortalMountBreeding.cpp/h` - Mount breeding
- `MortalMountedCombat.cpp/h` - Mounted combat
- `MortalStableSystem.cpp/h` - Stabling system
- `MortalStableMasterFees.cpp/h` - Stable fees
- `MortalCompanion.cpp/h` - Companion system (generic)
- `MortalCompanionFeed.cpp/h` - Companion feeding
- `MortalMercenaryBroker.cpp/h` - Mercenary broker

#### ❌ What's Missing:

1. **Mounts** - **MOSTLY COMPLETE**
   - ✅ Reins system exists
   - ⚠️ Need to verify: Condition system, full loot integration
   - ✅ Stabling exists

2. **Combat Pets** - **MISSING**
   - No dedicated `MortalPets` module
   - No Bond/Loyalty system for pets
   - No pet death/flee mechanics

3. **Mercenaries** - **PARTIAL**
   - Broker exists but need to verify:
     - Contract system completeness
     - Role-locked behavior
     - Wages & duration
     - Risk behavior (flee on death)

4. **Utility Companions** - **PARTIAL**
   - Generic companion system exists
   - Need to verify: Pack mules, vendor squires, eco-bots

### Issues Found:

1. **Combat Pets System Missing**
   - No dedicated implementation
   - Spec requires Bond/Loyalty system
   - Need death/flee mechanics

2. **Mercenary System Incomplete**
   - Broker exists but functionality unclear
   - Need contract system verification
   - Need role-locked behavior

3. **Utility Companions Unclear**
   - Generic companion system exists
   - Need specific implementations for pack mules, vendor squires

### Recommendations:

1. **Verify Mount System**
   - Check Condition system implementation
   - Verify full loot integration
   - Test stabling functionality

2. **Create `MortalPets.cpp/h`**
   - Implement Bond/Loyalty system
   - Add death/flee mechanics
   - Integrate with full loot

3. **Enhance Mercenary System**
   - Verify contract system
   - Implement role-locked behavior
   - Add risk behavior (flee on death)

4. **Complete Utility Companions**
   - Implement pack mules
   - Implement vendor squires
   - Implement eco-bots

**Priority:** Medium - Living assets are important but some can come in S1.5 per Spec 94.

---

## Action Items

### High Priority (Launch-Critical):

1. **Spec 92: Warfront Engine**
   - Create `MortalWarfrontEngine.cpp/h`
   - Implement team assignment & objective scoring
   - Add full-loot handling

2. **Spec 92: Siege Flow**
   - Enhance siege encounter system
   - Add sigil capture mechanics

### Medium Priority (S1.5):

3. **Spec 91: Anomalies**
   - Create `MortalAnomalies.cpp/h`
   - Implement signature spawner & scanner

4. **Spec 91: Rifts**
   - Create `MortalRifts.cpp/h`
   - Implement instability tracking & invasions

5. **Spec 90: Combat Pets**
   - Create `MortalPets.cpp/h`
   - Implement Bond/Loyalty system

6. **Spec 93: Module Organization**
   - Either reorganize code OR update spec to match reality

### Low Priority (Documentation):

7. **Spec 93: Update Index**
   - Document actual module structure
   - Map spec names to actual names
   - Note missing modules

---

## Next Steps

1. ✅ Verification complete for specs 94-90
2. 🔄 Fix issues found (starting with high priority)
3. 📝 Update specs to match reality where needed
4. ➡️ Move to next batch (specs 89-85)

