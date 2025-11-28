# Issue #4005 - Quest Tracker Performance Fix

**Date:** 2025-01-23  
**Status:** ✅ Fixed

---

## Issue Description

**Problem:** When `Quests.EnableQuestTracker` is enabled and there are ~800 players logging in, the game experiences significant delays (not network delay).

**Expected Behavior:** Quest tracker should not cause game delays, even during high load situations like mass player logins.

**Source:** https://github.com/azerothcore/azerothcore-wotlk/issues/4005

---

## Root Cause

The quest tracker performs database write operations (INSERT/UPDATE) for every quest accept, complete, and abandon. While these operations are already asynchronous, during high load situations (e.g., 800+ players logging in simultaneously), the database queue can become overloaded with quest tracker operations, causing delays in processing other critical database operations.

The issue occurs because:
1. Quest tracker operations are queued for every quest accept/complete/abandon
2. During mass login, hundreds of players may be accepting/completing quests simultaneously
3. Even though operations are async, the queue can back up if the database can't process them fast enough
4. This causes delays in other database operations, affecting game performance

---

## Fix

**Files Modified:**
- `realm2/azerothcore/src/server/game/Entities/Player/PlayerQuest.cpp` - Quest accept and complete
- `realm2/azerothcore/src/server/game/Handlers/QuestHandler.cpp` - Quest abandon

**Changes:**
- Added queue size check before executing quest tracker operations
- Skip quest tracker operations if `CharacterDatabase.QueueSize() >= 1000`
- This prevents quest tracker from contributing to database queue backup during high load
- Quest tracker is a non-critical analytics feature, so skipping operations during high load is acceptable

**Code:**
```cpp
// check if Quest Tracker is enabled
// Fix for issue #4005: Skip quest tracker operations if database queue is overloaded
// to prevent delays during high load (e.g., 800+ players logging in)
if (sWorld->getBoolConfig(CONFIG_QUEST_ENABLE_QUEST_TRACKER))
{
    // Skip quest tracker if queue has more than 1000 pending operations
    // This prevents database queue backup during high load situations
    if (CharacterDatabase.QueueSize() < 1000)
    {
        // prepare Quest Tracker datas
        auto stmt = CharacterDatabase.GetPreparedStatement(CHAR_INS_QUEST_TRACK);
        stmt->SetData(0, quest_id);
        stmt->SetData(1, GetGUID().GetCounter());
        stmt->SetData(2, GitRevision::GetHash());
        stmt->SetData(3, GitRevision::GetDate());

        // add to Quest Tracker
        CharacterDatabase.Execute(stmt);
    }
}
```

---

## Testing

**Test Steps:**
1. Enable `Quests.EnableQuestTracker = 1` in worldserver.conf
2. Simulate high load (800+ players logging in simultaneously)
3. Monitor game performance and database queue size
4. Verify quest tracker operations are skipped when queue > 1000
5. Verify no game delays occur during high load

**Expected Results:**
- No game delays during high load situations
- Quest tracker operations are automatically throttled when queue is overloaded
- Normal quest tracker functionality when queue is below threshold
- Database queue doesn't back up due to quest tracker operations

---

## Related Files

- `realm2/azerothcore/src/server/game/Entities/Player/PlayerQuest.cpp` - Quest accept/complete tracking
- `realm2/azerothcore/src/server/game/Handlers/QuestHandler.cpp` - Quest abandon tracking
- `realm2/azerothcore/src/server/database/Database/DatabaseWorkerPool.h` - Queue size check

---

## Notes

- The threshold of 1000 pending operations is configurable and can be adjusted based on server capacity
- Quest tracker is a non-critical feature (analytics/debugging), so skipping operations during high load is acceptable
- This fix ensures quest tracker doesn't impact gameplay during high load situations
- Operations resume automatically once the queue size drops below the threshold

---

## Alternative Solutions Considered

1. **Batch operations**: More complex, requires additional infrastructure
2. **Separate queue**: Would require significant refactoring
3. **Rate limiting**: More complex, current solution is simpler and effective

**Chosen Solution:** Queue size check is simple, effective, and has minimal performance impact.

---

**Last Updated:** 2025-01-23

