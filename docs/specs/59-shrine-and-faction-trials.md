# Project Canvas: Mortal Warcraft Overhaul
### Version 36.0 — Hybrid Technical Design Document  
### File: 59-shrine-and-faction-trials.md  
### Section: Shrine & Faction Solo Trials (Mage-Tower Style)

---

## 1. Purpose

Add **highly tuned, solo challenge encounters** inspired by WoW’s Mage Tower:

- Solo-only scenarios,
- Fixed or normalized difficulty,
- Strong emphasis on **player skill and build mastery**,
- Rewards focused on **cosmetics, titles, runes/augments** (not raw power creep).

These integrate with:

- Shrines (Order of the Shrine),
- Faction Sanctums,
- Season of the Frontier,
- Weapon Legacy / Appearance Codex.

---

## Related Specs

For full context on shrine and faction trial systems, see:

- **`51-factions-and-standing-system.md`** — Faction system that trials are tied to
- **`60-faction-sanctums.md`** — Faction sanctums where trials are accessed
- **`52-season-of-the-frontier.md`** — Seasonal system that provides trial challenges
- **`61-weapon-legacy-and-history.md`** — Weapon legacy system that trials can unlock
- **`57-appearance-codex-and-transmog.md`** — Appearance codex that trials can unlock
- **`02-combat.md`** — Combat mechanics (Brace, Guard Counter) used in trials
- **`84-mortal-core-stats-and-combat-model.md`** — Stat formulas that trials normalize

---

## 2. Concept Overview

### 2.1 Trial Types

Each Trial is:

- A **scenario-style encounter**:
  - Wave-based fights,
  - Boss mechanics,
  - Movement & survival puzzles.

Difficulty is:

- Tuned to expect:
  - Reasonable Mortal gear progression,
  - Use of Brace, Guard Counter, and Runes/Augments,
- **Normalized** where needed to reduce gear disparity:
  - Normalize base stats up/down into an intended band,
  - Still respect player builds and abilities.

### 2.2 Trial Themes

Examples:

- **Trial of the Bulwark**:
  - Focus: mitigation, HP management, Guard Counter and Brace usage.
- **Trial of the Blade**:
  - Focus: dealing sustained damage while handling mechanics.
- **Trial of the Veil**:
  - Focus: movement, dodging AOEs, kiting.
- **Trial of the Lifeline**:
  - Focus: healing/First Aid, NPC survival, cleansing debuffs.

Tied to:

- Order of the Shrine,
- Rangers’ Pact,
- Iron Ledger (logistical survival trials),
- Other factions for variety.

---

## 3. Access & Flow

### 3.1 Where Trials Are Accessed

- **Shrine Trials**:
  - Accessed at specific Shrines for defensive/undead themed challenges.
- **Faction Trials**:
  - Accessed inside Faction Sanctums (see Sanctum spec).
  - Each faction has its own Trial series.

### 3.2 Entry Requirements

- Character requirements:
  - Minimum Dynamic Level (e.g., ≥ 10),
  - Certain Faction standing for deeper tiers.
- Resource requirements:
  - Trial Token (e.g., “Shrine Challenge Token”),
  - Minimal gold fee to prevent trivial spam.

Entry triggers:

- Teleport player to a private instance of a designed Trial map (scenario-style),
- Normalize stats if needed.

---

## 4. Data Model (MySQL)

### 4.1 Trial Definitions

