# Fix for #23807 - Seething Revenant No Loot

**Issue:** [#23807](https://github.com/azerothcore/azerothcore-wotlk/issues/23807)  
**Status:** ✅ Fixed  
**Date:** 2025-01-23

## Problem

The Seething Revenant (NPC 30387) in Storm Peaks has no loot assigned, despite being a level 80 elite elemental that should drop vendor trash and crafting materials (Crystallized Fire, Relic of Ulduar).

## Root Cause

The `creature_loot_template` table had no entries for NPC 30387, meaning the creature would not drop any items when killed.

## Solution

Added loot entries to `creature_loot_template` for Seething Revenant based on Wowhead data and similar Storm Peaks elementals:
- Crystallized Fire (item 37701) - 10% chance
- Relic of Ulduar (item 45087) - 5% chance
- Other crystallized elements (Air, Earth, Water, Life, Shadow) - 8% chance each

## Implementation

**File:** `realm2/azerothcore/data/sql/updates/db_world/2025_01_23_18_fix_seething_revenant_loot.sql`

- Deleted any existing loot entries for NPC 30387
- Added loot entries for:
  - Crystallized Fire (37701) - 10%
  - Relic of Ulduar (45087) - 5%
  - Crystallized Air (37700) - 8%
  - Crystallized Earth (37702) - 8%
  - Crystallized Water (37705) - 8%
  - Crystallized Life (37704) - 8%
  - Crystallized Shadow (37703) - 8%

Note: Gold is automatically handled by the core based on `creature_template.goldMin` and `creature_template.goldMax`.

## Testing

1. Kill a Seething Revenant (NPC 30387) in Storm Peaks
2. Verify it drops loot (crystallized elements and/or Relic of Ulduar)
3. Verify gold is awarded

## Related Files

- `realm2/azerothcore/data/sql/updates/db_world/2025_01_23_18_fix_seething_revenant_loot.sql`

