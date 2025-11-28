# Project Canvas: Mortal Warcraft Overhaul
### Version 29.6 — Hybrid Technical Design Document  
### File: 42-gm-tools-and-live-events.md  
### Section: GM Tools, Admin Panels & Live Event Framework

---

## Related Specs

- `14-admin-tools.md` - GM tools and admin panel architecture
- `40-anti-bot-rmt-and-security.md` - Security system integration for GM actions
- `41-telemetry-and-balancing.md` - Telemetry system for event metrics and balancing
- `08-guilds-sovereignty.md` - Stronghold system that GM tools can control
- `37-economy-system-extensions.md` - Hot Zones, Task Boards, and economy bonuses that events can modify
- `48-zone-invasions-and-cross-faction-pve.md` - Zone invasions and events that GM tools can trigger
- `24-webportal-mortal-atlas.md` - Web portal admin area for event management
- `15-ui-client.md` - In-game GM panel UI implementation

---

## 1. Purpose

Define a **production-ready GM tooling and live events framework** for Mortal Warcraft that:

- Gives GMs & devs **safe, structured controls** to run events and intervene in the world.
- Avoids ad-hoc `.npc add` / `.gobject add` chaos.
- Ties into:
  - Strongholds, Hot Zones, World Events,
  - Task Boards, Town Buy Orders, Regional Bonuses,
  - Telemetry & security systems (Files 40–41).

This spec assumes:

- AIO (AzerothCore IO) or a similar **server-driven UI** framework is available.
- Mortal Atlas (web portal) exists and can expose **admin-only** views.
- Security/auth for GM actions is enforced at the account/role level.

---

## 2. GM Roles & Permissions

### 2.1 Roles

We define three logical roles (mapped onto your actual account flags):

1. **GM (Game Master)**
   - Primary live-ops role.
   - Can:
     - Start/stop events,
     - Spawn event mobs (via templates),
     - Adjust minor bonuses (e.g., regional XP/gold boosters),
     - Teleport *self* and *players* for support.

2. **Designer (Live Designer / Economy Designer)**
   - Focus on tuning & content staging.
   - Can:
     - Edit event templates (but not arbitrary spawns),
     - Adjust Task Board reward multipliers,
     - Configure Hot Zones & Town Buy Orders,
     - View telemetry dashboards.

3. **Admin (Server Owner / Lead)**
   - Full access.
   - Can:
     - Change global configs,
     - Promote/demote GM/Designer roles,
     - Execute emergency scripts (mass rollbacks, events cancel).

### 2.2 Permissions Matrix

We maintain a simple table of in-game feature permissions:

```sql
CREATE TABLE IF NOT EXISTS mortal_gm_permissions (
  account_id      INT NOT NULL,
  role            VARCHAR(16) NOT NULL,  -- 'GM','DESIGNER','ADMIN'
  granted_time    INT NOT NULL,
  granted_by      INT NOT NULL,          -- admin account id
  PRIMARY KEY (account_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

---

## 3. GM Control Surfaces

We provide **two** control surfaces:

1. **In-Game GM Panel (AIO UI)**
   - Accessible to GM/Designer/Admin.
   - Focuses on:
     - Quick actions during live gameplay,
     - Event start/stop,
     - Local diagnostics.

2. **Mortal Atlas Admin Area (Web)**
   - Accessible to Designer/Admin.
   - Focuses on:
     - Larger-scale configuration,
     - Editing templates,
     - Reviewing telemetry & security flags.

### 3.1 In-Game GM Panel (AIO)

Main tabs:

1. **Events**
   - Start/stop predefined events.
   - View current event status in each zone.
2. **Economy / Bonuses**
   - Set temporary multipliers:
     - Regional task payouts,
     - Town Buy Order bonuses,
     - Hot Zone boosts.
3. **Strongholds**
   - Inspect stronghold ownership.
   - Trigger “Under Siege” states.
4. **Security**
   - Quick view of top security flags (from File 40).
   - Teleport to suspect, or open moderate actions.
5. **Tools**
   - Teleport self/players within safe guidelines.
   - Spawn test NPCs / objects using **templates only** (no raw IDs).

### 3.2 Mortal Atlas Admin Area

Sections:

1. **Events Manager**
   - Create/edit/delete event templates.
   - Schedule events (time-window + conditions).
   - View event performance (participation, rewards, impact on economy).

2. **Economy & Balancing**
   - Direct views of telemetry (File 41).
   - Editable config for:
     - Reward multipliers,
     - Upkeep costs,
     - Material drop rates (where data-driven).

3. **Stronghold & Territory Control**
   - Map of strongholds and their owners.
   - Manual override tools:
     - Transfer ownership (last resort),
     - Toggle vulnerability windows.

4. **Security Dashboard**
   - Summaries from anti-bot/RMT system (File 40):
     - Watchlist accounts,
     - Econ flags,
     - Multibox clusters.
   - Tools to:
     - Add notes,
     - Mark flags as resolved,
     - Apply sanctions.

---

## 4. Event Template System

We avoid one-off hard-coded events by defining a **generic Event Template** model.

### 4.1 Event Template Schema

```sql
CREATE TABLE IF NOT EXISTS mortal_event_template (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  code            VARCHAR(64) NOT NULL,    -- 'EV_ZOMBIE_HORDE','EV_RESOURCE_SURGE_ELWYNN'
  name            VARCHAR(64) NOT NULL,
  description     VARCHAR(255) NULL,
  category        VARCHAR(32) NOT NULL,    -- 'PVE','PVP','ECON','MIXED'
  zone_id         INT NOT NULL,
  map_id          INT NOT NULL,
  start_type      VARCHAR(16) NOT NULL,    -- 'MANUAL','SCHEDULED'
  duration_seconds INT NOT NULL DEFAULT 1800,
  max_concurrent  INT NOT NULL DEFAULT 1,
  config_json     TEXT NOT NULL,           -- event-specific data blob (see below)
  enabled         TINYINT NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

`config_json` example for a **Zombie Horde** event:

```json
{
  "spawn_points": [
    { "x": -9450.0, "y": 65.2, "z": 56.1, "count": 30 },
    { "x": -9430.5, "y": 90.8, "z": 54.3, "count": 30 }
  ],
  "creature_entry": 120001,
  "respawn_interval": 30,
  "max_waves": 10,
  "reward_taskboard_code": "TASK_EVENT_ZOMBIE_ELWYNN",
  "announcement": "The dead rise in Elwynn Forest!"
}
```

### 4.2 Active Events

```sql
CREATE TABLE IF NOT EXISTS mortal_event_active (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  template_id     INT NOT NULL,
  zone_id         INT NOT NULL,
  map_id          INT NOT NULL,
  started_by      INT NOT NULL,        -- GM account id or system
  started_time    INT NOT NULL,
  end_time        INT NULL,
  state           VARCHAR(16) NOT NULL DEFAULT 'RUNNING',  -- 'RUNNING','ENDED','FAILED'
  metrics_json    TEXT NULL            -- aggregated metrics (kill count, participation, etc.)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

The event system:

- Reads `config_json` for spawn/multiplier behavior.
- Spawns/despawns creatures, applies bonuses, and triggers announcements.
- Writes summary metrics back to `metrics_json` on completion.

---

## 5. Standard Event Types

We define **reusable event types**:

### 5.1 Zombie Horde / Undead Invasion (PVE + Risk)

- Category: `PVE` or `MIXED`.
- Behavior:
  - Spawn waves of undead mobs in a defined area.
  - Add temporary Task Board entries:
    - “Cull the Horde” with bonus rewards.
- Knobs:
  - Wave count, spawn density,
  - Reward multipliers,
  - Whether event is full-loot (if in/near Red Zones).

### 5.2 Resource Surge (Economic)

- Category: `ECON`.
- Behavior:
  - Temporarily increases:
    - Node spawn rates,
    - Or Town Buy Order payouts in a region.
- Used to:
  - Move players into underused zones,
  - Stimulate supply of needed mats.

### 5.3 Warfront Push (PvP)

- Category: `PVP`.
- Behavior:
  - Temporarily increases:
    - Warfront rewards,
    - Bounty / Notoriety stakes in a region.
- Optional:
  - Spawn neutral event NPCs that provide:
    - “Join the war effort” tasks,
    - Buffs for participation.

### 5.4 Stronghold Siege Week

- Category: `MIXED`.
- Behavior:
  - Marks a window where:
    - Stronghold vulnerability is higher,
    - Siege engine recipes are cheaper (Military Credits).
  - Optional:
    - Server-wide announcement,
    - Bonus rewards for successful defenses/captures.

### 5.5 Market Festival / Black Market Arrival

- Category: `ECON` / `MIXED`.
- Behavior:
  - Spawns a temporary fair (NPCs, stalls) in a known or secret location.
  - Offers:
    - Unique buy orders,
    - Rare blueprint vendors,
    - Fencing of stolen goods.

Each of these is implemented as **templates** with `config_json` rather than unique code.

---

## 6. Stronghold & Hot Zone Controls

### 6.1 Stronghold Tools

GM/Designer can:

- Temporarily:
  - Lock/unlock a stronghold,
  - Change vulnerability windows,
  - Toggle output multipliers.

Data can be stored as overrides:

```sql
CREATE TABLE IF NOT EXISTS mortal_stronghold_overrides (
  stronghold_id   INT PRIMARY KEY,
  override_output_multiplier FLOAT NOT NULL DEFAULT 1.0,
  override_vulnerability_json TEXT NULL,
  last_updated    INT NOT NULL,
  updated_by      INT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 6.2 Hot Zones

We integrate with the earlier **Regional Bonuses** system:

- GM panel allows:
  - Activating/deactivating Hot Zones for:
    - Task rewards,
    - Node yield,
    - PvP incentives.
- Changes write into:
  - `mortal_regional_bonuses` (from the economy spec),
  - With `source = 'GM_EVENT'` and expiration timestamp.

---

## 7. Safety & Audit Logging

### 7.1 GM Action Log

We log all sensitive GM actions:

```sql
CREATE TABLE IF NOT EXISTS mortal_gm_action_log (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  account_id      INT NOT NULL,
  role            VARCHAR(16) NOT NULL,
  action_code     VARCHAR(64) NOT NULL,    -- 'START_EVENT','STOP_EVENT','SET_BONUS','TRANSFER_STRONGHOLD'
  target_type     VARCHAR(32) NULL,        -- 'PLAYER','GUILD','ZONE','EVENT','STRONGHOLD'
  target_id       INT NULL,
  timestamp       INT NOT NULL,
  parameters_json TEXT NULL                -- knobs/values changed
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

Examples:

- Starting an event:
  - `action_code = 'START_EVENT'`, `target_type = 'EVENT'`, `target_id = template_id`.
- Changing a stronghold multiplier:
  - `action_code = 'SET_STRONGHOLD_MULT'`, `target_type = 'STRONGHOLD'`, etc.

### 7.2 Safeguards

- Dangerous actions (e.g., mass wipes, economy resets) require:
  - Admin role,
  - Extra confirmation UI.
- GM panel should:
  - Default to **weak/modest** multipliers,
  - Provide visible warnings for large overrides.

---

## 8. Dev/QA Event Sandbox

To test events without impacting live realm:

- Maintain a **dev/test realm** where:
  - GM/Designer can:
    - Run events freely,
    - Stress test spawn counts,
    - Try unusual configurations.
- Optionally:
  - Allow copying live data into a staging realm for load tests.

---

## 9. Integration Points

### 9.1 Telemetry (File 41)

Each event writes:

- Participation data:
  - New tasks completed,
  - Kills, deaths, rewards.
- Impact metrics:
  - Extra gold/mats generated.

These are aggregated in `metrics_json` of `mortal_event_active` and can also update daily telemetry tables.

### 9.2 Security (File 40)

Events can:

- Temporarily increase activity in one area.
- Security system should:
  - Consider event context to avoid flagging **normal** concentrated play as suspicious.

GM panel should:

- Show when an area’s spike in activity is event-driven vs suspicious.

---

## 10. Implementation Summary

To implement this GM/Event framework:

1. **Create SQL tables**:
   - `mortal_gm_permissions`
   - `mortal_event_template`
   - `mortal_event_active`
   - `mortal_stronghold_overrides`
   - `mortal_gm_action_log`
2. **Implement AIO GM panel** with:
   - Tabs for Events, Economy/Bonuses, Strongholds, Security, Tools.
3. **Implement Mortal Atlas admin area**:
   - Event template editor,
   - Telemetry dashboards,
   - Stronghold & economy control panels.
4. **Implement event runner**:
   - Lua/C++ system that:
     - Reads event templates,
     - Spawns mobs/objects,
     - Applies temporary buffs/bonuses,
     - Cleans up after events end.
5. **Wire telemetry & security**:
   - Log key metrics into telemetry tables,
   - Respect security context (don’t mislabel event-driven spikes).

This gives Mortal Warcraft a robust, **repeatable live-ops toolkit** for running world events, tuning the sandbox, and responding to issues without ad-hoc hacks.

---

# 11. Complete Holiday Event Conversion Strategy

This section provides a comprehensive mapping of all WoW 3.3.5a holiday events to Mortal Warcraft's event system.

## 11.1 Holiday Event Conversion Rules

**All Holiday Events Convert to Mortal Events:**
- Original holiday events → Mortal seasonal events
- Holiday mechanics converted to Mortal systems
- Holiday rewards converted to Mortal progression
- Holiday NPCs converted to Mortal NPCs

**Conversion Process:**
1. Original holiday event → Mortal seasonal event
2. Holiday mechanics → Converted to Mortal systems
3. Holiday rewards → Converted to Mortal progression (no XP)
4. Holiday NPCs → Converted to Mortal NPCs (faction standing)

## 11.2 Holiday Event Conversion Table

| WoW Holiday | Original Function | Mortal Conversion | Status | Notes |
|-------------|-------------------|-------------------|--------|-------|
| **Noblegarden** | Spring event, egg hunt | Spring Festival | ✅ Preserved | Egg hunt, cosmetic rewards |
| **Children's Week** | Orphan quests | Children's Week | ✅ Preserved | Orphan quests, cosmetic rewards |
| **Midsummer Fire Festival** | Fire festival, bonfires | Midsummer Festival | ✅ Preserved | Bonfires, cosmetic rewards |
| **Brewfest** | Beer festival, racing | Brewfest | ✅ Preserved | Beer festival, racing, cosmetic rewards |
| **Hallow's End** | Halloween event, trick-or-treat | Hallow's End | ✅ Preserved | Trick-or-treat, cosmetic rewards |
| **Pilgrim's Bounty** | Thanksgiving event, feasting | Harvest Festival | ✅ Preserved | Feasting, cosmetic rewards |
| **Feast of Winter Veil** | Christmas event, gifts | Winter Veil | ✅ Preserved | Gift exchange, cosmetic rewards |
| **Love is in the Air** | Valentine's event, romance | Love Festival | ✅ Preserved | Romance quests, cosmetic rewards |
| **Lunar Festival** | Chinese New Year, lanterns | Lunar Festival | ✅ Preserved | Lanterns, cosmetic rewards |

## 11.3 Holiday Event Mechanics Conversion

### Event Duration

**Original:** Fixed dates (e.g., Hallow's End: Oct 18 - Nov 1)
**Mortal:** Flexible dates (GM-controlled, seasonal rotation)
- Events can be extended/shortened by GMs
- Events can be triggered manually via GM tools
- Events can be scheduled via event templates

### Event Rewards

**Original:** XP, items, achievements
**Mortal:** Gold, materials, cosmetics, achievements (no XP)
- All XP rewards removed
- Gold/material rewards preserved
- Cosmetic rewards preserved
- Achievement rewards preserved

### Event NPCs

**Original:** Holiday NPCs (quest givers, vendors)
**Mortal:** Holiday NPCs (faction standing-based)
- NPCs require faction standing (if applicable)
- NPCs provide tasks/contracts (not quests)
- NPCs sell cosmetic items (regional vendors)

## 11.4 Holiday Event Examples

### Hallow's End

**Original Features:**
- Trick-or-treat quests
- Headless Horseman boss
- Candy rewards
- XP rewards

**Mortal Conversion:**
- Trick-or-treat tasks (Task Board)
- Headless Horseman world boss (M-T3)
- Candy rewards (cosmetic items)
- Gold/material rewards (no XP)
- Achievement rewards preserved

### Brewfest

**Original Features:**
- Beer festival quests
- Racing events
- Beer rewards
- XP rewards

**Mortal Conversion:**
- Beer festival tasks (Task Board)
- Racing events (mini-games)
- Beer rewards (cosmetic items)
- Gold/material rewards (no XP)
- Achievement rewards preserved

### Winter Veil

**Original Features:**
- Gift exchange quests
- Greatfather Winter NPC
- Gift rewards
- XP rewards

**Mortal Conversion:**
- Gift exchange tasks (Task Board)
- Greatfather Winter NPC (faction standing-based)
- Gift rewards (cosmetic items)
- Gold/material rewards (no XP)
- Achievement rewards preserved

## 11.5 Holiday Event Template System

**Event Templates:**
- Pre-configured event templates for each holiday
- GM can activate/deactivate events via templates
- Templates include:
  - NPC spawns
  - GameObject spawns
  - Task Board entries
  - Reward configurations
  - Duration settings

**Template Management:**
- Create/edit templates via GM tools
- Activate templates via GM panel
- Monitor event status via telemetry
- Adjust event parameters in real-time

## 11.6 Holiday Event Integration

**Seasonal System:**
- Holiday events tie into seasonal system (`52-season-of-the-frontier.md`)
- Events can trigger seasonal bonuses
- Events can affect resource availability
- Events can affect faction standing

**Economy Integration:**
- Holiday events create economic opportunities
- Event-specific items tradeable
- Event vendors (regional access)
- Event caravans (special transport)

**Social Integration:**
- Holiday events encourage social interaction
- Event mini-games (tavern games)
- Event gatherings (social hubs)
- Event achievements (social prestige)

## 11.7 Holiday Event Conversion Summary

**Preserved Holidays:**
- All major holidays preserved (9 holidays)
- Mechanics converted to Mortal systems
- Rewards converted (no XP)
- NPCs converted (faction standing-based)

**New Holiday Events:**
- Mortal-specific events (GM-created)
- Seasonal events (tied to seasons)
- World events (tied to world simulation)
- Guild events (tied to strongholds)

**Event Management:**
- GM tools for event control
- Event templates for easy activation
- Telemetry for event monitoring
- Web portal for event configuration
