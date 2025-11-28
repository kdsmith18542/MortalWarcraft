# Using Feature Inventory for DBC ID Probing

## Purpose

This guide explains how to use the populated WoW 3.3.5a feature inventory (`wow-3.3.5a-feature-inventory-populated.md`) with the DBC ID finder script (`tools/find_dbc_ids.py`) to find IDs, models, and display IDs for implementation.

---

## Overview

The feature inventory contains feature names gathered from web research. These names can be used with the DBC ID finder to locate:
- Zone IDs (Map.dbc, AreaTable.dbc)
- Dungeon/Instance IDs (Map.dbc, DungeonMap.dbc)
- Creature IDs (CreatureDisplayInfo.dbc)
- Item IDs (ItemDisplayInfo.dbc, Item.dbc)
- GameObject IDs (GameObjectDisplayInfo.dbc)
- Spell IDs (Spell.dbc)
- NPC IDs (creature_template table)

---

## DBC ID Finder Script

**Location**: `tools/find_dbc_ids.py`

**Current Capabilities**:
- Searches `CreatureDisplayInfo.dbc` for creature display IDs
- Searches `ItemDisplayInfo.dbc` for item display IDs
- Lists common IDs

**DBC Path**: `azerothcore/data/dbc/`

---

## Usage Workflow

### Step 1: Extract Feature Names from Inventory

From `wow-3.3.5a-feature-inventory-populated.md`, extract feature names:

**Zones Example:**
- "Elwynn Forest"
- "Stranglethorn Vale"
- "Icecrown"

**Dungeons Example:**
- "Deadmines"
- "Wailing Caverns"
- "Icecrown Citadel"

**Creatures/NPCs Example:**
- "Lord Kazzak"
- "Azuregos"
- "Human Male"

**Items Example:**
- "Sword"
- "Plate Chest"
- "Heroes' Earthshatter"

### Step 2: Use DBC ID Finder

```bash
# For creatures
python3 tools/find_dbc_ids.py --type creature --name "Human Male"

# For items
python3 tools/find_dbc_ids.py --type item --name "Sword"

# For gameobjects
python3 tools/find_dbc_ids.py --type gameobject --name "Anvil"

# List common IDs
python3 tools/find_dbc_ids.py --type creature --list-common
python3 tools/find_dbc_ids.py --type item --list-common
```

### Step 3: Query Database for Additional IDs

For zones, dungeons, NPCs, and other features, query the database:

```sql
-- Find zone IDs
SELECT entry, name FROM area_table WHERE name LIKE '%Elwynn%';

-- Find dungeon/instance IDs
SELECT id, name FROM map WHERE name LIKE '%Deadmines%';

-- Find creature IDs
SELECT entry, name FROM creature_template WHERE name LIKE '%Kazzak%';

-- Find item IDs
SELECT entry, name FROM item_template WHERE name LIKE '%Sword%';
```

---

## Feature-to-DBC Mapping Guide

### Zones

**DBC Files:**
- `Map.dbc` - Map definitions
- `AreaTable.dbc` - Zone/area definitions
- `WorldMapArea.dbc` - World map data

**Database Tables:**
- `area_table` - Zone definitions
- `map` - Map definitions

**Example Queries:**
```sql
-- Get zone ID for "Stranglethorn Vale"
SELECT entry, name, mapid FROM area_table WHERE name = 'Stranglethorn Vale';

-- Get all zones in Eastern Kingdoms (mapid = 0)
SELECT entry, name FROM area_table WHERE mapid = 0;
```

**Script Enhancement Needed:**
```python
# Add to find_dbc_ids.py
def search_area_table(search_term):
    """Search AreaTable.dbc for zone IDs."""
    # Implementation needed
    pass
```

### Dungeons & Instances

**DBC Files:**
- `Map.dbc` - Instance map definitions
- `DungeonMap.dbc` - Dungeon mappings

**Database Tables:**
- `instance_template` - Instance definitions
- `map` - Map definitions

**Example Queries:**
```sql
-- Get instance ID for "Deadmines"
SELECT id, name, parent FROM map WHERE name LIKE '%Deadmines%';

-- Get all 5-man dungeons
SELECT id, name FROM map WHERE type = 1; -- Type 1 = Dungeon
```

**Script Enhancement Needed:**
```python
# Add to find_dbc_ids.py
def search_map_dbc(search_term):
    """Search Map.dbc for instance IDs."""
    # Implementation needed
    pass
```

### Creatures & NPCs

**DBC Files:**
- `CreatureDisplayInfo.dbc` - Creature display IDs
- `CreatureModelData.dbc` - Creature model data

**Database Tables:**
- `creature_template` - Creature definitions

