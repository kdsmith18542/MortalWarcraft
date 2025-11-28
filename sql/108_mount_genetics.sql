-- Mount Genetics System
-- Stores genetic data for mount breeding

DROP TABLE IF EXISTS `mount_genetics`;
CREATE TABLE `mount_genetics` (
  `item_guid` BIGINT UNSIGNED NOT NULL,
  `base_speed` FLOAT NOT NULL DEFAULT 1.0,
  `base_stamina` FLOAT NOT NULL DEFAULT 100.0,
  `coat_color` INT UNSIGNED NOT NULL DEFAULT 1,
  `temperament` FLOAT NOT NULL DEFAULT 50.0,
  `pack_capacity` INT UNSIGNED NOT NULL DEFAULT 0,
  `rare_gene` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0=None, 1=Albino, 2=Warbred, 3=Desert, 4=Frostblood, 5=Fearless',
  `bloodline_id` INT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`item_guid`),
  KEY `idx_bloodline` (`bloodline_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

