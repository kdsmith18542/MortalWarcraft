# Project Canvas: Mortal Warcraft Overhaul
### Version 36.0 — Hybrid Technical Design Document  
### File: 61-weapon-legacy-and-history.md  
### Section: Weapon Legacy & History System

---

## 1. Purpose

Add an **Artifact-like “weapon history” system** that:

- Makes weapons feel **personal and legendary**,
- Records the **story** of a weapon’s kills and achievements,
- Provides **cosmetic legacy rewards** when the weapon is lost or retired,
- Stays compatible with:
  - Full-loot (gear loss),
  - Sandbox economy,
  - Rune & Augment system.

No permanent, exclusive power; only minor or cosmetic perks.

---

## Related Specs

For full context on weapon legacy systems, see:

- **`57-appearance-codex-and-transmog.md`** — Appearance codex that stores weapon legacy appearances
- **`75-mortal-gear-and-runes-spec.md`** — Gear system that weapons are part of
- **`19-itemization.md`** — Itemization system that defines weapon tiers
- **`59-shrine-and-faction-trials.md`** — Trials that can contribute to weapon history
- **`11-pvp-systems.md`** — PvP systems that track weapon kills
- **`36-mortal-achievements-and-titles-core.md`** — Achievement system that weapon milestones can unlock

---

## 2. Concept Overview

### 2.1 Weapon History

Each individual weapon (item instance) tracks:

- Number of:
  - PvP kills,
  - Boss kills,
  - World events completed while wielded,
  - Trials/Endless Contracts participated in.
- Notable milestones:
  - “This weapon was used to slay Kazzak,” etc.

### 2.2 Legacy Thresholds

At certain milestones, the weapon gains:

- **Legacy Marks**:
  - Visual-only modifications (glows, etchings),
  - Cosmetic names (epithets),
  - Historical tooltip lines.

When the weapon is:

- Destroyed in full-loot,
- Or voluntarily **retired** at a special NPC,

A portion of its legacy is:

- Stored in the character’s **Weapon Legacy Codex**,
- Potentially converted into:
  - Legacy Appearance unlocks,
  - Small, account-bound **Legacy Tokens** for cosmetics.

---

## 3. Data Model (MySQL)

### 3.1 Weapon History

