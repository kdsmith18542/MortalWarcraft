-- ==================================================
-- Project Mortal Warcraft
-- Feature: Season Challenge Definitions
-- Description: Populates season challenges for the challenge track system
-- Based on: docs/specs/52-season-of-the-frontier.md
-- ==================================================

-- Daily Challenges
INSERT INTO `mortal_challenges` (`season_id`, `challenge_code`, `name`, `description`, `challenge_type`, `target_type`, `target_value`, `xp_reward`, `currency_reward_type`, `currency_reward_amount`, `item_reward_entry`, `is_repeatable`, `max_completions_per_day`, `sort_order`, `is_active`) VALUES
-- Get current season ID (assuming season 1 exists)
((SELECT id FROM mortal_seasons ORDER BY start_date DESC LIMIT 1), 'DAILY_KILL_10', 'Daily Slayer', 'Kill 10 creatures', 'DAILY', 'KILL_CREATURES', 10, 100, 'XP', 0, NULL, 1, 1, 1, 1),
((SELECT id FROM mortal_seasons ORDER BY start_date DESC LIMIT 1), 'DAILY_GATHER_5', 'Daily Gatherer', 'Gather 5 resources', 'DAILY', 'GATHER_RESOURCES', 5, 100, 'XP', 0, NULL, 1, 1, 2, 1),
((SELECT id FROM mortal_seasons ORDER BY start_date DESC LIMIT 1), 'DAILY_CRAFT_3', 'Daily Crafter', 'Craft 3 items', 'DAILY', 'CRAFT_ITEMS', 3, 100, 'XP', 0, NULL, 1, 1, 3, 1),
((SELECT id FROM mortal_seasons ORDER BY start_date DESC LIMIT 1), 'DAILY_PVP_KILL', 'Daily PvP', 'Kill 1 player in PvP', 'DAILY', 'KILL_PLAYERS', 1, 150, 'XP', 0, NULL, 1, 1, 4, 1),
((SELECT id FROM mortal_seasons ORDER BY start_date DESC LIMIT 1), 'DAILY_FISH_5', 'Daily Angler', 'Catch 5 fish', 'DAILY', 'CATCH_FISH', 5, 100, 'XP', 0, NULL, 1, 1, 5, 1)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `description` = VALUES(`description`);

-- Weekly Challenges
INSERT INTO `mortal_challenges` (`season_id`, `challenge_code`, `name`, `description`, `challenge_type`, `target_type`, `target_value`, `xp_reward`, `currency_reward_type`, `currency_reward_amount`, `item_reward_entry`, `is_repeatable`, `max_completions_per_day`, `sort_order`, `is_active`) VALUES
((SELECT id FROM mortal_seasons ORDER BY start_date DESC LIMIT 1), 'WEEKLY_DUNGEON_5', 'Weekly Dungeon Runner', 'Complete 5 dungeon runs', 'WEEKLY', 'COMPLETE_DUNGEONS', 5, 500, 'XP', 0, NULL, 1, 1, 10, 1),
((SELECT id FROM mortal_seasons ORDER BY start_date DESC LIMIT 1), 'WEEKLY_PVP_WINS_10', 'Weekly PvP Champion', 'Win 10 PvP matches', 'WEEKLY', 'WIN_PVP_MATCHES', 10, 750, 'XP', 0, NULL, 1, 1, 11, 1),
((SELECT id FROM mortal_seasons ORDER BY start_date DESC LIMIT 1), 'WEEKLY_CARAVAN_3', 'Weekly Courier', 'Complete 3 caravan contracts', 'WEEKLY', 'COMPLETE_CARAVANS', 3, 400, 'XP', 0, NULL, 1, 1, 12, 1),
((SELECT id FROM mortal_seasons ORDER BY start_date DESC LIMIT 1), 'WEEKLY_RAID_BOSS', 'Weekly Raid Boss', 'Kill 1 raid boss', 'WEEKLY', 'KILL_RAID_BOSSES', 1, 1000, 'XP', 0, NULL, 1, 1, 13, 1),
((SELECT id FROM mortal_seasons ORDER BY start_date DESC LIMIT 1), 'WEEKLY_FACTION_500', 'Weekly Faction Work', 'Gain 500 faction standing', 'WEEKLY', 'GAIN_FACTION_STANDING', 500, 300, 'XP', 0, NULL, 1, 1, 14, 1)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `description` = VALUES(`description`);

-- Seasonal Challenges
INSERT INTO `mortal_challenges` (`season_id`, `challenge_code`, `name`, `description`, `challenge_type`, `target_type`, `target_value`, `xp_reward`, `currency_reward_type`, `currency_reward_amount`, `item_reward_entry`, `is_repeatable`, `max_completions_per_day`, `sort_order`, `is_active`) VALUES
((SELECT id FROM mortal_seasons ORDER BY start_date DESC LIMIT 1), 'SEASONAL_KILL_1000', 'Season Slayer', 'Kill 1000 creatures', 'SEASONAL', 'KILL_CREATURES', 1000, 2000, 'XP', 0, NULL, 0, 0, 20, 1),
((SELECT id FROM mortal_seasons ORDER BY start_date DESC LIMIT 1), 'SEASONAL_PVP_KILL_100', 'Season PvP Master', 'Kill 100 players', 'SEASONAL', 'KILL_PLAYERS', 100, 3000, 'XP', 0, NULL, 0, 0, 21, 1),
((SELECT id FROM mortal_seasons ORDER BY start_date DESC LIMIT 1), 'SEASONAL_DUNGEON_50', 'Season Dungeon Master', 'Complete 50 dungeons', 'SEASONAL', 'COMPLETE_DUNGEONS', 50, 2500, 'XP', 0, NULL, 0, 0, 22, 1),
((SELECT id FROM mortal_seasons ORDER BY start_date DESC LIMIT 1), 'SEASONAL_CRAFT_200', 'Season Master Crafter', 'Craft 200 items', 'SEASONAL', 'CRAFT_ITEMS', 200, 2000, 'XP', 0, NULL, 0, 0, 23, 1),
((SELECT id FROM mortal_seasons ORDER BY start_date DESC LIMIT 1), 'SEASONAL_FACTION_EXALTED', 'Season Faction Champion', 'Reach Exalted with any faction', 'SEASONAL', 'REACH_FACTION_RANK', 7, 5000, 'XP', 0, NULL, 0, 0, 24, 1)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `description` = VALUES(`description`);

-- Summary
SELECT 
    'Season Challenges Created' as summary,
    COUNT(CASE WHEN challenge_type = 'DAILY' THEN 1 END) as daily_challenges,
    COUNT(CASE WHEN challenge_type = 'WEEKLY' THEN 1 END) as weekly_challenges,
    COUNT(CASE WHEN challenge_type = 'SEASONAL' THEN 1 END) as seasonal_challenges,
    COUNT(*) as total_challenges
FROM mortal_challenges;

