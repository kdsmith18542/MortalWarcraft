#include "StrongholdHandler.h"
#include "Player.h"
#include "Guild.h"
#include "GuildMgr.h"
#include "DatabaseEnv.h"
#include "WorldSession.h"
#include "Chat.h"
#include <unordered_map>

struct StrongholdEntry { uint32 id, zoneId, owningGuild, claimedAt; float posX, posY, posZ; uint32 mapId; };
static std::unordered_map<uint32, StrongholdEntry> s_strongholds;

void StrongholdHandler::Load() { LOG_INFO("module", ">> mod-mortal: StrongholdHandler system loaded"); LoadStrongholdData(); }
void StrongholdHandler::Unload() { s_strongholds.clear(); }

bool StrongholdHandler::ClaimStronghold(Player* player, uint32 strongholdId)
{
    auto it = s_strongholds.find(strongholdId);
    if (it == s_strongholds.end()) { ChatHandler(player->GetSession()).SendSysMessage("Stronghold not found."); return false; }
    if (it->second.owningGuild != 0) { ChatHandler(player->GetSession()).SendSysMessage("Already claimed."); return false; }
    Guild* guild = player->GetGuild();
    if (!guild) { ChatHandler(player->GetSession()).SendSysMessage("You must be in a guild."); return false; }
    it->second.owningGuild = guild->GetId();
    it->second.claimedAt = time(nullptr);
    CharacterDatabasePreparedStatement* stmt = CharacterDatabase.GetPreparedStatement(CHAR_UPD_MORTAL_STRONGHOLD);
    stmt->SetData(0, guild->GetId()); stmt->SetData(1, time(nullptr)); stmt->SetData(2, strongholdId);
    CharacterDatabase.Execute(stmt);
    ChatHandler(player->GetSession()).SendSysMessage("Your guild has claimed this stronghold!");
    return true;
}

bool StrongholdHandler::IsStrongholdOwner(uint32 guildId, uint32 strongholdId)
{ auto it = s_strongholds.find(strongholdId); return it != s_strongholds.end() && it->second.owningGuild == guildId; }

uint32 StrongholdHandler::GetStrongholdOwner(uint32 strongholdId)
{ auto it = s_strongholds.find(strongholdId); return it != s_strongholds.end() ? it->second.owningGuild : 0; }

void StrongholdHandler::ReleaseStronghold(uint32 strongholdId)
{ auto it = s_strongholds.find(strongholdId); if (it == s_strongholds.end()) return; RemoveStrongholdBuffs(it->second.owningGuild); it->second.owningGuild = 0; it->second.claimedAt = 0; }

void StrongholdHandler::ApplyStrongholdBuffs(uint32 guildId) {}
void StrongholdHandler::RemoveStrongholdBuffs(uint32 guildId) {}
bool StrongholdHandler::IsStrongholdLocation(uint32 zoneId)
{ for (auto& pair : s_strongholds) if (pair.second.zoneId == zoneId) return true; return false; }

void StrongholdHandler::LoadStrongholdData()
{ s_strongholds[1] = {1, 33, 0, 0, 0, 0, 0, 0}; s_strongholds[2] = {2, 1, 0, 0, 0, 0, 0, 1}; }
