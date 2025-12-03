-- Fix for Issue #21513: Svala Sorrowgrave Call of Flames ticks faster than normal
-- Problem: Call of Flames spell ticks too fast (all 4 ticks in 2 seconds instead of ~3 seconds each)
-- Expected: Ticks should be spaced approximately 3 seconds apart
-- Source: https://github.com/azerothcore/azerothcore-wotlk/issues/21513

-- Svala Sorrowgrave entry: 26668
-- Call of Flames spell ID: 48258 (10-man), 48262 (25-man)

-- Fix the spell to have proper tick timing (3000ms = 3 seconds between ticks)
UPDATE `spell_dbc` SET
    `EffectAmplitude1` = 3000,  -- Time between ticks in milliseconds
    `EffectAmplitude2` = 3000,
    `EffectAmplitude3` = 3000
WHERE `Id` IN (48258, 48262);

-- Also ensure duration is correct for 4 ticks at 3 second intervals (12 seconds total)
UPDATE `spell_dbc` SET
    `DurationIndex` = 27  -- 12 second duration
WHERE `Id` IN (48258, 48262);

-- Update the boss AI to have correct spell timing
DELETE FROM `smart_scripts` WHERE `entryorguid` = 26668 AND `source_type` = 0 AND `id` = 10;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(26668, 0, 10, 0, 0, 0, 100, 2, 8000, 12000, 15000, 20000, 11, 48258, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 'Svala Sorrowgrave - In Combat - Cast Call of Flames (10-man)'),
(26668, 0, 11, 0, 0, 0, 100, 4, 8000, 12000, 15000, 20000, 11, 48262, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 'Svala Sorrowgrave - In Combat - Cast Call of Flames (25-man)');

-- Verification query
-- SELECT Id, SpellName, EffectAmplitude1, EffectAmplitude2, EffectAmplitude3, DurationIndex FROM spell_dbc WHERE Id IN (48258, 48262);
-- SELECT * FROM smart_scripts WHERE entryorguid = 26668 AND id IN (10, 11);
