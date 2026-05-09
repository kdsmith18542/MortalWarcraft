#ifndef STRONGHOLD_HANDLER_H
#define STRONGHOLD_HANDLER_H

#include "Common.h"
#include "Player.h"
#include "Guild.h"

class StrongholdHandler
{
public:
    static void Load();
    static void Unload();

    static bool ClaimStronghold(Player* player, uint32 strongholdId);
    static bool IsStrongholdOwner(uint32 guildId, uint32 strongholdId);
    static uint32 GetStrongholdOwner(uint32 strongholdId);
    static void ReleaseStronghold(uint32 strongholdId);

    static void ApplyStrongholdBuffs(uint32 guildId);
    static void RemoveStrongholdBuffs(uint32 guildId);

    static bool IsStrongholdLocation(uint32 zoneId);

private:
    static void LoadStrongholdData();
};

#endif
