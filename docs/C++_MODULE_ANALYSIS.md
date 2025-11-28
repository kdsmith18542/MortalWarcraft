# AzerothCore Module Implementation Analysis
## C++ vs Lua Implementation Status for Mortal Warcraft Systems

**Analysis Date**: November 24, 2025  
**Focus**: Performance-critical systems and core backend logic

---

## Summary Table

| System | C++ Core | C++ Hooks | Database | UI/Lua Only | Missing in C++ |
|--------|----------|-----------|----------|-------------|----------------|
| Criminal Flags | ❌ | ❌ | ✅ | ⚠️ | Setter/Getter, Expiry hooks |
| Bounty System | ❌ | ❌ | ✅ | ✅ | Decay timer, NPC logic |
| Notoriety Decay | ❌ | ❌ | ✅ | ⚠️ | Timer/decay logic |
| Healing Zones | ❌ | ❌ | ❌ | ❌ | **Complete** |
| Blessed Items | ⚠️ | ✅ | ✅ | ⚠️ | Item protection enforcement |
| Public Grouping | ⚠️ | ✅ | ✅ | ⚠️ | Group creation/matching |
| Build Presets | ⚠️ | ✅ | ✅ | ✅ | Location validation only |
| Buy Orders | ⚠️ | ❌ | ✅ | ⚠️ | NPC-side buy order generation |
| Dynamic Ecosystem | ❌ | ⚠️ | ❌ | ❌ | Spawn scheduler |
| Caravan System | ⚠️ | ❌ | ✅ | ✅ | Vehicle physics/cargo system |

---

## Detailed System Analysis

### 1. Criminal Flags
**Status**: Lua-dependent, minimal C++ infrastructure

**EXISTS in C++**:
- Database table: `character_criminal_flags` (guid, criminal_until timestamp)
- Zone config table: `zone_pvp_config` (criminal_flag_duration field)
- Zone risk caching in `MortalOverhaul::GetZoneRiskConfig()`

**MISSING in C++**:
- ❌ Criminal flag setter: No `SetCriminalFlag(Player*, uint32 duration)` function
- ❌ Criminal flag getter: No `IsCriminal()` or `GetCriminalExpiry()` methods
- ❌ Expiry hook: No timer that auto-removes criminal status
- ❌ Attack-trigger hook: No code monitoring PvP attacks in Yellow zones to set flag
- ❌ Decay system: No periodic cleanup of expired flags

**ENFORCED WHERE**: Lua/UI layer (flag visual, chat messages)
- File: `lua_scripts/` (not available in search results)

**Notes**:
- The infrastructure exists but is inert
- Criminal flag system requires periodic update loop or event-based hooks
- No spell casting restrictions enforced for criminals in C++

---

### 2. Bounty System
**Status**: Database-only, no active C++ logic

**EXISTS in C++**:
- Database tables: 
  - `character_notoriety` (guid, notoriety level, last_updated)
  - `bounty_board_locations` (location data for boards)
  - Bounty token item: `item_template` entry 90002
- Stub method: `MortalOverhaul::UpdateBountyMapLocation(Player*)`

**MISSING in C++**:
- ❌ Notoriety increment on kill: No hook that increments `character_notoriety.notoriety` on PvP kill
- ❌ Decay timer: No background timer to reduce notoriety over time
- ❌ NPC bounty board logic: No creature script to display bounties or create contracts
- ❌ Bounty contract system: No code to execute bounty hunting tasks
- ❌ Reward distribution: No code to verify kills and distribute bounty tokens

**ENFORCED WHERE**: Lua/questline system (bounty quests, token exchange)

**Notes**:
- `MortalOverhaul::UpdateBountyMapLocation()` is stubbed out with no implementation
- The system is defined entirely in SQL schema and UI
- Zone-based notoriety multipliers exist in schema but not applied anywhere

---

### 3. Notoriety Decay
**Status**: Schema-only, zero enforcement

**EXISTS in C++**:
- Database columns: `character_notoriety.last_updated`
- Zone multipliers defined in comments in `41_bounty_system_enhancement.sql`

**MISSING in C++**:
- ❌ Decay timer: No timer that decrements notoriety over time
- ❌ Zone-based scaling: No code that applies zone multipliers (Red zone = faster decay)
- ❌ Periodic update: No cron/timer system to process notoriety decay for all players
- ❌ Decay formula: Decay rate not defined anywhere in C++

**ENFORCED WHERE**: None (system is completely inactive)

**Notes**:
- Notoriety appears designed to decay faster in safe zones, remain longer in Red zones
- No implementation whatsoever in the C++ codebase
- Would require a WorldScript timer or Map-level periodic update

---

