# Project Canvas: Mortal Warcraft Overhaul
### Version 26.2 — Hybrid Technical Design Document  
### File: 26-gear-visual-mapping.md  
### Section: Gear Visual Mapping & Progression (Using WotLK 3.3.5a Models)

---

## Related Specs

- `27-gear-stats-and-etl.md` - Gear stats and ETL pipeline that extends this mapping
- `19-itemization.md` - Itemization system and gear tiers
- `75-mortal-gear-and-runes-spec.md` - Mortal gear progression and rune system
- `30-db-migrations-mortal-core.md` - Database migrations for gear visuals table
- `31-mortal-core-registry.md` - ID registry for custom item entries
- `67-conversion-automation-plan.md` - Conversion automation that uses this mapping
- `57-appearance-codex-and-transmog.md` - Appearance system that uses visual mapping

---

## 1. Purpose

Define how **Mortal Warcraft’s gear progression** reuses **WotLK 3.3.5a item models** (raid tiers + PvP seasons) while:

- Completely replacing Blizzard’s original stats and level requirements.
- Preserving iconic visuals (T7–T10, S5–S8).
- Providing a **clean, classless, skill-based** Mortal gear ladder.

This is a **design + data-contract** doc. It does **not** list every item ID; instead it specifies:

- The **tiers/ranks** Mortal will use.
- Which WotLK sets each tier is visually based on.
- The **data pipeline** for pulling item IDs/display IDs and generating Mortal items.

---

## 2. Terminology

- **Source item** – Original 3.3.5a item (e.g. ICC T10 chest).
- **Source entry** – `item_template.entry` for the source item.
- **Display ID** – `item_template.displayid` used by the source item model.
- **Mortal item** – New custom item row in `item_template` using:
  - A **new entry ID** in a reserved range.
  - A **displayid** from a source item.
  - **Mortal stats & requirements**, not Blizzard’s.

---

## 3. Mortal PvE Gear Tiers

### 3.1 Mortal PvE Tier Ladder

We define **Mortal PvE tiers** as:

- **M-T0** – Starter / leveling / lowbie gear
- **M-T1** – Early endgame
- **M-T2** – Mid endgame
- **M-T3** – Late endgame
- **M-T4** – Peak endgame
- **M-T5** – Prestige / seasonal / legendary

Each tier has:

- A **visual source** (WotLK raid tier).
- A **Mortal power band** (internal stat budget).
- A rough **content source** (what activities award it).

### 3.2 Visual Sources by Tier

Initial mapping (can be tuned later):

| Mortal Tier | Visual Source (WotLK)        | Notes                                                |
|-------------|------------------------------|------------------------------------------------------|
| M-T0        | Mixed pre-raid / blue sets   | Low-key looks, world/dungeon drops                  |
| M-T1        | Tier 7 (Naxx 10 “Heroes’”)   | Early raids, heroic dungeons                        |
| M-T2        | Tier 8 (Ulduar)              | Harder dungeons, early delves, mid-tier raids       |
| M-T3        | Tier 9 (ToC)                 | Stronghold content, advanced delves                 |
| M-T4        | Tier 10 (ICC normal)         | High-end raids + cursed loot extraction             |
| M-T5        | Tier 10 Sanctified (heroic)  | Prestige seasons, top-end achievements, relic gear  |

We **do not** mirror Blizzard’s progression order 1:1; we simply use the models.

---

## 4. Mortal PvP Gear Ranks

### 4.1 PvP Rank Ladder

We define **Mortal PvP ranks** as:

- **P1 – Initiate**
- **P2 – Challenger**
- **P3 – Veteran**
- **P4 – Warmonger**
- **P5 – Conqueror**
- **P6 – Warlord**

These map to **WotLK arena seasons** visually, but are earned via Mortal PvP systems (bounties, Warfronts, PvP tokens, etc.), not rating.

### 4.2 Visual Sources by Rank

| Mortal PvP Rank | Visual Source (WotLK PvP) | Notes                                             |
|-----------------|---------------------------|---------------------------------------------------|
| P1 (Initiate)   | Savage Gladiator (S5 intro) | Entry PvP, basic gear for Red zones              |
| P2 (Challenger) | Hateful Gladiator (S5)    | Low-mid PvP progression                           |
| P3 (Veteran)    | Deadly Gladiator (S5)     | Solid mid-tier PvP                               |
| P4 (Warmonger)  | Furious Gladiator (S6)    | Advanced / organized PvP                         |
| P5 (Conqueror)  | Relentless Gladiator (S7) | High-end PvP, strong Red-zone presence           |
| P6 (Warlord)    | Wrathful Gladiator (S8)   | Prestige PvP, seasonal / limited availability     |

