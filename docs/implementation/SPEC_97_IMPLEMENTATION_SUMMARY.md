# Spec 97: Guild Wars & Alliances - Implementation Summary

**Date:** 2025-01-XX  
**Status:** ✅ **IN PROGRESS** (~70% Complete)

---

## Completed Components

### 1. Database Schema ✅
- **File:** `sql/63_guild_relations.sql`
- **Tables:**
  - `mortal_guild_relations` - Unified table for all relationship types (Neutral, Alliance, War, Truce)
  - `mortal_guild_pacts` - Optional table for future special agreements
- **Migration:** Automatically migrates existing `guild_wars` and `guild_alliances` data

### 2. C++ Core Module ✅
- **Files:**
  - `azerothcore/modules/mortal_overhaul/src/MortalGuildPolitics.h`
  - `azerothcore/modules/mortal_overhaul/src/MortalGuildPolitics.cpp`
- **Features:**
  - `GetRelation()` - Get relation type between two guilds
  - `SetRelation()` - Set relation between guilds
  - `AreAllied()`, `AreAtWar()`, `AreInTruce()`, `AreNeutral()` - Convenience functions
  - `CanAttackWithoutNotoriety()` - Legal PvP check (no notoriety for war kills)
  - `CanSiegeStronghold()` - Siege eligibility check
  - `GetAlliedGuilds()`, `GetEnemyGuilds()` - Coalition support
  - `DeclareWar()`, `FormAlliance()`, `BreakAlliance()`, `ProposeTruce()` - High-level operations
  - Relation expiration handling
  - Cache system for performance

### 3. Siege Integration ✅
- **File:** `azerothcore/modules/mortal_overhaul/src/MortalSiegeController.cpp`
- **Changes:**
  - `StartSiege()` now validates war status before allowing siege
  - `CanGuildJoinSiege()` uses `MortalGuildPolitics` to check alliances
  - Automatically loads allied guilds for both sides when siege starts
  - Supports multi-guild coalitions

### 4. Combat/Notoriety Integration ✅
- **Files:**
  - `azerothcore/modules/mortal_overhaul/src/MortalCombatFlags.cpp`
  - `azerothcore/modules/mortal_overhaul/src/PvPHooks.cpp`
- **Changes:**
  - `CanAttack()` checks for legal war kills (no notoriety)
  - `RecordPvPKill()` skips notoriety gain for legal war kills
  - War kills are legal PvP anywhere (no criminal flag)

---

## Remaining Components

### 5. NPC Scripts ⚠️ IN PROGRESS
- **File:** `azerothcore/modules/mortal_overhaul/src/npc_guild_steward.cpp` (to be created)
- **Features:**
  - Guild Steward NPC in capital cities
  - Declare War interface
  - Form Alliance interface
  - View Relations interface
  - Propose Truce interface
  - Costs and validation

### 6. MortalUI Integration ⚠️ PENDING
- **File:** `addons/MortalUI/MortalUI_PoliticsPanel.lua` (to be created)
- **Features:**
  - Politics Panel showing:
    - Active wars
    - Alliances
    - Truces (with timers)
    - Status tags (Ally, At War, Neutral)
  - Integration with AIO for server data

### 7. Atlas Web Portal ⚠️ PENDING
- **Files:**
  - `webportal/backend/internal/api/handlers/guild_politics.go` (to be created)
  - `webportal/frontend/src/pages/GuildPolitics.tsx` (to be created)
- **Features:**
  - "Guild Politics" page
  - Public information:
    - Which guilds are at war
    - Which guilds are allied
    - Which Strongholds they control
  - Intel protection (approximate numbers)

---

## Integration Points

### With Existing Systems:
1. ✅ **MortalSiegeController** - Coalition support, siege eligibility
2. ✅ **MortalCombatFlags** - Legal PvP checks
3. ✅ **PvPHooks** - Notoriety system integration
4. ⚠️ **MortalUI** - Politics panel (pending)
5. ⚠️ **Atlas** - Web portal display (pending)
6. ⚠️ **NPC Scripts** - Guild Steward (in progress)

---

## Testing Checklist

- [ ] Test relation storage (symmetric key handling)
- [ ] Test war declaration (costs, validation)
- [ ] Test alliance formation
- [ ] Test truce proposal/acceptance
- [ ] Test relation expiration
- [ ] Test siege eligibility (war requirement)
- [ ] Test coalition building (allied guilds)
- [ ] Test legal PvP (no notoriety for war kills)
- [ ] Test NPC scripts (Guild Steward)
- [ ] Test UI display (MortalUI)
- [ ] Test Atlas display

---

## Next Steps

1. Complete NPC scripts (Guild Steward)
2. Implement MortalUI Politics Panel
3. Implement Atlas Guild Politics page
4. Add GM tools for relation management
5. Testing and refinement

---

## Notes

- The system uses symmetric storage (always `guild_id_a < guild_id_b`)
- Relations are cached for performance
- Expired relations are automatically cleaned up
- War kills are legal PvP anywhere (no notoriety)
- Alliances enable coalition sieges
- Truces prevent new wars/sieges during active period

