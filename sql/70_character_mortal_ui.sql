-- ==================================================
-- Project Mortal Warcraft
-- Feature: UI Configuration Tracking
-- Description: Tracks which players have had UI configured
-- Version: 20.0
-- ==================================================

CREATE TABLE IF NOT EXISTS `character_mortal_ui` (
    `guid` INT UNSIGNED NOT NULL,
    `ui_configured` TINYINT UNSIGNED DEFAULT 0 COMMENT '1 = UI has been configured',
    `last_update` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Tracks UI configuration status for players';

