# PR Review Results - Potential Time Savers

**Date:** 2025-01-23  
**Method:** GitHub API PR Search

---

## Summary

**Checked for PRs addressing our fixes:**
- ✅ **#16905 (Berserk energy)** - No PRs found - Our fix is still needed
- ✅ **#23830 (Culling spawns)** - No PRs found - Our fix is still needed

**Found relevant open PRs that might help with other issues:**

---

## Open PRs That Might Save Time

### 1. **#23848** - fix(DB/SmartAI): add 'The Hills Have Us' Wintergarde Gryphon taxi
   - **URL:** https://github.com/azerothcore/azerothcore-wotlk/pull/23848
   - **State:** Open
   - **Labels:** DB, Waiting to be Tested, Ready to be Reviewed
   - **Author:** sogladev
   - **Updated:** 2025-11-23
   - **Relevance:** Fixes issue #23832 - "The Hills Have Us - missing Taxi"
   - **Action:** ✅ **Can use this PR** - Saves time on #23832

### 2. **#23847** - fix(DB/Quest) No prerequisite for The Artifacts of Steel Gate
   - **URL:** https://github.com/azerothcore/azerothcore-wotlk/pull/23847
   - **State:** Open
   - **Labels:** DB
   - **Author:** blinkysc
   - **Updated:** 2025-11-23
   - **Relevance:** Fixes issue #23846 - "The Artifacts of Steel Gate wrong quest prerequisite"
   - **Action:** ✅ **Can use this PR** - Saves time on #23846

### 3. **#23873** - fix(DB/Creature): update gossip for pilgrims bounty cooking trainers
   - **URL:** https://github.com/azerothcore/azerothcore-wotlk/pull/23873
   - **State:** Open
   - **Labels:** DB, Ready to be Reviewed
   - **Author:** sogladev
   - **Updated:** 2025-11-23
   - **Relevance:** Fixes issue #23868 - "Pilgrim's Bounty Horde Cooking trainers don't train cooking while offering quests"
   - **Action:** ✅ **Can use this PR** - Saves time on #23868

---

## Closed PRs (Already Merged - Check if we have them)

### Culling of Stratholme Related:
- **#22545** - fix(DB/SAI): Implement various missing Culling of Stratholme behaviours
  - **State:** Closed (merged)
  - **Date:** 2025-07-24
  - **Note:** Might have fixes we need, but doesn't address wave spawn randomization

- **#22550** - fix(DB/SAI): Implement various missing Culling of Stratholme behaviours (part 2)
  - **State:** Closed (merged)
  - **Date:** 2025-07-24
  - **Note:** Part 2 of above

---

## Issues We Fixed - Status Check

### #16905 - Druid Berserk Energy Bug
- **Last Updated:** 2025-09-21 (from issue fetch)
- **PRs Found:** None
- **Status:** ✅ Our fix is still needed - no upstream PR exists

### #23830 - Culling Wave Spawn Positions
- **Last Updated:** 2025-11-21 (from issue fetch)
- **PRs Found:** None
- **Status:** ✅ Our fix is still needed - no upstream PR exists

---

## Recommendations

### Immediate Actions:

1. **Review and potentially use these PRs:**
   - **#23848** for issue #23832 (The Hills Have Us taxi)
   - **#23847** for issue #23846 (Artifacts of Steel Gate prerequisite)
   - **#23873** for issue #23868 (Pilgrim's Bounty cooking trainers)

2. **Check if PRs are mergeable:**
   - Review the code changes
   - Test if they work in Realm 2
   - Cherry-pick or merge if acceptable

3. **Continue with our fixes:**
   - #16905 and #23830 have no PRs, so our fixes are still needed
   - Our fixes are ready for testing

### Long-term Strategy:

1. **Before starting any fix:**
   - Always check for existing PRs first
   - Use `tools/fetch_github_prs.py --issue <number>` to search
   - Review PR code to see if it's acceptable

2. **Monitor open PRs:**
   - Check weekly for new PRs that might help
   - Review "Ready to be Reviewed" PRs
   - Consider contributing to existing PRs instead of creating new fixes

3. **Upstream contribution:**
   - If our fixes work well, consider creating PRs upstream
   - This helps the community and reduces duplicate work

---

## Tools Created

1. **`fetch_github_prs.py`** - Search and fetch PRs
   - Search by issue number
   - Search by keywords
   - List open/closed PRs
   - Get PR details

2. **`fetch_github_issue.py`** - Check issue status
   - Get latest issue updates
   - Check if issues are still open
   - Get issue comments

---

## Next Steps

1. **Review PRs #23848, #23847, #23873:**
   ```bash
   # Get full PR details
   python3 tools/fetch_github_prs.py --repo azerothcore/azerothcore-wotlk --issue 23832 --details
   python3 tools/fetch_github_prs.py --repo azerothcore/azerothcore-wotlk --issue 23846 --details
   python3 tools/fetch_github_prs.py --repo azerothcore/azerothcore-wotlk --issue 23868 --details
   ```

2. **Decide if PRs are acceptable:**
   - Check code quality
   - Verify they fix the issues correctly
   - Test in Realm 2 environment

3. **If PRs are good:**
   - Cherry-pick commits
   - Or wait for upstream merge
   - Update roadmap to mark issues as "Waiting for upstream PR"

---

**Last Updated:** 2025-01-23

