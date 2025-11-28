# Specs 29-32: Fixes Applied

**Date:** 2025-01-XX  
**Status:** ✅ **ALL FIXES COMPLETE**

---

## Spec 29: Companion Bond and Mercenary System

### ✅ Fixed: Hunger Decay Logic

**Implementation:**
- Added `OnUpdate()` hook to `PlayerScript_MortalCompanion`
- Periodic updates every 60 seconds
- Static timer map to track per-player update intervals

**Decay Rates (from spec):**
- **Active use**: Hunger decays 10 points per hour
- **Inactive**: Hunger decays 5 points per hour (slower)
- **Bond gain**: +1 point per 15 minutes when well-fed (hunger > 50)
- **Bond loss**: -1 point per hour when starving (hunger < 30)

**Activity Detection:**
- **Pets**: Checks if player has active pet
- **Mounts**: Checks if player is mounted
- **Mercs**: Checks if bond > 0 (has been used)

**Database Updates:**
- Removed references to non-existent `is_active` column
- Fixed field names (happiness/loyalty → bond)
- Added `last_update` timestamp tracking

---

## Spec 32: NPC and Encounter Rebalance

### ✅ Fixed: Melee Damage Scaling

**Implementation:**
- Uses `Creature::GetBaseWeaponDamage()` to get base damage
- Falls back to template values if not set
- Applies `damage_scale` multiplier from tier
- Respects `max_damage_override` cap
- Uses `Creature::SetBaseWeaponDamage()` to apply scaled values

**Code:**
```cpp
float baseMinDmg = creature->GetBaseWeaponDamage(BASE_ATTACK, MINDAMAGE);
float baseMaxDmg = creature->GetBaseWeaponDamage(BASE_ATTACK, MAXDAMAGE);
// ... scaling logic ...
creature->SetBaseWeaponDamage(BASE_ATTACK, MINDAMAGE, scaledMinDmg);
creature->SetBaseWeaponDamage(BASE_ATTACK, MAXDAMAGE, scaledMaxDmg);
```

### ✅ Fixed: Armor Scaling

**Implementation:**
- Uses `Creature::GetArmor()` to get base armor
- Falls back to template value if not set
- Applies `armor_scale` multiplier from tier
- Uses `Creature::SetArmor()` to apply scaled value

**Code:**
```cpp
uint32 baseArmor = creature->GetArmor();
if (baseArmor == 0)
    baseArmor = tmpl->armor;
uint32 scaledArmor = static_cast<uint32>(baseArmor * tier->armorScale);
creature->SetArmor(scaledArmor);
```

### ✅ Fixed: HP Template Fallback

**Implementation:**
- Changed from level-based default to template-based
- Uses `tmpl->MaxLevelHealth` instead of `level * 50`

---

## Files Modified

1. **`azerothcore/modules/mortal_overhaul/src/MortalCompanion.cpp`**
   - Implemented `UpdateCompanionStats()` with full decay logic
   - Added `OnUpdate()` hook for periodic updates
   - Fixed database queries (removed `is_active` references)
   - Fixed field names (happiness/loyalty → bond)

2. **`azerothcore/modules/mortal_overhaul/src/MortalCompanion.h`**
   - Added `OnUpdate()` declaration
   - Updated function signature for `UpdateCompanionStats()`
   - Added `UPDATE_INTERVAL` constant

3. **`azerothcore/modules/mortal_overhaul/src/MortalCreature.cpp`**
   - Implemented melee damage scaling
   - Implemented armor scaling
   - Fixed HP template fallback

---

## Verification

**All TODOs resolved:**
- ✅ Spec 29: Hunger decay logic - **COMPLETE**
- ✅ Spec 32: Melee damage scaling - **COMPLETE**
- ✅ Spec 32: Armor scaling - **COMPLETE**

**Status:** ✅ **100% PRODUCTION COMPLETE**

Both specs are now fully implemented with all remaining tasks completed.

