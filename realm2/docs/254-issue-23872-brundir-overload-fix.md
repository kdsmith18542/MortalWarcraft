# Issue #23872 - Assembly of Iron: Stormcaller Brundir Can Die During Overload Cast

**Date:** 2025-01-23  
**Status:** ✅ Fixed

---

## Issue Description

**Problem:** Stormcaller Brundir can die during the Overload cast when another boss is still alive.

**Expected Behavior:** 
- If Stormcaller Brundir is not the last boss alive, during Overload cast, it cannot be killed and should become stuck at 1hp. Only after finishing Overload can the boss die.
- If Stormcaller Brundir is the last boss alive, it can be killed during the Overload cast.

**Source:** https://github.com/azerothcore/azerothcore-wotlk/issues/23872

---

## Root Cause

The boss script did not have a `DamageTaken` handler to prevent death during Overload cast when other bosses are still alive. The boss could be killed mid-cast, breaking the encounter mechanics.

---

## Fix

**File:** `realm2/azerothcore/src/server/scripts/Northrend/Ulduar/Ulduar/boss_assembly_of_iron.cpp`

**Changes:**
- Added `DamageTaken` function to `boss_stormcaller_brundirAI`
- Check if Brundir is casting Overload
- Check if this is the last boss alive using `IsEncounterComplete()`
- If casting Overload and not the last boss, prevent death by setting health to 1 instead of 0

**Code:**
```cpp
// Fix for issue #23872: Prevent death during Overload cast if not the last boss alive
void DamageTaken(Unit* /*attacker*/, uint32& damage, DamageEffectType /*damageType*/, SpellSchoolMask /*schoolMask*/) override
{
    // Check if Brundir is casting Overload
    if (me->HasUnitState(UNIT_STATE_CASTING))
    {
        if (Spell const* currentSpell = me->GetCurrentSpell(CURRENT_GENERIC_SPELL))
        {
            if (currentSpell->GetSpellInfo()->Id == SPELL_OVERLOAD)
            {
                // Check if this is the last boss alive
                bool isLastBossAlive = IsEncounterComplete(pInstance, me);
                
                // If not the last boss alive, prevent death during Overload cast
                if (!isLastBossAlive)
                {
                    if (me->GetHealth() <= damage)
                    {
                        // Set health to 1 instead of dying
                        damage = me->GetHealth() - 1;
                    }
                }
            }
        }
    }
}
```

---

## Testing

**Test Steps:**
1. Start Assembly of Iron encounter
2. Wait for Stormcaller Brundir to cast Overload
3. Deal lethal damage to Brundir while other bosses are still alive
4. Verify Brundir's health is set to 1 and he doesn't die
5. Wait for Overload to finish
6. Deal lethal damage again - Brundir should die normally
7. Test with Brundir as the last boss alive - he should be able to die during Overload

**Expected Results:**
- Brundir cannot die during Overload cast if other bosses are alive (health stuck at 1)
- Brundir can die during Overload cast if he's the last boss alive
- Normal death behavior after Overload finishes

---

## Related Files

- `realm2/azerothcore/src/server/scripts/Northrend/Ulduar/Ulduar/boss_assembly_of_iron.cpp` - `boss_stormcaller_brundirAI::DamageTaken()`
- `realm2/azerothcore/src/server/scripts/Northrend/Ulduar/Ulduar/boss_assembly_of_iron.cpp` - `IsEncounterComplete()` helper function

---

## Notes

- The fix uses `IsEncounterComplete()` which returns `true` when all three bosses are dead
- If `IsEncounterComplete()` returns `false`, it means other bosses are still alive
- The damage is reduced to leave 1 HP instead of killing the boss
- This matches retail behavior where Brundir becomes invulnerable during Overload (unless last boss)

---

**Last Updated:** 2025-01-23

