# Quick Reference: C++ Module Implementation Status

**For**: Developers, Project Managers, QA  
**Updated**: November 24, 2025  
**TL;DR**: 80% of systems need C++ backend implementation (headers exist, logic missing)

---

## One-Liner Status Per System

| System | Status | Priority | Go/No-Go |
|--------|--------|----------|----------|
| Criminal Flags | Headers + DB ✅, Logic ❌ | CRITICAL | ❌ Can't launch |
| Notoriety Decay | Pure missing | CRITICAL | ❌ Can't launch |
| Buy Order Gen | Fulfillment ✅, Generation ❌ | HIGH | ⚠️ Workaround exists |
| Public Grouping | Request ✅, Creation ❌ | HIGH | ⚠️ Workaround exists |
| Caravan Physics | Math ✅, Integration ❌ | MEDIUM | ✅ Can launch |
| Bounty System | Schema ✅, Logic ❌ | MEDIUM | ✅ Can launch |
| Build Presets | 95% ✅, Location check ❌ | LOW | ✅ Can launch |
| Blessed Items | Framework ✅, Binding ❌ | LOW | ✅ Can launch |
| Healing Zones | Nothing ❌ | LOW (?) | ✅ Can launch |
| Spawn Scheduler | Nothing ❌ | LOW | ✅ Can launch |

---

## The Three Critical Blockers

### 1. **Criminal Flag Expiry** (5 hours)
**Problem**: Players flagged as criminals never lose the flag  
**Result**: PvP system is unplayable  
**Fix**: Implement `SetCriminalFlag()` + cleanup timer

### 2. **Notoriety Decay** (4 hours)
**Problem**: Killed players stay wanted forever  
**Result**: Bounty system creates permanent enemies  
**Fix**: Implement decay timer with zone multipliers

### 3. **Group Formation** (4 hours)
**Problem**: Groups requested but never created  
**Result**: Group finder is a dead feature  
**Fix**: Hook `StartPublicGroup()` to `Group::Create()`

**Total to unblock**: 13 hours = 1-2 dev days

---

## What Exists vs What's Missing

### Criminal Flags
```
✅ Database: character_criminal_flags table
✅ Zone Config: zone_pvp_config.criminal_flag_duration
✅ Headers: IsCriminalFlagged(), SetCriminalFlag() declared
❌ Implementation: Functions not defined
❌ Expiry: No cleanup timer
❌ Hook: No OnPlayerAttack() to set flag
```

### Notoriety Decay
```
✅ Database: character_notoriety table
✅ Zone Multipliers: Defined in comments
❌ Formula: Not in C++ code
❌ Timer: No WorldScript
❌ Zone Lookup: GetZoneRiskConfig exists but decay not applied
```

### Public Groups
```
✅ API: Complete header with all functions
✅ Contribution Tracking: TrackContribution() declared
✅ Rewards: AwardContributionRewards() declared
❌ Group Creation: StartPublicGroup() doesn't call Group::Create()
❌ Membership: No code to add players to group
```

### Buy Orders
```
✅ Fulfillment: FulfillOrder() gives gold to player
✅ Retrieval: GetBuyOrders() gets active orders
✅ Pricing: GetHotZonePriceMultiplier() applies bonuses
❌ Generation: GenerateBuyOrders() stubbed out
❌ Scheduler: No timer to regenerate orders
❌ NPC Display: No gossip script
```

### Caravan System
```
✅ Physics: All calculations in MortalCaravanMovement.h
✅ Database: mortal_caravan_upgrades, wagon_stats tables exist
❌ Vehicle: No creature class to use physics
❌ Movement Hook: Calculations not applied
❌ Cargo: No item storage system
```

### Blessed Items
```
✅ Database: mortal_blessed_items table
✅ Death Hook: PlayerScript_MortalBlessedItems exists
✅ Usage Hook: ItemScript_MortalBlessedItems exists
✅ Functions Declared: BlessItem(), ConsumeBlessingCharge(), etc.
❌ Item Binding: Not marked soulbound
❌ Implementation: Actual .cpp logic status unknown
```

### Build Presets
```
✅ Full API: CreatePreset() through DeletePreset()
✅ Validation: ValidatePreset() checks caps
✅ Application: ApplyPresetAttributes/Gear/Runes
✅ Combat Check: CanApplyPreset() checks IsInCombat()
❌ Zone Check: CanApplyPreset() missing zone safety check
```

### Healing Zones
```
❌ Database: No zone_healing_config table
❌ Schema: No healing_allowed field
❌ Hook: No SpellScript for healing spells
❌ Logic: No zone restriction code
```

### Dynamic Ecosystem
```
⚠️ Foundation: AzerothCore grid system exists
⚠️ Respawn: Respawn system works
❌ Scheduling: No spawn wave system
❌ Clustering: No logic to spawn near activity
❌ Database: No ecosystem_spawning schema
```

---

## Files to Check/Modify

### Headers Already Defined (Just Need .cpp)
- `src/MortalBlessedItems.h` - Check if .cpp implements these
- `src/MortalBuyOrders.h` - Check if .cpp implements these
- `src/MortalPublicGrouping.h` - Check if .cpp implements these
- `src/MortalCaravanMovement.h` - Already has formulas, just needs integration
- `src/MortalBuildPresets.h` - Check if .cpp implements these

