# Project Canvas: Mortal Warcraft Overhaul  
### File: 98-mortal-siege-prep-contracts.md  
### Topic: Siege Preparation Contracts & War Economy Hooks

> This document defines **Task Board content specifically tied to sieges**:  
> how Contracts influence the outcome of a Stronghold Siege before and during the battle,  
> and how this keeps the economy, crafters, and non-frontline players deeply involved.

---

## 1. Design Goals

1. Make sieges **realm-wide projects**, not just 40 people fighting at the fortress:
   - Crafters, traders, scouts, and small PvP groups all have relevant tasks.

2. Tie Task Boards directly into:
   - Stronghold defence level,
   - Siege engine availability,
   - Strategic intel (Atlas updates).

3. Ensure **player-money-generating tasks**:
   - Participating in war prep is a reliable way to earn:
     - Gold,
     - Standing,
     - Military Credits,
     - Crafting demand.

Implementation bias:
- Siege prep logic in C++ (`MortalSiegePrepManager`),
- Contract templates in DB,
- Specific tasks implemented via Lua where needed.

---

## Related Specs

For full context on siege preparation contracts, see:

- **`92-mortal-warfronts-siege-flow.md`** — Siege flow system that prep contracts support
- **`95-wintergrasp-to-mortal-siege-adaptation.md`** — Siege adaptation and mechanics that prep affects
- **`08-guilds-sovereignty.md`** — Stronghold system that prep contracts defend
- **`76-dynamic-tasks-and-contracts-2-0-spec.md`** — Core contract system that prep contracts extend
- **`37-economy-system-extensions.md`** — Economy system that prep contracts feed into
- **`51-factions-and-standing-system.md`** — Faction standing rewards from prep contracts
- **`05-crafting.md`** — Crafting system that produces siege supplies

---

## 2. Systems Overview

### 2.1 Core Components

- **Siege Events**:
  - Exposed by `MortalSiegeController`:
    - `SIEGE_ANNOUNCED(strongholdId)`,
    - `SIEGE_IMMINENT(strongholdId)`,
    - `SIEGE_STARTED(strongholdId)`,
    - `SIEGE_ENDED(strongholdId)`.

- **Task Board Generator**:
  - `MortalSiegePrepManager` listens to siege events,
  - Spawns **Siege Prep Contracts** on relevant Task Boards.

- **Stronghold Siege Stats**:
  - Each Stronghold stores:
    - `defense_preparedness` (0–100),
    - `attacker_preparedness` (0–100),
    - `supply_stockpile` (resources collected),
    - `intel_level` (for Atlas & war UI).

Contracts completed adjust these values, which in turn affect the battle.

---

## 3. Contract Categories

### 3.1 Supply & Construction Contracts

**Defender-focused**:

Examples:

1. **Stone for the Walls**
   - Board: Frontier / Stronghold Task Board.
   - Objective:
     - Deliver X units of Stone/Metal to the Stronghold quartermaster.
   - Effect:
     - +Defence Preparedness,
     - Increases wall HP or reduces siege damage taken by a small amount.
   - Rewards:
     - Gold, Frontier Standing, crafting XP.

2. **Timber for Siege Platforms**
   - Objective:
     - Deliver Wood/Planks.
   - Effect:
     - More defensive siege engines available,
     - Extra arrow slits, barricades, etc.

3. **Rations for the Garrison**
   - Objective:
     - Deliver food supplies.
   - Effect:
     - Reduces respawn fatigue penalties,
     - Increases defender stamina buff (small combat regen).

**Attacker-focused** variants:

- Same categories, but for the attacker camp:
  - Supplies determine:
    - Number of siege vehicles available,
    - Buffs for attacking forces.

---

### 3.2 Armament & Crafting Orders

Creates demand for crafted items:

1. **Forge Order: Ballista Bolts**
   - Craft or gather specific items (bolts, arrows, bombs),
   - Turn in at War Camp.
   - Effect:
     - Enables or buffs certain siege engines or defensive turrets.

2. **Armor Reinforcement Kits**
   - Crafted kits turned in:
     - Slightly boosts base armor of defenders or attackers (pre-battle buff).

3. **Alchemical Wards**
   - Turn in potions/wards:
     - Reduces damage from specific siege attacks or magic types.

---

### 3.3 Intel & Scouting Contracts

1. **Scout Enemy Rally Points**
   - Objective:
     - Travel to designated locations near enemy territory,
     - Use a “Scout’s Mark” item to tag the area.
   - Effect:
     - Increases `intel_level` for defender/attacker,
     - Atlas gains improved estimates of:
       - Enemy numbers,
       - Direction of attack,
       - Rough composition (melee/ranged/vehicles).

2. **Map the Terrain**
   - Objective:
     - Explore specific subzones around the Stronghold with a surveying tool.
   - Effect:
     - Unlocks alternate flank routes during siege,
     - Begins to reveal terrain overlays in MortalUI (shortcuts, choke points).

3. **Intercept Enemy Couriers**
   - PvP Contract:
     - Kill NPC couriers or player-flagged couriers running supplies to the enemy.
   - Effect:
     - Reduces enemy `supply_stockpile`,
     - May grant rare intel items (plans, orders).

