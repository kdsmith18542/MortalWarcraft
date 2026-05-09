#include "LogHooks.h"
#include "Player.h"
#include "DatabaseEnv.h"

void LogHooks::Load()
{
    LOG_INFO("module", ">> mod-mortal: LogHooks system loaded");
    InitializeLogTables();
}

void LogHooks::Unload()
{
}

void LogHooks::LogPlayerEvent(uint32 playerGuid, const std::string& eventType, const std::string& details)
{
    LOG_DEBUG("module", "mod-mortal: Player {} event {}: {}", playerGuid, eventType, details);
}

void LogHooks::LogPvPKill(uint32 killerGuid, uint32 victimGuid, uint32 zoneId)
{
    LOG_INFO("module", "mod-mortal: PvP Kill - {} killed {} in zone {}",
             killerGuid, victimGuid, zoneId);
}

void LogHooks::LogEconomyEvent(uint32 playerGuid, const std::string& eventType, int32 goldDelta)
{
    LOG_DEBUG("module", "mod-mortal: Economy {} player {} delta {}", eventType, playerGuid, goldDelta);
}

void LogHooks::LogAdminAction(uint32 gmAccountId, const std::string& action, const std::string& target)
{
    LOG_INFO("module", "mod-mortal: Admin action by account {}: {} on {}", gmAccountId, action, target);
}

void LogHooks::InitializeLogTables()
{
}
