-- ==================================================
-- Mortal Warcraft Quest Conversion Patches
-- Generated from mortal_quest_conversion_map
-- This script applies quest conversions based on classification
-- ==================================================

-- Disable STORY_REWRITE quests (will be replaced with custom scripts)
UPDATE quest_template qt
INNER JOIN mortal_quest_conversion_map qcm ON qt.entry = qcm.quest_id
SET qt.SpecialFlags = qt.SpecialFlags | 2  -- QUEST_SPECIAL_FLAGS_DELIVER (disable)
WHERE qcm.conversion_type = 'STORY_REWRITE';

-- Update quest giver gossip for CONTRACT_BOARD quests
-- (NPCs will point players to task board)
UPDATE creature_template ct
INNER JOIN creature_questrelation cq ON ct.entry = cq.id
INNER JOIN mortal_quest_conversion_map qcm ON cq.quest = qcm.quest_id
SET ct.npcflag = ct.npcflag | 0x00000002  -- Ensure vendor flag for task board access
WHERE qcm.conversion_type = 'CONTRACT_BOARD';

-- Note: CONTRACT_LOCAL and FLAVOR quests remain active
-- HUB_NARRATIVE quests will be handled by custom scripts

-- Update quest rewards to remove XP (Mortal uses skill points instead)
UPDATE quest_template qt
INNER JOIN mortal_quest_conversion_map qcm ON qt.entry = qcm.quest_id
SET qt.RewXPId = 0,  -- Remove XP reward
    qt.RewXP = 0
WHERE qcm.conversion_type IN ('CONTRACT_BOARD', 'CONTRACT_LOCAL', 'FLAVOR');

-- Scale gold rewards based on risk tier (placeholder - would need zone risk data)
-- For now, reduce gold rewards by 50% to fit Mortal economy
UPDATE quest_template qt
INNER JOIN mortal_quest_conversion_map qcm ON qt.entry = qcm.quest_id
SET qt.RewOrReqMoney = qt.RewOrReqMoney * 0.5
WHERE qcm.conversion_type IN ('CONTRACT_BOARD', 'CONTRACT_LOCAL')
  AND qt.RewOrReqMoney > 0;

-- Log conversion statistics
INSERT INTO mortal_conversion_stats (stat_key, stat_value, last_updated, notes)
VALUES ('quests_patched', 
        (SELECT COUNT(*) FROM mortal_quest_conversion_map WHERE conversion_type != 'STORY_REWRITE'),
        UNIX_TIMESTAMP(),
        'Quests converted to contracts/flavor')
ON DUPLICATE KEY UPDATE
    stat_value = VALUES(stat_value),
    last_updated = VALUES(last_updated),
    notes = VALUES(notes);

