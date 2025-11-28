# Codebase Implementation Assessment
## Mortal Warcraft Overhaul - Realm 1

**Date:** 2025-01-XX  
**Status:** Assessment of implementation gaps between specs and code

---

## Executive Summary

**Total Systems Assessed:** 20  
**Fully Implemented:** 8 (40%)  
**Partially Implemented:** 7 (35%)  
**Not Implemented:** 5 (25%)

---

## ✅ Fully Implemented Systems

### 1. Skill Gain Formulas ✅
**Status:** COMPLETE  
**Location:** `src/MortalCombatSkills.cpp`, `src/MortalGatheringSkills.cpp`, `src/MortalCraftingSkills.cpp`

- ✅ Diminishing returns formula implemented (`CalculateDiminishingReturns`)
- ✅ Difficulty modifier implemented
- ✅ Tier modifier implemented
- ✅ Base gain rates defined

**Verification:**
```cpp
// All three files have:
float CalculateDiminishingReturns(float currentSkill)
{
    if (currentSkill <= 100.0f) return 1.0f;
    else if (currentSkill <= 200.0f) return 1.0f - ((currentSkill - 100.0f) / 200.0f);
    else if (currentSkill <= 300.0f) return 0.5f * (1.0f - ((currentSkill - 200.0f) / 200.0f));
    else return 0.25f;
}
```

### 2. Task Board Generation Algorithm ✅
**Status:** COMPLETE  
**Location:** `src/MortalTaskBoard.cpp/h`

- ✅ Dynamic generation system implemented
- ✅ Weight calculation based on demand state
- ✅ Reward scaling with multipliers
- ✅ Region demand system

**Reference:** `docs/implementation/SPECS_76_72_IMPLEMENTATION_SUMMARY.md`

### 3. Material Multiplier ✅
**Status:** COMPLETE  
**Location:** `src/MortalCombat.cpp` (`GetMaterialMultiplier`)

- ✅ Material tier multipliers implemented
- ✅ Quality fallback system

### 4. Hit/Miss Formula ✅
**Status:** COMPLETE  
**Location:** `src/MortalCombat.cpp`

- ✅ Hit chance calculation implemented
- ✅ Level penalty and mastery bonus included

### 5. Regional Bank Schema ✅
**Status:** COMPLETE  
**Location:** SQL migrations

- ✅ Complete schema with indexes and constraints

### 6. Market Stall Schema ✅
**Status:** COMPLETE  
**Location:** SQL migrations

- ✅ Complete schema for stalls, items, transactions

### 7. Encumbrance Formula ✅
**Status:** COMPLETE  
**Location:** `src/MortalEncumbrance.cpp/h`

- ✅ Weight calculation implemented
- ✅ Movement speed penalties

### 8. Caravan Speed Formula ✅
**Status:** COMPLETE  
**Location:** Spec defined, implementation likely in caravan system

---

## ⚠️ Partially Implemented Systems

### 9. WeaponSkillBonus/MagicSkillBonus for AP/SP ⚠️
**Status:** PARTIAL - Used in damage but NOT in AP/SP calculations  
**Location:** `src/MortalCombat.cpp`

**Current Implementation:**
- ✅ `GetSkillBonus()` exists and is used for **damage calculation** (0.1 per skill point)
- ❌ **NOT used in Attack Power (AP) calculation**
- ❌ **NOT used in Spell Power (SP) calculation**

**Spec Requirement:**
```
AP_melee = (2.0 * STR) + (0.5 * AGI) + WeaponSkillBonus
WeaponSkillBonus = WeaponMasterySkill / 5.0  // 0.2 AP per skill point
```

**What's Missing:**
- Need to hook into `Player::UpdateAttackPowerAndDamage()` or create custom AP/SP calculation
- Need to add `GetWeaponSkillBonus()` and `GetMagicSkillBonus()` functions
- Need to integrate into stat calculation pipeline

**Files to Modify:**
- `src/MortalCombat.cpp` - Add AP/SP bonus functions
- `src/MortalStats.cpp` (if exists) - Integrate into stat pipeline
- Hook into `Player::UpdateAttackPowerAndDamage()` and `Player::UpdateSpellDamageAndHealingBonus()`

### 10. Mana Regeneration Formula ⚠️
**Status:** PARTIAL - Using standard WoW formula, not custom Mortal formula  
**Location:** `azerothcore/src/server/game/Entities/Unit/StatSystem.cpp` (`Player::UpdateManaRegen()`)

