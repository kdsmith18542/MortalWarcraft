# Tools Enhanced with Reference Scripts

**Date:** 2025-01-23  
**Status:** ✅ Complete

---

## Summary

All research and investigation tools have been enhanced to automatically search the new reference script repositories (TrinityCore and CMaNGOS) for NPC IDs, script patterns, and dungeon information.

---

## Enhanced Tools

### 1. `find_dbc_ids.py`

**New Features:**
- ✅ Searches TrinityCore scripts for NPC IDs by name
- ✅ Searches CMaNGOS ScriptDevAI for NPC IDs by name
- ✅ New `--npc-id` option to search by ID
- ✅ New `--no-reference` flag to skip reference searches
- ✅ Automatic fallback: DBC → Database → Reference Scripts

**Usage Examples:**
```bash
# Search for NPC by name (searches all sources)
python3 find_dbc_ids.py --type creature --name "Brandon"

# Search for NPC by ID in reference scripts
python3 find_dbc_ids.py --npc-id 31023

# Skip reference scripts (DBC/database only)
python3 find_dbc_ids.py --type creature --name "Brandon" --no-reference
```

**Output Format:**
```
Found 2 NPC IDs in reference scripts matching 'Brandon':
  NPC_CAPTAIN_BRANDON = 37123 (from TrinityCore, Northrend/IcecrownCitadel/icecrown_citadel.h)
  NPC_CAPTAIN_BRANDON_UNDEAD = 37493 (from TrinityCore, Northrend/IcecrownCitadel/icecrown_citadel.h)
```

---

### 2. `investigate_issues.py`

**New Features:**
- ✅ Searches reference scripts for dungeon-related files
- ✅ Searches reference scripts for NPC IDs mentioned in issues
- ✅ Shows which reference scripts contain relevant code

**Usage Examples:**
```bash
# Investigate Culling of Stratholme issue
python3 investigate_issues.py --issue 23830 --db-name realm2_world
```

**New Output Sections:**
```
5. Reference Scripts:
   Found Culling of Stratholme scripts:
     TrinityCore:
       - Kalimdor/CavernsOfTime/CullingOfStratholme/culling_of_stratholme.h
       - Kalimdor/CavernsOfTime/CullingOfStratholme/instance_culling_of_stratholme.cpp
     CMaNGOS:
       - kalimdor/caverns_of_time/culling_of_stratholme/culling_of_stratholme.h
       - kalimdor/caverns_of_time/culling_of_stratholme/instance_culling_of_stratholme.cpp

7. Searching Reference Scripts for Wave NPCs:
     Risen Zombie (ID 27737):
       - NPC_ZOMBIE = 27737 (from CMaNGOS)
```

---

## Reference Script Locations

**TrinityCore Scripts:**
- Path: `tools/reference/trinitycore-scripts/src/server/scripts/`
- Type: ScriptedAI (AzerothCore-compatible)
- Use: Script patterns, compatible implementations

**CMaNGOS ScriptDevAI:**
- Path: `tools/reference/cmangos-wotlk/src/game/AI/ScriptDevAI/scripts/`
- Type: ScriptDevAI (CMaNGOS framework)
- Use: Complete NPC ID definitions, historical reference

---

## Benefits

1. **Faster Research** - No need to manually search reference repos
2. **More Complete** - Searches both TrinityCore and CMaNGOS automatically
3. **Better Results** - Finds NPC IDs that might not be in DBC/database
4. **Integrated** - Works seamlessly with existing DBC/database searches
5. **Fallback** - Tools work even if reference scripts are missing

---

## Implementation Details

### Search Functions

**`search_reference_scripts_npc(search_term)`**
- Searches both TrinityCore and CMaNGOS for NPC definitions
- Uses regex to find `NPC_NAME = ID` patterns
- Returns results with source and file location

**`search_reference_scripts_by_id(npc_id)`**
- Searches for specific NPC ID in reference scripts
- Returns all matches with NPC name and source

**`search_reference_scripts_by_dungeon(dungeon_name)`**
- Finds all scripts related to a dungeon
- Returns file paths from both sources

---

## Testing

✅ Tested with:
- NPC name search: "Brandon", "Patricia", "Stephanie"
- NPC ID search: 31023
- Dungeon search: "culling"
- Issue investigation: #23830

---

## Future Enhancements

Potential improvements:
1. Cache search results for faster repeated searches
2. Search for spell IDs in reference scripts
3. Search for gameobject IDs in reference scripts
4. Extract script patterns (not just IDs)
5. Compare implementations between TrinityCore and CMaNGOS

---

**Last Updated:** 2025-01-23

