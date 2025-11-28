# Project Canvas: Mortal Warcraft Overhaul
### Version 29.0 — Hybrid Technical Design Document  
### File: 40-anti-bot-rmt-and-security.md  
### Section: Anti-Bot, Anti-RMT, Multibox & Security Baseline

---

## Related Specs

- `14-admin-tools.md` - GM tools and admin panels that use security data
- `42-gm-tools-and-live-events.md` - GM tools that integrate with security system
- `41-telemetry-and-balancing.md` - Telemetry system that shares data with security
- `04-economy.md` - Economy system that security protects from RMT
- `11-pvp-systems.md` - PvP systems that security monitors for abuse
- `08-guilds-sovereignty.md` - Stronghold system that security protects from manipulation

---

## 1. Purpose

Define a **production-level security baseline** for Mortal Warcraft that:

- Protects the **economy** from bots, RMT, and mule networks.
- Limits abuse of **multiboxing** and automation.
- Uses **multiple detection layers** (anticheat, behavior, economy patterns).
- Integrates with GM tools and logging for **reviewable, human decisions**.

This spec is mandatory for production. It assumes the following AzerothCore modules are enabled:

- `mod-anticheat` – movement/combat anticheat.
- Lua engine (`mod-ale` / equivalent) – for behavior tracking hooks.
- AIO/Lua UI integration – for GM/security panels.
- `mod-playerbots` – used under strict control via Mercenary systems.
- `mod-autobalance` – instance mob scaling, must be monitored for abuse.
- `mod-premium`-style logic – used/extended to implement Supporter status.

---

## 2. Threat Model & Goals

### 2.1 Primary Threats

1. **Automation / Botting**
   - Path-grinding bots farming mobs/resources.
   - Fishing/gather bots.
   - Background macroing of skills/crafting.

2. **RMT (Real Money Trading)**
   - Gold/mat selling outfits using:
     - Bot farms,
     - Laundered mule accounts,
     - Out-of-band marketplaces.

3. **Multibox Abuse**
   - Large synchronized armies controlled by one person:
     - PvP win-trading,
     - Warfront manipulation,
     - Economic dominance.

4. **Client Hacks / Cheats**
   - Speed/fly hacks, teleport, no-clip.
   - Cast-time manipulation, cooldown hacks.

### 2.2 Goals

- Make **automation unprofitable** long-term.
- Keep **legit players safe** from false positives.
- Provide **clear evidence** for GM action.
- Ensure **Supporter / Premium** features cannot be abused as pay-to-cheat.

---

## 3. Detection Layers Overview

We use four overlapping layers:

1. **Technical Anticheat (mod-anticheat)**
   - Movement, speed, fly, teleport checks.
2. **Behavioral Metrics**
   - Play patterns indicating bots (24/7 uptime, ultra-regular rotations).
3. **Economic Pattern Detection**
   - Suspicious gold/item transfers (RMT, mule networks).
4. **Multibox & Session Rules**
   - Limits and flags on simultaneous connections and synchronized play.

Each layer writes to shared security tables and feeds a **Security Dashboard** (later in GM tools spec).

---

## 4. Technical Anticheat (mod-anticheat Baseline)

### 4.1 Configuration

- `mod-anticheat` must be enabled with:
  - Speed/fly/teleport checks at **recommended values**.
  - Logging to:
    - AzerothCore logs,
    - Dedicated DB table for actionable events.

We create a normalized table for serious anticheat events:

```sql
CREATE TABLE IF NOT EXISTS mortal_security_anticheat (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  guid            INT NOT NULL,     -- characters.guid
  account_id      INT NOT NULL,
  type            VARCHAR(32) NOT NULL,  -- 'SPEED','FLY','TELEPORT','COMBAT'
  value           FLOAT NULL,            -- magnitude of violation
  map_id          INT NOT NULL,
  zone_id         INT NOT NULL,
  timestamp       INT NOT NULL,
  flags           INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 4.2 Policy

- Single minor violations:
  - Logged, but no immediate action.
- Repeated or egregious violations:
  - Escalate to **behavior flag** (see 5.2).
  - Trigger automatic temporary suspension in extreme cases (configurable).

---

## 5. Behavioral Detection (Play Pattern Analysis)

### 5.1 Activity Summary

We track per-character **session and activity summaries**:

```sql
CREATE TABLE IF NOT EXISTS mortal_activity_summary_daily (
  guid            INT NOT NULL,
  date_int        INT NOT NULL,    -- YYYYMMDD
  session_count   INT NOT NULL DEFAULT 0,
  minutes_played  INT NOT NULL DEFAULT 0,
  kills_pve       INT NOT NULL DEFAULT 0,
  kills_pvp       INT NOT NULL DEFAULT 0,
  nodes_gathered  INT NOT NULL DEFAULT 0,
  tasks_completed INT NOT NULL DEFAULT 0,
  deaths_total    INT NOT NULL DEFAULT 0,
  gold_earned     BIGINT NOT NULL DEFAULT 0,
  gold_spent      BIGINT NOT NULL DEFAULT 0,
  chat_messages   INT NOT NULL DEFAULT 0,
  flags           INT NOT NULL DEFAULT 0,
  PRIMARY KEY (guid, date_int)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

Hooks (Lua/C++):

- On login/logout → update `session_count` + `minutes_played`.
- On kill, gather, task complete → increment relevant counters.
- On gold change (from NPC or player) → track `gold_earned` / `gold_spent`.
- On chat message → increment `chat_messages`.

### 5.2 Security Flags

We maintain a separate flag table:

```sql
CREATE TABLE IF NOT EXISTS mortal_security_flags (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  guid            INT NOT NULL,
  flag_type       VARCHAR(32) NOT NULL,  -- 'BOT_PATTERN','24_7_UPTIME','NO_CHAT','SUSPICIOUS_ROUTE'
  severity        TINYINT NOT NULL,      -- 1=low,2=med,3=high
  details         VARCHAR(255) NULL,
  first_seen      INT NOT NULL,
  last_seen       INT NOT NULL,
  resolved        TINYINT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

Automated analysis (scheduled job or on-demand process) looks for patterns such as:

- **24/7 uptime**:
  - `minutes_played` > threshold for multiple consecutive days.
- **Perfect grinding loops**:
  - High kills/nodes with **almost zero chat**, interactions, group activity.
- **Extreme regularity**:
  - Identical movement/kill rates over time windows.

Flags are **advisory**, not auto-bans. They surface accounts for GM review.

---

## 6. Economic Pattern Detection (RMT & Mules)

### 6.1 Trade & Mail Logging

We log **high-value trades and mail**:

```sql
CREATE TABLE IF NOT EXISTS mortal_trade_log (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  sender_guid     INT NOT NULL,
  receiver_guid   INT NOT NULL,
  timestamp       INT NOT NULL,
  gold_amount     BIGINT NOT NULL DEFAULT 0,
  item_count      INT NOT NULL DEFAULT 0,
  item_value_est  BIGINT NOT NULL DEFAULT 0,  -- estimated via internal pricing
  flags           INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS mortal_mail_log (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  sender_guid     INT NOT NULL,
  receiver_guid   INT NOT NULL,
  timestamp       INT NOT NULL,
  gold_amount     BIGINT NOT NULL DEFAULT 0,
  item_count      INT NOT NULL DEFAULT 0,
  item_value_est  BIGINT NOT NULL DEFAULT 0,
  flags           INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

`item_value_est` can use:

- Internal price lookup table for key mats,
- AH median pricing (when available),
- Or static design-time values.

### 6.2 Suspicious Transfer Detection

We add a **secondary table for flagged transfers**:

```sql
CREATE TABLE IF NOT EXISTS mortal_security_econ_flags (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  source_guid     INT NOT NULL,
  target_guid     INT NOT NULL,
  timestamp       INT NOT NULL,
  direction       VARCHAR(8) NOT NULL,   -- 'TRADE','MAIL'
  gold_amount     BIGINT NOT NULL DEFAULT 0,
  item_value_est  BIGINT NOT NULL DEFAULT 0,
  reason          VARCHAR(64) NOT NULL,  -- 'LARGE_ONE_WAY','MULE_PATTERN'
  details         VARCHAR(255) NULL,
  severity        TINYINT NOT NULL,      -- 1..3
  resolved        TINYINT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

Automated rules (tunable):

- **Large one-way transfers**:
  - A → B with gold + value above a daily threshold, no reciprocal activity.
- **Mule patterns**:
  - Many low-activity accounts sending to one central account.
- **Supporter / Premium anomalies**:
  - New Supporter accounts funneling large amounts of wealth to non-Supporter accounts quickly.

Again, these are **flags** for GM investigation, not instant bans.

---

## 7. Multibox Rules & Detection

### 7.1 Policy

- Define a max allowed simultaneous connections per physical user:
  - e.g., **2–3 concurrent connections** is allowed.
- Above this soft cap:
  - Accounts are flagged for **multibox review**.
- Prohibit:
  - Synchronized multiboxing in competitive PvP (arenas/RBG/Warfronts) beyond the cap.

### 7.2 Session Tracking

We record session info with IP and (if implemented) hardware fingerprint:

```sql
CREATE TABLE IF NOT EXISTS mortal_session_log (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  account_id      INT NOT NULL,
  guid            INT NOT NULL,
  ip_address      VARCHAR(45) NOT NULL,
  hw_hash         VARCHAR(64) NULL,      -- hardware fingerprint if available
  login_time      INT NOT NULL,
  logout_time     INT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

Analysis looks for:

- Many accounts from same `ip_address` or `hw_hash` active concurrently.
- Cross-correlation with:
  - Activity (all characters moving together, doing same actions),
  - Econ logs (feeding one master).

Flagged accounts appear in **Security Dashboard** with:

- Connection counts,
- Activity summaries,
- Econ flags.

---

## 8. Integration with Playerbots & Autobalance

### 8.1 Playerbots

`mod-playerbots` is **restricted** to:

- Mercenary/Companion systems:
  - Only hired via specific Gossip menus.
  - Only spawn in certain contexts (instanced dungeons, limited public zones).
- Bots must:
  - Not count as “real” players in metrics that would skew economy/participation data.
  - Be excluded from:
    - RMT detection,
    - Activity anomaly checks.

We add a simple flag in character table or a mapping table:

```sql
CREATE TABLE IF NOT EXISTS mortal_bot_characters (
  guid            INT PRIMARY KEY   -- bot character GUIDs
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

Analysis ignores entries found here.

### 8.2 Autobalance Abuse

`mod-autobalance` scales mobs based on party size. Possible abuse:

- Single player + many bot accounts artificially boosting difficulty/rewards.

Mitigations:

- Reward structures (loot, tokens) should scale with:
  - **Real players only**, not total group size.
- Autobalance settings must:
  - Not dramatically raise loot/xp for higher group sizes.
- Security checks:
  - Compare “effective group size” vs “real players” in suspicious runs.

---

## 9. Enforcement Workflow

### 9.1 Severity Levels

We define three severity levels:

- **Level 1 – Watchlist**
  - Single or mild flags (odd econ transfer, slightly botty behavior).
  - Action: GM notes, closer monitoring, no player-facing action.

- **Level 2 – Sanctions**
  - Multiple flags or one strong technical violation (e.g. repeated speed hacks).
  - Action:
    - Temporary suspension,
    - Confiscation of obviously botted wealth.

- **Level 3 – Ban**
  - Confirmed large-scale botting/RMT or cheat use.
  - Action:
    - Permanent ban of account(s),
    - Optional HW/IP block,
    - Confiscation/wiping of involved economic assets.

### 9.2 GM Tools (Hooks)

GM dashboard (defined in GM tools spec) should show:

- For each suspect:
  - Anticheat events.
  - Activity summaries.
  - Econ flags & transfer graphs.
  - Session/IP clusters.

GM interface supports:

- Tagging flags as **resolved / false positive**.
- Applying sanctions with a logged reason.

---

## 10. Logging, Privacy & Retention

- Retain detailed logs (trade/mail/security) for a **rolling window** (e.g., 90–180 days).
- Summarized activity (`mortal_activity_summary_daily`) can be kept longer.
- Provide admin commands to:
  - Anonymize or purge old detailed logs if needed.

---

## 11. Status

This security baseline:

- Assumes `mod-anticheat`, `mod-playerbots`, `mod-autobalance`, and premium/Supporter systems are in place.
- Requires:
  - SQL migrations for the tables described here.
  - Lua/C++ hook points for:
    - Activity updates,
    - Trade/mail logging,
    - Session tracking.
  - GM dashboard views built on these tables (see GM tools spec).

Once implemented, this will give Mortal Warcraft a **multi-layered, GM-reviewable defense** against bots, RMT, and abusive multiboxing, preserving the integrity of the sandbox economy.
