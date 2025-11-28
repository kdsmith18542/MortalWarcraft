-- ==================================================
-- Project Mortal Warcraft
-- Feature: Guard Entries for Siege/Territory Enforcement
-- Description: List of creature_template entries treated as guards for KOS/deterrence
-- ==================================================

CREATE TABLE IF NOT EXISTS `mortal_guard_entries` (
  `creature_entry` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`creature_entry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Guard creature entries used for siege/territory enforcement';

-- Seed with default city/zone guards (extend as needed)
INSERT IGNORE INTO `mortal_guard_entries` (`creature_entry`) VALUES
(68),    -- Stormwind City Guard
(3296),  -- Orgrimmar Grunt
(4262),  -- Darnassus Sentinel
(5624),  -- Undercity Guardian
(4263),  -- Silvermoon Guardian
(11822); -- Moonglade Warder

SELECT 'mortal_guard_entries created/seeded' AS result;
