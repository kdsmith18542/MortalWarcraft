# Project Canvas: Mortal Warcraft Overhaul
### Version 26.6 — Hybrid Technical Design Document  
### File: 30-db-migrations-mortal-core.md  
### Section: Core DB Migrations Bundle (Gear, Mounts, Companions, Mercs)

---

## Related Specs

- `26-gear-visual-mapping.md` - Gear visual mapping system
- `27-gear-stats-and-etl.md` - Gear stats and ETL pipeline
- `28-mounts-living-system-and-mapping.md` - Mount system and mapping
- `29-companion-bond-and-mercenary-system.md` - Companion and mercenary system
- `07-mounts.md` - Mount system design
- `19-itemization.md` - Itemization system
- `75-mortal-gear-and-runes-spec.md` - Gear and rune system
- `16-database-schema.md` - Database schema overview
- `31-mortal-core-registry.md` - ID registry for custom entries

---

## 1. Purpose

This document groups the **core Mortal-specific DB structures** into a single, coherent migration bundle.

It covers:

- Gear visuals & mapping.
- Mount visuals & Living Mount tiers.
- Companions (Bond & Hunger).
- Mercenary templates & contracts.

This should become a **single SQL migration** (or a small set, ordered) that can be applied on top of **AzerothCore 3.3.5a**.

Suggested filename:

- `data/sql/updates/mortal_overhaul_core.sql`

---

## 2. Naming & Conventions

- All tables are prefixed with `mortal_` to avoid clashes.
- Use **InnoDB** and `utf8mb4` where possible.
- Add indices for common lookups (owner, active, type).
- Foreign keys are left optional to keep it simple for now; you can add them once you’re happy with stability.

---

## 3. Table: mortal_gear_visuals

**Source Spec:** `26-gear-visual-mapping.md`

Purpose:

- Map **Mortal items** (custom `item_template.entry` IDs) to:
  - Their **tier/rank**.
  - Their **source WotLK item** (visual origin).
  - Their **displayid** (copied from `item_template.displayid`).

