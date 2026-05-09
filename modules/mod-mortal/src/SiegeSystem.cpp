#include "SiegeSystem.h"
#include "Player.h"
#include "Guild.h"
#include "GuildMgr.h"
#include "WorldSession.h"
#include "Chat.h"
#include "StrongholdHandler.h"
#include <unordered_map>

struct SiegeEntry
{
    uint32 strongholdId;
    uint32 attackingGuild;
    uint32 defendingGuild;
    uint32 startTime;
    uint32 duration;
    std::vector<uint32> attackers;
    std::vector<uint32> defenders;
    bool active;
};

static std::unordered_map<uint32, SiegeEntry> s_activeSieges;

void SiegeSystem::Load()
{
    LOG_INFO("module", ">> mod-mortal: SiegeSystem loaded");
    LoadSiegeData();
}

void SiegeSystem::Unload()
{
    s_activeSieges.clear();
}

void SiegeSystem::Update(uint32 diff)
{
    std::vector<uint32> completedSieges;
    uint32 now = time(nullptr);

    for (auto& pair : s_activeSieges)
    {
        if (!pair.second.active)
            continue;

        if ((now - pair.second.startTime) >= pair.second.duration)
        {
            completedSieges.push_back(pair.first);
        }
    }

    for (uint32 siegeId : completedSieges)
    {
        auto it = s_activeSieges.find(siegeId);
        if (it != s_activeSieges.end())
        {
            EndSiege(siegeId, it->second.defendingGuild);
        }
    }
}

bool SiegeSystem::StartSiege(Player* player, uint32 strongholdId)
{
    Guild* guild = player->GetGuild();
    if (!guild)
    {
        ChatHandler(player->GetSession()).SendSysMessage("You must be in a guild to start a siege.");
        return false;
    }

    if (IsUnderSiege(strongholdId))
    {
        ChatHandler(player->GetSession()).SendSysMessage("This stronghold is already under siege.");
        return false;
    }

    uint32 ownerGuild = StrongholdHandler::GetStrongholdOwner(strongholdId);
    if (ownerGuild == 0)
    {
        ChatHandler(player->GetSession()).SendSysMessage("This stronghold is not claimed.");
        return false;
    }

    s_activeSieges[strongholdId] =
    {
        strongholdId,
        guild->GetId(),
        ownerGuild,
        static_cast<uint32>(time(nullptr)),
        3600,
        {},
        {},
        true
    };

    ChatHandler(player->GetSession()).SendSysMessage("Siege declared! The battle has begun.");
    return true;
}

bool SiegeSystem::EndSiege(uint32 strongholdId, uint32 winningGuild)
{
    auto it = s_activeSieges.find(strongholdId);
    if (it == s_activeSieges.end())
        return false;

    if (winningGuild == it->second.attackingGuild)
    {
        StrongholdHandler::ReleaseStronghold(strongholdId);
    }

    s_activeSieges.erase(it);
    return true;
}

bool SiegeSystem::IsUnderSiege(uint32 strongholdId)
{
    auto it = s_activeSieges.find(strongholdId);
    return it != s_activeSieges.end() && it->second.active;
}

uint32 SiegeSystem::GetSiegeTimeRemaining(uint32 strongholdId)
{
    auto it = s_activeSieges.find(strongholdId);
    if (it == s_activeSieges.end() || !it->second.active)
        return 0;

    uint32 elapsed = time(nullptr) - it->second.startTime;
    if (elapsed >= it->second.duration)
        return 0;

    return it->second.duration - elapsed;
}

uint32 SiegeSystem::GetSiegeParticipants(uint32 strongholdId)
{
    auto it = s_activeSieges.find(strongholdId);
    if (it == s_activeSieges.end())
        return 0;

    return static_cast<uint32>(it->second.attackers.size() + it->second.defenders.size());
}

void SiegeSystem::LoadSiegeData()
{
}
