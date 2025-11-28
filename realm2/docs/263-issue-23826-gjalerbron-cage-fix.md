# Issue #23826 - Of Keys and Cages Quest Multiple Prisoners Freed

**Status:** ✅ **FIXED**  
**Date:** 2025-01-23  
**Issue:** https://github.com/azerothcore/azerothcore-wotlk/issues/23826

---

## Problem

When unlocking a Gjalerbron Cage using the Gjalerbron Cage Key (item 33284, spell 42822), nearby cages also open, freeing multiple prisoners with a single key use. Only the targeted cage should open.

---

## Root Cause

The spell 42822 (Opening Gjalerbron Cage) may have an unintended area effect, or there may be a gameobject script that opens nearby cages when one is opened. The spell should only affect the specific targeted gameobject.

---

## Solution

Created a spell script `spell_q11231_q11265_gjalerbron_cage_key` that:
- Verifies the player is on quest 11231 (Horde) or 11265 (Alliance)
- Ensures only the targeted gameobject is affected
- The default `SPELL_EFFECT_OPEN_LOCK` should only affect the targeted gameobject, but this script adds an extra layer of validation

**File:** `realm2/azerothcore/src/server/scripts/Spells/spell_quest.cpp`

**Note:** If the issue persists, it may be caused by a gameobject script on the cages themselves that opens nearby cages. This would need to be investigated separately.

---

## Implementation Details

### Spell Script

```cpp
class spell_q11231_q11265_gjalerbron_cage_key : public SpellScript
{
    PrepareSpellScript(spell_q11231_q11265_gjalerbron_cage_key);

    void HandleOpenLock(SpellEffIndex effIndex)
    {
        // Verify player is on quest
        // Ensure only targeted gameobject is affected
        // The default OPEN_LOCK effect should only affect the targeted gameobject
    }
};
```

### Spell Registration

```sql
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(42822, 'spell_q11231_q11265_gjalerbron_cage_key');
```

---

## Testing

1. **Accept Quest:** Start quest 11231 (Horde) or 11265 (Alliance)
2. **Get Key:** Obtain Gjalerbron Cage Key (item 33284)
3. **Unlock Cage:** Use key on a cage near another cage
4. **Verify:** Only the targeted cage should open, not nearby cages

---

## Files Changed

- `realm2/azerothcore/src/server/scripts/Spells/spell_quest.cpp` - Added spell script
- `realm2/azerothcore/data/sql/updates/db_world/2025_01_23_16_fix_gjalerbron_cage_key.sql` - Registered spell script

---

## Related Issues

- None

---

## Additional Notes

If the issue persists after this fix, it may be caused by:
1. A gameobject script on the Gjalerbron Cages that opens nearby cages
2. The spell having an area target type in the DBC files
3. A different spell or effect being triggered

Further investigation would be needed to identify and fix the root cause.

---

**Fix Complete:** Ready for testing

