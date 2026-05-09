#include "ZoneRiskHandler.h"
#include "Player.h"
#include "WorldSession.h"
#include "Chat.h"
#include "DatabaseEnv.h"
#include <unordered_map>
static std::unordered_map<uint32, uint32> s_zoneRiskTiers;

void ZoneRiskHandler::Load()
{
    LOG_INFO("module", ">> mod-mortal: ZoneRiskHandler system loaded");
    LoadZoneRiskData();
}

void ZoneRiskHandler::Unload() { s_zoneRiskTiers.clear(); }

void ZoneRiskHandler::OnZoneChange(Player* player, uint32 newZone)
{
    uint32 riskTier = GetRiskTier(newZone);
    SendZoneBanner(player, newZone);
    if (riskTier == RISK_TIER_GREEN) player->SetPvP(false);
    else if (riskTier == RISK_TIER_RED) player->SetPvP(true);
}

uint32 ZoneRiskHandler::GetRiskTier(uint32 zoneId)
{
    auto it = s_zoneRiskTiers.find(zoneId);
    return it != s_zoneRiskTiers.end() ? it->second : RISK_TIER_GREEN;
}

bool ZoneRiskHandler::IsAllowedZone(uint32 zoneId) { return s_zoneRiskTiers.find(zoneId) != s_zoneRiskTiers.end(); }
bool ZoneRiskHandler::IsPvPAllowed(uint32 zoneId) { return GetRiskTier(zoneId) >= RISK_TIER_YELLOW; }
bool ZoneRiskHandler::IsFullLoot(uint32 zoneId) { return GetRiskTier(zoneId) == RISK_TIER_RED; }

void ZoneRiskHandler::SendZoneBanner(Player* player, uint32 zoneId)
{
    uint32 riskTier = GetRiskTier(zoneId);
    std::string zoneName = "Unknown";
    if (AreaTableEntry const* area = sAreaTableStore.LookupEntry(zoneId))
        zoneName = area->area_name[0];

    switch (riskTier)
    {
        case RISK_TIER_GREEN:  ChatHandler(player->GetSession()).SendSysMessage("|cff00ff00[Safe Zone]|r " + zoneName); break;
        case RISK_TIER_YELLOW: ChatHandler(player->GetSession()).SendSysMessage("|cffffff00[Medium Risk]|r " + zoneName + " - Partial loot on death"); break;
        case RISK_TIER_RED:    ChatHandler(player->GetSession()).SendSysMessage("|cffff0000[FULL LOOT ZONE]|r " + zoneName + " - All items drop on death"); break;
    }
}

void ZoneRiskHandler::LoadZoneRiskData()
{
    QueryResult result = WorldDatabase.Query("SELECT zone_id, risk_tier FROM zones_risk_flags");
    if (!result)
    {
        s_zoneRiskTiers[1] = RISK_TIER_GREEN; s_zoneRiskTiers[3] = RISK_TIER_GREEN;
        s_zoneRiskTiers[1519] = RISK_TIER_YELLOW; s_zoneRiskTiers[33] = RISK_TIER_RED;
        return;
    }
    do { Field* fields = result->Fetch(); s_zoneRiskTiers[fields[0].Get<uint32>()] = fields[1].Get<uint32>(); } while (result->NextRow());
    LOG_INFO("module", ">> mod-mortal: Loaded {} zone risk mappings", s_zoneRiskTiers.size());
}
