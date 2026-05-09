#ifndef LOG_HOOKS_H
#define LOG_HOOKS_H

#include "Common.h"
#include "Player.h"

class LogHooks
{
public:
    static void Load();
    static void Unload();

    static void LogPlayerEvent(uint32 playerGuid, const std::string& eventType, const std::string& details);
    static void LogPvPKill(uint32 killerGuid, uint32 victimGuid, uint32 zoneId);
    static void LogEconomyEvent(uint32 playerGuid, const std::string& eventType, int32 goldDelta);
    static void LogAdminAction(uint32 gmAccountId, const std::string& action, const std::string& target);

private:
    static void InitializeLogTables();
};

#endif
