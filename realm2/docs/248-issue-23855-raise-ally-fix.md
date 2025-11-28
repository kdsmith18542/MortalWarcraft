# Issue #23855 - Death Knight Raise Ally Fix

**Date:** 2025-01-23  
**Status:** ✅ Fixed

---

## Issue Description

**Problem:** Death Knight spell "Raise Ally" (61999) doesn't work at all. When casting, players receive "invalid target" message even when the target is in party or raid and is dead.

**Expected Behavior:** The spell should resurrect a dead friendly player and allow them to play as a ghoul (vehicle control).

**Source:** https://github.com/azerothcore/azerothcore-wotlk/issues/23855

---

## Root Cause

The `CheckCast()` function in `spell_dk_raise_ally` was not properly validating:
1. Target is a Player (not just a Unit)
2. Target is in party or raid with the caster

The function only checked:
- Target exists
- Target is dead

This caused the spell to fail validation even when the target was valid.

---

## Fix

**File:** `realm2/azerothcore/src/server/scripts/Spells/spell_dk.cpp`

**Changes:**
- Added check to ensure target is a Player
- Added check to ensure caster is a Player
- Added check to ensure target is in party or raid with caster
- Improved error handling

**Code:**
```cpp
SpellCastResult CheckCast()
{
    Unit* unitTarget = GetExplTargetUnit();
    if (!unitTarget)
        return SPELL_FAILED_BAD_TARGETS;

    // Target must be a Player
    Player* targetPlayer = unitTarget->ToPlayer();
    if (!targetPlayer)
        return SPELL_FAILED_BAD_TARGETS;

    // Target must be dead
    if (targetPlayer->IsAlive())
        return SPELL_FAILED_TARGET_NOT_DEAD;

    // Target must be in party or raid with caster
    Player* casterPlayer = GetCaster()->ToPlayer();
    if (!casterPlayer)
        return SPELL_FAILED_BAD_TARGETS;

    if (!casterPlayer->IsInRaidWith(targetPlayer) && !casterPlayer->IsInPartyWith(targetPlayer))
        return SPELL_FAILED_BAD_TARGETS;

    return SPELL_CAST_OK;
}
```

---

## Testing

**Test Steps:**
1. Create two Death Knight characters
2. Invite one to party/raid
3. Have one character die
4. Cast Raise Ally on the dead character
5. Verify the spell works and the dead player is resurrected as a ghoul

**Expected Results:**
- Spell casts successfully
- Dead player is resurrected
- Dead player controls the ghoul as a vehicle
- Ghoul has proper abilities (including self-explosion)

---

## Related Files

- `realm2/azerothcore/src/server/scripts/Spells/spell_dk.cpp` - Main fix
- `realm2/azerothcore/src/server/scripts/Spells/spell_dk.cpp` - `spell_dk_raise_ally_trigger` (46619) - Aura script for ghoul control

---

## Notes

- The spell uses vehicle mechanics to allow the resurrected player to control the ghoul
- Spell 46619 (Raise Ally trigger) handles the vehicle/ghoul control
- The ghoul should have the same abilities as a normal DK pet ghoul

---

**Last Updated:** 2025-01-23

