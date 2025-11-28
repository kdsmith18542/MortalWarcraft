# MortalWarcraft Issue Categorization Guide

**Date:** 2025-01-23  
**Purpose:** Identify which AzerothCore issues are relevant for Realm 1 (Mortal Sandbox) vs Realm 2 (Legacy Journey)

---

## Realm Overview

### Realm 1: Mortal Warcraft (Mortal Sandbox)
- **Type:** Complete custom overhaul
- **Features:**
  - Classless, skill-based progression
  - Full-loot PvP zones
  - Custom economy (regional banking, trade runs)
  - Territory control and sovereignty
  - Custom crafting system
  - Custom combat formulas
  - Custom NPC tier system
- **Core Modifications:** Extensive (113+ custom database tables, 165+ Lua scripts, custom C++ modules)

### Realm 2: Mortal Warcraft: Legacy Journey
- **Type:** Expansion-progressive WotLK (Vanilla → TBC → WotLK)
- **Features:**
  - Standard WoW classes/talents
  - Era-based progression gating
  - Minimal custom systems
  - Focus on polish and stability
- **Core Modifications:** Minimal (2 custom modules, standard AzerothCore with era gating)

---

## Issue Categorization Framework

### Category 1: Core Engine Issues (Relevant for BOTH Realms)
**These affect the underlying AzerothCore engine and apply regardless of custom content.**

**Examples:**
- ✅ **#23855** - Death Knight Raise Ally spell (core spell system)
- ✅ **#2794** - Discussion channel bug (core chat system)
- ✅ **#4005** - Quest tracker performance (database performance)
- ✅ **#21397** - Mobs reset too quickly (core AI system)
- ✅ **#5116** - Leash system broken (core movement system)
- ✅ **#20873** - Spellcaster pathfinding (core AI)
- ✅ **#22677** - Spellcasters move between casts (core AI)
- ✅ **#6232** - Charge clipping through world (core spell system)

**Criteria:**
- Affects core engine systems (spells, AI, movement, database, networking)
- Not dependent on game content (quests, NPCs, items)
- Would affect any server using AzerothCore

**Action:** Fix in Realm 2, evaluate for Realm 1 (may need custom implementation)

---

### Category 2: Standard WoW Content Issues (Realm 2 Only)
**These affect standard WoW gameplay that Realm 1 has replaced with custom systems.**

**Examples:**
- ✅ **#23776** - Quest: "Iron Rune Constructs and You" missing crystal
- ✅ **#23780** - Northrend World Drop JC recipes and epic gear missing
- ✅ **#23830** - Culling of Stratholme wave spawn positions
- ✅ **#16905** - Druid Berserk energy bug
- ✅ **#21766** - Culling of Stratholme waves not patrolling
- ✅ **#15630** - Culling of Stratholme Arthas spawn timing

**Criteria:**
- Affects standard WoW quests, dungeons, raids, NPCs
- Assumes standard class/talent system
- Assumes standard progression (XP, levels, gear)

**Action:** Fix in Realm 2 only. Realm 1 has custom systems that replace these.

---

### Category 3: Custom System Issues (Realm 1 Only)
**These affect custom systems that Realm 1 has but Realm 2 doesn't.**

**Examples:**
- Skill system bugs
- Custom combat formula issues
- Territory control bugs
- Custom economy issues (market stalls, regional banking)
- Custom crafting system bugs
- Full-loot PvP zone issues
- Custom NPC tier system bugs

**Criteria:**
- Affects custom `mortal_*` database tables
- Affects custom Lua scripts
- Affects custom C++ modules (`mortal_overhaul`)

**Action:** Fix in Realm 1 only. Not applicable to Realm 2.

---

### Category 4: Infrastructure Issues (Relevant for BOTH Realms)
**These affect server infrastructure, not game content.**

**Examples:**
- Database performance issues
- Network/connection issues
- Server stability/crash issues
- Module loading issues
- Configuration issues

**Criteria:**
- Affects server operation, not game mechanics
- Would affect any server regardless of custom content

**Action:** Fix in both realms (may need realm-specific configuration)

---

## Decision Matrix

