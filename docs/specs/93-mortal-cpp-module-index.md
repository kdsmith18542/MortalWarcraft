# Project Canvas: Mortal Warcraft Overhaul  
### File: 93-mortal-cpp-module-index.md  
### Topic: C++ Module Index – Systems, Responsibilities & File Layout

> This document is a **high-level index** of planned C++ modules for Mortal Warcraft,  
> showing which systems they implement, where they live in the AzerothCore tree,  
> and how they relate to Lua scripts and DB tables.

---

## Related Specs

- `17-implementation-roadmap.md` - Implementation milestones and sequencing
- `01-progression.md` - MortalLevel, MortalStats, MortalCombatSkills modules
- `84-mortal-core-stats-and-combat-model.md` - Core stats and combat modules
- `02-combat.md` - Combat system modules
- `04-economy.md` - MortalRegionalBank, MortalMarketStalls, MortalInsurance modules
- `08-guilds-sovereignty.md` - MortalStrongholdSystem, MortalSiegeWindow modules
- `11-pvp-systems.md` - PvP system modules
- `51-factions-and-standing-system.md` - MortalFactions module
- `16-database-schema.md` - Database schema that modules interact with

---

## 1. Goals

1. Give Cursor / devs a **single map** of C++ modules:
   - What features they own,
   - Which specs they implement,
   - Which DB tables and Lua scripts they coordinate with.

2. Align with the project’s bias toward:
   - **C++-first** core mechanics,
   - Lua for content, flavor, and glue logic,
   - Clear modularity (each module has a focused concern).

3. Reduce “where should this go?” questions by:
   - Defining a **canonical file layout**,
   - Listing main entry points and helper APIs.

---

## 2. Directory Layout (Mortal Modules)

**ACTUAL STRUCTURE:** All Mortal-specific C++ lives in a flat structure under:

```txt
azerothcore/modules/mortal_overhaul/src/
    # All modules in flat structure (not organized subdirectories)
    MortalLevel.cpp/h
    MortalStats.cpp/h
    MortalCombatSkills.cpp/h
    MortalFactions.cpp/h
    MortalRegionalBank.cpp/h
    MortalMarketStalls.cpp/h
    MortalInsurance.cpp/h
    MortalStrongholdSystem.cpp/h
    MortalSiegeWindow.cpp/h
    MortalSiegeController.cpp/h
    MortalWarfrontState.cpp/h
    MortalWarfrontEngine.cpp/h
    MortalWorldBossEvents.cpp/h
    MortalMidnightHorde.cpp/h
    MortalAnomalies.cpp/h
    MortalRifts.cpp/h
    MortalHellgates.cpp/h
    MortalLivingMounts.cpp/h
    MortalPets.cpp/h
    MortalMercenaryBroker.cpp/h
    MortalUtilityCompanions.cpp/h
    MortalRadioSilence.cpp/h
    MortalTitleSystem.cpp/h
    # ... and many more modules
```

**NOTE:** The spec originally proposed organized subdirectories (`Mortal/Core/`, `Mortal/Economy/`, etc.), but the actual implementation uses a flat structure in `mortal_overhaul/src/`. This document has been updated to reflect the actual structure.

Additionally, some **AzerothCore patches/hooks** may land in:

```txt
src/server/game/Player/MortalPlayerHooks.cpp (if exists)
src/server/game/World/MortalWorldHooks.cpp (if exists)
```

---

## 3. Core Gameplay Modules

### 3.1 `MortalStats` – Stats & Derived Values

**Location:**

```txt
azerothcore/modules/mortal_overhaul/src/MortalStats.cpp
azerothcore/modules/mortal_overhaul/src/MortalStats.h
```

**Implements:**

- Spec: `84-mortal-core-stats-and-combat-model.md`
- Responsibilities:
  - Attribute caps (150 per stat, 400 total).
  - Derived stats:
    - HP, Mana, AP, SP, Crit, Armor, etc.
  - Integration with combat formulas (hit, mitigation).

**Key APIs:**