**Current Script Support:**
```bash
python3 tools/find_dbc_ids.py --type creature --name "Human"
```

**Example Database Query:**
```sql
-- Find creature ID for "Lord Kazzak"
SELECT entry, name, modelid1, modelid2, modelid3, modelid4 
FROM creature_template 
WHERE name LIKE '%Kazzak%';
```

### Items

**DBC Files:**
- `ItemDisplayInfo.dbc` - Item display IDs
- `Item.dbc` - Item definitions

**Database Tables:**
- `item_template` - Item definitions

**Current Script Support:**
```bash
python3 tools/find_dbc_ids.py --type item --name "Sword"
```

**Example Database Query:**
```sql
-- Find item ID for "Heroes' Earthshatter Chest"
SELECT entry, name, displayid, Quality, ItemLevel 
FROM item_template 
WHERE name LIKE '%Heroes%Earthshatter%';
```

### GameObjects

**DBC Files:**
- `GameObjectDisplayInfo.dbc` - GameObject display IDs

**Database Tables:**
- `gameobject_template` - GameObject definitions

**Script Enhancement Needed:**
```python
# Add to find_dbc_ids.py
def search_gameobject_display_info(search_term):
    """Search GameObjectDisplayInfo.dbc for display IDs."""
    # Implementation needed
    pass
```

**Example Database Query:**
```sql
-- Find GameObject ID for "Anvil"
SELECT entry, name, displayId 
FROM gameobject_template 
WHERE name LIKE '%Anvil%';
```

### Spells

**DBC Files:**
- `Spell.dbc` - Spell definitions

**Database Tables:**
- `spell_template` - Spell definitions

**Example Database Query:**
```sql
-- Find spell ID for "Fireball"
SELECT Id, Name 
FROM spell_template 
WHERE Name LIKE '%Fireball%';
```

---

## Recommended Script Enhancements

### 1. Add Zone/Area Search

```python
def search_area_table(search_term=""):
    """Search AreaTable.dbc for zone IDs."""
    dbc_file = DBC_PATH / "AreaTable.dbc"
    # Implementation
    pass
```

### 2. Add Map/Instance Search

```python
def search_map_dbc(search_term=""):
    """Search Map.dbc for instance/map IDs."""
    dbc_file = DBC_PATH / "Map.dbc"
    # Implementation
    pass
```

### 3. Add GameObject Search

```python
def search_gameobject_display_info(search_term=""):
    """Search GameObjectDisplayInfo.dbc for display IDs."""
    dbc_file = DBC_PATH / "GameObjectDisplayInfo.dbc"
    # Implementation
    pass
```

### 4. Add Database Query Support

```python
def query_database(table, search_term, search_field="name"):
    """Query database tables for IDs."""
    # Connect to database
    # Query table
    # Return results
    pass
```

### 5. Add Batch Processing

```python
def process_feature_inventory(inventory_file):
    """Process feature inventory and find all IDs."""
    # Read inventory file
    # For each feature, find IDs
    # Output results
    pass
```

---

## Example Workflow: Finding Zone IDs

### From Feature Inventory

**Source**: `wow-3.3.5a-feature-inventory-populated.md`

**Zones to Find:**
- Elwynn Forest
- Stranglethorn Vale
- Icecrown
- Borean Tundra

### Step 1: Query Database

```sql
-- Find zone IDs
SELECT entry, name, mapid 
FROM area_table 
WHERE name IN ('Elwynn Forest', 'Stranglethorn Vale', 'Icecrown', 'Borean Tundra');
```

### Step 2: Query DBC Files (if script enhanced)

```bash
# If zone search is added to script
python3 tools/find_dbc_ids.py --type zone --name "Elwynn Forest"
```

### Step 3: Document Results

Update feature inventory with found IDs:

```markdown
| Zone | Original Type | Zone ID | Map ID | Mortal Risk Tier | Notes |
|------|---------------|---------|--------|------------------|-------|
| Elwynn Forest | Alliance Starting | 12 | 0 | Green | Safe starting zone |
| Stranglethorn Vale | Contested | 33 | 0 | Red | Full-loot PvP zone |
```

---

## Example Workflow: Finding Dungeon IDs

### From Feature Inventory

**Dungeons to Find:**
- Deadmines
- Wailing Caverns
- Icecrown Citadel

### Step 1: Query Database

```sql
-- Find instance IDs
SELECT id, name, type, parent 
FROM map 
WHERE name IN ('Deadmines', 'Wailing Caverns', 'Icecrown Citadel');
```

### Step 2: Document Results

Update feature inventory:

```markdown
| Dungeon | Original Level | Instance ID | Mortal Tier | Overhaul Status | Notes |
|---------|----------------|--------------|-------------|-----------------|-------|
| Deadmines | 10-20 | 36 | M-T1 | ⏳ Pending | Convert to public dungeon |
| Wailing Caverns | 15-25 | 43 | M-T1 | ⏳ Pending | Convert to public dungeon |
```

---

## Example Workflow: Finding Creature IDs

### From Feature Inventory

**Creatures to Find:**
- Lord Kazzak
- Azuregos
- The Lich King

### Step 1: Use Script

```bash
# Search for creature display IDs (if name matches)
python3 tools/find_dbc_ids.py --type creature --name "Kazzak"
```

### Step 2: Query Database

```sql
-- Find creature IDs
SELECT entry, name, modelid1, displayid 
FROM creature_template 
WHERE name LIKE '%Kazzak%' OR name LIKE '%Azuregos%' OR name LIKE '%Lich King%';
```

### Step 3: Document Results

Update feature inventory:

```markdown
| Boss | Original Location | Creature ID | Display ID | Mortal Status | Notes |
|------|-------------------|-------------|------------|---------------|-------|
| Lord Kazzak | Blasted Lands | 18728 | 14544 | World Boss | Rebalance for skill system |
```

---

## Batch Processing Script Idea

Create a script to process the entire feature inventory:

```python
#!/usr/bin/env python3
"""
Process feature inventory and find all DBC IDs.
"""
import json
import re
from pathlib import Path

def process_inventory_file(inventory_file):
    """Read feature inventory and extract feature names."""
    features = {
        'zones': [],
        'dungeons': [],
        'raids': [],
        'creatures': [],
        'items': [],
        'gameobjects': []
    }
    
    # Parse markdown file
    # Extract feature names from tables
    # Return structured data
    
    return features

def find_ids_for_features(features):
    """Find IDs for all features."""
    results = {}
    
    # For each feature type:
    # - Query database
    # - Query DBC files
    # - Store results
    
    return results

def main():
    inventory_file = Path("docs/wow-3.3.5a-feature-inventory-populated.md")
    features = process_inventory_file(inventory_file)
    ids = find_ids_for_features(features)
    
    # Output results
    print(json.dumps(ids, indent=2))

if __name__ == '__main__':
    main()
```

---

## Integration with Feature Inventory

### Update Inventory Format

Add ID columns to inventory tables:

```markdown
| Zone | Zone ID | Map ID | Original Type | Mortal Risk Tier | Status |
|------|---------|--------|---------------|------------------|--------|
| Elwynn Forest | 12 | 0 | Alliance Starting | Green | ⏳ Pending |
```

### Create ID Mapping File

Create `docs/wow-3.3.5a-feature-ids-mapping.md`:

```markdown
# WoW 3.3.5a Feature ID Mapping

## Zones
| Zone Name | Zone ID | Map ID | Area ID |
|-----------|---------|--------|---------|
| Elwynn Forest | 12 | 0 | 12 |

## Dungeons
| Dungeon Name | Instance ID | Map ID |
|--------------|-------------|--------|
| Deadmines | 36 | 0 |

## Creatures
| Creature Name | Creature ID | Display ID |
|---------------|-------------|------------|
| Lord Kazzak | 18728 | 14544 |
```

---

## Next Steps

1. **Enhance DBC ID Finder Script**
   - Add zone/area search
   - Add map/instance search
   - Add gameobject search
   - Add database query support
   - Add batch processing

2. **Process Feature Inventory**
   - Extract all feature names
   - Run ID finder for each feature
   - Document results

3. **Create ID Mapping Document**
   - Map all features to IDs
   - Use for implementation reference

4. **Update Feature Inventory**
   - Add ID columns to tables
   - Mark features with found IDs

---

## Helper Script: Process Inventory

**New Script**: `tools/find_ids_from_inventory.py`

This script extracts feature names from the populated inventory and processes them:

```bash
# List all zones from inventory
python3 tools/find_ids_from_inventory.py --category zones --list

# List all dungeons from inventory
python3 tools/find_ids_from_inventory.py --category dungeons --list

# Search for specific creature
python3 tools/find_ids_from_inventory.py --category creatures --name "Kazzak"

# Process all world bosses
python3 tools/find_ids_from_inventory.py --category world-bosses --output boss_ids.json
```

---

## Related Files

- `tools/find_dbc_ids.py` - DBC ID finder script
- `tools/find_ids_from_inventory.py` - Helper script to process inventory
- `docs/wow-3.3.5a-feature-inventory-populated.md` - Populated feature inventory
- `docs/wow-3.3.5a-to-mortal-spec-mapping.md` - Feature-to-spec mapping
- `tools/query_item_displayids.py` - Item display ID query tool

