# Project Canvas: Mortal Warcraft Overhaul
### Version 34.0 — Hybrid Technical Design Document  
### File: 54-endless-contracts-defense-and-survival.md  
### Section: Endless Contracts – Defense & Survival Modes

---

## 1. Purpose

Introduce **Endless Contracts** as opt-in, repeatable PvE/PvPvE loops inspired by Warframe’s endless missions, tailored for Mortal Warcraft’s:

- Risk-zoned, full-loot world (Green / Yellow / Red),
- Stronghold & Shrine systems,
- Contract & Task Board economy.

Endless Contracts provide:

- Wave-based content (Defense / Survival variants),
- Scaling rewards the longer you stay,
- “Stay or extract?” tension,
- Tight integration into **economy**, **Factions**, and **Seasonal challenges**.

---

## Related Specs

For full context on endless contracts, see:

- **`76-dynamic-tasks-and-contracts-2-0-spec.md`** — Core contract system that endless contracts extend
- **`06-pve.md`** — PvE content system that includes defense and survival modes
- **`51-factions-and-standing-system.md`** — Faction system that provides contract rewards
- **`52-season-of-the-frontier.md`** — Seasonal system that includes endless contract challenges
- **`03-risk-zones.md`** — Risk zones that affect endless contract placement and loot rules
- **`48-zone-invasions-and-cross-faction-pve.md`** — Zone invasions that can trigger endless defense contracts
- **`59-shrine-and-faction-trials.md`** — Shrine systems that endless defense contracts protect

---

## 2. Contract Types

### 2.1 Endless Defense

Players defend a fixed objective against waves of enemies.

Examples of objectives:

- Shrine (Order of the Shrine),
- Stronghold gate or relay tower,
- Caravan’s supply wagon at a chokepoint,
- Planar Anchor near a Rift.

Loop:

1. Start contract at an NPC or Task Board:
   - “Defend the Shrine of Ash for at least 5 waves.”
2. Enter Defense instance or designated open-world location.
3. Waves spawn:
   - Increasing difficulty and variety.
4. After each wave:
   - **Extraction window**:
     - Vote to extract (party majority),
     - Or continue for more rewards and risk.
5. Failure condition:
   - Objective destroyed or all defenders wiped (and choose not to re-enter).

### 2.2 Endless Survival

Players must “hold the line” in a hostile area:

- Maintain resource uptime (e.g., fuel for warding fires),
- Survive within an expanding threat radius,
- Possibly keep key NPCs alive.

Loop:

1. Start contract:
   - “Survive in the Blighted Mine for 10 minutes.”
2. As time passes:
   - Enemy spawns increase in density and strength,
   - Environmental hazards intensify (poisons, debuffs).
3. Periodic extraction points:
   - At X minutes, Y minutes, etc.
4. Failure:
   - Total party wipe + objective failure.

---

## 3. Risk & Zoning

Endless Contracts must respect existing zone rules:

- **Green Zones**:
  - Largely PvE-only.
  - Lighter endless contracts for newer players:
    - Lower rewards,
    - No full-loot.
- **Yellow Zones**:
  - Criminal flagging applies:
    - Contracts might attract opportunistic gankers.
  - Defenders may be able to flag attackers as criminals around the objective.
- **Red Zones**:
  - Full-loot applies:
    - Killed defenders drop gear into Corpse Chests.
    - Other players can intrude depending on configuration:
      - Instance-limited (only your group),
      - Or open Red Zone location (true PvPvE).

Tuning knobs:

- Some Endless Contracts occur in **instanced spaces** (limited PvP).
- Others are **anchored to open-world locations**, inviting external interference.

---

## 4. Scaling & Rewards

### 4.1 Wave/Time Scaling

Each wave/minute:

- Increases:
  - Enemy HP/damage,
  - Special ability usage,
  - Spawn counts,
  - Chance for elites.

Bands:

- Waves 1–5: Intro / baseline.
- Waves 6–10: Challenging for ungeared parties.
- Waves 11–15: High-end group content.
- Beyond: “Endless” bragging rights and cosmetic bonuses.

### 4.2 Reward Structure

Rewards are a mix of:

- **Base payout**:
  - Awarded upon first extraction threshold (e.g., wave 5 or 10 minutes).
- **Incremental rewards** per wave/time milestone:
  - Materials (ore, wood, essences),
  - Augment fragments,
  - Faction commendations,
  - Small gold payouts.
- **Milestone chests**:
  - At waves 5/10/15+ or time thresholds.
- **Leaderboard / vanity**:
  - Longest survival / highest wave completions tracked for bragging rights.

Rewards scale:

- Non-linearly:
  - High waves give significantly better returns but also much higher risk.
- By zone:
  - Red Zone contracts drop the richest loot but also carry full-loot risk.

---

## 5. Contract Data Model

### 5.1 Contract Definition

```sql
CREATE TABLE IF NOT EXISTS mortal_endless_contracts (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  code            VARCHAR(64) NOT NULL UNIQUE,  -- 'DEFENSE_SHRINE_DUSKWOOD_T1'
  name            VARCHAR(128) NOT NULL,
  description     TEXT NOT NULL,
  type            VARCHAR(16) NOT NULL,        -- 'DEFENSE','SURVIVAL'
  map_id          INT NOT NULL,
  zone_id         INT NOT NULL,
  risk_tier       INT NOT NULL,                -- 1..5 aligned with Green/Yellow/Red
  min_players     INT NOT NULL DEFAULT 1,
  max_players     INT NOT NULL DEFAULT 5,
  faction_bias    VARCHAR(64) NULL,            -- e.g., 'ORDER_SHRINE','IRON_LEDGER'
  base_reward_json JSON NULL,                  -- baseline reward package
  flags           INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 5.2 Contract Wave Profiles

```sql
CREATE TABLE IF NOT EXISTS mortal_endless_waves (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  contract_id     INT NOT NULL,
  wave_number     INT NOT NULL,                -- 1..N (beyond N, repeat with scaling)
  enemy_group_id  INT NOT NULL,                -- link to spawn/encounter template
  scaling_factor  FLOAT NOT NULL DEFAULT 1.0,  -- HP/damage multiplier
  reward_modifier FLOAT NOT NULL DEFAULT 1.0,  -- reward scaling factor
  CONSTRAINT fk_mortal_endless_waves_contract
    FOREIGN KEY (contract_id) REFERENCES mortal_endless_contracts(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 5.3 Contract Completion Logs

```sql
CREATE TABLE IF NOT EXISTS mortal_endless_runs (
  id              BIGINT AUTO_INCREMENT PRIMARY KEY,
  contract_id     INT NOT NULL,
  guid            INT NOT NULL,               -- any participant (leader)
  party_size      INT NOT NULL,
  max_wave        INT NOT NULL,
  duration_sec    INT NOT NULL,
  extracted       TINYINT(1) NOT NULL,        -- 1 if party extracted successfully
  start_ts        INT NOT NULL,
  end_ts          INT NOT NULL,
  CONSTRAINT fk_mortal_endless_runs_contract
    FOREIGN KEY (contract_id) REFERENCES mortal_endless_contracts(id)
    ON DELETE CASCADE,
  INDEX idx_contract_wave (contract_id, max_wave)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

This powers:

- Leaderboards,
- Seasonal challenge hooks,
- Faction standing grants.

---

## 6. Hooks & Systems Integration

### 6.1 Task Boards

Endless Contracts can appear as:

- Contract entries:
  - “Endless Defense: Shrine of Ash (Tier 2)”,
  - “Endless Survival: Blighted Mine (Tier 3)”.
- Accepting the contract:
  - Summons party to staging area,
  - Starts instance or binds group to open-world site.

### 6.2 Factions

Contracts grant faction standing based on:

- `faction_bias` field:
  - Order of the Shrine for Shrine Defense,
  - Iron Ledger for caravan-protection Defense,
  - Rangers’ Pact for wilderness Survival,
  - Black Sun Cartel for smuggler-themed endless.

Hook:

- On extraction or threshold wave:
  - Award standing via `mortal_faction_activity_tags` system.

### 6.3 Seasonal Track

Challenges:

- Weeklies/Seasonals:
  - “Complete Endless Defense to wave 10+.”
  - “Survive 15 minutes in any Endless Survival contract.”
- XP & reward integration:
  - Use `mortal_endless_runs` logs to check completion thresholds.

### 6.4 Augments & Rewards

Endless Contracts are natural sources of:

- Augment fragments:
  - Use them to craft powerful but balanced augments.
- Rare crafting materials:
  - Essences tied to the specific contract theme.
- Faction commendations:
  - Especially for Rangers/Order.

---

## 7. Combat & Encounter Design

### 7.1 Defense

Key concepts:

- **Objective HP**:
  - Clear HP pool, visible to players.
- **Wave Themes**:
  - Standard mobs, elites, siege units, support casters.
- **Boss Waves**:
  - Every N waves, spawn mini-boss(es) with mechanics that demand:
    - Movement,
    - Guard Counter / Brace usage,
    - Coordination.

Optional mechanics:

- Repair tasks:
  - Players can spend materials gold to repair objective between waves.
- Shrine/Faction synergy:
  - Order of the Shrine players get small defensive buffs or utility at Shrine Defenses.

### 7.2 Survival

Key concepts:

- **Threat Meter**:
  - Increases with time and events.
- **Resource Maintenance**:
  - Keeping warding fires lit,
  - Maintaining magical barriers,
  - Feeding a relic power source.
- **Escalation**:
  - New enemy types introduced at time thresholds:
    - Poison enemies → highlight First Aid,
    - Undead waves → highlight Shrine/Faction synergy.

---

## 8. Risk & Rewards Tuning

### 8.1 Full-Loot Considerations

- Instanced Endless Contracts:
  - Might use modified loot rules:
    - Corpse chest remains only accessible to party for X minutes,
    - Then opens to others (in open-world versions).
- Red Zone versions:
  - Explicitly flagged as high-risk:
    - “This contract occurs in a contested Red Zone; full loot applies.”

### 8.2 Economic Impact

- Avoid turning Endless into pure gold-printing:
  - Focus on **materials, fragments, faction tokens**, cosmetic unlocks.
  - Gold rewards modest and capped per day.

---

## 9. UI & UX

### 9.1 Contract Selection

- Task Board UI:
  - Separate tab or filter for **Endless** contracts.
  - Show type (Defense/Survival), location, risk tier, recommended party size.

### 9.2 In-Run UI

- Wave count / time survived,
- Objective HP bar,
- Upcoming wave hints (small telegraphs),
- Extraction vote UI during breaks.

### 9.3 Post-Run Summary

- Waves cleared / time survived,
- Enemies killed, damage dealt/taken,
- Rewards earned,
- Faction standing gained,
- Seasonal challenge progress updates (if applicable).

---

## 10. Implementation Checklist

1. **DB**
   - Create `mortal_endless_contracts`, `mortal_endless_waves`, `mortal_endless_runs`.
   - Seed a small set of test contracts (1 Defense, 1 Survival).
2. **Server**
   - Implement contract start/end flows.
   - Wave spawning logic & scaling.
   - Extraction voting and reward distribution.
   - Logging to `mortal_endless_runs`.
3. **Content**
   - Design wave compositions for first contracts:
     - Green zone, Yellow zone, Red zone variants.
   - Hook in faction standing and reward packages.
4. **UI**
   - Task Board integration.
   - In-run wave/objective HUD.
   - Post-run summary screen.
5. **Balancing**
   - Internal tests for:
     - Wave difficulty,
     - Reward pacing,
     - Risk/reward relationship across zones.
   - Adjust spawn density, scaling, and reward multipliers.