- `void ApplyMortalStatCaps(Player* player);`
- `MortalDerivedStats ComputeDerived(const Player* player);`
- Hook points in:
  - `Player::UpdateStats()`,
  - On login and on attribute change.

**Note:** Named `MortalStats` in actual code, not `MortalCoreStats`.

---

### 3.2 `MortalLevel` – Dynamic Level System

**Location:**

```txt
azerothcore/modules/mortal_overhaul/src/MortalLevel.cpp
azerothcore/modules/mortal_overhaul/src/MortalLevel.h
```

**Implements:**

- Dynamic Level spec from main design doc.

**Responsibilities:**

- Override:
  - `Player::GiveXP` → no-op or repurposed.
  - `Player::GetLevel` → derived from skill points.
- Provide:
  - `uint8 GetMortalLevel(const Player* player);`
  - Utility to compute from `character_mortal_skills`.

**DB:**

- `character_mortal_skills` table (skills and points).

**Note:** Named `MortalLevel` in actual code, not `MortalLeveling`.

---

### 3.3 `MortalSkills` – Skill Gain & Caps

**Location:**

```txt
azerothcore/modules/mortal_overhaul/src/MortalCombatSkills.cpp/h
azerothcore/modules/mortal_overhaul/src/MortalCraftingSkills.cpp/h
azerothcore/modules/mortal_overhaul/src/MortalGatheringSkills.cpp/h
```

**Implements:**

- Skill gain / caps from core spec and loop spec docs.

**Responsibilities:**

- `MortalAdvanceSkill(player, skillId, amount)`, enforcing:
  - Global skill cap (e.g. 1200),
  - Per-skill caps as needed.
- Hooks:
  - Combat hits, crafting actions, gathering, etc.
  - Exposed to Lua as a callable helper.

**DB:**

- `character_mortal_skills`

**Note:** Skills are split into separate modules: Combat, Crafting, and Gathering.

---

## 4. Factions, Standing & Crime

### 4.1 `MortalFactions` – Factions & Standing

**Location:**

```txt
azerothcore/modules/mortal_overhaul/src/MortalFactions.cpp
azerothcore/modules/mortal_overhaul/src/MortalFactions.h
```

**Implements:**

- `86-mortal-factions-and-standing.md`

**Responsibilities:**

- Core Standing system:
  - Civic, Shrine, Cartel, Frontier, Atlas.
- APIs:
  - `int32 GetStanding(Player* player, MortalFactionId faction);`
  - `void AddStanding(Player* player, MortalFactionId faction, int32 delta);`
  - `void SetStanding(Player* player, MortalFactionId faction, int32 value);`
- Provide modifiers for:
  - Tax rates,
  - Guard behavior,
  - Market fees,
  - Access checks.

**DB:**

- `mortal_factions` (definitions),
- `mortal_standing` (per-player values).

**Note:** Named `MortalFactions` in actual code, not `MortalStanding`. Notoriety functionality may be in `MortalBountyBoard.cpp/h`.

---

### 4.2 `MortalBountyBoard` – Crime, Bounties & Criminal Flags

**Location:**

```txt
azerothcore/modules/mortal_overhaul/src/MortalBountyBoard.cpp
azerothcore/modules/mortal_overhaul/src/MortalBountyBoard.h
```

**Implements:**

- Bounty Board, criminal flags, Notoriety.

**Responsibilities:**

- Track short-term crime:
  - Attacking innocents in Yellow Zones,
  - Group ganks, theft.
- Show:
  - Map skulls for high-Notoriety players.
- Bounty integration:
  - Expose records to Lua for bounty board UI.

**Note:** Named `MortalBountyBoard` in actual code, not `MortalNotoriety`. May also include `MortalBountyPot.cpp/h`.

---

## 5. Economy, Markets & Insurance

### 5.1 `MortalEconomyCore`

**Location:**

```txt
src/server/game/Mortal/Economy/MortalEconomyCore.h
src/server/game/Mortal/Economy/MortalEconomyCore.cpp
```

**Implements:**

