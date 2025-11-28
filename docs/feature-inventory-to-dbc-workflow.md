# Feature Inventory to DBC ID Workflow

## Purpose

This document outlines the complete workflow for using the populated feature inventory to find DBC IDs, model IDs, and display IDs for implementation.

---

## Workflow Overview

```
Feature Inventory (Names) 
    ↓
Extract Feature Names
    ↓
Query Database / DBC Files
    ↓
Get IDs (Entry, Model, Display)
    ↓
Document in Inventory
    ↓
Use for Implementation
```

---

## Step-by-Step Process

### Step 1: Extract Feature Names from Inventory

**Source**: `docs/wow-3.3.5a-feature-inventory-populated.md`

**Example - Lich King Boss**:
- Category: WotLK Raids → Icecrown Citadel
- Feature Name: "The Lich King"

### Step 2: Choose Query Method

#### Method A: Database Query (Recommended)

**For Creatures/NPCs**:
```bash
python3 tools/query_creature_ids.py --name "Lich King"
# or
python3 tools/query_creature_ids.py --entry 36597
```

**For Items**:
```bash
python3 tools/query_item_displayids.py --name "Sword"
```

**For Zones**:
```sql
SELECT entry, name, mapid FROM area_table WHERE name LIKE '%Elwynn%';
```

**For Dungeons/Instances**:
```sql
SELECT id, name, type FROM map WHERE name LIKE '%Deadmines%';
```

#### Method B: DBC File Search (Limited)

**Current Capabilities**:
```bash
# Returns first 20 records (doesn't search by name yet)
python3 tools/find_dbc_ids.py --type creature --name "Lich King"
python3 tools/find_dbc_ids.py --type item --name "Sword"
```

**Limitation**: Current script doesn't search string fields, only returns first records.

### Step 3: Document Results

Update feature inventory with found IDs:

```markdown
| Boss | Original Location | Creature ID | Display ID | Model ID | Mortal Status | Notes |
|------|-------------------|-------------|------------|----------|---------------|-------|
| The Lich King | Icecrown Citadel | 36597 | [found] | [found] | World Boss | Rebalance for skill system |
```

---

## Example: Finding Lich King IDs

### Input
- **Feature Name**: "The Lich King" (from feature inventory)
- **Category**: WotLK Raids → Icecrown Citadel

### Process

1. **Extract Name**: "The Lich King"

2. **Query Database**:
   ```bash
   python3 tools/query_creature_ids.py --name "Lich King"
   ```
   
   Or direct SQL:
   ```sql
   SELECT entry, name, modelid1, displayid1 
   FROM creature_template 
   WHERE name LIKE '%Lich King%';
   ```

3. **Expected Output**:
   ```
   Entry: 36597
   Name: The Lich King
   Model ID: [value]
   Display ID: [value]
   ```

4. **Document in Inventory**:
   - Update `wow-3.3.5a-feature-inventory-populated.md`
   - Add IDs to appropriate table

---

## Tools Available

### 1. `tools/find_dbc_ids.py`
- **Purpose**: Search DBC files for display/model IDs
- **Current**: Returns first records (needs enhancement for name search)
- **Best For**: Direct ID lookups when you know the ID

### 2. `tools/query_creature_ids.py` (NEW)
- **Purpose**: Query creature_template database
- **Features**: Search by name or entry ID
- **Best For**: Finding creature IDs from feature names

### 3. `tools/query_item_displayids.py`
- **Purpose**: Query item_template database
- **Features**: Search by name, entry, tier, slot
- **Best For**: Finding item IDs from feature names

### 4. `tools/find_ids_from_inventory.py` (NEW)
- **Purpose**: Extract names from inventory and process them
- **Features**: Batch processing, category filtering
- **Best For**: Processing multiple features at once

---

## Recommended Enhancements

### 1. Enhance DBC Finder Script

Add database integration to `find_dbc_ids.py`:

```python
def search_creature_by_name(search_term):
    """Search creature_template, then find display IDs in DBC."""
    # 1. Query database for creature entry
    # 2. Get display IDs from creature_template
    # 3. Look up model IDs in CreatureDisplayInfo.dbc
    pass
```

### 2. Add Zone/Instance Search

```python
def search_zones_by_name(search_term):
    """Search area_table for zone IDs."""
    # Query area_table database
    pass

def search_instances_by_name(search_term):
    """Search map table for instance IDs."""
    # Query map database
    pass
```

### 3. Batch Processing

```python
def process_inventory_batch(inventory_file, category):
    """Process all features in a category."""
    # Extract all names
    # Query database for each
    # Output results
    pass
```

---

## Quick Reference

### Finding Creature IDs
```bash
# By name
python3 tools/query_creature_ids.py --name "Lich King"

# By entry
python3 tools/query_creature_ids.py --entry 36597
```

### Finding Item IDs
```bash
python3 tools/query_item_displayids.py --name "Sword"
```

### Finding Zone IDs
```sql
SELECT entry, name FROM area_table WHERE name LIKE '%Elwynn%';
```

### Finding Instance IDs
```sql
SELECT id, name FROM map WHERE name LIKE '%Deadmines%';
```

### Processing Inventory
```bash
# List all zones
python3 tools/find_ids_from_inventory.py --category zones --list

# Process all world bosses
python3 tools/find_ids_from_inventory.py --category world-bosses --output boss_ids.json
```

---

## Next Steps

1. **Install Dependencies** (if needed):
   ```bash
   pip install mysql-connector-python
   ```

2. **Test Database Connection**:
   ```bash
   python3 tools/query_creature_ids.py --entry 36597
   ```

3. **Process Feature Inventory**:
   - Extract feature names
   - Query for IDs
   - Document results

4. **Enhance Tools** (optional):
   - Add database integration to DBC finder
   - Add batch processing
   - Add zone/instance search

---

## Related Files

- `docs/wow-3.3.5a-feature-inventory-populated.md` - Populated feature inventory
- `tools/find_dbc_ids.py` - DBC ID finder script
- `tools/query_creature_ids.py` - Creature database query tool
- `tools/query_item_displayids.py` - Item database query tool
- `tools/find_ids_from_inventory.py` - Inventory processing helper
- `docs/using-feature-inventory-for-dbc-probing.md` - Detailed probing guide

