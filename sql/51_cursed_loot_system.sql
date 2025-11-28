-- ==================================================
-- Project Mortal Warcraft
-- Feature: Raids & Extraction (Cursed Loot)
-- Description: Bosses drop Cursed Artifacts that must be extracted
-- ==================================================

-- Raid Sigil Items (Required for entry)
CREATE TABLE IF NOT EXISTS `raid_sigils` (
    `sigil_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `item_entry` INT UNSIGNED NOT NULL UNIQUE COMMENT 'Item ID of the sigil',
    `raid_map_id` INT UNSIGNED NOT NULL COMMENT 'Map ID of the raid',
    `raid_name` VARCHAR(100) NOT NULL,
    `description` TEXT,
    `cost_gold` INT UNSIGNED NOT NULL DEFAULT 1000 COMMENT 'Cost to purchase sigil',
    `enabled` BOOLEAN NOT NULL DEFAULT TRUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert Raid Sigils
INSERT INTO `raid_sigils` (`item_entry`, `raid_map_id`, `raid_name`, `description`, `cost_gold`, `enabled`) VALUES
(90060, 409, 'Molten Core Sigil', 'Required to enter Molten Core. Consumed on use.', 5000, 1),
(90061, 249, 'Onyxia Lair Sigil', 'Required to enter Onyxia Lair. Consumed on use.', 5000, 1),
(90062, 469, 'Blackwing Lair Sigil', 'Required to enter Blackwing Lair. Consumed on use.', 10000, 1),
(90063, 531, 'Ahn Qiraj Temple Sigil', 'Required to enter AQ40. Consumed on use.', 10000, 1),
(90064, 533, 'Naxxramas Sigil', 'Required to enter Naxxramas. Consumed on use.', 15000, 1)

ON DUPLICATE KEY UPDATE
    `raid_name` = VALUES(`raid_name`),
    `description` = VALUES(`description`),
    `cost_gold` = VALUES(`cost_gold`),
    `enabled` = VALUES(`enabled`);

-- Cursed Artifacts (Heavy, non-equippable loot)
CREATE TABLE IF NOT EXISTS `cursed_artifacts` (
    `artifact_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `item_entry` INT UNSIGNED NOT NULL UNIQUE COMMENT 'Item ID of the artifact',
    `artifact_name` VARCHAR(100) NOT NULL,
    `weight` INT UNSIGNED NOT NULL DEFAULT 100 COMMENT 'Weight in encumbrance system',
    `purification_reward` TEXT COMMENT 'Reward after purification (item IDs, gold, etc.)',
    `description` TEXT,
    `enabled` BOOLEAN NOT NULL DEFAULT TRUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert Cursed Artifacts
INSERT INTO `cursed_artifacts` (`item_entry`, `artifact_name`, `weight`, `purification_reward`, `description`, `enabled`) VALUES
(90070, 'Cursed Core Fragment', 50, '90071,1000', 'A fragment of Ragnaros core. Heavy and cursed.', 1),
(90071, 'Purified Core Fragment', 0, '1000', 'Purified fragment, safe to carry.', 1),
(90072, 'Cursed Dragon Scale', 75, '90073,2000', 'A scale from Onyxia. Cursed with her essence.', 1),
(90073, 'Purified Dragon Scale', 0, '2000', 'Purified scale, safe to carry.', 1),
(90074, 'Cursed Blackwing Essence', 100, '90075,5000', 'Essence from Nefarian. Extremely heavy.', 1),
(90075, 'Purified Blackwing Essence', 0, '5000', 'Purified essence, safe to carry.', 1)

ON DUPLICATE KEY UPDATE
    `artifact_name` = VALUES(`artifact_name`),
    `weight` = VALUES(`weight`),
    `purification_reward` = VALUES(`purification_reward`),
    `description` = VALUES(`description`),
    `enabled` = VALUES(`enabled`);

-- Purification Altars (Extraction points)
CREATE TABLE IF NOT EXISTS `purification_altars` (
    `altar_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `altar_name` VARCHAR(100) NOT NULL,
    `map_id` INT UNSIGNED NOT NULL,
    `zone_id` INT UNSIGNED NOT NULL,
    `x` FLOAT NOT NULL,
    `y` FLOAT NOT NULL,
    `z` FLOAT NOT NULL,
    `o` FLOAT NOT NULL DEFAULT 0,
    `go_entry` INT UNSIGNED DEFAULT NULL COMMENT 'GameObject entry ID',
    `description` TEXT,
    `enabled` BOOLEAN NOT NULL DEFAULT TRUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert Purification Altars
INSERT INTO `purification_altars` (`altar_name`, `map_id`, `zone_id`, `x`, `y`, `z`, `o`, `description`, `enabled`) VALUES
('Tyr Hand Purification Altar', 0, 139, 1687.0, -5320.0, 73.0, 0, 'Purification altar in Tyr Hand (Eastern Plaguelands).', 1),
('Stormwind Cathedral Altar', 0, 1519, -8582.0, 861.0, 99.0, 0, 'Purification altar in Stormwind Cathedral.', 1),
('Orgrimmar Altar', 1, 1637, 1552.0, -4420.0, 8.0, 0, 'Purification altar in Orgrimmar.', 1)

ON DUPLICATE KEY UPDATE
    `altar_name` = VALUES(`altar_name`),
    `description` = VALUES(`description`),
    `enabled` = VALUES(`enabled`);

-- Boss to Artifact Mapping
CREATE TABLE IF NOT EXISTS `boss_cursed_loot` (
    `mapping_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `boss_entry` INT UNSIGNED NOT NULL COMMENT 'Creature entry ID',
    `boss_name` VARCHAR(100) NOT NULL,
    `artifact_entry` INT UNSIGNED NOT NULL COMMENT 'Cursed artifact item ID',
    `drop_chance` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Drop chance (1.0 = 100%)',
    `raid_map_id` INT UNSIGNED NOT NULL,
    `enabled` BOOLEAN NOT NULL DEFAULT TRUE,
    INDEX `idx_boss` (`boss_entry`),
    INDEX `idx_artifact` (`artifact_entry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert Boss to Artifact Mappings
INSERT INTO `boss_cursed_loot` (`boss_entry`, `boss_name`, `artifact_entry`, `drop_chance`, `raid_map_id`, `enabled`) VALUES
(11502, 'Ragnaros', 90070, 1.0, 409, 1),
(10184, 'Onyxia', 90072, 1.0, 249, 1),
(11583, 'Nefarian', 90074, 1.0, 469, 1)

ON DUPLICATE KEY UPDATE
    `drop_chance` = VALUES(`drop_chance`),
    `enabled` = VALUES(`enabled`);