- Currency & sinks summary spec.

**Responsibilities:**

- Global economic helpers:
  - Taxes, fees, repair cost modifiers.
- Hook gold gains & sinks:
  - Contracts, Task Boards, events.

---

### 5.2 `MortalRegionalBank`

**Location:**

```txt
azerothcore/modules/mortal_overhaul/src/MortalRegionalBank.cpp
azerothcore/modules/mortal_overhaul/src/MortalRegionalBank.h
```

**Implements:**

- Regional bank spec.

**Responsibilities:**

- Enforce regional bank separation:
  - Stormwind != Ironforge != Frontier Strongholds.
- NPC banker hooks:
  - Check player's region, route to correct bank slot.

**DB:**

- `character_regional_bank` (per-player, per-region inventory).

**Note:** Named `MortalRegionalBank` in actual code, not `MortalRegionalBanking`.

---

### 5.3 `MortalMarketStalls`

**Location:**

```txt
src/server/game/Mortal/Economy/MortalMarketStalls.h
src/server/game/Mortal/Economy/MortalMarketStalls.cpp
```

**Implements:**

- Market Stall system, EVE-style AH network.

**Responsibilities:**

- Stall rental & inventory management.
- Fee calculations (factoring Standing).
- Bridge to web Atlas for market data.

**DB:**

- `mortal_market_stalls`, `mortal_market_listings`.

---

### 5.4 `MortalInsurance`

**Location:**

```txt
src/server/game/Mortal/Economy/MortalInsurance.h
src/server/game/Mortal/Economy/MortalInsurance.cpp
```

**Implements:**

- Soul Insurance spec.

**Responsibilities:**

- Allow item-level insurance contracts:
  - Insurance premiums, payout calculations.
- Hook into death/loot routines:
  - On item loss → compute payout, schedule mail.

**DB:**

- `mortal_insurance_policies`,
- `mortal_insurance_payouts`.

---

## 6. War & Territory

### 6.1 `MortalStrongholdSystem`

**Location:**

```txt
azerothcore/modules/mortal_overhaul/src/MortalStrongholdSystem.cpp
azerothcore/modules/mortal_overhaul/src/MortalStrongholdSystem.h
```

**Implements:**

- Stronghold Sovereignty, resource generation.

**Responsibilities:**

- Own:
  - Stronghold definitions (location, type),
  - Ownership (guild/coalition),
  - Resource output.
- APIs:
  - `GuildId GetStrongholdOwner(StrongholdId);`
  - `void SetStrongholdOwner(StrongholdId, GuildId);`
- Tie into taxes and local buffs.

**Note:** Named `MortalStrongholdSystem` in actual code, not `MortalStrongholds`. Also includes `MortalStrongholdUpkeep.cpp/h`.

---

### 6.2 `MortalSiegeController` & `MortalSiegeWindow`

**Location:**

```txt
azerothcore/modules/mortal_overhaul/src/MortalSiegeController.cpp
azerothcore/modules/mortal_overhaul/src/MortalSiegeController.h
azerothcore/modules/mortal_overhaul/src/MortalSiegeWindow.cpp
azerothcore/modules/mortal_overhaul/src/MortalSiegeWindow.h
```

**Implements:**

- `92-mortal-warfronts-siege-flow.md` (siege portion).

**Responsibilities:**

- `MortalSiegeWindow`: Manage siege windows, schedule, state machine (PRE, ACTIVE, POST).
- `MortalSiegeController`: Multi-stage encounters, sigil capture, full-loot handling.
- Validate challenges.
- Handle ownership flip, lockouts.
- Expose events to Lua for encounter scripting.

**Note:** Split into two modules: `MortalSiegeWindow` for window management and `MortalSiegeController` for encounter flow.

---

### 6.3 `MortalWarfrontEngine` & `MortalWarfrontState`

**Location:**

