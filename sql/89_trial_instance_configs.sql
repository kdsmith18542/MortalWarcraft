-- ==================================================
-- Mortal Warcraft – Trial Instance Configs
-- Spec 59: Shrine and Faction Solo Trials
-- Target DB: world
-- ==================================================

-- Trial Instance Definitions
-- Each trial is a solo instance with normalized difficulty

-- Trial 1: Trial of the Bulwark (Tier 1 - Order Shrine)
INSERT INTO `mortal_trials` (`id`, `trial_key`, `name`, `faction_tag`, `tier`, `instance_id`, 
    `entry_map`, `entry_x`, `entry_y`, `entry_z`, `entry_o`, `min_level`, `max_level`, 
    `required_faction_tier`, `required_tokens`, `normalized_band_json`, `reward_title_id`, 
    `reward_rune_id`, `reward_cosmetic_id`, `description`)
VALUES
(1, 'TRIAL_BULWARK_T1', 'Trial of the Bulwark', 'ORDER_SHRINE', 1, 2000,
    0, -8800.0, 620.0, 94.0, 0.0, 1, 25, 1, 0,
    '{"min_ilvl": 1, "max_ilvl": 25, "stat_scale_multiplier": 1.0}',
    0, 0, 0, 'A test of defensive prowess and resilience')
ON DUPLICATE KEY UPDATE
    `trial_key` = VALUES(`trial_key`),
    `name` = VALUES(`name`),
    `faction_tag` = VALUES(`faction_tag`),
    `tier` = VALUES(`tier`),
    `instance_id` = VALUES(`instance_id`),
    `entry_map` = VALUES(`entry_map`),
    `entry_x` = VALUES(`entry_x`),
    `entry_y` = VALUES(`entry_y`),
    `entry_z` = VALUES(`entry_z`),
    `entry_o` = VALUES(`entry_o`),
    `min_level` = VALUES(`min_level`),
    `max_level` = VALUES(`max_level`),
    `required_faction_tier` = VALUES(`required_faction_tier`),
    `required_tokens` = VALUES(`required_tokens`),
    `normalized_band_json` = VALUES(`normalized_band_json`),
    `reward_title_id` = VALUES(`reward_title_id`),
    `reward_rune_id` = VALUES(`reward_rune_id`),
    `reward_cosmetic_id` = VALUES(`reward_cosmetic_id`),
    `description` = VALUES(`description`);

