-- ==================================================
-- Project Mortal Warcraft
-- Feature: Complete Instance Tier Mapping
-- Description: Completes instance tier mapping for all WotLK dungeons and raids
-- Based on: docs/specs/33-instance-and-battleground-tier-mapping.md
-- ==================================================

-- M-T3: Heroic Dungeons, TBC 25-man raids, Entry WotLK Raids
INSERT INTO `mortal_instance_tiers` (`map_id`, `instance_name`, `tier_code`, `trash_tier_code`, `boss_tier_code`, `loot_tier_hint`, `is_heroic`) VALUES
-- WotLK Heroic Dungeons
(533, 'Naxxramas', 'M-T3', 'TRASH_T3', 'BOSS_T3', 'M-T3', 0),
(533, 'Naxxramas (Heroic)', 'M-T4', 'TRASH_T4', 'BOSS_T4', 'M-T4', 1),
(615, 'The Obsidian Sanctum', 'M-T3', 'TRASH_T3', 'BOSS_T3', 'M-T3', 0),
(616, 'The Eye of Eternity', 'M-T3', 'TRASH_T3', 'BOSS_T3', 'M-T3', 0),
(631, 'Icecrown Citadel', 'M-T4', 'TRASH_T4', 'BOSS_T4', 'M-T4', 0),
(631, 'Icecrown Citadel (Heroic)', 'M-T5', 'TRASH_T5', 'BOSS_T5', 'M-T5', 1),
(649, 'Trial of the Crusader', 'M-T4', 'TRASH_T4', 'BOSS_T4', 'M-T4', 0),
(649, 'Trial of the Crusader (Heroic)', 'M-T5', 'TRASH_T5', 'BOSS_T5', 'M-T5', 1),
(724, 'The Ruby Sanctum', 'M-T4', 'TRASH_T4', 'BOSS_T4', 'M-T4', 0),
(724, 'The Ruby Sanctum (Heroic)', 'M-T5', 'TRASH_T5', 'BOSS_T5', 'M-T5', 1)
ON DUPLICATE KEY UPDATE 
    `tier_code` = VALUES(`tier_code`),
    `trash_tier_code` = VALUES(`trash_tier_code`),
    `boss_tier_code` = VALUES(`boss_tier_code`),
    `loot_tier_hint` = VALUES(`loot_tier_hint`);

-- M-T4: Mid/Late WotLK Raids
INSERT INTO `mortal_instance_tiers` (`map_id`, `instance_name`, `tier_code`, `trash_tier_code`, `boss_tier_code`, `loot_tier_hint`, `is_heroic`) VALUES
(603, 'Ulduar', 'M-T4', 'TRASH_T4', 'BOSS_T4', 'M-T4', 0),
(603, 'Ulduar (Heroic)', 'M-T5', 'TRASH_T5', 'BOSS_T5', 'M-T5', 1),
(249, 'Onyxia\'s Lair', 'M-T3', 'TRASH_T3', 'BOSS_T3', 'M-T3', 0)
ON DUPLICATE KEY UPDATE 
    `tier_code` = VALUES(`tier_code`),
    `trash_tier_code` = VALUES(`trash_tier_code`),
    `boss_tier_code` = VALUES(`boss_tier_code`),
    `loot_tier_hint` = VALUES(`loot_tier_hint`);

-- WotLK Dungeons (Normal)
INSERT INTO `mortal_instance_tiers` (`map_id`, `instance_name`, `tier_code`, `trash_tier_code`, `boss_tier_code`, `loot_tier_hint`, `is_heroic`) VALUES
(533, 'Utgarde Keep', 'M-T2', 'TRASH_T2', 'BOSS_T2', 'M-T2', 0),
(534, 'Utgarde Pinnacle', 'M-T2', 'TRASH_T2', 'BOSS_T2', 'M-T2', 0),
(530, 'The Nexus', 'M-T2', 'TRASH_T2', 'BOSS_T2', 'M-T2', 0),
(536, 'The Oculus', 'M-T2', 'TRASH_T2', 'BOSS_T2', 'M-T2', 0),
(532, 'Ahn\'kahet: The Old Kingdom', 'M-T2', 'TRASH_T2', 'BOSS_T2', 'M-T2', 0),
(531, 'Azjol-Nerub', 'M-T2', 'TRASH_T2', 'BOSS_T2', 'M-T2', 0),
(601, 'Halls of Lightning', 'M-T2', 'TRASH_T2', 'BOSS_T2', 'M-T2', 0),
(602, 'Halls of Stone', 'M-T2', 'TRASH_T2', 'BOSS_T2', 'M-T2', 0),
(600, 'Drak\'Tharon Keep', 'M-T2', 'TRASH_T2', 'BOSS_T2', 'M-T2', 0),
(604, 'Gundrak', 'M-T2', 'TRASH_T2', 'BOSS_T2', 'M-T2', 0),
(578, 'The Violet Hold', 'M-T2', 'TRASH_T2', 'BOSS_T2', 'M-T2', 0),
(608, 'The Culling of Stratholme', 'M-T2', 'TRASH_T2', 'BOSS_T2', 'M-T2', 0),
(615, 'The Forge of Souls', 'M-T3', 'TRASH_T3', 'BOSS_T3', 'M-T3', 0),
(616, 'Pit of Saron', 'M-T3', 'TRASH_T3', 'BOSS_T3', 'M-T3', 0),
(617, 'Halls of Reflection', 'M-T3', 'TRASH_T3', 'BOSS_T3', 'M-T3', 0)
ON DUPLICATE KEY UPDATE 
    `tier_code` = VALUES(`tier_code`),
    `trash_tier_code` = VALUES(`trash_tier_code`),
    `boss_tier_code` = VALUES(`boss_tier_code`),
    `loot_tier_hint` = VALUES(`loot_tier_hint`);