```txt
azerothcore/modules/mortal_overhaul/src/MortalWarfrontEngine.cpp
azerothcore/modules/mortal_overhaul/src/MortalWarfrontEngine.h
azerothcore/modules/mortal_overhaul/src/MortalWarfrontState.cpp
azerothcore/modules/mortal_overhaul/src/MortalWarfrontState.h
```

**Implements:**

- Warfront scenarios and scoring.

**Responsibilities:**

- `MortalWarfrontState`: Portal state tracking, open/closed status.
- `MortalWarfrontEngine`: Warfront instance lifecycle:
  - Team assignment,
  - Objectives & scoring,
  - Full-loot death handling.
- Reward distribution:
  - Military Credits,
  - Frontier/Civic Standing hooks.

**Note:** Split into two modules: `MortalWarfrontState` for state tracking and `MortalWarfrontEngine` for core engine.

---

## 7. World, Events & PvPvE

### 7.1 `MortalWorldBossEvents` & `MortalMidnightHorde`

**Location:**

```txt
azerothcore/modules/mortal_overhaul/src/MortalWorldBossEvents.cpp
azerothcore/modules/mortal_overhaul/src/MortalWorldBossEvents.h
azerothcore/modules/mortal_overhaul/src/MortalMidnightHorde.cpp
azerothcore/modules/mortal_overhaul/src/MortalMidnightHorde.h
```

**Implements:**

- Midnight Horde, world bosses, recurring events.

**Responsibilities:**

- `MortalWorldBossEvents`: Central scheduler for timed events, world boss spawning.
- `MortalMidnightHorde`: Midnight Horde event system.
- Spawning & despawning event creatures.
- Notifying chat and Atlas.

**Note:** Split into separate modules for different event types.

---

### 7.2 `MortalAnomalies`, `MortalRifts`, & `MortalHellgates`

**Location:**

```txt
azerothcore/modules/mortal_overhaul/src/MortalAnomalies.cpp
azerothcore/modules/mortal_overhaul/src/MortalAnomalies.h
azerothcore/modules/mortal_overhaul/src/MortalRifts.cpp
azerothcore/modules/mortal_overhaul/src/MortalRifts.h
azerothcore/modules/mortal_overhaul/src/MortalHellgates.cpp
azerothcore/modules/mortal_overhaul/src/MortalHellgates.h
```

**Implements:**

- `91-mortal-anomalies-rifts-hellgates.md`.

**Responsibilities:**

- `MortalAnomalies`: Anomaly signature spawner, scanner system, discovery & activation.
- `MortalRifts`: Rift Instability per zone, invasion spawner, zone state management.
- `MortalHellgates`: Hellgate key & portal logic, instance coordinator, PvPvE showdowns.

**Note:** Split into three separate modules, one for each system.

---

## 8. Living Assets

### 8.1 `MortalLivingMounts`

**Location:**

```txt
azerothcore/modules/mortal_overhaul/src/MortalLivingMounts.cpp
azerothcore/modules/mortal_overhaul/src/MortalLivingMounts.h
azerothcore/modules/mortal_overhaul/src/MortalMountRepair.cpp
azerothcore/modules/mortal_overhaul/src/MortalMountRepair.h
azerothcore/modules/mortal_overhaul/src/MortalStableSystem.cpp
azerothcore/modules/mortal_overhaul/src/MortalStableSystem.h
```

**Implements:**

- Living mounts, Reins durability & Condition.

**Responsibilities:**

- `MortalLivingMounts`: Reins item template handling, Condition system.
- `MortalMountRepair`: Mount repair mechanics.
- `MortalStableSystem`: Stabling logic & DB persistence.

**Note:** Named `MortalLivingMounts` in actual code, not `MortalMounts`. Split into multiple modules for different aspects.

---

### 8.2 `MortalPets`

**Location:**

```txt
azerothcore/modules/mortal_overhaul/src/MortalPets.cpp
azerothcore/modules/mortal_overhaul/src/MortalPets.h
```

**Implements:**

- Combat pets, loyalty, death/flee rules.

**Responsibilities:**

- Bond/Loyalty system (0-100).
- Feeding system.
- Death & risk handling in full loot zones.
- Flee & wild behavior.
- Combat integration.

