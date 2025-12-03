# Critical Fixes from AzerothCore Upstream

## Overview

This directory contains SQL patches and workarounds for critical gameplay issues identified in the upstream AzerothCore repository. These fixes address bugs that significantly impact gameplay, server stability, and player experience.

## Issue Selection Criteria

Issues were selected based on:
- **Impact**: Server-breaking, gameplay-critical, or major exploits
- **Player Feedback**: Tagged with "Players-feedback" or "Priority-Critical"
- **Fixability**: Can be addressed via database patches or documented workarounds
- **Relevance**: Applicable to WoW 3.3.5a era progression content

## Included Fixes

### 001 - SAI Event Link Fix (Issue #20927)
**Impact**: Medium - Affects Many NPCs
- **Problem**: SMART_EVENT_LINK (event type 61) doesn't properly execute linked events
- **Solution**: Database workarounds converting linked events to sequential actions
- **Status**: Partial fix (core modification needed for complete solution)
- **Applies to**: Custom SAI scripts, NPC behaviors

### 002 - Surveyor Candress Fix (Issue #20730)
**Impact**: Medium - Low Level Balance
- **Problem**: NPC casts fireball too frequently with excessive damage
- **Solution**: Adjusted cast probability from 100% to 8%, normalized damage
- **Status**: Complete database fix
- **Applies to**: Azuremyst Isle, level 5-6 content

### 003 - Blade of Eternal Darkness Crit (Issue #9400)
**Impact**: Medium - Item Functionality
- **Problem**: Engulfing Shadows proc cannot crit when it should
- **Solution**: Spell attribute correction to allow critical strikes
- **Status**: Partial fix (may require core modification)
- **Applies to**: Level 40-49 caster itemization

### 004 - Profession Learning Bug (Issue #2330)
**Impact**: High - Profession System
- **Problem**: `.learn all recipes` command breaks profession limits
- **Solution**: Database triggers and stored procedures to enforce limits
- **Status**: Preventive measures + cleanup tools
- **Applies to**: All profession-using characters

### 005 - Eye of the Storm Immunity Bug (Issue #21657)
**Impact**: High - Battleground Exploit
- **Problem**: Players with immunity fall through map instead of dying
- **Solution**: Cleanup scripts + recommendations for core fix
- **Status**: Mitigation (core fix needed)
- **Applies to**: Eye of the Storm battleground

## Application Instructions

### Prerequisites

1. **Backup your database** before applying any fixes
2. Ensure you have appropriate MySQL privileges
3. Test in a development environment first

### Applying Fixes

```bash
# Navigate to the SQL directory
cd sql/critical_fixes

# Apply all fixes
for file in *.sql; do
    echo "Applying $file..."
    mysql -u your_user -p your_database < "$file"
done

# Or apply individually
mysql -u your_user -p your_database < 001_sai_event_link_fix.sql
mysql -u your_user -p your_database < 002_surveyor_candress_fix.sql
# ... etc
```

### Selective Application

If you only want specific fixes:

```bash
# Fix only profession issues
mysql -u your_user -p your_database < 004_profession_learning_fix.sql

# Fix only PVP/battleground issues
mysql -u your_user -p your_database < 005_eots_immunity_death_fix.sql
```

## Compatibility Notes

### Mortal Warcraft Custom System

These fixes were created with Mortal Warcraft custom systems in mind:

- **Custom Skills**: May need adjustment if replacing traditional profession system
- **Combat System**: Blade of Eternal Darkness fix should respect custom crit mechanics
- **Crafting Quality**: Profession fixes include notes for procedural crafting integration
- **Faction System**: No conflicts expected

### Era Progression

All fixes are compatible with vanilla/TBC/WotLK era progression:
- No post-3.3.5a content referenced
- Respects classic item/spell values
- Maintains blizzlike behavior where documented

## Testing & Verification

Each fix includes verification steps. Test checklist:

- [ ] Fix 001: Test Bloodfury Warder (Entry 18853) enrage behavior
- [ ] Fix 001: Test Katherine Lee (Entry 28705) waypoint pause
- [ ] Fix 002: Test Surveyor Candress (Entry 16522) spell frequency
- [ ] Fix 003: Test Blade of Eternal Darkness (Item 17780) proc crits
- [ ] Fix 004: Test profession learning limits with `.learn all recipes`
- [ ] Fix 005: Test Eye of the Storm immunity falling behavior

