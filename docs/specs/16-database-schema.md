# Project Canvas: Mortal Warcraft Overhaul
### Version 26.1 — Hybrid Technical Design Document  
### File: 16-database-schema.md  
### Section: Database Schema Overview (Core Tables, Relations & Naming Conventions)

---

## Related Specs

- `30-db-migrations-mortal-core.md` - Core database migrations that implement this schema
- `01-progression.md` - Character progression and skills tables
- `04-economy.md` - Economy and regional banking tables
- `08-guilds-sovereignty.md` - Stronghold and guild sovereignty tables
- `11-pvp-systems.md` - PvP, notoriety, and bounty tables
- `51-factions-and-standing-system.md` - Faction and standing tables
- `19-itemization.md` - Item and gear tables
- `75-mortal-gear-and-runes-spec.md` - Rune and gear system tables
- `29-companion-bond-and-mercenary-system.md` - Companion and mercenary tables

---

# 1. Overview

This document gives a **high-level database schema map** for Mortal Warcraft, focusing on:

- New core tables
- Extended AzerothCore tables
- Relationships between systems
- Naming conventions
- Indexing principles

It is **not** a full DDL export, but a **spec guide** for how to structure SQL migration files.

---

# 2. Conventions

- **Prefix** all custom tables with `mortal_` where appropriate.
- Use **InnoDB** with foreign keys.
- Use **snake_case** for columns and tables.
- Primary key pattern: `id` (INT AUTO_INCREMENT) or natural keys where needed.
- All GUID links use standard AC GUID types.

---

# 3. Progression & Skills

## 3.1 `mortal_character_skills`

Tracks all custom skills (combat, crafting, lore, utility).

**Columns:**
- `id` (PK)
- `guid` (FK → `characters.guid`)
- `skill_id` (INT) – internal skill reference
- `value` (INT) – current skill level
- `max_value` (INT) – possible cap (e.g. 400)
- `last_gain_time` (INT, UNIX timestamp)

**Indexes:**
- `idx_mortal_skills_guid`
- `idx_mortal_skills_skill_id`

---

## 3.2 `mortal_material_lore`

Lore skill per material family.

**Columns:**
- `id` (PK)
- `guid` (FK → `characters.guid`)
- `material_id` (INT)
- `lore_level` (INT)
- `last_studied` (INT)

---

## 3.3 `mortal_mastery_points`

Tracks Mastery Tree points.

**Columns:**
- `guid` (PK, FK → `characters.guid`)
- `warlord_points` (INT)
- `guardian_points` (INT)
- `explorer_points` (INT)
- `unspent_points` (INT)

---

# 4. Attributes & Derived Level

## 4.1 `mortal_character_attributes`

Attributes & caps used by C++ hooks.

**Columns:**
- `guid` (PK, FK → `characters.guid`)
- `strength` (INT)
- `agility` (INT)
- `stamina` (INT)
- `intellect` (INT)
- `spirit` (INT)
- `total_attributes` (INT, computed/validated)

---

## 4.2 `mortal_derived_level_cache`

Optional optimization cache.

**Columns:**
- `guid` (PK)
- `derived_level` (TINYINT)
- `last_recalc` (INT)

---

# 5. Economy & Banking

## 5.1 `mortal_regional_bank`

Per-region banking.

**Columns:**
- `id` (PK)
- `guid` (FK → `characters.guid`)
- `region_id` (SMALLINT) – SW/IF/ORG, etc.
- `slot` (SMALLINT)
- `item_guid` (BIGINT)
- `item_count` (INT)

---

## 5.2 `mortal_market_stalls`

Player vendor stall configuration.

**Columns:**
- `id` (PK)
- `owner_guid` (FK → `characters.guid`)
- `stall_npc_entry` (INT)
- `region_id` (SMALLINT)
- `rent_expiry` (INT)
- `tax_rate` (FLOAT)
- `title` (VARCHAR)

---

## 5.3 `mortal_market_items`

Items listed on stalls.

**Columns:**
- `id` (PK)
- `stall_id` (FK → `mortal_market_stalls.id`)
- `item_template` (INT)
- `item_guid` (BIGINT, optional if per-instance)
- `quantity` (INT)
- `price` (BIGINT)
- `time_added` (INT)

---

# 6. Crafting & Materials

## 6.1 `mortal_material_properties`

Defines the “physics” of materials.

**Columns:**
- `material_id` (PK)
- `name` (VARCHAR)
- `family` (ENUM: metal, wood, leather, fabric, essence)
- `hardness` (INT)
- `flexibility` (INT)
- `weight` (INT)
- `conductivity` (INT)
- `purity` (INT)
- `tier` (TINYINT)