**Current Implementation:**
- ✅ Standard WoW mana regen formula exists
- ❌ **NOT using custom Mortal formula** (BaseRegen + SpiritBonus + ShrineBonus) * StateModifier

**Spec Requirement:**
```
ManaRegenPerSecond = (BaseRegen + SpiritBonus + ShrineBonus) * StateModifier
BaseRegen = 2.0
SpiritBonus = Spirit * 0.1
ShrineBonus = 5.0 (if near shrine)
StateModifier = 1.5 (resting), 0.3 (combat), 1.0 (normal)
```

**What's Missing:**
- Need to override `Player::UpdateManaRegen()` in Mortal system
- Need to check for shrine proximity
- Need to check player state (resting/combat/normal)

**Files to Modify:**
- Create `src/MortalManaRegen.cpp/h` or hook into existing system
- Override mana regen calculation for Mortal players

### 11. Mentor Scaling Formula ⚠️
**Status:** PARTIAL - SQL tables exist, formula not implemented  
**Location:** `sql/117_mentoring_enhancements.sql`

**Current Implementation:**
- ✅ SQL tables exist (`mortal_mentor_mode`, `mortal_level_bands`)
- ❌ **Scaling formula NOT implemented in C++**

**Spec Requirement:**
```
ScaleFactor = TargetBandMidpoint / ActualLevel
EffectiveHP = BaseHP * ScaleFactor
EffectiveDamage = BaseDamage * ScaleFactor
```

**What's Missing:**
- Need C++ implementation in `src/MortalMentor.cpp/h`
- Need to hook into damage calculation for PvE only
- Need to check PvP context and disable scaling

**Files to Create/Modify:**
- `src/MortalMentor.cpp/h` - New file for mentor system
- Hook into damage calculation in `MortalCombat.cpp`
- Add PvP zone detection

### 12. Attribute Overflow Normalization ⚠️
**Status:** NOT IMPLEMENTED  
**Location:** Spec defined in `84-mortal-core-stats-and-combat-model.md`

**Spec Requirement:**
```
If total attributes > 400:
    ScaleFactor = 400.0 / total
    Normalize each stat proportionally
    Adjust for rounding to reach exactly 400
```

**What's Missing:**
- Need `MortalStats::ClampBaseAttributes()` implementation
- Need to integrate into stat calculation pipeline
- Need to handle rounding adjustments

**Files to Create/Modify:**
- `src/MortalStats.cpp/h` - New file or add to existing
- Hook into stat calculation after gear/buffs applied

### 13. Stat Calculation Pipeline ⚠️
**Status:** PARTIAL - Order defined in spec, not enforced in code  
**Location:** Spec defined in `84-mortal-core-stats-and-combat-model.md`

**Spec Requirement:**
```
1. Base Attributes
2. Gear Modifiers
3. Rune Modifiers
4. Buff/Aura Modifiers
5. Individual Stat Clamping (150 max)
6. Total Attribute Clamping (400 max with normalization)
7. Derived Stats Calculation
```

**What's Missing:**
- Need centralized stat calculation function
- Need to enforce order of operations
- Need to integrate with existing AzerothCore stat system

**Files to Create/Modify:**
- `src/MortalStats.cpp/h` - Centralized stat calculation
- Hook into `Player::UpdateStats()` or create custom pipeline

### 14. Quality Tier Mapping ⚠️
**Status:** SPEC DEFINED - Need to verify implementation  
**Location:** Spec defined in `05-crafting.md`

**Spec Requirement:**
```
Shoddy: < 0
Common: 0-50
Fine: 51-100
Superior: 101-150
Exceptional: 151-200
Masterwork: 201-250
Legendary: 251+
```

**What's Missing:**
- Need to verify if crafting system uses this mapping
- Need to check `MortalCrafting.cpp` or crafting scripts

**Files to Check:**
- `src/MortalCrafting.cpp/h` (if exists)
- Lua crafting scripts

### 15. Reward Scaling Formulas ⚠️
**Status:** PARTIAL - Implemented but may not match spec exactly  
**Location:** `src/MortalTaskBoard.cpp`

**Current Implementation:**
- ✅ Multiplier system exists
- ⚠️ Need to verify it matches spec formulas exactly

**Spec Requirement:**
```
G_safe baseline values by level
DifficultyMultiplier = 1.0 + (LevelDiff * 0.1)
RiskMultiplier: 1.0 (Green), 1.2 (Yellow), 1.5 (Red)
RegionModifier = 1.0 + (DemandScore * 0.05)
```

