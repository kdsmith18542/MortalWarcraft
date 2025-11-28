# TrinityCore Fix Investigation

**Date:** 2025-01-23  
**Purpose:** Check if TrinityCore has fixes for our 12 completed issues

---

## Investigation Method

1. Search TrinityCore's issue tracker for our issue numbers
2. Check TrinityCore's 3.3.5 branch code for similar fixes
3. Compare fix approaches
4. Assess migration benefit

---

## Our Fixes vs TrinityCore

| Issue | Our Fix | TrinityCore Status | Notes |
|-------|---------|---------------------|-------|
| #21397 - Mobs reset too quickly | Reduced leash extension timer 5000ms → 2500ms | TBD | Check `TargetedMovementGenerator.h` |
| #5116 - Leash system broken | Added distance check (2.5x radius) | TBD | Check `Creature.cpp::CanCreatureAttack` |
| #20873 - Spellcaster pathfinding | Added `IsEngaged()` check in `JustReachedHome()` | TBD | Check `SmartAI.cpp` |
| #22677 - Spellcasters move between casts | Added 200ms post-cast movement delay | TBD | Check `TargetedMovementGenerator.cpp` |
| #6232 - Charge clipping through world | Enabled pathfinding for Charge spells | TBD | Check `SpellEffects.cpp` |
| #23831 - RDF wrong entrance (Gun'Drak) | SQL: Fixed `lfg_dungeon_template` coordinates | TBD | Check SQL updates |
| #23784 - Quest: "The Will of the Naaru" | SQL: Added SmartAI portal script | TBD | Check SmartAI scripts |
| #23783 - Crusader Bridenbrad quest | SQL: Fixed SmartAI to summon K'uri | TBD | Check SmartAI scripts |
| #23866 - Rising Anger spell bug | Core: Fixed spell school mask in `SpellInfoCorrections.cpp` | TBD | Check spell corrections |
| Eregos PLANAR_SHIFT immunity | Core: Added Planar Anomaly AI + spell script | TBD | Check `boss_eregos.cpp` |
| #23828 - Oculus Timestop bug | Core: Added target filtering to Timestop spell | TBD | Check `oculus.cpp` |
| #23776 - "Iron Rune Constructs" crystal | SQL: Added SmartAI to spawn NPC 24820 | TBD | Check SmartAI scripts |
| #23780 - World Drop JC recipes | SQL: Added reference loot template 10009 | TBD | Check loot templates |

---

## Investigation Results

### ⚠️ **CRITICAL FINDING: Issue Numbers Don't Match**

TrinityCore uses the same issue numbering system, but the issues with our numbers are **completely different problems**:

| Our Issue | TrinityCore Issue | Match? |
|-----------|-------------------|--------|
| #21397 - Mobs reset too quickly | #21397 - Flight Master Enraged Guards | ❌ **NO** |
| #5116 - Leash system broken | #5116 - Love is in the Air achievement | ❌ **NO** |
| #20873 - Spellcaster pathfinding | #20873 - Injured Stormwind Infantry icon | ❌ **NO** |
| #22677 - Spellcasters move between casts | #22677 - DB/Texts: Farrin Daris | ❌ **NO** |
| #6232 - Charge clipping through world | #6232 - Tranquility coefficient (Druid) | ❌ **NO** |

**Conclusion:** We need to search by **description/keywords**, not issue numbers.

### Core Fixes (C++) - Need Keyword Search

#### 1. Leash System Fixes (#21397, #5116)
**Status:** Need to search by "leash", "mob reset", "creature evade"  
**Files to Check:**
- `src/server/game/Movement/MovementGenerators/TargetedMovementGenerator.h`
- `src/server/game/Entities/Creature/Creature.cpp`

#### 2. Spellcaster AI Fixes (#20873, #22677)
**Status:** Need to search by "spellcaster", "pathfinding", "combat movement"  
**Files to Check:**
- `src/server/game/AI/SmartScripts/SmartAI.cpp`
- `src/server/game/Movement/MovementGenerators/TargetedMovementGenerator.cpp`

#### 3. Charge Clipping Fix (#6232)
**Status:** Need to search by "charge", "clipping", "terrain", "pathfinding"  
**Files to Check:**
- `src/server/game/Spells/SpellEffects.cpp`

#### 4. Spell Fixes (#23866)
**Status:** TBD  
**Files to Check:**
- `src/server/game/Spells/SpellInfoCorrections.cpp`

#### 5. Oculus Fixes (Eregos, #23828)
**Status:** TBD  
**Files to Check:**
- `src/server/scripts/Northrend/Nexus/Oculus/boss_eregos.cpp`
- `src/server/scripts/Northrend/Nexus/Oculus/oculus.cpp`

### Database Fixes (SQL)

#### 6. RDF Entrance Fix (#23831)
**Status:** TBD  
**Files to Check:**
- `sql/updates/world/` - Look for `lfg_dungeon_template` updates

#### 7. Quest Fixes (#23784, #23783, #23776)
**Status:** TBD  
**Files to Check:**
- `sql/updates/world/` - Look for SmartAI script updates

#### 8. Loot Template Fix (#23780)
**Status:** TBD  
**Files to Check:**
- `sql/updates/world/` - Look for `reference_loot_template` updates

---

## Next Steps

1. **Search TrinityCore codebase by keywords** (not issue numbers):
   - "leash extension timer"
   - "creature evade distance"
   - "spellcaster combat movement"
   - "charge pathfinding"
   - "planar shift eregos"
   - "oculus timestop"
   - "rising anger gormok"

2. **Check TrinityCore's 3.3.5 branch** for similar fixes
3. **Compare implementations** if fixes exist
4. **Count how many fixes TrinityCore has** vs how many we'd need to port
5. **Make recommendation** based on findings

**Note:** Since issue numbers don't match, we need to do actual code searches, not just issue tracker searches.

---

## Decision Criteria

**Switch to TrinityCore if:**
- >50% of our fixes already exist
- Module porting is straightforward
- Database compatibility is good
- Migration time is acceptable

**Stay with AzerothCore if:**
- <50% of our fixes exist
- Module porting is complex
- Migration time > 4 weeks
- Risk outweighs benefit

---

## Notes

- TrinityCore has 2.7x more commits (44,524 vs 16,690)
- TrinityCore has fewer open issues (1,576 vs 2,313)
- But we need to verify if those fixes address OUR specific issues

