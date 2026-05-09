#ifndef NOTORIETY_SYSTEM_H
#define NOTORIETY_SYSTEM_H
#include "Common.h"
#include "Player.h"
#define NOTORIETY_DECAY_INTERVAL 3600000
#define NOTORIETY_MAX 10000
#define CRIMINAL_THRESHOLD 100
#define OUTLAW_THRESHOLD 500

class NotorietySystem
{
public:
    static void Load();
    static void Unload();
    static void Update(uint32 diff);
    static void OnLogin(Player* player);
    static void OnDeath(Player* player, Unit* killer);
    static void OnPlayerKill(Player* killer, Player* victim);
    static void OnReputationChange(Player* player, uint32 factionId, int32& standing, bool incremental);
    static int32 GetNotoriety(Player* player);
    static void ModifyNotoriety(Player* player, int32 delta);
    static void SetNotoriety(Player* player, int32 value);
    static bool IsCriminal(Player* player);
    static bool IsOutlaw(Player* player);
    static uint32 GetCriminalFlagDuration(Player* player);
private:
    static void SaveNotoriety(Player* player);
    static void LoadNotoriety(Player* player);
    static void ApplyCriminalFlag(Player* player, uint32 durationMs);
    static void RemoveCriminalFlag(Player* player);
};
#endif