---

### 8.3 `MortalMercenaryBroker`

**Location:**

```txt
azerothcore/modules/mortal_overhaul/src/MortalMercenaryBroker.cpp
azerothcore/modules/mortal_overhaul/src/MortalMercenaryBroker.h
```

**Implements:**

- Contract-based mercenary system.

**Responsibilities:**

- Contract creation & management.
- Role-locked behavior (Healer/Tank/DPS).
- Wages & duration.
- Risk behavior (flee on death).
- Content restrictions.

**Note:** Named `MortalMercenaryBroker` in actual code, not `MortalMercenaries`.

---

### 8.4 `MortalUtilityCompanions`

**Location:**

```txt
azerothcore/modules/mortal_overhaul/src/MortalUtilityCompanions.cpp
azerothcore/modules/mortal_overhaul/src/MortalUtilityCompanions.h
azerothcore/modules/mortal_overhaul/src/MortalCompanion.cpp
azerothcore/modules/mortal_overhaul/src/MortalCompanion.h
```

**Implements:**

- Pack mules, vendor squires, eco-bots.

**Responsibilities:**

- Pack Mule: Extra inventory, encumbrance reduction, pack chest on death in Red Zones.
- Vendor Squire: Repair & vendor services, restricted in high-risk areas.
- Eco-Bot: NPC demand for low-tier goods, fixed buy prices.

**Note:** `MortalCompanion.cpp/h` provides generic companion feed system, `MortalUtilityCompanions` provides specific implementations.

---

## 9. Social & UI

### 9.1 `MortalRadioSilence`

**Location:**

```txt
azerothcore/modules/mortal_overhaul/src/MortalRadioSilence.cpp
azerothcore/modules/mortal_overhaul/src/MortalRadioSilence.h
```

**Implements:**

- Chat overhaul spec: channels, restrictions, broadcasts.

**Responsibilities:**

- Red Zone radio silence rules.
- Channel restrictions.
- Basic broadcast messages.

**Note:** Named `MortalRadioSilence` in actual code, not `MortalChat`. Full chat overhaul may be split across multiple modules.

---

### 9.2 Broadcasts (Distributed)

**Location:**

```txt
# Broadcasts are handled by various modules:
azerothcore/modules/mortal_overhaul/src/MortalWorldBossEvents.cpp  # World boss broadcasts
azerothcore/modules/mortal_overhaul/src/MortalWarfrontEngine.cpp   # Warfront broadcasts
azerothcore/modules/mortal_overhaul/src/MortalSiegeController.cpp  # Siege broadcasts
azerothcore/modules/mortal_overhaul/src/MortalRifts.cpp            # Rift invasion broadcasts
```

**Implements:**

- Automated server messages:
  - Shrines, Rifts, Warfronts, sieges, economy events.

**Note:** No dedicated `MortalBroadcasts` module - broadcasts are handled by individual system modules.

---

### 9.3 `MortalTitleSystem`

**Location:**

```txt
azerothcore/modules/mortal_overhaul/src/MortalTitleSystem.cpp
azerothcore/modules/mortal_overhaul/src/MortalTitleSystem.h
```

**Implements:**

- Custom titles & role tags (Admin/GM/criminals/etc.).

**Note:** Named `MortalTitleSystem` in actual code, not `MortalTitles`.

---

### 9.4 UI Data Feeds (Distributed)

**Location:**

```txt
# UI data feeds are handled by various modules:
azerothcore/modules/mortal_overhaul/src/MortalUIStats.cpp
azerothcore/modules/mortal_overhaul/src/MortalUINameplate.cpp
azerothcore/modules/mortal_overhaul/src/MortalUISurvival.cpp
azerothcore/modules/mortal_overhaul/src/MortalUITooltip.cpp
# Plus system-specific data exposure in:
# MortalWarfrontState, MortalStrongholdSystem, MortalFactions, etc.
```

**Implements:**

- Data feeds for MortalUI addon & Atlas.

