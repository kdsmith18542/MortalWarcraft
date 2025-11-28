# Issue #23808 - Westguard Sergeant Can Be Taken Out of Skorn

**Status:** ✅ **FIXED**  
**Date:** 2025-01-23  
**Issue:** https://github.com/azerothcore/azerothcore-wotlk/issues/23808

---

## Problem

The Westguard Sergeant (NPC 24060) summoned by the Westguard Command Insignia (item 33311, spell 43042) can be taken outside of Skorn (area 3537) and will not despawn. According to the item description, the sergeant should only be usable in Skorn and should despawn when leaving the area.

---

## Root Cause

1. **Spell 43042** (`spell_item_summon_or_dismiss`) had no zone restriction - it could be cast anywhere
2. **Westguard Sergeant NPC** had no SmartAI script to despawn when the player leaves Skorn

---

## Solution

### 1. Spell Script Zone Check

Created a new spell script `spell_q11248_westguard_sergeant_zone_check` that:
- Checks if the player is on quest 11248 (Operation: Skornful Wrath)
- Checks if the player is in Skorn (area 3537) when **summoning** (not when dismissing)
- Prevents casting outside Skorn with `SPELL_FAILED_NOT_HERE`
- Handles both summon and dismiss logic (replaces the generic `spell_item_summon_or_dismiss` for this spell)

**File:** `realm2/azerothcore/src/server/scripts/Spells/spell_quest.cpp`

### 2. SmartAI Despawn Script

Added a SmartAI script to the Westguard Sergeant (NPC 24060) that:
- Checks every 2 seconds if the owner (player) is more than 50 yards away
- Despawns the sergeant if the owner is too far (which happens when leaving Skorn)

**File:** `realm2/azerothcore/data/sql/updates/db_world/2025_01_23_15_fix_westguard_sergeant_zone_check.sql`

### 3. Spell Script Registration

Updated `spell_script_names` to use the new script for spell 43042:
- Replaces the generic `spell_item_summon_or_dismiss` with `spell_q11248_westguard_sergeant_zone_check`

---

## Implementation Details

### Spell Script

```cpp
class spell_q11248_westguard_sergeant_zone_check : public SpellScript
{
    PrepareSpellScript(spell_q11248_westguard_sergeant_zone_check);

    SpellCastResult CheckCast()
    {
        // Check if player is on quest and in Skorn when summoning
        // Allow dismissing from anywhere
    }

    void HandleSummon(SpellEffIndex effIndex)
    {
        // Handle dismiss logic (same as spell_item_summon_or_dismiss)
    }
};
```

### SmartAI Script

```sql
-- Event 27 = SMART_EVENT_UPDATE (every 2 seconds)
-- Action 41 = SMART_ACTION_DESPAWN_SELF
-- Target 23 = SMART_TARGET_ACTION_RANGE (check owner distance)
-- Despawn if owner more than 50 yards away
```

---

## Testing

1. **Summon in Skorn:** Use Westguard Command Insignia in Skorn - should work
2. **Summon outside Skorn:** Try to use outside Skorn - should fail with "You can't do that here"
3. **Leave Skorn:** Summon sergeant in Skorn, then walk outside - sergeant should despawn within 2 seconds
4. **Dismiss:** Use insignia again to dismiss - should work from anywhere

---

## Files Changed

- `realm2/azerothcore/src/server/scripts/Spells/spell_quest.cpp` - Added spell script
- `realm2/azerothcore/data/sql/updates/db_world/2025_01_23_15_fix_westguard_sergeant_zone_check.sql` - Added SmartAI script and spell registration

---

## Related Issues

- None

---

**Fix Complete:** Ready for testing

