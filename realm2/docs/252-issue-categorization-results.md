# Issue Categorization Results

**Date:** 2025-01-23  
**Purpose:** Categorize open AzerothCore issues for Realm 1 vs Realm 2

---

## Categorization Framework

See `251-mortalwarcraft-issue-categorization.md` for full framework.

**Categories:**
1. **Core Engine** - Affects underlying engine (both realms)
2. **Standard WoW Content** - Standard quests/dungeons/raids (Realm 2 only)
3. **Custom Systems** - Mortal Warcraft custom features (Realm 1 only)
4. **Infrastructure** - Server operation (both realms)

---

## Already Fixed Issues

### Core Engine (Both Realms)
- ✅ **#23855** - Death Knight Raise Ally (Fixed)
- ✅ **#2794** - Discussion channel bug (Fixed)
- ✅ **#4005** - Quest tracker performance (Fixed)
- ✅ **#21397** - Mobs reset too quickly (Fixed)
- ✅ **#5116** - Leash system broken (Fixed)
- ✅ **#20873** - Spellcaster pathfinding (Fixed)
- ✅ **#22677** - Spellcasters move between casts (Fixed)
- ✅ **#6232** - Charge clipping through world (Fixed)
- ✅ **#23806** - Flying vehicle movement issues (Fixed)

### Standard WoW Content (Realm 2 Only)
- ✅ **#23776** - Quest: "Iron Rune Constructs and You" missing crystal (Fixed)
- ✅ **#23780** - Northrend World Drop JC recipes and epic gear missing (Fixed)
- ✅ **#23830** - Culling of Stratholme wave spawn positions (Fixed)
- ✅ **#16905** - Druid Berserk energy bug (Fixed)
- ✅ **#21766** - Culling of Stratholme waves not patrolling (Fixed)
- ✅ **#15630** - Culling of Stratholme Arthas spawn timing (Fixed)
- ✅ **#15632** - Culling of Stratholme troops don't emote (Fixed)
- ✅ **#15626** - Culling of Stratholme citizens gossip (Fixed)
- ✅ **#15629** - Culling of Stratholme crate RP events (Fixed)
- ✅ **#15621** - Culling of Stratholme Brandon Eiredeck crowd (Fixed)
- ✅ **#15620** - Culling of Stratholme Patricia O'Reilly crowd (Fixed)
- ✅ **#15623** - Culling of Stratholme Stephanie Sindree harassment (Fixed)
- ✅ **#23863** - Thorim missing hammer after quest (Fixed)
- ✅ **#23834** - Aces High! quest issues (Fixed)
- ✅ **#23851** - Aberrations quest death animation (Fixed)

---

## Open Issues - Categorized

### Category 1: Core Engine Issues (Both Realms)

#### High Priority
1. **#23827** - Putting a talent point while eating cancels out eating animation
   - **Type:** Core Engine (animation/interaction system)
   - **Realm 1:** ✅ Evaluate (if custom skill system uses same code path)
   - **Realm 2:** ✅ Fix (standard talent system)
   - **Priority:** Medium-High (affects gameplay)

2. **#23806** - Flying vehicle issues
   - **Type:** Core Engine (vehicle system)
   - **Realm 1:** ✅ Evaluate (if vehicles are used in custom content)
   - **Realm 2:** ✅ Fix (standard vehicle system)
   - **Priority:** Medium (quest flow)

#### Medium Priority
3. **#23856** - Onslaught Gryphon Ride patrols through buildings and underwater
   - **Type:** Core Engine (pathfinding/movement)
   - **Realm 1:** ✅ Evaluate
   - **Realm 2:** ✅ Fix
   - **Priority:** Medium (pathfinding issue)

---

### Category 2: Standard WoW Content Issues (Realm 2 Only)

#### High Priority
1. **#23833** - Alliance Steam Tank does not disappear after dismounted
   - **Type:** Standard WoW Content (quest/vehicle)
   - **Realm 1:** ❌ Not Relevant
   - **Realm 2:** ✅ Fix
   - **Priority:** Medium (quest flow)

2. **#23863** - [Stormpeaks] Thorim is missing his hammer after regaining it
   - **Type:** Standard WoW Content (quest)
   - **Realm 1:** ❌ Not Relevant
   - **Realm 2:** ✅ Fix
   - **Priority:** Medium (quest progression)

3. **#23834** - Aces High! quest issues
   - **Type:** Standard WoW Content (quest)
   - **Realm 1:** ❌ Not Relevant
   - **Realm 2:** ✅ Fix
   - **Priority:** Medium (quest flow)