Again, we reuse **visuals only**.

---

## 5. Armor Type & Slot Mapping

For each armor type:

- **Plate**
- **Mail**
- **Leather**
- **Cloth**

And for each slot:

- `head`, `shoulders`, `chest`, `hands`, `legs`
- (Optionally belt/boots/bracers/capes if you want full sets)

We define a **Mortal item skeleton**:

### 5.1 Mortal Item Skeleton

For example, a plate chest piece:

- `M-T3 Plate Chest – Offensive`
- `M-T3 Plate Chest – Defensive`

Both could share the same **displayid** (same look) but have **different stats** (offensive vs defensive builds).

We do _not_ have to mirror Blizzard’s class-specific set names; we can define:

- **Mortal Warlord’s Battlegear** (plate)
- **Mortal Pathfinder’s Mail** (mail)
- **Mortal Shadeleather Harness** (leather)
- **Mortal Arcanist’s Regalia** (cloth)

Each mapped to specific WotLK set visuals.

---

## 6. Data Pipeline & Tables

### 6.1 Mapping Table: `mortal_gear_visuals`

Create a new table (or CSV to be imported) that maps Mortal items to source visuals:

```sql
CREATE TABLE mortal_gear_visuals (
  id                 INT AUTO_INCREMENT PRIMARY KEY,
  mortal_item_entry  INT NOT NULL,
  mortal_tier        VARCHAR(8) NOT NULL,   -- e.g. 'M-T3', 'P4'
  category           VARCHAR(16) NOT NULL,  -- 'pve' or 'pvp'
  armor_type         VARCHAR(8) NOT NULL,   -- 'plate', 'mail', 'leather', 'cloth'
  slot               VARCHAR(16) NOT NULL,  -- 'head', 'chest', etc.
  source_type        VARCHAR(32) NOT NULL,  -- e.g. 't10', 's8'
  source_item_entry  INT NOT NULL,          -- original 3.3.5 item entry
  displayid          INT NOT NULL,          -- copied from item_template.displayid
  notes              VARCHAR(255) NULL
);
```

**Important:**

- `mortal_item_entry` will be in a **reserved custom range**, e.g. `700000–709999` for PvE gear, `710000–719999` for PvP gear (per `31-mortal-core-registry.md`).
- We **do not** alter source items; we just copy their `displayid`.

---

## 7. Practical Workflow

### 7.1 Step 1 – Choose Visual Sources

For each Mortal tier/rank, decide:

- Plate set visual (raid/PvP set).
- Mail set visual.
- Leather set visual.
- Cloth set visual.

Example for **M-T4 (ICC normal)**:

- Plate: Warrior / DK / Paladin ICC sets (choose 1–2 as base).
- Mail: Hunter / Shaman ICC sets.
- Leather: Rogue / Druid ICC sets.
- Cloth: Mage / Warlock / Priest ICC sets.

You can pick:

- One core look per armor type.
- Or allow multiple variants (e.g., separate PvE/PvP looks within same tier).

### 7.2 Step 2 – Collect Source Item Entries

Using Wowhead/Wowpedia manually:

1. Open the set page (e.g., Warrior T10).
2. For each slot (head/chest/legs/hands/shoulders):
   - Copy the `item=` ID from Wowhead URL.
   - Add it to a CSV under `source_item_entry` along with:
     - `armor_type`
     - `slot`
     - `source_type` (e.g. `t10`)
     - Proposed `mortal_tier` (e.g. `M-T4`).

Example CSV row (conceptual):

```csv
mortal_item_entry,mortal_tier,category,armor_type,slot,source_type,source_item_entry,displayid,notes
70001,M-T4,pve,plate,chest,t10,ITEM_ID_HERE,,Warrior ICC chest visual
```

Leave `displayid` empty for now.

### 7.3 Step 3 – Backfill displayid from DB

Write a small script (Go/Python) that:

1. Reads the CSV.
2. For each row, queries:

   ```sql
   SELECT displayid FROM item_template WHERE entry = :source_item_entry;
   ```

3. Fills the `displayid` column.
4. Writes out:
   - Updated CSV.
   - Optional `INSERT` for `mortal_gear_visuals`.

