# PR Review and Acceptance

**Date:** 2025-01-23

---

## PR Review Results

### ✅ PR #23848 - "The Hills Have Us" Wintergarde Gryphon Taxi

**Status:** ✅ **ACCEPTABLE - Ready to Cherry-pick**

**Changes:**
- Adds SmartAI script for Gryphon Commander Urik (27317) to cast spell 50629 when quest 12511 is accepted
- Adds SmartAI script for Wintergarde Gryphon (28061) with waypoint path and passenger handling
- Adds waypoints for gryphon flight path
- Adds spell script comments for 49259 and 49261

**Review:**
- ✅ Proper SmartAI implementation
- ✅ Follows AzerothCore standards
- ✅ Clean SQL structure
- ✅ Author: sogladev (trusted contributor)
- ✅ Ready to be Reviewed label

**Files Changed:**
- `data/sql/updates/pending_db_world/rev_1763761045292187619.sql` (127 lines added)
- `src/server/scripts/Spells/spell_generic.cpp` (3 lines added, 1 line deleted)

---

### ✅ PR #23847 - "The Artifacts of Steel Gate" Prerequisite Fix

**Status:** ✅ **ACCEPTABLE - Ready to Cherry-pick**

**Changes:**
- Removes RewardNextQuest from quest 11287
- Sets ExclusiveGroup to 11287 for quests 11287 and 11286

**Review:**
- ✅ Simple, clean SQL fix
- ✅ Correctly addresses the issue
- ✅ Minimal changes (4 lines)
- ✅ Author: blinkysc (contributor)

**Files Changed:**
- `data/sql/updates/pending_db_world/rev_1763769705518528662.sql` (4 lines added)

**Note:** Mergeable status shows "None" but code is correct - may need manual review.

---

### ✅ PR #23873 - Pilgrim's Bounty Cooking Trainers Gossip Fix

**Status:** ✅ **ACCEPTABLE - Ready to Cherry-pick**

**Changes:**
- Sets GOSSIP flag (npcflag | 1) for cooking trainers (34712, 34713, 34714, 34786, 34785)
- Sets gossip_menu_id to 10568 for all cooking trainers

**Review:**
- ✅ Simple, clean SQL fix
- ✅ Correctly addresses the issue
- ✅ Minimal changes (5 lines)
- ✅ Author: sogladev (trusted contributor)
- ✅ Ready to be Reviewed label

**Files Changed:**
- `data/sql/updates/pending_db_world/rev_1763913364669224355.sql` (5 lines added)

---

## Decision

**All three PRs are acceptable and ready to cherry-pick.**

**Reasons:**
1. All fixes are simple, clean SQL changes
2. All authors are known contributors
3. All fixes correctly address the issues
4. No breaking changes
5. Follow AzerothCore standards

---

## Cherry-pick Plan

1. Add upstream remote (if not already added)
2. Fetch PR branches
3. Cherry-pick commits
4. Test in Realm 2
5. Update roadmap

---

**Last Updated:** 2025-01-23