### In-Game Testing Commands

```
-- Fix 001 Testing
.go creature id 18853
.modify hp 30

-- Fix 002 Testing
.go creature id 16522
.levelup -75  -- Be level 5-6 for accurate testing

-- Fix 003 Testing
.additem 17780
.learn 21978
-- Cast shadow spells and watch for procs

-- Fix 004 Testing
.learn all recipes Alchemy
.learn all recipes Blacksmithing
.learn all recipes Engineering  -- Should fail

-- Fix 005 Testing
-- Requires actual Eye of the Storm battleground
.tele EyeOfTheStorm
```

## Known Limitations

### Core Modifications Required

Some issues cannot be fully fixed with SQL alone:

1. **SAI Event Link (001)**: Core still has underlying bug
2. **Blade Crit (003)**: May need spell system core modification
3. **EOTS Bug (005)**: Requires battleground core fix

These fixes provide workarounds and mitigations until upstream core fixes are available.

### Custom Content Impact

If you have custom NPCs or scripts:
- Review SAI scripts for event type 61 usage
- Check custom profession system compatibility
- Verify custom spell proc behaviors

## Rollback Procedures

If a fix causes issues:

```sql
-- Rollback SAI fixes
DELETE FROM smart_scripts WHERE entryorguid IN (18853, 28705);
-- Restore from backup

-- Rollback profession triggers
DROP TRIGGER IF EXISTS prevent_excess_professions;
DROP PROCEDURE IF EXISTS fix_character_professions;

-- Rollback creature stat changes
UPDATE creature_template SET 
    dmg_multiplier = <original_value>,
    mindmg = <original_value>,
    maxdmg = <original_value>
WHERE entry = 16522;

-- Restore from full database backup for complete rollback
```

## Monitoring & Maintenance

### Recommended Monitoring

```sql
-- Check for players with >2 professions
SELECT guid, COUNT(DISTINCT skill) as prof_count
FROM character_skills
WHERE skill IN (164, 165, 171, 182, 186, 197, 202, 333, 393, 755, 773)
GROUP BY guid
HAVING prof_count > 2;

-- Check for stuck EOTS players
SELECT guid, name, position_z 
FROM characters 
WHERE map = 566 AND position_z < 1000;

-- Monitor SAI errors in server log
grep "SmartScript" worldserver.log | grep "ERROR"
```

### Periodic Maintenance

- **Weekly**: Check for profession limit violations
- **Daily**: Monitor battleground stuck players
- **After patches**: Verify fixes still apply correctly

## Contributing

Found an issue with these fixes?
1. Test thoroughly to reproduce
2. Document the problem
3. Create an issue in this repository
4. Reference the original upstream issue number

## Additional Resources

- [AzerothCore Issue Tracker](https://github.com/azerothcore/azerothcore-wotlk/issues)
- [Upstream Sync Guide](../../UPSTREAM_SYNC_GUIDE.md)
- [WoW 3.3.5a Database](https://wowgaming.altervista.org/aowow/)
- [AzerothCore Wiki](https://www.azerothcore.org/wiki/)

## Support Matrix

| Fix | SQL Only | Core Mod | Config | Client |
|-----|----------|----------|--------|--------|
| 001 | ✓        | Recommended | -   | -      |
| 002 | ✓        | -        | -      | -      |
| 003 | Partial  | Required | -      | -      |
| 004 | ✓        | -        | ✓      | -      |
| 005 | Partial  | Required | -      | ✓      |

Legend:
- ✓ = Fully supported with this approach
- Partial = Provides mitigation, not complete fix
- Required = Necessary for complete solution
- Recommended = Optional but improves fix

## Version History

- **v1.0** (Dec 3, 2025): Initial release with 5 critical fixes
  - SAI Event Link workarounds
  - Surveyor Candress balance fix
  - Blade of Eternal Darkness crit enable
  - Profession learning safeguards
  - EOTS immunity mitigation

## License

These fixes are provided as-is for use with AzerothCore-based servers. Follow the same license as your AzerothCore installation.
