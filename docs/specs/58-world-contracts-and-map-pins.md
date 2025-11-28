# Project Canvas: Mortal Warcraft Overhaul
### Version 36.0 — Hybrid Technical Design Document  
### File: 58-world-contracts-and-map-pins.md  
### Section: World Contracts & Map-Wide Objectives

---

## 1. Purpose

Add a **World Quest / map-wide objective** layer inspired by post-3.3.5 WoW “World Quests” and Legion-style map pins, tailored for Mortal Warcraft’s:

- Risk-zoned world (Green / Yellow / Red),
- Task Boards, Contracts, Rifts, Invasions, Hellgates,
- Faction systems and Season Track.

Goals:

- Give players a **“map of opportunities”** instead of linear quest hubs.
- Make the world feel **busy and reactive** without theme-park queues.
- Keep everything rooted in:
  - Contracts, economy, events,
  - Risk vs reward zoning.

---

## Related Specs

For full context on world contracts and map systems, see:

- **`76-dynamic-tasks-and-contracts-2-0-spec.md`** — Core contract and task system that world contracts extend
- **`13-caravans-contracts.md`** — Caravan contracts that appear as world contracts
- **`24-webportal-mortal-atlas.md`** — Atlas web portal that displays map pins
- **`15-ui-client.md`** — UI system that displays map pins and contract information
- **`03-risk-zones.md`** — Risk zones that affect contract placement and rewards
- **`51-factions-and-standing-system.md`** — Faction system that issues world contracts
- **`48-zone-invasions-and-cross-faction-pve.md`** — Zone invasions that generate world contracts
- **`91-mortal-anomalies-rifts-hellgates.md`** — Rifts and anomalies that appear as world contracts

---

## 2. Concept Overview

### 2.1 World Contracts

A **World Contract** is a time-limited task anchored to:

- A specific zone & coordinates,
- A particular system (Rift, Endless Contract, Shrine defense, caravan escort, etc.),
- A faction or generic issuer.

Examples:

- “Cull the Alpha Packs in Northern Barrens” (Rangers’ Pact).
- “Protect the Trade Route: Gold Road Run” (Iron Ledger).
- “Close Planar Breaches in Desolace” (Rifts).
- “Midnight Horde Overflow in Duskwood Cemetery” (Order of the Shrine).

### 2.2 Map Pins

Contracts are visible on:

- **In-game Map** via MortalMap:
  - Icons colored by risk tier or faction,
  - Hover tooltips with contract synopsis & rewards.
- **Atlas Web Map**:
  - Same pins / legends,
  - Let players plan routes out of game.

Contracts can be:

- Accepted at Task Boards / issuer NPCs,
- Auto-accepted on arrival (for simple “participation credit” events).

---

## 3. Types of World Contracts

We treat World Contracts as a **thin wrapper** around existing systems.

### 3.1 Hunt / Cull Contracts

- Kill X of a specific mob type in a defined area.
- Good for:
  - Green/Yellow zones,
  - Early game and casual sessions.

### 3.2 Defense / Event Contracts

- Defend a Shrine, Stronghold gate, or waypoint from waves.
- Often overlap with:
  - Midnight Horde,
  - Endless Defense,
  - Invasion events.

### 3.3 Rift & Anomaly Contracts

- Close a number of Rifts or anomalies in a region.
- Synergizes with:
  - Rangers’ Pact,
  - Anomaly Scanning & Arcane Eye.

### 3.4 Caravan & Trade Contracts

- Escort or run cargo between cities/Strongholds.
- Reward structure depends heavily on:
  - Distance,
  - Risk tier,
  - Cargo type.

### 3.5 Hellgate / Dungeon Contracts

- Complete Hellgates, Public Dungeons, or specific instanced runs.
- May require:
  - Minimal deaths,
  - Time constraints,
  - Bonus objectives.

---

## 4. Data Model (MySQL)

We treat contracts with two layers:

- **Templates**: what a contract *is*.
- **Instances**: a specific spawn on the world map with start/end times.

### 4.1 Contract Templates

