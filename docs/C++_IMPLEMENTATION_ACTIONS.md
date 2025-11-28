# Implementation Action Items - C++ Module Gaps

**Generated**: November 24, 2025  
**Priority Ranking**: Based on performance impact and implementation complexity

---

## TIER 1: Critical Infrastructure (Do First - Enable Other Systems)

### 1.1 Criminal Flag Setter/Getter
**Impact**: Blocks criminal flag system entirely  
**Effort**: 2 hours  
**Dependencies**: None

**What's Missing**:
```cpp
// In MortalOverhaul.h, add:
bool IsCriminalFlagged(Player* player, uint32 zoneId = 0);
uint32 GetCriminalFlagExpiry(Player* player);
void SetCriminalFlag(Player* player, uint32 durationSeconds);
void ClearCriminalFlag(Player* player);
```

**Implementation Points**:
1. Query `character_criminal_flags` table
2. Check `criminal_until` against current time
3. Return true if `criminal_until > time(nullptr)`
4. Update flag via prepared statement
5. Add zone lookup for duration via `GetZoneRiskConfig()`

**Hook Location**: `PlayerScript_MortalPvP::OnPlayerAttack()` (doesn't exist yet)

---

### 1.2 Criminal Flag Expiry Cleanup
**Impact**: Prevents stale data, unblocks criminal players  
**Effort**: 3 hours  
**Dependencies**: 1.1

**What's Missing**:
```cpp
// Add to ScriptMgr.cpp
class WorldScript_CriminalFlagCleanup : public WorldScript
{
    // Run every 60 seconds
    // DELETE FROM character_criminal_flags WHERE criminal_until < UNIX_TIMESTAMP();
};
```

**Implementation Points**:
1. Create WorldScript with update timer
2. Every 60 seconds, clean expired flags
3. Log number of cleaned flags
4. Optional: Notify players when flag expires (broadcast message)

**Database Query**:
```sql
DELETE FROM character_criminal_flags 
WHERE criminal_until < UNIX_TIMESTAMP() 
LIMIT 1000;  -- Batch deletes
```

---

## TIER 2: Core System Logic (Enable Gameplay)

### 2.1 Notoriety Decay Timer
**Impact**: Bounty system becomes non-trivial (kills decay over time)  
**Effort**: 4 hours  
**Dependencies**: None (but complements 1.1)

**What's Missing**:
```cpp
// In MortalOverhaul.h, add:
void DecayNotoriety(Player* player, uint32 diffMs);
uint32 GetNotorietyDecayRate(uint32 zoneId); // Returns notoriety/hour
void ApplyNotorietyDecayForAllPlayers(); // Called by WorldScript
```

**Implementation Points**:
1. Create notoriety decay formula (per spec: Red zones = slower decay, Green = faster)
2. WorldScript timer: every 10 minutes, call `ApplyNotorietyDecayForAllPlayers()`
3. Load all players with notoriety > 0
4. Apply zone-based decay multiplier
5. Update database
6. Cache results to avoid repeated loads

**Decay Formula** (suggested):
```
Zone Type | Base Rate | Formula
Green     | 10/hour   | notoriety -= (time_diff_hours * 10)
Yellow    | 5/hour    | notoriety -= (time_diff_hours * 5)
Red       | 1/hour    | notoriety -= (time_diff_hours * 1)
```

**Database Indices**: Already exist (`idx_notoriety` on `character_notoriety`)

---

### 2.2 Bounty Token Award System
**Impact**: Unblocks bounty hunting gameplay  
**Effort**: 3 hours  
**Dependencies**: 2.1 (for notoriety tracking)

**What's Missing**:
```cpp
// Add to MortalOverhaul.h/cpp or create MortalBounty.h/cpp
void OnPlayerKilledByBounty(Player* killer, Player* target);
void AwardBountyTokens(Player* killer, uint32 tokenCount);
uint32 CalculateBountyTokenReward(Player* target); // Based on target's notoriety
```

**Implementation Points**:
1. Hook into `PlayerScript_MortalPvP::OnPlayerPVPKill()`
2. Check if killed player has notoriety > 0
3. Calculate token reward based on target's notoriety level
4. Award tokens to killer
5. Log transaction to `mortal_bounty_token_log` (new table)

**New Table Required**:
```sql
CREATE TABLE mortal_bounty_token_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    killer_guid INT,
    victim_guid INT,
    tokens_awarded INT,
    victim_notoriety INT,
    kill_time TIMESTAMP,
    INDEX (killer_guid),
    INDEX (victim_guid),
    INDEX (kill_time)
);
```

---

### 2.3 Buy Order Generation (Scheduled)
**Impact**: Economy becomes dynamic (NPCs request materials on schedule)  
**Effort**: 6 hours  
**Dependencies**: None

**What's Missing**:
```cpp
// In MortalBuyOrders.h, add real implementation to:
void GenerateBuyOrders(uint32 npcEntry, const std::string& regionCode);

// Implementation should:
// 1. Load NPC properties (region, tier)
// 2. Select 3-5 random materials from region's crafting materials
// 3. Set realistic quantities (100-1000 units)
// 4. Set expiry (8 hours)
// 5. Insert into database
```

**Implementation Points**:
1. Load all quest givers/NPCs with buy order capability
2. Per NPC: Pick 3-5 materials from region material pool
3. Set quantity based on NPC tier (T1 = 100-300, T5 = 500-1000)
4. Set price at 1.2x-1.8x vendor price (with hot zone multiplier)
5. Expire old orders (>8 hours old)
6. Insert new orders

**WorldScript Timer**:
```cpp
// Every 8 hours (28800 seconds), regenerate orders
void RegenerateAllBuyOrders() {
    QueryResult npcs = WorldDatabase.Query(
        "SELECT entry FROM creature_template WHERE npcflag & 0x200" // UNIT_NPC_FLAG_VENDOR
    );
    for (auto const& npc : npcs) {
        MortalBuyOrders::GenerateBuyOrders(npc->GetEntry(), GetNPCRegion(npc->GetEntry()));
    }
}
```

**Database Changes**:
- Add `npc_template.buy_order_region` (VARCHAR 32) for region code
- Add `mortal_buy_orders.last_regenerated_time` to track freshness

---

## TIER 3: Completion of Started Systems

### 3.1 Public Group Creation
**Impact**: Groups actually form (not just listed)  
**Effort**: 4 hours  
**Dependencies**: None (but needs AzerothCore Group API knowledge)

**What's Missing**:
- `MortalPublicGrouping::StartPublicGroup()` doesn't call `Group::Create()`
- No membership assignment
- No group chat setup

**Implementation Points**:
1. In `StartPublicGroup()`, after approval:
   ```cpp
   Group* group = new Group();
   if (group->Create(leader))  // Actual Group creation
   {
       // Add accepted applicants
       for (auto appId : acceptedApplicants) {
           Player* member = ObjectAccessor::GetPlayerByGUID(sWorld, appGuid);
           group->AddMember(member);
       }
       // Update database request status
       UPDATE mortal_public_group_requests SET status = 2 WHERE id = requestId;
   }
   ```

2. Hook into `OnGroupCreate()` to record group source
3. Clear request when group disbands

---

### 3.2 Caravan Vehicle Integration
**Impact**: Caravans become actual entities (not just quests)  
**Effort**: 8 hours  
**Dependencies**: AzerothCore Vehicle system knowledge

**What's Missing**:
- Physics calculations exist but not applied to movement
- No cargo system
- No vehicle entity

**Implementation Points**:
1. Create `MortalCaravan` class extending `Creature`
2. In `UpdateSpeed()`, apply `CalculateCaravanSpeed()`:
   ```cpp
   float baseSpeed = 2.0f;  // from wagon stats
   float cargoPenalty = CalculateCargoPenalty(cargoWeight, cargoCapacity);
   float terrainMod = GetTerrainModifier(currentTerrain);
   float roadBonus = GetRoadBonus(isOnRoad);
   float healthMod = CalculateHealthModifier(wagonHealthPercent);
   
   float finalSpeed = baseSpeed * cargoPenalty * terrainMod * roadBonus * healthMod;
   SetSpeed(MOVE_RUN, finalSpeed);
   ```

3. Implement cargo system:
   ```cpp
   // In MortalCaravan
   std::vector<Item*> _cargoItems;
   float _currentCargoWeight;
   float _maxCargoCapacity;
   
   bool AddCargo(Item* item);
   bool RemoveCargo(Item* item);
   ```

4. Hook death/completion:
   - On death: drop cargo
   - On complete: award contract gold

---

### 3.3 Healing Zone Restrictions (if intended)
**Impact**: Combat zones become healing-denied (adds difficulty)  
**Effort**: 5 hours  
**Dependencies**: None (but verify design intention first)

**What's Missing**:
- No zone healing config
- No spell hook to prevent healing

**Implementation IF NEEDED**:
1. Create `zone_healing_config` table:
   ```sql
   CREATE TABLE zone_healing_config (
       zone_id INT PRIMARY KEY,
       allow_healing BOOLEAN DEFAULT TRUE,
       allow_self_only BOOLEAN DEFAULT FALSE,  -- Only self-healing
       notes VARCHAR(255)
   );
   ```

2. Create SpellScript hook:
   ```cpp
   class SpellScript_HealingZoneRestriction : public SpellScript
   {
       void Validate(SpellInfo const* /*spellInfo*/) override {
           // Check if healing spell
           if (!IsHealingSpell()) return;
       }
       
       SpellCastResult CheckCast() override {
           Player* caster = GetCaster()->ToPlayer();
           if (!caster) return SPELL_CAST_OK;
           
           // Check zone restriction
           auto config = MortalOverhaul->GetHealingZoneConfig(caster->GetZoneId());
           if (!config || !config->allow_healing) {
               return SPELL_FAILED_CUSTOM_ERROR;  // "Healing is not permitted here"
           }
           return SPELL_CAST_OK;
       }
   };
   ```

3. Register for all healing spells (class-specific healing, priest heals, paladin blessings, etc.)

---

## TIER 4: Polish & Optimization

### 4.1 Build Preset Location Validation
**Impact**: Prevents preset switching in combat  
**Effort**: 1 hour  
**Dependencies**: None

**What's Missing**:
- `CanApplyPreset()` is stubbed, missing location check

**Implementation**:
```cpp
bool MortalBuildPresets::CanApplyPreset(Player* player)
{
    if (!player || player->IsInCombat())
        return false;
    
    // Add location check
    uint32 zoneId = player->GetZoneId();
    QueryResult result = WorldDatabase.Query(
        "SELECT 1 FROM zone_pvp_config WHERE zone_id = {} AND pvp_type = 0",  // Green zones only
        zoneId
    );
    
    return result != nullptr;
}
```

**Database**: Uses existing `zone_pvp_config` table

---

### 4.2 Blessed Item Binding Enforcement
**Impact**: Blessed items can't be traded/stolen  
**Effort**: 2 hours  
**Dependencies**: None

**What's Missing**:
- Items can be blessed but are still tradeable
- Need to mark blessed items as soulbound

**Implementation**:
```cpp
bool MortalBlessedItems::BlessItem(Player* player, Item* item)
{
    // ... existing blessing code ...
    
    // Bind item to player
    item->SetBinding(true);  // Soulbound
    item->SetUInt64Value(ITEM_FIELD_OWNER, player->GetGUID().GetRawValue());
    item->SaveToDB();
    
    return true;
}
```

---

### 4.3 Buy Order NPC Gossip Integration
**Impact**: Players can see buy orders via NPC dialog  
**Effort**: 3 hours  
**Dependencies**: 2.3 (buy order generation)

**What's Missing**:
- NPCs don't show buy orders in gossip menu
- No gossip script for buy order NPCs

**Implementation**:
```cpp
class CreatureScript_BuyOrderNPC : public CreatureScript
{
public:
    CreatureScript_BuyOrderNPC() : CreatureScript("npc_buy_order_vendor") { }
    
    bool OnGossipHello(Player* player, Creature* creature) override {
        std::vector<MortalBuyOrders::BuyOrder> orders = 
            MortalBuyOrders::GetBuyOrders(creature->GetEntry());
        
        for (auto const& order : orders) {
            // Build gossip menu with item name, quantity, price
        }
        
        player->SendGossipMenu(9999, creature->GetGUID());
        return true;
    }
};
```

---

## TIER 5: Advanced Features (Lower Priority)

### 5.1 Dynamic Ecosystem Spawn Scheduler
**Impact**: World feels alive (spawns react to activity)  
**Effort**: 16+ hours  
**Dependencies**: Deep AzerothCore Map/Grid knowledge

**What's Missing**:
- No spawn scheduler
- No area-based creature clustering
- No respawn throttling based on population

**High-Level Approach**:
1. Create `EcosystemManager` class
2. Track player activity per area (grid-based)
3. Per update tick (~100ms):
   - Count players in area
   - Calculate desired spawn count
   - Compare to actual spawns
   - Throttle respawns up/down
4. Handle predator/prey relationships (simple: herbivores flee combat areas)

**Database**:
```sql
CREATE TABLE ecosystem_spawning (
    spawn_group_id INT,
    map_id INT,
    zone_id INT,
    spawn_weight INT,
    min_players INT,
    max_players INT,
    base_respawn_seconds INT,
    dynamic_rate FLOAT  -- 1.0 = normal, 0.5 = half speed, 2.0 = double speed
);
```

**Performance Concerns**:
- Querying all players in area per spawn
- Should use grid-based locality
- Cache results for 30 seconds

---

## Implementation Priority Matrix

| Task | Effort | Impact | Dependencies | Go? |
|------|--------|--------|--------------|-----|
| 1.1 Criminal Flag Setter | 2h | HIGH | None | ✅ YES |
| 1.2 Criminal Flag Cleanup | 3h | HIGH | 1.1 | ✅ YES |
| 2.1 Notoriety Decay | 4h | HIGH | None | ✅ YES |
| 2.2 Bounty Tokens | 3h | MEDIUM | 2.1 | ✅ YES |
| 2.3 Buy Order Generation | 6h | MEDIUM | None | ✅ YES |
| 3.1 Public Group Creation | 4h | MEDIUM | None | ✅ YES |
| 3.2 Caravan Vehicle | 8h | MEDIUM | None | ⚠️ OPTIONAL |
| 3.3 Healing Zones | 5h | LOW | None | ❌ VERIFY DESIGN |
| 4.1 Build Preset Validation | 1h | LOW | None | ✅ YES |
| 4.2 Blessed Item Binding | 2h | LOW | None | ✅ YES |
| 4.3 Buy Order Gossip | 3h | LOW | 2.3 | ✅ YES |
| 5.1 Spawn Scheduler | 16h | LOW | None | ❌ LOW PRIORITY |

**Recommended First Sprint**: 1.1 + 1.2 + 2.1 + 4.1 = ~10 hours = 1 day for core criminal/bounty system

**Recommended Second Sprint**: 2.2 + 2.3 + 3.1 + 4.2 + 4.3 = ~18 hours = 2-3 days for economy/grouping

---

## Testing Checklist

After each implementation, verify:

### Criminal Flags (1.1, 1.2)
- [ ] Attack criminal player in yellow zone → gets flag
- [ ] Flag expires after 15 minutes
- [ ] Criminal player shows icon to others
- [ ] Cleanup removes expired flags

### Notoriety (2.1, 2.2)
- [ ] PvP kill increments notoriety
- [ ] Notoriety decays over time
- [ ] Bounty tokens awarded correctly
- [ ] Decay rate matches zone type

### Buy Orders (2.3, 4.3)
- [ ] Orders generate every 8 hours
- [ ] NPC shows active orders in gossip
- [ ] Player can fulfill orders
- [ ] Old orders expire

### Build Presets (4.1)
- [ ] Can apply preset in Green zone
- [ ] Cannot apply preset in Red zone
- [ ] Cannot apply preset in combat

---

## Code Review Locations

After implementation, ensure:
1. All new code has proper error checking
2. Database queries use prepared statements
3. Performance: No N+1 queries, cache aggressively
4. Logging: Errors logged, major actions telemetry'd
5. Thread safety: No race conditions on shared data

**Key Files to Modify**:
- `/src/MortalOverhaul.h` and `/src/MortalOverhaul.cpp`
- `/src/MortalBuyOrders.h` and `/src/MortalBuyOrders.cpp`
- `/src/MortalBountySystem.h` (new file) and `.cpp`
- `/src/ScriptMgr.cpp` (WorldScript timers, PlayerScript hooks)
- `azerothcore/src/server/database/Database/Implementation/CharacterDatabase.h` (prepared statements)

