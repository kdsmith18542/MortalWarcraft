# System-by-System Implementation Status

**Generated**: November 24, 2025

---

## 1. CRIMINAL FLAGS SYSTEM

### 🔴 Status: 70% Complete (Headers + DB exist, Logic Missing)

| Component | Status | Location | Notes |
|-----------|--------|----------|-------|
| Database Table | ✅ | `sql/16_criminal_flags.sql` | Clean schema with expiry timestamp |
| Data Model | ✅ | `MortalOverhaul.h` (implied) | guid + criminal_until fields |
| Getter Function | ❌ | Missing | Need `IsCriminalFlagged(Player*)` |
| Setter Function | ❌ | Missing | Need `SetCriminalFlag(Player*, duration)` |
| Expiry Cleanup | ❌ | Missing | Need WorldScript timer |
| Attack Hook | ❌ | Missing | Need PlayerScript_MortalPvP::OnAttack() |
| Visualization | ⚠️ | Lua | Icon/chat messages probably in UI |
| Zone Config | ✅ | `zone_pvp_config.criminal_flag_duration` | 900s (15 min) default |

**What's Blocking It**:
- No `OnPlayerAttack()` hook to detect yellow zone crimes
- No cleanup timer to remove expired flags
- Flag check functions not implemented

**Why It Matters**:
Players can attack criminals in Yellow zones without consequence if this isn't working.

**Effort to Complete**: 5 hours (setter, getter, cleanup timer, attack hook)

---

## 2. BOUNTY SYSTEM

### 🔴 Status: 20% Complete (Schema Only, No Logic)

| Component | Status | Location | Notes |
|-----------|--------|----------|-------|
| Database Tables | ✅ | `sql/17_notoriety.sql` + `sql/18_bounty_tokens.sql` | character_notoriety + bounty_board_locations |
| Item Template | ✅ | item_template entry 90002 | Bounty Token item exists |
| Notoriety Field | ✅ | character_notoriety.notoriety | Tracks kill count |
| Bounty Decay | ❌ | Missing | No timer to reduce notoriety |
| Bounty Contract | ❌ | Missing | No system to create contracts |
| Bounty Board NPC | ❌ | Missing | No creature script to show bounties |
| Token Award | ❌ | Missing | No code to give tokens on kill |
| Stub Function | ⚠️ | `MortalOverhaul::UpdateBountyMapLocation()` | Exists but does nothing |

**What's Blocking It**:
- Notoriety decay system not implemented (see below)
- No PvP kill hook to increment notoriety
- No NPC to display contracts
- No contract completion logic

**Why It Matters**:
Bounty hunting is a major economy driver. Without this, there's no reward for hunting criminals.

**Effort to Complete**: 8 hours (decay + kill hook + NPC logic + token rewards)

---

## 3. NOTORIETY DECAY

### 🔴 Status: 0% Complete (Schema Exists, No Implementation)

| Component | Status | Location | Notes |
|-----------|--------|----------|-------|
| Database Table | ✅ | `character_notoriety` | Tracks guid, notoriety, last_updated |
| Zone Multiplier Schema | ✅ | sql/41_bounty_system_enhancement.sql (comments) | Rules defined in comments |
| Decay Formula | ❌ | Missing | Not implemented anywhere |
| Decay Timer | ❌ | Missing | No WorldScript to run decay |
| Zone Lookup | ⚠️ | `MortalOverhaul::GetZoneRiskConfig()` | Zone config exists, decay multipliers not applied |
| Increment on Kill | ❌ | Missing | No OnPVPKill hook |
| Database Update | ❌ | Missing | No queries to update notoriety |

**What's Blocking It**:
- WorldScript timer not implemented
- Decay formula not defined in C++
- Zone multiplier logic not applied

**Why It Matters**:
Without decay, players stay wanted forever, creating impossible revenge scenarios.

**Effort to Complete**: 4 hours (decay formula, timer, zone lookup)

---

## 4. HEALING ZONE RESTRICTIONS

### 🔴 Status: 0% Complete (Never Implemented)

| Component | Status | Location | Notes |
|-----------|--------|----------|-------|
| Database Schema | ❌ | Missing | No zone_healing_config table |
| Zone Config | ❌ | Missing | No healing_allowed field |
| Spell Hook | ❌ | Missing | No SpellScript to block healing |
| Spell Check | ❌ | Missing | No code to identify healing spells |
| Enforcement | ❌ | Missing | No spell failure mechanism |
| Sanctuary Flag | ⚠️ | AzerothCore has AREA_FLAG_SANCTUARY | Exists in core but unused |

**What's Blocking It**:
- Design question: Is this feature intended?
- No schema for zone healing restrictions
- No spell hook system

**Why It Matters**:
Could make combat zones feel more dangerous (no healing between fights).

**Effort to Complete**: 5 hours (if confirmed as needed)

**⚠️ QUESTION**: Confirm with design team if this system is actually needed or if it's an abandoned feature.

---

## 5. BLESSED ITEMS (Death Protection)

### 🟡 Status: 60% Complete (Framework Exists, Enforcement Gaps)

