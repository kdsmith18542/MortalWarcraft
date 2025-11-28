-- ==================================================
-- Project Mortal Warcraft
-- Feature: First Aid Item Templates
-- Description: Creates item templates for bandages, dressings, splints, antidotes
-- Based on: docs/specs/50-lifeskills-fishing-and-first-aid.md
-- ==================================================

-- Simple Bandage (Field Medicine - Out of Combat)
-- Restores 15% HP over 10 seconds, out of combat only
INSERT INTO `item_template` (`entry`, `class`, `subclass`, `name`, `displayid`, `Quality`, `Flags`, `BuyCount`, `BuyPrice`, `SellPrice`, `InventoryType`, `AllowableClass`, `AllowableRace`, `ItemLevel`, `RequiredLevel`, `stackable`, `bonding`, `description`, `Material`, `ScriptName`) VALUES
(900700, 0, 0, 'Simple Bandage', 13262, 1, 0, 1, 50, 5, 0, -1, -1, 1, 0, 20, 0, 'Restores 15% HP over 10 seconds. Out of combat only.', -1, 'item_first_aid')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `description` = VALUES(`description`);

-- Combat Dressing (Trauma Care - In Combat)
-- Removes bleed effects, small instant heal, usable in combat
INSERT INTO `item_template` (`entry`, `class`, `subclass`, `name`, `displayid`, `Quality`, `Flags`, `BuyCount`, `BuyPrice`, `SellPrice`, `InventoryType`, `AllowableClass`, `AllowableRace`, `ItemLevel`, `RequiredLevel`, `stackable`, `bonding`, `description`, `Material`, `ScriptName`) VALUES
(900701, 0, 0, 'Combat Dressing', 13262, 2, 0, 1, 200, 20, 0, -1, -1, 1, 0, 10, 0, 'Removes bleed effects and restores 200 HP. Usable in combat.', -1, 'item_first_aid')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `description` = VALUES(`description`);

-- Splint (Trauma Care - Movement Debuff)
-- Removes or downgrades movement debuffs
INSERT INTO `item_template` (`entry`, `class`, `subclass`, `name`, `displayid`, `Quality`, `Flags`, `BuyCount`, `BuyPrice`, `SellPrice`, `InventoryType`, `AllowableClass`, `AllowableRace`, `ItemLevel`, `RequiredLevel`, `stackable`, `bonding`, `description`, `Material`, `ScriptName`) VALUES
(900702, 0, 0, 'Splint', 13262, 2, 0, 1, 150, 15, 0, -1, -1, 1, 0, 10, 0, 'Removes or downgrades movement debuffs. Out of combat only.', -1, 'item_first_aid')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `description` = VALUES(`description`);

-- Antidote (Toxicology - Poison/Disease)
-- Removes poison and disease effects
INSERT INTO `item_template` (`entry`, `class`, `subclass`, `name`, `displayid`, `Quality`, `Flags`, `BuyCount`, `BuyPrice`, `SellPrice`, `InventoryType`, `AllowableClass`, `AllowableRace`, `ItemLevel`, `RequiredLevel`, `stackable`, `bonding`, `description`, `Material`, `ScriptName`) VALUES
(900703, 0, 0, 'Antidote', 13262, 2, 0, 1, 180, 18, 0, -1, -1, 1, 0, 10, 0, 'Removes poison and disease effects. Usable in combat.', -1, 'item_first_aid')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `description` = VALUES(`description`);

-- Register items in mortal_first_aid_items
INSERT INTO `mortal_first_aid_items` (`item_entry`, `item_name`, `skill_line`, `use_type`, `hp_restore_pct`, `channel_time_ms`, `cooldown_ms`, `requires_combat`, `breaks_on_damage`, `skill_required`, `notes`) VALUES
(900700, 'Simple Bandage', 'FIELD_MEDICINE', 'BANDAGE', 0.15, 10000, 0, 0, 1, 0, 'Restores 15% HP over 10 seconds, out of combat only'),
(900701, 'Combat Dressing', 'TRAUMA_CARE', 'COMBAT_DRESSING', 0.0, 3000, 30000, 1, 0, 50, 'Removes bleed effects, small instant heal, usable in combat'),
(900702, 'Splint', 'TRAUMA_CARE', 'SPLINT', 0.0, 5000, 60000, 0, 1, 100, 'Removes or downgrades movement debuffs'),
(900703, 'Antidote', 'TOXICOLOGY', 'ANTIDOTE', 0.0, 2000, 45000, 1, 0, 75, 'Removes poison and disease effects')
ON DUPLICATE KEY UPDATE `item_name` = VALUES(`item_name`), `notes` = VALUES(`notes`);

-- Summary
SELECT 
    'First Aid Items Created' as summary,
    COUNT(*) as total_items
FROM mortal_first_aid_items WHERE item_entry >= 900700;
