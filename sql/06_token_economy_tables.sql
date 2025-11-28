-- ==================================================
-- Project Mortal Warcraft: Token Economy System
-- Module: mod-mortal-core
-- Feature: Account Premium Status Tracking
-- ==================================================

-- Account Premium Status Table
-- Tracks when supporter/premium status expires for each account
CREATE TABLE IF NOT EXISTS `account_premium` (
  `id` INT UNSIGNED NOT NULL COMMENT 'Account ID',
  `premium_until` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Unix timestamp when premium expires (0 = not premium)',
  `last_updated` TIMESTAMP NOT NULL DEFAULT 0 ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_premium_until` (`premium_until`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Tracks premium/supporter status expiration for accounts';

-- Helper function to check if account has active premium status
-- Usage in Lua: CheckPremiumStatus(accountId)
-- Returns: true if premium_until > current_time, false otherwise

