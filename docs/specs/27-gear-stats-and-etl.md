# Project Canvas: Mortal Warcraft Overhaul
### Version 26.3 — Hybrid Technical Design Document  
### File: 27-gear-stats-and-etl.md  
### Section: Gear Stat Budgets & ETL Pipeline (Mortal Items from WotLK Visuals)

---

## Related Specs

- `26-gear-visual-mapping.md` - Gear visual mapping that feeds into ETL pipeline
- `19-itemization.md` - Itemization system and gear tiers
- `75-mortal-gear-and-runes-spec.md` - Mortal gear progression and rune system
- `84-mortal-core-stats-and-combat-model.md` - Core stats system that gear stats align with
- `30-db-migrations-mortal-core.md` - Database migrations for gear tables
- `67-conversion-automation-plan.md` - Conversion automation that uses ETL pipeline
- `31-mortal-core-registry.md` - ID registry for custom item entries

---

## 1. Purpose

This document extends `26-gear-visual-mapping.md` with:

1. A **tier → stat budget** system for Mortal gear (PvE + PvP).
2. A concrete **ETL pipeline outline** that:
   - Reads `mortal_gear_visuals_seed.csv`.
   - Enriches each row with Mortal stats & requirements based on tier.
   - Emits SQL `INSERT` statements for `item_template` and `mortal_gear_visuals`.

Goal: given a list of **source visuals** (WotLK item IDs), we can automatically generate:

- Custom Mortal items (`item_template.entry` in a reserved range).
- With correct **displayid**, **skill-based requirements**, and **Mortal-appropriate stats**.

---

## 2. Mortal Stat Philosophy (Recap)

From previous docs:

- **No traditional levels** – derived level from skills.
- **Attribute caps:**
  - Single attribute (`Str/Agi/Sta/Int/Spi`) ≤ **150**.
  - Sum of attributes ≤ **400** (“genetic limit”).
- **Derived Stats Rewrite:**
  - Health: `HP = 50 + (Stamina * 10)` (max ~1,550 HP).
  - Crit Chance: `(Agility / 20)%`.
  - Mana: `Mana = 100 + (Intellect * 10)`.
- Items add:
  - Flat attribute bonuses (+Str, +Sta, etc.).
  - Armor values.
  - Possibly small combat modifiers (hit/crit/haste), but we favor raw attributes.

Gear must:

- Support builds hitting caps **only at high tiers**.
- Leave room for **meaningful upgrades** between tiers.
- Avoid stat inflation that breaks hit/miss tables or Guard Counter balance.

---

## 3. Tier Stat Budgets (High-Level)

We define a **normalized budget** system:

- Each tier has a **Base Attribute Budget** and an **Armor Budget** per slot.
- Items can be:
  - **Offensive** – more Str/Agi/Int, less Sta/Armor.
  - **Defensive** – more Sta/Armor, less offensive stats.
  - **Hybrid** – balanced.

### 3.1 Attribute Budget by Tier

Think in terms of **total attribute points per full set** (head + shoulders + chest + hands + legs + belt + boots + bracers):

- **M-T1**: ~80 total attrib points.
- **M-T2**: ~120.
- **M-T3**: ~160.
- **M-T4**: ~200.
- **M-T5**: ~230.

Given genetic limit 400, this means:

- Gear contributes roughly:
  - 20–60% of max attributes, depending on tier.
- The rest comes from:
  - Base racial/backgrounds.
  - Progression, runes, enchants, etc.

We then derive **per-slot budgets** from these totals.

### 3.2 Attribute Budget per Slot

Example (PvE, per full 8-piece set):

| Slot      | M-T1 | M-T2 | M-T3 | M-T4 | M-T5 |
|-----------|------|------|------|------|------|
| Head      | 10   | 15   | 20   | 25   | 28   |
| Shoulders | 8    | 12   | 16   | 20   | 23   |
| Chest     | 12   | 18   | 24   | 30   | 34   |
| Hands     | 8    | 12   | 16   | 20   | 23   |
| Legs      | 12   | 18   | 24   | 30   | 34   |
| Belt      | 6    | 9    | 12   | 15   | 17   |
| Boots     | 6    | 9    | 12   | 15   | 17   |
| Bracers   | 4    | 7    | 8    | 10   | 12   |
| **Total** | 66   | 100  | 144  | 165  | 188  |

