-- ==================================================
-- Project Mortal Warcraft
-- Feature: Endless Contract Definitions
-- Description: Populates endless contract definitions
-- Based on: docs/specs/54-endless-contracts-defense-and-survival.md
-- ==================================================

-- Defense Contract
INSERT INTO `mortal_endless_contracts` (`contract_code`, `name`, `description`, `contract_type`, `min_wave`, `max_wave`, `base_reward_xp`, `base_reward_gold`, `scaling_factor`, `is_active`) VALUES
('DEFENSE_BASE', 'Base Defense', 'Defend your base against waves of enemies', 'DEFENSE', 1, 50, 100, 50, 1.1, 1)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `description` = VALUES(`description`);

-- Survival Contract
INSERT INTO `mortal_endless_contracts` (`contract_code`, `name`, `description`, `contract_type`, `min_wave`, `max_wave`, `base_reward_xp`, `base_reward_gold`, `scaling_factor`, `is_active`) VALUES
('SURVIVAL_ARENA', 'Survival Arena', 'Survive as long as possible in an arena', 'SURVIVAL', 1, 100, 150, 75, 1.15, 1)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `description` = VALUES(`description`);

-- Wave Definitions for Defense Contract
INSERT INTO `mortal_endless_waves` (`contract_id`, `wave_number`, `creature_entry`, `creature_count`, `spawn_delay_seconds`, `notes`) VALUES
((SELECT id FROM mortal_endless_contracts WHERE contract_code = 'DEFENSE_BASE'), 1, 1, 5, 0, 'Wave 1: Basic enemies'),
((SELECT id FROM mortal_endless_contracts WHERE contract_code = 'DEFENSE_BASE'), 2, 1, 8, 10, 'Wave 2: More enemies'),
((SELECT id FROM mortal_endless_contracts WHERE contract_code = 'DEFENSE_BASE'), 3, 1, 10, 10, 'Wave 3: Increased difficulty'),
((SELECT id FROM mortal_endless_contracts WHERE contract_code = 'DEFENSE_BASE'), 5, 1, 15, 10, 'Wave 5: Boss wave'),
((SELECT id FROM mortal_endless_contracts WHERE contract_code = 'DEFENSE_BASE'), 10, 1, 20, 10, 'Wave 10: Major boss wave')
ON DUPLICATE KEY UPDATE `creature_count` = VALUES(`creature_count`), `notes` = VALUES(`notes`);

-- Wave Definitions for Survival Contract
INSERT INTO `mortal_endless_waves` (`contract_id`, `wave_number`, `creature_entry`, `creature_count`, `spawn_delay_seconds`, `notes`) VALUES
((SELECT id FROM mortal_endless_contracts WHERE contract_code = 'SURVIVAL_ARENA'), 1, 1, 3, 0, 'Wave 1: Starting enemies'),
((SELECT id FROM mortal_endless_contracts WHERE contract_code = 'SURVIVAL_ARENA'), 5, 1, 8, 15, 'Wave 5: Increased spawns'),
((SELECT id FROM mortal_endless_contracts WHERE contract_code = 'SURVIVAL_ARENA'), 10, 1, 12, 15, 'Wave 10: Boss spawn'),
((SELECT id FROM mortal_endless_contracts WHERE contract_code = 'SURVIVAL_ARENA'), 20, 1, 20, 15, 'Wave 20: Elite wave'),
((SELECT id FROM mortal_endless_contracts WHERE contract_code = 'SURVIVAL_ARENA'), 50, 1, 30, 15, 'Wave 50: Legendary wave')
ON DUPLICATE KEY UPDATE `creature_count` = VALUES(`creature_count`), `notes` = VALUES(`notes`);

-- Summary
SELECT 
    'Endless Contracts Created' as summary,
    COUNT(*) as total_contracts,
    COUNT(CASE WHEN contract_type = 'DEFENSE' THEN 1 END) as defense_contracts,
    COUNT(CASE WHEN contract_type = 'SURVIVAL' THEN 1 END) as survival_contracts
FROM mortal_endless_contracts
UNION ALL
SELECT 
    'Endless Waves Created' as summary,
    COUNT(*) as total_waves,
    0 as defense_contracts,
    0 as survival_contracts
FROM mortal_endless_waves;

