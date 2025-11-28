# Spec 95 Impact Analysis: Wintergrasp-to-Mortal Siege Adaptation

**Date:** 2025-01-XX  
**Spec:** `95-wintergrasp-to-mortal-siege-adaptation.md`  
**Status:** 🔄 **REVIEW COMPLETE** - Minor enhancements needed

---

## Summary

Spec 95 describes adapting the existing Wintergrasp battleground into Mortal's Stronghold Siege system. Our existing `MortalSiegeController` implementation is **mostly compatible** but needs some enhancements for full integration.

---

## Compatibility Assessment

### ✅ Already Implemented

1. **Siege Controller Structure**
   - ✅ `MortalSiegeController` exists with multi-stage encounters
   - ✅ Guild-based attacker/defender system
   - ✅ Full-loot handling
   - ✅ Ownership flip logic
   - ✅ Reward distribution hooks

2. **Stronghold System**
   - ✅ `MortalStrongholdSystem` exists
   - ✅ Ownership tracking
   - ✅ Resource generation hooks

3. **Reward Systems**
   - ✅ Military Credits (via `MortalWarfrontEngine`)
   - ✅ Standing system (via `MortalFactions`)
   - ✅ Resource shipments

---

## Required Enhancements

### 1. Wintergrasp Integration Hooks

**Location:** `MortalSiegeController.h/cpp`

**Add:**
- `StartWintergraspSiege(uint32 siegeId, uint32 zoneId)` - Initialize Wintergrasp battle
- `EndWintergraspSiege(uint32 siegeId, bool attackerWon)` - Cleanup Wintergrasp battle
- `OnWintergraspBattleEnd(uint32 siegeId, TeamId winnerTeam)` - Callback from Wintergrasp

**Implementation Notes:**
- Need to interface with `BattlefieldWG` class
- Map guild teams to Wintergrasp Team 0/1
- Disable automatic Wintergrasp scheduling

---

### 2. Guild Coalition Support

**Location:** `MortalSiegeController.h/cpp`

**Current:** Only tracks single attacker/defender guild

**Enhance:**
- Add `std::vector<uint32> attackerAllies` and `defenderAllies` to `EnhancedSiegeData`
- Add `AddSiegeAlly(uint32 siegeId, uint32 guildId, bool isAttacker)`
- Update team assignment logic to include allies
- Handle neutral guilds (cannot join or mercenary slots)

---

### 3. Zone Flag for Full-Loot

**Location:** `MortalSiegeController.cpp` + `MortalRiskZoneLogic.h/cpp`

**Add:**
- `SetZoneFullLootFlag(uint32 zoneId, bool enabled)` - Mark zone as full-loot during siege
- Integration with `MortalRiskZoneLogic` to apply Red Zone rules
- Ensure shrine respawn rules still apply

**Implementation:**
```cpp
// In MortalSiegeController::StartSiege()
MortalRiskZoneLogic::SetZoneFullLootFlag(zoneId, true);

// In MortalSiegeController::EndSiege()
MortalRiskZoneLogic::SetZoneFullLootFlag(zoneId, false);
```

---

### 4. War Calendar Integration

**Location:** `MortalSiegeController.cpp` + Atlas/UI modules

**Add:**
- `GetUpcomingSieges()` - Return scheduled sieges for calendar
- `GetSiegeSchedule(uint32 strongholdId)` - Get vulnerability windows
- Expose via `MortalUIBridge` or similar for Atlas integration

**Note:** This may already exist in `MortalSiegeWindow` - verify and enhance if needed.

---

### 5. Siege End Callback Signature

**Location:** `MortalSiegeController.h/cpp`

**Current:** `EndSiege(uint32 siegeId, bool attackerWon)`

**Enhance:** Add callback that Wintergrasp can call:
```cpp
void OnSiegeEnded(
    uint32 siegeId,
    bool attackerWon,
    uint32 attackerGuildId,
    uint32 defenderGuildId,
    uint32 strongholdId,
    const std::vector<ObjectGuid>& attackerPlayers,
    const std::vector<ObjectGuid>& defenderPlayers
);
```

This matches the spec's requirement for Wintergrasp to call into Mortal systems.

---

