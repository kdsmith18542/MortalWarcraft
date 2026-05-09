#include "MortalAttributes.h"
#include "Player.h"
#include "DatabaseEnv.h"
#include "ObjectMgr.h"
#include <unordered_map>

struct AttributeEntry { uint32 strength, agility, stamina, intellect, spirit; };
static std::unordered_map<uint32, AttributeEntry> s_playerAttributes;

void MortalAttributes::Load()
{
    LOG_INFO("module", ">> mod-mortal: MortalAttributes system loaded");
}

void MortalAttributes::Unload() { s_playerAttributes.clear(); }

void MortalAttributes::OnLogin(Player* player)
{
    LoadAttributes(player);
    EnforceAttributeCaps(player);
}

bool MortalAttributes::ValidateAttributes(Player* player)
{
    if (GetTotalAttributes(player) > MAX_ATTRIBUTE_TOTAL) return false;
    uint32 guid = player->GetGUID().GetCounter();
    auto it = s_playerAttributes.find(guid);
    if (it == s_playerAttributes.end()) return true;
    return it->second.strength <= MAX_ATTRIBUTE_PER_STAT &&
           it->second.agility <= MAX_ATTRIBUTE_PER_STAT &&
           it->second.stamina <= MAX_ATTRIBUTE_PER_STAT &&
           it->second.intellect <= MAX_ATTRIBUTE_PER_STAT &&
           it->second.spirit <= MAX_ATTRIBUTE_PER_STAT;
}

void MortalAttributes::EnforceAttributeCaps(Player* player)
{
    uint32 guid = player->GetGUID().GetCounter();
    auto it = s_playerAttributes.find(guid);
    if (it == s_playerAttributes.end()) return;

    it->second.strength  = std::min(it->second.strength, MAX_ATTRIBUTE_PER_STAT);
    it->second.agility   = std::min(it->second.agility, MAX_ATTRIBUTE_PER_STAT);
    it->second.stamina   = std::min(it->second.stamina, MAX_ATTRIBUTE_PER_STAT);
    it->second.intellect = std::min(it->second.intellect, MAX_ATTRIBUTE_PER_STAT);
    it->second.spirit    = std::min(it->second.spirit, MAX_ATTRIBUTE_PER_STAT);

    if (GetTotalAttributes(player) > MAX_ATTRIBUTE_TOTAL)
        it->second.spirit -= std::min(it->second.spirit, GetTotalAttributes(player) - MAX_ATTRIBUTE_TOTAL);
}

uint32 MortalAttributes::GetTotalAttributes(Player* player)
{
    auto it = s_playerAttributes.find(player->GetGUID().GetCounter());
    if (it == s_playerAttributes.end()) return 0;
    return it->second.strength + it->second.agility + it->second.stamina + it->second.intellect + it->second.spirit;
}

uint32 MortalAttributes::GetAttributePoints(Player* player, uint32 statType)
{
    auto it = s_playerAttributes.find(player->GetGUID().GetCounter());
    if (it == s_playerAttributes.end()) return 0;
    switch (statType) {
        case 0: return it->second.strength;  case 1: return it->second.agility;
        case 2: return it->second.stamina;   case 3: return it->second.intellect;
        case 4: return it->second.spirit;    default: return 0;
    }
}

bool MortalAttributes::CanIncreaseAttribute(Player* player, uint32 statType, uint32 amount)
{
    return GetAttributePoints(player, statType) + amount <= MAX_ATTRIBUTE_PER_STAT &&
           GetTotalAttributes(player) + amount <= MAX_ATTRIBUTE_TOTAL;
}

void MortalAttributes::SetAttributePoints(Player* player, uint32 statType, uint32 value)
{
    if (value > MAX_ATTRIBUTE_PER_STAT) value = MAX_ATTRIBUTE_PER_STAT;
    uint32 guid = player->GetGUID().GetCounter();
    switch (statType) {
        case 0: s_playerAttributes[guid].strength = value; break;
        case 1: s_playerAttributes[guid].agility = value; break;
        case 2: s_playerAttributes[guid].stamina = value; break;
        case 3: s_playerAttributes[guid].intellect = value; break;
        case 4: s_playerAttributes[guid].spirit = value; break;
    }
    EnforceAttributeCaps(player);
    SaveAttributes(player);
}

void MortalAttributes::ModifyAttributePoints(Player* player, uint32 statType, int32 delta)
{
    SetAttributePoints(player, statType, GetAttributePoints(player, statType) + delta);
}

void MortalAttributes::SaveAttributes(Player* player)
{
    uint32 guid = player->GetGUID().GetCounter();
    auto it = s_playerAttributes.find(guid);
    if (it == s_playerAttributes.end()) return;

    CharacterDatabasePreparedStatement* stmt = CharacterDatabase.GetPreparedStatement(CHAR_REP_MORTAL_ATTRIBUTES);
    stmt->SetData(0, guid); stmt->SetData(1, it->second.strength);
    stmt->SetData(2, it->second.agility); stmt->SetData(3, it->second.stamina);
    stmt->SetData(4, it->second.intellect); stmt->SetData(5, it->second.spirit);
    CharacterDatabase.Execute(stmt);
}

void MortalAttributes::LoadAttributes(Player* player)
{
    uint32 guid = player->GetGUID().GetCounter();
    CharacterDatabasePreparedStatement* stmt = CharacterDatabase.GetPreparedStatement(CHAR_SEL_MORTAL_ALL_ATTRIBUTES);
    stmt->SetData(0, guid);
    PreparedQueryResult result = CharacterDatabase.Query(stmt);
    if (result)
    {
        Field* fields = result->Fetch();
        s_playerAttributes[guid] = { fields[0].Get<uint32>(), fields[1].Get<uint32>(),
            fields[2].Get<uint32>(), fields[3].Get<uint32>(), fields[4].Get<uint32>() };
    }
    else
        s_playerAttributes[guid] = { 0, 0, 0, 0, 0 };
}
