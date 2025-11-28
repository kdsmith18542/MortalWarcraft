-- Fix Script Registrations for Mortal Overhaul Module
-- These scripts exist in C++ code but need proper database registration

-- ================================================
-- 1. REMOVE UNIMPLEMENTED ITEM/NPC SCRIPTS
-- ================================================
-- These are assigned in DB but have no C++ implementation yet
-- We'll remove them to clean up the warnings until they're implemented

DELETE FROM item_template WHERE ScriptName IN (
    'item_courier_crate',
    'item_mortal_bond',
    'item_stat_book',
    'item_true_sight'
) AND entry IN (90000, 90002, 90003, 90004);

UPDATE item_template SET ScriptName = '' 
WHERE entry IN (90000, 90002, 90003, 90004);

DELETE FROM creature_template WHERE ScriptName IN (
    'mortal_bounty_board',
    'mortal_squire',
    'mortal_territory_controller',
    'npc_mercenary_broker'
);

-- ================================================
-- 2. FIX SPELL SCRIPT REGISTRATIONS
-- ================================================
-- These spell scripts exist in MortalPerformanceHooks.cpp
-- They use RegisterSpellScript() which means they apply to ALL spells
-- We don't need spell_script_names entries for them

-- If there are any existing entries, remove them to clean up warnings
DELETE FROM spell_script_names WHERE ScriptName IN (
    'SpellScript_MortalTracking',
    'SpellScript_MortalArmorWeight',
    'SpellScript_MortalLivingMounts',
    'SpellScript_MortalResurrection'
);

-- Note: These scripts are now registered globally via RegisterSpellScript()
-- They will check internally if they should apply to specific spells
-- This is the correct approach for these performance-critical hooks

-- ================================================
-- 3. ADD NOTES FOR FUTURE IMPLEMENTATION
-- ================================================
-- Document what these items/NPCs should do once implemented

-- item_courier_crate (90002): Courier contract system item
-- item_mortal_bond (90000): Companion bond system item  
-- item_stat_book (90003): Stat/skill book item
-- item_true_sight (90004): Vision/tracking potion
-- mortal_bounty_board: Bounty board NPC
-- mortal_squire: Vendor squire companion NPC
-- mortal_territory_controller: Guild territory control NPC
-- npc_mercenary_broker: Mercenary hiring NPC