Pseudo-query example:

```sql
INSERT INTO mortal_gear_visuals (
  mortal_item_entry, mortal_tier, category, armor_type, slot,
  source_type, source_item_entry, displayid, notes
)
VALUES
(70001, 'M-T4', 'pve', 'plate', 'chest', 't10', 51213, 12345, 'Warrior ICC chest visual');
```

### 7.4 Step 4 – Generate Mortal item_template Rows

Once `mortal_gear_visuals` is populated:

- Use a SQL script or an ETL tool to generate `item_template` inserts.

Each `mortal_item_entry` row should:

- Use `displayid` from `mortal_gear_visuals`.
- Use **Mortal stat rules**:
  - Attribute cap-aware.
  - Skill requirement instead of level requirement.
  - Durability, weight, etc.

**Example skeleton (pseudo):**

```sql
INSERT INTO item_template (
  entry, class, subclass, name, displayid,
  Quality, InventoryType, AllowableClass, AllowableRace,
  RequiredLevel, RequiredSkill, RequiredSkillRank,
  stat_type1, stat_value1,
  stat_type2, stat_value2,
  Armor, MaxDurability,
  /* other fields... */
)
SELECT
  v.mortal_item_entry,
  4, 4,                               -- Armor, Plate (example)
  CONCAT('Mortal Warlord's Breastplate (', v.mortal_tier, ')'),
  v.displayid,
  4, 5,  -1, -1,                       -- Epic, chest, no class/race restriction
  1, :required_skill_id, :required_skill_rank,  -- Level 1, uses Mortal skills instead of level
  :stat_type1, :stat_value1,
  :stat_type2, :stat_value2,
  :armor_value, :max_durability
FROM mortal_gear_visuals v
WHERE v.mortal_item_entry = 70001;
```

You can generate these programmatically based on a **tier → stat budget** mapping.

---

## 8. Stat Budget & Requirements (High-Level)

This doc focuses on visuals, but we must align with existing Mortal stat philosophy:

- Hard attribute caps:
  - Single attribute ≤ 150.
  - Sum of attributes ≤ 400.
- Derived stats:
  - HP, Crit, etc. from attributes.

### 8.1 Tier Budgets (Conceptual)

Define a baseline “power budget” per tier:

- M-T1: baseline endgame gear.
- M-T2: +X% over M-T1.
- M-T3: +Y% over M-T2.
- M-T4: near soft cap for most builds.
- M-T5: marginal stat upgrades, main value is prestige/title.

Requirements:

- Instead of `RequiredLevel`:
  - Use `RequiredSkill` + rank (e.g. “Armor Mastery: Plate 150”).
- Optionally require:
  - Completion flags (raid attunement).
  - Stronghold ownership contributions.

---

## 9. Visual Clarity Rules

To avoid noise and confusion:

1. **Green/Yellow Zones**:
   - Mostly M-T0 to M-T2 tiers.
   - PvP ranks P1–P3 seen infrequently.
2. **Red Zones**:
   - Primary stage for M-T3–M-T4.
   - PvP ranks P3–P6.
3. **Prestige Areas / Events**:
   - M-T5 & P6 reserved for:
     - Top guilds.
     - Seasonal rewards.
     - Special events (Midnight Horde, Hellgates, etc.).

This ensures:

- When you see a **Wrathful-style set**, you know:
  - That player is one of the top PvPers (P6).
- When you see **Sanctified T10**:
  - It’s a rare M-T5 piece tied to endgame systems.

---

## 10. File & Spec Placement

- This document should live in your specs folder as:

  `docs/26-gear-visual-mapping.md`

- The CSV used for population can be:

  `data/mortal_gear_visuals_seed.csv`

  With columns:

  ```csv
  mortal_item_entry,mortal_tier,category,armor_type,slot,source_type,source_item_entry,displayid,notes
  ```

Cursor can then be pointed at:

- This spec file + the CSV to:
  - Generate the DB migration for `mortal_gear_visuals`.
  - Write the small ETL tool to backfill `displayid` and generate `item_template` inserts.

---

## 11. Status

This file is the **authoritative design** for:

- Mapping Mortal gear tiers/ranks to WotLK 3.3.5a visuals.
- Keeping art + nostalgia while fully replacing Blizzard’s gear math.
- Providing a reproducible pipeline from **Wowhead/DB → Mortal item_template**.

