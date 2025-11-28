-- ==================================================
-- Project Mortal Warcraft
-- Feature: World Contracts Templates
-- Description: Sample world contract templates for each contract type
-- Based on: docs/specs/58-world-contracts-and-map-pins.md
-- ==================================================

USE `azerothcore_world`;

-- Insert sample world contract templates for each type

-- HUNT CONTRACTS (Kill X of specific mobs)
INSERT INTO `mortal_world_contract_templates` (`code`, `name`, `description`, `type`, `risk_tier`, `zone_id`, `faction_tag`, `objective_json`, `reward_json`, `flags`, `is_active`) VALUES
('WC_HUNT_BARRENS_ALPHA_WOLVES', 'Cull the Alpha Packs', 'The Rangers'' Pact requires assistance in thinning the alpha wolf packs that threaten travelers along the Gold Road. Eliminate 15 alpha wolves in the Northern Barrens.', 'HUNT', 2, 17, 'RANGERS_PACT', '{"target_mobs": [{"entry": 509, "count": 15}], "area_restriction": {"x": -456, "y": 2650, "radius": 2000}}', '{"gold": 150, "faction_standing": 25, "material_tokens": 5}', 0, 1),
('WC_HUNT_DUSKWOOD_SPIDERS', 'Web Weaver Extermination', 'Spiders have overrun the forests near Darkshire. Help the Order of the Shrine by eliminating 20 web weavers and their brood.', 'HUNT', 1, 10, 'ORDER_OF_THE_SHRINE', '{"target_mobs": [{"entry": 30, "count": 20}], "area_restriction": {"x": -10517, "y": -1158, "radius": 1500}}', '{"gold": 100, "faction_standing": 20, "material_tokens": 3}', 0, 1),
('WC_HUNT_REDRIDGE_GNOLLS', 'Riverpaw Incursion', 'The Redridge Militia needs help dealing with a gnoll incursion. Clear out 12 Riverpaw gnolls from the Lakeshire outskirts.', 'HUNT', 1, 44, 'REDRIDGE_MILITIA', '{"target_mobs": [{"entry": 117, "count": 12}], "area_restriction": {"x": -9450, "y": -2239, "radius": 1200}}', '{"gold": 80, "faction_standing": 15, "material_tokens": 2}', 0, 1);

-- DEFENSE CONTRACTS (Defend locations from waves)
INSERT INTO `mortal_world_contract_templates` (`code`, `name`, `description`, `type`, `risk_tier`, `zone_id`, `faction_tag`, `objective_json`, `reward_json`, `flags`, `is_active`) VALUES
('WC_DEFENSE_DUSKWOOD_CEMETERY', 'Midnight Horde Defense', 'The Order of the Shrine requires defenders to protect the Darkshire Cemetery from the encroaching Midnight Horde. Survive 3 waves of undead attackers.', 'DEFENSE', 3, 10, 'ORDER_OF_THE_SHRINE', '{"waves": 3, "wave_mobs": [{"entry": 1501, "count": 8}, {"entry": 1502, "count": 6}, {"entry": 1503, "count": 4}], "location": {"x": -10517, "y": -1158, "z": 39}}', '{"gold": 300, "faction_standing": 50, "material_tokens": 10}', 0, 1),
('WC_DEFENSE_GREYCRAG_OUTPOST', 'Outpost Assault', 'The Greycrag Irregulars need help defending their remote outpost from bandit raiders. Hold the position for 15 minutes against escalating attacks.', 'DEFENSE', 4, 1637, 'GREYCRAG_IRREGULARS', '{"duration_minutes": 15, "spawn_points": [{"x": 0, "y": 0, "z": 0}], "enemy_waves": [{"bandits": 6}, {"bandits": 8}, {"bandits": 10}]}', '{"gold": 500, "faction_standing": 75, "material_tokens": 15}', 0, 1);

