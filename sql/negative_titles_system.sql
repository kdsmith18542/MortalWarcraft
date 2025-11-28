-- Negative Titles & Notoriety Labels System
-- Spec 56 Implementation
-- Creates system-enforced negative titles based on notoriety scores, crime behaviors, and faction disgrace

-- ===========================================
-- TABLES
-- ===========================================

-- Negative Title Definitions
CREATE TABLE IF NOT EXISTS `mortal_negative_titles` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `code` VARCHAR(64) NOT NULL UNIQUE,
  `name` VARCHAR(128) NOT NULL,
  `description` TEXT NOT NULL,
  `category` VARCHAR(16) NOT NULL,
  `priority` INT NOT NULL DEFAULT 0,
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  INDEX `idx_category_priority` (`category`, `priority`),
  INDEX `idx_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Title Conditions (triggers)
CREATE TABLE IF NOT EXISTS `mortal_negative_title_conditions` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `title_id` INT NOT NULL,
  `condition_type` VARCHAR(32) NOT NULL,
  `param_json` JSON NOT NULL,
  CONSTRAINT `fk_mortal_negative_title_conditions_title`
    FOREIGN KEY (`title_id`) REFERENCES `mortal_negative_titles`(`id`)
    ON DELETE CASCADE,
  INDEX `idx_title_condition` (`title_id`, `condition_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Per-Character Active Title State
