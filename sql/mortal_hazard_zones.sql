-- ==================================================
-- Project Mortal Warcraft
-- Feature: Environmental Hazard Zones System
-- Description: Defines environmental hazard zones with effects
-- Based on spec 03-risk-zones.md section 7.1
-- ==================================================

-- Hazard Zones Table
CREATE TABLE IF NOT EXISTS `mortal_hazard_zones` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `zone_id` INT UNSIGNED NOT NULL COMMENT 'Zone ID where hazard is located',
    `hazard_type` TINYINT UNSIGNED NOT NULL COMMENT '1=Poison Swamp, 2=Volcanic Ash, 3=Radiation, 4=Frostbite',
    `x` FLOAT NOT NULL COMMENT 'X coordinate of hazard center',
    `y` FLOAT NOT NULL COMMENT 'Y coordinate of hazard center',
    `z` FLOAT NOT NULL COMMENT 'Z coordinate of hazard center',
    `radius` FLOAT NOT NULL COMMENT 'Radius of hazard effect area',
    `spell_id` INT UNSIGNED NOT NULL COMMENT 'Spell ID for hazard effect',
    `description` VARCHAR(255) NOT NULL COMMENT 'Description of the hazard',
    `active` TINYINT(1) NOT NULL DEFAULT 1 COMMENT 'Whether hazard is active',
    INDEX `idx_zone_hazard` (`zone_id`, `hazard_type`),
    INDEX `idx_active` (`active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert default hazard zones based on spec 03-risk-zones.md section 7.1

-- Swamp of Sorrows - Poison Swamps
INSERT INTO `mortal_hazard_zones` (`zone_id`, `hazard_type`, `x`, `y`, `z`, `radius`, `spell_id`, `description`, `active`) VALUES
(8, 1, -1050.0, -2480.0, 50.0, 200.0, 30108, 'Toxic swamp waters that poison those who linger', 1),
(8, 1, -800.0, -2200.0, 45.0, 150.0, 30108, 'Corrosive marsh gases in the southern swamps', 1),
(8, 1, -1200.0, -2800.0, 55.0, 180.0, 30108, 'Poisonous algae blooms in stagnant waters', 1);

-- Burning Steppes - Volcanic Ash
INSERT INTO `mortal_hazard_zones` (`zone_id`, `hazard_type`, `x`, `y`, `z`, `radius`, `spell_id`, `description`, `active`) VALUES
(46, 2, -8000.0, -2500.0, 150.0, 300.0, 28423, 'Ash from active volcanoes chokes the air', 1),
(46, 2, -8200.0, -2200.0, 140.0, 250.0, 28423, 'Sulfurous fumes from lava flows', 1),
(46, 2, -7800.0, -2800.0, 160.0, 220.0, 28423, 'Volcanic ash clouds from recent eruptions', 1);

-- Silithus - Radiation Pockets
INSERT INTO `mortal_hazard_zones` (`zone_id`, `hazard_type`, `x`, `y`, `z`, `radius`, `spell_id`, `description`, `active`) VALUES
(1377, 3, -6800.0, 800.0, 10.0, 150.0, 30098, 'Residual radiation from ancient battles', 1),
(1377, 3, -6500.0, 600.0, 8.0, 120.0, 30098, 'Radioactive crystal formations', 1),
(1377, 3, -7100.0, 1000.0, 12.0, 180.0, 30098, 'Tainted sands from the Scarab War', 1);

-- Winterspring - Frostbite
INSERT INTO `mortal_hazard_zones` (`zone_id`, `hazard_type`, `x`, `y`, `z`, `radius`, `spell_id`, `description`, `active`) VALUES
(618, 4, 6700.0, -4400.0, 700.0, 250.0, 12497, 'Extreme cold that freezes exposed skin', 1),
(618, 4, 6900.0, -4200.0, 720.0, 200.0, 12497, 'Blizzard conditions in mountain passes', 1),
(618, 4, 6500.0, -4600.0, 680.0, 220.0, 12497, 'Frozen winds from the Storm Peaks', 1);

-- Additional hazard zones for other Red zones

-- Eastern Plaguelands - Radiation (post-Scourge contamination)
INSERT INTO `mortal_hazard_zones` (`zone_id`, `hazard_type`, `x`, `y`, `z`, `radius`, `spell_id`, `description`, `active`) VALUES
(139, 3, 1800.0, -5300.0, 90.0, 300.0, 30098, 'Residual plague radiation in contaminated areas', 1),
(139, 3, 2200.0, -5100.0, 85.0, 250.0, 30098, 'Toxic waste from plague experiments', 1);

-- Stranglethorn Vale - Poison (jungle toxins)
INSERT INTO `mortal_hazard_zones` (`zone_id`, `hazard_type`, `x`, `y`, `z`, `radius`, `spell_id`, `description`, `active`) VALUES
(33, 1, -14000.0, -1000.0, 20.0, 200.0, 30108, 'Venomous jungle plants and insects', 1),
(33, 1, -13800.0, -800.0, 15.0, 180.0, 30108, 'Toxic river waters in the jungle interior', 1);

-- Blasted Lands - Volcanic Ash (Dark Portal fallout)
INSERT INTO `mortal_hazard_zones` (`zone_id`, `hazard_type`, `x`, `y`, `z`, `radius`, `spell_id`, `description`, `active`) VALUES
(4, 2, -11200.0, -2700.0, 30.0, 250.0, 28423, 'Ash clouds from the Dark Portal rift', 1),
(4, 2, -11500.0, -2500.0, 25.0, 220.0, 28423, 'Sulfurous gases from dimensional tears', 1);

-- Icecrown - Frostbite (Scourge cold)
INSERT INTO `mortal_hazard_zones` (`zone_id`, `hazard_type`, `x`, `y`, `z`, `radius`, `spell_id`, `description`, `active`) VALUES
(210, 4, 8500.0, 800.0, 500.0, 400.0, 12497, 'Deathly cold from the Frozen Throne', 1),
(210, 4, 8000.0, 1000.0, 480.0, 350.0, 12497, 'Arctic winds from the Icecrown Glacier', 1);

ON DUPLICATE KEY UPDATE
    `zone_id` = VALUES(`zone_id`),
    `hazard_type` = VALUES(`hazard_type`),
    `x` = VALUES(`x`),
    `y` = VALUES(`y`),
    `z` = VALUES(`z`),
    `radius` = VALUES(`radius`),
    `spell_id` = VALUES(`spell_id`),
    `description` = VALUES(`description`),
    `active` = VALUES(`active`);