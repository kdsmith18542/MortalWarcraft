# Critical Fixes Priority List

**Date:** 2025-01-23  
**Purpose:** Identify and prioritize critical fixes from the issue tracker

---

## Analysis

From the roadmap, most Phase 1 and Phase 2 fixes are already **Fixed** but awaiting testing. Let's identify the highest-priority **open** issues that need work.

---

## High-Priority Open Issues

### 1. **#2794 - Discussion Channel Bug** (27 comments, Confirmed)
- **Type:** Chat/Communication
- **Impact:** High - Affects all new characters (except Undead/Tauren)
- **Status:** Not Started
- **Description:** New characters are not automatically joined to channels /1 (General) and /3 (LocalDefense) on first login
- **Priority:** High - Affects player communication

### 2. **#4005 - Quest Tracker Performance** (26 comments)
- **Type:** Performance
- **Impact:** High - Causes game delay with 800+ players
- **Status:** Not Started
- **Description:** Enabling `Quests.EnableQuestTracker` causes significant game delay
- **Priority:** High - Performance issue affecting many players

### 3. **#23855 - Death Knight Raise Ally Doesn't Work**
- **Type:** Class/Spell Bug
- **Impact:** High - Core Death Knight ability broken
- **Status:** Open
- **Description:** Spell Raise Ally doesn't work at all
- **Priority:** Critical - Class-defining ability broken

### 4. **#23833 - Alliance Steam Tank Doesn't Disappear**
- **Type:** Quest/Vehicle Bug
- **Impact:** Medium - Quest progression issue
- **Status:** Open
- **Description:** Alliance Steam Tank doesn't disappear after dismounting
- **Priority:** Medium - Quest flow issue

---

## Recommended Fix Order

1. **#23855** - Death Knight Raise Ally (Critical - Class ability)
2. **#2794** - Discussion Channel Bug (High - Affects all new players)
3. **#4005** - Quest Tracker Performance (High - Performance with many players)
4. **#23833** - Steam Tank (Medium - Quest flow)

---

## Next Steps

1. Investigate each issue using our tools
2. Implement fixes
3. Test in Realm 2 environment
4. Update roadmap with status

---

**Last Updated:** 2025-01-23