CREATE TABLE IF NOT EXISTS `mortal_negative_title_state` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `guid` INT NOT NULL,
  `active_title_id` INT NULL,
  `last_update_ts` INT NOT NULL,
  `history_json` JSON NULL,
  UNIQUE KEY `uniq_guid` (`guid`),
  CONSTRAINT `fk_mortal_negative_title_state_title`
    FOREIGN KEY (`active_title_id`) REFERENCES `mortal_negative_titles`(`id`)
    ON DELETE SET NULL,
  INDEX `idx_active_title` (`active_title_id`),
  INDEX `idx_last_update` (`last_update_ts`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Crime Counters (for behavioral titles)
CREATE TABLE IF NOT EXISTS `mortal_crime_counters` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `guid` INT NOT NULL,
  `crime_code` VARCHAR(64) NOT NULL,
  `count` INT NOT NULL DEFAULT 0,
  `last_incident_ts` INT NOT NULL,
  `window_sum` INT NOT NULL DEFAULT 0,
  `window_start_ts` INT NOT NULL,
  UNIQUE KEY `uniq_guid_crime` (`guid`, `crime_code`),
  INDEX `idx_crime_code` (`crime_code`),
  INDEX `idx_last_incident` (`last_incident_ts`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Player Bounties (for bounty system)
CREATE TABLE IF NOT EXISTS `player_bounties` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `guid` INT NOT NULL,
  `bounty_amount` INT NOT NULL DEFAULT 0,
  `last_updated` INT NOT NULL,
  UNIQUE KEY `uniq_guid` (`guid`),
  INDEX `idx_bounty_amount` (`bounty_amount`),
  INDEX `idx_last_updated` (`last_updated`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Atonement Progress (for redemption quests)
CREATE TABLE IF NOT EXISTS `character_atonement_progress` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `guid` INT NOT NULL,
  `title_code` VARCHAR(64) NOT NULL,
  `start_time` INT NOT NULL,
  `end_time` INT NOT NULL,
  `objectives_json` JSON NOT NULL,
  `status` ENUM('ACTIVE', 'COMPLETED', 'FAILED', 'EXPIRED') NOT NULL DEFAULT 'ACTIVE',
  `completed_time` INT NULL,
  UNIQUE KEY `uniq_guid_title` (`guid`, `title_code`),
  INDEX `idx_status` (`status`),
  INDEX `idx_end_time` (`end_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===========================================
-- SEED DATA: NOTORIETY TITLES
-- ===========================================

INSERT INTO `mortal_negative_titles` (`code`, `name`, `description`, `category`, `priority`) VALUES
('NOTO_PETTY_CUTPURSE', 'Petty Cutpurse', 'A minor thief who preys on the weak and unguarded.', 'NOTORIETY', 10),
('NOTO_ROADSIDE_MENACE', 'Roadside Menace', 'A dangerous predator who ambushes travelers on the roads.', 'NOTORIETY', 20),
('NOTO_BUTCHER_OF_WAYS', 'Butcher of the Ways', 'A ruthless killer who stains the trade routes with blood.', 'NOTORIETY', 30),
('NOTO_REDHANDED', 'Redhanded', 'A wanted criminal who refuses to atone for their crimes.', 'NOTORIETY', 40),
('NOTO_SCOURGE_FRONTIER', 'Scourge of the Frontier', 'A legendary outlaw whose name strikes fear across the lands.', 'NOTORIETY', 50);

-- Notoriety Title Conditions
INSERT INTO `mortal_negative_title_conditions` (`title_id`, `condition_type`, `param_json`) VALUES
-- Petty Cutpurse: 500 <= N < 1500
((SELECT id FROM mortal_negative_titles WHERE code = 'NOTO_PETTY_CUTPURSE'), 'NOTORIETY_THRESHOLD', JSON_OBJECT('min', 500, 'max', 1499)),
-- Roadside Menace: 1500 <= N < 4000
((SELECT id FROM mortal_negative_titles WHERE code = 'NOTO_ROADSIDE_MENACE'), 'NOTORIETY_THRESHOLD', JSON_OBJECT('min', 1500, 'max', 3999)),
-- Butcher of the Ways: 4000 <= N < 8000
((SELECT id FROM mortal_negative_titles WHERE code = 'NOTO_BUTCHER_OF_WAYS'), 'NOTORIETY_THRESHOLD', JSON_OBJECT('min', 4000, 'max', 7999)),
-- Redhanded: 8000 <= N < 15000
((SELECT id FROM mortal_negative_titles WHERE code = 'NOTO_REDHANDED'), 'NOTORIETY_THRESHOLD', JSON_OBJECT('min', 8000, 'max', 14999)),
-- Scourge of the Frontier: N >= 15000
((SELECT id FROM mortal_negative_titles WHERE code = 'NOTO_SCOURGE_FRONTIER'), 'NOTORIETY_THRESHOLD', JSON_OBJECT('min', 15000, 'max', 999999));

-- ===========================================
-- SEED DATA: CRIME BEHAVIOR TITLES
-- ===========================================

INSERT INTO `mortal_negative_titles` (`code`, `name`, `description`, `category`, `priority`) VALUES
('CRIME_GUTTER_THIEF', 'Gutter-Thief', 'A desperate pickpocket who steals from the poor and desperate.', 'CRIME', 5),
('CRIME_GRAVE_ROBBER', 'Grave Robber', 'A desecrator who disturbs the dead for personal gain.', 'CRIME', 6),
('CRIME_FENCE', 'Fence of Ill Repute', 'A shady dealer who profits from stolen goods and black market trade.', 'CRIME', 7),
('CRIME_CONTRACT_BREAKER', 'Contract Breaker', 'An unreliable mercenary who abandons their sworn duties.', 'CRIME', 8),
('CRIME_SMUGGLER', 'Cloaked Smuggler', 'A shadow trader who evades authorities with illicit goods.', 'CRIME', 9),
('CRIME_SHADOW_ROUTES', 'Shadow of the Routes', 'A master smuggler whose network spans the frontier.', 'CRIME', 10);

-- Crime Title Conditions (7-day windows)
INSERT INTO `mortal_negative_title_conditions` (`title_id`, `condition_type`, `param_json`) VALUES
-- Gutter-Thief: THIEVERY_ITEMS_STOLEN >= 10 in 7 days
((SELECT id FROM mortal_negative_titles WHERE code = 'CRIME_GUTTER_THIEF'), 'CRIME_COUNTER', JSON_OBJECT('crime_code', 'THIEVERY_ITEMS_STOLEN', 'min', 10, 'window_sec', 604800)),
-- Grave Robber: GRAVE_LOOTS >= 10 in 7 days
((SELECT id FROM mortal_negative_titles WHERE code = 'CRIME_GRAVE_ROBBER'), 'CRIME_COUNTER', JSON_OBJECT('crime_code', 'GRAVE_LOOTS', 'min', 10, 'window_sec', 604800)),
-- Fence of Ill Repute: BLACKMARKET_SALES >= 50 gold volume in 7 days
((SELECT id FROM mortal_negative_titles WHERE code = 'CRIME_FENCE'), 'CRIME_COUNTER', JSON_OBJECT('crime_code', 'BLACKMARKET_SALES_GOLD', 'min', 50, 'window_sec', 604800)),
-- Contract Breaker: CONTRACT_FAILS >= 5 in 7 days
((SELECT id FROM mortal_negative_titles WHERE code = 'CRIME_CONTRACT_BREAKER'), 'CRIME_COUNTER', JSON_OBJECT('crime_code', 'CONTRACT_FAILS', 'min', 5, 'window_sec', 604800)),
-- Cloaked Smuggler: SMUGGLER_RUNS_SUCCESS >= 10 in 7 days
((SELECT id FROM mortal_negative_titles WHERE code = 'CRIME_SMUGGLER'), 'CRIME_COUNTER', JSON_OBJECT('crime_code', 'SMUGGLER_RUNS_SUCCESS', 'min', 10, 'window_sec', 604800)),
-- Shadow of the Routes: High volume smuggling + low detection (complex condition)
((SELECT id FROM mortal_negative_titles WHERE code = 'CRIME_SHADOW_ROUTES'), 'CRIME_COUNTER', JSON_OBJECT('crime_code', 'SMUGGLER_RUNS_SUCCESS', 'min', 25, 'window_sec', 604800));

-- ===========================================
-- SEED DATA: FACTION DISGRACE TITLES
-- ===========================================

INSERT INTO `mortal_negative_titles` (`code`, `name`, `description`, `category`, `priority`) VALUES
('FACT_EXCOMMUNICATED', 'Excommunicated', 'Banished from the sacred Order of the Shrine for grave offenses.', 'FACTION', 25),
('FACT_PERSONA_NON_GRATA', 'Persona Non Grata', 'Declared unwelcome by the Iron Ledger for betraying trade agreements.', 'FACTION', 26),
('FACT_MARK_SNITCH', 'Mark of the Snitch', 'Branded by the Black Sun Cartel for informing on their operations.', 'FACTION', 27),
('FACT_OATHBREAKER_PACT', 'Oathbreaker of the Pact', 'Forsworn member of the Rangers\' Pact who abandoned their sacred duties.', 'FACTION', 28);

-- Faction Title Conditions
INSERT INTO `mortal_negative_title_conditions` (`title_id`, `condition_type`, `param_json`) VALUES
-- Excommunicated: Order of the Shrine standing <= -50000
((SELECT id FROM mortal_negative_titles WHERE code = 'FACT_EXCOMMUNICATED'), 'FACTION_STANDING', JSON_OBJECT('faction_code', 'ORDER_SHRINE', 'max', -50000)),
-- Persona Non Grata: Iron Ledger standing <= -30000
((SELECT id FROM mortal_negative_titles WHERE code = 'FACT_PERSONA_NON_GRATA'), 'FACTION_STANDING', JSON_OBJECT('faction_code', 'IRON_LEDGER', 'max', -30000)),
-- Mark of the Snitch: Black Sun Cartel standing <= -25000 (plus snitch actions)
((SELECT id FROM mortal_negative_titles WHERE code = 'FACT_MARK_SNITCH'), 'FACTION_STANDING', JSON_OBJECT('faction_code', 'BLACK_SUN_CARTEL', 'max', -25000)),
-- Oathbreaker of the Pact: Rangers' Pact standing <= -40000
((SELECT id FROM mortal_negative_titles WHERE code = 'FACT_OATHBREAKER_PACT'), 'FACTION_STANDING', JSON_OBJECT('faction_code', 'RANGERS_PACT', 'max', -40000));

-- ===========================================
-- UTILITY PROCEDURES
-- ===========================================

-- Procedure to update character negative title state
DELIMITER //

CREATE PROCEDURE `UpdateCharacterNegativeTitle`(IN p_guid INT)
BEGIN
    DECLARE v_active_title_id INT DEFAULT NULL;
    DECLARE v_current_ts INT DEFAULT UNIX_TIMESTAMP();

    -- Find highest priority eligible title
    SELECT t.id INTO v_active_title_id
    FROM mortal_negative_titles t
    INNER JOIN mortal_negative_title_conditions c ON t.id = c.title_id
    WHERE t.is_active = 1
    AND (
        -- Notoriety threshold check
        (c.condition_type = 'NOTORIETY_THRESHOLD' AND
         JSON_EXTRACT(c.param_json, '$.min') <= (SELECT COALESCE(notoriety, 0) FROM character_notoriety WHERE guid = p_guid) AND
         (SELECT COALESCE(notoriety, 0) FROM character_notoriety WHERE guid = p_guid) <= JSON_EXTRACT(c.param_json, '$.max'))

        -- Crime counter check
        OR (c.condition_type = 'CRIME_COUNTER' AND
            JSON_EXTRACT(c.param_json, '$.min') <= (SELECT COALESCE(window_sum, 0) FROM mortal_crime_counters
                                                    WHERE guid = p_guid AND crime_code = JSON_UNQUOTE(JSON_EXTRACT(c.param_json, '$.crime_code'))))

        -- Faction standing check (placeholder - would need faction system integration)
        OR (c.condition_type = 'FACTION_STANDING' AND 0) -- Placeholder for faction integration
    )
    ORDER BY t.priority DESC
    LIMIT 1;

    -- Update or insert state
    INSERT INTO mortal_negative_title_state (guid, active_title_id, last_update_ts, history_json)
    VALUES (p_guid, v_active_title_id, v_current_ts,
            CASE WHEN v_active_title_id IS NOT NULL THEN
                JSON_ARRAY(JSON_OBJECT('title_id', v_active_title_id, 'timestamp', v_current_ts, 'action', 'assigned'))
            ELSE NULL END)
    ON DUPLICATE KEY UPDATE
        active_title_id = v_active_title_id,
        last_update_ts = v_current_ts,
        history_json = CASE WHEN active_title_id != v_active_title_id OR active_title_id IS NULL THEN
            JSON_ARRAY_APPEND(COALESCE(history_json, JSON_ARRAY()),
                '$',
                JSON_OBJECT('title_id', v_active_title_id, 'timestamp', v_current_ts,
                           'action', CASE WHEN v_active_title_id IS NOT NULL THEN 'assigned' ELSE 'removed' END))
        ELSE history_json END;
END //

-- Procedure to increment crime counter
CREATE PROCEDURE `IncrementCrimeCounter`(IN p_guid INT, IN p_crime_code VARCHAR(64), IN p_window_sec INT)
BEGIN
    DECLARE v_current_ts INT DEFAULT UNIX_TIMESTAMP();
    DECLARE v_window_start INT DEFAULT v_current_ts - p_window_sec;

    INSERT INTO mortal_crime_counters (guid, crime_code, count, last_incident_ts, window_sum, window_start_ts)
    VALUES (p_guid, p_crime_code, 1, v_current_ts, 1, v_window_start)
    ON DUPLICATE KEY UPDATE
        count = count + 1,
        last_incident_ts = v_current_ts,
        window_sum = CASE WHEN window_start_ts < v_window_start THEN 1 ELSE window_sum + 1 END,
        window_start_ts = CASE WHEN window_start_ts < v_window_start THEN v_window_start ELSE window_start_ts END;

    -- Trigger title update
    CALL UpdateCharacterNegativeTitle(p_guid);
END //

-- Procedure to decay crime counters (call periodically)
CREATE PROCEDURE `DecayCrimeCounters`(IN p_decay_window_sec INT)
BEGIN
    DECLARE v_cutoff_ts INT DEFAULT UNIX_TIMESTAMP() - p_decay_window_sec;

    -- Reset window sums for old entries
    UPDATE mortal_crime_counters
    SET window_sum = 0, window_start_ts = UNIX_TIMESTAMP()
    WHERE last_incident_ts < v_cutoff_ts;

    -- Update all character title states after decay
    UPDATE mortal_negative_title_state
    SET last_update_ts = UNIX_TIMESTAMP()
    WHERE guid IN (
        SELECT DISTINCT guid FROM mortal_crime_counters
        WHERE last_incident_ts < v_cutoff_ts
    );
END //

DELIMITER ;

-- ===========================================
-- INDEXES FOR PERFORMANCE
-- ===========================================

-- Additional indexes for performance
CREATE INDEX idx_crime_counters_window ON mortal_crime_counters (window_start_ts, window_sum);
CREATE INDEX idx_title_state_guid_update ON mortal_negative_title_state (guid, last_update_ts);