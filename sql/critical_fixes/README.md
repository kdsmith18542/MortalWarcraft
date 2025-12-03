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
- [ ] Fix 006: Test Magmoth Fire Totem (Entry 25444) spell casting
- [ ] Fix 007: Test Forge of Fate smelting in Dalaran
- [ ] Fix 008: Test Prayer of Healing through walls/obstacles
- [ ] Fix 009: Test Replenishment aura doesn't cause combat
- [ ] Fix 010: Test Shadowmeld grounding instant spells
- [ ] Fix 011: Test Shadowfiend mana during Cyclone
- [ ] Fix 012: Test Thunderstorm critting grants Clearcasting
- [ ] Fix 013: Test Freezing Trap reflection by Spell Reflection
- [ ] Fix 014: Test Horde Siege Tank Demoralizer targeting
- [ ] Fix 015: Test Rogue combo point display after Cold Blood
- [ ] Fix 016: Test Tahu Sagewind spawn in Thunder Bluff
- [ ] Fix 017: Test healing threat range limitations
- [ ] Fix 018: Test Grounding Totem vs Chain Lightning
- [ ] Fix 019: Test eating/drinking during talent allocation
- [ ] Fix 020: Test Call of Flames timing in Utgarde Pinnacle
- [ ] Fix 021: Test Lightning Infused Relics Collect Data spell
- [ ] Fix 022: Test Dun-da-Dun-tah quest RP and timing
- [ ] Fix 023: Test Tinky Wickwhistle completion RP
- [ ] Fix 024: Test Battle for Undercity elevator state
- [ ] Fix 025: Test Aces High vehicle abilities and parachute
- [ ] Fix 026: Test Army of Damned Deathstorm friendly fire
- [ ] Fix 027: Test Assault by Air spear gun attacks
- [ ] Fix 028: Test Warrior Cleave with Sweeping Strikes
- [ ] Fix 029: Test Charge terrain climbing in WSG
- [ ] Fix 030: Test Thorim Chain Lightning 8 yard range

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

-- Fix 006 Testing
.go creature id 25444
-- Attack the totem's owner, observe fireball casts

-- Fix 007 Testing
.tele Dalaran
.go xyz 5922 691 643 571 6
.additem 2770  -- Copper Ore
-- Try smelting near the forge

-- Fix 008 Testing
.levelup 30
.learn 596  -- Prayer of Healing
-- Stand behind obstacle from party member, cast

-- Fix 009 Testing
-- Test any Replenishment-granting ability
.learn 31878  -- Paladin: Judgements of the Wise
-- Use in combat, shouldn't pull extra mobs

-- Fix 010 Testing
.morph 10  -- Night Elf
.learn 58984  -- Shadowmeld
-- Have someone cast Polymorph, use Shadowmeld at cast end

-- Fix 011 Testing
.learn 34433  -- Shadowfiend (Priest)
.learn 33786  -- Cyclone (Druid)
-- Cast Shadowfiend, get cycloned, check mana

-- Fix 012 Testing
.learn 51490  -- Thunderstorm
.learn 16246  -- Clearcasting
-- Cast Thunderstorm until crit, check for Clearcasting buff

-- Fix 013 Testing
.learn 1499  -- Freezing Trap
.learn 23920  -- Spell Reflection
-- Place trap, reflect it with warrior

-- Fix 014 Testing
.quest add 11652  -- The Plains of Nasam
.go creature id 25588
-- Mount siege tank, test Demoralizer on barrels

-- Fix 015 Testing
-- Create Rogue
.learn 14177  -- Cold Blood
.learn 14179  -- Relentless Strikes
.learn 2098  -- Eviscerate
-- Build 4 combo points, use Cold Blood, Eviscerate

-- Fix 016 Testing
.tele Thunderbluff
.go xyz -1040.5 218.2 129.19 1 0
-- Look for Tahu Sagewind and rug

-- Fix 017 Testing
-- Have healer and DPS in group
-- Pull mob, have healer stay 50+ yards away
-- Healer heals DPS, mob should not aggro healer

-- Fix 018 Testing
.learn 8177  -- Grounding Totem
.learn 421  -- Chain Lightning
-- Cast Grounding, cast Chain Lightning, check chain stops

-- Fix 019 Testing
.levelup 11  -- Get talent points
.additem 4536  -- Food
-- Eat food, open talents, allocate point