You can scale these numbers up/down slightly; the key is consistent ratios.

---

## 4. Attribute Distribution Patterns

Each item archetype uses a **pattern** to split its budget across attributes.

### 4.1 Archetype Examples

**Plate – Offensive (Melee Warlord)**

- Focus: `Str`, `Sta`, minor `Agi`.
- Example distribution (Chest, M-T3, budget 24):
  - Str: 12
  - Sta: 8
  - Agi: 4

**Plate – Defensive (Guardian)**

- Focus: `Sta`, `Str`, minor `Spi` (for resist/mitigation).
- Example (Chest, M-T3, budget 24):
  - Sta: 14
  - Str: 6
  - Spi: 4

**Leather – Agility DPS**

- Focus: `Agi`, `Sta`.
- Example (Legs, M-T2, budget 18):
  - Agi: 11
  - Sta: 7

**Cloth – Caster DPS**

- Focus: `Int`, `Sta`, minor `Spi`.
- Example (Head, M-T4, budget 25):
  - Int: 14
  - Sta: 8
  - Spi: 3

**Cloth – Healer**

- Focus: `Int`, `Spi`, `Sta`.
- Example (Chest, M-T3, budget 24):
  - Int: 10
  - Spi: 8
  - Sta: 6

The ETL tool can encode these patterns as:
- Look up by **armor_type** + **role** + **slot**.

---

## 5. Armor Budget

Armor values should:

- Scale primarily by **tier** and **armor_type**.
- Not explode as in retail WotLK.

Example baseline (Chest):

| Armor Type | M-T1 | M-T2 | M-T3 | M-T4 | M-T5 |
|-----------|------|------|------|------|------|
| Plate     | 350  | 450  | 550  | 650  | 725  |
| Mail      | 300  | 375  | 450  | 525  | 580  |
| Leather   | 250  | 325  | 400  | 475  | 520  |
| Cloth     | 200  | 260  | 320  | 380  | 410  |

For smaller slots (belt, bracers) use lower scaling factors (e.g., 40–50% of chest).

---

## 6. Requirements (Skill-Based)

Instead of `RequiredLevel`, Mortal items should use **skill gates**.

### 6.1 Armor Mastery Skills (Example)

- `Armor Mastery: Plate`
- `Armor Mastery: Mail`
- `Armor Mastery: Leather`
- `Armor Mastery: Cloth`

Each gear tier requires a minimum skill rank.

Example:

| Tier  | Skill Rank Required |
|-------|---------------------|
| M-T1  | 25                  |
| M-T2  | 50                  |
| M-T3  | 75                  |
| M-T4  | 100                 |
| M-T5  | 125                 |

In `item_template`:

- `RequiredSkill = <ARMOR_MASTERY_SKILL_ID>`
- `RequiredSkillRank = tier_requirement`

You can also add **Mortal-specific flags**:
- e.g. `RequiredReputation` or `RequiredFlag` fields via custom columns.

---

## 7. PvP Stat Adjustments

PvP tiers (P1–P6) should:

- Have similar attribute budgets to PvE tiers of comparable level.
- Possibly favor:
  - More stamina.
  - Slightly more resilience-like effect (if implemented), or:
    - Flat damage reduction vs players.
- Avoid raw power creep vs PvE; difference should be in **stat mix**, not absolute power.

Simple rule of thumb:

- Map P1–P6 to M-T1–M-T5 for budget:
  - P1 ≈ M-T1
  - P2 ≈ M-T1.5
  - P3 ≈ M-T2
  - P4 ≈ M-T3
  - P5 ≈ M-T4
  - P6 ≈ M-T5

---

## 8. CSV Format for Visuals + Tier

We’ll use a **seed CSV** to drive the ETL.

`data/mortal_gear_visuals_seed.csv`:

```csv
mortal_item_entry,mortal_tier,category,armor_type,slot,role,source_type,source_item_entry,displayid,notes
70001,M-T4,pve,plate,chest,offense,t10,51213,,Warrior ICC chest visual
70002,M-T4,pve,plate,chest,defense,t10,51218,,Paladin ICC chest visual
70003,P6,pvp,plate,head,offense,s8,51413,,Wrathful Gladiator helm visual
```

