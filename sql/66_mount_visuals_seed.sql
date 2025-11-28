-- ==================================================
-- Project Mortal Warcraft: Mount Visuals Seed Data
-- Feature: Initial mount data for mortal_mount_visuals table
-- Based on: docs/specs/28-mounts-living-system-and-mapping.md
-- ==================================================

-- NOTE: This requires mortal_mount_visuals table from 65_mortal_core_registry_tables.sql
-- NOTE: Item entries use range 720000-729999 per spec 31-mortal-core-registry.md

START TRANSACTION;

-- Check if table exists
SET @has_table := (
    SELECT COUNT(*)
    FROM information_schema.TABLES
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'mortal_mount_visuals'
);

SET @sql_insert = IF(@has_table > 0,
    'INSERT INTO `mortal_mount_visuals` 
    (`mortal_item_entry`, `mortal_mount_tier`, `speed_multiplier`, `capacity_slots`, 
     `source_item_entry`, `source_spell_id`, `source_creature_id`, `notes`) VALUES
    -- M-M1: Pack Beasts (slow, high capacity)
    (720001, ''M-M1'', 0.6, 8, 12302, 580, 0, ''Pack Kodo - Heavy transport mount''),
    (720002, ''M-M1'', 0.6, 10, 12303, 6653, 0, ''Pack Ram - Dwarven transport mount''),
    
    -- M-M2: Riding Mounts (standard speed, minimal capacity)
    (720101, ''M-M2'', 1.0, 4, 12330, 458, 0, ''Brown Horse - Standard riding mount''),
    (720102, ''M-M2'', 1.0, 4, 12351, 6648, 0, ''Chestnut Mare - Standard riding mount''),
    (720103, ''M-M2'', 1.0, 4, 12353, 472, 0, ''Pinto - Standard riding mount''),
    (720104, ''M-M2'', 1.0, 4, 12354, 470, 0, ''Black Stallion - Standard riding mount''),
    
    -- M-M3: War Mounts (fast, combat-focused)
    (720201, ''M-M3'', 1.2, 2, 13328, 23227, 0, ''Swift Palomino - War mount''),
    (720202, ''M-M3'', 1.2, 2, 13329, 23228, 0, ''Swift White Steed - War mount''),
    (720203, ''M-M3'', 1.2, 2, 13334, 23229, 0, ''Swift Brown Steed - War mount''),
    (720204, ''M-M3'', 1.15, 2, 13335, 23238, 0, ''Swift Gray Ram - War mount''),
    (720205, ''M-M3'', 1.15, 2, 13331, 23239, 0, ''Swift Blue Raptor - War mount''),
    
    -- M-M4: Prestige/Elite (very fast, minimal capacity, prestige)
    (720301, ''M-M4'', 1.3, 2, 13326, 23250, 0, ''Swift Razzashi Raptor - Prestige mount''),
    (720302, ''M-M4'', 1.3, 2, 13327, 23252, 0, ''Swift Zulian Tiger - Prestige mount''),
    (720303, ''M-M4'', 1.25, 2, 13333, 23241, 0, ''Swift Mistsaber - Prestige mount''),
    (720304, ''M-M4'', 1.3, 2, 13332, 23242, 0, ''Swift Frostsaber - Prestige mount'')
    ON DUPLICATE KEY UPDATE 
        `mortal_mount_tier` = VALUES(`mortal_mount_tier`),
        `speed_multiplier` = VALUES(`speed_multiplier`),
        `capacity_slots` = VALUES(`capacity_slots`);',
    'SELECT ''mortal_mount_visuals table not found. Run 65_mortal_core_registry_tables.sql first.'' AS result;');

PREPARE stmt_insert FROM @sql_insert;
EXECUTE stmt_insert;
DEALLOCATE PREPARE stmt_insert;

COMMIT;

SELECT CASE
    WHEN @has_table > 0 THEN 'Mount visuals seed data inserted successfully (16 mounts).'
    ELSE 'mortal_mount_visuals table not found. Run 65_mortal_core_registry_tables.sql first.'
END AS result;

SELECT 'NOTE: You still need to create the actual item_template entries for these mount items (720001-720304).' AS result;
SELECT 'NOTE: Source item/spell IDs are examples - verify against your WotLK 3.3.5a database.' AS result;