-- WotLK Dungeons (Heroic)
INSERT INTO `mortal_instance_tiers` (`map_id`, `instance_name`, `tier_code`, `trash_tier_code`, `boss_tier_code`, `loot_tier_hint`, `is_heroic`) VALUES
(533, 'Utgarde Keep (Heroic)', 'M-T3', 'TRASH_T3', 'BOSS_T3', 'M-T3', 1),
(534, 'Utgarde Pinnacle (Heroic)', 'M-T3', 'TRASH_T3', 'BOSS_T3', 'M-T3', 1),
(530, 'The Nexus (Heroic)', 'M-T3', 'TRASH_T3', 'BOSS_T3', 'M-T3', 1),
(536, 'The Oculus (Heroic)', 'M-T3', 'TRASH_T3', 'BOSS_T3', 'M-T3', 1),
(532, 'Ahn\'kahet: The Old Kingdom (Heroic)', 'M-T3', 'TRASH_T3', 'BOSS_T3', 'M-T3', 1),
(531, 'Azjol-Nerub (Heroic)', 'M-T3', 'TRASH_T3', 'BOSS_T3', 'M-T3', 1),
(601, 'Halls of Lightning (Heroic)', 'M-T3', 'TRASH_T3', 'BOSS_T3', 'M-T3', 1),
(602, 'Halls of Stone (Heroic)', 'M-T3', 'TRASH_T3', 'BOSS_T3', 'M-T3', 1),
(600, 'Drak\'Tharon Keep (Heroic)', 'M-T3', 'TRASH_T3', 'BOSS_T3', 'M-T3', 1),
(604, 'Gundrak (Heroic)', 'M-T3', 'TRASH_T3', 'BOSS_T3', 'M-T3', 1),
(578, 'The Violet Hold (Heroic)', 'M-T3', 'TRASH_T3', 'BOSS_T3', 'M-T3', 1),
(608, 'The Culling of Stratholme (Heroic)', 'M-T3', 'TRASH_T3', 'BOSS_T3', 'M-T3', 1),
(615, 'The Forge of Souls (Heroic)', 'M-T4', 'TRASH_T4', 'BOSS_T4', 'M-T4', 1),
(616, 'Pit of Saron (Heroic)', 'M-T4', 'TRASH_T4', 'BOSS_T4', 'M-T4', 1),
(617, 'Halls of Reflection (Heroic)', 'M-T4', 'TRASH_T4', 'BOSS_T4', 'M-T4', 1)
ON DUPLICATE KEY UPDATE 
    `tier_code` = VALUES(`tier_code`),
    `trash_tier_code` = VALUES(`trash_tier_code`),
    `boss_tier_code` = VALUES(`boss_tier_code`),
    `loot_tier_hint` = VALUES(`loot_tier_hint`);

-- Complete Battleground Tier Mapping
INSERT INTO `mortal_battleground_tiers` (`map_id`, `bg_name`, `is_warfront`, `pvp_tier_hint`, `reward_tokens`, `reward_credits`, `notes`) VALUES
-- Classic BGs (Not Warfronts)
(30, 'Alterac Valley', 0, 'P1', 50, 100, 'Classic BG - Standard PvP rewards'),
(489, 'Warsong Gulch', 0, 'P1', 30, 50, 'Classic BG - Standard PvP rewards'),
(529, 'Arathi Basin', 0, 'P1', 40, 75, 'Classic BG - Standard PvP rewards'),
(566, 'Eye of the Storm', 0, 'P1', 40, 75, 'TBC BG - Standard PvP rewards'),
(607, 'Strand of the Ancients', 0, 'P2', 60, 120, 'WotLK BG - Higher rewards'),
(628, 'Isle of Conquest', 0, 'P2', 80, 150, 'WotLK BG - Higher rewards'),
-- Warfronts (Full Loot)
(30, 'Alterac Valley (Warfront)', 1, 'P3', 150, 300, 'Warfront variant - Full loot enabled'),
(489, 'Warsong Gulch (Warfront)', 1, 'P2', 100, 200, 'Warfront variant - Full loot enabled'),
(529, 'Arathi Basin (Warfront)', 1, 'P3', 120, 250, 'Warfront variant - Full loot enabled')
ON DUPLICATE KEY UPDATE 
    `is_warfront` = VALUES(`is_warfront`),
    `pvp_tier_hint` = VALUES(`pvp_tier_hint`),
    `reward_tokens` = VALUES(`reward_tokens`),
    `reward_credits` = VALUES(`reward_credits`),
    `notes` = VALUES(`notes`);

-- Summary
SELECT 
    'Instance Tier Mapping Complete' as summary,
    COUNT(DISTINCT map_id) as total_instances,
    COUNT(DISTINCT CASE WHEN is_heroic = 0 THEN map_id END) as normal_instances,
    COUNT(DISTINCT CASE WHEN is_heroic = 1 THEN map_id END) as heroic_instances,
    COUNT(DISTINCT tier_code) as tier_bands
FROM mortal_instance_tiers;

SELECT 
    'Battleground Tier Mapping Complete' as summary,
    COUNT(*) as total_bgs,
    SUM(CASE WHEN is_warfront = 1 THEN 1 ELSE 0 END) as warfronts,
    SUM(CASE WHEN is_warfront = 0 THEN 1 ELSE 0 END) as standard_bgs
FROM mortal_battleground_tiers;

