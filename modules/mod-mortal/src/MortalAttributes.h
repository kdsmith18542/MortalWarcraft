#ifndef MORTAL_ATTRIBUTES_H
#define MORTAL_ATTRIBUTES_H

#include "Common.h"
#include "Player.h"

class MortalAttributes
{
public:
    static void Load();
    static void Unload();

    static void OnLogin(Player* player);
    static bool ValidateAttributes(Player* player);
    static void EnforceAttributeCaps(Player* player);

    static uint32 GetTotalAttributes(Player* player);
    static uint32 GetAttributePoints(Player* player, uint32 statType);
    static bool CanIncreaseAttribute(Player* player, uint32 statType, uint32 amount);

    static void SetAttributePoints(Player* player, uint32 statType, uint32 value);
    static void ModifyAttributePoints(Player* player, uint32 statType, int32 delta);

private:
    static void SaveAttributes(Player* player);
    static void LoadAttributes(Player* player);
};

#endif
