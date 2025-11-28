# Mortal Warcraft Conversion Scripts

This directory contains scripts for automating the conversion of WotLK data into Mortal Warcraft's systems.

## Overview

These scripts follow Spec 67 (Conversion Automation Plan) and provide a repeatable pipeline for:
- Quest classification and conversion
- Spell tagging and categorization
- Item tier assignment and tagging
- NPC role assignment and scaling profile assignment

## Directory Structure

```
tools/conversion_scripts/
├── README.md                    # This file
├── classify_quests.py          # Quest classification script
├── classify_spells.py          # Spell tagging script
├── classify_items.py           # Item tagging script
├── classify_npcs.py            # NPC tagging script
├── generate_quest_patches.sql  # Quest conversion patch generator
├── generate_spell_patches.sql  # Spell conversion patch generator
├── generate_item_patches.sql   # Item conversion patch generator
└── data/                        # Raw data exports
    ├── quests_raw.csv
    ├── spells_raw.csv
    ├── items_raw.csv
    ├── npcs_raw.csv
    ├── keystone_quests.txt      # Manual override list
    └── keystone_spells.txt      # Manual override list
```

## Prerequisites

- Python 3.8+
- MySQL/MariaDB client libraries
- Access to AzerothCore world database

## Usage

### 1. Export Raw Data

First, export raw data from your AzerothCore database using the export tool:

```bash
# Export all conversion tables at once (recommended)
python3 tools/export_db_tables.py --all-conversion --output-dir tools/conversion_scripts/data/

# Or export individually
python3 tools/export_db_tables.py --table quest_template --output tools/conversion_scripts/data/quests_raw.csv
python3 tools/export_db_tables.py --table item_template --output tools/conversion_scripts/data/items_raw.csv
python3 tools/export_db_tables.py --table creature_template --output tools/conversion_scripts/data/npcs_raw.csv
python3 tools/export_db_tables.py --table spell_template --output tools/conversion_scripts/data/spells_raw.csv
```

**Note:** The export tool reads database configuration from environment variables or `worldserver.conf`. See `tools/export_db_tables.py --help` for options.

### 2. Run Classification Scripts

```bash
# Classify quests
python3 classify_quests.py

# Classify spells
python3 classify_spells.py

# Classify items
python3 classify_items.py

# Classify NPCs
python3 classify_npcs.py
```

### 3. Review and Edit

- Review generated tags in the database
- Edit `data/keystone_quests.txt` and `data/keystone_spells.txt` for manual overrides
- Re-run classification scripts if needed

### 4. Generate Patches

```bash
# Generate SQL patches
mysql -u root -p world < generate_quest_patches.sql
mysql -u root -p world < generate_spell_patches.sql
mysql -u root -p world < generate_item_patches.sql
```

### 5. Verify

Check conversion statistics:

```sql
SELECT * FROM mortal_conversion_stats;
```

## Script Details

### classify_quests.py ✅

Classifies quests based on:
- Zone/Area
- Quest type (KILL, COLLECT, ESCORT, etc.)
- Chain dependencies
- Manual keystone list

Outputs: SQL INSERT statements for `mortal_quest_conversion_map`

### classify_spells.py ✅

Tags spells based on:
- Spell school (holy, fire, frost, etc.)
- Name/description patterns
- Effects (damage, heal, buff, CC, teleport)
- Spec 64 rules (CORE, LEARNED, RUNE, MASTERY, AUGMENT, REMOVED)
- PvP flags and modifiers
- Combat ability detection

Outputs: SQL INSERT statements for `mortal_spell_tags`

### classify_items.py ✅

Tags items based on:
- Quality (green/blue/epic)
- Slot (weapon/armor/trinket)
- Required level
- Source (raid/dungeon/BoE)

Outputs: SQL INSERT statements for `mortal_item_tags`

### classify_npcs.py ✅

Tags NPCs based on:
- Level
- Rank (elite/boss)
- Location (zone/instance)

Outputs: SQL INSERT statements for `mortal_npc_tags`

## Manual Override Lists

### keystone_quests.txt

One quest ID per line. These quests will be force-tagged as `STORY_REWRITE` with notes indicating they are keystone chains.

### keystone_spells.txt

One spell ID per line. These spells will receive special handling (e.g., marked for manual review).

## Patch Generation Scripts ✅

### generate_quest_patches.sql ✅

Applies quest conversions:
- Disables STORY_REWRITE quests
- Updates quest giver gossip for CONTRACT_BOARD quests
- Removes XP rewards (Mortal uses skill points)
- Scales gold rewards for Mortal economy

### generate_spell_patches.sql ✅

Applies spell conversions:
- Disables REMOVED spells
- Marks rank spells for consolidation
- Updates trainers to teach canonical ranks

### generate_item_patches.sql ✅

Applies item conversions:
- Disables DISABLED items
- Marks APPEARANCE_ONLY items
- Updates item levels to match Mortal tiers
- Marks mount items for Living Mounts system

## Notes

- All scripts are designed to be idempotent (safe to re-run)
- Scripts use `INSERT ... ON DUPLICATE KEY UPDATE` to allow iteration
- Manual overrides take precedence over heuristics
- Review high-impact content (top-tier items, powerful spells) manually
- **Review patch scripts before applying** - they modify game data

