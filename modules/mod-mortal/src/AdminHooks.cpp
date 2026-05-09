#include "AdminHooks.h"
#include "Player.h"
#include "WorldSession.h"
#include "Chat.h"
#include "DatabaseEnv.h"
#include <unordered_map>
#include <unordered_set>

static std::unordered_set<uint32> s_gameMasterAccounts;
static std::unordered_map<std::string, bool> s_featureFlags;

void AdminHooks::Load() { LOG_INFO("module", ">> mod-mortal: AdminHooks system loaded"); LoadFeatureFlags(); }
void AdminHooks::Unload() { s_gameMasterAccounts.clear(); s_featureFlags.clear(); }

void AdminHooks::OnPlayerLogin(Player* player)
{ if (IsGameMaster(player->GetSession()->GetAccountId())) s_gameMasterAccounts.insert(player->GetSession()->GetAccountId()); }

bool AdminHooks::HandleAdminCommand(Player* player, const char* command)
{
    if (!IsGameMaster(player->GetSession()->GetAccountId())) return false;
    std::string cmd(command);
    if (cmd == "reload flags") { LoadFeatureFlags(); ChatHandler(player->GetSession()).SendSysMessage("Feature flags reloaded."); return true; }
    return false;
}

bool AdminHooks::IsGameMaster(uint32 accountId) { return s_gameMasterAccounts.find(accountId) != s_gameMasterAccounts.end(); }
bool AdminHooks::HasPermission(uint32 accountId, uint32 permission) { return IsGameMaster(accountId); }

void AdminHooks::ApplyFeatureFlag(const std::string& flag, bool enabled) { s_featureFlags[flag] = enabled; }
bool AdminHooks::IsFeatureEnabled(const std::string& flag)
{ auto it = s_featureFlags.find(flag); return it == s_featureFlags.end() || it->second; }

void AdminHooks::LoadFeatureFlags()
{
    s_featureFlags["notoriety"] = true;
    s_featureFlags["bounties"] = true;
    s_featureFlags["sieges"] = true;
    s_featureFlags["caravans"] = true;
    s_featureFlags["crafting"] = true;
    s_featureFlags["risk_zones"] = true;
    s_featureFlags["regional_banking"] = true;
}
