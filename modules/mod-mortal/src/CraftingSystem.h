#ifndef CRAFTING_SYSTEM_H
#define CRAFTING_SYSTEM_H

#include "Common.h"
#include "Player.h"

class CraftingSystem
{
public:
    static void Load();
    static void Unload();

    static bool CraftItem(Player* player, uint32 recipeId, uint32 workstationId);
    static bool CanCraft(Player* player, uint32 recipeId);
    static void GetRequiredMaterials(uint32 recipeId, std::vector<std::pair<uint32, uint32>>& materials);

    static bool IsWorkstation(uint32 gameObjectEntry);
    static uint32 GetWorkstationType(uint32 gameObjectEntry);

    static void CalculateQuality(Player* player, uint32 recipeId, float& quality, float& durability);
    static void ApplyDurabilityDecay(Player* player, Item* item);

private:
    static void LoadRecipes();
    static void LoadWorkstations();
};

#endif
