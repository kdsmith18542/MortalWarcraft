# Project Canvas: Mortal Warcraft Overhaul
### Version 33.5 — Hybrid Technical Design Document  
### File: 52-season-of-the-frontier.md  
### Section: Seasonal Challenge Track (“Season of the Frontier”)

---

## 1. Purpose

Define a **seasonal challenge system** (“Season of the Frontier”) inspired by Nightwave-style passes, customized for Mortal Warcraft’s:

- **Sandbox, full-loot, classless** design.
- Strong emphasis on **Factions**, **Strongholds**, **Rifts**, **Hellgates**, **Trade**, and **Events**.
- Goal to improve **retention, direction, and variety** without:
  - Theme-park queueing,
  - Mandatory daily checklists,
  - Raw power creep.

Seasons provide:

- A **time-limited track** (e.g., 8–12 weeks) with levels (“Ranks”).
- **Challenges** (Dailies, Weeklies, Seasonals) that push players into varied content.
- **Rewards** focused on:
  - Cosmetics, titles, banners, mounts/skins,
  - Faction tokens, crafting mats, respecs, bag upgrades,
  - Limited, carefully-scoped utility (no flat +% damage/healing globals).

---

## Related Specs

For full context on seasonal systems, see:

- **`01-progression.md`** — Progression system that seasons complement (meta-progress, not combat power)
- **`43-long-term-progression-and-seasons.md`** — Long-term progression and seasonal framework
- **`51-factions-and-standing-system.md`** — Faction system that provides seasonal challenges and rewards
- **`36-mortal-achievements-and-titles-core.md`** — Achievement system that tracks seasonal progress
- **`48-zone-invasions-and-cross-faction-pve.md`** — Zone invasions and events that provide seasonal content
- **`76-dynamic-tasks-and-contracts-2-0-spec.md`** — Task boards that provide seasonal challenges
- **`91-mortal-anomalies-rifts-hellgates.md`** — Rifts and hellgates that provide seasonal content

---

## 2. Core Structure

### 2.1 Season Object

Each season has:

- ID & name: e.g., `SEASON_OF_THE_RISEN`, “Season of the Risen”.
- Thematic wrapper:
  - Lore blurb tying to current world events (Midnight Horde, Invasions, etc.).
- Start and end timestamps.
- Total **Ranks** (e.g., 30 or 40).
- Per-rank **reward definitions**.

### 2.2 Player Progress

Each character (or account-wide, configurable) tracks:

- Current **Season Renown**,
- Current **Rank**,
- Which rewards claimed,
- Which challenges completed (per reset window).

Season Renown is gained by completing challenges, not by raw grinding.

### 2.3 Challenge Types

- **Dailies**:
  - Small tasks, reset every 24h.
- **Weeklies**:
  - Larger tasks, reset every 7 days.
- **Seasonals**:
  - Long-term or “once per season” objectives.

Each challenge grants:

- Season Renown,
- Optional bonus rewards (faction standing, items, currency) immediately on completion.

---

## 3. Challenge Design

### 3.1 Design Goals

Challenges should:

- Encourage players to **touch multiple systems**:
  - Rifts, Strongholds, Trade, Fishing, First Aid, Factions, Hellgates, etc.
- Respect **risk zoning**:
  - Some tasks specifically in Yellow/Red zones,
  - Others accessible to lower-risk players in Green/Yellow.
- Avoid “log in or fall behind” pressure:
  - Seasonals and catch-up renown sources,
  - Generous weekly renown budget.

### 3.2 Example Daily Challenges

Examples (not exhaustive):

- “Complete 2 Courier Contracts (any zone).”
- “Defeat 20 enemies in a Public Dungeon.”
- “Catch 5 fish in any Yellow Zone.”
- “Complete 1 Task Board quest in a town under a current ‘Hot Zone’ modifier.”
- “Visit and pray at 2 different Shrines (no death required).”

### 3.3 Example Weekly Challenges

Examples:

- “Complete 3 Hellgates (any difficulty).”
- “Participate in at least one Stronghold Defense or Siege (win or lose).”
- “Deliver a trade caravan from a Red Zone to a Green Zone city.”
- “Earn 1,000 Standing with any Faction.”
- “Clear a Midnight Horde event to completion.”
- “Win 3 matches in the Fighting Pits (any wager size).”

### 3.4 Example Seasonal Challenges

Examples:

- “Reach Exalted with any one Faction.”
- “Capture or defend a Stronghold during a successful siege.”
- “Complete 10 Hellgates without dying.”
- “Participate in the defeat of each of the current season’s World Bosses.”
- “Survive for 15+ waves in a single Endless Defense Contract (once implemented).”

---

## 4. Rewards

### 4.1 Reward Philosophy

- Mostly **cosmetics & options**, not raw power.
- When granting utility:
  - Small, bounded, and often temporary or contextual.
- Spread rewards across:
  - Individual ranks,
  - Milestone ranks (e.g., Rank 10/20/30).

### 4.2 Reward Categories