- `displayid` can be left blank initially and backfilled from DB.
- `role` determines attribute distribution pattern:
  - `offense`, `defense`, `hybrid`, `caster`, `healer`, etc.

---

## 9. ETL Pipeline – Conceptual Flow

1. **Input:**
   - Seed CSV (`mortal_gear_visuals_seed.csv`).
   - Config (YAML/JSON) with:
     - Tier → attribute budgets per slot.
     - Tier → armor values per slot.
     - Tier → skill rank requirement.
     - Role → attribute distribution.

2. **Step 1 – Backfill displayid:**
   - Connect to AzerothCore DB.
   - For each row with `displayid` empty:
     - Query `item_template` by `source_item_entry`.
     - Fill `displayid`.

3. **Step 2 – Compute stats:**
   - For each row:
     - Determine base budget from:
       - `mortal_tier` + `slot` (attribute points).
       - `armor_type` + `slot` (armor).
     - Apply `role` distribution for attributes.
     - Determine `RequiredSkill` and `RequiredSkillRank`.

4. **Step 3 – Emit SQL:**
   - `INSERT` into `mortal_gear_visuals`.
   - `INSERT` into `item_template`.

5. **Step 4 – Write updated CSV:**
   - For auditing and manual tweaks.

---

## 10. ETL Script Outline (Python)

This is **pseudocode / structure** to guide Cursor; not production code.

