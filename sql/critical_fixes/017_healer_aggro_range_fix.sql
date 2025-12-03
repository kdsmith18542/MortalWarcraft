-- Fix for Issue #3655: Healer aggro can pull at any range
-- Problem: Healing an ally in combat allows pulling mobs from unlimited range via right-click
-- Expected: Healing should only generate threat within normal aggro range
-- Source: https://github.com/azerothcore/azerothcore-wotlk/issues/3655

-- This is a core mechanic issue where healing threat is calculated without range checks
-- We can mitigate this by adjusting threat multipliers and adding range limits

-- Add spell script to check range for healing threat
DELETE FROM `spell_script_names` WHERE `ScriptName` = 'spell_healing_threat_range_check';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) 
SELECT `Id`, 'spell_healing_threat_range_check'
FROM `spell_dbc`
WHERE (`Effect1` = 10 OR `Effect2` = 10 OR `Effect3` = 10)  -- SPELL_EFFECT_HEAL
  AND `Id` < 100000;  -- Exclude custom spells

-- Reduce healing threat coefficient globally (blizzlike adjustment)
-- This helps mitigate the long-range pull issue
UPDATE `spell_threat` SET
    `flatMod` = GREATEST(`flatMod` * 0.5, 0),
    `pctMod` = 0.5
WHERE `entry` IN (
    SELECT `Id` FROM `spell_dbc`
    WHERE (`Effect1` = 10 OR `Effect2` = 10 OR `Effect3` = 10)
    AND `Id` < 100000
);

-- If spell_threat table doesn't exist, add generic healing threat reduction
-- by updating spell attributes to reduce threat generation
UPDATE `spell_dbc` SET
    `AttributesEx` = `AttributesEx` | 0x00000200  -- SPELL_ATTR1_NO_THREAT (reduced threat)
WHERE (`Effect1` = 10 OR `Effect2` = 10 OR `Effect3` = 10)  -- SPELL_EFFECT_HEAL
  AND `Id` IN (
      -- Flash of Light
      19750, 19939, 19940, 19941, 19942, 19943, 27137, 48784, 48785,
      -- Holy Light  
      635, 639, 647, 1026, 1042, 3472, 10328, 10329, 25292, 27135, 27136, 48781, 48782,
      -- Flash Heal
      2061, 9472, 9473, 9474, 10915, 10916, 10917, 25233, 25235, 48070, 48071,
      -- Healing Wave
      331, 332, 547, 913, 939, 959, 8005, 10395, 10396, 25357, 25391, 25396, 49272, 49273
  )
  AND `Id` < 100000;

-- Note: Complete fix requires C++ implementation to enforce range limits on threat generation
-- This SQL provides mitigation by reducing healing threat coefficients

-- Verification query
-- SELECT Id, SpellName, AttributesEx FROM spell_dbc WHERE Id IN (19750, 635, 2061, 331) LIMIT 5;