-- Fix 020 Testing
.tele 1196  -- Utgarde Pinnacle
.go xyz 276 -293 105
-- Fight Svala, observe Call of Flames timing

-- Fix 021 Testing
.quest add 11494  -- Lightning Infused Relics
.go c i 24807  -- Walt
-- Get disguise, go to relic, use Collect Data

-- Fix 022 Testing
.quest add 12082  -- Dun-da-Dun-tah!
.go c i 26814  -- Harrison Jones
-- Start quest, observe RP timing and snake

-- Fix 023 Testing
.quest add 11699  -- I'm Stuck in this Damned Cage
.go c i 25714  -- Tinky Wickwhistle
-- Complete and turn in quest, watch RP

-- Fix 024 Testing
.quest add 13367  -- Battle for Undercity (Horde)
-- Start quest event, observe elevator state

-- Fix 025 Testing
.quest add 13413  -- Aces High!
.go c i 32548  -- Corastrasza
-- Summon Skytalon, check abilities and dismount

-- Fix 026 Testing
.quest add 13395  -- Army of the Damned
.go c i 31795  -- Arthas vehicle
-- Use Deathstorm, verify no player damage

-- Fix 027 Testing
.quest add 13309  -- Assault by Air
.go c i 31808  -- Proto-Drake
-- Ride drake, verify spear guns attack

-- Fix 028 Testing
.levelup 30  -- Warrior with Sweeping Strikes
.learn 12328  -- Sweeping Strikes
.learn 845  -- Cleave
-- Use SS, then Cleave on 2+ targets

-- Fix 029 Testing
.bg join 2  -- Warsong Gulch
-- Try charging up to graveyard from base

-- Fix 030 Testing
.tele Ulduar
-- Fight Thorim, spread >8 yards apart
-- Observe Chain Lightning doesn't jump
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
-- Note: For better performance, ensure index exists: CREATE INDEX idx_skill_guid ON character_skills(skill, guid);
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
| 006 | ✓        | -        | -      | -      |
| 007 | ✓        | -        | -      | -      |
| 008 | Partial  | Recommended | -   | -      |
| 009 | ✓        | -        | -      | -      |
| 010 | Partial  | Required | -      | -      |
| 011 | Partial  | Required | -      | -      |
| 012 | ✓        | -        | -      | -      |
| 013 | Partial  | Required | -      | -      |
| 014 | ✓        | -        | -      | -      |
| 015 | Partial  | Recommended | -   | -      |
| 016 | ✓        | -        | -      | -      |
| 017 | Partial  | Required | -      | -      |
| 018 | Partial  | Required | -      | -      |
| 019 | Partial  | Recommended | -   | -      |
| 020 | ✓        | -        | -      | -      |
| 021 | Partial  | Required | -      | -      |
| 022 | Partial  | Recommended | -   | -      |
| 023 | ✓        | -        | -      | -      |
| 024 | Partial  | Required | -      | -      |
| 025 | Partial  | Required | -      | -      |
| 026 | Partial  | Required | -      | -      |
| 027 | Partial  | Required | -      | -      |
| 028 | Partial  | Required | -      | -      |
| 029 | Partial  | Required | -      | -      |
| 030 | Partial  | Required | -      | -      |

Legend:
- ✓ = Fully supported with this approach
- Partial = Provides mitigation, not complete fix
- Required = Necessary for complete solution
- Recommended = Optional but improves fix

### 006 - Magmoth Fire Totem (Issue #23680)
**Impact**: Medium - Borean Tundra Content
- **Problem**: Magmoth Fire Totem does nothing, doesn't cast spells
- **Solution**: Added SAI script to make totem cast fireball every 3 seconds
- **Status**: Complete database fix
- **Applies to**: Borean Tundra, level 70-72 content

### 007 - Forge of Fate Dalaran (Issue #23770)
**Impact**: Low - Mining Convenience
- **Problem**: Forge of Fate in Dalaran doesn't work as a forge for smelting
- **Solution**: Updated gameobject type to allow smelting nearby
- **Status**: Complete database fix
- **Applies to**: Dalaran, all mining professions

### 008 - Prayer of Healing LOS (Issue #21976)
**Impact**: Medium - Priest Healing
- **Problem**: Prayer of Healing requires LOS to all targets, shouldn't
- **Solution**: Added spell script preparation and attribute changes
- **Status**: Partial fix (core modification recommended)
- **Applies to**: All Priest healing content

