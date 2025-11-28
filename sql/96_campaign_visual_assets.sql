-- ==================================================
-- Mortal Warcraft – Campaign Visual Assets
-- Spec 62: Core Lore and Campaign Skeleton
-- Updates creature and item templates with appropriate model/display IDs
-- Target DB: world
-- ==================================================

-- Note: These IDs are based on common WotLK models
-- Use tools/find_dbc_ids.py to find specific IDs from DBC files
-- Or reference Wowhead for visual verification

-- ==================================================
-- Creature Model IDs (CreatureDisplayInfo.dbc)
-- ==================================================

-- Survivor Alden (99990) - Human Male Survivor
-- Using Human Male model (Display ID 49)
UPDATE `creature_template` SET
    `modelid1` = 49,
    `modelid2` = 0,
    `modelid3` = 0,
    `modelid4` = 0
WHERE `entry` = 99990;

-- Training Dummy (99992) - Training Dummy
-- Using Training Dummy model (Display ID 30721)
UPDATE `creature_template` SET
    `modelid1` = 30721,
    `modelid2` = 0,
    `modelid3` = 0,
    `modelid4` = 0
WHERE `entry` = 99992;

-- Harbor Clerk Serra (99980) - Human Female Clerk
-- Using Human Female model (Display ID 50)
UPDATE `creature_template` SET
    `modelid1` = 50,
    `modelid2` = 0,
    `modelid3` = 0,
    `modelid4` = 0
WHERE `entry` = 99980;

-- Banker Tolan (99983) - Human Male Banker
-- Using Human Male model (Display ID 49)
UPDATE `creature_template` SET
    `modelid1` = 49,
    `modelid2` = 0,
    `modelid3` = 0,
    `modelid4` = 0
WHERE `entry` = 99983;

-- Shrine Acolyte Valeria (99984) - Human Female Acolyte
-- Using Human Female model (Display ID 50)
UPDATE `creature_template` SET
    `modelid1` = 50,
    `modelid2` = 0,
    `modelid3` = 0,
    `modelid4` = 0
WHERE `entry` = 99984;

-- Ether-touched Scavenger (99996) - Corrupted Creature
-- Using Ghoul model (Display ID 14122) as placeholder for corrupted creature
UPDATE `creature_template` SET
    `modelid1` = 14122,
    `modelid2` = 0,
    `modelid3` = 0,
    `modelid4` = 0
WHERE `entry` = 99996;

-- Quartermaster Rhela (99982) - Human Female Quartermaster
-- Using Human Female model (Display ID 50)
UPDATE `creature_template` SET
    `modelid1` = 50,
    `modelid2` = 0,
    `modelid3` = 0,
    `modelid4` = 0
WHERE `entry` = 99982;

-- ==================================================
-- Item Display IDs (ItemDisplayInfo.dbc)
-- ==================================================

-- Broken Weapon (99991) - Simple Broken Sword
-- Using simple sword display (Display ID 1542)
UPDATE `item_template` SET
    `displayid` = 1542
WHERE `entry` = 99991;

-- Crafted Shiv (99995) - Simple Dagger
-- Using simple dagger display (Display ID 1542 or similar)
UPDATE `item_template` SET
    `displayid` = 1542
WHERE `entry` = 99995;

-- ==================================================
-- GameObject Display IDs (GameObjectDisplayInfo.dbc)
-- ==================================================

-- Makeshift Anvil (19980) - Anvil GameObject
-- Using Anvil display (Display ID 1 - default anvil)
-- Note: GameObject display IDs are in GameObjectDisplayInfo.dbc
-- Common anvil display ID: 1 or search for "Anvil" in DBC

-- Damaged Raft (19981) - Boat/Raft GameObject
-- Using Boat display (Display ID varies - search for "Boat" or "Raft" in DBC)

-- Damaged Shrine Fragment (19982) - Shrine GameObject
-- Using Shrine/Altar display (Display ID varies - search for "Shrine" in DBC)

-- Driftwood Pile (19983) - Wood Pile GameObject
-- Using Wood Pile display (Display ID varies - search for "Wood" in DBC)

-- Port Meridian Task Board (19990) - Board/Notice Board
-- Using Notice Board display (Display ID varies - search for "Board" in DBC)

-- Regional Bank (19991) - Bank Vault
-- Using Bank display (Display ID varies - search for "Bank" in DBC)

-- Shrine (19992) - Shrine Altar
-- Using Shrine display (Display ID varies - search for "Shrine" in DBC)

-- Market Stall (19993) - Market Stall
-- Using Market Stall display (Display ID varies - search for "Stall" in DBC)

-- ==================================================
-- Notes on Finding Display IDs
-- ==================================================

-- To find specific display IDs:
-- 1. Use tools/find_dbc_ids.py to search DBC files
-- 2. Reference Wowhead for visual verification:
--    - Creatures: https://www.wowhead.com/wotlk/npc=ENTRY
--    - Items: https://www.wowhead.com/wotlk/item=ENTRY
--    - GameObjects: https://www.wowhead.com/wotlk/object=ENTRY
-- 3. Check existing examples in sql/73_t1_t2_display_ids.sql
-- 4. Use DBC viewer tools to browse CreatureDisplayInfo.dbc, ItemDisplayInfo.dbc, etc.

-- Common Model IDs Reference:
-- Human Male: 49
-- Human Female: 50
-- Orc Male: 51
-- Orc Female: 52
-- Dwarf Male: 53
-- Dwarf Female: 54
-- Night Elf Male: 55
-- Night Elf Female: 56
-- Undead Male: 57
-- Undead Female: 58
-- Tauren Male: 59
-- Tauren Female: 60
-- Gnome Male: 1563
-- Gnome Female: 1564
-- Troll Male: 1478
-- Troll Female: 1479
-- Blood Elf Male: 15475
-- Blood Elf Female: 15476
-- Draenei Male: 16125
-- Draenei Female: 16126

