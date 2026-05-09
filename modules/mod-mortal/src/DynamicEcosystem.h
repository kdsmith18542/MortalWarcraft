#ifndef DYNAMIC_ECOSYSTEM_H
#define DYNAMIC_ECOSYSTEM_H

#include "Common.h"
#include "Creature.h"

class DynamicEcosystem
{
public:
    static void Load();
    static void Unload();

    static void Update(uint32 diff);
    static void OnCreatureDeath(Creature* creature, Unit* killer);
    static void OnCreatureUpdate(Creature* creature, uint32 diff);

    static void AdjustSpawnWeights(uint32 zoneId, uint32 creatureEntry, int32 delta);
    static uint32 GetAdjustedMaxCount(uint32 zoneId, uint32 creatureEntry);

private:
    static void LoadEcosystemData();
    static void ProcessSpawnAdjustments(uint32 diff);
};

#endif
