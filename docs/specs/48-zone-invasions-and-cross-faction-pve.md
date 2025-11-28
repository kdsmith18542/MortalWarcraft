# Project Canvas: Mortal Warcraft Overhaul
### Version 32.0 — Hybrid Technical Design Document  
### File: 48-zone-invasions-and-cross-faction-pve.md  
### Section: Zone-Wide Invasions, Falling Territories & Cross-Faction Cooperation

---

## 1. Purpose

Tie together:

- Midnight Horde,
- Hot Zones,
- Planar Rifts,
- World Events

into a **unified zone-state system** where:

- Zones can **“fall” into enemy control** temporarily.
- Task Boards, banks, markets, and guards **change behavior** based on the zone state.
- Players of opposite factions can **cooperate in PvE** against shared threats, while your primary conflict logic comes from **Notoriety, Guild Wars, and Strongholds** instead of vanilla factions.

---

## Related Specs

For full context on zone invasions and cross-faction PvE, see:

- **`06-pve.md`** — PvE content system that includes invasion events
- **`03-risk-zones.md`** — Risk zones that can be invaded and change state
- **`12-world-simulation.md`** — World simulation system that drives invasion events
- **`37-economy-system-extensions.md`** — Hot zones system that interacts with zone states
- **`51-factions-and-standing-system.md`** — Faction system that affects cross-faction cooperation
- **`08-guilds-sovereignty.md`** — Stronghold system that can be affected by invasions
- **`76-dynamic-tasks-and-contracts-2-0-spec.md`** — Task boards that adjust based on zone state

---

## 2. Zone State Model

Each zone has a **dynamic state**:

- `NEUTRAL` (normal)
- `HOT` (elevated activity, higher rewards)
- `INVADED` (enemy forces present, faction NPCs under threat)
- `OCCUPIED` (enemy forces control major hubs)
- `PURGED` (recently cleared, temporary aftermath bonuses)

### 2.1 Data Model