```sql
CREATE TABLE IF NOT EXISTS mortal_trials (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  code            VARCHAR(64) NOT NULL UNIQUE,   -- 'TRIAL_BULWARK_T1'
  name            VARCHAR(128) NOT NULL,
  description     TEXT NOT NULL,
  tier            INT NOT NULL DEFAULT 1,        -- difficulty tier
  faction_tag     VARCHAR(64) NULL,             -- 'ORDER_SHRINE','RANGERS_PACT',etc.
  map_id          INT NOT NULL,
  entry_npc_id    INT NULL,                     -- optional reference
  normalized_band_json JSON NULL,               -- normalization parameters
  reward_json     JSON NOT NULL,                -- one-time and repeat rewards
  flags           INT NOT NULL DEFAULT 0,
  is_active       TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

`normalized_band_json` example:

```json
{
  "min_ilvl": 1,
  "max_ilvl": 5,
  "stat_scale_multiplier": 1.0
}
```

### 4.2 Trial Progress & Achievements

```sql
CREATE TABLE IF NOT EXISTS mortal_trial_progress (
  id              BIGINT AUTO_INCREMENT PRIMARY KEY,
  guid            INT NOT NULL,
  trial_id        INT NOT NULL,
  best_result_json JSON NOT NULL,               -- e.g. { "success": true, "time_sec": 540, "deaths": 1 }
  completions     INT NOT NULL DEFAULT 0,
  last_attempt_ts INT NOT NULL,
  UNIQUE KEY uniq_guid_trial (guid, trial_id),
  CONSTRAINT fk_mortal_trial_progress_trial
    FOREIGN KEY (trial_id) REFERENCES mortal_trials(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

---

## 5. Normalization & Fairness

### 5.1 Normalization Strategy

We do not want Trials to be trivialized by outgearing content.

Options:

- Normalize **base stats** into a band:
  - Clamp attributes to [X, Y] ranges,
  - Preserve relative build choices (e.g., tanky vs glass cannon).
- Normalize **gear tier**:
  - Use a scaled item budget; apply a global multiplier to damage taken/dealt inside the instance.

Implementation rough idea:

- On entering Trial:
  - Snapshot base stats,
  - Apply scaling aura / aura script:
    - Buff/nerf damage dealt/taken.
- Keep it simple for v1:
  - Use a percentage-based damage taken/dealt aura per Trial tier.

---

## 6. Rewards

### 6.1 One-Time Rewards

On first completion per Trial tier:

- Unique **cosmetics**:
  - Armor/mount appearance unlocks,
  - Weapon appearances,
  - Visual-only spell effects (if possible).
- Unique **titles**:
  - *Bulwark of the Shrine*,
  - *Blade of the Frontier*,
  - *Veil Dancer*, etc.
- Unique **runes or augments**:
  - Primarily utility or flavor variants:
    - Brace FX changes,
    - Slight stat rebalancing, not raw raw DPS bumps.

### 6.2 Repeat Rewards

On repeat completions:

- Modest:
  - Faction standing,
  - Season Renown,
  - Appearance Tokens or small material bundles.

Focus: Trials are about prestige & mastery, not endless farming.

---

## 7. Integration with Other Systems

### 7.1 Factions

Trials:

- Gate deeper tiers behind higher standing,
- Grant standing on completion,
- Reward faction-branded cosmetics.

### 7.2 Seasons

Season challenges:

- “Complete any Tier-2 Trial this season.”
- “Complete Trial of the Bulwark deathless.”

Link to Season of the Frontier spec:
- Trials are explicit challenge types for Dailies/Weeklies/Seasonals.

### 7.3 Weapon Legacy & Appearance Codex

- Certain Trials reward:
  - Legacy marks for Weapon History (cosmetic badges),
  - High-prestige appearances for weapons/armor.

---

## 8. UI & UX

### 8.1 Trial Browser UI

- Accessed via:
  - Shrine NPC gossip,
  - Faction Sanctum keeper NPC.

Shows:

- Available Trials by:
  - Tier,
  - Faction,
  - Theme (Bulwark/Blade/Veil/Lifeline).
- Player progress:
  - Completed / not completed,
  - Best time / attempt stats.

### 8.2 In-Trial UI

- Scenario tracker:
  - Objectives,
  - Timer (if relevant),
  - Death count (if relevant).
- Clear fail/restart handling.

### 8.3 Result Screen

- On completion:
  - Show:
    - Pass/Fail,
    - Time, deaths, healing/damage stats,
    - New rewards (cosmetics/titles),
    - Updates to Season challenges.

---

## 9. Implementation Checklist

1. **DB**
   - Create `mortal_trials`, `mortal_trial_progress`.
   - Seed initial Trials (1 per faction).

2. **Server**
   - Implement:
     - Entry handling & normalization aura,
     - Scenario scripting per Trial,
     - Success/fail criteria & reward distribution.

3. **Content**
   - Design mechanics-heavy fights emphasizing:
     - Brace, Guard Counter,
     - Movement,
     - Human-error punishments, not gear checks.

4. **UI**
   - Trial Browser (MortalUI),
   - In-Trial HUD,
   - Result screen.

5. **Integration**
   - Hook Trials into:
     - Faction rewards,
     - Season track,
     - Appearance & Weapon Legacy systems.

---

This gives you a modern “Mage Tower” experience inside Mortal Warcraft’s framework: pure skill checks, prestige cosmetics, and faction flavor, with no power creep arms race.
