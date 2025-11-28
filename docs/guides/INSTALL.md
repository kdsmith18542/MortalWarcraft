# Installation Guide

## Prerequisites

- AzerothCore with Eluna support compiled
- MySQL database access
- CMake 3.10 or higher

## Installation Steps

### 1. Copy Module to AzerothCore

```bash
cp -r mortal_overhaul /path/to/azerothcore/modules/
```

### 2. Update AzerothCore CMakeLists.txt

Add to your main `CMakeLists.txt`:

```cmake
add_subdirectory(modules/mortal_overhaul)
```

### 3. Add Database Prepared Statements

Edit `src/Server/Database/CharacterDatabase.cpp`:

1. Add to the `CharacterStatements` enum:
```cpp
CHAR_SEL_MORTAL_SKILL,
CHAR_SEL_MORTAL_TOTAL_SKILLS,
CHAR_REP_MORTAL_SKILL,
CHAR_SEL_MORTAL_REGIONAL_BANK,
CHAR_REP_MORTAL_REGIONAL_BANK_ITEM,
```

2. Add to `PrepareStatements()`:
```cpp
PREPARE_STATEMENT(CHAR_SEL_MORTAL_SKILL, 
    "SELECT skill_value FROM character_mortal_skills WHERE guid = ? AND skill_id = ?", 
    CONNECTION_SYNCH);

PREPARE_STATEMENT(CHAR_SEL_MORTAL_TOTAL_SKILLS,
    "SELECT SUM(skill_value) FROM character_mortal_skills WHERE guid = ?",
    CONNECTION_SYNCH);

PREPARE_STATEMENT(CHAR_REP_MORTAL_SKILL,
    "REPLACE INTO character_mortal_skills (guid, skill_id, skill_value, skill_max) VALUES (?, ?, ?, ?)",
    CONNECTION_ASYNC);

PREPARE_STATEMENT(CHAR_SEL_MORTAL_REGIONAL_BANK,
    "SELECT slot, item_guid, item_entry, count FROM character_regional_bank WHERE guid = ? AND region_id = ?",
    CONNECTION_SYNCH);

PREPARE_STATEMENT(CHAR_REP_MORTAL_REGIONAL_BANK_ITEM,
    "REPLACE INTO character_regional_bank (guid, region_id, slot, item_guid, item_entry, count) VALUES (?, ?, ?, ?, ?, ?)",
    CONNECTION_ASYNC);
```

### 4. Run SQL Scripts

**Option A: Use the installation script (Recommended)**
```bash
cd /path/to/azerothcore
./modules/mortal_overhaul/scripts/install_database.sh
```

**Option B: Manual installation**

World Database:
```bash
mysql -u root -p azerothcore_world < modules/mortal_overhaul/sql/01_create_tables.sql
mysql -u root -p azerothcore_world < modules/mortal_overhaul/sql/02_systems_audit_soulbound.sql
mysql -u root -p azerothcore_world < modules/mortal_overhaul/sql/03_systems_audit_level_reqs.sql
mysql -u root -p azerothcore_world < modules/mortal_overhaul/sql/04_systems_audit_flight_masters.sql
mysql -u root -p azerothcore_world < modules/mortal_overhaul/sql/05_systems_audit_talents.sql
mysql -u root -p azerothcore_world < modules/mortal_overhaul/sql/06_token_economy_tables.sql
mysql -u root -p azerothcore_world < modules/mortal_overhaul/sql/07_token_economy_items.sql
mysql -u root -p azerothcore_world < modules/mortal_overhaul/sql/08_fragment_drops.sql
mysql -u root -p azerothcore_world < modules/mortal_overhaul/sql/09_guild_territories.sql
mysql -u root -p azerothcore_world < modules/mortal_overhaul/sql/10_resource_nodes.sql
mysql -u root -p azerothcore_world < modules/mortal_overhaul/sql/11_world_bosses.sql
mysql -u root -p azerothcore_world < modules/mortal_overhaul/sql/12_arena_rankings.sql
mysql -u root -p azerothcore_world < modules/mortal_overhaul/sql/13_material_properties.sql
mysql -u root -p azerothcore_world < modules/mortal_overhaul/sql/34_market_stalls.sql
mysql -u root -p azerothcore_world < modules/mortal_overhaul/sql/14_player_housing.sql
mysql -u root -p azerothcore_world < modules/mortal_overhaul/sql/55_warfronts.sql
mysql -u root -p azerothcore_world < modules/mortal_overhaul/sql/56_crafting_blueprints.sql
```

Character Database:
```bash
mysql -u root -p azerothcore_characters < modules/mortal_overhaul/sql/06_token_economy_tables.sql
mysql -u root -p azerothcore_characters < modules/mortal_overhaul/sql/09_guild_territories.sql
mysql -u root -p azerothcore_characters < modules/mortal_overhaul/sql/12_arena_rankings.sql
mysql -u root -p azerothcore_characters < modules/mortal_overhaul/sql/14_player_housing.sql
mysql -u root -p azerothcore_characters < modules/mortal_overhaul/sql/28_courier_contracts.sql
mysql -u root -p azerothcore_characters < modules/mortal_overhaul/sql/57_character_attributes.sql
```

### 5. Configure Eluna

**Option A: Use the setup script (Recommended)**
```bash
cd /path/to/azerothcore
./modules/mortal_overhaul/scripts/setup_lua.sh [lua_scripts_directory]
```

**Option B: Manual copy**
```bash
cp modules/mortal_overhaul/lua/*.lua /path/to/azerothcore/lua_scripts/
# Or if Eluna uses a different directory:
cp modules/mortal_overhaul/lua/*.lua /path/to/azerothcore/bin/lua_scripts/
```

### 6. Update Configuration

Add settings from `config/worldserver.conf.diff` to your `worldserver.conf`.

### 7. Recompile AzerothCore

```bash
cd build
cmake ..
make -j$(nproc)
```

### 8. Restart Server

Restart your AzerothCore worldserver to load the module.

## Verification

1. Log into the game
2. Check that XP gain is disabled (kill mobs, no XP)
3. Check that level is calculated from skills (should be level 1 for new characters)
4. Verify weapon skills are maxed (400) on login
