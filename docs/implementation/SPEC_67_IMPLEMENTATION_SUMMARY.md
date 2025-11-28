# Spec 67: Conversion Automation Plan - Implementation Summary

## Overview

Complete implementation of the conversion automation framework for semi-automating the conversion of WotLK data into Mortal Warcraft's systems.

---

## Database Schema ✅ **COMPLETE**

**File:** `sql/78_conversion_automation_tables.sql`

### Tables Created:
1. **`mortal_quest_conversion_map`** - Quest conversion mapping
   - `quest_id` - Quest ID from quest_template
   - `conversion_type` - STORY_REWRITE, CONTRACT_BOARD, CONTRACT_LOCAL, FLAVOR, HUB_NARRATIVE
   - `faction_tag` - LEDGER, SHRINE, CARTEL, RANGERS (optional)
   - `contract_template_id` - Link to contract/task templates
   - `notes` - Conversion notes

2. **`mortal_item_tags`** - Item categorization
   - `item_id` - Item ID from item_template
   - `mortal_tier` - Mortal gear tier T1-T5
   - `category` - WEAPON, ARMOR, TRINKET, CONSUMABLE, REAGENT, RUNE, APPEARANCE_ONLY, MOUNT_REINS
   - `subcategory` - SWORD, STAFF, LIGHT_ARMOR, HEAVY_ARMOR, etc.
   - `usage_policy` - ENABLED, DISABLED, APPEARANCE_ONLY, VENDOR_TRASH, CONVERT_TO_RUNE
   - `notes` - Classification notes

3. **`mortal_npc_tags`** - NPC categorization
   - `entry` - creature_template.entry
   - `role` - TRADER, GUARD, BOSS, WEAK_MOB, MID_ELITE, WORLD_BOSS, PUBLIC_DUNGEON_ELITE
   - `faction_override` - LEDGER, SHRINE, CARTEL, RANGERS, NEUTRAL
   - `scaling_profile` - FRONTIER_ELITE, PUBLIC_DUNGEON, STRONGHOLD_DEFENDER
   - `notes` - Classification notes

4. **`mortal_conversion_stats`** - Progress tracking
   - `stat_key` - e.g., quests_classified, spells_classified
   - `stat_value` - Count of classified items
   - `last_updated` - Unix timestamp
   - `notes` - Additional metadata

---

## Classification Scripts ✅ **COMPLETE**

**Directory:** `tools/conversion_scripts/`

### Scripts Created:

1. **`classify_quests.py`** ✅
   - Classifies quests based on:
     - Zone/Area
     - Quest type (KILL, COLLECT, ESCORT, etc.)
     - Chain dependencies
     - Manual keystone list override
   - Outputs: SQL INSERT statements for `mortal_quest_conversion_map`
   - Features:
     - Heuristic-based classification
     - Keystone quest override support
     - Statistics tracking

2. **`classify_items.py`** ✅
   - Classifies items based on:
     - Quality (green/blue/epic)
     - Item level
     - Source (raid/dungeon/BoE)
   - Assigns Mortal tiers:
     - T5: Epic, ilvl 245+ (endgame raid)
     - T4: Epic, ilvl 200-244
     - T3: Rare, ilvl 200+ (heroic dungeons)
     - T2: Rare/Uncommon, ilvl 150-199 (normal dungeons)
     - T1: Uncommon/Common, ilvl < 150 (basic/crafted)
   - Outputs: SQL INSERT statements for `mortal_item_tags`

3. **`classify_npcs.py`** ✅
   - Classifies NPCs based on:
     - Rank (elite/boss)
     - Level
     - Type flags
     - Name patterns
   - Assigns roles and scaling profiles
   - Outputs: SQL INSERT statements for `mortal_npc_tags`

4. **`README.md`** ✅
   - Complete documentation
   - Usage instructions
   - Workflow guide
   - Script details

### Manual Override Files:
- `data/keystone_quests.txt` - Keystone quest IDs (force-tagged as STORY_REWRITE)
- `data/keystone_spells.txt` - Keystone spell IDs (for special handling)

---

## Features Summary

### Quest Classification
- ✅ Heuristic-based classification
- ✅ Keystone quest override support
- ✅ Conversion type assignment (STORY_REWRITE, CONTRACT_BOARD, CONTRACT_LOCAL, FLAVOR)
- ✅ Faction tagging support
- ✅ Statistics tracking

### Item Classification
- ✅ Tier assignment (T1-T5) based on quality and level
- ✅ Category assignment (WEAPON, ARMOR, TRINKET, etc.)
- ✅ Usage policy assignment (ENABLED, DISABLED, CONVERT_TO_RUNE, etc.)
- ✅ Mount reins detection
- ✅ Trinket conversion detection

### NPC Classification
- ✅ Role assignment (TRADER, GUARD, BOSS, etc.)
- ✅ Scaling profile assignment
- ✅ Faction override support
- ✅ World boss detection

### Statistics & Tracking
- ✅ Conversion statistics table
- ✅ Progress tracking per content type
- ✅ Last updated timestamps

---

## Status: ✅ **~85% COMPLETE**

### Completed:
- ✅ All tagging tables created
- ✅ Quest classification script complete
- ✅ Item classification script complete
- ✅ NPC classification script complete
- ✅ Documentation complete
- ✅ Manual override framework complete
- ✅ Statistics tracking complete

### Remaining (Content/Data Work):
- ⚠️ **Spell Classification Script** - Framework pattern exists, needs implementation
  - Would follow same pattern as other scripts
  - Requires spell.dbc or spell_template export
  
- ⚠️ **Patch Generation Scripts** - SQL generators for applying tags
  - `generate_quest_patches.sql` - Convert quests to contracts
  - `generate_spell_patches.sql` - Apply spell tags
  - `generate_item_patches.sql` - Apply item tags
  
- ⚠️ **Actual Data Classification** - Content work
  - Export raw data from database
  - Run classification scripts on real data
  - Review and iterate on classifications
  - Generate and apply patches

**Core framework is 100% complete. Remaining work is content/data classification and patch generation.**

---

## Usage Workflow

1. **Export Raw Data**
   ```bash
   mysql -u root -p world -e "SELECT * FROM quest_template" > tools/conversion_scripts/data/quests_raw.csv
   mysql -u root -p world -e "SELECT * FROM item_template" > tools/conversion_scripts/data/items_raw.csv
   mysql -u root -p world -e "SELECT * FROM creature_template" > tools/conversion_scripts/data/npcs_raw.csv
   ```

2. **Run Classification Scripts**
   ```bash
   cd tools/conversion_scripts
   python3 classify_quests.py
   python3 classify_items.py
   python3 classify_npcs.py
   ```

3. **Review and Edit**
   - Review generated SQL files
   - Edit keystone override files
   - Re-run scripts if needed

4. **Apply Tags**
   ```bash
   mysql -u root -p world < quest_tags.sql
   mysql -u root -p world < item_tags.sql
   mysql -u root -p world < npc_tags.sql
   ```

5. **Check Statistics**
   ```sql
   SELECT * FROM mortal_conversion_stats;
   ```

**Ready for content classification work!**