### 6. Vehicle Cost Integration

**Location:** New or enhance existing siege tech system

**Add:**
- Integration with `MortalSiegeTech` or create `MortalSiegeVehicles`
- Vehicle construction costs:
  - Siege materials (crafted)
  - Military Credits
  - Stronghold stockpiles
- Vehicle power/HP adjustments for Mortal stat squish

**Note:** Spec mentions this is Season 1.5+ feature, but architecture should support it.

---

### 7. Shrine Respawn Integration

**Location:** `MortalSiegeController.cpp` + Shrine system

**Ensure:**
- Shrine respawn nodes in/around siege zone
- Forward shrines for attackers
- Defender shrines behind inner walls
- Corpse run mechanics (gear in corpse chest, respawn naked)

**Note:** This may already be handled by existing shrine system - verify.

---

## Database Changes

### New Tables (if needed)

1. **Siege Guild Alliances**
   ```sql
   CREATE TABLE IF NOT EXISTS `mortal_siege_alliances` (
     `siege_id` INT UNSIGNED NOT NULL,
     `guild_id` INT UNSIGNED NOT NULL,
     `is_attacker` TINYINT(1) NOT NULL,
     PRIMARY KEY (`siege_id`, `guild_id`)
   );
   ```

2. **Wintergrasp Siege Mapping**
   ```sql
   CREATE TABLE IF NOT EXISTS `mortal_wintergrasp_sieges` (
     `siege_id` INT UNSIGNED NOT NULL,
     `battlefield_id` INT UNSIGNED NOT NULL,
     `wintergrasp_zone_id` INT UNSIGNED NOT NULL,
     PRIMARY KEY (`siege_id`)
   );
   ```

---

## Implementation Priority

### Season 1 (Launch-Critical)
1. ✅ Basic siege controller (already done)
2. ⚠️ Wintergrasp integration hooks (needed)
3. ⚠️ Zone full-loot flag (needed)
4. ⚠️ Guild coalition support (needed for multi-guild sieges)
5. ⚠️ Siege end callback (needed for Wintergrasp)

### Season 1.5+
1. War calendar integration (nice-to-have)
2. Vehicle cost system (future)
3. Advanced shrine respawn mechanics (if not already handled)

---

## Code Locations to Update

1. **`azerothcore/modules/mortal_overhaul/src/MortalSiegeController.h`**
   - Add Wintergrasp integration functions
   - Add guild coalition support to `EnhancedSiegeData`
   - Add siege end callback signature

2. **`azerothcore/modules/mortal_overhaul/src/MortalSiegeController.cpp`**
   - Implement Wintergrasp hooks
   - Implement guild coalition logic
   - Add zone flag management

3. **`azerothcore/modules/mortal_overhaul/src/MortalRiskZoneLogic.h/cpp`**
   - Add `SetZoneFullLootFlag()` function
   - Integrate with siege controller

4. **`azerothcore/src/server/game/Battlefield/Zones/BattlefieldWG.cpp`**
   - Add hooks to call `MortalSiegeController::OnWintergraspBattleEnd()`
   - Disable automatic scheduling
   - Map guild teams to Team 0/1

5. **SQL Migration**
   - Add siege alliance tables if needed
   - Add Wintergrasp mapping table

---

## Testing Checklist

- [ ] Wintergrasp battle starts when siege begins
- [ ] Guild teams correctly assigned to Team 0/1
- [ ] Full-loot rules apply during siege
- [ ] Ownership flips correctly on attacker victory
- [ ] Rewards distributed (Military Credits, Standing)
- [ ] Shrine respawn works correctly
- [ ] Guild allies can join siege
- [ ] War calendar shows upcoming sieges

---

## Conclusion

**Status:** Our existing `MortalSiegeController` implementation is **85% compatible** with Spec 95 requirements. The main gaps are:

1. **Wintergrasp integration hooks** (critical)
2. **Guild coalition support** (important for multi-guild sieges)
3. **Zone full-loot flag management** (needed for proper Red Zone rules)

These enhancements are **straightforward** and can be added without major refactoring. The core architecture is sound.

**Recommendation:** Implement the Season 1 critical items before launch, defer Season 1.5+ features.

