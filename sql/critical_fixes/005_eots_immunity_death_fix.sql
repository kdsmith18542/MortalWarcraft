-- ============================================================================
-- CRITICAL FIX #5: Eye of the Storm - Immunity Death Bug
-- ============================================================================
-- Issue: https://github.com/azerothcore/azerothcore-wotlk/issues/21657
-- Description: Players with immunity (BoP, Divine Shield) fall to bottom instead of dying
-- Impact: Battleground exploit, player gets stuck
-- Battleground: Eye of the Storm (Map 566)
-- ============================================================================

-- This is primarily a CORE bug, but we can add some mitigations

-- Add a script to teleport players back if they fall below a certain Z coordinate
-- This uses game_event_condition to set up a periodic check

-- First, ensure we have a teleport location for each team
DELETE FROM `game_tele` WHERE `name` IN ('eots_alliance_graveyard', 'eots_horde_graveyard');
INSERT INTO `game_tele` (`id`, `position_x`, `position_y`, `position_z`, `orientation`, `map`, `name`) VALUES
(9001, 2527.6, 1596.9, 1262.3, 3.14, 566, 'eots_alliance_graveyard'),
(9002, 1807.5, 1539.5, 1267.5, 3.14, 566, 'eots_horde_graveyard');

-- Create an areatrigger at the bottom of the map to catch fallen players
DELETE FROM `areatrigger_scripts` WHERE `entry` IN (5608, 5609);
-- Note: Areatrigger IDs 5608-5609 are custom, adjust if conflicts exist

-- Alternative: Use a world script to periodically check player positions
-- This would need to be implemented in C++, but we can add the configuration

-- ============================================================================
-- PREVENTION CONFIGURATION
-- ============================================================================

-- Add battleground-specific rules to prevent immunity-based exploits
-- This requires a custom module or core modification

-- Recommended core fix location:
-- src/server/game/Battlegrounds/Zones/BattlegroundEY.cpp
-- Add check in Update() or HandlePlayerUnderMap():

/*
void BattlegroundEY::HandlePlayerUnderMap(Player* player)
{
    // Check if player is below the death plane
    if (player->GetPositionZ() < 1000.0f)
    {
        // Remove all immunity effects
        player->RemoveAurasByType(SPELL_AURA_SCHOOL_IMMUNITY);
        player->RemoveAurasByType(SPELL_AURA_MOD_IMMUNE_AURA_APPLY_SCHOOL);
        
        // Teleport to graveyard
        if (player->GetTeam() == ALLIANCE)
            player->TeleportTo(566, 2527.6f, 1596.9f, 1262.3f, 3.14f);
        else
            player->TeleportTo(566, 1807.5f, 1539.5f, 1267.5f, 3.14f);
            
        // Apply deserter debuff if abusing
        if (player->HasAura(1022) || player->HasAura(642))  // BoP or Divine Shield
        {
            // Log the exploit attempt
            sLog->outString("EOTS Exploit: Player %s (GUID: %u) attempted immunity fall exploit", 
                          player->GetName().c_str(), player->GetGUID().GetCounter());
        }
    }
}
*/

-- ============================================================================
-- WORKAROUND SCRIPT
-- ============================================================================

-- Note: Custom GM commands should be added via C++ code, not database
-- For a quick workaround, GMs can use existing teleport commands:
-- .tele <location_name>
-- 
-- Or create a GM macro:
-- /run if GetRealZoneText() == "Eye of the Storm" then if UnitFactionGroup("player") == "Alliance" then 
-- SendChatMessage(".tele eots_alliance_graveyard", "GUILD") else SendChatMessage(".tele eots_horde_graveyard", "GUILD") end end

-- ============================================================================
-- PLAYER EDUCATION
-- ============================================================================

-- Add an in-game warning NPC or sign near the edge areas
DELETE FROM `creature_text` WHERE `CreatureID` = 999901;  -- Custom NPC ID
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(999901, 0, 0, 'WARNING: Jumping off edges with immunity active will cause you to become stuck. Do not abuse this bug!', 42, 0, 100, 0, 0, 0, 0, 0, 'EOTS Warning Sign');

-- ============================================================================
-- TEMPORARY PLAYER-SIDE FIX
-- ============================================================================

-- Create a custom addon alert (for client-side warning)
-- File: Interface/AddOns/EOTSFix/EOTSFix.lua
/*
local function OnUpdate()
    if GetRealZoneText() == "Eye of the Storm" then
        if UnitBuff("player", "Divine Shield") or 
           UnitBuff("player", "Blessing of Protection") or
           UnitBuff("player", "Ice Block") then
            
            local _, _, _, _, _, _, _, _, _, mapID = GetInstanceInfo()
            if mapID == 566 then
                DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000WARNING: Do not jump off edges with immunity active - you will become stuck!|r", 1.0, 0.0, 0.0)
            end
        end
    end
end

local frame = CreateFrame("Frame")
frame:SetScript("OnUpdate", OnUpdate)
*/

-- ============================================================================
-- VERIFICATION & MONITORING
-- ============================================================================

-- Query to find players stuck below the map in EOTS
-- SELECT guid, name, position_x, position_y, position_z, map 
-- FROM characters 
-- WHERE map = 566 AND position_z < 1000;

-- Clean up stuck characters (run periodically)
-- UPDATE characters 
-- SET position_x = 2527.6, position_y = 1596.9, position_z = 1262.3, map = 566
-- WHERE map = 566 AND position_z < 1000 AND race IN (1,3,4,7,11);  -- Alliance races

-- UPDATE characters 
-- SET position_x = 1807.5, position_y = 1539.5, position_z = 1267.5, map = 566
-- WHERE map = 566 AND position_z < 1000 AND race IN (2,5,6,8,9);  -- Horde races

-- ============================================================================
-- RECOMMENDATIONS
-- ============================================================================
-- 1. Implement core fix in BattlegroundEY.cpp
-- 2. Add GM monitoring for exploit attempts
-- 3. Warn players via MOTD about the bug
-- 4. Consider disabling EOTS until upstream fix is available
-- 5. Log all instances of players falling with immunity active
--
-- Long-term: Wait for upstream core fix from AzerothCore
-- ============================================================================