---

## 6.2 `mortal_crafting_components`

Intermediate parts.

**Columns:**
- `id` (PK)
- `component_type` (VARCHAR) – blade, hilt, plate
- `material_id` (FK → `mortal_material_properties.material_id`)
- `quality_tier` (TINYINT)
- `base_item_template` (INT)
- `created_by` (FK → `characters.guid`)
- `created_at` (INT)

---

## 6.3 `mortal_blueprints`

BPO/BPC definitions.

**Columns:**
- `id` (PK)
- `item_template` (INT) – blueprint item
- `is_original` (BOOLEAN)
- `max_uses` (INT) – NULL for Originals
- `craft_type` (VARCHAR)
- `output_item_template` (INT)
- `required_skill` (INT)
- `required_skill_level` (INT)
- `notes` (TEXT)

---

## 6.4 `mortal_item_weight`

Maps item templates to weight & class.

**Columns:**
- `item_template` (PK)
- `weight` (INT)
- `weight_class` (ENUM: ultra_light, light, medium, heavy, ultra_heavy)

---

# 7. Caravans & Contracts

## 7.1 `mortal_courier_contracts`

Core contract system.

**Columns:**
- `id` (PK)
- `owner_guid` (FK → `characters.guid`)
- `courier_guid` (FK → `characters.guid`, nullable)
- `origin_region_id` (SMALLINT)
- `destination_region_id` (SMALLINT)
- `crate_id` (FK → `mortal_contract_crates.id`)
- `collateral_amount` (BIGINT)
- `reward_amount` (BIGINT)
- `deadline` (INT)
- `status` (ENUM: open, accepted, completed, failed, cancelled)
- `created_at` (INT)
- `accepted_at` (INT, nullable)
- `completed_at` (INT, nullable)

---

## 7.2 `mortal_contract_crates`

Encapsulated cargo.

**Columns:**
- `id` (PK)
- `owner_guid` (FK)
- `item_container_id` (BIGINT)
- `weight` (INT)
- `created_at` (INT)

---

## 7.3 `mortal_caravan_wagons`

Live caravan instances.

**Columns:**
- `id` (PK)
- `owner_guid` (FK → `characters.guid`)
- `contract_id` (FK → `mortal_courier_contracts.id`, nullable)
- `wagon_type` (VARCHAR)
- `current_zone` (SMALLINT)
- `pos_x` (FLOAT)
- `pos_y` (FLOAT)
- `health` (INT)
- `max_health` (INT)
- `created_at` (INT)

---

# 8. Gear, Mounts & Companions

## 8.1 `mortal_gear_visuals`

Maps Mortal custom gear items to their visual sources (WotLK item models).

**Columns:**
- `id` (PK)
- `mortal_item_entry` (INT) – custom item entry (700000-719999 range)
- `mortal_tier` (VARCHAR) – 'M-T1' through 'M-T5' or 'P1' through 'P6'
- `category` (VARCHAR) – 'pve' or 'pvp'
- `armor_type` (VARCHAR) – 'plate','mail','leather','cloth'
- `slot` (VARCHAR) – 'head','chest','legs', etc.
- `source_type` (VARCHAR) – 't7','t8','t9','t10','s5','s6','s7','s8'
- `source_item_entry` (INT) – original WotLK item entry
- `displayid` (INT) – copied from item_template.displayid
- `notes` (VARCHAR)

**See:** `26-gear-visual-mapping.md`, `30-db-migrations-mortal-core.md`

---

## 8.2 `mortal_mount_visuals`

Defines Mortal Living Mounts (Reins items) with tier, speed, and capacity.

**Columns:**
- `id` (PK)
- `mortal_item_entry` (INT) – Reins item entry (720000-729999 range)
- `mortal_mount_tier` (VARCHAR) – 'M-M1','M-M2','M-M3','M-M4'
- `speed_multiplier` (FLOAT) – e.g. 0.6, 1.0, 1.2, 1.3
- `capacity_slots` (INT) – extra saddlebag slots (0-16)
- `source_item_entry` (INT) – original WotLK mount item
- `source_spell_id` (INT) – original mount spell
- `source_creature_id` (INT, nullable) – optional creature_template entry
- `notes` (VARCHAR)

**See:** `28-mounts-living-system-and-mapping.md`, `30-db-migrations-mortal-core.md`

