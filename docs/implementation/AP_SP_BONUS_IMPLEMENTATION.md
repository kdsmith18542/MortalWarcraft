# AP/SP Bonus Implementation
## WeaponSkillBonus and MagicSkillBonus Integration

**Date:** 2025-01-XX  
**Status:** ✅ AP Bonus Complete, ⚠️ SP Bonus Needs Hook

---

## Implementation Summary

### ✅ Completed: WeaponSkillBonus for Attack Power

**Files Modified:**
- `src/MortalDamage.h` - Added function declarations
- `src/MortalCombat.cpp` - Implemented bonus calculation functions
- `src/ScriptMgr.cpp` - Added PlayerScript hook to integrate into AP calculation

**Implementation Details:**

1. **Function: `GetWeaponSkillBonus(Player* player, Item* weapon)`**
   - Calculates WeaponSkillBonus from weapon mastery skill
   - Formula: `WeaponSkillBonus = WeaponMasterySkill / 5.0`
   - Returns 0.2 AP per skill point

2. **Function: `GetWeaponSkillBonusForAP(Player* player, bool ranged)`**
   - Gets WeaponSkillBonus for equipped weapon (melee or ranged)
   - Automatically selects appropriate weapon slot

3. **PlayerScript Hook: `OnPlayerAfterUpdateAttackPowerAndDamage`**
   - Intercepts AP calculation after base AP is computed
   - Adds WeaponSkillBonus to `attPowerMod` (flat AP modifier)
   - Applies to both melee and ranged AP

**Formula Applied:**
```
AP_melee = (2.0 * STR) + (0.5 * AGI) + WeaponSkillBonus
AP_ranged = (2.0 * AGI) + (0.5 * STR) + WeaponSkillBonus
WeaponSkillBonus = WeaponMasterySkill / 5.0
```

**Example:**
- Player with 100 Swords skill
- WeaponSkillBonus = 100 / 5.0 = 20 AP
- This is equivalent to 10 Strength (since 1 STR = 2.0 AP)

---

### ⚠️ Pending: MagicSkillBonus for Spell Power

**Status:** Function implemented, but needs hook into spell power calculation

**Function Implemented:**
- `GetMagicSkillBonus(Player* player)` - Calculates from highest magic school skill
- Formula: `MagicSkillBonus = MagicMasterySkill / 5.0`
- Uses highest skill from: Fire Lore, Frost Lore, Arcane Lore, Ether Lore, Shadow Lore, Nature Lore

**Challenge:**
- AzerothCore doesn't have a direct hook for `UpdateSpellDamageAndHealingBonus()`
- Spell Power is calculated per spell school, not as a single value
- Need to either:
  1. Patch `UpdateSpellDamageAndHealingBonus()` directly (requires core modification)
  2. Add hook to AzerothCore (requires core modification)
  3. Modify spell power in `OnPlayerUpdate` (less ideal but works)

**Recommended Approach:**
- Add a hook to AzerothCore's `UpdateSpellDamageAndHealingBonus()` function
- Or modify spell power calculation in `OnPlayerUpdate` hook
- Apply MagicSkillBonus to all spell schools

**Formula to Apply:**
```
SP = (2.0 * INT) + (0.5 * SPI) + MagicSkillBonus
MagicSkillBonus = MagicMasterySkill / 5.0
```

---

## Testing Checklist

- [ ] Verify WeaponSkillBonus is added to melee AP
- [ ] Verify WeaponSkillBonus is added to ranged AP
- [ ] Test with different weapon types (swords, axes, bows, etc.)
- [ ] Test with different skill levels (0, 50, 100, 200, 300)
- [ ] Verify bonus scales correctly (0.2 AP per skill point)
- [ ] Test MagicSkillBonus once hook is implemented
- [ ] Verify bonuses don't apply in PvP contexts (if needed)

---

## Magic School Skill IDs

Current implementation uses these skill IDs (can be extended):
- 2000: Fire Lore
- 2001: Frost Lore
- 2002: Arcane Lore
- 2003: Ether Lore
- 2004: Shadow Lore
- 2005: Nature Lore

**Note:** These IDs need to match the skill IDs defined in the Mortal skill system.

---

## Next Steps

1. ✅ AP Bonus - **COMPLETE**
2. ⚠️ SP Bonus - Implement hook for spell power calculation
3. ⚠️ Verify skill IDs match Mortal skill system
4. ⚠️ Add realm check (only apply to Realm 1 / Mortal players)
5. ⚠️ Testing and validation

---

## Files Modified

- `src/MortalDamage.h` - Added function declarations
- `src/MortalCombat.cpp` - Implemented bonus calculation functions
- `src/ScriptMgr.cpp` - Added PlayerScript hook for AP bonus

---

**Last Updated:** 2025-01-XX

