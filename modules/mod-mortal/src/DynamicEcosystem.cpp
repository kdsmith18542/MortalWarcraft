#include "DynamicEcosystem.h"
#include "Creature.h"
#include "Map.h"
#include "ZoneScript.h"
#include "DatabaseEnv.h"
#include <unordered_map>

struct EcosystemEntry
{
    uint32 creatureEntry;
    uint32 zoneId;
    uint32 baseMaxCount;
    int32 currentWeight;
    uint32 lastUpdateTime;
};

static std::unordered_map<uint32, EcosystemEntry> s_ecosystemData;
static uint32 s_ecosystemUpdateTimer = 0;

void DynamicEcosystem::Load()
{
    LOG_INFO("module", ">> mod-mortal: DynamicEcosystem system loaded");
    LoadEcosystemData();
}

void DynamicEcosystem::Unload()
{
    s_ecosystemData.clear();
}

void DynamicEcosystem::Update(uint32 diff)
{
    s_ecosystemUpdateTimer += diff;
    if (s_ecosystemUpdateTimer >= 60000)
    {
        ProcessSpawnAdjustments(s_ecosystemUpdateTimer);
        s_ecosystemUpdateTimer = 0;
    }
}

void DynamicEcosystem::OnCreatureDeath(Creature* creature, Unit* killer)
{
    if (!killer || !killer->IsPlayer())
        return;

    uint32 zoneId = creature->GetZoneId();
    AdjustSpawnWeights(zoneId, creature->GetEntry(), -5);
}

void DynamicEcosystem::OnCreatureUpdate(Creature* creature, uint32 diff)
{
}

void DynamicEcosystem::AdjustSpawnWeights(uint32 zoneId, uint32 creatureEntry, int32 delta)
{
    for (auto& pair : s_ecosystemData)
    {
        if (pair.second.zoneId == zoneId && pair.second.creatureEntry == creatureEntry)
        {
            pair.second.currentWeight += delta;
            if (pair.second.currentWeight < -100)
                pair.second.currentWeight = -100;
            break;
        }
    }
}

uint32 DynamicEcosystem::GetAdjustedMaxCount(uint32 zoneId, uint32 creatureEntry)
{
    for (auto& pair : s_ecosystemData)
    {
        if (pair.second.zoneId == zoneId && pair.second.creatureEntry == creatureEntry)
        {
            float weightFactor = 1.0f + (pair.second.currentWeight / 100.0f);
            uint32 adjusted = static_cast<uint32>(pair.second.baseMaxCount * weightFactor);
            if (adjusted < 1)
                adjusted = 1;
            return adjusted;
        }
    }
    return 0;
}

void DynamicEcosystem::LoadEcosystemData()
{
}

void DynamicEcosystem::ProcessSpawnAdjustments(uint32 diff)
{
    for (auto& pair : s_ecosystemData)
    {
        if (pair.second.currentWeight < 0)
            pair.second.currentWeight += 1;
        else if (pair.second.currentWeight > 0)
            pair.second.currentWeight -= 1;
    }
}