| Component | Status | Location | Notes |
|-----------|--------|----------|-------|
| Database Table | ✅ | `mortal_blessed_items` | Full schema with charges tracking |
| Blessing Function | ⚠️ | `MortalBlessedItems::BlessItem()` | Declared in .h, implementation status unknown |
| Check Function | ⚠️ | `MortalBlessedItems::IsItemBlessed()` | Declared in .h, implementation status unknown |
| Charge Consumption | ⚠️ | `MortalBlessedItems::ConsumeBlessingCharge()` | Declared in .h, implementation status unknown |
| Cleanup Function | ⚠️ | `MortalBlessedItems::CleanupExpiredBlessings()` | Declared in .h, implementation status unknown |
| Death Hook | ✅ | `PlayerScript_MortalBlessedItems::OnPlayerDeath()` | Exists in ScriptMgr.cpp, checks blessed items |
| Item Binding | ❌ | Missing | Blessed items not marked soulbound |
| Item Usage | ✅ | `ItemScript_MortalBlessedItems::OnUse()` | Blessing item usage hooked |

**What's Blocking It**:
- Actual .cpp implementation of blessing functions not verified
- Items can be blessed but still traded (need soulbound)
- Cleanup timer not scheduled

**Why It Matters**:
Players can bless items then gift them, breaking the "soft insurance" concept.

**Effort to Complete**: 3 hours (bind items on blessing, schedule cleanup timer)

---

## 6. PUBLIC GROUPING SYSTEM

### 🟡 Status: 70% Complete (Request System Works, Creation Missing)

| Component | Status | Location | Notes |
|-----------|--------|----------|-------|
| Header API | ✅ | `MortalPublicGrouping.h` | Full API declared |
| Database Schema | ✅ | Assumed in sql/113_public_grouping_enhancements.sql | Tables for requests/applications |
| Request Creation | ✅ | `CreateGroupRequest()` | Declared, implementation status unknown |
| Request Listing | ✅ | `GetAvailableRequests()` | Declared, implementation status unknown |
| Application System | ✅ | `ApplyToGroupRequest()`, `ProcessApplication()` | Declared, implementation status unknown |
| Group Creation | ❌ | `StartPublicGroup()` | Doesn't call `Group::Create()` |
| Group Membership | ❌ | Missing | No code to add members to group |
| Contribution Tracking | ✅ | `TrackContribution()`, `GetContributionScores()` | Declared |
| Reward Distribution | ✅ | `AwardContributionRewards()` | Declared |

**What's Blocking It**:
- `StartPublicGroup()` needs to actually create a Group object
- Group membership assignment missing
- Database requests not tied to actual Group objects

**Why It Matters**:
Group finder requests never become actual groups, leaving them hanging.

**Effort to Complete**: 4 hours (group creation, membership management)

---

## 7. BUILD PRESETS SYSTEM

### 🟢 Status: 90% Complete (One Validation Missing)

| Component | Status | Location | Notes |
|-----------|--------|----------|-------|
| Header API | ✅ | `MortalBuildPresets.h` | Well-designed API |
| Preset CRUD | ✅ | Create/Read/Update/Delete functions declared | Database operations |
| Attribute Validation | ✅ | `ValidatePreset()` checks attribute caps | Implemented |
| Mastery Validation | ✅ | `ValidateMasteryAllocation()` checks tree rules | Implemented in ScriptMgr.cpp |
| Location Check - Out of Combat | ⚠️ | `CanApplyPreset()` checks combat | Implemented |
| Location Check - Zone Type | ❌ | `CanApplyPreset()` missing zone check | Only Safe (Green) zones |
| Preset Activation | ✅ | `ActivatePreset()` applies preset | Implemented |
| Gear Equipping | ✅ | `ApplyPresetGear()` equips items | Declared |
| Rune Application | ✅ | `ApplyPresetRunes()` applies augments | Declared |

**What's Blocking It**:
- `CanApplyPreset()` doesn't check if player is in a safe zone

**Why It Matters**:
Players could swap gear in combat, giving unfair advantages.

**Effort to Complete**: 1 hour (add zone check to CanApplyPreset)

---

## 8. BUY ORDER SYSTEM

### 🟡 Status: 50% Complete (Fulfillment Works, Generation Missing)

| Component | Status | Location | Notes |
|-----------|--------|----------|-------|
| Database Schema | ✅ | `mortal_buy_orders` table | Complete with expiry and pricing |
| Order Retrieval | ✅ | `GetBuyOrders(npcEntry)` | Gets active orders for NPC |
| Order Fulfillment | ✅ | `FulfillOrder()` | Gives gold to player, updates database |
| Order Expiry | ✅ | Database design with expires_time | Orders naturally expire |
| Order Generation | ❌ | `GenerateBuyOrders()` function exists but stubbed | Should create new orders |
| Material Selection | ❌ | Missing | No algorithm to pick materials |
| Price Calculation | ⚠️ | `GetHotZonePriceMultiplier()` exists | Prices calculated, generation missing |
| NPC Gossip | ❌ | Missing | NPCs don't show buy orders |
| Regional Bonuses | ✅ | `mortal_regional_bonuses` table | Hot zones with multipliers defined |
| Log Table | ✅ | `mortal_buy_order_log` | Transaction history |

