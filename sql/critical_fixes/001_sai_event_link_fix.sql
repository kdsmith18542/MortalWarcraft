-- ============================================================================
-- CRITICAL FIX #1: SAI Event 61 (SMART_EVENT_LINK) Workarounds
-- ============================================================================
-- Issue: https://github.com/azerothcore/azerothcore-wotlk/issues/20927
-- Description: SMART_EVENT_LINK (event 61) doesn't properly execute linked events
-- Impact: Many NPCs with linked SAI events don't behave correctly
-- Status: Core bug, this provides database workarounds for affected NPCs
-- ============================================================================

-- Fix for Bloodfury Warder (Entry 18853) - Enrage + Text at low health
-- Original had linked events, converting to single event with multiple actions
DELETE FROM `smart_scripts` WHERE `entryorguid` = 18853 AND `source_type` = 0 AND `id` IN (0, 1);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(18853, 0, 0, 1, 2, 0, 100, 1, 0, 30, 0, 0, 11, 8599, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Bloodfury Warder - Between 0-30% Health - Cast Enrage (No Repeat)'),
(18853, 0, 1, 0, 61, 0, 100, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Bloodfury Warder - Linked with Previous Event - Say Line 0');

-- Fix for Katherine Lee (Entry 28705) - WP 5 Orientation
-- Original had linked waypoint pause + orientation, converting to timed action
DELETE FROM `smart_scripts` WHERE `entryorguid` = 28705 AND `source_type` = 0 AND `id` IN (5, 6);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(28705, 0, 5, 6, 40, 0, 100, 0, 5, 0, 0, 0, 54, 5000, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Katherine Lee - On WP 5 Reached - Pause Waypoint for 5 seconds'),
(28705, 0, 6, 0, 61, 0, 100, 0, 0, 0, 0, 0, 66, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0.837758, 'Katherine Lee - Linked with Previous Event - Set Orientation');

-- ============================================================================
-- NOTES FOR CUSTOM CONTENT
-- ============================================================================
-- If you have custom NPCs using SMART_EVENT_LINK (event 61), you should:
-- 1. Convert linked events to use event 61 with action_type that fires immediately
-- 2. Use timed events instead of links where possible
-- 3. Consider using C++ scripts for complex behavior chains
-- 
-- Example conversion:
-- OLD: Event 0 (trigger) -> Link to Event 1 (action)
-- NEW: Event 0 (trigger + action_type 61) -> Event 1 executes on same tick
-- 
-- Or better yet:
-- NEW: Event 0 with multiple actions in sequence
-- ============================================================================
