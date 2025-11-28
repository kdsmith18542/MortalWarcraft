-- ==================================================
-- Project Mortal Warcraft
-- Feature: Material Properties
-- Description: Material property definitions for crafting
-- Spec: 10-crafting-economy.md
-- ==================================================

-- Material families and their properties
CREATE TABLE IF NOT EXISTS `mortal_material_properties` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `material_name` VARCHAR(100) NOT NULL,
    `material_family` VARCHAR(50) NOT NULL COMMENT 'Metals, Woods, Leathers, Fabrics, MagicalEssences',
    `hardness` TINYINT UNSIGNED NOT NULL DEFAULT 50 COMMENT '0-100',
    `flexibility` TINYINT UNSIGNED NOT NULL DEFAULT 50 COMMENT '0-100',
    `weight` TINYINT UNSIGNED NOT NULL DEFAULT 50 COMMENT '0-100',
    `conductivity` TINYINT UNSIGNED NOT NULL DEFAULT 50 COMMENT '0-100',
    `purity` TINYINT UNSIGNED NOT NULL DEFAULT 50 COMMENT '0-100',
    `tier` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Material tier (1-5)',
    `created_at` INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_material_name` (`material_name`),
    KEY `idx_family` (`material_family`),
    KEY `idx_tier` (`tier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert material properties
INSERT INTO `mortal_material_properties` (`material_name`, `material_family`, `hardness`, `flexibility`, `weight`, `conductivity`, `purity`, `tier`) VALUES
-- Metals
('Copper', 'Metals', 30, 60, 70, 90, 50, 1),
('Tin', 'Metals', 25, 55, 65, 85, 45, 1),
('Iron', 'Metals', 70, 40, 80, 60, 60, 2),
('Steel', 'Metals', 85, 35, 85, 50, 75, 3),
('Mithril', 'Metals', 60, 70, 50, 40, 85, 4),
('Thorium', 'Metals', 90, 30, 90, 30, 90, 4),
('Elementium', 'Metals', 95, 25, 95, 20, 95, 5),

-- Woods
('Softwood', 'Woods', 20, 80, 30, 10, 40, 1),
('Hardwood', 'Woods', 50, 60, 50, 15, 60, 2),
('Heartwood', 'Woods', 70, 50, 60, 20, 75, 3),
('Dreamwood', 'Woods', 60, 70, 40, 80, 90, 4),

-- Leathers
('Light Hide', 'Leathers', 30, 90, 20, 5, 50, 1),
('Medium Hide', 'Leathers', 50, 80, 40, 5, 60, 2),
('Heavy Hide', 'Leathers', 70, 70, 60, 5, 70, 3),
('Demon Hide', 'Leathers', 80, 60, 70, 10, 85, 4),

-- Fabrics
('Linen', 'Fabrics', 10, 95, 10, 5, 40, 1),
('Silk', 'Fabrics', 20, 90, 15, 5, 60, 2),
('Dreamcloth', 'Fabrics', 30, 85, 20, 70, 90, 4),

-- Magical Essences
('Fire Essence', 'MagicalEssences', 80, 20, 30, 100, 70, 3),
('Frost Essence', 'MagicalEssences', 70, 30, 40, 90, 70, 3),
('Shadow Essence', 'MagicalEssences', 60, 40, 50, 80, 75, 3),
('Dream Essence', 'MagicalEssences', 50, 50, 20, 95, 90, 4);

