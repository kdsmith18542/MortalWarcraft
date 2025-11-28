-- ==================================================
-- Project Mortal Warcraft
-- Feature: Endless Contracts Population
-- Description: Populates endless contracts, waves, and enemy groups for defense and survival modes
-- Based on: docs/specs/54-endless-contracts-defense-and-survival.md
-- ==================================================

-- Enemy Groups for wave spawning
-- Each group_id has multiple spawn entries
INSERT INTO mortal_enemy_groups (id, creature_entry, count, spawn_x, spawn_y, spawn_z) VALUES
-- Group 1: Basic wolves (Green Zone)
(1, 1, 1, -100.0, -100.0, 0.0),
(1, 1, 1, -95.0, -105.0, 0.0),
(1, 1, 1, -105.0, -95.0, 0.0),
(1, 1, 1, -90.0, -110.0, 0.0),
(1, 1, 1, -110.0, -90.0, 0.0),
-- Group 2: Wolves with spiders (Yellow Zone)
(2, 1, 1, -100.0, -100.0, 0.0),
(2, 1, 1, -95.0, -105.0, 0.0),
(2, 30, 1, -105.0, -95.0, 0.0),
(2, 30, 1, -90.0, -110.0, 0.0),
-- Group 3: Mixed enemies with elites (Red Zone)
(3, 1, 1, -100.0, -100.0, 0.0),
(3, 30, 1, -95.0, -105.0, 0.0),
(3, 6, 1, -105.0, -95.0, 0.0), -- Elite bear
(3, 6, 1, -90.0, -110.0, 0.0),
-- Group 4: Undead horde (Survival Green)
(4, 3, 1, -100.0, -100.0, 0.0),
(4, 3, 1, -95.0, -105.0, 0.0),
(4, 3, 1, -105.0, -95.0, 0.0),
(4, 3, 1, -90.0, -110.0, 0.0),
(4, 3, 1, -110.0, -90.0, 0.0),
-- Group 5: Undead with ghouls (Survival Yellow)
(5, 3, 1, -100.0, -100.0, 0.0),
(5, 3, 1, -95.0, -105.0, 0.0),
(5, 3, 1, -105.0, -95.0, 0.0),
(5, 3, 1, -90.0, -110.0, 0.0),
(5, 3, 1, -110.0, -90.0, 0.0),
(5, 1502, 1, -85.0, -115.0, 0.0), -- Ghoul
-- Group 6: Undead army with bosses (Survival Red)
(6, 3, 1, -100.0, -100.0, 0.0),
(6, 3, 1, -95.0, -105.0, 0.0),
(6, 3, 1, -105.0, -95.0, 0.0),
(6, 3, 1, -90.0, -110.0, 0.0),
(6, 3, 1, -110.0, -90.0, 0.0),
(6, 1502, 1, -85.0, -115.0, 0.0),
(6, 1502, 1, -115.0, -85.0, 0.0),
(6, 10000, 1, -100.0, -100.0, 0.0), -- Boss placeholder
-- Group 7: Bandits (Defense Green)
(7, 100, 1, -100.0, -100.0, 0.0),
(7, 100, 1, -95.0, -105.0, 0.0),
(7, 100, 1, -105.0, -95.0, 0.0),
-- Group 8: Bandits with rogues (Defense Yellow)
(8, 100, 1, -100.0, -100.0, 0.0),
(8, 100, 1, -95.0, -105.0, 0.0),
(8, 100, 1, -105.0, -95.0, 0.0),
(8, 103, 1, -90.0, -110.0, 0.0), -- Rogue
-- Group 9: Bandit army (Defense Red)
(9, 100, 1, -100.0, -100.0, 0.0),
(9, 100, 1, -95.0, -105.0, 0.0),
(9, 100, 1, -105.0, -95.0, 0.0),
(9, 103, 1, -90.0, -110.0, 0.0),
(9, 103, 1, -110.0, -90.0, 0.0),
(9, 10001, 1, -100.0, -100.0, 0.0), -- Elite bandit placeholder
-- Group 10: Demons (High level waves)
(10, 10002, 1, -100.0, -100.0, 0.0),
(10, 10002, 1, -95.0, -105.0, 0.0),
(10, 10002, 1, -105.0, -95.0, 0.0),
(10, 10002, 1, -90.0, -110.0, 0.0),
(10, 10002, 1, -110.0, -90.0, 0.0),
(10, 10003, 1, -100.0, -100.0, 0.0) -- Demon boss
ON DUPLICATE KEY UPDATE creature_entry = VALUES(creature_entry), count = VALUES(count), spawn_x = VALUES(spawn_x), spawn_y = VALUES(spawn_y), spawn_z = VALUES(spawn_z);

