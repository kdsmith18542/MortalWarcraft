-- ==================================================
-- Project Mortal Warcraft
-- Feature: Mortal Codex
-- Description: In-game help entries and per-character unlocks
-- Based on: docs/specs/38-social-and-onboarding-systems.md §5
-- ==================================================

CREATE TABLE IF NOT EXISTS `mortal_codex_entry` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `category` VARCHAR(32) NOT NULL,
  `code` VARCHAR(64) NOT NULL,
  `title` VARCHAR(64) NOT NULL,
  `body_text` TEXT NOT NULL,
  `sort_order` INT NOT NULL DEFAULT 0,
  `flags` INT UNSIGNED NOT NULL DEFAULT 0,
  UNIQUE KEY `uk_codex_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Mortal Codex entries';

CREATE TABLE IF NOT EXISTS `mortal_player_codex` (
  `guid` INT UNSIGNED NOT NULL,
  `codex_code` VARCHAR(64) NOT NULL,
  `unlocked_at` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`guid`, `codex_code`),
  FOREIGN KEY (`guid`) REFERENCES `characters` (`guid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Per-character unlocked codex entries';

INSERT INTO `mortal_codex_entry` (`category`, `code`, `title`, `body_text`, `sort_order`, `flags`) VALUES
('GENERAL', 'CODEX_OVERVIEW', 'Welcome to the Mortal Codex', 'The Mortal Codex is your in-game field guide. Use .codex list to browse topics or .codex view CODE to read a specific entry. Entries unlock automatically when you discover new systems such as Task Boards, Regional Banks, or Red Zones.', 0, 0),
('RISK', 'RED_ZONES', 'Red Zones & Full Loot', 'Red Zones are full-loot areas. If you die here, everything you carry drops into a corpse chest that other players can loot. Travel light, bank valuables, and consider blessing key items before entering.', 10, 0),
('ECONOMY', 'REGIONAL_BANKING', 'Regional Banking', 'Mortal banks are regional. Items stored in a Stormwind vault stay in that vault until you retrieve them. Use banks near trade routes, and remember that siege losses can temporarily lock access to remote vaults.', 20, 0),
('ECONOMY', 'TASK_BOARDS', 'Task Boards & Contracts', 'Task Boards offer procedural contracts in three risk tiers. Green tasks teach basics, Yellow tasks require contested travel, and Red tasks expect escorts or stealth. Always read the payout and risk tier before accepting.', 30, 0),
('ECONOMY', 'BUY_ORDERS', 'Town Buy Orders', 'Quartermasters post buy orders for raw materials. Deliver the requested items before the timer expires to earn Military Credits and stabilize regional markets. Hot Zones increase payouts for specific regions.', 40, 0),
('SAFETY', 'BLESSED_ITEMS', 'Blessed Items & Durability', 'Blessed items survive one death in hostile zones. Speak to a Shrine keeper with a Blessed Ember or Codex Fragment to apply a blessing. Each blessing has limited charges, so reserve it for irreplaceable gear.', 50, 0)
ON DUPLICATE KEY UPDATE `title` = VALUES(`title`), `body_text` = VALUES(`body_text`), `sort_order` = VALUES(`sort_order`);
