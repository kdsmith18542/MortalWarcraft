#include "RegionalBank.h"
#include "Player.h"
#include "DatabaseEnv.h"
#include "ObjectMgr.h"
#include "WorldSession.h"
#include "Chat.h"
#include <unordered_map>
#include <vector>

static std::unordered_map<uint32, uint32> s_zoneBankMapping;
static std::vector<uint32> s_bankNpcEntries;

void RegionalBank::Load()
{
    LOG_INFO("module", ">> mod-mortal: RegionalBank system loaded");
    LoadBankNpcs();
}

void RegionalBank::Unload()
{
    s_zoneBankMapping.clear();
    s_bankNpcEntries.clear();
}

void RegionalBank::OnPlayerLogout(Player* player)
{
}

bool RegionalBank::DepositItem(Player* player, uint32 zoneId, uint8 slot, uint32 itemEntry, uint32 count)
{
    if (count == 0 || slot > 100)
        return false;

    uint32 associatedZone = GetAssociatedZone(zoneId);
    if (associatedZone == 0)
        associatedZone = zoneId;

    uint32 guid = player->GetGUID().GetCounter();

    CharacterDatabasePreparedStatement* stmt = CharacterDatabase.GetPreparedStatement(CHAR_REP_MORTAL_REGIONAL_BANK_ITEM);
    stmt->SetData(0, guid);
    stmt->SetData(1, associatedZone);
    stmt->SetData(2, slot);
    stmt->SetData(3, 0);
    stmt->SetData(4, itemEntry);
    stmt->SetData(5, count);
    CharacterDatabase.Execute(stmt);

    return true;
}

bool RegionalBank::WithdrawItem(Player* player, uint32 zoneId, uint8 slot, uint32 count)
{
    uint32 guid = player->GetGUID().GetCounter();
    uint32 associatedZone = GetAssociatedZone(zoneId);
    if (associatedZone == 0)
        associatedZone = zoneId;

    CharacterDatabasePreparedStatement* stmt = CharacterDatabase.GetPreparedStatement(CHAR_SEL_MORTAL_REGIONAL_BANK);
    stmt->SetData(0, guid);
    stmt->SetData(1, associatedZone);
    PreparedQueryResult result = CharacterDatabase.Query(stmt);

    if (!result)
        return false;

    do
    {
        Field* fields = result->Fetch();
        uint8 bankSlot = fields[0].Get<uint8>();
        if (bankSlot != slot)
            continue;

        uint32 itemEntry = fields[2].Get<uint32>();
        uint32 storedCount = fields[1].Get<uint32>();

        if (count > storedCount)
            count = storedCount;

        ItemPosCountVec dest;
        if (player->CanStoreNewItem(NULL_BAG, NULL_SLOT, dest, itemEntry, count) == EQUIP_ERR_OK)
        {
            Item* item = player->StoreNewItem(dest, itemEntry, count, true);
            player->SendNewItem(item, count, true, false);
        }

        CharacterDatabasePreparedStatement* delStmt = CharacterDatabase.GetPreparedStatement(CHAR_DEL_MORTAL_REGIONAL_BANK_ITEM);
        delStmt->SetData(0, guid);
        delStmt->SetData(1, associatedZone);
        delStmt->SetData(2, slot);
        CharacterDatabase.Execute(delStmt);

        return true;
    } while (result->NextRow());

    return false;
}

uint32 RegionalBank::GetItemCount(Player* player, uint32 zoneId, uint8 slot)
{
    uint32 guid = player->GetGUID().GetCounter();
    uint32 associatedZone = GetAssociatedZone(zoneId);
    if (associatedZone == 0)
        associatedZone = zoneId;

    CharacterDatabasePreparedStatement* stmt = CharacterDatabase.GetPreparedStatement(CHAR_SEL_MORTAL_REGIONAL_BANK);
    stmt->SetData(0, guid);
    stmt->SetData(1, associatedZone);
    PreparedQueryResult result = CharacterDatabase.Query(stmt);

    if (result)
    {
        do
        {
            Field* fields = result->Fetch();
            if (fields[0].Get<uint8>() == slot)
                return fields[1].Get<uint32>();
        } while (result->NextRow());
    }
    return 0;
}

uint32 RegionalBank::GetAssociatedZone(uint32 areaId)
{
    auto it = s_zoneBankMapping.find(areaId);
    if (it != s_zoneBankMapping.end())
        return it->second;
    return areaId;
}

bool RegionalBank::IsRegionalBankNpc(uint32 entry)
{
    return std::find(s_bankNpcEntries.begin(), s_bankNpcEntries.end(), entry) != s_bankNpcEntries.end();
}

void RegionalBank::LoadBankNpcs()
{
    s_bankNpcEntries.push_back(2500);
    s_bankNpcEntries.push_back(2501);
    s_bankNpcEntries.push_back(2502);

    s_zoneBankMapping[1]    = 1;     // Kalimdor -> Kalimdor bank
    s_zoneBankMapping[3]    = 3;     // EK -> EK bank
    s_zoneBankMapping[1519] = 1519;  // STV -> STV bank
}
