# Project Canvas: Mortal Warcraft Overhaul
### Version 26.1 — Hybrid Technical Design Document  
### File: 13-caravans-contracts.md  
### Section: Caravans, Courier Contracts, Ambush Logic, Collateral Systems & Regional Trade Networks

---

# 1. Overview

Caravans & Contracts form the economic backbone of Mortal Warcraft’s **regional trade network**, inspired by:

- EVE Online hauling  
- Albion Online caravans  
- Red Dead Online wagon physics  
- Mortal Online pack animal hauling  
- WoW Classic world geography  

These systems make **travel matter**, add **high-stakes trade risk**, and create **organic PvP hotspots**.

This document defines:

- Courier contracts  
- Caravan wagons  
- Pack animals  
- Ambush logic  
- Collateral systems  
- Trade routes  
- Regional markets  
- Escort incentives  

---

## Related Specs

For full context on caravan and contract systems, see:

- **`04-economy.md`** — Regional banking and market systems that caravans connect
- **`03-risk-zones.md`** — Risk tiers that affect caravan routes and ambush mechanics
- **`02-combat.md`** — Combat mechanics used in caravan ambushes and escort encounters
- **`11-pvp-systems.md`** — PvP systems and criminal logic that apply to caravan attacks
- **`76-dynamic-tasks-and-contracts-2-0-spec.md`** — Contract system architecture and task templates
- **`58-world-contracts-and-map-pins.md`** — World contract system and map integration
- **`51-factions-and-standing-system.md`** — Faction standing that affects contract availability and rewards

---

# 2. Courier Contract System

## 2.1 Purpose
Allows players to hire others to transport goods across zones.

## 2.2 Contract Types
1. **Delivery Contract**
   - Deliver crate from City A → City B  

2. **Pickup Contract**
   - Retrieve crate from wilderness → return to city  

3. **Escort Contract**
   - Protect caravan for payment  

## 2.3 Contract Fields
```
contract_id
owner_guid
courier_guid
origin_zone
destination_zone
item_container_id
collateral_amount
reward_amount
deadline
status
```

SQL:
- `schema_courier_contracts.sql`

Lua:
- `MortalCourierContracts.cpp/h` (C++ implementation)

---

# 3. Collateral System (Anti-Scam Protection)

When accepting a contract, courier must pay **Collateral**.

### Collateral protects the customer:
- If courier **fails** → owner receives collateral  
- If courier **succeeds** → courier is refunded collateral + gets reward  

Prevents griefing & theft.

---

# 4. Contract Crates

## 4.1 Crate Rules
- Cannot open crate  
- Cannot inspect contents  
- Adds **weight** and slows the courier  
- Crate binds to courier until delivery  

Crates are special items stored in:
- `contract_crates.sql`

---

# 5. Caravan Wagons

## 5.1 Anatomy of a Caravan
A caravan consists of:

- **1 Wagon Vehicle**
- **1–2 Pack Animals (oxen/mules)**
- **1 Driver (player)**
- **Optional escorts (players)**

Wagons are slow, heavy, and highly visible.

## 5.2 Wagon Stats
```
max_speed
turn_rate
stamina_pool
armor
cargo_slots
visibility_radius
```

SQL:
- `caravan_wagon_stats.sql`

---

# 6. Caravan Movement Logic

Wagons use **damped physics** rather than instant turning:

- Slow acceleration  
- Slow turning  
- Heavy braking  
- Cannot traverse steep slopes  
- Cannot enter buildings  

### 6.1 Caravan Movement Speed Formula

Caravan movement speed is calculated as:

```
CaravanSpeed = BaseSpeed * CargoPenalty * TerrainModifier * RoadBonus * HealthModifier
```

**Base Speed:**
- **Default Base Speed**: 2.0 yards/second (walking speed, ~50% of normal player run speed)
- Configurable per wagon type via `caravan_wagon_stats.max_speed`
- Wagons are inherently slow due to weight and size

**Cargo Penalty:**
```
CargoPenalty = 1.0 - (CurrentCargoWeight / MaxCargoCapacity) * 0.5
// Maximum 50% speed reduction at full capacity
```

Where:
- **CurrentCargoWeight**: Total weight of items in wagon cargo slots
- **MaxCargoCapacity**: Maximum cargo capacity of the wagon (from `caravan_wagon_stats.cargo_slots`)
- **Penalty Range**: 1.0 (empty) to 0.5 (full capacity)

**Terrain Modifier:**
- **Roads/Paths**: 1.0 (no penalty)
- **Grass/Plains**: 0.9 (10% slower)
- **Hills/Mountains**: 0.7 (30% slower)
- **Swamp/Mud**: 0.6 (40% slower)
- **Steep Slopes**: 0.0 (cannot traverse)

**Road Bonus:**
- **On Road**: +0.2 (20% speed bonus, stacks with terrain)
- **Off Road**: 0.0 (no bonus)
- Roads provide better traction and smoother travel

**Health Modifier:**
- **Wagon Health > 75%**: 1.0 (no penalty)
- **Wagon Health 50-75%**: 0.9 (10% slower)
- **Wagon Health 25-50%**: 0.8 (20% slower)
- **Wagon Health < 25%**: 0.6 (40% slower, critical condition)

### 6.2 Speed Calculation Examples

**Example 1: Empty Wagon on Road**
```
BaseSpeed = 2.0
CargoPenalty = 1.0 (empty)
TerrainModifier = 1.0 (road)
RoadBonus = 1.2
HealthModifier = 1.0 (full health)
CaravanSpeed = 2.0 * 1.0 * 1.0 * 1.2 * 1.0 = 2.4 yards/second
```

