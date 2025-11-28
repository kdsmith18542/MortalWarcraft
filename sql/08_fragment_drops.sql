-- ==================================================
-- Project Mortal Warcraft: Fragment Drop Configuration
-- Module: mod-mortal-core
-- Feature: Configure Fragment of the Crown drops
-- ==================================================

-- Note: Fragment drops should be configured via:
-- 1. Creature loot tables (for Red Zone Bosses)
-- 2. Gameobject loot tables (for Delve Chests)
-- 3. Lua scripts for custom drop logic

-- Example: Add Fragment to a specific boss loot table
-- This is a template - adjust creature_entry and drop_chance as needed

-- For Red Zone Bosses (1% drop rate)
-- INSERT INTO `creature_loot_template` (
--     `Entry`, `Item`, `Reference`, `Chance`, `QuestRequired`, `LootMode`, 
--     `GroupId`, `MinCount`, `MaxCount`, `Comment`
-- ) VALUES (
--     BOSS_ENTRY_ID, -- Replace with actual boss entry
--     90001, -- Fragment of the Crown
--     0, -- Reference
--     1.0, -- 1% chance
--     0, -- QuestRequired
--     1, -- LootMode
--     0, -- GroupId
--     1, -- MinCount
--     1, -- MaxCount
--     'Fragment of the Crown - Red Zone Boss Drop'
-- );

-- For Delve Chests (Gameobject loot)
-- INSERT INTO `gameobject_loot_template` (
--     `Entry`, `Item`, `Reference`, `Chance`, `QuestRequired`, `LootMode`, 
--     `GroupId`, `MinCount`, `MaxCount`, `Comment`
-- ) VALUES (
--     CHEST_ENTRY_ID, -- Replace with actual chest entry
--     90001, -- Fragment of the Crown
--     0, -- Reference
--     1.0, -- 1% chance
--     0, -- QuestRequired
--     1, -- LootMode
--     0, -- GroupId
--     1, -- MinCount
--     1, -- MaxCount
--     'Fragment of the Crown - Delve Chest Drop'
-- );

-- Alternative: Use Lua script for more control
-- See: lua/fragment_drops.lua (to be created)

