# Project Canvas: Mortal Warcraft Overhaul
### Version 27.5 — Hybrid Technical Design Document  
### File: 37-economy-system-extensions.md  
### Section: Economy Extensions (Task Boards, Buy Orders, Hot Zones, Decay Tiers, Upkeep, Blessed Items)

---

## 1. Purpose

Extend the existing Mortal Warcraft economy with systems that:

- Keep **gold and goods flowing** at all tiers.
- Provide **evergreen, low-friction money-making tasks**.
- Prevent the game from becoming top-heavy or economically stale.
- Encourage participation in **risky content** without causing unrecoverable wipeouts.

This doc defines 8 features:

1. Task Boards as primary money engine (refinement + expansion).
2. NPC Buy Orders (Town Requests).
3. Rotating Regional Economic Bonuses (“Hot Zones”).
4. Tiered Durability & Early-Game Safety.
5. Minimum payout rules for Dungeons, BGs, Arenas, Warfronts.
6. Stronghold Upkeep & Decay.
7. City Odd Jobs & Tavern Economy.
8. Blessed Items (Soft Insurance System).

All are additive on top of previous specs (loot rework, Strongholds, Warfronts, etc.).

---

## Related Specs

For full context on economy extensions, see:

- **`04-economy.md`** — Core economy system that these extensions build upon
- **`10-crafting-economy.md`** — Crafting economy that interacts with buy orders and task boards
- **`76-dynamic-tasks-and-contracts-2-0-spec.md`** — Task Board system architecture referenced throughout
- **`05-crafting.md`** — Crafting system that uses blessed items and interacts with economy extensions
- **`03-risk-zones.md`** — Risk tiers that affect hot zones and task board payouts
- **`08-guilds-sovereignty.md`** — Stronghold upkeep and decay systems
- **`06-pve.md`** — PvE content that provides minimum payouts

---

## 2. Task Boards as Primary Money Engine

### 2.1 Concept

Task Boards become the **main day-to-day PvE money generator**, offering:

- Always-available, procedurally generated tasks.
- Multiple risk tiers (Green / Yellow / Red).
- Payouts tuned to make:
  - Safe tasks modestly rewarding.
  - Risky tasks *clearly* better in expected value.

### 2.2 Risk Tiers

Define 3 standard tiers per board:

- **T_G** (Green) – Safe:
  - Tasks operate within Green Zones.
  - Minimal or no PvP risk.
- **T_Y** (Yellow) – Contested:
  - Tasks require entering Yellow Zones.
  - Criminal flag risk and moderate PvP threat.
- **T_R** (Red) – High Risk:
  - Tasks require entering/traversing Red Zones.
  - Full loot risk.

### 2.3 Task Types

Each board can generate tasks in several templates:

1. **Hunt Task**
   - Objective: Kill N creatures of type X in zone Y.
   - Variants:
     - Normal mobs, elites, alpha variants.
   - Rewards:
     - Gold,
     - Chance at bonus mats.

2. **Gather Task**
   - Objective: Collect N units of resource R (herbs, ore, hides).
   - Source:
     - Gathered from nodes or looted off mobs (configurable).
   - Rewards:
     - Gold,
     - Small lump sum of related crafting mats.

3. **Delivery Task (Local)**
   - Objective: Carry a crate from NPC A to NPC B within the same region.
   - Crate is an item in player bags with weight (ties to encumbrance).
   - Rewards:
     - Gold,
     - Chance for city reputation.

4. **Courier Task (Inter-Region)**
   - Objective: Move item(s) from City/Bank A to City/Bank B.
   - Uses same crate mechanics, but spawns crate in origin bank.
   - Rewards:
     - Higher gold proportional to distance and risk tier.

5. **Escort Task**
   - Objective: Escort an NPC caravan from point A to B.
   - NPC path can be configured to pass through Yellow or Red zones.
   - Rewards:
     - Gold,
     - Potential reputation with local factions.

### 2.4 Task Board Data Schema

#### 2.4.1 Task Definitions

