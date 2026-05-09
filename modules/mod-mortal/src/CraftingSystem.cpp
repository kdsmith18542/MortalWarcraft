#include "CraftingSystem.h"
#include "Player.h"
#include "Item.h"
#include "ObjectMgr.h"
#include "WorldSession.h"
#include "Chat.h"
#include "DatabaseEnv.h"
#include <unordered_map>
#include <vector>

struct RecipeEntry
{
    uint32 id;
    uint32 craftedItemEntry;
    uint32 requiredSkill;
    uint32 requiredSkillLevel;
    uint32 workstationType;
    uint32 craftTime;
    std::vector<std::pair<uint32, uint32>> materials;
};

struct WorkstationEntry
{
    uint32 gameObjectEntry;
    uint32 workstationType;
};

static std::unordered_map<uint32, RecipeEntry> s_recipes;
static std::unordered_map<uint32, WorkstationEntry> s_workstations;

void CraftingSystem::Load()
{
    LOG_INFO("module", ">> mod-mortal: CraftingSystem loaded");
    LoadRecipes();
    LoadWorkstations();
}

void CraftingSystem::Unload()
{
    s_recipes.clear();
    s_workstations.clear();
}

bool CraftingSystem::CraftItem(Player* player, uint32 recipeId, uint32 workstationId)
{
    auto it = s_recipes.find(recipeId);
    if (it == s_recipes.end())
        return false;

    RecipeEntry& recipe = it->second;

    if (!CanCraft(player, recipeId))
        return false;

    for (auto& mat : recipe.materials)
    {
        if (!player->HasItemCount(mat.first, mat.second))
        {
            ChatHandler(player->GetSession()).SendSysMessage("Missing required materials");
            return false;
        }
    }

    for (auto& mat : recipe.materials)
        player->DestroyItemCount(mat.first, mat.second, true);

    float quality, durability;
    CalculateQuality(player, recipeId, quality, durability);

    ItemPosCountVec dest;
    if (player->CanStoreNewItem(NULL_BAG, NULL_SLOT, dest, recipe.craftedItemEntry, 1) == EQUIP_ERR_OK)
    {
        Item* item = player->StoreNewItem(dest, recipe.craftedItemEntry, 1, true);
        player->SendNewItem(item, 1, true, false);
        ChatHandler(player->GetSession()).SendSysMessage("Item crafted successfully");
    }

    return true;
}

bool CraftingSystem::CanCraft(Player* player, uint32 recipeId)
{
    auto it = s_recipes.find(recipeId);
    if (it == s_recipes.end())
        return false;

    return true;
}

void CraftingSystem::GetRequiredMaterials(uint32 recipeId, std::vector<std::pair<uint32, uint32>>& materials)
{
    auto it = s_recipes.find(recipeId);
    if (it != s_recipes.end())
        materials = it->second.materials;
}

bool CraftingSystem::IsWorkstation(uint32 gameObjectEntry)
{
    return s_workstations.find(gameObjectEntry) != s_workstations.end();
}

uint32 CraftingSystem::GetWorkstationType(uint32 gameObjectEntry)
{
    auto it = s_workstations.find(gameObjectEntry);
    if (it != s_workstations.end())
        return it->second.workstationType;
    return 0;
}

void CraftingSystem::CalculateQuality(Player* player, uint32 recipeId, float& quality, float& durability)
{
    quality = 1.0f;
    durability = 100.0f;
}

void CraftingSystem::ApplyDurabilityDecay(Player* player, Item* item)
{
    if (!item)
        return;

    uint32 maxDurability = item->GetUInt32Value(ITEM_FIELD_MAX_DURABILITY);
    if (maxDurability == 0)
        return;

    uint32 curDurability = item->GetUInt32Value(ITEM_FIELD_DURABILITY);
    if (curDurability > 0)
    {
        uint32 decay = 1;
        if (curDurability <= decay)
            decay = curDurability - 1;

        item->SetUInt32Value(ITEM_FIELD_DURABILITY, curDurability - decay);
    }
}

void CraftingSystem::LoadRecipes()
{
}

void CraftingSystem::LoadWorkstations()
{
    s_workstations[100] = { 100, 1 }; // Forge
    s_workstations[101] = { 101, 2 }; // Anvil
    s_workstations[102] = { 102, 3 }; // Cooking Fire
}
