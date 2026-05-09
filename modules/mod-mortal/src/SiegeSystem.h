#ifndef SIEGE_SYSTEM_H
#define SIEGE_SYSTEM_H
#include "Common.h"
#include "Player.h"

class SiegeSystem
{
public:
    static void Load();
    static void Unload();
    static void Update(uint32 diff);
    static bool StartSiege(Player* player, uint32 strongholdId);
    static bool EndSiege(uint32 strongholdId, uint32 winningGuild);
    static bool IsUnderSiege(uint32 strongholdId);
    static uint32 GetSiegeTimeRemaining(uint32 strongholdId);
    static uint32 GetSiegeParticipants(uint32 strongholdId);
private:
    static void LoadSiegeData();
};
#endif