-- Endless Contracts
INSERT INTO mortal_endless_contracts (code, name, description, type, map_id, zone_id, risk_tier, min_players, max_players, faction_bias, base_reward_json, flags) VALUES
-- Defense Contracts
('DEFENSE_SHRINE_GREEN', 'Defend the Shrine - Green Zone', 'Protect the sacred shrine from waves of attackers in a safe green zone. Low risk, moderate rewards.', 'DEFENSE', 0, 10, 1, 1, 5, 'ORDER_SHRINE', '{"gold": 100, "items": [{"id": 10001, "count": 1}, {"id": 10002, "count": 2}]}', 0),
('DEFENSE_SHRINE_YELLOW', 'Defend the Shrine - Yellow Zone', 'Guard the shrine against opportunistic attackers. Criminal flagging applies - stay vigilant!', 'DEFENSE', 0, 44, 2, 1, 5, 'ORDER_SHRINE', '{"gold": 200, "items": [{"id": 10003, "count": 1}, {"id": 10004, "count": 2}]}', 0),
('DEFENSE_SHRINE_RED', 'Defend the Shrine - Red Zone', 'Battle hordes in contested territory. Full loot rules apply - defend or lose everything!', 'DEFENSE', 0, 46, 3, 2, 5, 'ORDER_SHRINE', '{"gold": 500, "items": [{"id": 10005, "count": 1}, {"id": 10006, "count": 3}]}', 0),
-- Survival Contracts
('SURVIVAL_MINE_GREEN', 'Survival: Abandoned Mine - Green Zone', 'Survive encroaching darkness in an abandoned mine. Maintain your wards and hold the line!', 'SURVIVAL', 0, 1, 1, 1, 5, 'RANGERS_PACT', '{"gold": 150, "items": [{"id": 10007, "count": 1}, {"id": 10008, "count": 2}]}', 0),
('SURVIVAL_MINE_YELLOW', 'Survival: Haunted Mine - Yellow Zone', 'Endure undead hordes in a cursed mine. Environmental hazards intensify over time.', 'SURVIVAL', 0, 44, 2, 1, 5, 'RANGERS_PACT', '{"gold": 300, "items": [{"id": 10009, "count": 1}, {"id": 10010, "count": 2}]}', 0),
('SURVIVAL_MINE_RED', 'Survival: Cursed Mine - Red Zone', 'Battle demonic forces in a rift-torn mine. High risk, legendary rewards await the survivors!', 'SURVIVAL', 0, 46, 3, 2, 5, 'RANGERS_PACT', '{"gold": 750, "items": [{"id": 10011, "count": 1}, {"id": 10012, "count": 3}]}', 0)
ON DUPLICATE KEY UPDATE name = VALUES(name), description = VALUES(description), type = VALUES(type), map_id = VALUES(map_id), zone_id = VALUES(zone_id), risk_tier = VALUES(risk_tier), min_players = VALUES(min_players), max_players = VALUES(max_players), faction_bias = VALUES(faction_bias), base_reward_json = VALUES(base_reward_json), flags = VALUES(flags);

