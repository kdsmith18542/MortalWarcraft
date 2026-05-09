#ifndef PVP_HOOKS_H
#define PVP_HOOKS_H
#include "Common.h"
#include "Player.h"

class PvPHooks
{
public:
    static void Load();
    static void Unload();
    static void OnDeath(Player* player, Unit* killer);
    static void OnPlayerKillPlayer(Player* killer, Player* victim);
    static void HandleLootOnDeath(Player* victim, Player* killer);
    static void HandleCorpseChest(Player* victim);
    static bool IsInRedZone(Player* player);
    static bool IsInYellowZone(Player* player);
};
#endif