4. **#23851** - [Stormpeaks] Quest Aberrations/The Aberrations Must Die - The eggs do not have their death animation
   - **Type:** Standard WoW Content (quest)
   - **Realm 1:** ❌ Not Relevant
   - **Realm 2:** ✅ Fix
   - **Priority:** Medium (quest visual)

5. **#23826** - [Quest] - Of Keys and Cages you shouldn't be able to "free" multiple Gjalerbron Prisoner with 1 cage opening
   - **Type:** Standard WoW Content (quest)
   - **Realm 1:** ❌ Not Relevant
   - **Realm 2:** ✅ Fix
   - **Priority:** Medium (quest logic)

6. **#23808** - [Howling Fjord] Westguard Sergeant can be taken out of Skorn
   - **Type:** Standard WoW Content (quest)
   - **Realm 1:** ❌ Not Relevant
   - **Realm 2:** ✅ Fix
   - **Priority:** Medium (quest NPC behavior)

7. **#23803** - [Quest] - The Lodestone, NPC Image of Stone Giants do not dispawn after the RP event
   - **Type:** Standard WoW Content (quest)
   - **Realm 1:** ❌ Not Relevant
   - **Realm 2:** ✅ Fix
   - **Priority:** Medium (quest RP event)

#### Medium Priority
8. **#23807** - [Stormpeaks] Seething revenant no loot
   - **Type:** Standard WoW Content (loot)
   - **Realm 1:** ❌ Not Relevant
   - **Realm 2:** ✅ Fix
   - **Priority:** Medium (loot table)

9. **#23804** - Wyrm Reanimators in Sindragosa's Fall can fail to respawn
   - **Type:** Standard WoW Content (spawn/respawn)
   - **Realm 1:** ❌ Not Relevant
   - **Realm 2:** ✅ Fix
   - **Priority:** Medium (spawn system)

#### Raid/Dungeon Issues
10. **#23872** - [Ulduar] Assembly of Iron - Stormcaller Brundir can die during Overload cast
    - **Type:** Standard WoW Content (raid boss)
    - **Realm 1:** ❌ Not Relevant
    - **Realm 2:** ✅ Fix
    - **Priority:** High (raid boss mechanics)

---

### Category 3: Custom System Issues (Realm 1 Only)

*No standard AzerothCore issues fall into this category. Custom system issues would be tracked separately in Realm 1's issue tracker.*

---

### Category 4: Infrastructure Issues (Both Realms)

*No infrastructure issues found in current open issues list.*

---

## Recommended Fix Order for Realm 2

### Phase 1: High Priority Core Engine
1. **#23827** - Talent point while eating (Core Engine)
2. **#23806** - Flying vehicle issues (Core Engine)

### Phase 2: High Priority Content
3. ✅ **#23872** - Ulduar Assembly of Iron boss bug (Raid) - **FIXED**
4. ✅ **#23833** - Alliance Steam Tank (Quest) - **FIXED**
5. ✅ **#23863** - Thorim missing hammer (Quest) - **FIXED**

### Phase 3: Medium Priority Content
6. ✅ **#23834** - Aces High! quest - **FIXED**
7. ✅ **#23806** - Flying vehicle movement issues - **FIXED** (core engine fix)
8. ✅ **#23851** - Aberrations quest death animation - **FIXED**
9. ✅ **#23826** - Of Keys and Cages quest - **FIXED**
10. ✅ **#23808** - Westguard Sergeant quest - **FIXED**
11. **#23803** - The Lodestone quest
12. **#23807** - Seething revenant loot
13. **#23804** - Wyrm Reanimators respawn

---

## Summary Statistics

**Total Open Issues Reviewed:** ~50

**By Category:**
- **Core Engine:** 3 issues (both realms)
- **Standard WoW Content:** 10+ issues (Realm 2 only)
- **Custom Systems:** 0 issues (Realm 1 only - tracked separately)
- **Infrastructure:** 0 issues (both realms)

**By Priority:**
- **High Priority:** 5 issues
- **Medium Priority:** 8+ issues
- **Low Priority:** Remaining issues

---

## Next Steps

1. ✅ Continue fixing high-priority issues
2. ✅ Update roadmap with categorized issues
3. ✅ Create Realm 1-specific issue tracker (if needed)
4. ✅ Prioritize fixes based on player impact

---

**Last Updated:** 2025-01-23