```sql
CREATE TABLE IF NOT EXISTS mortal_tasks_def (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  code            VARCHAR(64) NOT NULL,        -- 'HUNT_BOARS_ELWYNN_TG'
  type            VARCHAR(16) NOT NULL,        -- 'HUNT','GATHER','DELIVER','COURIER','ESCORT'
  risk_tier       VARCHAR(8) NOT NULL,         -- 'T_G','T_Y','T_R'
  min_skill_band  INT NOT NULL DEFAULT 0,      -- e.g., required approx Mortal level or skill total
  max_skill_band  INT NOT NULL DEFAULT 999,
  zone_id         INT NOT NULL,                -- primary zone
  param1          INT NULL,                    -- creature entry, item entry, etc.
  param2          INT NULL,                    -- count, crate weight, etc.
  base_gold       INT NOT NULL DEFAULT 0,      -- base payout at design time
  base_fame       INT NOT NULL DEFAULT 0,      -- optional rep/fame metric
  flags           INT NOT NULL DEFAULT 0,      -- reserved for future use
  notes           VARCHAR(255) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

#### 2.4.2 Task Instances

```sql
CREATE TABLE IF NOT EXISTS mortal_tasks_instance (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  def_id          INT NOT NULL,          -- FK to mortal_tasks_def
  hub_npc_entry   INT NOT NULL,          -- which Task Board NPC advertises it
  state           TINYINT NOT NULL DEFAULT 0,  -- 0=available,1=claimed,2=completed,3=expired
  assigned_guid   INT NULL,              -- characters.guid if claimed
  created_time    INT NOT NULL,
  expire_time     INT NOT NULL,
  reward_gold     INT NOT NULL,
  reward_fame     INT NOT NULL,
  reward_bonus    VARCHAR(64) NULL       -- optional: item reward code bundle
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

Task instances are refreshed as they are taken/expired to maintain:

- At least N tasks **per risk tier** per hub.

### 2.5 Reward Scaling Rules

Design guidelines:

- Let `G_safe` be target gold/hr for safe Green tasks.

Then approximate:

- **Green (T_G)**:  
  Reward tuned so completing 2–3 tasks/hr yields ~`G_safe`.
- **Yellow (T_Y)**:  
  Reward tuned for ~`2 * G_safe` expected value/hr.
- **Red (T_R)**:  
  Reward tuned for ~`3–4 * G_safe` expected value/hr, amortizing occasional deaths.

Use simple multipliers at generation time:

- `reward_gold = base_gold * risk_mult * distance_mult * difficulty_mult`.

---

## 3. NPC Buy Orders (Town Requests)

### 3.1 Concept

Cities and towns place **NPC-funded buy orders** for specific materials, ensuring:

- Constant outlets for mats → gold.
- Regional economic variation (some cities crave certain materials more).

### 3.2 Buy Order Schema

```sql
CREATE TABLE IF NOT EXISTS mortal_buy_orders (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  hub_npc_entry   INT NOT NULL,          -- request board or quartermaster NPC
  item_entry      INT NOT NULL,          -- item_template.entry required
  quantity_total  INT NOT NULL,          -- total desired
  quantity_fulfilled INT NOT NULL DEFAULT 0,
  price_per_unit  INT NOT NULL,          -- in copper
  region_code     VARCHAR(32) NOT NULL,  -- internal region identifier
  expires_time    INT NOT NULL,
  flags           INT NOT NULL DEFAULT 0, -- e.g., 1 = high priority
  notes           VARCHAR(255) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

Players interact via:

- NPC gossip: “Turn in materials for Town Requests.”
- Server checks:
  - Player’s inventory for item_entry.
  - Remaining quantity on order.
  - Pays `price_per_unit` * quantity turned in.

### 3.3 Generation Logic

A simple scheduler:

- Every X hours, per region:
  - Spawn Y buy orders for:
    - Common materials (cloth, ore, herbs),
    - With modest multipliers (~1.2x–1.5x vendor price).
  - Occasionally spawn:
    - High-priority orders with ~2x–3x vendor price for key mats.

---

## 4. Rotating Regional Economic Bonuses (“Hot Zones”)

### 4.1 Concept

Weekly or daily, declare certain regions as **economic hot spots**:

- Bonus rewards for:
  - Completing tasks from that region’s Task Board.
  - Fulfilling buy orders.
  - Running courier contracts starting/ending there.

### 4.2 Schema

```sql
CREATE TABLE IF NOT EXISTS mortal_regional_bonuses (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  region_code     VARCHAR(32) NOT NULL,
  bonus_type      VARCHAR(32) NOT NULL,   -- 'TASK_GOLD','BUYORDER_PRICE','COURIER_GOLD'
  multiplier      FLOAT NOT NULL,         -- e.g. 1.3 for +30%
  start_time      INT NOT NULL,
  end_time        INT NOT NULL,
  notes           VARCHAR(255) NULL,
  UNIQUE KEY uk_region_type_time (region_code, bonus_type, start_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

Task, buy-order, and courier logic consult this table to apply multipliers.

A global announcer (and later, Mortal Atlas web portal) shows current hot zones.

---

## 5. Tiered Durability & Early-Game Safety

### 5.1 Tiered Durability Rules

We refine the durability / decay system:

- **T1 Gear** (low-level)
  - Max durability loss per repair: **0–5%**.
  - High base durability.
- **T2–T3 Gear**
  - Max durability loss per repair: ~10% (current plan).
- **T4–T5 Gear**
  - Max durability loss per repair: 10–15%.
  - Higher base durability but bigger stakes.

Implementation:

- Use a `mortal_item_tiers` mapping table (extends gear tier specs) to know which items are T1–T5.
- Modify repair logic (C++ or script) to apply tier-based decay.

### 5.2 Starter Safety Net (Mentor)

Add logic to the Mentor NPC in Green zones:

- On interact, check:
  - If player’s gear slots + gold fall below a threshold (e.g. no weapon, no chest, < X gold).
- Offer:
  - A once-per-day **Starter Refit**:
    - Basic weapon,
    - Simple armor set,
    - Very low-value items (T0/T1 only).

This ensures players are never truly “bricked” economically.

---

## 6. Minimum Payout Guidelines for Core Activities

This section defines **design constraints** for gold/tokens entering the game.

### 6.1 Target Baselines

Rough guidelines (actual numbers filled during tuning):

- Let `G_safe` be safe Green task gold/hr.

Then:

- M-T1/M-T2 Dungeons:
  - At least `≈ G_safe` in gold + tradeable mats per hour.
- Classic BGs (non-Warfront):
  - Similar to M-T1/M-T2 dungeons for average win/loss ratio.
- Arenas:
  - Weekly PvP Token payouts at low/mid rating sufficient to:
    - Acquire a full P2/P3 set over a season with consistent play.
- Warfronts:
  - Winners: large shipments + currencies.
  - Losers: enough credits/tokens to make queueing again feel productive.

### 6.2 Implementation Note

No explicit new tables required here; this is a **design rule** that should be documented for tuning and QA.

---

## 7. Stronghold Upkeep & Decay

### 7.1 Concept

Strongholds require **ongoing upkeep** to maintain their passive generation and defenses. If upkeep fails, strongholds:

- Degrade in tier.
- Produce fewer resources.
- Become easier to capture.

### 7.2 Schema Additions

Extend existing stronghold schema with upkeep:

```sql
CREATE TABLE IF NOT EXISTS mortal_stronghold_upkeep (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  stronghold_id   INT NOT NULL,      -- FK to stronghold master table
  upkeep_gold     INT NOT NULL,      -- gold required per cycle
  upkeep_mats     VARCHAR(255) NULL, -- e.g. 'IRON_BAR:200;STONE:300'
  cycle_seconds   INT NOT NULL,      -- e.g. 604800 for weekly
  last_cycle_time INT NOT NULL,
  missed_cycles   INT NOT NULL DEFAULT 0,
  status          TINYINT NOT NULL DEFAULT 0  -- 0=stable,1=weakened,2=decaying
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

Upkeep processing:

- Every `cycle_seconds`:
  - Check stronghold chest/bank for required gold + materials.
  - If present:
    - Deduct and reset `missed_cycles`.
  - If missing:
    - Increment `missed_cycles`.
    - After N missed cycles:
      - Lower stronghold tier or mark as vulnerable to auto-neutralization.

---

## 8. City Odd Jobs & Tavern Economy

### 8.1 City Odd Jobs

Use the same underlying **task system** but with:

- Type: `CITY_JOB`.
- Risk tier: `T_G` only.
- Very short, low-paying tasks around capitals.

Examples:

- Deliver packages between districts.
- Sweep critters / kill pests in sewers.
- Fetch food/drink from taverns to NPCs.

Odd jobs are:

- Infinite,
- Simple,
- Low stress,
- Designed mainly for:
  - Social players,
  - People idling in cities.

### 8.2 Tavern Games Enhancements

Existing tavern game hooks (dice/cards) extended with:

- **House Rake**:
  - A small cut of each wager goes to “the house.”
- **Tavern Patron Progression**:
  - Track tavern game wins per character.
  - Award:
    - Small gold drip from house over time (as “comps”),
    - Cosmetic toys/titles (see Achievements spec).

Schema addition for tavern stats is optional but straightforward.

---

## 9. Blessed Items (Soft Insurance System)

### 9.1 Concept

Players may “bless” a limited number of items to **protect them from dropping on death** in Red Zones, at a cost:

- Blessed items:
  - Do not drop on death (corpse chest).
  - Suffer **increased durability loss** or **higher repair costs**.
- Blessing:
  - Costs gold (and optionally a rare mat).
  - Has limited duration or charges.

This encourages players to bring **some valuable gear** into Red Zones without risking total wipeouts, while still preserving decay and gold sinks.

### 9.2 Schema: Blessed State

```sql
CREATE TABLE IF NOT EXISTS mortal_blessed_items (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  guid            INT NOT NULL,         -- characters.guid
  item_guid       INT NOT NULL,         -- item_instance.guid or equivalent
  bless_end_time  INT NOT NULL,         -- unix time when blessing expires
  max_deaths      INT NOT NULL,         -- optional: number of deaths blessing covers
  deaths_used     INT NOT NULL DEFAULT 0,
  flags           INT NOT NULL DEFAULT 0, -- e.g. type of blessing
  UNIQUE KEY uk_guid_item (guid, item_guid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 9.3 Rules

- **Access**:
  - Blessings applied at Shrines / Priests in Green/Yellow zones.
- **Limits**:
  - Only 1–2 items per character may be blessed at a time.
- **Cost**:
  - Scales with item tier (T2<T3<T4<T5).
  - Paid in gold, optionally plus rare “Blessing Reagents.”

### 9.4 On-Death Logic

When a player dies in a Red Zone:

1. Determine items that would normally drop to corpse chest.
2. For each item:
   - If it has a valid, active blessing entry in `mortal_blessed_items`:
     - **Do not drop** it to corpse.
     - Increment `deaths_used` and/or check time.
     - Apply extra durability penalty.
     - If `deaths_used >= max_deaths` or `bless_end_time < now`:
       - Remove blessing entry.
   - Else:
     - Drop as usual.

---

## 10. Status & Integration

These economy extensions:

- Are **fully compatible** with existing Mortal specs:
  - Regional banking, market stalls, couriers, full loot rules.
  - Strongholds & Warfronts.
  - PvP vendors & currencies.
- Require:
  - Additional SQL tables as defined above.
  - Lua/C++ hooks in:
    - Task Board logic,
    - Repair/durability handling,
    - Death/loot logic,
    - Stronghold tick processing,
    - Shrine/Priest gossip (for blessings),
    - Tavern games and city job tasks.

Cursor can now:

- Use this doc (`37-economy-system-extensions.md`) plus previous economy specs to:
  - Generate SQL migrations,
  - Scaffold Lua scripts (`MortalTaskBoard.cpp/h` (C++ implementation), `buy_order_system.lua`, `regional_bonus_manager.lua`, etc.),
  - Implement the blessed item checks and upkeep processors.
