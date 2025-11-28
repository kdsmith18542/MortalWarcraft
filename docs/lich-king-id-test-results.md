# Lich King Boss ID Test Results

## Test Objective

Find the model ID and display ID for the Lich King boss from Icecrown Citadel raid using the feature inventory and DBC ID finder.

---

## Results

### Creature Entry ID
**Found**: `36597` (The Lich King)

**Source**: 
- AzerothCore source code: `NPC_THE_LICH_KING = 36597`
- File: `azerothcore/src/server/scripts/Northrend/IcecrownCitadel/icecrown_citadel.h`

### DBC Finder Script Test

**Command Used**:
```bash
python3 tools/find_dbc_ids.py --type creature --name "Lich King"
```

**Result**: 
- Script executed successfully
- Returned 20 creature display IDs (first 1000 records scanned)
- Note: Current script doesn't search by name in string data, only returns first records

**Limitation**: The current DBC finder script doesn't search string fields in DBC files, so it returns generic results rather than the specific Lich King model.

---

## Database Query (Recommended Method)

To get the actual model/display IDs, query the database:

```sql
-- Query Lich King creature template
SELECT 
    entry,
    name,
    modelid1,
    modelid2,
    modelid3,
    modelid4,
    displayid1,
    displayid2,
    displayid3,
    displayid4
FROM creature_template
WHERE entry = 36597;
```

**Expected Results**:
- Entry: 36597
- Name: "The Lich King"
- Model IDs: (will show actual model IDs)
- Display IDs: (will show actual display IDs)

---

## Alternative: Direct SQL Query Tool

Created new tool: `tools/query_creature_ids.py`

**Usage**:
```bash
# Query by entry ID
python3 tools/query_creature_ids.py --entry 36597

# Query by name
python3 tools/query_creature_ids.py --name "Lich King"

# Output as SQL
python3 tools/query_creature_ids.py --entry 36597 --format sql
```

**Note**: Requires `mysql-connector-python`:
```bash
pip install mysql-connector-python
```

---

## Using Feature Inventory

**From Inventory**: `wow-3.3.5a-feature-inventory-populated.md`

**Feature Name**: "The Lich King" (under WotLK Raids → Icecrown Citadel)

**Workflow**:
1. Extract name from inventory: "The Lich King"
2. Use database query tool: `python3 tools/query_creature_ids.py --name "Lich King"`
3. Or query directly: `SELECT * FROM creature_template WHERE name LIKE '%Lich King%'`

---

## Recommended DBC Finder Enhancements

The current `find_dbc_ids.py` script should be enhanced to:

1. **Search String Fields**: Parse DBC string blocks to search by name
2. **Database Integration**: Query `creature_template` for entry IDs, then look up display IDs in DBC
3. **Better Name Matching**: Use fuzzy matching or partial string search

**Example Enhancement**:
```python
def search_creature_by_name(search_term):
    """Search creature_template database, then find display IDs in DBC."""
    # 1. Query database for creature entry
    # 2. Get display IDs from creature_template
    # 3. Look up model IDs in CreatureDisplayInfo.dbc
    pass
```

---

## Next Steps

1. **Install Database Connector** (if needed):
   ```bash
   pip install mysql-connector-python
   ```

2. **Query Database**:
   ```bash
   python3 tools/query_creature_ids.py --entry 36597
   ```

3. **Document Results**: Update feature inventory with found IDs

4. **Enhance DBC Finder**: Add database integration for better name-based searches

---

## Summary

✅ **Creature Entry ID Found**: 36597 (from source code)  
⚠️ **Model/Display IDs**: Need database query (DBC finder doesn't search strings yet)  
✅ **Tool Created**: `query_creature_ids.py` for database queries  
✅ **Workflow Established**: Feature inventory → Name extraction → Database query → ID mapping

## How to Get Model/Display IDs

### Option 1: Direct SQL Query
```sql
SELECT entry, name, modelid1, modelid2, modelid3, modelid4, 
       displayid1, displayid2, displayid3, displayid4
FROM creature_template
WHERE entry = 36597;
```

### Option 2: Use Query Tool (after installing mysql-connector-python)
```bash
pip install mysql-connector-python
python3 tools/query_creature_ids.py --entry 36597
```

### Option 3: Check DBC Files Directly
If you have CreatureDisplayInfo.dbc extracted:
- Look up display ID from creature_template
- Find corresponding model ID in CreatureDisplayInfo.dbc

---

## Test Conclusion

✅ **Feature Inventory Works**: Names from inventory can be used for queries  
✅ **Creature ID Found**: 36597 confirmed from source code  
✅ **Display ID Found**: 30721 (from database query)  
✅ **Tools Created**: Database query tool ready to use  
✅ **Package Installed**: mysql-connector-python installed in virtual environment  
✅ **Database Query Successful**: Script successfully queries creature_template_model table

The feature inventory provides the names, and the database query tools can find the IDs. The DBC finder script works for direct ID lookups but needs enhancement for name-based searches.

---

## Final Test Results (Success!)

### Database Query Results

**Command**:
```bash
tools/venv/bin/python3 tools/query_creature_ids.py --entry 36597
```

**Results**:
- **Entry**: 36597
- **Name**: The Lich King
- **Display ID**: 30721
- **Level**: 83
- **Faction**: 974

**Note**: The script automatically detects whether the database uses the old structure (modelid columns in creature_template) or the new structure (creature_template_model table) and queries accordingly.

### Search by Name Results

**Command**:
```bash
tools/venv/bin/python3 tools/query_creature_ids.py --name "Lich King"
```

**Results**: Found 42 creatures matching "Lich King", including:
- Entry 36597: The Lich King (Display ID: 30721) - Main ICC boss
- Entry 16980: The Lich King (Display ID: 11686) - Level 60 version
- Entry 24248: The Lich King (Display ID: 25337) - Level 83 variant
- And 39 other variants/related creatures

**Conclusion**: The tool successfully retrieves creature IDs, display IDs, and related information from the database. The Lich King boss from ICC has Display ID **30721**.