**Responsibilities:**

- Expose:
  - Standing summaries (via MortalFactions),
  - Warfront schedule (via MortalWarfrontState),
  - Stronghold ownership (via MortalStrongholdSystem),
  - Anomaly/Rift status (via MortalAnomalies/MortalRifts).

**Note:** No dedicated `MortalUIBridge` module - UI data is exposed by individual system modules.

---

## 10. Admin & GM Tools

### 10.1 Admin Tools (Distributed)

**Location:**

```txt
# Admin tools are distributed across modules:
azerothcore/modules/mortal_overhaul/src/MortalSandboxWatchdog.cpp  # Sandbox monitoring
azerothcore/modules/mortal_overhaul/src/MortalLiveBalance.cpp      # Live balance adjustments
# Plus command scripts in various modules
```

**Responsibilities:**

- GM commands for:
  - Adjusting Standing (via MortalFactions),
  - Triggering events (via MortalWorldBossEvents, MortalRifts, etc.),
  - Forcing Rifts/Anomalies (via MortalRifts, MortalAnomalies),
  - Manipulating Strongholds & Warfronts (via MortalStrongholdSystem, MortalWarfrontEngine).
- Hooks into:
  - AzerothAdmin & mod-aio UIs.

**Note:** No dedicated `MortalAdminTools` module - admin functionality is distributed across system modules.

---

## 11. Hooks & Integration Points

### 11.1 Player Hooks

- Hooks are integrated directly into modules:
  - Leveling: `MortalLevel.cpp`
  - Stat caps: `MortalStats.cpp`
  - Death/loot events: Various modules (MortalRiskZoneLogic, etc.)
  - Standing changes: `MortalFactions.cpp`

**Note:** No dedicated `MortalPlayerHooks.cpp` file - hooks are in individual modules.

### 11.2 World Hooks

- Hooks are integrated directly into modules:
  - Event scheduling: `MortalWorldBossEvents.cpp`, `MortalMidnightHorde.cpp`
  - Zone state changes: `MortalRifts.cpp`, `MortalRiskZoneLogic.cpp`

**Note:** No dedicated `MortalWorldHooks.cpp` file - hooks are in individual modules.

---

## 12. Actual Module Structure Summary

**Key Differences from Original Spec:**

1. **Flat Structure**: All modules in `azerothcore/modules/mortal_overhaul/src/` (not organized subdirectories)
2. **Naming Variations**: Some modules have different names (e.g., `MortalStats` vs `MortalCoreStats`)
3. **Split Modules**: Some systems split into multiple files (e.g., Warfronts split into State and Engine)
4. **Distributed Functionality**: Some features (broadcasts, UI feeds, admin tools) distributed across modules rather than dedicated files
5. **Additional Modules**: Many modules exist that weren't in original spec (e.g., `MortalBraceMechanic`, `MortalFlask`, `MortalTaskBoard`, etc.)

**Complete Module List:**

The actual codebase contains 200+ modules. Key ones include:
- Core: `MortalLevel`, `MortalStats`, `MortalCombatSkills`, `MortalCraftingSkills`, `MortalGatheringSkills`
- Factions: `MortalFactions`, `MortalBountyBoard`
- Economy: `MortalRegionalBank`, `MortalMarketStalls`, `MortalInsurance`
- War: `MortalStrongholdSystem`, `MortalSiegeWindow`, `MortalSiegeController`, `MortalWarfrontState`, `MortalWarfrontEngine`
- World: `MortalAnomalies`, `MortalRifts`, `MortalHellgates`, `MortalWorldBossEvents`, `MortalMidnightHorde`
- Assets: `MortalLivingMounts`, `MortalPets`, `MortalMercenaryBroker`, `MortalUtilityCompanions`
- Social: `MortalRadioSilence`, `MortalTitleSystem`
- And many more...

---

This index has been updated to reflect the **actual implementation structure**. It should be kept up-to-date as modules are implemented, and referenced at the top of each spec doc section so Cursor knows **which files to touch** when implementing or changing a system.
