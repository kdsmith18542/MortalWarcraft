-- Bulletin Board System
-- Stores player messages on bulletin boards

DROP TABLE IF EXISTS `bulletin_board_messages`;
CREATE TABLE `bulletin_board_messages` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `author` VARCHAR(12) NOT NULL COMMENT 'Player name',
  `message` VARCHAR(200) NOT NULL COMMENT 'Message text',
  `timestamp` INT UNSIGNED NOT NULL COMMENT 'Unix timestamp',
  PRIMARY KEY (`id`),
  KEY `idx_timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

