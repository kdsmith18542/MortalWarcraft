#ifndef TERRITORY_CONTROL_H
#define TERRITORY_CONTROL_H

#include "Common.h"
#include "Player.h"

class TerritoryControl
{
public:
    static void Load();
    static void Unload();

    static bool CapturePoint(Player* player, uint32 tcpId);
    static uint32 GetTcpOwner(uint32 tcpId);
    static uint32 GetTcpProgress(uint32 tcpId);

    static void Update(uint32 diff);
    static void ApplyZoneEffects(uint32 zoneId, uint32 controllingGuild);

private:
    static void LoadTcpData();
};

#endif
