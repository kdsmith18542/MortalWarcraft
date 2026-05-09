#ifndef BOUNTY_BOARD_H
#define BOUNTY_BOARD_H

#include "Common.h"
#include "Player.h"

class BountyBoard
{
public:
    static void Load();
    static void Unload();

    static void OnPlayerKill(Player* killer, Player* victim);

    static bool PostBounty(Player* poster, Player* target, uint32 amount);
    static bool ClaimBounty(Player* claimer, Player* target);
    static uint32 GetBountyOnPlayer(Player* target);

    static bool IsPlayerBountied(Player* target);

private:
    static void LoadBounties();
};

#endif