---

### 3.4 Sabotage & Special Ops (Higher Risk)

1. **Sabotage the Workshops**
   - Objective:
     - Infiltrate enemy-controlled workshops in the open world,
     - Use a “Saboteur’s Charge” item.
   - Effect:
     - Reduces available siege engines at siege start,
     - Or applies initial damage to walls/towers.

2. **Poison the Storehouses**
   - Objective:
     - Reach enemy supply depots,
     - Use special item to corrupt food/stock.
   - Effect:
     - Applies debuffs to enemy forces in the siege (lower stamina, regen).

3. **Assassinate Enemy Captains**
   - Elite Contract:
     - Kill a specific commander NPC in enemy territory,
     - High difficulty, may require a small group.
   - Effect:
     - Reduces enemy morale (small stat debuffs),
     - Increases Frontier Standing & war-based titles.

---

## 4. Siege Stat Effects

`MortalSiegePrepManager` maintains simple numeric metrics:

- `defense_preparedness` (0–100)
- `offense_preparedness` (0–100)
- `intel_level_def` / `intel_level_off`
- `supply_stockpile_def` / `supply_stockpile_off`

At siege start, it applies modifiers:

- High **defense_preparedness**:
  - +X% wall HP,
  - +Y% tower damage,
  - Extra defensive NPCs.

- High **offense_preparedness**:
  - More initial siege vehicles,
  - Lower vehicle build cost/time,
  - Offensive buff aura near engines.

- High **intel_level**:
  - Better MortalUI siege intel (estimated enemy sizes),
  - Access to extra flanking routes or surprise events.

- High **supply_stockpile**:
  - Extra war consumables,
  - Faster respawn buffs for the side.

These values are **clamped** to prevent runaway snowballing (e.g., max ±20% from baseline).

---

## 5. Economic Hooks

### 5.1 Gold Flow

- All siege prep Contracts:
  - Pay **gold** and **Standing** on completion.
- This:
  - Creates ongoing “player money generating tasks”,
  - Binds economy health to war activity,
  - Prevents purely passive stockpiling.

### 5.2 Crafting Demand

Crafting professions feed into Contracts:

- Blacksmiths:
  - Weapons, armor kits, siege parts.
- Engineers:
  - Explosives, siege components.
- Alchemists:
  - Wards, flasks, bombs.
- Gatherers:
  - Fuel, timber, ores.

Strongholds actively consume these items, generating **recurring demand** instead of one-off spikes.

---

## 6. Task Board Integration

### 6.1 Which Boards Show Siege Prep?

The following boards react when a siege is scheduled/announced:

- **Stronghold Board** (local to Stronghold),
- **Frontier Boards** in nearby zones,
- **Civic Boards** in capital cities (high-level contracts, e.g., large supply orders).

Range:

- The closer the board to the Stronghold, the more **high-impact** siege prep tasks appear.

### 6.2 Lifecycle

- On `SIEGE_ANNOUNCED`:
  - Spawn long-duration prep Contracts:
    - Gather/craft/deliver over the next hours/days.

- On `SIEGE_IMMINENT`:
  - Spawn short-duration high-urgency Contracts:
    - Final supply runs,
    - Emergency scouting.

- On `SIEGE_STARTED`:
  - Spawn limited-time battlefield-support Contracts (if feasible):
    - Kill X enemies near specific flank (dangerous),
    - Escort war mules.

- On `SIEGE_ENDED`:
  - Mark Contracts as expired or convert into:
    - “Aftermath” Contracts (cleanup, repair, scavenging).

---

## 7. Standing & Titles

Participation in siege prep can grant:

- Frontier Standing:
  - For defensive/offensive supplies and Contracts in frontier zones.
- Civic Standing:
  - Completing government-sanctioned contracts from civic boards,
  - Large shipments for city governments.

Titles (examples):

- `the Quartermaster` – after contributing large total value of supplies.
- `Siegebreaker` / `Bulwark of Wintergrasp` – combined prep + direct siege result.

---

## 8. Implementation Sketch

### 8.1 C++ Manager

`src/server/game/Mortal/War/MortalSiegePrepManager.*`

Responsibilities:

- Subscribe to `MortalSiegeController` events,
- Track per-Stronghold prep metrics,
- Trigger Contract template activation/deactivation,
- Compute siege modifiers at battle start.

### 8.2 DB & Lua

- DB:
  - `mortal_contract_templates`:
    - Type, category, board, required items, rewards, siege flags.
- Lua:
  - For custom Contract scripts:
    - Intercept deliveries,
    - Apply metric changes via C++ API calls.

---

## 9. Summary

Siege Prep Contracts ensure that:

- War is not just about **who shows up on siege night**:
  - It’s about days of preparation, supply trails, crafting, scouting, sabotage.
- Non-frontline players have **meaningful, rewarded roles**:
  - Economic play, logistics, and intel all feed directly into battlefield performance.
- The **economy stays active and purpose-driven**:
  - Gold and item flows always have a reason beyond grinding for its own sake.

This plugs **Task Boards, crafting, Standing, Strongholds, and sieges** into one coherent war economy loop.
