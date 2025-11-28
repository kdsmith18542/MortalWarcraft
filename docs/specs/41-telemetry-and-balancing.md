# Project Canvas: Mortal Warcraft Overhaul
### Version 29.3 — Hybrid Technical Design Document  
### File: 41-telemetry-and-balancing.md  
### Section: Telemetry, Analytics & Balancing Hooks

---

## Related Specs

- `40-anti-bot-rmt-and-security.md` - Security system that shares data with telemetry
- `42-gm-tools-and-live-events.md` - GM tools that use telemetry dashboards
- `14-admin-tools.md` - Admin tools that display telemetry data
- `24-webportal-mortal-atlas.md` - Web portal that surfaces telemetry views
- `04-economy.md` - Economy metrics tracked by telemetry
- `11-pvp-systems.md` - PvP metrics tracked by telemetry
- `06-pve.md` - PvE content metrics tracked by telemetry

---

## 1. Purpose

Define a **telemetry and analytics framework** for Mortal Warcraft that:

- Measures the health of:
  - Economy (gold, mats, prices),
  - Activity loops (PvE, PvP, trade, tasks),
  - Risk systems (Red-Zone deaths, gear loss),
  - Social systems (guilds, group content).
- Provides **actionable data** for:
  - Reward tuning (gold/hr, tokens/hr),
  - Difficulty adjustment,
  - Content/prioritization decisions.
- Integrates with:
  - Existing security / anti-bot tables (File 40),
  - Mortal Atlas (web portal),
  - GM dashboards.

Telemetry is **read-only**: it never alters behavior by itself. It feeds human-driven balancing decisions.

---

## 2. Design Principles

1. **Low Overhead**
   - Only log what is necessary for tuning and monitoring.
   - Use aggregation where possible (daily summaries) instead of raw spam.

2. **Actionable Metrics**
   - Every metric we log should be tied to:
     - A question we want answered, or
     - A decision we may take (buff/nerf, promote/demote content).

3. **Per-Character & Per-Realm Views**
   - Character-level:
     - What is this player doing? Is their loop healthy/fun?
   - Realm-level:
     - Is the economy inflating?
     - Are certain activities dead?

4. **Separation from Security**
   - Security (File 40) focuses on *abuse*.
   - Telemetry focuses on *balance and engagement*.
   - Some tables can be shared, but intent is different.

---

## 3. Core Telemetry Domains

We focus on these domains:

1. **Economy**
   - Gold inflows/outflows,
   - Material/mat acquisition and sinks,
   - Auction & buy-order prices,
   - Stronghold production vs sinks.

2. **Activities / Loops**
   - Task Boards, Buy Orders, City Jobs,
   - Dungeons & Raids (Expeditions),
   - Public Dungeons & World Events,
   - Battlegrounds, Arenas, Warfronts,
   - Red-Zone farming & trade runs.

3. **Risk & Loss**
   - Red-Zone deaths & gear loss,
   - Blessed item use/consumption,
   - Durability decay vs item retirement.

4. **Social Structures**
   - Guild membership,
   - Stronghold ownership,
   - Participation in group content.

5. **Engagement**
   - Time in-game per day,
   - Distribution of time across activities,
   - Churn indicators (players who stop logging in).

---

## 4. Economy Telemetry

### 4.1 Gold Flow Aggregates

We extend the daily summary concept to **gold categories**:

```sql
CREATE TABLE IF NOT EXISTS mortal_econ_gold_daily (
  guid            INT NOT NULL,
  date_int        INT NOT NULL,      -- YYYYMMDD
  gold_from_tasks BIGINT NOT NULL DEFAULT 0,
  gold_from_dungeons BIGINT NOT NULL DEFAULT 0,
  gold_from_pvp   BIGINT NOT NULL DEFAULT 0,  -- BG, Arena, Warfront rewards
  gold_from_trades BIGINT NOT NULL DEFAULT 0, -- player-to-player trades (net)
  gold_from_npc_vendors BIGINT NOT NULL DEFAULT 0,
  gold_sink_repairs BIGINT NOT NULL DEFAULT 0,
  gold_sink_vendors BIGINT NOT NULL DEFAULT 0,
  gold_sink_taxes BIGINT NOT NULL DEFAULT 0,  -- stronghold taxes, fees
  gold_sink_blessings BIGINT NOT NULL DEFAULT 0,
  gold_sink_upkeep BIGINT NOT NULL DEFAULT 0,
  PRIMARY KEY (guid, date_int)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

Hooks:

- Each time gold changes, we categorize the **source/sink**:
  - E.g., Task reward, Dungeon completion, BG reward, vendor sale, repair, blessing, etc.
- Aggregate into this daily table for each character.

Realm-level views can SUM by `date_int` to monitor:

- Total gold entering vs leaving,
- Distribution across activities.

### 4.2 Material Flows

We track key materials (T3–T5 mats, rare blueprints, key reagents) at aggregate level.

```sql
CREATE TABLE IF NOT EXISTS mortal_econ_mats_daily (
  guid            INT NOT NULL,
  date_int        INT NOT NULL,
  item_entry      INT NOT NULL,      -- tracked material ID
  quantity_gain   INT NOT NULL DEFAULT 0,
  quantity_loss   INT NOT NULL DEFAULT 0,
  PRIMARY KEY (guid, date_int, item_entry)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

Usage:

- Monitor whether rare mats are:
  - Accumulating (hoarding) or
  - Being consumed at healthy rates.

### 4.3 Auction & Buy Order Data

We capture **snapshot summaries** of:

- Average sale price,
- Volume traded per day, per item.

Example table:

```sql
CREATE TABLE IF NOT EXISTS mortal_econ_market_daily (
  date_int        INT NOT NULL,
  item_entry      INT NOT NULL,
  avg_price       BIGINT NOT NULL DEFAULT 0,  -- average sale/fulfillment price
  volume_traded   INT NOT NULL DEFAULT 0,     -- count of trades/fulfillments
  region_code     VARCHAR(32) NOT NULL,
  PRIMARY KEY (date_int, item_entry, region_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

Data sources:

- Real trades from player AH listings,
- Completed Town Buy Orders.

---

## 5. Activity Telemetry (Loops)

### 5.1 Task Boards & City Jobs

```sql
CREATE TABLE IF NOT EXISTS mortal_activity_tasks_daily (
  guid            INT NOT NULL,
  date_int        INT NOT NULL,
  tasks_green     INT NOT NULL DEFAULT 0,
  tasks_yellow    INT NOT NULL DEFAULT 0,
  tasks_red       INT NOT NULL DEFAULT 0,
  tasks_cityjobs  INT NOT NULL DEFAULT 0,
  avg_task_reward BIGINT NOT NULL DEFAULT 0, -- optional: per-day average
  PRIMARY KEY (guid, date_int)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

Hooks:

- On task completion, increment appropriate counter (Green/Yellow/Red/City).
- Optionally update rolling average reward.

Use cases:

- Identify whether:
  - Players are ignoring Red tasks (rewards too low),
  - Overusing safe tasks (risk/reward off).

### 5.2 Dungeons & Raids (Expeditions)

```sql
CREATE TABLE IF NOT EXISTS mortal_activity_pve_daily (
  guid            INT NOT NULL,
  date_int        INT NOT NULL,
  expeditions_completed INT NOT NULL DEFAULT 0,
  expeditions_failed    INT NOT NULL DEFAULT 0,
  public_dungeons_runs  INT NOT NULL DEFAULT 0,
  boss_kills            INT NOT NULL DEFAULT 0,
  deaths_in_pve         INT NOT NULL DEFAULT 0,
  PRIMARY KEY (guid, date_int)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

Additionally, we can track **per-expedition** metrics in a separate table:

```sql
CREATE TABLE IF NOT EXISTS mortal_activity_expedition_runs (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  guid            INT NOT NULL,
  date_int        INT NOT NULL,
  expedition_code VARCHAR(64) NOT NULL,  -- FK to mortal_expedition_def.code
  completed       TINYINT NOT NULL,      -- 1=success,0=failure
  deaths          INT NOT NULL DEFAULT 0,
  time_seconds    INT NOT NULL DEFAULT 0,
  loot_value_est  BIGINT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

Use:

- See which dungeons are too easy/hard,
- Which ones have poor rewards or low engagement.

### 5.3 PvP (BG, Arena, Warfronts)

```sql
CREATE TABLE IF NOT EXISTS mortal_activity_pvp_daily (
  guid            INT NOT NULL,
  date_int        INT NOT NULL,
  bg_games        INT NOT NULL DEFAULT 0,
  bg_wins         INT NOT NULL DEFAULT 0,
  arena_games     INT NOT NULL DEFAULT 0,
  arena_wins      INT NOT NULL DEFAULT 0,
  warfront_games  INT NOT NULL DEFAULT 0,
  warfront_wins   INT NOT NULL DEFAULT 0,
  kills_pvp       INT NOT NULL DEFAULT 0,
  deaths_pvp      INT NOT NULL DEFAULT 0,
  PRIMARY KEY (guid, date_int)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

Use:

- Determine popularity and win/loss patterns.
- Identify if rewards are out of line for any PvP mode.

---

## 6. Risk & Loss Telemetry

### 6.1 Red-Zone Deaths & Gear Loss

```sql
CREATE TABLE IF NOT EXISTS mortal_activity_risk_daily (
  guid            INT NOT NULL,
  date_int        INT NOT NULL,
  deaths_redzone  INT NOT NULL DEFAULT 0,
  deaths_yellow   INT NOT NULL DEFAULT 0,
  items_lost_count INT NOT NULL DEFAULT 0,
  items_lost_value BIGINT NOT NULL DEFAULT 0,
  blessed_saves    INT NOT NULL DEFAULT 0,   -- times blessed items prevented drop
  durability_loss_total BIGINT NOT NULL DEFAULT 0, -- summed durability loss units
  PRIMARY KEY (guid, date_int)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

Hooks:

- On Red-Zone death:
  - Count items transferred to corpse chest,
  - Estimate their value via internal pricing,
  - Increment `deaths_redzone` and loss metrics.
- On Blessed Item save:
  - Increment `blessed_saves`.

Use:

- Tune:
  - How punishing Red Zones actually are,
  - Whether Blessed system is over- or under-used.

---

## 7. Social & Guild Telemetry

### 7.1 Guild Membership & Churn

```sql
CREATE TABLE IF NOT EXISTS mortal_social_guild_daily (
  guild_id        INT NOT NULL,
  date_int        INT NOT NULL,
  member_count    INT NOT NULL DEFAULT 0,
  joins           INT NOT NULL DEFAULT 0,
  leaves          INT NOT NULL DEFAULT 0,
  PRIMARY KEY (guild_id, date_int)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

Use:

- Monitor:
  - Guild growth,
  - Sudden collapses (drama, burnout),
  - Overall guild coverage on the realm.

### 7.2 Stronghold Participation

```sql
CREATE TABLE IF NOT EXISTS mortal_social_stronghold_daily (
  stronghold_id   INT NOT NULL,
  date_int        INT NOT NULL,
  owner_guild_id  INT NOT NULL,
  times_attacked  INT NOT NULL DEFAULT 0,
  times_defended  INT NOT NULL DEFAULT 0,
  times_captured  INT NOT NULL DEFAULT 0,
  resource_output BIGINT NOT NULL DEFAULT 0,
  PRIMARY KEY (stronghold_id, date_int)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

Use:

- Identify:
  - Over-dominant guilds,
  - Underused strongholds,
  - Resource output vs upkeep vs sinks.

---

## 8. Engagement & Retention

### 8.1 Playtime & Activity Distribution

We extend/combine with `mortal_activity_summary_daily` (File 40) to capture:

- `minutes_played`
- `time_in_redzones`
- `time_in_capitals`
- `time_in_group` (parties/raids)

Example extension:

```sql
ALTER TABLE mortal_activity_summary_daily
  ADD COLUMN time_in_redzones INT NOT NULL DEFAULT 0,
  ADD COLUMN time_in_capitals INT NOT NULL DEFAULT 0,
  ADD COLUMN time_in_group    INT NOT NULL DEFAULT 0;
```

Hooks:

- Periodically (e.g. every few minutes):
  - Check player location and context,
  - Increment the relevant time bucket.

### 8.2 Churn Indicators (Offline analytics)

We can derive churn without extra tables:

- Track last login date per account/character.
- Segment players by:
  - Lifetime played,
  - Preferred activities,
  - Whether they died heavily in Red Zones before quitting.

This helps answer:

- “Are new players leaving after first full-loot death?”
- “Do players who reach Stronghold stage stay longer?”

---

## 9. Dashboards & Mortal Atlas Integration

### 9.1 Internal Dashboards (GM/Designer)

Using SQL views or a lightweight admin panel, we expose:

- **Economy Overview**
  - Gold in vs out per day,
  - Top gold sources,
  - Inflation trend,
  - Top mats by volume and price.

- **Activity Overview**
  - Participation in tasks/dungeons/PvP per day,
  - Time spent in each loop.

- **Risk Overview**
  - Red-Zone deaths vs population,
  - Gear loss distributions,
  - Blessed saves usage.

- **Guild/Stronghold Overview**
  - Stronghold ownership map,
  - Attacks/defenses per week,
  - Guild size distribution.

### 9.2 Mortal Atlas (Web Portal) Views

Mortal Atlas can expose **player-agnostic, aggregated** data:

- Heatmaps of:
  - Kills (PvE & PvP),
  - Trade/contract volume (per region).
- Economic charts:
  - Prices of key mats,
  - Volumes per region.
- Stronghold:
  - Ownership map,
  - Attack/defense history (high-level).

No personal data; everything aggregated to maintain privacy.

---

## 10. Balancing Workflow

### 10.1 Regular Review Cadence

We define a simple cadence:

- **Weekly**
  - Check:
    - Gold faucets vs sinks,
    - Participation in Task tiers (Green/Yellow/Red).
  - Apply:
    - Minor % tweaks to rewards (e.g., +10% Red tasks if underused).

- **Monthly**
  - Review:
    - Dungeon clear times, failure rates,
    - PvP reward rates,
    - Stronghold output vs upkeep.
  - Apply:
    - Adjustments to loot tables, token gains, upkeep costs.

- **Seasonal (every few months)**
  - Review:
    - Mastery trees & core skills for extreme outliers,
    - Long-term wealth concentration,
    - Zone popularity/neglect.
  - Apply:
    - Larger shifts (new content, new mats, soft resets defined in long-term progression spec).

### 10.2 Tuning Examples

- If `tasks_red` completion is low and `deaths_redzone` is high:
  - Increase Red task payouts or tweak risk (more shrines, blessed costs).
- If `gold_from_tasks` dwarfs `gold_from_dungeons`:
  - Boost dungeon reward pools or introduce additional loot hooks.
- If certain mats show extreme `avg_price` & low `volume_traded`:
  - Add more sources (events, world bosses) or additional sinks for substitutes.

---

## 11. Implementation Summary

To implement this telemetry framework:

1. **Create the SQL tables** defined above, taking care to:
   - Reuse/extend `mortal_activity_summary_daily` from File 40.
2. **Add Lua/C++ hooks** at key events:
   - Task completion, dungeon completion, PvP match end,
   - Gold change events, Red-Zone deaths, stronghold ticks.
3. **Batch writes where possible**:
   - Use in-memory counters flushed periodically for high-frequency events.
4. **Build basic dashboards**:
   - Either as:
     - In-game AIO UIs for GMs/designers, or
     - Simple web views in Mortal Atlas’s admin section.

Once live, this telemetry system will enable **data-driven balancing**, ensuring your complex sandbox remains:

- Economically stable,
- Reward-balanced across playstyles,
- And fun long-term.
