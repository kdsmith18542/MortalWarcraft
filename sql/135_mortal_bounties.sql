-- ==================================================
-- Project Mortal Warcraft
-- Migration: mortal_bounties table and bounty token log
-- Purpose: Store posted bounties and log token claims
-- Run against: azerothcore_characters
-- ==================================================

USE azerothcore_characters;

-- mortal_bounties: stores posted bounties on player targets
CREATE TABLE IF NOT EXISTS `mortal_bounties` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `poster_guid` INT UNSIGNED NOT NULL COMMENT 'GUID of player who posted the bounty',
    `target_guid` INT UNSIGNED NOT NULL COMMENT 'GUID of player who is the bounty target',
    `bounty_amount` BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Amount in copper',
    `posted_at` INT UNSIGNED NOT NULL COMMENT 'UNIX_TIMESTAMP when posted',
    `is_claimed` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '0 = unclaimed, 1 = claimed',
    `claimed_by` INT UNSIGNED NULL COMMENT 'GUID of player who claimed',
    `claimed_at` INT UNSIGNED NULL COMMENT 'UNIX_TIMESTAMP when claimed',
    `notes` VARCHAR(255) DEFAULT NULL,
    INDEX `idx_target_unclaimed` (`target_guid`, `is_claimed`),
    INDEX `idx_posted_at` (`posted_at`),
    INDEX `idx_claimed_by` (`claimed_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- mortal_bounty_token_log: records token pickups and turn-ins for auditing
CREATE TABLE IF NOT EXISTS `mortal_bounty_token_log` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `bounty_id` INT UNSIGNED NULL COMMENT 'FK to mortal_bounties.id when applicable',
    `killer_guid` INT UNSIGNED NOT NULL COMMENT 'GUID of player who looted the token',
    `victim_guid` INT UNSIGNED NOT NULL COMMENT 'GUID of player who was killed',
    `token_guid` BIGINT UNSIGNED NULL COMMENT 'Item instance GUID if applicable',
    `action` VARCHAR(50) NOT NULL COMMENT 'picked_up|turned_in|claimed',
    `amount` BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'amount awarded (copper) when turned in',
    `created_at` INT UNSIGNED NOT NULL COMMENT 'UNIX_TIMESTAMP of action',
    INDEX `idx_bounty_id` (`bounty_id`),
    INDEX `idx_killer` (`killer_guid`),
    INDEX `idx_victim` (`victim_guid`),
    INDEX `idx_action_created` (`action`, `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Optional: seed a minimal example (commented)
-- INSERT INTO mortal_bounties (poster_guid, target_guid, bounty_amount, posted_at) VALUES (123, 456, 100000, UNIX_TIMESTAMP());

-- Notes:
-- - `bounty_amount` is stored in copper. Conversion helpers in C++ expect copper.
-- - Tokens are represented by item entry 90002 (configured elsewhere). Token instance GUIDs may be logged.

