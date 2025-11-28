# Cherry-pick Summary - PRs #23848, #23847, #23873

**Date:** 2025-01-23  
**Branch:** `realm2-cherrypick-prs-23848-23847-23873`

---

## Summary

Successfully cherry-picked 3 PRs from upstream AzerothCore:

1. **PR #23848** - "The Hills Have Us" Wintergarde Gryphon Taxi Fix
2. **PR #23847** - "The Artifacts of Steel Gate" Prerequisite Fix  
3. **PR #23873** - Pilgrim's Bounty Cooking Trainers Gossip Fix

---

## Commits Cherry-picked

1. **8b8133b36** - `fix(DB/SmartAI): add 'The Hills Have Us' Wintergarde Gryphon taxi`
   - Fixes issue #23832
   - Adds SmartAI scripts for gryphon taxi

2. **97c00d4ee** - `fix(DB/Quest) No prerequisite for The Artifacts of Steel Gate`
   - Fixes issue #23846
   - Removes incorrect quest prerequisite

3. **49aa803ba** - `fix(DB/Creature): update gossip for pilgrims bounty cooking trainers`
   - Fixes issue #23868
   - Sets gossip flags for cooking trainers

---

## Files Changed

### PR #23848:
- `data/sql/updates/pending_db_world/rev_1763761045292187619.sql` (new)
- `src/server/scripts/Spells/spell_generic.cpp` (modified)

### PR #23847:
- `data/sql/updates/pending_db_world/rev_1763769705518528662.sql` (new)

### PR #23873:
- `data/sql/updates/pending_db_world/rev_1763913364669224355.sql` (new)

---

## Next Steps

1. **Test the changes:**
   - Test quest #12511 "The Hills Have Us" - verify gryphon taxi works
   - Test quest #11287 "The Artifacts of Steel Gate" - verify prerequisite is correct
   - Test Pilgrim's Bounty cooking trainers - verify gossip works

2. **Merge to realm2-develop:**
   ```bash
   git checkout realm2-develop
   git merge realm2-cherrypick-prs-23848-23847-23873
   ```

3. **Update roadmap:**
   - Mark issues #23832, #23846, #23868 as "Fixed via upstream PR"
   - Update status in `206-realm2-fixes-roadmap.md`

---

## Benefits

✅ **Saved time** - Didn't need to implement fixes ourselves  
✅ **Upstream quality** - Fixes from trusted contributors  
✅ **Future-proof** - Will be merged upstream eventually  
✅ **Clean code** - Follows AzerothCore standards  

---

**Last Updated:** 2025-01-23

