-- ==================================================
-- Mortal Warcraft – Faction Sanctum Instance Configs
-- Spec 60: Faction Sanctums
-- Target DB: world
-- ==================================================

-- Sanctum Instance Definitions
-- These would be custom instances or phased zones for each faction

-- Iron Ledger Trade Hall (Instance ID: 1000)
INSERT INTO `mortal_faction_sanctums` (`faction_tag`, `instance_id`, `entry_map`, `entry_x`, `entry_y`, `entry_z`, `entry_o`, `min_faction_tier`, `description`)
VALUES
('IRON_LEDGER', 1000, 0, -8823.0, 640.0, 94.0, 0.0, 1, 'Iron Ledger Trade Hall - A bustling marketplace and trading hub')
ON DUPLICATE KEY UPDATE
    `instance_id` = VALUES(`instance_id`),
    `entry_map` = VALUES(`entry_map`),
    `entry_x` = VALUES(`entry_x`),
    `entry_y` = VALUES(`entry_y`),
    `entry_z` = VALUES(`entry_z`),
    `entry_o` = VALUES(`entry_o`),
    `min_faction_tier` = VALUES(`min_faction_tier`),
    `description` = VALUES(`description`);

-- Order of the Shrine Chapel (Instance ID: 1001)
INSERT INTO `mortal_faction_sanctums` (`faction_tag`, `instance_id`, `entry_map`, `entry_x`, `entry_y`, `entry_z`, `entry_o`, `min_faction_tier`, `description`)
VALUES
('ORDER_SHRINE', 1001, 0, -8800.0, 620.0, 94.0, 0.0, 1, 'Order of the Shrine Chapel - A place of spiritual refuge and defense')
ON DUPLICATE KEY UPDATE
    `instance_id` = VALUES(`instance_id`),
    `entry_map` = VALUES(`entry_map`),
    `entry_x` = VALUES(`entry_x`),
    `entry_y` = VALUES(`entry_y`),
    `entry_z` = VALUES(`entry_z`),
    `entry_o` = VALUES(`entry_o`),
    `min_faction_tier` = VALUES(`min_faction_tier`),
    `description` = VALUES(`description`);

-- Black Sun Cartel Den (Instance ID: 1002)
INSERT INTO `mortal_faction_sanctums` (`faction_tag`, `instance_id`, `entry_map`, `entry_x`, `entry_y`, `entry_z`, `entry_o`, `min_faction_tier`, `description`)
VALUES
('BLACK_SUN_CARTEL', 1002, 0, -8850.0, 600.0, 94.0, 0.0, 1, 'Black Sun Cartel Den - A shadowy underworld hub')
ON DUPLICATE KEY UPDATE
    `instance_id` = VALUES(`instance_id`),
    `entry_map` = VALUES(`entry_map`),
    `entry_x` = VALUES(`entry_x`),
    `entry_y` = VALUES(`entry_y`),
    `entry_z` = VALUES(`entry_z`),
    `entry_o` = VALUES(`entry_o`),
    `min_faction_tier` = VALUES(`min_faction_tier`),
    `description` = VALUES(`description`);

-- Rangers' Pact Lodge (Instance ID: 1003)
INSERT INTO `mortal_faction_sanctums` (`faction_tag`, `instance_id`, `entry_map`, `entry_x`, `entry_y`, `entry_z`, `entry_o`, `min_faction_tier`, `description`)
VALUES
('RANGERS_PACT', 1003, 0, -8780.0, 660.0, 94.0, 0.0, 1, 'Rangers'' Pact Lodge - A wilderness outpost and scouting base')
ON DUPLICATE KEY UPDATE
    `instance_id` = VALUES(`instance_id`),
    `entry_map` = VALUES(`entry_map`),
    `entry_x` = VALUES(`entry_x`),
    `entry_y` = VALUES(`entry_y`),
    `entry_z` = VALUES(`entry_z`),
    `entry_o` = VALUES(`entry_o`),
    `min_faction_tier` = VALUES(`min_faction_tier`),
    `description` = VALUES(`description`);

-- Sanctum Vendor NPCs (would be spawned in instances)
-- These are placeholder NPC entries that would need to be created in creature_template

-- Iron Ledger Vendor (99970)
-- Order Shrine Vendor (99971)
-- Black Sun Vendor (99972)
-- Rangers' Pact Vendor (99973)

-- Sanctum Contract Boards (gameobjects)
-- These would be placed in each sanctum instance

-- Iron Ledger Contract Board (GO ID: 19990)
-- Order Shrine Contract Board (GO ID: 19991)
-- Black Sun Contract Board (GO ID: 19992)
-- Rangers' Pact Contract Board (GO ID: 19993)

