-- ==================================================
-- Project Mortal Warcraft
-- Feature: Convert Quest XP Rewards to Gold
-- Description: Since XP is disabled, convert all quest XP rewards to gold
-- ==================================================

-- Conversion rate: 1 XP = 1 copper (adjustable)
-- This means 100 XP = 1 silver, 10,000 XP = 1 gold
-- Higher level quests will give more gold

-- Note: Quest XP is calculated dynamically based on quest level and player level
-- We'll add gold to RewardMoneyMaxLevel (gold given at max level)
-- and set RewardXPDifficulty to 0 to disable XP

-- Step 1: Calculate approximate XP values for each quest difficulty
-- Based on quest level and difficulty multiplier
-- Formula: Base XP from questxp_dbc * difficulty multiplier

-- For simplicity, we'll use a flat conversion:
-- Level 1-10 quests: ~50-200 XP = 50-200 copper = 0.5-2 silver
-- Level 11-20 quests: ~200-500 XP = 200-500 copper = 2-5 silver  
-- Level 21-30 quests: ~500-1000 XP = 500-1000 copper = 5-10 silver
-- Level 31-40 quests: ~1000-2000 XP = 1000-2000 copper = 1-2 gold
-- Level 41-50 quests: ~2000-4000 XP = 2000-4000 copper = 2-4 gold
-- Level 51-60 quests: ~4000-8000 XP = 4000-8000 copper = 4-8 gold
-- Level 61-70 quests: ~8000-12000 XP = 8000-12000 copper = 8-12 gold
-- Level 71-80 quests: ~12000-20000 XP = 12000-20000 copper = 12-20 gold

-- We'll add gold based on quest level
-- Gold = (Quest Level * 100) copper = (Quest Level / 100) gold
-- This gives roughly: Level 10 = 1 gold, Level 20 = 2 gold, Level 80 = 8 gold

-- Update quest_template to add gold equivalent and disable XP
-- Note: Update the database name if your setup uses a different name
UPDATE `azerothcore_world`.`quest_template` 
SET 
    `RewardMoney` = `RewardMoney` + (CASE 
        WHEN `QuestLevel` > 0 THEN `QuestLevel` * 100  -- Add copper based on level
        WHEN `QuestLevel` = -1 THEN 5000  -- Dynamic level quests: 50 silver default
        ELSE 1000  -- Unknown level: 10 silver default
    END),
    `RewardXPDifficulty` = 0  -- Disable XP reward
WHERE 
    `RewardXPDifficulty` > 0  -- Only update quests that give XP
    AND `RewardXPDifficulty` <= 10;  -- Valid difficulty range

-- Alternative: More generous conversion (1 XP = 2 copper)
-- Uncomment below and comment above if you want more gold:
/*
UPDATE `quest_template` 
SET 
    `RewardMoney` = `RewardMoney` + (CASE 
        WHEN `QuestLevel` > 0 THEN `QuestLevel` * 200  -- 2x conversion
        WHEN `QuestLevel` = -1 THEN 10000
        ELSE 2000
    END),
    `RewardXPDifficulty` = 0
WHERE 
    `RewardXPDifficulty` > 0
    AND `RewardXPDifficulty` <= 10;
*/

-- Log the conversion
SELECT 
    COUNT(*) as quests_updated,
    SUM(CASE WHEN `QuestLevel` > 0 THEN `QuestLevel` * 100 ELSE 1000 END) as total_copper_added,
    SUM(CASE WHEN `QuestLevel` > 0 THEN `QuestLevel` * 100 ELSE 1000 END) / 10000 as total_gold_added
FROM `quest_template`
WHERE `RewardXPDifficulty` = 0
AND `RewardXPDifficulty` > 0;  -- This will be 0 after update, so this is just for reference

-- Note: This conversion is approximate
-- Actual XP values vary based on player level vs quest level
-- Players will receive gold instead of XP when completing quests