### 009 - Replenishment Threat (Issue #12115)
**Impact**: High - Threat Mechanics
- **Problem**: Replenishment aura generates threat when it shouldn't
- **Solution**: Updated spell attributes to prevent threat generation
- **Status**: Complete database fix
- **Applies to**: All classes with Replenishment talents

### 010 - Shadowmeld Grounding (Issue #22455)
**Impact**: Medium - Night Elf PvP
- **Problem**: Shadowmeld doesn't ground instant-cast spells with proper timing
- **Solution**: Spell script preparation for timing-based grounding
- **Status**: Partial fix (core modification needed)
- **Applies to**: Night Elf racial ability, PvP content

### 011 - Shadowfiend Cyclone (Issue #22536)
**Impact**: Medium - Druid/Priest Interaction
- **Problem**: Shadowfiend restores mana while priest is cycloned
- **Solution**: Added spell script to check for cyclone state
- **Status**: Partial fix (core modification needed)
- **Applies to**: Druid Cyclone + Priest Shadowfiend interaction

### 012 - Thunderstorm Clearcasting (Issue #23326)
**Impact**: Medium - Shaman Talent Proc
- **Problem**: Thunderstorm crits don't grant Clearcasting buff
- **Solution**: Added proc flags and spell proc event entries
- **Status**: Complete database fix
- **Applies to**: Elemental Shaman talent interactions

### 013 - Freezing Trap Reflection (Issue #22028)
**Impact**: Medium - Hunter Trap PvP
- **Problem**: Freezing Trap can't be reflected by Spell Reflection
- **Solution**: Removed cant-be-reflected flag, added reflection script
- **Status**: Partial fix (core modification needed)
- **Applies to**: Hunter traps, Warrior/Engineering reflection mechanics

### 014 - Siege Tank Demoralizer (Issue #21276)
**Impact**: Medium - Borean Tundra Vehicles
- **Problem**: Demoralizer spell direction wrong, hits barrels incorrectly
- **Solution**: Fixed spell targeting, made barrels immune to combat
- **Status**: Complete database fix
- **Applies to**: Borean Tundra vehicle quests

### 015 - Combo Point Visual (Issue #22068)
**Impact**: Low - Rogue UI
- **Problem**: Combo points display incorrectly with Cold Blood + Relentless Strikes
- **Solution**: Added spell script to force combo point refresh
- **Status**: Partial fix (core modification needed)
- **Applies to**: Rogue finishers, combo point system

### 016 - Tahu Sagewind Missing (Issue #22752)
**Impact**: Low - Thunder Bluff NPC
- **Problem**: Tahu Sagewind NPC missing from Thunder Bluff
- **Solution**: Added NPC spawn, conversation scripts, and rug gameobject
- **Status**: Complete database fix
- **Applies to**: Thunder Bluff lore NPCs

### 017 - Healer Aggro Range (Issue #3655)
**Impact**: High - Healing Threat
- **Problem**: Healing can pull mobs from unlimited range
- **Solution**: Reduced healing threat coefficient, added range checks
- **Status**: Mitigation (core fix needed for complete solution)
- **Applies to**: All healing classes, threat generation

### 018 - Grounding Totem Chain Lightning (Issue #21627)
**Impact**: Medium - Shaman Totem Interaction
- **Problem**: Grounding Totem doesn't fully consume Chain Lightning
- **Solution**: Modified Chain Lightning to stop chaining when grounded
- **Status**: Partial fix (core modification needed)
- **Applies to**: Shaman Grounding Totem mechanics

### 019 - Eating Talent Animation (Issue #23827)
**Impact**: Low - Quality of Life
- **Problem**: Allocating talent points cancels eating/drinking animation
- **Solution**: Modified aura interrupt flags on food/drink buffs
- **Status**: Partial fix (core modification recommended)
- **Applies to**: All classes, food/drink mechanics

### 020 - Call of Flames Timing (Issue #21513)
**Impact**: Medium - Utgarde Pinnacle Boss
- **Problem**: Svala Sorrowgrave's Call of Flames ticks too fast
- **Solution**: Fixed spell tick timing to 3 seconds between ticks
- **Status**: Complete database fix
- **Applies to**: Utgarde Pinnacle, level 80 dungeon content