```sql
CREATE TABLE IF NOT EXISTS mortal_zone_state (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  map_id          INT NOT NULL,
  zone_id         INT NOT NULL,
  state           VARCHAR(16) NOT NULL,    -- 'NEUTRAL','HOT','INVADED','OCCUPIED','PURGED'
  state_since     INT NOT NULL,
  state_until     INT NULL,
  invasion_id     INT NULL,                -- links to active invasion event, if any
  last_changed_by VARCHAR(16) NOT NULL,   -- 'SYSTEM','EVENT','GM'
  flags           INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

Zone state is updated by:

- Scheduled world events,
- Planar Rift/Undead Horde outcomes,
- GM tools (File 42).

---

## 3. Zone-Wide Invasions

### 3.1 Concept

A **Zone Invasion** is a high-level event that:

- Spawns enemy forces (undead, planar, cultists, etc.).
- Pushes toward key hubs (towns, strongholds, shrines).
- Changes:

  - Guard behavior,
  - NPC availability,
  - Task Boards & markets.

### 3.2 Invasion Definitions

```sql
CREATE TABLE IF NOT EXISTS mortal_invasion_def (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  code            VARCHAR(64) NOT NULL,    -- 'INV_UNDEAD_ELWYNN','INV_PLANAR_BARRENS'
  name            VARCHAR(64) NOT NULL,
  map_id          INT NOT NULL,
  zone_id         INT NOT NULL,
  duration_seconds INT NOT NULL,
  config_json     TEXT NOT NULL,           -- waves, invasion routes, objectives
  flags           INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

**Active invasions:**

```sql
CREATE TABLE IF NOT EXISTS mortal_invasion_active (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  invasion_def_id INT NOT NULL,
  map_id          INT NOT NULL,
  zone_id         INT NOT NULL,
  started_time    INT NOT NULL,
  end_time        INT NULL,
  outcome         VARCHAR(16) NULL,        -- 'FAILED','REPULSED','OCCUPIED'
  progress_json   TEXT NULL                -- for metrics & route progress
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 3.3 Flow

1. Invasion starts:
   - `mortal_zone_state.state` becomes `INVADED`.
   - Waves of mobs spawn at borders, rifts, or dark shrines.
2. Players fight invading forces at multiple hotspots:

   - Wardstones,
   - Shrines,
   - Roads to towns.

3. Outcomes:

   - If players **repel** the invasion in time:
     - `zone_state` transitions to `PURGED`:
       - Temporary buffs, extra tasks, special vendors.
   - If players **fail**:
     - Key hubs are taken:
       - `zone_state` becomes `OCCUPIED`.

---

## 4. Occupied Zones

### 4.1 Behavior in OCCUPIED State

When `state = OCCUPIED`:

- Town banks / markets:

  - May be:
    - Closed,
    - Or replaced with **Black Market** vendors only.
  - Regional bank access might be:
    - Restricted or taxed extra.

- Guards:

  - Faction guards replaced by **enemy elite NPCs** (phased).
  - City / town is dangerous until a **counter-offensive** is launched.

- Task Boards:

  - Normal tasks removed or reduced.
  - Special **Liberation Tasks** appear:
    - Kill invasion commanders,
    - Secure roads,
    - Reclaim shrines.

- Strongholds in the zone:

  - May receive:
    - Penalties (reduced resource output),
    - Or special defense bonuses (if they become last bastions).

### 4.2 Liberation

To restore a zone:

1. System or GM triggers a **Liberation Offensive** event:
   - Encodes objectives to drive state back toward `NEUTRAL` or `PURGED`.
2. Players complete:

   - Commanders killed,
   - Rifts sealed,
   - Wardstones recaptured.

3. On success:

   - `state` becomes `PURGED` for a while:
     - Bonus task rewards,
     - Discounted repairs,
     - Cosmetic titles for heavy participants.

---

## 5. Hot Zones & Purged Bonuses

### 5.1 HOT

- `HOT` zones are high-activity but not fully invaded:

  - Extra resource yields,
  - Higher task payouts,
  - More frequent anomalies / rifts.

They can:

- Gradually escalate into `INVADED` if neglected, based on:

  - Event triggers,
  - Demon/undead planar energy metrics,
  - GM decisions.

### 5.2 PURGED

- `PURGED` is a temporary “afterglow” state:

  - Slight buffs:
    - Vendor discounts,
    - Task bonuses,
    - Shrine blessings.
  - Cosmetic effects:
    - Banners,
    - Light effects,
    - NPC dialogue praising heroes.

---

## 6. Cross-Faction PvE Cooperation

### 6.1 Philosophy

Mortal Warcraft de-emphasizes strict Alliance/Horde conflict:

- Main engines of conflict are:
  - **Notoriety** (criminal vs law-abiding),
  - **Guild Wars** and **Strongholds**,
  - **Red Zone** full-loot rules.

In high-threat PvE contexts:

- Players of different legacy factions should be able to **fight side-by-side** against invasions, planar entities, and world bosses.

### 6.2 Cooperative Rules

In the following contexts:

- Planar Rifts,
- Zone Invasions (INVADED/OCCUPIED),
- World Boss events,
- Certain public dungeons flagged as “Cooperative”,

Apply:

1. **Cross-faction friendliness:**
   - Players on different original factions are treated as “cooperative”:
     - Cannot attack each other (unless Criminal/War flags override),
     - Can heal, buff, and join the same Public Groups.

2. **Cross-faction grouping:**
   - Public Expeditions ignore faction boundaries.
   - Private groups/raids also can invite across factions in cooperative zones.

3. **Conflict precedence:**

   - **Guild Wars**:
     - If two guilds are formally at war:
       - Their members remain hostile to each other even in cooperative PvE, except where disabled by specific content rules.
   - **Criminal / Notoriety**:
     - Criminals remain attackable targets.
     - Helping a Criminal still flags you, respecting existing rules.
   - **Red Zones**:
     - Red Zones retain FFA rules unless a specific event overrides this.

### 6.3 Limited Scope

- Cross-faction cooperation is **not universal**:
  - Regular open world rules:
    - Faction hostility can still exist where appropriate (especially in normal contested zones).
- It is **tightly scoped** to:

  - Major invasions,
  - Shared planar threats,
  - Specific cooperative instances.

This supports the fantasy of:

- “World-threatening events force enemies to stand together,”
- Without erasing the underlying sandbox conflict.

---

## 7. Integration with Existing Systems

### 7.1 Events & GM Tools

- Invasion definitions can be managed through:

  - Event Templates (File 42),
  - GM panel for starting/stopping invasions and liberation offensives.

- Zone state changes:
  - Logged via GM/action logs,
  - Visible in Mortal Atlas and MortalMap overlays.

### 7.2 Telemetry & Economy

- Telemetry tracks:

  - Time spent per zone state,
  - Participation in invasions/liberations,
  - Economic impact (e.g., price shifts for goods abundant in certain zones).

- Economy:

  - Banks/markets behavior under OCCUPIED state adds:
    - Temporary trade friction,
    - Opportunities for traders (running supplies to safer hubs).

### 7.3 MortalMap & Web Atlas

- MortalMap overlays:

  - Color/texture coding for zone states:
    - NEUTRAL, HOT, INVADED, OCCUPIED, PURGED.
- Web Atlas:

  - Zone-state banner,
  - Active invasion details,
  - Leaderboards for liberation efforts.

---

## 8. Implementation Checklist

1. Implement `mortal_zone_state`, `mortal_invasion_def`, `mortal_invasion_active` tables.
2. Hook zone state into:

   - Spawns,
   - Task Boards,
   - Banks/markets behavior,
   - Guard NPC templates.

3. Implement **Invasion Runner**:

   - Orchestrates waves, routes, objectives based on `config_json`.

4. Extend GM Tools (File 42) with:

   - Controls to start/stop invasions,
   - Force state changes for testing.

5. Implement **Cross-Faction Cooperation** rules:

   - In cooperative PvE contexts (rifts, invasions, world bosses).
   - Integrate with:
     - Notoriety,
     - Guild Wars,
     - Red Zone logic.

6. Integrate zone state with:

   - Telemetry,
   - MortalMap / Web Atlas overlays.

