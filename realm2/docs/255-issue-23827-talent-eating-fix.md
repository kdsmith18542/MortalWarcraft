# Issue #23827 - Talent Point While Eating Cancels Animation

**Date:** 2025-01-23  
**Status:** ✅ Fixed

---

## Issue Description

**Problem:** Putting a talent point while eating/drinking cancels the eating animation, making the player lose the food benefit.

**Expected Behavior:** Learning a talent should not cancel the eating/drinking animation.

**Source:** https://github.com/azerothcore/azerothcore-wotlk/issues/23827

---

## Root Cause

When learning a talent, passive spells are cast via `CastSpell()`. In `Spell::prepare()`, if the caster is sitting (eating) and the spell doesn't have `SPELL_ATTR0_ALLOW_WHILE_SITTING`, the stand state is set to standing, which cancels the eating animation.

---

## Fix

**File:** `realm2/azerothcore/src/server/game/Entities/Player/Player.cpp`

**Changes:**
- Modified `_addTalentAurasAndSpells()` to preserve eating/drinking state
- Store current stand state before casting passive spell
- Restore sit state after casting if player was eating/drinking

**Code:**
```cpp
void Player::_addTalentAurasAndSpells(uint32 spellId)
{
    // ... existing code ...
    else if (spellInfo->IsPassive() || (spellInfo->HasAttribute(SPELL_ATTR0_DO_NOT_DISPLAY) && spellInfo->Stances))
    {
        if (IsNeedCastPassiveSpellAtLearn(spellInfo))
        {
            // Fix for issue #23827: Preserve eating/drinking state when learning talents
            // Store current stand state before casting passive spell
            uint8 oldStandState = getStandState();
            bool wasSitting = IsSitState();
            
            CastSpell(this, spellId, true);
            
            // Restore sit state if player was eating/drinking
            if (wasSitting && oldStandState != UNIT_STAND_STATE_STAND)
            {
                SetStandState(oldStandState);
            }
        }
    }
}
```

---

## Testing

**Test Steps:**
1. Get a character with at least 2 talent points available
2. Use food item (e.g., `.additem 4536` for Red Apple)
3. Start eating
4. Open talent panel
5. Place a talent point while eating
6. Verify eating animation continues and food benefit is not lost

**Expected Results:**
- Eating animation continues after placing talent point
- Food benefit is not lost
- Player remains in sit state

---

## Related Files

- `realm2/azerothcore/src/server/game/Entities/Player/Player.cpp` - `_addTalentAurasAndSpells()` function
- `realm2/azerothcore/src/server/game/Spells/Spell.cpp` - `Spell::prepare()` function (line 3599-3602)

---

## Notes

- The fix preserves the stand state for passive talent spells only
- Active spells will still cancel eating (as intended)
- This matches retail behavior where talent points don't interrupt eating

---

**Last Updated:** 2025-01-23

