# Issue #16905 Investigation: Druid Berserk Energy Bug

**Date:** 2025-01-23  
**Status:** Needs Issue Description

---

## Issue Summary

**Title:** [Druid] Spell Berserk: energy consumption in feral form  
**Link:** https://github.com/azerothcore/azerothcore-wotlk/issues/16905  
**Priority:** Low  
**Type:** Core Fix (Spell Script)  
**Labels:** Players-feedback, Confirmed (12 comments)

---

## Current Implementation

Berserk spell (50334) is implemented in:
- `src/server/scripts/Spells/spell_druid.cpp` (lines 1161-1190)

### Current Script Behavior

The `spell_dru_berserk` script currently:
1. **Removes Tiger's Fury auras** (spells 5217, 6793, 9845, 9846, 50212, 50213)
2. **Resets Dire Bear Maul cooldown** (spells 33878, 33986, 33987, 48563, 48564)

### Spell Linking

From `spell_linked_spell.sql`:
- Spell 50334 (Berserk) is linked to spell 58923 (modify target number aura)

---

## Problem

The issue title says "energy consumption in feral form" which suggests:
- Berserk should **consume energy** when cast in **cat form** (feral form)
- Currently, it does **not consume energy**

However, without the actual issue description, we cannot determine:
1. How much energy should be consumed?
2. Should it consume all energy or a fixed amount?
3. Is this only for cat form or also for bear form?
4. What is the exact bug behavior?

---

## What We Need

1. **Issue Description:**
   - What is the expected behavior?
   - What is the current (buggy) behavior?
   - How much energy should be consumed?

2. **Retail Verification:**
   - Wowhead comments or videos showing retail behavior
   - Spell tooltip or DBC data showing energy cost

3. **Testing:**
   - Test in-game to reproduce the bug
   - Verify expected vs actual behavior

---

## Potential Fix

If Berserk should consume all energy in cat form (similar to how other abilities work), the fix might be:

```cpp
void HandleAfterCast()
{
    Unit* caster = GetCaster();
    
    if (caster->IsPlayer())
    {
        Player* player = caster->ToPlayer();
        
        // If in cat form, consume all energy
        if (player->GetShapeshiftForm() == FORM_CAT)
        {
            player->SetPower(POWER_ENERGY, 0);
        }
        
        // Remove tiger fury / mangle(bear)
        // ... existing code ...
    }
}
```

**BUT:** This is speculation without issue details. We need confirmation.

---

## Current Status

**Blocked** - Cannot proceed without issue description or retail verification.

**Next Steps:**
1. Read the actual GitHub issue description
2. Check Wowhead for spell 50334 details
3. Test in-game to reproduce the bug
4. Implement fix once behavior is confirmed

---

## Code Location

- **File:** `realm2/azerothcore/src/server/scripts/Spells/spell_druid.cpp`
- **Lines:** 1161-1190
- **Class:** `spell_dru_berserk`
- **Function:** `HandleAfterCast()`

---

## Notes

- This is a class balance issue, not a critical blocker
- Affects Druid feral DPS rotation
- Can be deferred until issue details are available

