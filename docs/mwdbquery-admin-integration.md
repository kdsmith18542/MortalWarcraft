# MWDBQuery Admin Tools Integration Guide

## Overview

The `mwdbquery.py` tool provides comprehensive database querying capabilities that can be integrated with the Mortal Warcraft admin tools addon (AIO-based Mortal Control Panel) to give GMs quick access to design data.

## Use Cases

### 1. Event Template Creation
When GMs create event templates (spec 42), they need to:
- Find creature entry IDs and display IDs for spawns
- Verify creature stats (HP, damage modifiers) for balancing
- Look up item IDs for rewards

**Integration**: Add a "Database Lookup" tab in the GM panel that queries creatures/items by name.

### 2. NPC Spawning Tools
When GMs spawn test NPCs or event mobs, they need:
- Display IDs for visual verification
- Stats for balancing checks
- Faction IDs for proper behavior

**Integration**: Enhance the "Tools" tab in MCP with a creature/item lookup that shows all design-relevant data.

### 3. Quest & Content Creation
When creating custom quests or content:
- Find quest IDs and requirements
- Look up item stats for rewards
- Verify creature data for objectives

**Integration**: Add quest/item lookup in the admin panel.

## Integration Options

### Option 1: Lua Wrapper (Recommended)
Create a Lua module that calls the Python script via system command:

```lua
-- lua/mwdbquery_wrapper.lua
local function QueryDatabase(queryType, params)
    local cmd = string.format(
        "tools/venv/bin/python3 tools/mwdbquery.py %s --name \"%s\" --format json",
        queryType, params.name
    )
    local handle = io.popen(cmd)
    local result = handle:read("*a")
    handle:close()
    return json.decode(result)
end

-- Expose to AIO
AIO.AddHandlers("MWDBQuery", {
    QueryCreature = function(player, name)
        if not player:IsGM() then return end
        local results = QueryDatabase("creature", {name = name})
        return results
    end,
    QueryItem = function(player, name)
        if not player:IsGM() then return end
        local results = QueryDatabase("item", {name = name})
        return results
    end,
    QueryQuest = function(player, name)
        if not player:IsGM() then return end
        local results = QueryDatabase("quest", {name = name})
        return results
    end
})
```

### Option 2: Direct Database Access (Better Performance)
Instead of calling Python, create Lua functions that query the database directly:

```lua
-- lua/mwdbquery_lua.lua
local function QueryCreatureByName(player, name)
    if not player:IsGM() then return {} end
    
    local query = string.format(
        "SELECT entry, name, displayid, minlevel, maxlevel, faction, rank, " ..
        "HealthModifier, DamageModifier, BaseAttackTime " ..
        "FROM creature_template " ..
        "WHERE name LIKE '%%%s%%' LIMIT 20",
        name
    )
    
    local results = {}
    local result = WorldDBQuery(query)
    while result do
        table.insert(results, {
            entry = result:GetUInt32(0),
            name = result:GetString(1),
            displayid = result:GetUInt32(2),
            minlevel = result:GetUInt32(3),
            maxlevel = result:GetUInt32(4),
            faction = result:GetUInt32(5),
            rank = result:GetUInt32(6),
            healthModifier = result:GetFloat(7),
            damageModifier = result:GetFloat(8),
            baseAttackTime = result:GetUInt32(9)
        })
        result = result:NextRow()
    end
    
    return results
end
```

### Option 3: REST API Bridge (For Web Portal)
If using the Mortal Atlas web portal, create a simple REST API that wraps `mwdbquery.py`:

```python
# tools/mwdbquery_api.py (Flask/FastAPI)
from flask import Flask, jsonify, request
import subprocess
import json

app = Flask(__name__)

@app.route('/api/query/creature', methods=['GET'])
def query_creature():
    name = request.args.get('name')
    entry = request.args.get('entry')
    full = request.args.get('full', 'false') == 'true'
    
    cmd = ['tools/venv/bin/python3', 'tools/mwdbquery.py', 'creature']
    if entry:
        cmd.extend(['--entry', entry])
    if name:
        cmd.extend(['--name', name])
    if full:
        cmd.append('--full')
    cmd.extend(['--format', 'json'])
    
    result = subprocess.run(cmd, capture_output=True, text=True)
    return jsonify(json.loads(result.stdout))
```

## Recommended Implementation

**Phase 1: Lua Direct Queries** (Fastest, no external dependencies)
- Add database query functions directly in Lua
- Expose via AIO handlers
- Add UI in Mortal Control Panel

**Phase 2: Enhanced Features** (If needed)
- Use Python script for complex queries or exports
- Add CSV/JSON export capabilities
- Integration with event template system

## UI Integration Points

### Mortal Control Panel (MCP) - New Tab: "Database Lookup"

**Tab Structure:**
1. **Creature Lookup**
   - Search by name or entry ID
   - Display: Entry, Name, Display IDs, Level, Faction, Rank
   - With "Full Stats" toggle: HealthModifier, DamageModifier, speeds, etc.
   - Action buttons: "Copy Entry ID", "Use for Event Template"

2. **Item Lookup**
   - Search by name, entry, tier, armor type, slot
   - Display: Entry, Display ID, Quality, Item Level, Stats, Sockets
   - With "Full Stats" toggle: All stats, sockets, spells, flags
   - Action buttons: "Copy Entry ID", "View in Item Template"

3. **Quest Lookup**
   - Search by title or entry ID
   - Display: Entry, Level, Title, Objectives, Rewards
   - Action buttons: "Copy Entry ID", "View Requirements"

### Integration with Event Templates

When creating event templates (spec 42), the lookup tool can:
- Auto-fill creature_entry from search results
- Validate display IDs exist
- Show stats for balancing
- Copy JSON config snippets

## Example Usage in Admin Panel

```lua
-- In admin_panel.lua, add to Tools tab
local function ShowDatabaseLookup(player)
    local frame = CreateFrame("Frame", "MWDBQueryFrame", UIParent)
    -- ... UI code ...
    
    -- Search button handler
    local function OnSearchClick()
        local searchType = dropdown:GetValue() -- "creature", "item", "quest"
        local searchValue = editbox:GetText()
        
        AIO.Handle("MWDBQuery", "Query" .. searchType, player, searchValue, function(results)
            -- Display results in scrollable list
            DisplayResults(results)
        end)
    end
end
```

## Security Considerations

- Only GMs with appropriate permissions can access
- Queries should be rate-limited to prevent abuse
- Sensitive data (like exact spawn locations) should be filtered
- All queries should be logged in `mortal_gm_action_log`

## Files to Create/Modify

1. **New Files:**
   - `lua/mwdbquery_lua.lua` - Direct database query functions
   - `lua/admin_panel_db_lookup.lua` - UI handlers for database lookup tab

2. **Modify:**
   - `lua/admin_panel.lua` - Add "Database Lookup" tab
   - `docs/specs/14-admin-tools.md` - Document new feature

3. **Optional:**
   - `tools/mwdbquery_api.py` - REST API wrapper (if web portal integration needed)

## Benefits

1. **Faster Content Creation**: GMs can quickly find IDs without leaving game
2. **Better Balancing**: Full stats visible when creating events
3. **Reduced Errors**: Copy-paste IDs instead of manual entry
4. **Design Reference**: All design-relevant data in one place
5. **Event Template Integration**: Seamless workflow for event creation

## Next Steps

1. Implement Lua database query functions
2. Add "Database Lookup" tab to MCP
3. Integrate with event template creation workflow
4. Add copy-to-clipboard functionality for IDs
5. Test with GM team for usability

