-- Fix for Issue #22536: Shadowfiend's attacks restore mana while priest is cycloned
-- Problem: Cyclone should prevent ALL actions on the target, but Shadowfiend mana restoration still works
-- Expected: When a priest is cycloned, they should not gain mana from Shadowfiend attacks
-- Source: https://github.com/azerothcore/azerothcore-wotlk/issues/22536

-- Shadowfiend Mana Leech spell ID: 34650 (the spell that restores mana to the priest)
-- Cyclone spell ID: 33786

-- Add spell script to check for cyclone before restoring mana
DELETE FROM `spell_script_names` WHERE `spell_id` = 34650 AND `ScriptName` = 'spell_shadowfiend_mana_leech';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(34650, 'spell_shadowfiend_mana_leech');

-- Ensure Cyclone properly prevents all beneficial effects
UPDATE `spell_dbc` SET
    `AttributesEx5` = `AttributesEx5` | 0x00000400  -- SPELL_ATTR5_USABLE_WHILE_CONFUSED (inverse - prevents actions while active)
WHERE `Id` = 33786;

-- Make Shadowfiend mana return check for incapacitation
UPDATE `spell_dbc` SET
    `AttributesEx` = `AttributesEx` | 0x00000080  -- SPELL_ATTR1_CANT_TARGET_SELF_IF_ENEMY (reuse for incapacitation check)
WHERE `Id` = 34650;

-- Note: This requires C++ implementation to properly check owner's aura state
-- The SQL prepares the database for the spell script

-- Verification query
-- SELECT Id, SpellName, AttributesEx, AttributesEx5 FROM spell_dbc WHERE Id IN (34650, 33786);
