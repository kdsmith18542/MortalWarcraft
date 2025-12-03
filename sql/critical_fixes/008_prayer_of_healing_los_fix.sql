-- Fix for Issue #21976: Prayer of Healing doesn't ignore line of sight
-- Problem: Prayer of Healing requires line of sight to all targets, but shouldn't
-- Expected: Only the main target needs to be in LOS; party members behind walls should still be healed
-- Source: https://github.com/azerothcore/azerothcore-wotlk/issues/21976
-- Additional source: https://www.wowhead.com/wotlk/spell=596/prayer-of-healing#comments:id=918159

-- Prayer of Healing spell IDs (all ranks):
-- 596 (Rank 1), 996 (Rank 2), 10960 (Rank 3), 10961 (Rank 4), 25316 (Rank 5), 25308 (Rank 6), 48072 (Rank 7)

-- Add SPELL_ATTR2_CAN_TARGET_NOT_IN_LOS flag (0x00000004) to ignore LOS requirement
UPDATE `spell_dbc` SET
    `Attributes` = `Attributes` | 0x00000004
WHERE `Id` IN (596, 996, 10960, 10961, 25316, 25308, 48072);

-- Alternative approach using custom spell attributes table if spell_dbc doesn't exist
-- This will work with the spell_script_names system
DELETE FROM `spell_script_names` WHERE `spell_id` IN (596, 996, 10960, 10961, 25316, 25308, 48072) AND `ScriptName` = 'spell_pri_prayer_of_healing';

INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(596, 'spell_pri_prayer_of_healing'),
(996, 'spell_pri_prayer_of_healing'),
(10960, 'spell_pri_prayer_of_healing'),
(10961, 'spell_pri_prayer_of_healing'),
(25316, 'spell_pri_prayer_of_healing'),
(25308, 'spell_pri_prayer_of_healing'),
(48072, 'spell_pri_prayer_of_healing');

-- Note: The spell script needs to be implemented in C++ to properly ignore LOS
-- This SQL prepares the database for that script

-- Verification query
-- SELECT Id, SpellName, Attributes FROM spell_dbc WHERE Id IN (596, 996, 10960, 10961, 25316, 25308, 48072);
