#ifndef ZONE_RISK_HANDLER_H
#define ZONE_RISK_HANDLER_H

#include "Common.h"
#include "Player.h"

#define RISK_TIER_GREEN  0
#define RISK_TIER_YELLOW 1
#define RISK_TIER_RED    2

class ZoneRiskHandler
{
public:
    static void Load();
    static void Unload();

    static void OnZoneChange(Player* player, uint32 newZone);
    static uint32 GetRiskTier(uint32 zoneId);
    static bool IsAllowedZone(uint32 zoneId);
    static bool IsPvPAllowed(uint32 zoneId);
    static bool IsFullLoot(uint32 zoneId);

    static void SendZoneBanner(Player* player, uint32 zoneId);

private:
    static void LoadZoneRiskData();
};

#endif