- **Cosmetics**:
  - Armor/mount skins,
  - Weapon illusions,
  - Banners, cloaks, tabards,
  - Emotes & poses,
  - Shrine and Stronghold decoration blueprints.
- **Economic / Utility**:
  - Faction commendations (tokens redeemable for Standing),
  - Trade certificates (one-time fee reduction on AH listings),
  - Insurance vouchers (discount on item “Soul Insurance” premiums),
  - Bank vouchers (temporary extra slots).
- **Progression Adjacent**:
  - Respec tokens (Mastery Trees, attribute redistributions),
  - Extra bag slots or one-time permanent bag unlocks,
  - Small bundles of crafting mats (ore, wood, fish, reagents), tuned as time-savers not mandatory power.

No season reward should:

- Grant new rune/ability that is **never available again**,
- Provide permanent, unbounded combat advantage over non-participants.

New abilities unlocked via seasons should later be:

- Obtainable via permanent content (e.g., as high-end faction reward or rare drop), or
- Purely cosmetic variants of existing abilities.

---

## 5. Data Model (MySQL)

### 5.1 Seasons

```sql
CREATE TABLE IF NOT EXISTS mortal_seasons (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  code            VARCHAR(64) NOT NULL UNIQUE, -- e.g. 'SEASON_OF_THE_RISEN'
  name            VARCHAR(128) NOT NULL,
  description     TEXT NOT NULL,
  start_ts        INT NOT NULL,
  end_ts          INT NOT NULL,
  total_ranks     INT NOT NULL DEFAULT 30,
  is_active       TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 5.2 Season Ranks & Rewards

```sql
CREATE TABLE IF NOT EXISTS mortal_season_ranks (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  season_id       INT NOT NULL,
  rank_number     INT NOT NULL,           -- 1..N
  renown_required INT NOT NULL,           -- cumulative or per-rank cost
  reward_json     JSON NULL,              -- structured rewards list
  CONSTRAINT fk_mortal_season_ranks_season
    FOREIGN KEY (season_id) REFERENCES mortal_seasons(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

`reward_json` could contain entries like:

```json
[
  {"type": "ITEM", "ref": "ITEM_ID", "count": 1},
  {"type": "CURRENCY", "ref": "GOLD", "amount": 5000},
  {"type": "TITLE", "ref": "TITLE_ID"}
]
```

### 5.3 Challenges

```sql
CREATE TABLE IF NOT EXISTS mortal_season_challenges (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  season_id       INT NOT NULL,
  code            VARCHAR(64) NOT NULL,       -- 'DAILY_FISH_YELLOW', 'WEEKLY_HELLGATE_3X'
  name            VARCHAR(128) NOT NULL,
  description     TEXT NOT NULL,
  category        VARCHAR(16) NOT NULL,       -- 'DAILY','WEEKLY','SEASONAL'
  renown_reward   INT NOT NULL,
  meta_json       JSON NULL,                  -- parameters (target counts, zone tags, etc.)
  is_active       TINYINT(1) NOT NULL DEFAULT 1,
  CONSTRAINT fk_mortal_season_challenges_season
    FOREIGN KEY (season_id) REFERENCES mortal_seasons(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 5.4 Player Season Progress

Account-level or character-level (choose model; here: character-level):

```sql
CREATE TABLE IF NOT EXISTS mortal_season_progress (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  guid            INT NOT NULL,              -- character guid
  season_id       INT NOT NULL,
  current_renown  INT NOT NULL DEFAULT 0,
  current_rank    INT NOT NULL DEFAULT 0,
  rewards_claimed JSON NULL,                 -- list of rank_numbers already claimed
  last_update_ts  INT NOT NULL,
  UNIQUE KEY uniq_character_season (guid, season_id),
  CONSTRAINT fk_mortal_season_progress_season
    FOREIGN KEY (season_id) REFERENCES mortal_seasons(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 5.5 Player Challenge Completion

```sql
CREATE TABLE IF NOT EXISTS mortal_season_challenge_state (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  guid            INT NOT NULL,
  challenge_id    INT NOT NULL,
  progress_value  INT NOT NULL DEFAULT 0,
  completed       TINYINT(1) NOT NULL DEFAULT 0,
  reset_ts        INT NOT NULL,                -- when this challenge resets for this player
  CONSTRAINT fk_mortal_season_challenge_state_challenge
    FOREIGN KEY (challenge_id) REFERENCES mortal_season_challenges(id)
    ON DELETE CASCADE,
  INDEX idx_char_challenge (guid, challenge_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

---

## 6. Server Logic

### 6.1 Renown & Rank Calculation

- Season Renown is granted on **challenge completion**.
- Rank can be:
  - Computed on the fly from `current_renown` using `mortal_season_ranks`,
  - Or cached in `current_rank` for convenience.

On Renown gain:

1. Add renown to `current_renown`.
2. Compute new rank:
   - If new rank > old rank:
     - Flag those ranks as “unclaimed” in `rewards_claimed`.

### 6.2 Challenge Progress Updates

Hook into existing systems:

- When a relevant event fires (Hellgate complete, Courier delivered, Rift closed, etc.):
  - Server checks:
    - Active season?
    - Player enrolled?
    - Matching challenges for this season & category?
  - Increments `progress_value` for those challenges,
  - Marks `completed` and triggers renown gain if thresholds met.

### 6.3 Reset Logic

- Dailies:
  - Reset every 24h based on server-time.
- Weeklies:
  - Reset every 7 days (e.g., fixed weekday/time).
- Seasonals:
  - Do not reset until season end.

Reset action:

- For each relevant `mortal_season_challenge_state` row:
  - If category = DAILY or WEEKLY, reset `progress_value`, `completed`, `reset_ts`.

---

## 7. Integration with Other Systems

### 7.1 Factions

- Many challenges can be **faction-flavored**:
  - “Earn 500 Standing with Iron Ledger this week.”
  - “Complete 3 Rangers’ Pact contracts.”
- Season rewards can include:
  - Faction commendations,
  - Unique cosmetics that show faction + season brand.

### 7.2 Strongholds & Sieges

Challenges:

- “Defend a Stronghold during a siege (participation credit).”
- “Capture one Stronghold from ENEMY guilds during the season.”
- “Complete 3 days in a row of Stronghold patrol contracts.”

Rewards:

- Cosmetic Stronghold decorations tied to the season theme.

### 7.3 Rifts, Hellgates, and Events

Challenges:

- “Close 5 planar Rifts in any Red Zone.”
- “Complete 2 Hellgates without any party member dying.”
- “Survive a full Midnight Horde event.”

These directly reuse your dynamic event hooks.

### 7.4 Atlas & War Board

- Atlas should show:
  - Current season info (name, theme, dates),
  - Player’s rank and progress (if authenticated),
  - List of active Weekly/Seasonal challenges.
- War Board (in-game):
  - Rotating panel:
    - “Seasonal Focus” section showing some challenges.

---

## 8. UI & UX

### 8.1 In-Game Seasonal UI (MortalUI Addon)

- **Season Panel** (similar to Factions panel):
  - Shows:
    - Season name, art, time remaining,
    - Current rank and renown bar,
    - Rank rewards list.
- **Challenges Tab**:
  - Sections: Dailies / Weeklies / Seasonals.
  - Each entry:
    - Name + description,
    - Progress (e.g., 2/3 Hellgates),
    - Renown reward,
    - Icons for associated systems (Factions, Rifts, Strongholds, etc.).
- Reward claims:
  - Button to claim rank rewards,
  - Visual indicator for claimed/unclaimed ranks.

### 8.2 Atlas UI

- Season landing page:
  - High-level description, trailer art, lore snippet.
- Authenticated player view:
  - Current rank, renown, claimed rewards,
  - List of current Weeklies/Seasonals.
- Optional:
  - Global stats:
    - Number of Hellgates completed this season,
    - Strongholds captured, etc.

---

## 9. Anti-FOMO & Catch-Up

To avoid punishing players who can’t log in every day:

- **Generous Weekly renown budget**:
  - A player focusing on Weeklies + Seasonals can complete the track.
- **No mandatory Daily streaks**:
  - Dailies are **bonus renown**, not required.
- **Catch-up mechanic**:
  - Past a certain date:
    - Players below a target rank get **small bonus renown** from new completions,
    - Or a one-time “backdated renown” grant on login.

Seasons should feel:

- Like “fun themed campaigns,”
- Not like a second job.

---

## 10. Implementation Checklist

1. **DB**
   - Create `mortal_seasons`, `mortal_season_ranks`,
     `mortal_season_challenges`, `mortal_season_progress`,
     `mortal_season_challenge_state`.
   - Seed test season: `SEASON_OF_THE_RISEN` with dummy dates & rewards.

2. **Server Hooks**
   - Central helpers for:
     - Getting active season,
     - Granting Season Renown,
     - Updating challenge progress on event triggers.
   - Event integration:
     - Courier completion,
     - Hellgate win,
     - Rift closure,
     - Shrine defense success,
     - Stronghold siege participation,
     - Fishing/First Aid events as desired.

3. **UI**
   - MortalUI: Season panel + Challenges tab.
   - Add “Season Renown gained” floating combat-text-like feedback.

4. **Atlas**
   - REST endpoints:
     - `GET /api/season/current`,
     - `GET /api/season/challenges`,
     - `GET /api/season/progress` (auth).
   - Frontend pages for Season overview and player progress.

5. **Balancing**
   - First test season with:
     - 20–30 ranks,
     - Conservative renown requirements,
     - Mix of low-friction and high-risk challenges.
   - Iterate based on playtests:
     - Challenge variety,
     - Time investment needed to complete track.

---

This system is intentionally scaffolded to sit *on top of* your existing and planned content, using your Factions, Strongholds, Rifts, Hellgates, Fishing, First Aid, contracts and events as the building blocks for challenges and rewards.