**Note:** Future breeding system (from `07-mounts.md`) would add `mortal_mounts`, `mortal_mount_breeds`, and `mortal_mount_bloodlines` tables, but the current implementation uses the simpler `mortal_mount_visuals` approach.

---

## 8.3 `mortal_companions`

Tracks Bond & Hunger for all companion types (pets, mercs, mounts).

**Columns:**
- `id` (PK)
- `owner_guid` (INT, FK → `characters.guid`)
- `companion_guid` (BIGINT) – pet/merc creature GUID or mount item instance GUID
- `companion_type` (TINYINT) – 0=pet, 1=merc, 2=mount
- `hunger` (TINYINT) – 0-100
- `bond` (TINYINT) – 0-100
- `last_update` (INT) – Unix timestamp

**See:** `29-companion-bond-and-mercenary-system.md`, `30-db-migrations-mortal-core.md`

---

## 8.4 `mortal_merc_templates`

Defines available mercenary archetypes (tank/healer/DPS).

**Columns:**
- `id` (PK)
- `name` (VARCHAR) – e.g. "Mortal Field Medic"
- `role` (VARCHAR) – 'tank','healer','melee_dps','ranged_dps'
- `base_gear_tier` (VARCHAR) – e.g. 'M-T2','M-T3'
- `creature_entry` (INT) – creature_template.entry (600000-609999 range)
- `base_wage` (INT) – gold cost baseline
- `max_bond_bonus` (TINYINT) – max % performance bonus at bond=100
- `notes` (VARCHAR)

**See:** `29-companion-bond-and-mercenary-system.md`, `30-db-migrations-mortal-core.md`

---

## 8.5 `mortal_merc_contracts`

Tracks active mercenary contracts (player hires).

**Columns:**
- `id` (PK)
- `owner_guid` (INT, FK → `characters.guid`)
- `merc_template_id` (INT, FK → `mortal_merc_templates.id`)
- `merc_creature_guid` (BIGINT, nullable) – spawned creature GUID if active
- `start_time` (INT) – Unix timestamp
- `end_time` (INT) – Unix timestamp
- `active` (TINYINT)
- `last_paid_time` (INT)
- `daily_wage` (INT)
- `notes` (VARCHAR)

**See:** `29-companion-bond-and-mercenary-system.md`, `30-db-migrations-mortal-core.md`

---

# 9. PvP, Crime & Bounties

## 9.1 `mortal_notoriety`

Tracks Notoriety and crime state.

**Columns:**
- `guid` (PK, FK → `characters.guid`)
- `notoriety_score` (INT)
- `tier` (TINYINT)
- `last_crime_time` (INT)
- `outlaw_since` (INT, nullable)

---

## 9.2 `mortal_bounties`

Bounty postings.

**Columns:**
- `id` (PK)
- `target_guid` (FK → `characters.guid`)
- `posted_by_guid` (FK → `characters.guid`)
- `bounty_amount` (BIGINT)
- `created_at` (INT)
- `expires_at` (INT)
- `is_active` (BOOLEAN)

---

## 9.3 `mortal_bounty_claims`

Claim history.

**Columns:**
- `id` (PK)
- `bounty_id` (FK → `mortal_bounties.id`)
- `killer_guid` (FK → `characters.guid`)
- `claimed_at` (INT)

---

## 9.4 `mortal_pvp_kills`

Detailed PvP log.

**Columns:**
- `id` (PK)
- `killer_guid` (FK)
- `victim_guid` (FK)
- `zone_id` (SMALLINT)
- `risk_tier` (TINYINT)
- `time` (INT)
- `loot_value` (BIGINT)
- `flags` (INT – zerg, criminal, bounty)

---

# 10. Guilds, Strongholds & Territory

## 10.1 `mortal_strongholds`

Stronghold ownership and state.

**Columns:**
- `id` (PK)
- `name` (VARCHAR)
- `map_id` (INT)
- `pos_x` (FLOAT)
- `pos_y` (FLOAT)
- `guild_id` (FK → `guild.id`, nullable)
- `level` (TINYINT)
- `treasury_gold` (BIGINT)
- `last_siege_time` (INT)

---

## 10.2 `mortal_tcp` (Territory Control Points)

Control nodes.

**Columns:**
- `id` (PK)
- `name` (VARCHAR)
- `zone_id` (SMALLINT)
- `pos_x` (FLOAT)
- `pos_y` (FLOAT)
- `controlling_guild_id` (FK → `guild.id`, nullable)
- `last_flip_time` (INT)
- `influence_value` (INT)

---

