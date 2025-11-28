-- ==================================================
-- Project Mortal Warcraft
-- Feature: Titles & Social Progression
-- Description: Custom title system for Mortal Warcraft
-- Spec: 09-social-systems.md
-- ==================================================

-- Titles definitions
CREATE TABLE IF NOT EXISTS `mortal_titles` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    `display_name` VARCHAR(100) NOT NULL COMMENT 'Display format: "Title <name>"',
    `category` VARCHAR(50) NOT NULL COMMENT 'PvP, Economy, MiniGame, Seasonal, Guild, Exploration',
    `requirements` TEXT COMMENT 'JSON or text description of requirements',
    `icon` INT UNSIGNED DEFAULT 0 COMMENT 'Icon ID for display',
    `rarity` TINYINT UNSIGNED DEFAULT 0 COMMENT '0=Common, 1=Rare, 2=Epic, 3=Legendary',
    `created_at` INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_name` (`name`),
    KEY `idx_category` (`category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Character title ownership
CREATE TABLE IF NOT EXISTS `mortal_character_titles` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `guid` INT UNSIGNED NOT NULL,
    `title_id` INT UNSIGNED NOT NULL,
    `unlocked_at` INT UNSIGNED NOT NULL DEFAULT 0,
    `is_active` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Only one title can be active per character',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_guid_title` (`guid`, `title_id`),
    KEY `idx_guid` (`guid`),
    KEY `idx_title` (`title_id`),
    FOREIGN KEY (`title_id`) REFERENCES `mortal_titles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Character biographies
CREATE TABLE IF NOT EXISTS `mortal_character_bio` (
    `guid` INT UNSIGNED NOT NULL,
    `bio_text` TEXT COMMENT 'Player-written biography',
    `rp_tags` VARCHAR(255) COMMENT 'Comma-separated RP tags',
    `preferred_playstyle` VARCHAR(100) COMMENT 'PvP, PvE, Crafting, Social, etc.',
    `updated_at` INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`guid`),
    FOREIGN KEY (`guid`) REFERENCES `characters` (`guid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert example titles
INSERT INTO `mortal_titles` (`name`, `display_name`, `category`, `requirements`, `rarity`) VALUES
-- PvP Titles
('arena_champion', 'Arena Champion', 'PvP', 'Win 100 arena matches', 1),
('bounty_hunter', 'Bounty Hunter', 'PvP', 'Claim 50 bounties', 1),
('siege_veteran', 'Siege Veteran', 'PvP', 'Participate in 10 successful sieges', 2),
('outlaw', 'Outlaw', 'PvP', 'Reach Outlaw notoriety tier', 0),
('infamous', 'Infamous', 'PvP', 'Reach Infamous notoriety tier', 2),

-- Economy Titles
('regional_trader', 'Regional Trader', 'Economy', 'Complete 100 market stall transactions', 0),
('master_crafter', 'Master Crafter', 'Economy', 'Craft 1000 items', 1),
('legendary_crafter', 'Legendary Crafter', 'Economy', 'Craft 10 Legendary quality items', 3),
('caravan_master', 'Caravan Master', 'Economy', 'Complete 50 caravan contracts', 1),

-- Mini-Game Titles
('dice_king', 'Dice King', 'MiniGame', 'Win 100 dice games', 0),
('tavern_champion', 'Tavern Champion', 'MiniGame', 'Win all tavern mini-games', 1),

-- Seasonal Titles
('spring_harvester', 'Spring Harvester', 'Seasonal', 'Complete Spring season objectives', 0),
('summer_warrior', 'Summer Warrior', 'Seasonal', 'Complete Summer season objectives', 0),
('autumn_gatherer', 'Autumn Gatherer', 'Seasonal', 'Complete Autumn season objectives', 0),
('winter_survivor', 'Winter Survivor', 'Seasonal', 'Complete Winter season objectives', 0),

-- Guild Titles
('guild_leader', 'Guild Leader', 'Guild', 'Be the leader of a guild', 0),
('territory_controller', 'Territory Controller', 'Guild', 'Control a territory control point', 1),
('stronghold_master', 'Stronghold Master', 'Guild', 'Own a stronghold', 2),

-- Exploration Titles
('world_wanderer', 'World Wanderer', 'Exploration', 'Visit all major zones', 1),
('treasure_hunter', 'Treasure Hunter', 'Exploration', 'Discover 50 hidden treasures', 1);