### 021 - Lightning Infused Relics (Issue #23596)
**Impact**: High - Quest Breaking
- **Problem**: Collect Data vehicle spell warps player to Westfall graveyard
- **Solution**: Fixed spell effect and targeting, removed teleport
- **Status**: Partial fix (core modification needed)
- **Applies to**: Storm Peaks quest content

### 022 - Dun-da-Dun-tah Quest (Issue #23790)
**Impact**: Medium - Quest Polish
- **Problem**: Harrison Jones timing issues, snake attackable, drakkars spawn incorrectly
- **Solution**: Fixed movement speed, RP timing, prevented poison stacking
- **Status**: Partial fix (core modification recommended)
- **Applies to**: Sholazar Basin quest chain

### 023 - Tinky Wickwhistle RP (Issue #23777)
**Impact**: Low - Quest Completion RP
- **Problem**: No RP when turning in quest
- **Solution**: Added SAI script for teleport visual and dialogue
- **Status**: Complete database fix
- **Applies to**: Borean Tundra quest content

### 024 - Battle for Undercity Lifts (Issue #23792)
**Impact**: Medium - Quest Mechanics
- **Problem**: Lifts work during quest when they should be broken
- **Solution**: Disabled elevators during quest phase
- **Status**: Partial fix (phasing needed)
- **Applies to**: Undercity quest event

### 025 - Aces High Quest (Issue #23834)
**Impact**: High - Quest Functionality
- **Problem**: Multiple vehicle issues - wrong abilities, no parachute, NPCs don't attack
- **Solution**: Fixed vehicle spells, added Blazing Speed, parachute, NPC AI
- **Status**: Partial fix (core modification needed)
- **Applies to**: Dragonblight quest content

### 026 - Army of Damned Deathstorm (Issue #23896)
**Impact**: High - Quest Fairness
- **Problem**: Player takes damage from Arthas's Deathstorm ability
- **Solution**: Updated spell to only hit hostile targets
- **Status**: Partial fix (core modification needed)
- **Applies to**: Icecrown quest vehicle content

### 027 - Assault by Air Spear Guns (Issue #21680)
**Impact**: Medium - Quest Mechanics
- **Problem**: Spear guns don't attack, no parachute on dismount
- **Solution**: Added SAI for attacks, parachute on dismount
- **Status**: Partial fix (core modification needed)
- **Applies to**: Icecrown vehicle quest

### 028 - Cleave Sweeping Strikes (Issue #22427)
**Impact**: Medium - Warrior DPS
- **Problem**: Cleave doesn't consume 2 Sweeping Strikes stacks
- **Solution**: Added proc events for proper interaction
- **Status**: Partial fix (core modification needed)
- **Applies to**: Warrior melee combat, all levels

### 029 - Charge Terrain Climbing (Issue #22331)
**Impact**: Medium - Warrior/Druid Mobility
- **Problem**: Can't charge up terrain in WSG graveyards
- **Solution**: Updated spell to allow vertical movement
- **Status**: Partial fix (core modification needed)
- **Applies to**: Warsong Gulch, Warrior/Druid charge abilities

### 030 - Thorim Chain Lightning Range (Issue #22498)
**Impact**: Medium - Ulduar Boss Mechanics
- **Problem**: Chain Lightning jumps beyond intended 8 yard range
- **Solution**: Fixed spell radius and distance checks
- **Status**: Partial fix (core modification needed)
- **Applies to**: Ulduar raid, Thorim encounter

## Version History

- **v3.0** (Dec 3, 2025): Comprehensive release with 25 critical fixes
  - Added 10 more quest and vehicle fixes (021-030)
  - Focus on WotLK vehicle quests and combat mechanics
  - Improved warrior/druid mobility and combat interactions
  
- **v2.0** (Dec 3, 2025): Expanded release with 15 critical fixes
  - Added 10 new fixes covering spell mechanics, NPCs, and PvP interactions
  - Focus on vanilla and early WotLK content
  - Improved threat mechanics and class ability interactions
  
- **v1.0** (Dec 3, 2025): Initial release with 5 critical fixes
  - SAI Event Link workarounds
  - Surveyor Candress balance fix
  - Blade of Eternal Darkness crit enable
  - Profession learning safeguards
  - EOTS immunity mitigation

## License

These fixes are provided as-is for use with AzerothCore-based servers. Follow the same license as your AzerothCore installation.
