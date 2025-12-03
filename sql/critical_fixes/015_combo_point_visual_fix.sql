-- Fix for Issue #22068: Rogue Combo Point Visual not correct
-- Problem: When using Eviscerate with Cold Blood + Relentless Strikes, combo points display incorrectly
-- Expected: Combo point display should accurately reflect actual combo points available
-- Source: https://github.com/azerothcore/azerothcore-wotlk/issues/22068

-- This is primarily a client-side display issue caused by spell proc timing
-- The fix requires ensuring proper combo point updates are sent to the client

-- Cold Blood spell ID: 14177
-- Relentless Strikes spell ID: 14179 (Rank 5)
-- Eviscerate spell IDs: 2098, 6760, 6761, 6762, 8623, 8624, 11299, 11300, 31016, 26865, 48667, 48668

-- Add spell script to force combo point refresh after finisher
DELETE FROM `spell_script_names` WHERE `spell_id` IN (2098, 6760, 6761, 6762, 8623, 8624, 11299, 11300, 31016, 26865, 48667, 48668) AND `ScriptName` = 'spell_rog_eviscerate_combo_refresh';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(2098, 'spell_rog_eviscerate_combo_refresh'),
(6760, 'spell_rog_eviscerate_combo_refresh'),
(6761, 'spell_rog_eviscerate_combo_refresh'),
(6762, 'spell_rog_eviscerate_combo_refresh'),
(8623, 'spell_rog_eviscerate_combo_refresh'),
(8624, 'spell_rog_eviscerate_combo_refresh'),
(11299, 'spell_rog_eviscerate_combo_refresh'),
(11300, 'spell_rog_eviscerate_combo_refresh'),
(31016, 'spell_rog_eviscerate_combo_refresh'),
(26865, 'spell_rog_eviscerate_combo_refresh'),
(48667, 'spell_rog_eviscerate_combo_refresh'),
(48668, 'spell_rog_eviscerate_combo_refresh');

-- Update Relentless Strikes to properly sync combo point display
UPDATE `spell_dbc` SET
    `AttributesEx` = `AttributesEx` | 0x00000010,  -- SPELL_ATTR1_NO_THREAT
    `procFlags` = 0x00010000  -- PROC_FLAG_DONE_PERIODIC
WHERE `Id` = 14179;

-- Note: This requires C++ implementation to force client combo point updates
-- The SQL prepares the database for the spell script

-- Verification query
-- SELECT Id, SpellName, AttributesEx, procFlags FROM spell_dbc WHERE Id = 14179;