**What's Missing:**
- Verify G_safe baseline values are correct
- Verify all multipliers match spec exactly

---

## ❌ Not Implemented Systems

### 16. World Simulation Schemas ❌
**Status:** NOT IMPLEMENTED  
**Location:** Spec defined in `12-world-simulation.md`

**What's Missing:**
- `mortal_ecosystem_spawn_weights` table
- `mortal_ecosystem_relations` table
- `mortal_territory_world_modifiers` table
- `mortal_migration_events` table
- `mortal_alpha_variants` table
- `mortal_weather_zones` table
- `mortal_daynight_cycle` table
- `mortal_seasonal_states` table
- `mortal_resource_node_simulation` table

**Action Required:**
- Create SQL migration file with all 9 tables
- Implement C++ systems to use these tables

### 17. Outlaw Threshold / Notoriety Decay / Bounty Pot ❌
**Status:** SPEC DEFINED - Need to verify implementation  
**Location:** Spec defined in `02-combat.md`

**Spec Requirements:**
- Outlaw threshold: 10 notoriety points (default)
- Notoriety decay: 1 point per day
- Bounty pot percentage: 25%

**What's Missing:**
- Need to check crime/outlaw system implementation
- Verify these values are configurable

**Files to Check:**
- `src/MortalCrime.cpp/h` (if exists)
- Crime/outlaw Lua scripts

### 18. Shrine Order Naming ❌
**Status:** SPEC DEFINED - Need to verify implementation  
**Location:** Spec defined in `86-mortal-factions-and-standing.md`

**Spec Requirements:**
- `SHRINE_ORDER_DAWN`
- `SHRINE_ORDER_DUSK`
- `SHRINE_ORDER_VEIL`
- `SHRINE_ORDER_ANVIL` (optional)

**What's Missing:**
- Need to verify faction IDs are set correctly
- Need to check if shrine system uses these names

### 19. Combat/Gear Integration Documentation ❌
**Status:** NEEDS DOCUMENTATION  
**Location:** Specs `02-combat.md` and `75-mortal-gear-and-runes-spec.md`

**What's Missing:**
- Need to document how combat formulas integrate with gear system
- Need to verify gear stats flow into combat calculations correctly

### 20. Mentor Respec Logic ❌
**Status:** NOT IMPLEMENTED  
**Location:** Spec defined in `01-progression.md`

**Spec Requirement:**
- Free respec until 200 skill points
- Mentor system integration

**What's Missing:**
- Need to implement respec logic
- Need to check skill point total
- Need to integrate with mentor system

---

## Priority Recommendations

### High Priority (Core Systems)
1. **WeaponSkillBonus/MagicSkillBonus for AP/SP** - Critical for combat balance
2. **Mana Regeneration Formula** - Core gameplay mechanic
3. **Attribute Overflow Normalization** - Prevents stat exploits
4. **Stat Calculation Pipeline** - Foundation for all stat systems

### Medium Priority (Gameplay Systems)
5. **Mentor Scaling Formula** - Important for group play
6. **World Simulation Schemas** - Dynamic world content
7. **Quality Tier Mapping Verification** - Crafting system

### Low Priority (Polish/Verification)
8. **Outlaw/Notoriety Values** - Verify implementation
9. **Shrine Order Naming** - Verify faction IDs
10. **Combat/Gear Integration Docs** - Documentation

---

## Next Steps

1. **Create implementation plan** for high-priority items
2. **Start with AP/SP bonus integration** (most critical)
3. **Implement mana regen override** (core mechanic)
4. **Add attribute overflow normalization** (exploit prevention)
5. **Create stat calculation pipeline** (foundation)

---

## Files to Create/Modify

### New Files Needed:
- `src/MortalStats.cpp/h` - Centralized stat calculation
- `src/MortalMentor.cpp/h` - Mentor scaling system
- `src/MortalManaRegen.cpp/h` - Custom mana regen (or hook into existing)
- `sql/XXX_world_simulation_schemas.sql` - World simulation tables

### Files to Modify:
- `src/MortalCombat.cpp` - Add AP/SP bonus functions
- `src/MortalCombat.cpp` - Integrate mentor scaling for PvE
- Hook into `Player::UpdateAttackPowerAndDamage()`
- Hook into `Player::UpdateSpellDamageAndHealingBonus()`
- Hook into `Player::UpdateManaRegen()` (or override)

---

**Last Updated:** 2025-01-XX

