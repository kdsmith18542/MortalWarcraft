#ifndef REGIONAL_BANK_H
#define REGIONAL_BANK_H
#include "Common.h"
#include "Player.h"

class RegionalBank
{
public:
    static void Load();
    static void Unload();
    static void OnPlayerLogout(Player* player);
    static bool DepositItem(Player* player, uint32 zoneId, uint8 slot, uint32 itemEntry, uint32 count);
    static bool WithdrawItem(Player* player, uint32 zoneId, uint8 slot, uint32 count);
    static uint32 GetItemCount(Player* player, uint32 zoneId, uint8 slot);
    static uint32 GetAssociatedZone(uint32 areaId);
    static bool IsRegionalBankNpc(uint32 entry);
private:
    static void LoadBankNpcs();
};
#endif