| Issue Type | Realm 1 (Mortal Sandbox) | Realm 2 (Legacy Journey) | Notes |
|------------|--------------------------|-------------------------|-------|
| **Core Engine** | ✅ Evaluate | ✅ Fix | May need custom implementation for Realm 1 |
| **Standard WoW Content** | ❌ Not Relevant | ✅ Fix | Realm 1 has custom systems |
| **Custom Systems** | ✅ Fix | ❌ Not Applicable | Realm 2 doesn't have these |
| **Infrastructure** | ✅ Fix | ✅ Fix | Both realms need stable infrastructure |

---

## Issue Prioritization for Realm 1

### High Priority
1. **Core Engine Issues** that affect custom systems
   - Example: Movement/AI issues affecting custom NPCs
   - Example: Spell system issues affecting custom abilities
2. **Infrastructure Issues** affecting server stability
3. **Custom System Bugs** that break core gameplay

### Medium Priority
1. **Core Engine Issues** that don't directly affect custom systems
   - Example: Quest tracker performance (if quest system is used)
2. **Database Performance** issues

### Low Priority / Not Relevant
1. **Standard WoW Content Issues**
   - Quest bugs (Realm 1 has custom quest system)
   - Standard dungeon/raid bugs (Realm 1 has custom content)
   - Class/talent bugs (Realm 1 is classless)

---

## Issue Prioritization for Realm 2

### High Priority
1. **Core Engine Issues** affecting gameplay
2. **Standard WoW Content Issues** affecting player experience
3. **Infrastructure Issues** affecting server stability

### Medium Priority
1. **Quest/Dungeon/Raid Bugs** affecting content progression
2. **Class/Talent Bugs** affecting gameplay balance

### Low Priority
1. **Minor Content Issues** (cosmetic, non-gameplay affecting)
2. **Edge Case Bugs** (rarely encountered)

---

## Examples: Applying the Framework

### Example 1: #23855 - Death Knight Raise Ally
- **Category:** Core Engine (spell system)
- **Realm 1:** ✅ Evaluate (if custom spell system uses same code path)
- **Realm 2:** ✅ Fix (standard DK ability)
- **Decision:** Fix in Realm 2, check if Realm 1 uses standard spell system

### Example 2: #23776 - Quest Missing Crystal
- **Category:** Standard WoW Content (quest)
- **Realm 1:** ❌ Not Relevant (custom quest system)
- **Realm 2:** ✅ Fix (standard quest)
- **Decision:** Fix in Realm 2 only

### Example 3: #4005 - Quest Tracker Performance
- **Category:** Infrastructure (database performance)
- **Realm 1:** ✅ Evaluate (if quest tracker is used)
- **Realm 2:** ✅ Fix (standard feature)
- **Decision:** Fix in Realm 2, evaluate usage in Realm 1

### Example 4: Custom Skill System Bug
- **Category:** Custom System
- **Realm 1:** ✅ Fix (core system)
- **Realm 2:** ❌ Not Applicable (doesn't have skill system)
- **Decision:** Fix in Realm 1 only

---

## Recommendations

### For Realm 1 (Mortal Sandbox)
1. **Focus on:**
   - Core engine fixes that affect custom systems
   - Custom system bugs
   - Infrastructure issues
2. **Skip:**
   - Standard WoW quest/dungeon/raid fixes
   - Class/talent fixes (classless system)
   - Standard progression fixes (custom progression)

### For Realm 2 (Legacy Journey)
1. **Focus on:**
   - All core engine fixes
   - Standard WoW content fixes
   - Infrastructure issues
2. **Skip:**
   - Custom system fixes (doesn't have them)

---

## Next Steps

1. **Review open AzerothCore issues** and categorize them using this framework
2. **Create separate issue trackers:**
   - `realm1-issues.md` - Realm 1 specific issues
   - `realm2-issues.md` - Realm 2 specific issues (already exists: `206-realm2-fixes-roadmap.md`)
3. **Prioritize fixes** based on realm-specific needs
4. **Document custom system issues** for Realm 1 separately

---

**Last Updated:** 2025-01-23

