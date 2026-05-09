#include "PvPHooks.h"
#include "ZoneRiskHandler.h"
#include "NotorietySystem.h"
#include "BountyBoard.h"
#include "Player.h"
#include "Item.h"
#include "ObjectMgr.h"
#include "WorldSession.h"
#include "Chat.h"
#include "SpellMgr.h"

void PvPHooks::Load()
{
    LOG_INFO("module", ">> mod-mortal: PvPHooks system loaded");
}

void PvPHooks::Unload()
{
}

void PvPHooks::OnDeath(Player* player, Unit* killer)
{
    if (!killer)
        return;

    if (Player* killerPlayer = killer->ToPlayer())
    {
        OnPlayerKillPlayer(killerPlayer, player);

        if (IsInRedZone(player))
            HandleLootOnDeath(player, killerPlayer);
    }
}

void PvPHooks::OnPlayerKillPlayer(Player* killer, Player* victim)
{
    NotorietySystem::OnPlayerKill(killer, victim);
    BountyBoard::OnPlayerKill(killer, victim);
}

void PvPHooks::HandleLootOnDeath(Player* victim, Player* killer)
{
    uint32 zoneId = victim->GetZoneId();
    uint32 riskTier = ZoneRiskHandler::GetRiskTier(zoneId);

    if (riskTier != RISK_TIER_RED)
        return;

    HandleCorpseChest(victim);
}

void PvPHooks::HandleCorpseChest(Player* victim)
{
    float x = victim->GetPositionX();
    float y = victim->GetPositionY();
    float z = victim->GetPositionZ();
    float o = victim->GetOrientation();
    uint32 mapId = victim->GetMapId();

    if (GameObject* corpseChest = victim->SummitGameObject(500000, x, y, z, o, 0.0f, 0.0f, 0.0f, 0.0f, 300))
    {
        for (uint8 i = EQUIPMENT_SLOT_START; i < EQUIPMENT_SLOT_END; ++i)
        {
            if (Item* item = victim->GetItemByPos(INVENTORY_SLOT_BAG_0, i))
            {
                if (item->GetTemplate()->Class == ITEM_CLASS_ARMOR ||
                    item->GetTemplate()->Class == ITEM_CLASS_WEAPON)
                {
                    victim->RemoveItem(INVENTORY_SLOT_BAG_0, i, true);
                    corpseChest->AddItem(item->GetEntry(), 1);
                }
            }
        }

        for (uint8 i = INVENTORY_SLOT_BAG_0; i < INVENTORY_SLOT_BAG_6; ++i)
        {
            if (Bag* bag = victim->GetBagByPos(i))
            {
                for (uint32 j = 0; j < bag->GetBagSize(); ++j)
                {
                    if (Item* item = bag->GetItemByPos(j))
                    {
                        if (item->GetTemplate()->Class == ITEM_CLASS_ARMOR ||
                            item->GetTemplate()->Class == ITEM_CLASS_WEAPON)
                        {
                            bag->RemoveItem(j, true);
                            corpseChest->AddItem(item->GetEntry(), 1);
                        }
                    }
                }
            }
        }
    }
}

bool PvPHooks::IsInRedZone(Player* player)
{
    return ZoneRiskHandler::IsFullLoot(player->GetZoneId());
}

bool PvPHooks::IsInYellowZone(Player* player)
{
    uint32 riskTier = ZoneRiskHandler::GetRiskTier(player->GetZoneId());
    return riskTier == RISK_TIER_YELLOW;
}