-- Trial 2: Trial of the Blade (Tier 1 - Rangers' Pact)
INSERT INTO `mortal_trials` (`id`, `trial_key`, `name`, `faction_tag`, `tier`, `instance_id`, 
    `entry_map`, `entry_x`, `entry_y`, `entry_z`, `entry_o`, `min_level`, `max_level`, 
    `required_faction_tier`, `required_tokens`, `normalized_band_json`, `reward_title_id`, 
    `reward_rune_id`, `reward_cosmetic_id`, `description`)
VALUES
(2, 'TRIAL_BLADE_T1', 'Trial of the Blade', 'RANGERS_PACT', 1, 2001,
    0, -8780.0, 660.0, 94.0, 0.0, 1, 25, 1, 0,
    '{"min_ilvl": 1, "max_ilvl": 25, "stat_scale_multiplier": 1.0}',
    0, 0, 0, 'A test of offensive skill and precision')
ON DUPLICATE KEY UPDATE
    `trial_key` = VALUES(`trial_key`),
    `name` = VALUES(`name`),
    `faction_tag` = VALUES(`faction_tag`),
    `tier` = VALUES(`tier`),
    `instance_id` = VALUES(`instance_id`),
    `entry_map` = VALUES(`entry_map`),
    `entry_x` = VALUES(`entry_x`),
    `entry_y` = VALUES(`entry_y`),
    `entry_z` = VALUES(`entry_z`),
    `entry_o` = VALUES(`entry_o`),
    `min_level` = VALUES(`min_level`),
    `max_level` = VALUES(`max_level`),
    `required_faction_tier` = VALUES(`required_faction_tier`),
    `required_tokens` = VALUES(`required_tokens`),
    `normalized_band_json` = VALUES(`normalized_band_json`),
    `reward_title_id` = VALUES(`reward_title_id`),
    `reward_rune_id` = VALUES(`reward_rune_id`),
    `reward_cosmetic_id` = VALUES(`reward_cosmetic_id`),
    `description` = VALUES(`description`);

-- Trial 3: Trial of the Veil (Tier 1 - Black Sun Cartel)
INSERT INTO `mortal_trials` (`id`, `trial_key`, `name`, `faction_tag`, `tier`, `instance_id`, 
    `entry_map`, `entry_x`, `entry_y`, `entry_z`, `entry_o`, `min_level`, `max_level`, 
    `required_faction_tier`, `required_tokens`, `normalized_band_json`, `reward_title_id`, 
    `reward_rune_id`, `reward_cosmetic_id`, `description`)
VALUES
(3, 'TRIAL_VEIL_T1', 'Trial of the Veil', 'BLACK_SUN_CARTEL', 1, 2002,
    0, -8850.0, 600.0, 94.0, 0.0, 1, 25, 1, 0,
    '{"min_ilvl": 1, "max_ilvl": 25, "stat_scale_multiplier": 1.0}',
    0, 0, 0, 'A test of stealth and cunning')
ON DUPLICATE KEY UPDATE
    `trial_key` = VALUES(`trial_key`),
    `name` = VALUES(`name`),
    `faction_tag` = VALUES(`faction_tag`),
    `tier` = VALUES(`tier`),
    `instance_id` = VALUES(`instance_id`),
    `entry_map` = VALUES(`entry_map`),
    `entry_x` = VALUES(`entry_x`),
    `entry_y` = VALUES(`entry_y`),
    `entry_z` = VALUES(`entry_z`),
    `entry_o` = VALUES(`entry_o`),
    `min_level` = VALUES(`min_level`),
    `max_level` = VALUES(`max_level`),
    `required_faction_tier` = VALUES(`required_faction_tier`),
    `required_tokens` = VALUES(`required_tokens`),
    `normalized_band_json` = VALUES(`normalized_band_json`),
    `reward_title_id` = VALUES(`reward_title_id`),
    `reward_rune_id` = VALUES(`reward_rune_id`),
    `reward_cosmetic_id` = VALUES(`reward_cosmetic_id`),
    `description` = VALUES(`description`);

-- Trial 4: Trial of the Lifeline (Tier 1 - Iron Ledger)
INSERT INTO `mortal_trials` (`id`, `trial_key`, `name`, `faction_tag`, `tier`, `instance_id`, 
    `entry_map`, `entry_x`, `entry_y`, `entry_z`, `entry_o`, `min_level`, `max_level`, 
    `required_faction_tier`, `required_tokens`, `normalized_band_json`, `reward_title_id`, 
    `reward_rune_id`, `reward_cosmetic_id`, `description`)
VALUES
(4, 'TRIAL_LIFELINE_T1', 'Trial of the Lifeline', 'IRON_LEDGER', 1, 2003,
    0, -8823.0, 640.0, 94.0, 0.0, 1, 25, 1, 0,
    '{"min_ilvl": 1, "max_ilvl": 25, "stat_scale_multiplier": 1.0}',
    0, 0, 0, 'A test of resource management and efficiency')
ON DUPLICATE KEY UPDATE
    `trial_key` = VALUES(`trial_key`),
    `name` = VALUES(`name`),
    `faction_tag` = VALUES(`faction_tag`),
    `tier` = VALUES(`tier`),
    `instance_id` = VALUES(`instance_id`),
    `entry_map` = VALUES(`entry_map`),
    `entry_x` = VALUES(`entry_x`),
    `entry_y` = VALUES(`entry_y`),
    `entry_z` = VALUES(`entry_z`),
    `entry_o` = VALUES(`entry_o`),
    `min_level` = VALUES(`min_level`),
    `max_level` = VALUES(`max_level`),
    `required_faction_tier` = VALUES(`required_faction_tier`),
    `required_tokens` = VALUES(`required_tokens`),
    `normalized_band_json` = VALUES(`normalized_band_json`),
    `reward_title_id` = VALUES(`reward_title_id`),
    `reward_rune_id` = VALUES(`reward_rune_id`),
    `reward_cosmetic_id` = VALUES(`reward_cosmetic_id`),
    `description` = VALUES(`description`);

-- Note: Instance IDs 2000-2003 would need to be created as custom instances
-- Each trial instance would contain:
-- - Normalization aura spawn point
-- - Trial encounter boss/mechanic
-- - Exit portal/object
-- - Progress tracking objects

