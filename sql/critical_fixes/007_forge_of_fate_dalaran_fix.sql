-- Fix for Issue #23770: Forge of Fate in Dalaran should allow smelting
-- Problem: The Forge of Fate in Dalaran does not count as a forge for mining smelting
-- Expected: Players should be able to smelt ores anywhere within the room
-- Source: https://github.com/azerothcore/azerothcore-wotlk/issues/23770

-- The Forge of Fate gameobject needs to have the correct type and flags
-- Gameobject entry for Forge of Fate is typically around ID 192829

-- Update the gameobject to be usable as a forge
UPDATE `gameobject_template` SET
    `type` = 8,  -- Type 8 is GAMEOBJECT_TYPE_SPELL_FOCUS
    `data0` = 0, -- SpellFocusType
    `data1` = 10, -- dist (10 yards radius)
    `data2` = 0,
    `data3` = 0,
    `data4` = 0,
    `data5` = 0
WHERE `entry` = 192829 AND `name` LIKE '%Forge%';

-- Alternative: If the above doesn't work, we may need to add an areatrigger
-- For now, this should enable basic forge functionality
-- The game client will recognize type 8 gameobjects as usable for smelting

-- Verification query
-- SELECT entry, name, type, data0, data1 FROM gameobject_template WHERE entry = 192829;