## 10.3 `mortal_guild_season_scores`

Season rankings.

**Columns:**
- `guild_id` (PK, FK)
- `season_id` (INT)
- `territory_score` (INT)
- `siege_wins` (INT)
- `caravans_escorted` (INT)
- `events_participated` (INT)
- `rank_position` (INT)

---

## 10.4 `mortal_guild_alliances`

Alliance & politics.

**Columns:**
- `id` (PK)
- `guild_id_a` (FK → `guild.id`)
- `guild_id_b` (FK → `guild.id`)
- `status` (ENUM: allied, at_war, neutral)
- `created_at` (INT)
- `updated_at` (INT)

---

# 11. Logs & Analytics

## 11.1 `mortal_log_economy`

Economy actions.

**Columns:**
- `id` (PK)
- `guid` (FK)
- `action_type` (VARCHAR) – stall_sale, tax_collected, contract_paid
- `amount` (BIGINT)
- `region_id` (SMALLINT)
- `time` (INT)
- `details` (TEXT)

---

## 11.2 `mortal_log_admin`

Admin actions.

**Columns:**
- `id` (PK)
- `gm_guid` (FK → `characters.guid`)
- `action` (VARCHAR)
- `target_guid` (FK, nullable)
- `time` (INT)
- `notes` (TEXT)

---

## 11.3 `mortal_log_guild`

Guild-level events.

**Columns:**
- `id` (PK)
- `guild_id` (FK)
- `event_type` (VARCHAR)
- `time` (INT)
- `details` (TEXT)

---

# 12. World Simulation & Events

## 12.1 `mortal_ecosystem_spawn_weights`

Per-zone creature weights.

**Columns:**
- `id` (PK)
- `zone_id` (SMALLINT)
- `creature_entry` (INT)
- `weight` (INT)
- `last_modified` (INT)

---

## 12.2 `mortal_ecosystem_relations`

Predator-prey rules.

**Columns:**
- `id` (PK)
- `predator_entry` (INT)
- `prey_entry` (INT)
- `pressure_factor` (FLOAT)

---

## 12.3 `mortal_seasonal_state`

Season & global modifiers.

**Columns:**
- `id` (PK, 1 row global)
- `current_season` (ENUM: spring, summer, autumn, winter)
- `season_start` (INT)
- `season_end` (INT)

---

## 12.4 `mortal_world_events`

Active & historical events.

**Columns:**
- `id` (PK)
- `event_type` (VARCHAR)
- `status` (ENUM: scheduled, running, ended)
- `zone_id` (SMALLINT)
- `start_time` (INT)
- `end_time` (INT)
- `data` (TEXT)

---

# 13. Social & RP

## 13.1 `mortal_titles`

Title definitions.

**Columns:**
- `id` (PK)
- `name` (VARCHAR)
- `category` (VARCHAR)
- `requirements` (TEXT)

---

## 13.2 `mortal_character_titles`

Who owns which titles.

**Columns:**
- `id` (PK)
- `guid` (FK → `characters.guid`)
- `title_id` (FK → `mortal_titles.id`)
- `unlocked_at` (INT)
- `is_active` (BOOLEAN)

---

## 13.3 `mortal_character_bio`

Player-written bios.

**Columns:**
- `guid` (PK, FK)
- `bio_text` (TEXT)
- `rp_tags` (VARCHAR)

---

# 14. Feature Flags & Config

## 14.1 `mortal_feature_flags`

Live-tunable switches for balancing.

**Columns:**
- `key` (PK, VARCHAR)
- `value` (VARCHAR)
- `updated_at` (INT)

---

# 15. Indexing & Performance Notes

- All tables referencing `guid` or `guild_id` must have **indexes** on those fields.
- Time-series logs (`mortal_log_*`, `mortal_pvp_kills`) should have:
  - Index on `(time)`
  - Optional partial pruning/archival strategy.
- Territory & stronghold queries are frequent → index `(zone_id, controlling_guild_id)` and `(map_id)`.

---

# 16. Status

This schema overview is **Authoritative for v26.1**.  
Individual migration files (`*.sql`) should be organized per system:

- `01_skills_and_attributes.sql`
- `02_economy_and_banking.sql`
- `03_crafting_and_materials.sql`
- `04_pvp_and_crime.sql`
- `05_guilds_and_territory.sql`
- `06_world_simulation.sql`
- `07_social_and_titles.sql`
- `08_logs_and_analytics.sql`
- `09_feature_flags.sql`

This keeps DB evolution manageable and Cursor-friendly.

