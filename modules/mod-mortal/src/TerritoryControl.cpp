#include "TerritoryControl.h"
#include "Player.h"
#include "Guild.h"
#include "GuildMgr.h"
#include "DatabaseEnv.h"
#include "WorldSession.h"
#include "Chat.h"
#include <unordered_map>

struct TcpEntry { uint32 id, zoneId, owningGuild, captureProgress, captureTime; float posX, posY, posZ; uint32 mapId; };
static std::unordered_map<uint32, TcpEntry> s_tcpData;

void TerritoryControl::Load() { LOG_INFO("module", ">> mod-mortal: TerritoryControl system loaded"); LoadTcpData(); }
void TerritoryControl::Unload() { s_tcpData.clear(); }

bool TerritoryControl::CapturePoint(Player* player, uint32 tcpId)
{
    auto it = s_tcpData.find(tcpId);
    if (it == s_tcpData.end()) return false;
    Guild* guild = player->GetGuild();
    if (!guild) return false;
    it->second.owningGuild = guild->GetId();
    it->second.captureProgress = 100;
    ApplyZoneEffects(it->second.zoneId, guild->GetId());
    return true;
}

uint32 TerritoryControl::GetTcpOwner(uint32 tcpId)
{ auto it = s_tcpData.find(tcpId); return it != s_tcpData.end() ? it->second.owningGuild : 0; }

uint32 TerritoryControl::GetTcpProgress(uint32 tcpId)
{ auto it = s_tcpData.find(tcpId); return it != s_tcpData.end() ? it->second.captureProgress : 0; }

void TerritoryControl::Update(uint32 diff) {}
void TerritoryControl::ApplyZoneEffects(uint32 zoneId, uint32 controllingGuild) {}
void TerritoryControl::LoadTcpData() { s_tcpData[1] = {1, 33, 0, 0, 0, 0, 0, 0}; s_tcpData[2] = {2, 1, 0, 0, 0, 0, 0, 1}; }