### Missing Entirely
- `src/MortalNotorietyDecay.h` - **Doesn't exist, needs creation**
- `src/MortalCriminalFlags.h` - **Doesn't exist, needs creation**
- `src/MortalBountyRewards.h` - **Doesn't exist, needs creation**

### World-Level Hooks Missing
- `ScriptMgr.cpp` - Needs WorldScript timers:
  - Criminal flag cleanup timer
  - Notoriety decay timer
  - Buy order regeneration timer
  - Ecosystem spawn scheduler (optional)

### Player-Level Hooks Missing
- `ScriptMgr.cpp` - Needs PlayerScript hooks:
  - OnPlayerAttack() for criminal flag setting
  - OnPlayerDeath() for bounty/criminal flag updates
  - OnPlayerPVPKill() for notoriety increment
  - OnPlayerLeaveArea() for bounty cleanup

---

## The Implementation Pattern

Every incomplete system follows this pattern:

```cpp
// Step 1: Header declares the API
class MortalSystem {
    bool DoSomething(Player* player);  // ✅ Declared
};

// Step 2: Database schema exists
CREATE TABLE mortal_system (...);  // ✅ Tables exist

// Step 3: Implementation missing
// src/MortalSystem.cpp
// ❌ File either doesn't exist or is mostly empty

// Step 4: Integration hooks missing
// In ScriptMgr.cpp
class PlayerScript_MortalSystem : public PlayerScript {
    // ❌ OnSomethingHappens() method doesn't exist
    // ❌ Never calls MortalSystem::DoSomething()
};

// Result: The system is "declared" but inert
```

**Solution**: Implement missing `.cpp` files and hook them into `ScriptMgr.cpp`

---

## Quick Implementation Checklist

### For Each System, Verify:

- [ ] **Header exists** in `/src/` (check `.h` file)
- [ ] **Database schema exists** in `/sql/` (check `.sql` files)
- [ ] **Functions implemented** in corresponding `.cpp` file
- [ ] **Hooked into ScriptMgr.cpp** (check PlayerScript/WorldScript)
- [ ] **Timer scheduled** if needed (WorldScript::Update())
- [ ] **Error handling** for database failures
- [ ] **Logging** for debugging and monitoring

### Example: Criminal Flags

```cpp
// 1. Check header
✅ src/MortalOverhaul.h has GetZoneRiskConfig()

// 2. Check database
✅ sql/16_criminal_flags.sql has table definition

// 3. Check implementation
❌ Need SetCriminalFlag(Player*, duration) in MortalOverhaul.cpp

// 4. Check hook
❌ ScriptMgr.cpp missing OnPlayerAttack() hook

// 5. Check timer
❌ No WorldScript to clean expired flags

// Fix: 5 hours of work
```

---

## Estimated Timeline to Launch-Ready

| Scope | Systems | Effort | Timeline |
|-------|---------|--------|----------|
| **Minimum** | Criminal flags, Notoriety decay, Group formation | 13h | 1-2 days |
| **Recommended** | + Buy orders, Bounty rewards, Caravan basics | 30h | 4-5 days |
| **Complete** | + Blessed items, Build presets, Healing zones | 44h | 1 week |
| **Polished** | + Spawn scheduler, Edge cases, Testing | 80h | 2 weeks |

**Go/No-Go Decision**:
- **If launching in 1 week**: Aim for "Minimum" scope, patch later
- **If launching in 2 weeks**: Can do "Recommended" scope
- **If launching in 1 month**: Can do "Complete" scope

---

## Red Flags in Current Code

### 1. Stub Functions (Declared but Not Implemented)
```cpp
// These exist in headers but may not be implemented:
MortalBlessedItems::BlessItem()
MortalBuyOrders::GenerateBuyOrders()
MortalPublicGrouping::StartPublicGroup()
```

### 2. Missing Integrations
```cpp
// These hooks don't exist:
PlayerScript_MortalPvP (for criminal flags)
PlayerScript_MortalBounty (for notoriety increment)
WorldScript_CriminalFlagCleanup (for expiry)
WorldScript_NotorietyDecay (for decay timer)
WorldScript_BuyOrderRegeneration (for economy)
```

### 3. Unused Database Fields
```sql
-- These fields exist but aren't used in C++:
zone_pvp_config.criminal_flag_duration
zone_pvp_config.always_drop_loot
character_notoriety.zone_id
character_notoriety.total_kills
```

### 4. Physics Not Applied
```cpp
// These calculations exist but aren't called:
MortalCaravanMovement::CalculateCaravanSpeed()
MortalCaravanMovement::CalculateCargoPenalty()
MortalCaravanMovement::GetTerrainModifier()
```

---

## Questions for Design/PM

1. **Healing Zones**: Is this system intended? It has zero C++ implementation.
2. **Spawn Scheduler**: Priority after launch or must-have?
3. **Bounty System**: Can it launch with manual order generation (admin tool)?
4. **Caravans**: Can they launch as regular quests without vehicle integration?
5. **Timeline**: 1 week to launch vs 2 weeks? Affects what's prioritized.

---

## Key Takeaway

**The gap is not "what features don't exist" but "which features need C++ backend logic hooked in".**

All the database design and header APIs are there. Just need:
1. ✍️ Write the `.cpp` implementation files
2. 🔗 Hook them into ScriptMgr.cpp (PlayerScript/WorldScript)
3. ⏱️ Schedule timers for recurring tasks
4. 🧪 Test and verify

**Minimum viable: 13 hours of focused development**

