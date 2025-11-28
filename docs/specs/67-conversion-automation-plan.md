# Project Canvas: Mortal Warcraft Overhaul  
### Version 36.0 — Automation & Data Passes  
### File: 67-conversion-automation-plan.md  
### Section: Automated Conversion Plan (Spells, Quests, Items, Content)

---

## Related Specs

- `63-quest-conversion-strategy.md` - Quest conversion rules and strategy
- `64-spell-and-ability-library.md` - Spell conversion and tagging system
- `19-itemization.md` - Item conversion and Mortal gear tiers
- `30-db-migrations-mortal-core.md` - Database migration structure
- `31-mortal-core-registry.md` - ID registry for converted content
- `27-gear-stats-and-etl.md` - Gear stats extraction and transformation

---

## 1. Purpose

Define how to **semi-automate** the conversion of original WotLK data into Mortal Warcraft’s systems, using:

- Scripts and tools (SQL, Lua, small Go/Rust/Python helpers),
- The rules from these specs:
  - `63-quest-conversion-strategy.md`
  - `64-spell-and-ability-library.md`
  - Plus gear/economy specs (Mortal gear tiers, Runes, Contracts, etc.).

Goal: provide a **repeatable pipeline** that Cursor (and contributors) can run and iterate, instead of doing everything by hand in the DB.

---

## 2. High-Level Architecture

We define a simple, source-of-truth pipeline:

1. **Raw Data (Source):**
   - AzerothCore DB (world/characters/etc),
   - DBC/DB2 equivalents (Spell.dbc, Item.dbc, etc).

2. **Classification Layer (Tagging Tables):**
   - Quest conversion map (`mortal_quest_conversion_map`),
   - Spell tags (`mortal_spell_tags`),
   - Item tags (`mortal_item_tags`),
   - Optional NPC tags (`mortal_npc_tags`).

3. **Conversion Scripts:**
   - SQL migrations,
   - Lua tools,
   - Optional external scripts (Go/Rust/Python) to:
     - Read DB,
     - Emit tag data,
     - Generate SQL patches.

4. **Patch Application:**
   - Migration pipeline that:
     - Applies modifications in controlled order,
     - Can be re-run on updated source DBs (idempotent where possible).

5. **Verification & Reporting:**
   - Simple dashboards/queries that show:
     - How many quests/spells/items are classified,
     - Which content remains “legacy”,
     - Basic sanity metrics (e.g., number of spells per category).

---

## 3. Core Tagging Tables

### 3.1 Quest Conversion Map

Already defined in `63-quest-conversion-strategy.md`:

```sql
CREATE TABLE IF NOT EXISTS mortal_quest_conversion_map (
  quest_id            INT PRIMARY KEY,
  conversion_type     VARCHAR(32) NOT NULL,  -- 'STORY_REWRITE','CONTRACT_BOARD','CONTRACT_LOCAL','FLAVOR'
  faction_tag         VARCHAR(64) NULL,     -- 'LEDGER','SHRINE','CARTEL','RANGERS', optional
  contract_template_id INT NULL,            -- link into world contract/task templates if used
  notes               TEXT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

**Source:**  
- Populated initially via:
  - Export of `quest_template` (or equivalent),
  - Manual + scripted classification by:
    - Zone,
    - Type,
    - Dependencies.

### 3.2 Spell Tags

New table:

```sql
CREATE TABLE IF NOT EXISTS mortal_spell_tags (
  spell_id        INT PRIMARY KEY,
  category        VARCHAR(32) NOT NULL,  -- 'CORE','LEARNED','RUNE','MASTERY','AUGMENT','REMOVED'
  subcategory     VARCHAR(32) NULL,      -- 'MARTIAL','ARCANE','HEALING','CC','MOBILITY','UTILITY','PVE_ONLY', etc.
  pvp_flags       VARCHAR(32) NULL,      -- 'PVP_REDUCED','PVP_DISABLED','PVP_CC_CAP', etc.
  source_type     VARCHAR(32) NULL,      -- 'BOOK','TRIAL','FACTION','DROP','CRAFT','BASELINE'
  notes           TEXT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 3.3 Item Tags

For gear, trinkets, set bonuses, etc:

```sql
CREATE TABLE IF NOT EXISTS mortal_item_tags (
  item_id         INT PRIMARY KEY,
  mortal_tier     INT NULL,              -- Mortal gear tier T1–T5 or NULL if not in progression
  category        VARCHAR(32) NULL,      -- 'WEAPON','ARMOR','TRINKET','CONSUMABLE','REAGENT','RUNE','APPEARANCE_ONLY'
  subcategory     VARCHAR(32) NULL,      -- 'SWORD','STAFF','LIGHT_ARMOR','HEAVY_ARMOR','MOUNT_REINS', etc.
  usage_policy    VARCHAR(32) NULL,      -- 'ENABLED','DISABLED','APPEARANCE_ONLY','VENDOR_TRASH','CONVERT_TO_RUNE'
  notes           TEXT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 3.4 Optional NPC Tags

For future passes:

```sql
CREATE TABLE IF NOT EXISTS mortal_npc_tags (
  entry           INT PRIMARY KEY,       -- creature_template.entry
  role            VARCHAR(32) NULL,      -- 'TRADER','GUARD','BOSS','WEAK_MOB','MID_ELITE','WORLD_BOSS'
  faction_override VARCHAR(64) NULL,     -- 'LEDGER','SHRINE','CARTEL','RANGERS','NEUTRAL', etc.
  scaling_profile VARCHAR(32) NULL,      -- 'FRONTIER_ELITE','PUBLIC_DUNGEON','STRONGHOLD_DEFENDER', etc.
  notes           TEXT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

---

## 4. Data Export & Workspace Setup

### 4.1 Recommended Workflow

1. **Create a separate “conversion workspace” DB:**
   - Clone of the AzerothCore world DB,
   - Used for:
     - Experimenting with scripts,
     - Generating tags and patches.

2. **Export baseline tables:**
   - `quest_template`, `creature_template`, `spell_template`, `item_template`, etc.
   - Use:
     - `mysqldump`,
     - Or simple SQL `SELECT INTO OUTFILE`.

3. **Store raw exports in a `tools/` directory in your repo:**

Example structure:

```text
tools/
  data/
    quests_raw.csv
    spells_raw.csv
    items_raw.csv
  scripts/
    classify_quests.py
    classify_spells.py
    classify_items.py
    generate_quest_patches.sql
    generate_spell_patches.sql
    generate_item_patches.sql
```

Cursor can work easily on these scripts + CSV files.

---

## 5. Quest Conversion Automation

### 5.1 Classification Helpers

We use a mix of:

- **Heuristics** (auto-tagging by patterns),
- **Zone & chain metadata**,
- **Manual override lists** for Keystone chains.

Example heuristics script (`classify_quests.py`):

- Load `quests_raw.csv`,
- For each quest:
  - Check:
    - Zone/Area,
    - `SpecialFlags`, `Type`, `QuestLevel`,
    - Text pattern matches (`“hero of the alliance”`, class references, etc.).
  - Assign a **default conversion_type**:
    - Most simple `KILL`/`COLLECT` → `CONTRACT_BOARD` or `CONTRACT_LOCAL`.
    - `ESCORT` quests → usually `CONTRACT_LOCAL`.
    - Quests with many prerequisites / long chains → candidate `STORY_REWRITE`.

- Output:
  - SQL insert/update statements populating `mortal_quest_conversion_map` with:
    - Tentative `conversion_type`,
    - Auto-generated `notes`.

### 5.2 Manual Keystone List

Create a file:

```text
tools/data/keystone_quests.txt
```

Listing quest IDs or chain roots that are:

- Important to rewrite as:
  - Campaign Acts,
  - Faction arcs,
  - Frontier meta events.

The classification script:

- Force-tags these as `STORY_REWRITE` with `notes='Keystone chain'`.

### 5.3 Patch Generation

Once `mortal_quest_conversion_map` is populated:

- `generate_quest_patches.sql` can:

1. Disable or repurpose specific quest_givers for `STORY_REWRITE` cases:
   - Mark them as inactive,
   - Or change their gossip to hint at custom scripts.

2. Convert `CONTRACT_BOARD` / `CONTRACT_LOCAL` quests into:
   - Contract or task templates in:
     - `mortal_contract_templates` or similar.

3. Standardize rewards:
   - Remove XP, adjust gold/material rewards per risk tier and level.

The exact patch details follow rules in `63-quest-conversion-strategy.md`.

---

## 6. Spell Conversion Automation

### 6.1 Tagging Spells

A `classify_spells.py` script can:

- Load `spells_raw.csv`,
- Match spells on:
  - School (holy/fire/frost/nature/shadow/arcane/physical),
  - Name and description patterns,
  - Attributes & effects (damage, heal, buff, CC, teleport, etc.),
  - Class-specific fields (if present).

Apply rules from `64-spell-and-ability-library.md`:

- Simple nukes / core attacks:
  - Tag as `category='LEARNED'` or `category='RUNE'`.
- Buffs & auras:
  - Tag as `category='AUGMENT'`.
- Big immunities / raid-level CDs:
  - Tag as `category='REMOVED'` or `subcategory='PVE_ONLY'`.
- Pure CC / stuns / fears:
  - Tag as `subcategory='CC'` + `pvp_flags='PVP_CC_CAP'`.
- Mobility (Charge/Blink):
  - Tag as `category='RUNE'`, `subcategory='MOBILITY'`.

The script emits:

- `INSERT ... ON DUPLICATE KEY UPDATE` statements for `mortal_spell_tags`.

### 6.2 Rank Consolidation

A separate step/script:

- Groups spells by:
  - Name base or `spellicon`, etc.
- Picks:
  - A single canonical `spell_id` per ability family,
  - Marks others as `category='REMOVED'` or internal-only.

Patch script:

- Updates:
  - Trainers,
  - Spell lists,
  - Book/tome items to reference the canonical ID only.

### 6.3 PvP Rules Injection

Using `mortal_spell_tags`:

- C++/Lua hooks read each spell’s `pvp_flags`:
  - Apply:
    - Duration caps for CC,
    - Reduced coefficients for heals/damage,
    - PvP disable for some spells.

Automation:

- Helper script can:
  - Generate C++ enum or config files from the tag table (e.g., `mortal_pvp_spell_rules.h`).

---

## 7. Item Conversion Automation

### 7.1 Mortal Tier Assignment

A `classify_items.py` script:

- Groups items by:
  - Quality (green/blue/epic),
  - Slot (weapon/armor/trinket),
  - Required level,
  - Source (raid/dungeon/BoE).

Rules:

- Endgame raid pieces:
  - Get assigned Mortal T4–T5 equivalents.
- Heroic dungeon drops:
  - Mortal T3.
- Normal dungeons:
  - Mortal T2.
- Basic crafted / quest gear:
  - Mortal T1 or “starter” tier.

The exact mapping can be tuned, but the script gives you a **baseline**.

### 7.2 Special Categories

- Trinkets with complex procs:
  - Tagged with `usage_policy='CONVERT_TO_RUNE'` or `usage_policy='DISABLED'` depending on viability.
- Old set bonuses:
  - Items may be:
    - Re-tagged as appearance only (`APPEARANCE_ONLY`),
    - Or included in Mortal tiers with **new, simpler set effects** manually designed later.
- Mount items:
  - Tagged as `subcategory='MOUNT_REINS'`,
  - To be wired into:
    - Living Mounts spec (durability, hunger, full-loot drop).

### 7.3 Appearance Library Population

Additionally:

- Script can:
  - Generate initial rows for the **Appearance Codex**:
    - From all armor/weapon item models,
    - Marking:
      - Their model ID,
      - Gender/race variations if any.

This ties into `57-appearance-codex-and-transmog.md`.

---

## 8. NPC & Encounter Rebalance Automation (Stub)

Full automation is risky, but scripts can:

- Tag NPCs based on:
  - Level,
  - Rank (elite/boss),
  - Location (zone/instance),
- Assign default scaling profiles:
  - `WEAK_MOB`, `MID_ELITE`, `WORLD_BOSS`, `PUBLIC_DUNGEON_ELITE`, etc.

`classify_npcs.py` can:

- Fill `mortal_npc_tags`,
- Which can then be read by:
  - C++ scaling functions,
  - Lua encounter scripts,
- To apply:
  - Health/damage scaling,
  - Extra mechanics toggles for certain templates.

---

## 9. Running the Pipeline

### 9.1 Recommended Order

1. **Initialize tagging tables**:
   - `mortal_quest_conversion_map`,
   - `mortal_spell_tags`,
   - `mortal_item_tags`,
   - `mortal_npc_tags` (optional).

2. **Export raw data**:
   - Quests, spells, items, NPCs to CSV.

3. **Run classification scripts**:
   - `classify_quests.py`,
   - `classify_spells.py`,
   - `classify_items.py`,
   - `classify_npcs.py` (if used).

4. **Review & hand-edit**:
   - Keystone quest lists,
   - High-impact spells (heals, CC, immunities),
   - Top-tier raid items & trinkets.

5. **Generate patches**:
   - `generate_quest_patches.sql`,
   - `generate_spell_patches.sql`,
   - `generate_item_patches.sql`.

6. **Apply patches to a test DB**:
   - Separate from production/test realm.

7. **Verify in-game**:
   - Check sample zones and dungeons:
     - Quest availability,
     - Spell kits and training,
     - Item drops and vendors.

8. **Iterate**:
   - Adjust classification rules,
   - Regenerate tags and patches as needed.

---

## 10. Tooling & Repo Structure

Suggested addition to your repo:

```text
/Tools
  /data
    quests_raw.csv
    spells_raw.csv
    items_raw.csv
    npcs_raw.csv
    keystone_quests.txt
    keystone_spells.txt   # optional special cases
  /scripts
    classify_quests.py
    classify_spells.py
    classify_items.py
    classify_npcs.py
    generate_quest_patches.sql
    generate_spell_patches.sql
    generate_item_patches.sql
    README.md
```

- Each script:
  - Documented in `README.md`,
  - Designed so Cursor can easily modify/add rules.

---

## 11. Design Principles for Automation

1. **Data-driven, not hard-coded.**
   - All categorizations and decisions should come from:
     - Tag tables,
     - Configs,
     - Not buried in C++ if avoidable.

2. **Repeatable & reversible.**
   - You can:
     - Re-run classification after updating specs,
     - Apply new patches over a fresh DB.

3. **Manual control over high-impact content.**
   - Scripts give you:
     - Reasonable defaults,
     - But Keystone chains, top-tier spells, and key items are always:
       - Listed in separate text files,
       - Reviewed by a human.

4. **Expose tags to admins & tools.**
   - Build a GM/Atlas view that:
     - Shows quest/spell/item tags,
     - Makes it easy to spot anomalies (e.g., a powerful CC spell marked `CORE` accidentally).

---

This document should be used whenever you:

- Stand up a new AzerothCore DB for Mortal Warcraft,
- Need to re-run conversions after core changes,
- Or want to extend the rules for new content (new Runes, Faction spells, gear tiers, etc.).
