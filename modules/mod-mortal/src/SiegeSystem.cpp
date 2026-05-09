#include "SiegeSystem.h"
#include "Player.h"
#include "Guild.h"
#include "GuildMgr.h"
#include "WorldSession.h"
#include "Chat.h"
#include "StrongholdHandler.h"
#include <unordered_map>

struct SiegeEntry { uint32 strongholdId, attackingGuild, defendingGuild, startTime, duration; std::vector<uint32> attackers, defenders; bool active; };
static std::unordered_map<uint32, SiegeEntry> s_activeSieges;

void SiegeSystem::Load() { LOG_INFO("module", ">> mod-mortal: SiegeSystem loaded"); LoadSiegeData(); }
void SiegeSystem::Unload() { s_activeSieges.clear(); }

void SiegeSystem::Update(uint32 diff)
{
    std::vector<uint32> completed;
    uint32 now = time(nullptr);
    for (auto& pair : s_activeSieges)
        if (pair.second.active && (now - pair.second.startTime) >= pair.second.duration)
            completed.push_back(pair.first);
    for (uint32 id : completed)
    { auto it = s_activeSieges.find(id); if (it != s_activeSieges.end()) EndSiege(id, it->second.defendingGuild); }
}

bool SiegeSystem::StartSiege(Player* player, uint32 strongholdId)
{
    Guild* guild = player->GetGuild();
    if (!guild) { ChatHandler(player->GetSession()).SendSysMessage("You must be in a guild."); return false; }
    if (IsUnderSiege(strongholdId)) { ChatHandler(player->GetSession()).SendSysMessage("Already under siege."); return false; }
    uint32 owner = StrongholdHandler::GetStrongholdOwner(strongholdId);
    if (owner == 0) { ChatHandler(player->GetSession()).SendSysMessage("Stronghold not claimed."); return false; }
    s_activeSieges[strongholdId] = {strongholdId, guild->GetId(), owner, static_cast<uint32>(time(nullptr)), 3600, {}, {}, true};
    ChatHandler(player->GetSession()).SendSysMessage("Siege declared!");
    return true;
}

bool SiegeSystem::EndSiege(uint32 strongholdId, uint32 winningGuild)
{
    auto it = s_activeSieges.find(strongholdId);
    if (it == s_activeSieges.end()) return false;
    if (winningGuild == it->second.attackingGuild) StrongholdHandler::ReleaseStronghold(strongholdId);
    s_activeSieges.erase(it);
    return true;
}

bool SiegeSystem::IsUnderSiege(uint32 strongholdId)
{ auto it = s_activeSieges.find(strongholdId); return it != s_activeSieges.end() && it->second.active; }

uint32 SiegeSystem::GetSiegeTimeRemaining(uint32 strongholdId)
{
    auto it = s_activeSieges.find(strongholdId);
    if (it == s_activeSieges.end() || !it->second.active) return 0;
    uint32 elapsed = time(nullptr) - it->second.startTime;
    return elapsed >= it->second.duration ? 0 : it->second.duration - elapsed;
}

uint32 SiegeSystem::GetSiegeParticipants(uint32 strongholdId)
{
    auto it = s_activeSieges.find(strongholdId);
    return it != s_activeSieges.end() ? static_cast<uint32>(it->second.attackers.size() + it->second.defenders.size()) : 0;
}

void SiegeSystem::LoadSiegeData() {}
