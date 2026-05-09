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

void ZoneRiskHandler::Unload()
{
    s_zoneRiskTiers.clear();
}

void ZoneRiskHandler::OnZoneChange(Player* player, uint32 newZone)
{
    uint32 riskTier = GetRiskTier(newZone);
    SendZoneBanner(player, newZone);

    switch (riskTier)
    {
        case RISK_TIER_GREEN:
            player->SetPvP(false);
            break;
        case RISK_TIER_YELLOW:
            break;
        case RISK_TIER_RED:
            player->SetPvP(true);
            break;
    }
}

uint32 ZoneRiskHandler::GetRiskTier(uint32 zoneId)
{
    auto it = s_zoneRiskTiers.find(zoneId);
    if (it != s_zoneRiskTiers.end())
        return it->second;
    return RISK_TIER_GREEN;
}

bool ZoneRiskHandler::IsAllowedZone(uint32 zoneId)
{
    return s_zoneRiskTiers.find(zoneId) != s_zoneRiskTiers.end();
}

bool ZoneRiskHandler::IsPvPAllowed(uint32 zoneId)
{
    uint32 tier = GetRiskTier(zoneId);
    return tier == RISK_TIER_YELLOW || tier == RISK_TIER_RED;
}

bool ZoneRiskHandler::IsFullLoot(uint32 zoneId)
{
    return GetRiskTier(zoneId) == RISK_TIER_RED;
}

void ZoneRiskHandler::SendZoneBanner(Player* player, uint32 zoneId)
{
    uint32 riskTier = GetRiskTier(zoneId);
    std::string zoneName = "Unknown";

    if (AreaTableEntry const* area = sAreaTableStore.LookupEntry(zoneId))
        zoneName = area->area_name;

    switch (riskTier)
    {
        case RISK_TIER_GREEN:
            ChatHandler(player->GetSession()).SendSysMessage("|cff00ff00[Safe Zone]|r " + zoneName);
            break;
        case RISK_TIER_YELLOW:
            ChatHandler(player->GetSession()).SendSysMessage("|cffffff00[Medium Risk]|r " + zoneName + " - Partial loot on death");
            break;
        case RISK_TIER_RED:
            ChatHandler(player->GetSession()).SendSysMessage("|cffff0000[FULL LOOT ZONE]|r " + zoneName + " - All items drop on death");
            break;
    }
}

void ZoneRiskHandler::LoadZoneRiskData()
{
    QueryResult result = WorldDatabase.Query("SELECT zone_id, risk_tier FROM zones_risk_flags");
    if (!result)
    {
        LOG_INFO("module", ">> mod-mortal: No zone risk data found, using defaults");
        s_zoneRiskTiers[1]      = RISK_TIER_GREEN;   // Kalimdor
        s_zoneRiskTiers[3]      = RISK_TIER_GREEN;   // Eastern Kingdoms
        s_zoneRiskTiers[1519]   = RISK_TIER_YELLOW;  // STV
        s_zoneRiskTiers[33]     = RISK_TIER_RED;     // Stranglethorn Vale
        return;
    }

    do
    {
        Field* fields = result->Fetch();
        uint32 zoneId = fields[0].Get<uint32>();
        uint32 riskTier = fields[1].Get<uint32>();
        s_zoneRiskTiers[zoneId] = riskTier;
    } while (result->NextRow());

    LOG_INFO("module", ">> mod-mortal: Loaded {} zone risk mappings", s_zoneRiskTiers.size());
}
