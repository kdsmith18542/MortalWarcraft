-- ============================================
-- MORTAL REGIONAL VENDOR SYSTEM
-- ============================================
-- File: 136_regional_vendor_mappings.sql
-- Description: Regional vendor mappings and mail restriction rules
-- ============================================

-- ============================================
-- REGIONAL VENDOR MAPPINGS
-- ============================================

-- Map vendors to regions
CREATE TABLE IF NOT EXISTS `mortal_vendor_regions` (
    `vendor_entry` INT PRIMARY KEY COMMENT 'NPC entry ID (FK to creature_template.entry)',
    `region_id` INT NOT NULL COMMENT 'Region identifier (1=Eastern Kingdoms, 2=Kalimdor, etc.)',
    `vendor_type` VARCHAR(32) NOT NULL COMMENT 'Type of vendor (general, weapon, armor, food, repair, reagent, mount, pet, banker)',
    `access_restriction` TINYINT NOT NULL DEFAULT 0 COMMENT '0=all players, 1=criminals only, 2=outlaws only, 3=green zones only, 4=yellow zones only, 5=red zones only',
    `zone_restriction` SMALLINT UNSIGNED DEFAULT NULL COMMENT 'Specific zone ID restriction (NULL = region-wide)',
    `notoriety_min` INT DEFAULT NULL COMMENT 'Minimum notoriety required (NULL = no requirement)',
    `notoriety_max` INT DEFAULT NULL COMMENT 'Maximum notoriety allowed (NULL = no limit)',
    `notes` VARCHAR(255) NULL COMMENT 'Additional notes about this vendor',
    INDEX `idx_region` (`region_id`),
    INDEX `idx_type` (`vendor_type`),
    INDEX `idx_zone` (`zone_restriction`),
    CONSTRAINT `fk_vendor_regions_entry` FOREIGN KEY (`vendor_entry`)
        REFERENCES `creature_template` (`entry`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Maps vendors to regions and defines access restrictions';

-- ============================================
-- MAIL RESTRICTION RULES
-- ============================================

-- Mail restriction rules by zone and region
CREATE TABLE IF NOT EXISTS `mortal_mail_restrictions` (
    `rule_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `source_zone_id` SMALLINT UNSIGNED NOT NULL COMMENT 'Source zone ID',
    `source_region_id` INT NOT NULL COMMENT 'Source region ID',
    `dest_zone_id` SMALLINT UNSIGNED DEFAULT NULL COMMENT 'Destination zone ID (NULL = any zone)',
    `dest_region_id` INT DEFAULT NULL COMMENT 'Destination region ID (NULL = any region)',
    `restriction_type` TINYINT NOT NULL DEFAULT 0 COMMENT '0=allow, 1=deny, 2=allow_gold_only, 3=allow_messages_only',
    `notoriety_min` INT DEFAULT NULL COMMENT 'Minimum notoriety for this rule',
    `notoriety_max` INT DEFAULT NULL COMMENT 'Maximum notoriety for this rule',
    `active` TINYINT NOT NULL DEFAULT 1 COMMENT '1=active, 0=inactive',
    `notes` VARCHAR(255) NULL COMMENT 'Rule description',
    INDEX `idx_source_zone` (`source_zone_id`),
    INDEX `idx_source_region` (`source_region_id`),
    INDEX `idx_dest_zone` (`dest_zone_id`),
    INDEX `idx_dest_region` (`dest_region_id`),
    INDEX `idx_active` (`active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Mail restriction rules by zone and region';

-- ============================================
-- REGIONAL DEFINITIONS
-- ============================================

-- Region definitions for reference
CREATE TABLE IF NOT EXISTS `mortal_regions` (
    `region_id` INT PRIMARY KEY COMMENT 'Unique region identifier',
    `region_name` VARCHAR(64) NOT NULL COMMENT 'Human-readable region name',
    `continent_id` TINYINT NOT NULL COMMENT 'Continent (0=Eastern Kingdoms, 1=Kalimdor, 2=Outland, etc.)',
    `faction_preference` TINYINT DEFAULT NULL COMMENT '0=Alliance, 1=Horde, NULL=Neutral',
    `capital_zone_id` SMALLINT UNSIGNED DEFAULT NULL COMMENT 'Capital city zone ID',
    `description` VARCHAR(255) NULL COMMENT 'Region description'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Region definitions for the regional economy system';

-- ============================================
-- INITIAL DATA - REGIONS
-- ============================================

INSERT INTO `mortal_regions` (`region_id`, `region_name`, `continent_id`, `faction_preference`, `capital_zone_id`, `description`) VALUES
(1, 'Eastern Kingdoms Alliance', 0, 0, 1519, 'Alliance territories in Eastern Kingdoms'),
(2, 'Eastern Kingdoms Horde', 0, 1, 1637, 'Horde territories in Eastern Kingdoms'),
(3, 'Eastern Kingdoms Neutral', 0, NULL, 35, 'Neutral territories in Eastern Kingdoms'),
(4, 'Kalimdor Alliance', 1, 0, 1657, 'Alliance territories in Kalimdor'),
(5, 'Kalimdor Horde', 1, 1, 1638, 'Horde territories in Kalimdor'),
(6, 'Kalimdor Neutral', 1, NULL, 440, 'Neutral territories in Kalimdor'),
(7, 'Outland', 2, NULL, NULL, 'Outland territories'),
(8, 'Northrend', 3, NULL, NULL, 'Northrend territories'),
(9, 'Cataclysm', 4, NULL, NULL, 'Cataclysm expansion territories')
ON DUPLICATE KEY UPDATE
    `region_name` = VALUES(`region_name`),
    `continent_id` = VALUES(`continent_id`),
    `faction_preference` = VALUES(`faction_preference`),
    `capital_zone_id` = VALUES(`capital_zone_id`),
    `description` = VALUES(`description`);

-- ============================================
-- INITIAL DATA - MAIL RESTRICTIONS
-- ============================================

-- Default mail restrictions based on zone risk tiers
-- Green zones: Full mail within region
INSERT INTO `mortal_mail_restrictions` (`source_zone_id`, `source_region_id`, `dest_region_id`, `restriction_type`, `notes`) VALUES
-- Green zones can send mail within their region
(1519, 1, 1, 0, 'Stormwind (Green) - full mail within Eastern Kingdoms Alliance'),
(1537, 1, 1, 0, 'Ironforge (Green) - full mail within Eastern Kingdoms Alliance'),
(1657, 4, 4, 0, 'Darnassus (Green) - full mail within Kalimdor Alliance'),
(1637, 2, 2, 0, 'Orgrimmar (Green) - full mail within Eastern Kingdoms Horde'),
(1638, 5, 5, 0, 'Thunder Bluff (Green) - full mail within Kalimdor Horde'),
(1497, 2, 2, 0, 'Undercity (Green) - full mail within Eastern Kingdoms Horde'),
(35, 3, 3, 0, 'Booty Bay (Green) - full mail within Eastern Kingdoms Neutral'),
(440, 6, 6, 0, 'Gadgetzan (Green) - full mail within Kalimdor Neutral'),
(17, 6, 6, 0, 'Ratchet (Green) - full mail within Kalimdor Neutral');

-- Yellow zones: Can only send to Green zones in same region
-- Note: This is handled by the code logic, but we can add specific rules if needed

-- Red zones: No mail at all (restriction_type = 1 means deny)
-- Note: This is handled by the code logic, but we can add specific rules if needed

-- ============================================
-- INITIAL DATA - VENDOR MAPPINGS
-- ============================================

-- Major city vendors - Alliance
INSERT INTO `mortal_vendor_regions` (`vendor_entry`, `region_id`, `vendor_type`, `access_restriction`, `notes`) VALUES
-- Stormwind vendors
(12805, 1, 'general', 0, 'General goods vendor - Stormwind'),
(12806, 1, 'weapon', 0, 'Weapon vendor - Stormwind'),
(12807, 1, 'armor', 0, 'Armor vendor - Stormwind'),
(12808, 1, 'food', 0, 'Food vendor - Stormwind'),
(12809, 1, 'repair', 0, 'Repair vendor - Stormwind'),
(12810, 1, 'reagent', 0, 'Reagent vendor - Stormwind'),
(12811, 1, 'mount', 3, 'Mount vendor - Stormwind (Green zones only)'),
(12812, 1, 'pet', 3, 'Pet vendor - Stormwind (Green zones only)'),
(12813, 1, 'banker', 0, 'Banker - Stormwind'),

-- Ironforge vendors
(12814, 1, 'general', 0, 'General goods vendor - Ironforge'),
(12815, 1, 'weapon', 0, 'Weapon vendor - Ironforge'),
(12816, 1, 'armor', 0, 'Armor vendor - Ironforge'),
(12817, 1, 'food', 0, 'Food vendor - Ironforge'),
(12818, 1, 'repair', 0, 'Repair vendor - Ironforge'),
(12819, 1, 'reagent', 0, 'Reagent vendor - Ironforge'),
(12820, 1, 'mount', 3, 'Mount vendor - Ironforge (Green zones only)'),
(12821, 1, 'pet', 3, 'Pet vendor - Ironforge (Green zones only)'),
(12822, 1, 'banker', 0, 'Banker - Ironforge'),

-- Darnassus vendors
(12823, 4, 'general', 0, 'General goods vendor - Darnassus'),
(12824, 4, 'weapon', 0, 'Weapon vendor - Darnassus'),
(12825, 4, 'armor', 0, 'Armor vendor - Darnassus'),
(12826, 4, 'food', 0, 'Food vendor - Darnassus'),
(12827, 4, 'repair', 0, 'Repair vendor - Darnassus'),
(12828, 4, 'reagent', 0, 'Reagent vendor - Darnassus'),
(12829, 4, 'mount', 3, 'Mount vendor - Darnassus (Green zones only)'),
(12830, 4, 'pet', 3, 'Pet vendor - Darnassus (Green zones only)'),
(12831, 4, 'banker', 0, 'Banker - Darnassus'),

-- Horde vendors - Orgrimmar
(12832, 2, 'general', 0, 'General goods vendor - Orgrimmar'),
(12833, 2, 'weapon', 0, 'Weapon vendor - Orgrimmar'),
(12834, 2, 'armor', 0, 'Armor vendor - Orgrimmar'),
(12835, 2, 'food', 0, 'Food vendor - Orgrimmar'),
(12836, 2, 'repair', 0, 'Repair vendor - Orgrimmar'),
(12837, 2, 'reagent', 0, 'Reagent vendor - Orgrimmar'),
(12838, 2, 'mount', 3, 'Mount vendor - Orgrimmar (Green zones only)'),
(12839, 2, 'pet', 3, 'Pet vendor - Orgrimmar (Green zones only)'),
(12840, 2, 'banker', 0, 'Banker - Orgrimmar'),

-- Thunder Bluff vendors
(12841, 5, 'general', 0, 'General goods vendor - Thunder Bluff'),
(12842, 5, 'weapon', 0, 'Weapon vendor - Thunder Bluff'),
(12843, 5, 'armor', 0, 'Armor vendor - Thunder Bluff'),
(12844, 5, 'food', 0, 'Food vendor - Thunder Bluff'),
(12845, 5, 'repair', 0, 'Repair vendor - Thunder Bluff'),
(12846, 5, 'reagent', 0, 'Reagent vendor - Thunder Bluff'),
(12847, 5, 'mount', 3, 'Mount vendor - Thunder Bluff (Green zones only)'),
(12848, 5, 'pet', 3, 'Pet vendor - Thunder Bluff (Green zones only)'),
(12849, 5, 'banker', 0, 'Banker - Thunder Bluff'),

-- Undercity vendors
(12850, 2, 'general', 0, 'General goods vendor - Undercity'),
(12851, 2, 'weapon', 0, 'Weapon vendor - Undercity'),
(12852, 2, 'armor', 0, 'Armor vendor - Undercity'),
(12853, 2, 'food', 0, 'Food vendor - Undercity'),
(12854, 2, 'repair', 0, 'Repair vendor - Undercity'),
(12855, 2, 'reagent', 0, 'Reagent vendor - Undercity'),
(12856, 2, 'mount', 3, 'Mount vendor - Undercity (Green zones only)'),
(12857, 2, 'pet', 3, 'Pet vendor - Undercity (Green zones only)'),
(12858, 2, 'banker', 0, 'Banker - Undercity'),

-- Neutral vendors - Booty Bay
(12859, 3, 'general', 0, 'General goods vendor - Booty Bay'),
(12860, 3, 'weapon', 0, 'Weapon vendor - Booty Bay'),
(12861, 3, 'armor', 0, 'Armor vendor - Booty Bay'),
(12862, 3, 'food', 0, 'Food vendor - Booty Bay'),
(12863, 3, 'repair', 0, 'Repair vendor - Booty Bay'),
(12864, 3, 'reagent', 0, 'Reagent vendor - Booty Bay'),
(12865, 3, 'banker', 0, 'Banker - Booty Bay'),

-- Neutral vendors - Gadgetzan
(12866, 6, 'general', 0, 'General goods vendor - Gadgetzan'),
(12867, 6, 'weapon', 0, 'Weapon vendor - Gadgetzan'),
(12868, 6, 'armor', 0, 'Armor vendor - Gadgetzan'),
(12869, 6, 'food', 0, 'Food vendor - Gadgetzan'),
(12870, 6, 'repair', 0, 'Repair vendor - Gadgetzan'),
(12871, 6, 'reagent', 0, 'Reagent vendor - Gadgetzan'),
(12872, 6, 'banker', 0, 'Banker - Gadgetzan'),

-- Neutral vendors - Ratchet
(12873, 6, 'general', 0, 'General goods vendor - Ratchet'),
(12874, 6, 'weapon', 0, 'Weapon vendor - Ratchet'),
(12875, 6, 'armor', 0, 'Armor vendor - Ratchet'),
(12876, 6, 'food', 0, 'Food vendor - Ratchet'),
(12877, 6, 'repair', 0, 'Repair vendor - Ratchet'),
(12878, 6, 'reagent', 0, 'Reagent vendor - Ratchet'),
(12879, 6, 'banker', 0, 'Banker - Ratchet')

ON DUPLICATE KEY UPDATE
    `region_id` = VALUES(`region_id`),
    `vendor_type` = VALUES(`vendor_type`),
    `access_restriction` = VALUES(`access_restriction`),
    `notes` = VALUES(`notes`);

-- Outlaw vendors (Red zones only, access_restriction = 5)
INSERT INTO `mortal_vendor_regions` (`vendor_entry`, `region_id`, `vendor_type`, `access_restriction`, `notes`) VALUES
(12900, 1, 'fence', 5, 'Fence vendor - Red zones only (Alliance territories)'),
(12901, 2, 'fence', 5, 'Fence vendor - Red zones only (Horde territories)'),
(12902, 3, 'fence', 5, 'Fence vendor - Red zones only (Neutral territories)'),
(12903, 4, 'fence', 5, 'Fence vendor - Red zones only (Kalimdor Alliance)'),
(12904, 5, 'fence', 5, 'Fence vendor - Red zones only (Kalimdor Horde)'),
(12905, 6, 'fence', 5, 'Fence vendor - Red zones only (Kalimdor Neutral)')
ON DUPLICATE KEY UPDATE
    `region_id` = VALUES(`region_id`),
    `vendor_type` = VALUES(`vendor_type`),
    `access_restriction` = VALUES(`access_restriction`),
    `notes` = VALUES(`notes`);

-- Criminal vendors (Yellow zones, access_restriction = 1)
INSERT INTO `mortal_vendor_regions` (`vendor_entry`, `region_id`, `vendor_type`, `access_restriction`, `notes`) VALUES
(12910, 1, 'criminal', 1, 'Criminal vendor - Yellow zones (Alliance territories)'),
(12911, 2, 'criminal', 1, 'Criminal vendor - Yellow zones (Horde territories)'),
(12912, 3, 'criminal', 1, 'Criminal vendor - Yellow zones (Neutral territories)')
ON DUPLICATE KEY UPDATE
    `region_id` = VALUES(`region_id`),
    `vendor_type` = VALUES(`vendor_type`),
    `access_restriction` = VALUES(`access_restriction`),
    `notes` = VALUES(`notes`);