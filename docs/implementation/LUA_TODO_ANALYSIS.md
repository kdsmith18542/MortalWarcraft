# Lua Scripts - TODO/FIXME Analysis

**Date:** 2025-01-XX  
**Total TODOs Found:** 11 (across 19 files)  
**Status:** 📋 **DOCUMENTED**

---

## 📋 TODO Categories

### 1. C++ Hook Requirements (8 TODOs)

These TODOs indicate features that require C++ implementation or hooks:

#### `world_bosses.lua`
- **Line 40:** `-- TODO: Actual creature spawning would happen here via C++`
- **Status:** Expected - Requires C++ creature spawning system

#### `zone_pvp_system.lua`
- **Line 160:** `-- TODO: Apply visual effect (red nameplate, skull icon)`
- **Status:** Expected - Requires C++ visual effect system

#### `delve_instances.lua`
- **Line 82:** `-- TODO: Implement actual mob scaling via C++ hook or creature stat modification`
- **Status:** Expected - Requires C++ creature stat modification

#### `outlaw_state.lua`
- **Line 107:** `-- TODO: Implement teleport back or guard attack`
- **Status:** Expected - Requires C++ teleport/guard AI system

#### `public_dungeon_spawns.lua`
- **Line 59:** `-- TODO: Apply drop rate multiplier to loot table`
- **Line 76:** `-- TODO: Trigger faster respawns via C++ hook or spawn system`
- **Status:** Expected - Requires C++ loot/spawn system modifications

#### `public_dungeon_ai.lua`
- **Line 39:** `-- TODO: Set aggro range via C++ hook or creature AI modification`
- **Line 61:** `-- TODO: Call for help via C++ hook or creature AI`
- **Status:** Expected - Requires C++ creature AI modifications

#### `sky_predator_ai.lua`
- **Line 112:** `-- TODO: Expand to check all nearby players when GetPlayersInRange is available`
- **Status:** Expected - Requires Eluna API expansion or C++ hook

#### `survival_mechanics.lua`
- **Line 92:** `-- TODO: Apply stamina reduction aura (Spell ID to be created)`
- **Status:** Expected - Requires custom spell creation

---

### 2. System Integration (2 TODOs)

These TODOs indicate features that need integration with other systems:

#### `material_lore_system.lua`
- **Line 162:** `-- TODO: Integrate with skill advancement system to actually award XP`
- **Status:** Moderate Priority - Needs skill system integration
- **Action:** Should integrate with `combat_skills.lua` or `gathering_skills.lua`

#### `altar_rotation.lua`
- **Line 1:** `-- TODO: Implement weekly rotation of Purification Altar locations`
- **Status:** Moderate Priority - Feature implementation needed
- **Action:** Should implement rotation logic

---

### 3. Feature Implementation (1 TODO)

#### `seasonal_pve_events.lua`
- **Line 1:** `-- TODO: Implement seasonal PvE event controller`
- **Status:** Moderate Priority - Core feature implementation
- **Action:** Should implement event management logic

---

## 📊 TODO Breakdown

| Category | Count | Priority | Status |
|----------|-------|----------|--------|
| **C++ Hooks Required** | 8 | Low | Expected |
| **System Integration** | 2 | Moderate | Needs Work |
| **Feature Implementation** | 1 | Moderate | Needs Work |
| **Total** | **11** | - | - |

---

## 🎯 Recommendations

### Immediate Actions (Moderate Priority)
1. **Material Lore XP Integration**
   - Integrate `material_lore_system.lua` with skill advancement system
   - Connect to `combat_skills.lua` or create skill XP award function

2. **Altar Rotation Implementation**
   - Implement weekly rotation logic in `altar_rotation.lua`
   - Add database persistence for current altar location

3. **Seasonal PvE Events**
   - Complete implementation of `seasonal_pve_events.lua`
   - Add event management, spawning, and reward logic

### Long-term Actions (Low Priority - C++ Dependent)
4. **C++ Hook Development**
   - Prioritize based on feature importance
   - Most critical: Creature spawning, stat modification, AI modifications
   - Less critical: Visual effects, teleport systems

---

## 📝 Notes

- **Most TODOs are Expected:** 8 out of 11 TODOs are for C++ hooks, which is normal for Lua scripting in game servers
- **No Blocking Issues:** All TODOs are for enhancements, not critical bugs
- **Gradual Implementation:** C++ hooks can be implemented as features are prioritized
- **Lua Workarounds:** Some features may have Lua workarounds, but C++ hooks provide better performance

---

## ✅ Status Summary

**Total TODOs:** 11  
**C++ Dependent:** 8 (73%)  
**Lua Implementation:** 3 (27%)  
**Blocking Issues:** 0  
**Critical:** 0  

**Overall Assessment:** ✅ **Healthy** - Most TODOs are expected C++ requirements, not blocking issues.