-- Endless Waves
-- Defense Shrine Green (contract_id will be 1)
INSERT INTO mortal_endless_waves (contract_id, wave_number, enemy_group_id, scaling_factor, reward_modifier) VALUES
(1, 1, 7, 1.0, 1.0),
(1, 2, 7, 1.1, 1.05),
(1, 3, 7, 1.2, 1.1),
(1, 4, 7, 1.3, 1.15),
(1, 5, 7, 1.4, 1.2),
(1, 6, 7, 1.5, 1.25),
(1, 7, 7, 1.6, 1.3),
(1, 8, 7, 1.7, 1.35),
(1, 9, 7, 1.8, 1.4),
(1, 10, 7, 1.9, 1.45),
(1, 11, 7, 2.0, 1.5),
(1, 12, 7, 2.1, 1.55),
(1, 13, 7, 2.2, 1.6),
(1, 14, 7, 2.3, 1.65),
(1, 15, 7, 2.4, 1.7),
(1, 16, 7, 2.5, 1.75),
(1, 17, 7, 2.6, 1.8),
(1, 18, 7, 2.7, 1.85),
(1, 19, 7, 2.8, 1.9),
(1, 20, 7, 2.9, 1.95)
ON DUPLICATE KEY UPDATE enemy_group_id = VALUES(enemy_group_id), scaling_factor = VALUES(scaling_factor), reward_modifier = VALUES(reward_modifier);

-- Defense Shrine Yellow (contract_id 2)
INSERT INTO mortal_endless_waves (contract_id, wave_number, enemy_group_id, scaling_factor, reward_modifier) VALUES
(2, 1, 8, 1.0, 1.0),
(2, 2, 8, 1.15, 1.1),
(2, 3, 8, 1.3, 1.2),
(2, 4, 8, 1.45, 1.3),
(2, 5, 8, 1.6, 1.4),
(2, 6, 8, 1.75, 1.5),
(2, 7, 8, 1.9, 1.6),
(2, 8, 8, 2.05, 1.7),
(2, 9, 8, 2.2, 1.8),
(2, 10, 8, 2.35, 1.9),
(2, 11, 8, 2.5, 2.0),
(2, 12, 8, 2.65, 2.1),
(2, 13, 8, 2.8, 2.2),
(2, 14, 8, 2.95, 2.3),
(2, 15, 8, 3.1, 2.4),
(2, 16, 8, 3.25, 2.5),
(2, 17, 8, 3.4, 2.6),
(2, 18, 8, 3.55, 2.7),
(2, 19, 8, 3.7, 2.8),
(2, 20, 8, 3.85, 2.9)
ON DUPLICATE KEY UPDATE enemy_group_id = VALUES(enemy_group_id), scaling_factor = VALUES(scaling_factor), reward_modifier = VALUES(reward_modifier);

-- Defense Shrine Red (contract_id 3)
INSERT INTO mortal_endless_waves (contract_id, wave_number, enemy_group_id, scaling_factor, reward_modifier) VALUES
(3, 1, 9, 1.0, 1.0),
(3, 2, 9, 1.2, 1.15),
(3, 3, 9, 1.4, 1.3),
(3, 4, 9, 1.6, 1.45),
(3, 5, 9, 1.8, 1.6),
(3, 6, 9, 2.0, 1.75),
(3, 7, 9, 2.2, 1.9),
(3, 8, 9, 2.4, 2.05),
(3, 9, 9, 2.6, 2.2),
(3, 10, 9, 2.8, 2.35),
(3, 11, 9, 3.0, 2.5),
(3, 12, 9, 3.2, 2.65),
(3, 13, 9, 3.4, 2.8),
(3, 14, 9, 3.6, 2.95),
(3, 15, 9, 3.8, 3.1),
(3, 16, 9, 4.0, 3.25),
(3, 17, 9, 4.2, 3.4),
(3, 18, 9, 4.4, 3.55),
(3, 19, 9, 4.6, 3.7),
(3, 20, 9, 4.8, 3.85)
ON DUPLICATE KEY UPDATE enemy_group_id = VALUES(enemy_group_id), scaling_factor = VALUES(scaling_factor), reward_modifier = VALUES(reward_modifier);

