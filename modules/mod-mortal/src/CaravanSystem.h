#ifndef CARAVAN_SYSTEM_H
#define CARAVAN_SYSTEM_H
#include "Common.h"
#include "Player.h"

class CaravanSystem
{
public:
    static void Load();
    static void Unload();
    static bool CreateCaravan(Player* player, uint32 routeId);
    static bool JoinCaravan(Player* player, uint32 caravanId);
    static bool LeaveCaravan(Player* player, uint32 caravanId);
    static void StartCaravanMove(uint32 caravanId);
    static void OnCaravanArrive(uint32 caravanId);
    static void OnCaravanAttacked(uint32 caravanId);
    static float GetCaravanSpeed(uint32 caravanId);
    static uint32 GetCaravanHealth(uint32 caravanId);
private:
    static void LoadCaravanRoutes();
};
#endif