**Example 2: Half-Loaded Wagon Off-Road**
```
BaseSpeed = 2.0
CargoPenalty = 1.0 - (0.5 * 0.5) = 0.75 (50% cargo = 25% penalty)
TerrainModifier = 0.9 (grass)
RoadBonus = 1.0 (no road)
HealthModifier = 1.0
CaravanSpeed = 2.0 * 0.75 * 0.9 * 1.0 * 1.0 = 1.35 yards/second
```

**Example 3: Fully Loaded Wagon, Damaged, on Road**
```
BaseSpeed = 2.0
CargoPenalty = 0.5 (full capacity)
TerrainModifier = 1.0 (road)
RoadBonus = 1.2
HealthModifier = 0.8 (50% health)
CaravanSpeed = 2.0 * 0.5 * 1.0 * 1.2 * 0.8 = 0.96 yards/second
```

### 6.3 Movement Restrictions

**Cannot Traverse:**
- Steep slopes (>45 degree incline)
- Buildings/interiors
- Water (unless bridge/ferry)
- Narrow passages (wagon too wide)

**Movement Penalties:**
- Turning: Slow turn rate (damped physics)
- Acceleration: Gradual speed increase (not instant)
- Braking: Heavy braking (takes time to stop)
- Reversing: 50% of forward speed

Lua:
- `MortalCaravanMovement.cpp/h` (C++ implementation)

---

# 7. Ambush Logic

Caravans naturally create ambush opportunities.

## 7.1 Ambush Triggers
Ambush AI mobs (bandits) spawn when:
- Caravan passes through high-risk points  
- Weather events occur  
- Zone simulation detects “hot trade routes”  

Lua:
- `MortalAmbushSpawner.cpp/h` (C++ implementation)

## 7.2 Player Ambushes
Red zones:
- Full loot  
- Players can steal crate  
- Caravan drops **Caravan Chest** with all contents  

Yellow zones:
- Attacker becomes criminal  
- Criminal drops all gear on death  

---

# 8. Escort Incentives

Escorts gain:
- Escort merit points  
- Bonus gold  
- Reputation with trade factions  
- Chance at special caravan reward crates  

This encourages group transport.

---

# 9. Smuggler Routes (Outlaw Exclusive)

Outlaws gain access to secret tunnels/routes:

- Hidden passages  
- Abandoned mines  
- Backdoor exits  
- High-risk, high-reward paths  

Used for:
- Illegal goods  
- Stolen items  
- Black market deliveries  

Lua:
- `smuggler_routes.lua`

---

# 10. Pack Animals (Mules & Oxen)

Pack animals support caravan hauling.

## 10.1 Stats
```
carry_capacity
panic_threshold
speed
durability
temperament
```

Pack animals follow wagon movement logic.

Lua:
- `pack_animal_handler.lua`

---

# 11. Trade Routes (Regional Market Loop)

Trade networks form naturally:

### Example Loop:
1. Tanaris → Gadgetzan (Ore supply)
2. Transport ore to Ironforge (Crafting demand)
3. Sell on Ironforge market
4. Buy crafted gear
5. Transport gear to STV (PvP demand)

Trade flows follow:
- Resource zones  
- Crafting hubs  
- PvP hotspot demand  
- Seasonal bonuses  
- Stronghold territory control  

---

# 12. Route Risk Levels

Routes assigned risk colors:

- **Green Route** – Safe, low reward  
- **Yellow Route** – Moderate reward  
- **Red Route** – Maximum reward, full loot  

---

# 13. Caravan Upgrades

Caravan upgrades include:

- Reinforced wheels  
- Heavy armor plating  
- Faster pack animals  
- Magical lantern (visibility boost)  
- Decoy wagon (consumes to fake caravan)  

Crafted using specific BPCs.

SQL:
- `caravan_upgrades.sql`

---

# 14. Caravan Events

Dynamic world events featuring caravans:

### 14.1 Merchant Convoy
NPC-led convoy  
Players may escort for rewards  

### 14.2 Smuggler Convoy
Outlaw NPC convoy  
Outlaws may assist; others may attack  

### 14.3 Siege Supply Caravan
Guild-owned caravan delivers siege materials  
Enemy guilds can ambush to cripple siege efforts  

Lua:
- `caravan_event_controller.lua`

---

# 15. Caravan Respawn Logic

If caravan is destroyed:
- Crate drops  
- Pack animals drop carcasses  
- Wagon disappears  
- Courier fails contract  

A replacement caravan requires:
- New wagon  
- New animals  
- New contract crate  

---

# 16. Integration With Other Systems

Caravans interact heavily with:

- PvP risk tiers  
- Bounty system  
- Notoriety system  
- Guild sovereignty  
- Material economy  
- Extraction PvP  
- Pack animal breeding  
- World seasonal states  

This is one of the game's **core retention and tension systems**.

---

# 17. Implementation Summary

## 17.1 Lua Files
- `MortalCourierContracts.cpp/h` (C++ implementation)
- `MortalCaravanMovement.cpp/h` (C++ implementation)
- `MortalAmbushSpawner.cpp/h` (C++ implementation)
- `caravan_event_controller.lua`
- `pack_animal_handler.lua`
- `smuggler_routes.lua`

## 17.2 SQL Files
- `schema_courier_contracts.sql`
- `contract_crates.sql`
- `caravan_wagon_stats.sql`
- `caravan_upgrades.sql`

## 17.3 C++ Files
- `CaravanHooks.cpp`
- `ContractHooks.cpp`
- `AmbushLogic.cpp`

---

# 18. Status
Caravans & Contracts are **Core** and define the living regional economy and risk-based travel of Mortal Warcraft.