-- Survival Mine Green (contract_id 4)
INSERT INTO mortal_endless_waves (contract_id, wave_number, enemy_group_id, scaling_factor, reward_modifier) VALUES
(4, 1, 4, 1.0, 1.0),
(4, 2, 4, 1.1, 1.05),
(4, 3, 4, 1.2, 1.1),
(4, 4, 4, 1.3, 1.15),
(4, 5, 4, 1.4, 1.2),
(4, 6, 4, 1.5, 1.25),
(4, 7, 4, 1.6, 1.3),
(4, 8, 4, 1.7, 1.35),
(4, 9, 4, 1.8, 1.4),
(4, 10, 4, 1.9, 1.45),
(4, 11, 4, 2.0, 1.5),
(4, 12, 4, 2.1, 1.55),
(4, 13, 4, 2.2, 1.6),
(4, 14, 4, 2.3, 1.65),
(4, 15, 4, 2.4, 1.7),
(4, 16, 4, 2.5, 1.75),
(4, 17, 4, 2.6, 1.8),
(4, 18, 4, 2.7, 1.85),
(4, 19, 4, 2.8, 1.9),
(4, 20, 4, 2.9, 1.95)
ON DUPLICATE KEY UPDATE enemy_group_id = VALUES(enemy_group_id), scaling_factor = VALUES(scaling_factor), reward_modifier = VALUES(reward_modifier);

-- Survival Mine Yellow (contract_id 5)
INSERT INTO mortal_endless_waves (contract_id, wave_number, enemy_group_id, scaling_factor, reward_modifier) VALUES
(5, 1, 5, 1.0, 1.0),
(5, 2, 5, 1.15, 1.1),
(5, 3, 5, 1.3, 1.2),
(5, 4, 5, 1.45, 1.3),
(5, 5, 5, 1.6, 1.4),
(5, 6, 5, 1.75, 1.5),
(5, 7, 5, 1.9, 1.6),
(5, 8, 5, 2.05, 1.7),
(5, 9, 5, 2.2, 1.8),
(5, 10, 5, 2.35, 1.9),
(5, 11, 5, 2.5, 2.0),
(5, 12, 5, 2.65, 2.1),
(5, 13, 5, 2.8, 2.2),
(5, 14, 5, 2.95, 2.3),
(5, 15, 5, 3.1, 2.4),
(5, 16, 5, 3.25, 2.5),
(5, 17, 5, 3.4, 2.6),
(5, 18, 5, 3.55, 2.7),
(5, 19, 5, 3.7, 2.8),
(5, 20, 5, 3.85, 2.9)
ON DUPLICATE KEY UPDATE enemy_group_id = VALUES(enemy_group_id), scaling_factor = VALUES(scaling_factor), reward_modifier = VALUES(reward_modifier);

-- Survival Mine Red (contract_id 6)
INSERT INTO mortal_endless_waves (contract_id, wave_number, enemy_group_id, scaling_factor, reward_modifier) VALUES
(6, 1, 6, 1.0, 1.0),
(6, 2, 6, 1.2, 1.15),
(6, 3, 6, 1.4, 1.3),
(6, 4, 6, 1.6, 1.45),
(6, 5, 6, 1.8, 1.6),
(6, 6, 6, 2.0, 1.75),
(6, 7, 6, 2.2, 1.9),
(6, 8, 6, 2.4, 2.05),
(6, 9, 6, 2.6, 2.2),
(6, 10, 6, 2.8, 2.35),
(6, 11, 6, 3.0, 2.5),
(6, 12, 6, 3.2, 2.65),
(6, 13, 6, 3.4, 2.8),
(6, 14, 6, 3.6, 2.95),
(6, 15, 6, 3.8, 3.1),
(6, 16, 6, 4.0, 3.25),
(6, 17, 6, 4.2, 3.4),
(6, 18, 6, 4.4, 3.55),
(6, 19, 6, 4.6, 3.7),
(6, 20, 6, 4.8, 3.85)
ON DUPLICATE KEY UPDATE enemy_group_id = VALUES(enemy_group_id), scaling_factor = VALUES(scaling_factor), reward_modifier = VALUES(reward_modifier);

-- Summary
SELECT
    'Endless Contracts Population Complete' as status,
    COUNT(DISTINCT c.id) as total_contracts,
    COUNT(DISTINCT CASE WHEN c.type = 'DEFENSE' THEN c.id END) as defense_contracts,
    COUNT(DISTINCT CASE WHEN c.type = 'SURVIVAL' THEN c.id END) as survival_contracts,
    COUNT(DISTINCT w.id) as total_waves,
    COUNT(DISTINCT eg.id) as total_enemy_groups
FROM mortal_endless_contracts c
LEFT JOIN mortal_endless_waves w ON c.id = w.contract_id
LEFT JOIN mortal_enemy_groups eg ON w.enemy_group_id = eg.id;