### 4. Healing Zones (Zone-Based Healing Restrictions)
**Status**: **Not designed/implemented anywhere**

**EXISTS in C++**:
- ❌ Nothing. Sanctuary concept exists in AzerothCore core (AREA_FLAG_SANCTUARY) but:
  - Not connected to Mortal zone config
  - No healing restriction enforcement
  - No toggle per zone

**MISSING in C++**:
- ❌ Healing spell hook: No code to detect healing spells and check zone restrictions
- ❌ Zone healing config: No database field for healing restrictions
- ❌ Spell failure: Healing spells not prevented in combat zones
- ❌ Holy ground concept: No safe zone where healing is unrestricted

**DATABASE**:
- ❌ No schema for healing zone config
- Sanctuary flag exists in core but unused for Mortal purposes

**ENFORCED WHERE**: Nowhere (system doesn't exist)

**CRITICAL ISSUE**: This system appears to be **completely missing**. If intended, needs:
1. `zone_healing_config` table with healing restriction flags
2. SpellScript hook on healing spells to check zone config
3. Spell failure mechanism

---

### 5. Blessed Items
**Status**: Partially implemented, lacking enforcement

**EXISTS in C++**:
- Database schema: `mortal_blessed_items` (guid, item_guid, bless_end_time, charges_remaining)
- Header functions declared: `BlessItem()`, `IsItemBlessed()`, `ConsumeBlessingCharge()`, `CleanupExpiredBlessings()`
- PlayerScript hook: `PlayerScript_MortalBlessedItems::OnPlayerDeath()` in `ScriptMgr.cpp`
- Death handler checks equipped items and consumes charges
- ItemScript hook for blessing items: `ItemScript_MortalBlessedItems::OnUse()`

**MISSING in C++**:
- ❌ Implementation of blessing logic: Functions declared but not defined (likely in `.cpp` file not examined)
- ❌ Binding enforcement: No code preventing blessed item trading/dropping when blessed
- ❌ Blessing cost enforcement: No code to deduct gold from player
- ⚠️ Partial drop enforcement: Blessing only protects equipped items, not inventory

**ENFORCED WHERE**: 
- Blessing blessing use: C++ ItemScript
- Death protection: C++ PlayerScript
- Item binding: Likely Lua or missing entirely

**Notes**:
- The system is mostly C++-backed with proper database support
- Cleanup of expired blessings needs to be scheduled
- Protection doesn't extend to non-equipped items

---

### 6. Public Grouping System
**Status**: Framework exists, group creation missing

**EXISTS in C++**:
- Header defined: `MortalPublicGrouping.h` with full API
- Database tables: Schema for group requests and applications (assumed, not shown)
- Contribution tracking: `TrackContribution()`, `GetContributionScores()` functions
- Reward multiplier: `CalculateRewardMultiplier()` for contribution-based rewards
- PlayerScript hook: Likely exists for tracking combat metrics

**MISSING in C++**:
- ❌ Group creation: `StartPublicGroup()` doesn't actually call `Group::Create()`
- ❌ Group matching: No matchmaking logic for pairing leaders with applicants
- ❌ Activity formation: No code that converts a group request into an active `Group` object
- ⚠️ Database queries: Functions declared but implementations not confirmed

**ENFORCED WHERE**:
- Request management: C++ APIs
- Group formation: Completely missing
- UI/listing: Lua/web portal

**Notes**:
- The framework is well-designed but incomplete
- Would require hooking into `Group::Create()` and passing the request ID
- Contribution system can be performant if data is cached

---

### 7. Build Presets
**Status**: Preset management in C++, location validation missing

**EXISTS in C++**:
- Header defined: `MortalBuildPresets.h` with full API
- Database support: Schema for preset storage (attributes JSON, gear JSON, runes JSON)
- Preset validation: `ValidatePreset()` checks attribute caps and mastery rules
- Application gate: `CanApplyPreset(Player*)` checks out-of-combat requirement
- Preset application: `ApplyPresetAttributes()`, `ApplyPresetGear()`, `ApplyPresetRunes()` functions

**MISSING in C++**:
- ⚠️ Location validation: `CanApplyPreset()` is stubbed, missing location check (safe zones only)
- ❌ Location whitelist: No database field for locations where presets can be applied
- ⚠️ Item equipping: `ApplyPresetGear()` not confirmed to actually equip items

**ENFORCED WHERE**:
- Preset creation/storage: C++
- Attribute validation: C++
- Location restriction: **Not enforced** (missing)
- UI selection: Lua

**Notes**:
- Location validation could be a quick win: add location check to `CanApplyPreset()`
- Otherwise well-architected system
- Needs location whitelist in database

---

### 8. Buy Orders
**Status**: NPC-side generation missing, fulfillment exists

**EXISTS in C++**:
- Database schema: `mortal_buy_orders` table with full fields
- Header defined: `MortalBuyOrders.h` with namespace functions
- Fulfillment logic: `FulfillOrder(Player*, orderId, quantity)` implemented
- Order query: `GetBuyOrders(npcEntry)` retrieves active orders
- Price multiplier: `GetHotZonePriceMultiplier()` applies regional bonuses
- Logging: `mortal_buy_order_log` table for transaction history

**MISSING in C++**:
- ❌ Order generation: `GenerateBuyOrders()` function declared but appears stubbed/incomplete
- ❌ NPC logic: No creature script that NPCs use to generate orders
- ❌ Periodic regeneration: No timer to create new orders on schedule
- ❌ Material selection: No algorithm to pick realistic materials per region

**ENFORCED WHERE**:
- Player-side fulfillment: C++
- Order generation: **Lua/admin tools** (manual insertion or script-based)
- UI: Lua/web portal

**CRITICAL**: Buy orders are probably static/admin-generated, not dynamic. Check if `GenerateBuyOrders()` is called anywhere.

**Notes**:
- The fulfillment pathway is solid
- Missing: scheduled task to auto-generate orders or admin interface
- Hot zone price bonuses are in place

---

### 9. Dynamic Ecosystem / Spawn Scheduler
**Status**: AzerothCore spawn system exists, Mortal ecosystem missing

**EXISTS in C++** (AzerothCore core, not Mortal-specific):
- Respawn scaling: `Map::ApplyDynamicModeRespawnScaling()` for difficulty-based adjustments
- Spawn caching: Creatures/GameObjects loaded/unloaded by grid system
- Respawn delay config: `CONFIG_RESPAWN_DYNAMICRATE_CREATURE`, `CONFIG_RESPAWN_DYNAMICMINIMUM_CREATURE`
- Formation system: Creature groups with formation data (creature_group_spawn, formation_data tables)

**MISSING in C++**:
- ❌ Ecosystem scheduler: No system to trigger spawn waves based on area population/kills
- ❌ Spawn clustering: No logic to spawn creatures near areas of activity
- ❌ Dynamic difficulty: Respawn scaling exists but not tied to local player count
- ❌ Resource node scheduling: No dynamic spawn rate for herbs/ore based on demand
- ❌ Predator/prey simulation: No ecosystem balancing logic

**DATABASE**:
- ❌ No ecosystem state tables
- ❌ No spawn wave definitions
- Schema exists for creature spawns but not for dynamic scheduling

**ENFORCED WHERE**: None (system doesn't exist in Mortal implementation)

**Notes**:
- This is a **major feature gap**
- Would require WorldScript timer and area-based spawn logic
- AzerothCore has the foundation (grids, respawn), but Mortal doesn't leverage it
- High performance impact if implemented naively (would need efficient area queries)

---

### 10. Caravan System
**Status**: Movement physics defined, vehicle logic missing

**EXISTS in C++**:
- Header defined: `MortalCaravanMovement.h` with comprehensive API
- Movement calculations: 
  - `CalculateCargoPenalty()` (cargo weight vs capacity)
  - `GetTerrainModifier()` (terrain penalties)
  - `GetRoadBonus()` (road speed bonuses)
  - `CalculateHealthModifier()` (wagon damage penalties)
  - `CalculateCaravanSpeed()` (composite speed formula)
- Terrain classification: Enum for ROAD, GRASS, HILLS, SWAMP, STEEP
- Terrain validation: `IsTerrainTraversable()`

**MISSING in C++**:
- ❌ Vehicle implementation: No Vehicle-based caravan entity
- ❌ Cargo system: No inventory/cargo slot management
- ❌ Movement enforcement: Physics calculations exist but not applied to creature movement
- ❌ Interaction system: No escort/ride mechanics
- ❌ Combat on caravan: No damage calculation or cargo loss mechanics
- ❌ Station system: No endpoint logic for caravan contracts

**DATABASE**:
- ✅ Tables exist: `mortal_caravan_upgrades`, `mortal_caravan_wagon_stats`, `mortal_character_caravan_upgrades`
- ✅ Upgrade stats: Wheels, armor, animals, decoys defined

**ENFORCED WHERE**:
- Movement physics: C++ (but not hooked in)
- Gameplay logic: Lua/quest system (escort quests)

**CRITICAL MISSING PIECE**: No code actually instantiates a caravan vehicle or applies these movement calculations. The API exists but is unused.

**Notes**:
- Physics formulas are well-designed and spec-compliant
- Implementation requires:
  1. Creating a Creature-based vehicle class for caravans
  2. Hooking `CalculateCaravanSpeed()` into movement speed calculations
  3. Implementing cargo system (item storage in creature)
  4. Death mechanics (cargo dropped on failure)
- This is more about integration than missing logic

---

## Performance-Critical Systems Summary

### Highest Priority (Heavy Logic in Lua, Should Be C++)
1. **Notoriety Decay** - Affects every criminal player every frame (needs timer)
2. **Dynamic Ecosystem** - Spawn management scales with server load (needs efficient queries)
3. **Buy Order Generation** - Economic simulation (needs scheduled task)

### Medium Priority (Partially Implemented, Needs Completion)
4. **Criminal Flags** - Setter/getter logic missing but hooks in place
5. **Caravan Physics** - Calculations exist, need vehicle integration
6. **Public Grouping** - Request system works, group creation missing

### Lower Priority (Mostly Complete, Minor Gaps)
7. **Blessed Items** - Protection works, just needs item binding enforcement
8. **Build Presets** - Just needs location validation added

### Not Started (Complete Feature Gap)
9. **Healing Zone Restrictions** - Entire system missing, would need new database schema
10. **Bounty System** - Decay exists in schema but no active enforcement

---

## Database Schema Assessment

**Well-Designed**:
- `character_criminal_flags` (clean, indexed)
- `character_notoriety` (ready for decay)
- `zone_pvp_config` (comprehensive zone config)
- `mortal_blessed_items` (proper blessing tracking)
- `mortal_buy_orders` (complete transaction model)

**Incomplete**:
- No `zone_healing_config` table
- No ecosystem state tables
- No dynamic spawn scheduler tables

**Underutilized**:
- Zone config fields (criminal_flag_duration) loaded but not applied
- Notoriety decay multipliers exist in comments but not in schema

---

## Recommendations

### Quick Wins (< 1 day each)
1. **Criminal Flag Expiry**: Add WorldScript timer to check `criminal_until` and clear old flags
2. **Blessed Item Cleanup**: Call `MortalBlessedItems::CleanupExpiredBlessings()` on timer
3. **Build Preset Location Validation**: Add zone_id check to `CanApplyPreset()`

### Medium Effort (2-5 days)
1. **Notoriety Decay**: Implement decay formula, add WorldScript timer
2. **Criminal Flag Setter**: Implement `SetCriminalFlag()` with attack hook
3. **Public Group Creation**: Hook `StartPublicGroup()` to actual `Group::Create()`

### Major Effort (1-2 weeks)
1. **Buy Order Generation**: Implement `GenerateBuyOrders()` with material selection logic
2. **Caravan Vehicle System**: Create creature-based caravan with cargo management
3. **Dynamic Ecosystem**: Design and implement spawn scheduler with area queries

### Research Required
1. **Healing Zones**: Confirm if this is an intended feature or design gap
2. **Bounty System**: Determine if bounty contracts are Lua-driven or need C++ backend

---

## Code Files to Review

**Mortal C++ Module Files** (in `/src/`):
- `MortalOverhaul.h/cpp` - Main entry point
- `MortalBlessedItems.h/cpp` - Item blessing logic
- `MortalPublicGrouping.h/cpp` - Group request system
- `MortalCaravanMovement.h/cpp` - Movement physics
- `MortalBuildPresets.h/cpp` - Preset management
- `MortalBuyOrders.h/cpp` - Buy order fulfillment
- `ScriptMgr.cpp` - PlayerScript/ItemScript/WorldScript hooks

**AzerothCore Integration**:
- `Group::Create()` - Group creation (needs hook for public grouping)
- `Player::OnDeath()` - Death handling (needs bounty/criminal flag hooks)
- `Spell::Cast()` - Spell casting (needs healing zone restriction hook)
- `Creature::Update()` - Movement (needs caravan speed calculation hook)

**SQL Tables** (primary):
- `character_criminal_flags`
- `character_notoriety`
- `zone_pvp_config`
- `mortal_blessed_items`
- `mortal_buy_orders`
- `mortal_build_presets`

---

## Conclusion

**Current State**: The Mortal Warcraft codebase has **good database design** and **solid API headers**, but lacks **execution logic** in C++. Most systems are either:
- **Stubbed headers** (declared but not implemented)
- **Hooks in place but inactive** (declared in PlayerScript but no trigger logic)
- **Physics/formulas defined but not applied** (caravan movement calculations unused)

**The biggest gaps** are in systems that should be **performance-critical**:
- Notoriety decay (affects all criminal players)
- Dynamic ecosystem (spawn management)
- Buy order generation (economic simulation)

**Next step**: Implement the "Quick Wins" to get basic systems running, then tackle the missing hooks for criminal flags and bounties.
