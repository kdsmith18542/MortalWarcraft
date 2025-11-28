-- ==================================================
-- Project Mortal Warcraft
-- Feature: Caravan Upgrades
-- Description: Upgradeable caravan components
-- Spec: 13-caravans-contracts.md
-- ==================================================

-- Caravan upgrade definitions
CREATE TABLE IF NOT EXISTS `mortal_caravan_upgrades` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `upgrade_name` VARCHAR(100) NOT NULL,
    `upgrade_type` VARCHAR(50) NOT NULL COMMENT 'wheels, armor, animals, lantern, decoy',
    `item_entry` INT UNSIGNED NOT NULL COMMENT 'BPC item entry',
    `stat_modifier` VARCHAR(100) NOT NULL COMMENT 'JSON: {speed: 1.1, armor: 50, etc}',
    `description` TEXT,
    `created_at` INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_upgrade_name` (`upgrade_name`),
    KEY `idx_type` (`upgrade_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Character caravan upgrades (owned)
CREATE TABLE IF NOT EXISTS `mortal_character_caravan_upgrades` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `guid` INT UNSIGNED NOT NULL,
    `upgrade_id` INT UNSIGNED NOT NULL,
    `caravan_id` INT UNSIGNED DEFAULT NULL COMMENT 'NULL = not installed, otherwise caravan ID',
    `acquired_at` INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_guid` (`guid`),
    KEY `idx_upgrade` (`upgrade_id`),
    KEY `idx_caravan` (`caravan_id`),
    FOREIGN KEY (`upgrade_id`) REFERENCES `mortal_caravan_upgrades` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert default upgrades
INSERT INTO `mortal_caravan_upgrades` (`upgrade_name`, `upgrade_type`, `item_entry`, `stat_modifier`, `description`) VALUES
('Reinforced Wheels', 'wheels', 900040, '{"speed": 1.1, "durability": 1.2}', 'Increases caravan speed by 10% and durability by 20%'),
('Heavy Armor Plating', 'armor', 900041, '{"armor": 100, "health": 1.5}', 'Increases caravan armor by 100 and health by 50%'),
('Swift Pack Animals', 'animals', 900042, '{"speed": 1.15, "capacity": 1.1}', 'Increases caravan speed by 15% and capacity by 10%'),
('Magical Lantern', 'lantern', 900043, '{"visibility": 1.3, "ambush_chance": 0.8}', 'Increases visibility by 30% and reduces ambush chance by 20%'),
('Decoy Wagon', 'decoy', 900044, '{"decoy": true}', 'Consumable item that creates a fake caravan to confuse attackers');