**What's Blocking It**:
- `GenerateBuyOrders()` is stubbed
- No scheduled task to regenerate orders
- NPCs don't display orders in gossip

**Why It Matters**:
Without order generation, the economy is static. Players craft for non-existent demand.

**Effort to Complete**: 9 hours (generation logic, periodic scheduler, gossip integration)

---

## 9. DYNAMIC ECOSYSTEM / SPAWN SCHEDULER

### 🔴 Status: 0% Complete (Complex Feature, Not Implemented)

| Component | Status | Location | Notes |
|-----------|--------|----------|-------|
| Spawn Tracking | ⚠️ | AzerothCore grid system exists | Tracks creatures per grid cell |
| Respawn System | ⚠️ | AzerothCore respawn timer exists | Respawns creatures after death |
| Dynamic Respawn | ⚠️ | `Map::ApplyDynamicModeRespawnScaling()` | Exists but applies difficulty scaling only |
| Area Population | ❌ | Missing | No code counts players per area |
| Spawn Clustering | ❌ | Missing | No code clusters spawns near activity |
| Ecosystem Manager | ❌ | Missing | No class to manage ecosystem |
| Predator/Prey | ❌ | Missing | No AI adjustments for activity |
| Loot Scaling | ❌ | Missing | Loot doesn't scale with difficulty |
| Database Schema | ❌ | Missing | No ecosystem_spawning table |

**What's Blocking It**:
- Complex feature requiring area-based queries
- Needs creature group logic
- Performance implications (per-spawn updates)

**Why It Matters**:
World feels static. NPCs don't react to activity.

**Effort to Complete**: 16+ hours (ecosystem manager, area queries, testing)

**Priority**: LOW (world is playable without this, nice-to-have feature)

---

## 10. CARAVAN SYSTEM

### 🟡 Status: 40% Complete (Physics Defined, Not Integrated)

| Component | Status | Location | Notes |
|-----------|--------|----------|-------|
| Movement Formulas | ✅ | `MortalCaravanMovement.h` | Cargo, terrain, road, health penalties calculated |
| Cargo Penalty | ✅ | `CalculateCargoPenalty()` | Formula: 1.0 - (weight/capacity) * 0.5 |
| Terrain Modifier | ✅ | `GetTerrainModifier()` | Road 1.0, Grass 0.9, Hills 0.7, Swamp 0.6, Steep 0.0 |
| Road Bonus | ✅ | `GetRoadBonus()` | On-road: +0.2, off-road: 0.0 |
| Health Modifier | ✅ | `CalculateHealthModifier()` | >75% = 1.0, 50-75% = 0.9, 25-50% = 0.8, <25% = 0.6 |
| Speed Calculation | ✅ | `CalculateCaravanSpeed()` | Composite formula: base * cargo * terrain * road * health |
| Traversability Check | ✅ | `IsTerrainTraversable()` | Checks if terrain can be crossed |
| Vehicle Entity | ❌ | Missing | No Creature-based caravan class |
| Movement Hook | ❌ | Missing | Speed calculations not applied to movement |
| Cargo System | ❌ | Missing | No inventory/cargo management |
| Database Schema | ✅ | mortal_caravan_upgrades, wagon_stats | Tables exist |
| Caravan Upgrades | ✅ | Wheels, armor, animals, decoys defined | SQL inserts in place |

**What's Blocking It**:
- No creature class that extends the physics
- Movement speed not calculated from cargo/terrain
- Cargo slot system not implemented

**Why It Matters**:
Caravans don't feel different from regular movement. Content feels static.

**Effort to Complete**: 8 hours (creature class, cargo system, movement hook)

---

## Summary Table (All Systems)

| # | System | Status | Severity | Effort | Impact |
|---|--------|--------|----------|--------|--------|
| 1 | Criminal Flags | 🟡 70% | HIGH | 5h | PvP system broken |
| 2 | Bounty System | 🔴 20% | HIGH | 8h | No economy driver |
| 3 | Notoriety Decay | 🔴 0% | CRITICAL | 4h | Criminals forever |
| 4 | Healing Zones | 🔴 0% | LOW | 5h | Design question |
| 5 | Blessed Items | 🟡 60% | LOW | 3h | Can be stolen |
| 6 | Public Grouping | 🟡 70% | MEDIUM | 4h | Groups won't form |
| 7 | Build Presets | 🟢 90% | LOW | 1h | Can swap in combat |
| 8 | Buy Orders | 🟡 50% | MEDIUM | 9h | Economy static |
| 9 | Spawn Scheduler | 🔴 0% | LOW | 16h | World static |
| 10 | Caravans | 🟡 40% | MEDIUM | 8h | Movement boring |
| | | | | **57 hours** | |

**To Get to "Playable"** (systems 1, 3, 6, 8): **19 hours**  
**To Get to "Complete"** (systems 1-10 except 4, 9): **44 hours**  
**To Get to "Polished"** (all systems): **80 hours**

