#ifndef ADMIN_HOOKS_H
#define ADMIN_HOOKS_H

#include "Common.h"
#include "Player.h"

class AdminHooks
{
public:
    static void Load();
    static void Unload();

    static void OnPlayerLogin(Player* player);

    static bool HandleAdminCommand(Player* player, const char* command);
    static bool IsGameMaster(uint32 accountId);
    static bool HasPermission(uint32 accountId, uint32 permission);

    static void ApplyFeatureFlag(const std::string& flag, bool enabled);
    static bool IsFeatureEnabled(const std::string& flag);

private:
    static void LoadFeatureFlags();
};

#endif