```sql
CREATE TABLE IF NOT EXISTS mortal_weapon_history (
  id              BIGINT AUTO_INCREMENT PRIMARY KEY,
  item_guid       BIGINT NOT NULL,              -- unique item instance
  owner_guid      INT NOT NULL,                 -- current or original owner
  weapon_code     VARCHAR(64) NULL,             -- optional classification tag
  pvp_kills       INT NOT NULL DEFAULT 0,
  boss_kills      INT NOT NULL DEFAULT 0,
  events_participated INT NOT NULL DEFAULT 0,
  trials_completed INT NOT NULL DEFAULT 0,
  legacy_tier     INT NOT NULL DEFAULT 0,       -- derived from milestones
  created_ts      INT NOT NULL,
  last_update_ts  INT NOT NULL,
  UNIQUE KEY uniq_item_guid (item_guid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 3.2 Weapon Legacy Codex (Per Character)

```sql
CREATE TABLE IF NOT EXISTS mortal_weapon_legacy_codex (
  id              BIGINT AUTO_INCREMENT PRIMARY KEY,
  guid            INT NOT NULL,                 -- character guid
  weapon_template INT NOT NULL,                 -- item_template.entry
  max_legacy_tier INT NOT NULL DEFAULT 0,       -- best tier ever achieved on any instance
  legacy_points   INT NOT NULL DEFAULT 0,       -- cumulative score
  last_update_ts  INT NOT NULL,
  UNIQUE KEY uniq_guid_template (guid, weapon_template)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 3.3 Legacy Effects & Milestones

```sql
CREATE TABLE IF NOT EXISTS mortal_weapon_legacy_definitions (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  weapon_template INT NOT NULL,                 -- or 0 for generic class of weapons
  tier            INT NOT NULL,                 -- 1..N
  required_score  INT NOT NULL,                 -- e.g. combination of kills/events
  reward_json     JSON NOT NULL,                -- e.g. appearance unlock, title, cosmetic FX
  UNIQUE KEY uniq_weapon_tier (weapon_template, tier)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

---

## 4. Scoring & Tiering

### 4.1 Scoring Mechanism

Each tracked event contributes **Legacy Score**, for example:

- PvP kill (Red Zone) while wielding weapon: +3 points,
- PvP kill (Yellow Zone): +2 points,
- Boss kill in Dungeon/Raid: +5–10 points depending on difficulty,
- Endless Contract wave thresholds: +1–3 points,
- Trial completion: +3–5 points.

Total score map to **Legacy Tiers**, via `mortal_weapon_legacy_definitions`.

### 4.2 Legacy Tier Effects

Tier 1:

- Tooltip: “This weapon has seen blood.”  
- Small visual scratch marks, minor glow.

Tier 2:

- Tooltip updates with:
  - Number of kills, boss kills.
- Cosmetic kill-marker etchings.

Tier 3:

- Unique **legacy appearance** unlock:
  - Weapon look variant (for that template) added to Appearance Codex.
- Optional: small cosmetic combat FX (no extra damage).

Tier 4+ (rare):

- Named “epithet” for the weapon:
  - “Ashen Fang”, “Storm’s Oath”, etc.
- Weapon’s name in tooltip:
  - “Mortal Iron Greatsword, *Storm’s Oath*” (cosmetic only).

---

## 5. Retirement & Loss

### 5.1 Full-Loot Loss

When:

- The weapon is looted and then later destroyed/salvaged, or
- Permanently lost in any way,

The system:

1. Computes final Legacy score & tier for that `item_guid`.
2. Increments the owner’s `mortal_weapon_legacy_codex` entry:
   - `max_legacy_tier` = max(previous, current),
   - `legacy_points` += portion of score (for meta unlocks).
3. Optional:
   - Issue **Legacy Tokens** for high-tier retirements:
     - Account-bound currency for uniqueness cosmetics.

### 5.2 Voluntary Retirement

At a special NPC (e.g., **Chronicler of Blades**):

- Player can:
  - Retire a weapon (permanent destruction) to “record its story”.
- Same process as above, but with:
  - Guaranteed additional cosmetic reward chance,
  - A bit more Legacy point conversion.

---

## 6. Integration with Other Systems

### 6.1 Rune & Augment System

Legacy should never undermine:

- Rune abilities,
- Augment choices.

Integration:

- Some Augments might **scale** with a weapon’s Legacy Tier **cosmetically**:
  - Different VFX once Tier 3+,
  - No stat multipliers from Legacy itself.

### 6.2 Trials & Endless Contracts

- Trials:
  - Using a weapon for success in Trials can yield Legacy score.
- Endless Contracts:
  - High-wave completions contribute to Legacy.
- Seasonal Challenges:
  - “Retire a Tier-3 or higher Legacy weapon this season.”

### 6.3 Appearance Codex

- Legacy Tier 3+ may:
  - Grant special variant of that weapon’s appearance,
  - Or special colorways (via reward_json).

---

## 7. UI & UX

### 7.1 Weapon Tooltip

- Extra lines showing:
  - Legacy tier (e.g., “Legacy Tier III: Veteran of the Frontier”),
  - Short stats (PvP kills, boss kills),
  - Notable achievements (if any).

### 7.2 Legacy Codex Panel

- New tab in MortalUI:
  - Shows weapon templates for which:
    - You’ve achieved Legacy tiers,
    - Summary stats and unlocked cosmetic variants.

### 7.3 Retirement UI

- Dialog at Chronicler NPC:
  - Confirmation that weapon will be destroyed.
  - Show:
    - Legacy Tier,
    - Rewards you’ll obtain upon retirement.

---

## 8. Implementation Checklist

1. **DB**
   - Create `mortal_weapon_history`, `mortal_weapon_legacy_codex`, `mortal_weapon_legacy_definitions`.
   - Seed generic Legacy definitions for common weapon templates.

2. **Server**
   - Hook events:
     - On kill, boss kill, Trial success, Endless wave clear.
   - Update `mortal_weapon_history` for wielded weapon(s).
   - Handle retirement & loss conversion into Legacy Codex.

3. **UI**
   - Tooltip enhancements,
   - Legacy Codex UI,
   - Retirement dialog.

4. **Balancing**
   - Tune scoring so:
     - Legacy tiers feel meaningful but not grindy to the point of burnout.
   - Keep all Legacy rewards strictly cosmetic or “sideways” (no vertical power).

---

This gives you that “this weapon has a story” artifact fantasy while fully respecting Mortal Warcraft’s harsh, full-loot, gear-loss world.
