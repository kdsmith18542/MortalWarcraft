# Project Canvas: Mortal Warcraft Overhaul
### Version 27.0 — Hybrid Technical Design Document  
### File: 34-mortal-arena-and-rating.md  
### Section: Mortal Arena & Rating System (2s / 3s / 5s / 1s)

---

## 1. Purpose

Define how **Arena PvP** works in Mortal Warcraft, using:

- The **original 3.3.5a arena structure** (2v2, 3v3, 5v5 teams, rating, weekly rewards),
- But integrated with:
  - Mortal’s **PvP gear tiers** (P1–P6),
  - **Military Credits** (Honor → Military currency),
  - Mortal’s **risk philosophy** (full loot in Warfronts/Red Zones, not everywhere).

Design goals:

1. Preserve the feel of **classic arenas** for PvP enthusiasts.
2. Make arenas a **clean, competitive environment** (no full-loot friction).
3. Tie arena rating to **P-tier progression** in a clear, predictable way.
4. Keep 1v1 as **optional side content**, not the main rated ladder.

---

## Related Specs

For full context on arena systems, see:

- **`11-pvp-systems.md`** — Core PvP systems and mechanics used in arenas
- **`35-mortal-pvp-vendors-and-rewards.md`** — PvP vendors and reward systems tied to arena rating
- **`02-combat.md`** — Combat mechanics and formulas used in arena matches
- **`84-mortal-core-stats-and-combat-model.md`** — Stat formulas that determine arena performance
- **`36-mortal-achievements-and-titles-core.md`** — Achievement and title system for arena rewards
- **`33-instance-and-battleground-tier-mapping.md`** — Arena instance mapping and tier structure

---

## 2. Brackets & Roles

### 2.1 Official Rated Brackets

We support three rated brackets:

- **2v2** → “Duos”: accessible competitive PvP.
- **3v3** → “Trios”: **primary competitive bracket** for top rewards.
- **5v5** → “Warbands”: optional high-chaos bracket, can tie into Warfront theming.

Each bracket uses:

- Arena **teams** (as in 3.3.5a):
  - Team name, captain, roster.
  - Team rating per bracket.
- A combined **rating + MMR** approach (see §3).

### 2.2 1v1 (Unrated “Pits” / Optional)

There is **no official rated 1v1 bracket**.

1v1 is offered as:

- **Duel Queue**:
  - Quick fights in a small arena map.
  - Uses personal **“duel MMR”** purely for matchmaking; no seasonal rewards.
- **Wager Pits Integration**:
  - Optionally reuse the **Fighting Pits** (Gurubashi / Ring of Trials) as 1v1 wager arenas:
    - Gold betting.
    - Cosmetic titles / vanity rewards.
    - No P-tier gear rewards.

This keeps 1v1 as a **fun, ego/side mode**, not the core gear path.

---

## 3. Rating Model

### 3.1 Team Rating & Hidden MMR

We mirror WotLK’s basic concept:

- **Team Rating (R_team)**:
  - Starts at **1500** (configurable).
  - Visible rating used for:
    - Rewards, titles, ladders.

- **Matchmaking Rating (MMR)**:
  - Per team & bracket.
  - Used for finding opponents.
  - Usually tracks close to team rating, but may diverge briefly on streaks.

### 3.2 Personal Participation (Lightweight)

We simplify **personal rating** to reduce complexity:

- Each character has:
  - `mortal_arena_personal` rows per bracket (2s/3s/5s).
- Personal rating mirrors team rating but with:
  - A “participation factor”:
    - You must play at least **X% of the team’s games that week** to qualify for full rewards for that team.

Implementation detail:

- Avoid overcomplicating; prefer:
  - `games_played_this_week` and `games_won_this_week` per character+team.
  - A simple rule: **at least 30% of games** for that team this week to qualify.

### 3.3 Table: mortal_arena_seasons

Tracks global season configuration:

```sql
CREATE TABLE IF NOT EXISTS mortal_arena_seasons (
  id                INT AUTO_INCREMENT PRIMARY KEY,
  name              VARCHAR(64) NOT NULL,
  start_time        INT NOT NULL,
  end_time          INT NOT NULL,
  is_active         TINYINT NOT NULL DEFAULT 0,
  reward_profile    VARCHAR(32) NOT NULL,   -- e.g. 'S1_DEFAULT'
  notes             VARCHAR(255) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 3.4 Table: mortal_arena_team_rating (Overlay)

We can either reuse AzerothCore’s arena_team tables, or add an overlay. For clarity, we add a Mortal overlay linked to `arena_team.id`:

```sql
CREATE TABLE IF NOT EXISTS mortal_arena_team_rating (
  id                INT AUTO_INCREMENT PRIMARY KEY,
  arena_team_id     INT NOT NULL,       -- FK to arena_team.id
  bracket           TINYINT NOT NULL,   -- 2,3,5
  rating            INT NOT NULL DEFAULT 1500,
  mmr               INT NOT NULL DEFAULT 1500,
  season_id         INT NOT NULL,
  games_played      INT NOT NULL DEFAULT 0,
  games_won         INT NOT NULL DEFAULT 0,
  last_update       INT NOT NULL,
  UNIQUE KEY uk_team_bracket_season (arena_team_id, bracket, season_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

If you prefer to stick to AC’s default system more closely, this table can be a view/proxy; the important part is that **Cursor has a canonical design**.

---

## 4. Rewards & PvP Gear Tiers (P1–P6)

### 4.1 Rating Bands → P-Tiers

We map **peak rating** (per season, per bracket) to **reward bands**:

Example bands:

- **P1** (Entry PvP):  
  - Rating 1300–1499 (any bracket).
- **P2** (Core PvP set):  
  - Rating 1500–1699.
- **P3** (Serious PvP set):  
  - Rating 1700–1899.
- **P4** (High PvP set):  
  - Rating 1900–2099.
- **P5** (Elite PvP set):  
  - Rating 2100–2299.
- **P6** (Top-end / gladiator-equivalent):  
  - Rating 2300+.

We can define per-bracket weighting (3v3 favored):

- 2s:
  - Counts fully towards P1–P4.
  - Only awards P5–P6 cosmetics/titles, not stat-dominant gear.
- 3s:
  - Full reward track P1–P6.
- 5s:
  - Optional; can be tuned to award slightly fewer tokens to avoid it overshadowing 3s.

### 4.2 Table: mortal_arena_rating_bands

```sql
CREATE TABLE IF NOT EXISTS mortal_arena_rating_bands (
  id                INT AUTO_INCREMENT PRIMARY KEY,
  code              VARCHAR(32) NOT NULL,  -- 'P1','P2',..,'P6'
  min_rating        INT NOT NULL,
  max_rating        INT NOT NULL,
  bracket_mask      TINYINT NOT NULL DEFAULT 7,   -- bitmask: 1=2s,2=3s,4=5s
  weekly_token_base INT NOT NULL,                 -- base weekly token reward
  weekly_credits    INT NOT NULL,                 -- base weekly Military Credits
  notes             VARCHAR(255) NULL,
  UNIQUE KEY uk_code (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

You can then tune:

- `weekly_token_base` and `weekly_credits` per band and per season.

### 4.3 Weekly Rewards

At weekly reset:

- For each character:
  1. Determine **best rating band** they qualified for:
     - Highest team rating across their teams where:
       - They played at least X% of games for that team.
  2. Grant:
     - **PvP Tokens** (used directly to buy P1–P6 pieces).
     - **Military Credits** (shared currency used for siege gear, Warfront things, etc., as per your Honor Overhaul).

You remove:

- The old **Arena Points / Honor Points** Emblem-style currencies,
- And replace them with Mortal currencies in line with your other PvP systems.

---

## 5. Risk & Loot Rules (Arenas vs Warfronts)

### 5.1 Arenas = Competitive, Low-Risk PvP

Core philosophy:

> Arenas are the **structured, low-friction competitive space**.  
> Warfronts, Red Zones, Hellgates = high-risk sandbox PvP.

So, in **Arena instances**:

- **No full loot**:
  - Death does *not* create a corpse chest.
- **No gear drop**:
  - You cannot loot the opponent’s gear.
- **Durability loss**:
  - Either **0%** or very low (cosmetic penalty only).
- **Queue / Access**:
  - Classic style queue via Arena NPCs or UI.
  - You can optionally keep them separate from world portals to emphasize “sport”.

This keeps arenas:

- Focused on **skill, comp, and meta**.
- Not gating entire characters behind full-loot PTSD.

### 5.2 Warfronts & Red Zones = High-Risk

- Warfronts (AB/AV-style) and Red Zone world PvP:
  - Follow your existing **full loot** + corpse chest rules.
- Arenas:
  - Reward **tokens/credits**, not enemy items.

This clear separation makes Mortal more approachable while retaining your high-risk sandbox identity.

---

## 6. 1v1 Duel / Pit Integration

### 6.1 Duel Queue (Optional)

Implement an **unrated 1v1 queue**:

- Uses small arena maps.
- Players queue solo, matched by a **duel MMR** (stored in a simple table).
- Rewards:
  - Tiny amounts of gold / fun vanity tokens.
  - No P-tier gear / no serious progression.

### 6.2 Fighting Pits (Gurubashi / Ring of Trials)

From your main spec:

- Fighting Pits are **gold wager matches**.

Design integration:

- Allow:
  - 1v1 / 2v2 / FFA pit modes.
- Bets:
  - Gold, optional Gladiator Tokens (a side currency).
- Rules:
  - Decide:
    - Either **no full loot**, just gold wagers.
    - Or **full loot enabled** but very clearly signposted: “High Risk Pit”.

Pits remain:

- A sandbox, social, high-drama layer.
- Separate from the **ranked ladder**…

---

## 7. Minimal Schema Additions (Summary)

New tables proposed:

1. `mortal_arena_seasons`
2. `mortal_arena_team_rating` (overlay referencing `arena_team`)
3. `mortal_arena_rating_bands`

Optionally:

- `mortal_arena_duel_mmr` if you want persistent 1v1 matchmaking data.

All other logic can be:

- Driven by existing AC arena structures + these overlays, plus C++/script hooks for:
  - Reward calculation at reset.
  - Rating/MMR updates post-match.

---

## 8. Status

This spec defines:

- **Which brackets are official** (2s/3s/5s) and how 1s fits (unrated).
- **How rating, seasons, and rewards** tie into Mortal’s P1–P6 tiers and Military Credits.
- A **clear separation** between:
  - Arenas (competitive, low-risk),
  - Warfronts/Red Zones/Hellgates (Mortal high-risk sandbox PvP).

You can now point Cursor at:

- This doc (`34-mortal-arena-and-rating.md`),
- Your PvP gear tier spec,
- And the main Warfront/Stronghold docs,

to implement:

- Rating band logic,
- Weekly reward scripts,
- And the arena-side UI/tooling for the Mortal PvP ecosystem.