```python
import csv
import mysql.connector
from dataclasses import dataclass

@dataclass
class GearRow:
    mortal_item_entry: int
    mortal_tier: str
    category: str
    armor_type: str
    slot: str
    role: str
    source_type: str
    source_item_entry: int
    displayid: int | None
    notes: str

# --- 1. Load config (budgets, distributions) ---

TIER_ATTR_BUDGET = {
    # (tier, slot): points
    ("M-T4", "chest"): 30,
    ("M-T4", "head"): 25,
    # ...
}

ARMOR_BUDGET = {
    # (tier, armor_type, slot): armor
    ("M-T4", "plate", "chest"): 650,
    # ...
}

ROLE_DISTRIBUTION = {
    # (armor_type, role): fractions for attributes
    ("plate", "offense"): {"str": 0.5, "sta": 0.3, "agi": 0.2},
    ("plate", "defense"): {"sta": 0.6, "str": 0.25, "spi": 0.15},
    ("cloth", "caster"): {"int": 0.6, "sta": 0.25, "spi": 0.15},
}

TIER_SKILL_RANK = {
    "M-T1": 25,
    "M-T2": 50,
    "M-T3": 75,
    "M-T4": 100,
    "M-T5": 125,
}

ARMOR_MASTERY_SKILL_ID = {
    "plate": 8000,   # Per 31-mortal-core-registry.md
    "mail": 8001,
    "leather": 8002,
    "cloth": 8003,
}

# --- 2. Read CSV ---

rows: list[GearRow] = []
with open("data/mortal_gear_visuals_seed.csv", newline="") as f:
    reader = csv.DictReader(f)
    for r in reader:
        rows.append(GearRow(
            mortal_item_entry=int(r["mortal_item_entry"]),
            mortal_tier=r["mortal_tier"],
            category=r["category"],
            armor_type=r["armor_type"],
            slot=r["slot"],
            role=r["role"],
            source_type=r["source_type"],
            source_item_entry=int(r["source_item_entry"]),
            displayid=int(r["displayid"]) if r["displayid"] else None,
            notes=r.get("notes", ""),
        ))

# --- 3. Backfill displayid from DB ---

db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="password",
    database="azerothcore_world",
)

cur = db.cursor()

for row in rows:
    if row.displayid is None:
        cur.execute(
            "SELECT displayid FROM item_template WHERE entry = %s",
            (row.source_item_entry,),
        )
        result = cur.fetchone()
        if not result:
            raise RuntimeError(f"No item_template for entry {row.source_item_entry}")
        row.displayid = int(result[0])

# --- 4. Compute stats and emit SQL ---

def compute_attributes(row: GearRow) -> dict[str, int]:
    key = (row.mortal_tier, row.slot)
    budget = TIER_ATTR_BUDGET[key]
    dist = ROLE_DISTRIBUTION[(row.armor_type, row.role)]
    # round distribution
    attrs = {}
    remaining = budget
    for i, (attr, frac) in enumerate(dist.items()):
        if i == len(dist) - 1:
            attrs[attr] = remaining
        else:
            val = int(round(budget * frac))
            attrs[attr] = val
            remaining -= val
    return attrs

def compute_armor(row: GearRow) -> int:
    key = (row.mortal_tier, row.armor_type, row.slot)
    return ARMOR_BUDGET.get(key, 0)

item_template_inserts = []
visual_inserts = []

for row in rows:
    attrs = compute_attributes(row)
    armor = compute_armor(row)
    skill_rank = TIER_SKILL_RANK[row.mortal_tier]
    skill_id = ARMOR_MASTERY_SKILL_ID[row.armor_type]

    name = f"Mortal {row.mortal_tier} {row.armor_type.capitalize()} {row.slot.capitalize()}"
    # Map attributes to stat_typeN/stat_valueN as per your schema
    stat_pairs = []
    for attr, value in attrs.items():
        # Example mapping
        if attr == "str":
            stat_type = 0  # STAT_STRENGTH
        elif attr == "agi":
            stat_type = 1  # STAT_AGILITY
        elif attr == "sta":
            stat_type = 3  # STAT_STAMINA
        elif attr == "int":
            stat_type = 4  # STAT_INTELLECT
        elif attr == "spi":
            stat_type = 5  # STAT_SPIRIT
        else:
            continue
        stat_pairs.append((stat_type, value))

    # Build item_template insert string (simplified)
    sql = f"-- Item {row.mortal_item_entry}\n"           f"INSERT INTO item_template (entry, name, displayid, class, subclass, InventoryType, Quality, RequiredLevel, RequiredSkill, RequiredSkillRank, Armor, StatsCount"
    values = f"VALUES ({row.mortal_item_entry}, '{name}', {row.displayid}, 4, /* subclass */ 4, /* InventoryType by slot */ 5, 4, 1, {skill_id}, {skill_rank}, {armor}, {len(stat_pairs)}"

    # Add stat columns (you’ll need to match AC schema exactly)
    # ...

    item_template_inserts.append(sql + ") " + values + ");")

    visual_sql = f"INSERT INTO mortal_gear_visuals (mortal_item_entry, mortal_tier, category, armor_type, slot, source_type, source_item_entry, displayid, notes) "                  f"VALUES ({row.mortal_item_entry}, '{row.mortal_tier}', '{row.category}', '{row.armor_type}', '{row.slot}', '{row.source_type}', {row.source_item_entry}, {row.displayid}, '{row.notes}');"

    visual_inserts.append(visual_sql)

# Write to .sql files
with open("out/mortal_item_template.sql", "w") as f:
    f.write("\n".join(item_template_inserts))

with open("out/mortal_gear_visuals.sql", "w") as f:
    f.write("\n".join(visual_inserts))
```

This can be adapted into:

- A standalone tool under `tools/mortal_gear_etl.py`.
- Or re-implemented in Go if you prefer a single-language toolchain.

---

## 11. ETL Script Outline (Go) – Optional

A Go version would:

- Use `database/sql` + `go-sql-driver/mysql`.
- Use a CSV reader (`encoding/csv`).
- Use structs similar to `GearRow`.
- Implement the same budget/distribution logic in Go.

You can ask Cursor to “port `mortal_gear_etl.py` logic to Go with these packages” once the Python version is validated.

---

## 12. Status

This file is the **authoritative spec** for:

1. Mortal gear **stat budgets** across PvE tiers and PvP ranks.
2. The **ETL pipeline** that:
   - Reads visual mapping CSV.
   - Pulls displayid from AzerothCore DB.
   - Computes Mortal-specific attributes, armor, and requirements.
   - Outputs ready-to-run SQL insert scripts.

Place it at:

- `docs/27-gear-stats-and-etl.md`

and keep `26-gear-visual-mapping.md` as the companion visual-mapping spec.
