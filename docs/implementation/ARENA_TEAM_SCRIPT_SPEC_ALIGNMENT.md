# ArenaTeamScript Hooks - Spec 34 Alignment Verification

**Date:** 2025-01-XX  
**Spec:** `34-mortal-arena-and-rating.md`  
**Status:** ✅ **ALIGNED** - All required hooks are available and properly implemented

---

## Spec Requirements

From **Section 7** of `34-mortal-arena-and-rating.md`:

> "All other logic can be:
> - Driven by existing AC arena structures + these overlays, plus **C++/script hooks for:**
>   - **Reward calculation at reset.**
>   - **Rating/MMR updates post-match.**"

---

## Current ArenaTeamScript Hooks

### ✅ Available Hooks (5 total)

1. **`OnGetSlotByType`** - Maps arena type to slot
   - Hook: `ARENATEAMHOOK_ON_GET_SLOT_BY_TYPE`
   - Called from: `ArenaTeam.cpp:635`
   - Purpose: Slot mapping for UI/display

2. **`OnGetArenaPoints`** - **REWARD CALCULATION** ✅
   - Hook: `ARENATEAMHOOK_ON_GET_ARENA_POINTS`
   - Called from: `ArenaTeam.cpp:678` (in `GetPoints()` method)
   - Purpose: **Aligns with spec requirement for "Reward calculation at reset"**
   - Usage: Called during `ArenaTeam::GetPoints()` which is used in:
     - `ArenaTeam::UpdateArenaPointsHelper()` (weekly reward calculation)
     - `ArenaTeamMgr::DistributeArenaPoints()` (weekly reset)

3. **`OnTypeIDToQueueID`** - Maps type ID to queue ID
   - Hook: `ARENATEAMHOOK_ON_TYPEID_TO_QUEUEID`
   - Called from: `BattlegroundMgr.cpp:697`
   - Purpose: Queue type mapping

4. **`OnQueueIdToArenaType`** - Maps queue ID to arena type
   - Hook: `ARENATEAMHOOK_ON_QUEUEID_TO_ARENA_TYPE`
   - Called from: `BattlegroundMgr.cpp:729`
   - Purpose: Arena type mapping

5. **`OnSetArenaMaxPlayersPerTeam`** - Sets max players per team
   - Hook: `ARENATEAMHOOK_ON_SET_ARENA_MAX_PLAYERS_PER_TEAM`
   - Called from: `BattlegroundMgr.cpp:421`
   - Purpose: Team size configuration

---

## Supporting Hooks (Other Script Types)

### ✅ Rating/MMR Updates Post-Match

The spec requirement for "Rating/MMR updates post-match" is handled by:

1. **`FormulaScript::OnAfterArenaRatingCalculation`** ✅
   - Called from: `Arena.cpp:290` (after rating calculation)
   - Purpose: **Aligns with spec requirement for "Rating/MMR updates post-match"**
   - Provides access to:
     - `winnerMatchmakerChange` / `loserMatchmakerChange` (MMR changes)
     - `winnerChange` / `loserChange` (rating changes)
   - Called immediately after `ArenaTeam::WonAgainst()` / `ArenaTeam::LostAgainst()`

2. **`FormulaScript::OnBeforeUpdatingPersonalRating`**
   - Called from: `ArenaTeam.cpp:879, 886` (before personal rating update)
   - Purpose: Modify personal rating changes before application

3. **`GlobalScript::OnBeforeUpdateArenaPoints`**
   - Called from: `ArenaTeamMgr.cpp:231` (before weekly point distribution)
   - Purpose: Modify arena points map before distribution

---

## Implementation Status

### ✅ All Spec Requirements Met

| Spec Requirement | Implementation | Status |
|-----------------|----------------|--------|
| **Reward calculation at reset** | `ArenaTeamScript::OnGetArenaPoints()` | ✅ Available |
| **Rating/MMR updates post-match** | `FormulaScript::OnAfterArenaRatingCalculation()` | ✅ Available |

### Hook Implementation Quality

All hooks are:
- ✅ Properly declared in header files
- ✅ Properly implemented with `CALL_ENABLED_HOOKS` macro
- ✅ Called from appropriate game code locations
- ✅ Registered in ScriptMgr

---

## Usage for Spec 34 Implementation

To implement the Mortal arena system per Spec 34, you would use:

1. **For Weekly Reward Calculation:**
   ```cpp
   // In your MortalArenaScript class
   void OnGetArenaPoints(ArenaTeam* team, float& points) override
   {
       // Modify points based on:
       // - Rating bands (P1-P6)
       // - Bracket type (2v2/3v3/5v5)
       // - Season configuration
       // - Mortal-specific reward formulas
   }
   ```

2. **For Rating/MMR Updates:**
   ```cpp
   // In your MortalFormulaScript class
   void OnAfterArenaRatingCalculation(Battleground* const bg, 
                                       int32& winnerMatchmakerChange, 
                                       int32& loserMatchmakerChange, 
                                       int32& winnerChange, 
                                       int32& loserChange) override
   {
       // Track rating/MMR changes in mortal_arena_team_rating table
       // Update season statistics
       // Trigger rating band changes
   }
   ```

---

## AzerothCore API Compliance

### ✅ Implementation Follows AzerothCore Patterns

The ArenaTeamScript implementation correctly uses the AzerothCore script API:

1. **Inheritance**: Inherits from `ScriptObject` ✅
2. **Registration**: Uses `ScriptRegistry<ArenaTeamScript>::AddScript()` ✅
3. **Hook Macros**: Uses `CALL_ENABLED_HOOKS` macro correctly ✅
4. **Template Instantiation**: Includes `template class AC_GAME_API ScriptRegistry<ArenaTeamScript>;` ✅
5. **Inclusion**: Included in `AllScriptsObjects.h` ✅
6. **Initialization**: Registered in `ScriptMgr::Initialize()` (line 83) ✅
7. **ScriptMgr Methods**: Properly declared in `ScriptMgr.h` and implemented in `ArenaTeamScript.cpp` ✅

The implementation follows the exact same pattern as other script types (ArenaScript, PlayerScript, etc.) and is fully integrated with AzerothCore's script system.

---

## Conclusion

**✅ The ArenaTeamScript hooks are fully aligned with Spec 34 requirements.**

The current implementation provides all necessary hooks for:
- Reward calculation at weekly reset (`OnGetArenaPoints`)
- Rating/MMR updates post-match (`OnAfterArenaRatingCalculation`)

**✅ The implementation correctly uses AzerothCore's script API.**

No additional ArenaTeamScript hooks are required to implement Spec 34's arena system.