```sql
CREATE TABLE IF NOT EXISTS mortal_gear_visuals (
  id                 INT AUTO_INCREMENT PRIMARY KEY,
  mortal_item_entry  INT NOT NULL,
  mortal_tier        VARCHAR(8) NOT NULL,    -- 'M-T1','M-T2','P3','P6', etc.
  category           VARCHAR(16) NOT NULL,   -- 'pve' or 'pvp'
  armor_type         VARCHAR(8) NOT NULL,    -- 'plate','mail','leather','cloth'
  slot               VARCHAR(16) NOT NULL,   -- 'head','chest','legs','hands','shoulders', etc.
  source_type        VARCHAR(32) NOT NULL,   -- 't7','t8','t9','t10','s5','s6','s7','s8', etc.
  source_item_entry  INT NOT NULL,           -- original WotLK item entry
  displayid          INT NOT NULL,           -- from item_template.displayid
  notes              VARCHAR(255) NULL,
  INDEX idx_mortal_item (mortal_item_entry),
  INDEX idx_source_item (source_item_entry),
  INDEX idx_tier_category (mortal_tier, category)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

---

## 4. Table: mortal_mount_visuals

**Source Spec:** `28-mounts-living-system-and-mapping.md`

Purpose:

- Define Mortal **Living Mounts**:
  - Map Reins item ID to mount tier, speed, capacity.
  - Reference original WotLK mount item and spell.

```sql
CREATE TABLE IF NOT EXISTS mortal_mount_visuals (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  mortal_item_entry     INT NOT NULL,        -- new Reins item ID (e.g. 72001)
  mortal_mount_tier     VARCHAR(8) NOT NULL, -- 'M-M1','M-M2','M-M3','M-M4'
  speed_multiplier      FLOAT NOT NULL,      -- e.g. 0.6, 1.0, 1.2, 1.3
  capacity_slots        INT NOT NULL,        -- extra saddlebag slots (0–16)
  source_item_entry     INT NOT NULL,        -- original WotLK mount item
  source_spell_id       INT NOT NULL,        -- original mount spell
  source_creature_id    INT NULL,            -- optional, creature_template entry
  notes                 VARCHAR(255) NULL,
  INDEX idx_mortal_mount_item (mortal_item_entry),
  INDEX idx_mount_tier (mortal_mount_tier)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

---

## 5. Table: mortal_companions

**Source Spec:** `29-companion-bond-and-mercenary-system.md`

Purpose:

- Store **Bond & Hunger** for all companion types:
  - Pets.
  - Mercenaries.
  - Mounts (via their item instance GUID).

```sql
CREATE TABLE IF NOT EXISTS mortal_companions (
  id                INT AUTO_INCREMENT PRIMARY KEY,
  owner_guid        INT NOT NULL,        -- player GUID
  companion_guid    BIGINT NOT NULL,     -- pet/merc/mount identifier
  companion_type    TINYINT NOT NULL,    -- 0=pet,1=merc,2=mount
  hunger            TINYINT NOT NULL DEFAULT 100,   -- 0-100
  bond              TINYINT NOT NULL DEFAULT 0,     -- 0-100
  last_update       INT NOT NULL,        -- Unix timestamp (seconds)
  INDEX idx_owner_type (owner_guid, companion_type),
  INDEX idx_companion (companion_guid, companion_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

> Notes:
> - `owner_guid` refers to `characters.guid`.
> - `companion_guid` refers to:
>   - Pet/merc creature GUID (from `creature`/`pet` tables).
>   - Mount item instance GUID (from `item_instance.guid`).

---

## 6. Table: mortal_merc_templates

**Source Spec:** `29-companion-bond-and-mercenary-system.md`

Purpose:

- Define **merc archetypes** available in the game:
  - Tank / Healer / DPS roles.
  - Their base gear tier (Mortal tier they emulate).
  - Creature template for spawning.

```sql
CREATE TABLE IF NOT EXISTS mortal_merc_templates (
  id                INT AUTO_INCREMENT PRIMARY KEY,
  name              VARCHAR(64) NOT NULL,
  role              VARCHAR(16) NOT NULL,   -- 'tank','healer','melee_dps','ranged_dps'
  base_gear_tier    VARCHAR(8) NOT NULL,    -- e.g. 'M-T2','M-T3'
  creature_entry    INT NOT NULL,           -- from creature_template.entry
  base_wage         INT NOT NULL,           -- gold cost baseline
  max_bond_bonus    TINYINT NOT NULL DEFAULT 10, -- max % performance bonus
  notes             VARCHAR(255) NULL,
  INDEX idx_role (role),
  INDEX idx_tier (base_gear_tier)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

---

## 7. Table: mortal_merc_contracts

**Source Spec:** `29-companion-bond-and-mercenary-system.md`

Purpose:

- Track **which player hired which merc**, for how long and under what conditions.

```sql
CREATE TABLE IF NOT EXISTS mortal_merc_contracts (
  id                  INT AUTO_INCREMENT PRIMARY KEY,
  owner_guid          INT NOT NULL,      -- characters.guid
  merc_template_id    INT NOT NULL,      -- mortal_merc_templates.id
  merc_creature_guid  BIGINT NULL,       -- active creature GUID if spawned
  start_time          INT NOT NULL,      -- Unix timestamp
  end_time            INT NOT NULL,      -- Unix timestamp
  active              TINYINT NOT NULL DEFAULT 0,
  last_paid_time      INT NOT NULL,      -- last upkeep payment
  daily_wage          INT NOT NULL,      -- effective wage for this contract
  notes               VARCHAR(255) NULL,
  INDEX idx_owner_active (owner_guid, active),
  INDEX idx_template (merc_template_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

> Optional later:
> - Add **FOREIGN KEY** constraints to `characters` and `mortal_merc_templates`.
> - For now, left out to simplify initial integration.

---

## 8. Suggested Migration Ordering

Inside `mortal_overhaul_core.sql`:

```sql
-- 1. Gear visuals
SOURCE 01_mortal_gear_visuals.sql;      -- or inline CREATE TABLE

-- 2. Mount visuals
SOURCE 02_mortal_mount_visuals.sql;

-- 3. Companions (Bond & Hunger)
SOURCE 03_mortal_companions.sql;

-- 4. Merc system
SOURCE 04_mortal_merc_templates.sql;
SOURCE 05_mortal_merc_contracts.sql;
```

Or simply keep them all in one file in the correct order:

1. `mortal_gear_visuals`
2. `mortal_mount_visuals`
3. `mortal_companions`
4. `mortal_merc_templates`
5. `mortal_merc_contracts`

---

## 9. Integration Notes

- **item_template**:
  - No schema changes required.
  - Mortal gear/mount items will be inserted via:
    - ETL script from `26-gear-visual-mapping.md` + `27-gear-stats-and-etl.md`.
    - Mount ETL from `28-mounts-living-system-and-mapping.md`.

- **characters / creature_template / item_instance**:
  - Existing AzerothCore tables; we only reference them via GUIDs/entries.

- **Scripts**:
  - C++/Lua systems should:
    - Query/update `mortal_companions` for hunger/bond.
    - Query `mortal_merc_templates` when offering mercs in UI.
    - Create/update `mortal_merc_contracts` when hiring/renewing mercs.
    - Query `mortal_gear_visuals` / `mortal_mount_visuals` in ETL tools, not during live gameplay (those are mostly design-time tables).

---

## 10. Status

This file is the **migration bundle spec** for the core Mortal systems:

- Gear visuals.
- Mount visuals.
- Companion Bond & Hunger.
- Mercenary templates & contracts.

Place it as:

- `docs/30-db-migrations-mortal-core.md`

Then:

- Use this as the source of truth when generating:
  - `data/sql/updates/mortal_overhaul_core.sql`
  - Or individual `01_*.sql` files under your AzerothCore-style update path.
