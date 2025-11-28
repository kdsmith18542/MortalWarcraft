-- ==================================================
-- Project Mortal Warcraft
-- Feature: Public Dungeons (Delves)
-- Description: De-instance major dungeons, make them open-world
-- ==================================================

-- Public Dungeon Configuration
CREATE TABLE IF NOT EXISTS `public_dungeons_config` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `map_id` SMALLINT UNSIGNED NOT NULL COMMENT 'Dungeon map ID',
  `name` VARCHAR(100) NOT NULL COMMENT 'Dungeon name',
  `max_players` INT UNSIGNED NOT NULL DEFAULT 40 COMMENT 'Maximum players allowed (high capacity)',
  `pvp_enabled` TINYINT(1) NOT NULL DEFAULT 1 COMMENT 'Is PvP enabled?',
  `full_loot` TINYINT(1) NOT NULL DEFAULT 1 COMMENT 'Is full loot enabled?',
  `enabled` TINYINT(1) NOT NULL DEFAULT 1 COMMENT 'Is this dungeon public?',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_map` (`map_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Public dungeon configurations';

-- Public Dungeon Entry Points (where players enter)
CREATE TABLE IF NOT EXISTS `public_dungeon_entries` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `dungeon_id` INT UNSIGNED NOT NULL COMMENT 'Reference to public_dungeons_config.id',
  `map` SMALLINT UNSIGNED NOT NULL COMMENT 'World map where entry exists',
  `zone` SMALLINT UNSIGNED NOT NULL COMMENT 'Zone ID',
  `x` FLOAT NOT NULL COMMENT 'Entry X coordinate',
  `y` FLOAT NOT NULL COMMENT 'Entry Y coordinate',
  `z` FLOAT NOT NULL COMMENT 'Entry Z coordinate',
  `o` FLOAT NOT NULL COMMENT 'Entry orientation',
  `description` VARCHAR(255) COMMENT 'Entry description',
  PRIMARY KEY (`id`),
  KEY `idx_dungeon` (`dungeon_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Public dungeon entry points';

-- Insert Public Dungeon configurations
-- Major dungeons converted to open-world
INSERT INTO `public_dungeons_config` (`map_id`, `name`, `max_players`, `pvp_enabled`, `full_loot`, `enabled`) VALUES
-- Deadmines (Map 36) - Westfall
(36, 'Deadmines (Public)', 40, 1, 1, 1),
-- Wailing Caverns (Map 43) - The Barrens
(43, 'Wailing Caverns (Public)', 40, 1, 1, 1),
-- Shadowfang Keep (Map 33) - Silverpine Forest
(33, 'Shadowfang Keep (Public)', 40, 1, 1, 1),
-- Blackfathom Deeps (Map 48) - Ashenvale
(48, 'Blackfathom Deeps (Public)', 40, 1, 1, 1),
-- The Stockade (Map 34) - Stormwind
(34, 'The Stockade (Public)', 40, 1, 1, 1),
-- Razorfen Kraul (Map 47) - The Barrens
(47, 'Razorfen Kraul (Public)', 40, 1, 1, 1),
-- Razorfen Downs (Map 129) - The Barrens
(129, 'Razorfen Downs (Public)', 40, 1, 1, 1),
-- Scarlet Monastery (Map 189) - Tirisfal Glades
(189, 'Scarlet Monastery (Public)', 40, 1, 1, 1),
-- Ragefire Chasm (Map 389) - Orgrimmar
(389, 'Ragefire Chasm (Public)', 40, 1, 1, 1),
-- Zul'Farrak (Map 209) - Tanaris
(209, 'Zul\'Farrak (Public)', 40, 1, 1, 1),
-- Maraudon (Map 349) - Desolace
(349, 'Maraudon (Public)', 40, 1, 1, 1),
-- Dire Maul (Map 429) - Feralas
(429, 'Dire Maul (Public)', 40, 1, 1, 1),
-- Blackrock Depths (Map 230) - Blackrock Mountain
(230, 'Blackrock Depths (Public)', 40, 1, 1, 1),
-- Blackrock Spire (Map 229) - Blackrock Mountain
(229, 'Blackrock Spire (Public)', 40, 1, 1, 1),
-- Scholomance (Map 289) - Western Plaguelands
(289, 'Scholomance (Public)', 40, 1, 1, 1),
-- Stratholme (Map 329) - Eastern Plaguelands
(329, 'Stratholme (Public)', 40, 1, 1, 1),
-- Hellfire Ramparts (Map 543) - Hellfire Peninsula
(543, 'Hellfire Ramparts (Public)', 40, 1, 1, 1),
-- The Blood Furnace (Map 542) - Hellfire Peninsula
(542, 'The Blood Furnace (Public)', 40, 1, 1, 1),
-- The Shattered Halls (Map 540) - Hellfire Peninsula
(540, 'The Shattered Halls (Public)', 40, 1, 1, 1),
-- Mana-Tombs (Map 557) - Terokkar Forest
(557, 'Mana-Tombs (Public)', 40, 1, 1, 1),
-- Auchenai Crypts (Map 558) - Terokkar Forest
(558, 'Auchenai Crypts (Public)', 40, 1, 1, 1),
-- Sethekk Halls (Map 556) - Terokkar Forest
(556, 'Sethekk Halls (Public)', 40, 1, 1, 1),
-- Shadow Labyrinth (Map 555) - Terokkar Forest
(555, 'Shadow Labyrinth (Public)', 40, 1, 1, 1),
-- The Mechanar (Map 554) - Netherstorm
(554, 'The Mechanar (Public)', 40, 1, 1, 1),
-- The Botanica (Map 553) - Netherstorm
(553, 'The Botanica (Public)', 40, 1, 1, 1),
-- The Arcatraz (Map 552) - Netherstorm
(552, 'The Arcatraz (Public)', 40, 1, 1, 1),
-- The Steamvault (Map 545) - Zangarmarsh
(545, 'The Steamvault (Public)', 40, 1, 1, 1),
-- The Underbog (Map 546) - Zangarmarsh
(546, 'The Underbog (Public)', 40, 1, 1, 1),
-- The Slave Pens (Map 547) - Zangarmarsh
(547, 'The Slave Pens (Public)', 40, 1, 1, 1),
-- Magisters' Terrace (Map 585) - Isle of Quel'Danas
(585, 'Magisters\' Terrace (Public)', 40, 1, 1, 1),
-- Utgarde Keep (Map 574) - Howling Fjord
(574, 'Utgarde Keep (Public)', 40, 1, 1, 1),
-- The Nexus (Map 576) - Borean Tundra
(576, 'The Nexus (Public)', 40, 1, 1, 1),
-- Azjol-Nerub (Map 601) - Dragonblight
(601, 'Azjol-Nerub (Public)', 40, 1, 1, 1),
-- Ahn'kahet: The Old Kingdom (Map 619) - Dragonblight
(619, 'Ahn\'kahet: The Old Kingdom (Public)', 40, 1, 1, 1),
-- Drak'Tharon Keep (Map 600) - Grizzly Hills
(600, 'Drak\'Tharon Keep (Public)', 40, 1, 1, 1),
-- The Violet Hold (Map 608) - Dalaran
(608, 'The Violet Hold (Public)', 40, 1, 1, 1),
-- Gundrak (Map 604) - Zul'Drak
(604, 'Gundrak (Public)', 40, 1, 1, 1),
-- Halls of Stone (Map 599) - Storm Peaks
(599, 'Halls of Stone (Public)', 40, 1, 1, 1),
-- Halls of Lightning (Map 602) - Storm Peaks
(602, 'Halls of Lightning (Public)', 40, 1, 1, 1),
-- The Oculus (Map 578) - Borean Tundra
(578, 'The Oculus (Public)', 40, 1, 1, 1),
-- The Culling of Stratholme (Map 595) - Tanaris
(595, 'The Culling of Stratholme (Public)', 40, 1, 1, 1),
-- Trial of the Champion (Map 650) - Icecrown
(650, 'Trial of the Champion (Public)', 40, 1, 1, 1),
-- The Forge of Souls (Map 632) - Icecrown
(632, 'The Forge of Souls (Public)', 40, 1, 1, 1),
-- Pit of Saron (Map 658) - Icecrown
(658, 'Pit of Saron (Public)', 40, 1, 1, 1),
-- Halls of Reflection (Map 668) - Icecrown
(668, 'Halls of Reflection (Public)', 40, 1, 1, 1);

-- Insert entry points for public dungeons
INSERT INTO `public_dungeon_entries` (`dungeon_id`, `map`, `zone`, `x`, `y`, `z`, `o`, `description`) VALUES
-- Deadmines entry (Westfall)
(1, 0, 40, -11208.0, 1686.0, 24.0, 0.0, 'Deadmines Entrance'),
-- Wailing Caverns entry (The Barrens)
(2, 1, 17, -731.0, -2212.0, 17.0, 0.0, 'Wailing Caverns Entrance'),
-- Shadowfang Keep entry (Silverpine)
(3, 0, 130, -234.0, 1569.0, 76.0, 0.0, 'Shadowfang Keep Entrance'),
-- Blackfathom Deeps entry (Ashenvale)
(4, 1, 331, 4249.0, 740.0, -25.0, 0.0, 'Blackfathom Deeps Entrance'),
-- The Stockade entry (Stormwind)
(5, 0, 1519, -8764.0, 845.0, 87.0, 0.0, 'The Stockade Entrance'),
-- Razorfen Kraul entry (The Barrens)
(6, 1, 17, -4484.0, -1739.0, 86.0, 0.0, 'Razorfen Kraul Entrance'),
-- Razorfen Downs entry (The Barrens)
(7, 1, 17, -4657.0, -2519.0, 81.0, 0.0, 'Razorfen Downs Entrance'),
-- Scarlet Monastery entry (Tirisfal)
(8, 0, 139, 2872.0, -820.0, 160.0, 0.0, 'Scarlet Monastery Entrance'),
-- Ragefire Chasm entry (Orgrimmar)
(9, 1, 1637, 1800.0, -4400.0, -20.0, 0.0, 'Ragefire Chasm Entrance'),
-- Zul'Farrak entry (Tanaris)
(10, 1, 440, -6800.0, -2900.0, 9.0, 0.0, 'Zul\'Farrak Entrance'),
-- Maraudon entry (Desolace)
(11, 1, 405, -1180.0, 2870.0, 85.0, 0.0, 'Maraudon Entrance'),
-- Dire Maul entry (Feralas)
(12, 1, 357, -4590.0, 1632.0, 94.0, 0.0, 'Dire Maul Entrance'),
-- Blackrock Depths entry (Blackrock Mountain)
(13, 0, 25, -7170.0, -920.0, 166.0, 0.0, 'Blackrock Depths Entrance'),
-- Blackrock Spire entry (Blackrock Mountain)
(14, 0, 25, -7520.0, -1220.0, 286.0, 0.0, 'Blackrock Spire Entrance'),
-- Scholomance entry (Western Plaguelands)
(15, 0, 28, 1270.0, -2550.0, 92.0, 0.0, 'Scholomance Entrance'),
-- Stratholme entry (Eastern Plaguelands)
(16, 0, 139, 3390.0, -3380.0, 142.0, 0.0, 'Stratholme Entrance'),
-- Hellfire Ramparts entry (Hellfire Peninsula)
(17, 530, 3483, -360.0, 3070.0, -15.0, 0.0, 'Hellfire Ramparts Entrance'),
-- The Blood Furnace entry (Hellfire Peninsula)
(18, 530, 3483, -300.0, 3160.0, -15.0, 0.0, 'The Blood Furnace Entrance'),
-- The Shattered Halls entry (Hellfire Peninsula)
(19, 530, 3483, -310.0, 3080.0, -15.0, 0.0, 'The Shattered Halls Entrance'),
-- Mana-Tombs entry (Terokkar Forest)
(20, 530, 3519, -3100.0, 4940.0, -15.0, 0.0, 'Mana-Tombs Entrance'),
-- Auchenai Crypts entry (Terokkar Forest)
(21, 530, 3519, -3360.0, 5220.0, -15.0, 0.0, 'Auchenai Crypts Entrance'),
-- Sethekk Halls entry (Terokkar Forest)
(22, 530, 3519, -3360.0, 4660.0, -15.0, 0.0, 'Sethekk Halls Entrance'),
-- Shadow Labyrinth entry (Terokkar Forest)
(23, 530, 3519, -3640.0, 4940.0, -15.0, 0.0, 'Shadow Labyrinth Entrance'),
-- The Mechanar entry (Netherstorm)
(24, 530, 3523, 2860.0, 1550.0, -15.0, 0.0, 'The Mechanar Entrance'),
-- The Botanica entry (Netherstorm)
(25, 530, 3523, 3400.0, 1480.0, -15.0, 0.0, 'The Botanica Entrance'),
-- The Arcatraz entry (Netherstorm)
(26, 530, 3523, 3300.0, 1350.0, -15.0, 0.0, 'The Arcatraz Entrance'),
-- The Steamvault entry (Zangarmarsh)
(27, 530, 3521, 530.0, 7000.0, -15.0, 0.0, 'The Steamvault Entrance'),
-- The Underbog entry (Zangarmarsh)
(28, 530, 3521, 780.0, 6760.0, -15.0, 0.0, 'The Underbog Entrance'),
-- The Slave Pens entry (Zangarmarsh)
(29, 530, 3521, 720.0, 6990.0, -15.0, 0.0, 'The Slave Pens Entrance'),
-- Magisters' Terrace entry (Isle of Quel'Danas)
(30, 530, 4080, 12880.0, -6870.0, 15.0, 0.0, 'Magisters\' Terrace Entrance'),
-- Utgarde Keep entry (Howling Fjord)
(31, 571, 495, 1200.0, -4860.0, 41.0, 0.0, 'Utgarde Keep Entrance'),
-- The Nexus entry (Borean Tundra)
(32, 571, 3537, 3890.0, 6980.0, 69.0, 0.0, 'The Nexus Entrance'),
-- Azjol-Nerub entry (Dragonblight)
(33, 571, 65, 3700.0, 2150.0, 36.0, 0.0, 'Azjol-Nerub Entrance'),
-- Ahn'kahet: The Old Kingdom entry (Dragonblight)
(34, 571, 65, 3700.0, 2150.0, 36.0, 0.0, 'Ahn\'kahet: The Old Kingdom Entrance'),
-- Drak'Tharon Keep entry (Grizzly Hills)
(35, 571, 394, 4770.0, -2020.0, 230.0, 0.0, 'Drak\'Tharon Keep Entrance'),
-- The Violet Hold entry (Dalaran)
(36, 571, 4395, 5690.0, 500.0, 652.0, 0.0, 'The Violet Hold Entrance'),
-- Gundrak entry (Zul'Drak)
(37, 571, 66, 6700.0, -4600.0, 441.0, 0.0, 'Gundrak Entrance'),
-- Halls of Stone entry (Storm Peaks)
(38, 571, 67, 8920.0, -970.0, 1039.0, 0.0, 'Halls of Stone Entrance'),
-- Halls of Lightning entry (Storm Peaks)
(39, 571, 67, 9180.0, -1380.0, 1110.0, 0.0, 'Halls of Lightning Entrance'),
-- The Oculus entry (Borean Tundra)
(40, 571, 3537, 3870.0, 6980.0, 106.0, 0.0, 'The Oculus Entrance'),
-- The Culling of Stratholme entry (Tanaris)
(41, 1, 440, -8750.0, -4450.0, 24.0, 0.0, 'The Culling of Stratholme Entrance'),
-- Trial of the Champion entry (Icecrown)
(42, 571, 210, 8500.0, 610.0, 547.0, 0.0, 'Trial of the Champion Entrance'),
-- The Forge of Souls entry (Icecrown)
(43, 571, 210, 5650.0, 2000.0, 798.0, 0.0, 'The Forge of Souls Entrance'),
-- Pit of Saron entry (Icecrown)
(44, 571, 210, 5600.0, 200.0, 528.0, 0.0, 'Pit of Saron Entrance'),
-- Halls of Reflection entry (Icecrown)
(45, 571, 210, 5600.0, 200.0, 528.0, 0.0, 'Halls of Reflection Entrance');

-- Note: To fully de-instance these dungeons, you need to:
-- 1. Update `instance_template` table to remove instance flags (or set max players to 0)
-- 2. Update `map` table entries to remove dungeon flags
-- 3. This may require core modifications to allow multiple groups in same dungeon