-- RIFT CONTRACTS (Close planar breaches)
INSERT INTO `mortal_world_contract_templates` (`code`, `name`, `description`, `type`, `risk_tier`, `zone_id`, `faction_tag`, `objective_json`, `reward_json`, `flags`, `is_active`) VALUES
('WC_RIFT_DESOLACE_BREACHES', 'Planar Tears in Desolace', 'The Rangers'' Pact has detected multiple planar breaches in Desolace. Close 5 rifts before they destabilize the region further.', 'RIFT', 3, 405, 'RANGERS_PACT', '{"rift_count": 5, "rift_entries": [180000, 180001, 180002, 180003, 180004], "time_limit": 3600}', '{"gold": 250, "faction_standing": 40, "material_tokens": 8}', 0, 1),
('WC_RIFT_BARRENS_ANOMALIES', 'Burning Steppes Anomalies', 'Arcane anomalies are appearing throughout the Burning Steppes. The Iron Ledger requests assistance in closing 3 major rifts.', 'RIFT', 4, 46, 'IRON_LEDGER', '{"rift_count": 3, "rift_entries": [180005, 180006, 180007], "time_limit": 2700}', '{"gold": 400, "faction_standing": 60, "material_tokens": 12}', 0, 1);

-- CARAVAN CONTRACTS (Escort trade routes)
INSERT INTO `mortal_world_contract_templates` (`code`, `name`, `description`, `type`, `risk_tier`, `zone_id`, `faction_tag`, `objective_json`, `reward_json`, `flags`, `is_active`) VALUES
('WC_CARAVAN_GOLD_ROAD_RUN', 'Gold Road Caravan', 'The Iron Ledger needs a reliable escort for a valuable caravan running the Gold Road from Stormwind to Booty Bay. Ensure safe delivery through Yellow Zone territory.', 'CARAVAN', 3, 17, 'IRON_LEDGER', '{"route": [{"x": -8913, "y": 554, "z": 94}, {"x": -456, "y": 2650, "z": 91}, {"x": -14457, "y": 470, "z": 15}], "cargo_value": 5000, "time_limit": 7200}', '{"gold": 350, "faction_standing": 45, "material_tokens": 9}', 0, 1),
('WC_CARAVAN_FRONTIER_SUPPLY', 'Frontier Supply Run', 'The Greycrag Irregulars require supplies delivered to their remote outpost. Escort the wagon through dangerous Red Zone wilderness.', 'CARAVAN', 5, 1637, 'GREYCRAG_IRREGULARS', '{"route": [{"x": -8913, "y": 554, "z": 94}, {"x": 0, "y": 0, "z": 0}], "cargo_value": 8000, "time_limit": 5400}', '{"gold": 600, "faction_standing": 80, "material_tokens": 18}', 0, 1);

-- HELLGATE CONTRACTS (Complete dungeon runs)
INSERT INTO `mortal_world_contract_templates` (`code`, `name`, `description`, `type`, `risk_tier`, `zone_id`, `faction_tag`, `objective_json`, `reward_json`, `flags`, `is_active`) VALUES
('WC_HELLGATE_RAGEFIRE_CHASM', 'Ragefire Chasm Incursion', 'The Order of the Shrine has detected demonic activity in Ragefire Chasm. Clear the trogg-infested depths and seal any hellgates found within.', 'HELLGATE', 2, 2437, 'ORDER_OF_THE_SHRINE', '{"instance_id": 389, "objectives": ["clear_troggs", "seal_hellgate"], "time_limit": 1800, "max_deaths": 3}', '{"gold": 200, "faction_standing": 35, "material_tokens": 7}', 0, 1),
('WC_HELLGATE_WAILING_CAVERNS', 'Wailing Caverns Cleansing', 'Demonic corruption has spread to Wailing Caverns. The Rangers'' Pact requests a thorough cleansing of the cavern system.', 'HELLGATE', 3, 718, 'RANGERS_PACT', '{"instance_id": 43, "objectives": ["clear_corruption", "defeat_lord_cobrahn"], "time_limit": 2400, "max_deaths": 2}', '{"gold": 280, "faction_standing": 45, "material_tokens": 9}', 0, 1);