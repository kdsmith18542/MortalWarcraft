# Reload Instructions for Mortal Warcraft Systems

## ✅ Completed Tasks

### 1. Sealed Courier Crate Item
- **Status:** ✅ Created (Entry 90002)
- **Database:** `azerothcore_world`
- **Script:** `sql/28_courier_contracts_item.sql` (already run)
- **Lua Updated:** `courier_contracts.lua` now uses entry 90002

### 2. Spawn Management System
- **Status:** ✅ Created
- **Database:** `azerothcore_world.mortal_custom_spawns` table created
- **Script:** `sql/30_spawn_helper.sql` (already run)
- **Lua:** `spawn_manager.lua` deployed (logs spawn requirements)

### 3. NPC Spawning Approach
**Best Approach:** Use in-game GM commands (`.npc add`) since the `creature` spawn table doesn't exist in this database structure.

**Alternative:** The `mortal_custom_spawns` table tracks spawn locations. A future C++ hook could auto-spawn from this table, but for now, manual spawning is required.

## 🔄 Reloading Eluna Scripts

### Option 1: Server Restart (Recommended)
```bash
# Stop worldserver
# Start worldserver
# Scripts will auto-reload on startup
```

### Option 2: Check for Eluna Reload Command
Eluna (mod-eluna) may support a reload command. Check in-game:
```
.reload eluna
.reload scripts
```

If these don't work, **server restart is required**.

## 📍 Manual NPC Spawning

### Mercenary Brokers (Entry 91000)

**Stormwind:**
```
.npc add 91000
# Then move to: -8861.0, 674.5, 97.9 (Zone 1519)
```

**Orgrimmar:**
```
.npc add 91000
# Then move to: 1596.5, -4379.2, 10.1 (Zone 1637)
```

**Booty Bay:**
```
.npc add 91000
# Then move to: -14464.4, 460.2, 16.3 (Zone 35)
```

### Market District Auctioneers
Standard auctioneers (entries 8670-8675, 9856, 15659, 15678) should already exist. If missing, spawn them at their respective locations.

## 📋 Files Deployed

### SQL Scripts (All Run Successfully)
- ✅ `sql/28_courier_contracts_item.sql` - Sealed Courier Crate item
- ✅ `sql/30_spawn_helper.sql` - Spawn management table

### Lua Scripts (Deployed to `azerothcore/bin/lua_scripts/`)
- ✅ `courier_contracts.lua` - Updated with item entry 90002
- ✅ `spawn_manager.lua` - Spawn tracking system

## 🎯 Next Steps

1. **Restart worldserver** to load new Lua scripts
2. **Spawn Mercenary Brokers** using `.npc add 91000` commands
3. **Test systems:**
   - Mercenary hire system
   - Courier contracts
   - Guard nerfs (598 guards updated to Level 55)

## 📝 Notes

- The `mortal_custom_spawns` table tracks spawn locations but doesn't auto-spawn (requires C++ support)
- All Lua scripts are in place and ready
- Database tables are created and populated
- Item templates are registered

