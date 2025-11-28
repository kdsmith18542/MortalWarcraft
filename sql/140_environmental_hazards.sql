-- ==================================================
-- Project Mortal Warcraft
-- Feature: Environmental Hazards System
-- Description: Defines environmental hazard zones with effects
-- Based on spec 03-risk-zones.md section 7.1
-- ==================================================

-- Environmental Hazards Table
CREATE TABLE IF NOT EXISTS `mortal_environmental_hazards` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `zone_id` INT UNSIGNED NOT NULL,
    `hazard_type` VARCHAR(50) NOT NULL COMMENT 'poison_swamp, volcanic_ash, radiation_pocket, frostbite',
    `effect_spell_id` INT UNSIGNED NOT NULL COMMENT 'Spell ID for the hazard effect',
    `trigger_radius` FLOAT NOT NULL DEFAULT 10.0 COMMENT 'Radius to trigger hazard effect',
    `damage_interval` INT UNSIGNED NOT NULL DEFAULT 2000 COMMENT 'Damage tick interval in milliseconds',
    `damage_amount` INT UNSIGNED NOT NULL DEFAULT 100 COMMENT 'Base damage per tick',
    `movement_penalty` FLOAT NOT NULL DEFAULT 0.0 COMMENT 'Movement speed reduction (0.0-1.0)',
    `description` VARCHAR(255) NOT NULL,
    `is_active` TINYINT(1) NOT NULL DEFAULT 1,
    INDEX `idx_zone_hazard` (`zone_id`, `hazard_type`),
    INDEX `idx_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert Environmental Hazards Data

-- Poison Swamps (Swamp of Sorrows)
INSERT INTO `mortal_environmental_hazards` (`zone_id`, `hazard_type`, `effect_spell_id`, `trigger_radius`, `damage_interval`, `damage_amount`, `movement_penalty`, `description`, `is_active`) VALUES
(8, 'poison_swamp', 3427, 15.0, 3000, 50, 0.1, 'Toxic swamp gases cause poison damage and slow movement', 1);

-- Volcanic Ash (Burning Steppes)
INSERT INTO `mortal_environmental_hazards` (`zone_id`, `hazard_type`, `effect_spell_id`, `trigger_radius`, `damage_interval`, `damage_amount`, `movement_penalty`, `description`, `is_active`) VALUES
(46, 'volcanic_ash', 3809, 20.0, 4000, 75, 0.15, 'Volcanic ash clouds reduce visibility and cause fire damage', 1);

-- Radiation Pockets (Silithus)
INSERT INTO `mortal_environmental_hazards` (`zone_id`, `hazard_type`, `effect_spell_id`, `trigger_radius`, `damage_interval`, `damage_amount`, `movement_penalty`, `description`, `is_active`) VALUES
(1377, 'radiation_pocket', 5413, 12.0, 2500, 100, 0.2, 'Radioactive anomalies cause radiation sickness and severe movement impairment', 1);

-- Frostbite (Winterspring)
INSERT INTO `mortal_environmental_hazards` (`zone_id`, `hazard_type`, `effect_spell_id`, `trigger_radius`, `damage_interval`, `damage_amount`, `movement_penalty`, `description`, `is_active`) VALUES
(618, 'frostbite', 12484, 18.0, 3500, 60, 0.12, 'Extreme cold causes frostbite damage and chills movement', 1);

-- Additional hazard zones for Red zones
-- Eastern Plaguelands - Plague effects
INSERT INTO `mortal_environmental_hazards` (`zone_id`, `hazard_type`, `effect_spell_id`, `trigger_radius`, `damage_interval`, `damage_amount`, `movement_penalty`, `description`, `is_active`) VALUES
(139, 'plague_cloud', 3427, 25.0, 5000, 40, 0.05, 'Lingering plague clouds from the Scourge invasion', 1);

-- Blasted Lands - Fel energy
INSERT INTO `mortal_environmental_hazards` (`zone_id`, `hazard_type`, `effect_spell_id`, `trigger_radius`, `damage_interval`, `damage_amount`, `movement_penalty`, `description`, `is_active`) VALUES
(4, 'fel_corruption', 17205, 22.0, 4500, 80, 0.08, 'Fel energy corruption from the Dark Portal rift', 1);

-- Stranglethorn Vale - Jungle hazards
INSERT INTO `mortal_environmental_hazards` (`zone_id`, `hazard_type`, `effect_spell_id`, `trigger_radius`, `damage_interval`, `damage_amount`, `movement_penalty`, `description`, `is_active`) VALUES
(33, 'jungle_fever', 3427, 16.0, 6000, 30, 0.03, 'Tropical diseases and insect swarms in the dense jungle', 1);

ON DUPLICATE KEY UPDATE
    `effect_spell_id` = VALUES(`effect_spell_id`),
    `trigger_radius` = VALUES(`trigger_radius`),
    `damage_interval` = VALUES(`damage_interval`),
    `damage_amount` = VALUES(`damage_amount`),
    `movement_penalty` = VALUES(`movement_penalty`),
    `description` = VALUES(`description`),
    `is_active` = VALUES(`is_active`);