```sql
CREATE TABLE IF NOT EXISTS mortal_world_contract_templates (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  code            VARCHAR(64) NOT NULL UNIQUE,     -- 'WC_HUNT_BARRENS_ALPHA_WOLVES'
  name            VARCHAR(128) NOT NULL,
  description     TEXT NOT NULL,
  type            VARCHAR(32) NOT NULL,           -- 'HUNT','DEFENSE','RIFT','CARAVAN','HELLGATE'
  risk_tier       INT NOT NULL,                   -- 1..5 (Green->Red mapping)
  zone_id         INT NOT NULL,
  faction_tag     VARCHAR(64) NULL,               -- e.g. 'IRON_LEDGER','RANGERS_PACT'
  objective_json  JSON NOT NULL,                  -- target mobs, counts, event ids, etc.
  reward_json     JSON NOT NULL,                  -- base rewards
  flags           INT NOT NULL DEFAULT 0,
  is_active       TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 4.2 Contract Instances (Map Pins)

```sql
CREATE TABLE IF NOT EXISTS mortal_world_contract_instances (
  id              BIGINT AUTO_INCREMENT PRIMARY KEY,
  template_id     INT NOT NULL,
  map_id          INT NOT NULL,
  x_coord         FLOAT NOT NULL,
  y_coord         FLOAT NOT NULL,
  start_ts        INT NOT NULL,
  end_ts          INT NOT NULL,
  state           VARCHAR(16) NOT NULL DEFAULT 'ACTIVE', -- 'ACTIVE','COMPLETED','EXPIRED'
  current_progress_json JSON NULL,                      -- e.g. global progress for server-wide events
  CONSTRAINT fk_mortal_world_contract_instances_template
    FOREIGN KEY (template_id) REFERENCES mortal_world_contract_templates(id)
    ON DELETE CASCADE,
  INDEX idx_contract_active (template_id, state, end_ts)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 4.3 Player Contract Progress

```sql
CREATE TABLE IF NOT EXISTS mortal_world_contract_progress (
  id              BIGINT AUTO_INCREMENT PRIMARY KEY,
  guid            INT NOT NULL,
  instance_id     BIGINT NOT NULL,
  progress_json   JSON NOT NULL,      -- per-contract type tracking
  completed       TINYINT(1) NOT NULL DEFAULT 0,
  last_update_ts  INT NOT NULL,
  CONSTRAINT fk_mortal_world_contract_progress_instance
    FOREIGN KEY (instance_id) REFERENCES mortal_world_contract_instances(id)
    ON DELETE CASCADE,
  INDEX idx_guid_instance (guid, instance_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

---

## 5. Lifecycle & Rotation

### 5.1 Generation

Server scheduler periodically:

- Picks eligible templates for each zone:
  - Based on risk tier, recent activity, current events.
- Spawns instances with:
  - Start time = now,
  - End time = now + duration (e.g., 4–24 hours),
  - Coordinates = chosen from region sets,
  - Writes them into `mortal_world_contract_instances`.

### 5.2 Expiry & Completion

- When `end_ts` passes, instance state → `EXPIRED`.
- Some contracts can be **server-progress** driven:
  - If cumulative kills reach target before `end_ts`, mark as `COMPLETED`.
- Rewards:
  - Distributed per player based on `mortal_world_contract_progress`.

---

## 6. Integration with Existing Systems

### 6.1 Task Boards

- Task Boards query active contracts in their zone or region:
  - Show them in a list with icons and rewards.
- Players:
  - Can explicitly accept a contract,
  - Or gain “participation credit” by entering the area and doing relevant actions.

### 6.2 Factions

- Each contract may tag a faction:
  - Award standing on completion using the Faction system.
- Some contracts exclusive to certain factions:
  - e.g., Rangers’ Pact-only anomaly hunts.

### 6.3 Seasons (Season of the Frontier)

- Seasonal Challenges:
  - “Complete 10 Red-Tier World Contracts.”
  - “Finish 3 Iron Ledger caravan contracts without deaths.”
- Season Renown and rewards can be hooked to:
  - Completion of specific template tags.

### 6.4 Events & Rifts/Hellgates

- World Contracts can be auto-spawned in response to:
  - New Rifts appearing,
  - Invasions,
  - Hellgate clusters.

---

## 7. UI & UX (MortalUI + Atlas)

### 7.1 In-Game Map (MortalMap)

- Show pins for active contracts:
  - Shape by type (Hunt, Rift, Caravan, etc.),
  - Color by risk zone (Green/Yellow/Red).
- Hover tooltip:
  - Contract name,
  - Short description,
  - Time remaining,
  - Faction icon & reward summary.

### 7.2 Contract List Panel

- Separate UI panel:
  - Filter by:
    - Zone,
    - Risk tier,
    - Faction.
  - Shows which contracts you:
    - Have started,
    - Completed,
    - Are eligible for.

### 7.3 Atlas

- Web Map:
  - Mirrors pins with hover pop-ups,
  - Allows path-planning (manually) for trade runs, Rift loops, etc.
- Optional:
  - Show global progress of server-wide contracts (e.g., cumulative alpha culls).

---

## 8. Risk vs Reward Tuning

- Green:
  - Low payout, high safety, often soloable.
- Yellow:
  - Medium payout, moderate risk (Criminal flagging).
- Red:
  - High payout, full-loot risk.
  - Ideal for:
    - Strong guild groups,
    - High-tier factions.

Rewards lean toward:

- Faction standing,
- Materials and contract tokens,
- Cosmetic unlocks and appearance tokens,
- Less toward pure raw gold to avoid inflation.

---

## 9. Implementation Checklist

1. **DB**
   - Create `mortal_world_contract_templates`, `mortal_world_contract_instances`, `mortal_world_contract_progress`.
   - Seed example templates:
     - 1 Hunt per zone type,
     - 1 Caravan, 1 Rift-related, 1 Defense.

2. **Server**
   - Contract scheduler:
     - Rotates contracts per zone and risk tier.
   - Event hooks:
     - Update progress on kills, Rifts closed, caravans escorted, etc.
   - Completion handling:
     - Rewards + faction standing + Season hooks.

3. **UI**
   - MortalMap pins and tooltips.
   - Contract list panel with filters.

4. **Atlas**
   - Endpoints:
     - `GET /api/contracts/active`,
     - `GET /api/contracts/progress` (auth),
     - Map overlay layer.

5. **Balancing**
   - Tune durations, density, and rewards.
   - Ensure contracts feel like “opportunities”, not mandatory chores.
