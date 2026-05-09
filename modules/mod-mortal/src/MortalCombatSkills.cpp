#include "MortalCombatSkills.h"
#include "MortalLevel.h"
#include "Player.h"
#include "DatabaseEnv.h"
#include "ObjectMgr.h"
#include "WorldSession.h"
#include <unordered_map>

struct SkillEntry
{
    uint32 value;
    uint32 maxValue;
    uint32 state;
};

static std::unordered_map<uint32, std::unordered_map<uint32, SkillEntry>> s_playerSkills;

static const uint32 s_skillMaxValues[MORTAL_SKILL_COUNT] =
{
    100,   // Swords
    100,   // Axes
    100,   // Maces
    100,   // Spears
    100,   // Bows
    100,   // Crossbows
    100,   // Defense
    100,   // Blocking
    100,   // Parrying
    100,   // Magic Arcane
    100,   // Magic Fire
    100,   // Magic Frost
    100,   // Magic Shadow
    100,   // Mining
    100,   // Herbalism
    100,   // Lumberjacking
    100,   // Skinning
    100,   // Fishing
    100,   // Stealth
    100,   // Lockpicking
};

static const char* s_skillNames[MORTAL_SKILL_COUNT] =
{
    "Swords", "Axes", "Maces", "Spears",
    "Bows", "Crossbows",
    "Defense", "Blocking", "Parrying",
    "Arcane Magic", "Fire Magic", "Frost Magic", "Shadow Magic",
    "Mining", "Herbalism", "Lumberjacking", "Skinning", "Fishing",
    "Stealth", "Lockpicking"
};

void MortalCombatSkills::Load()
{
    LOG_INFO("module", ">> mod-mortal: MortalCombatSkills system loaded");
    LOG_INFO("module", ">> mod-mortal: {} skills registered", MORTAL_SKILL_COUNT);
}

void MortalCombatSkills::Unload()
{
    s_playerSkills.clear();
}

void MortalCombatSkills::OnLogin(Player* player)
{
    LoadSkillsFromDB(player);
}

uint32 MortalCombatSkills::GetSkillValue(Player* player, uint32 skillId)
{
    if (skillId >= MORTAL_SKILL_COUNT)
        return 0;

    auto& playerMap = s_playerSkills[player->GetGUID().GetCounter()];
    auto it = playerMap.find(skillId);
    if (it != playerMap.end())
        return it->second.value;
    return 0;
}

void MortalCombatSkills::SetSkillValue(Player* player, uint32 skillId, uint32 value)
{
    if (skillId >= MORTAL_SKILL_COUNT)
        return;

    uint32 maxVal = GetMaxSkillValue(skillId);
    if (value > maxVal)
        value = maxVal;

    auto& entry = s_playerSkills[player->GetGUID().GetCounter()][skillId];
    entry.value = value;
    entry.maxValue = maxVal;
    entry.state = 0;

    SaveSkillToDB(player, skillId);
    MortalLevel::OnSkillGain(player, skillId, value);
}

void MortalCombatSkills::GainSkill(Player* player, uint32 skillId, uint32 amount)
{
    if (skillId >= MORTAL_SKILL_COUNT || amount == 0)
        return;

    uint32 currentValue = GetSkillValue(player, skillId);
    uint32 maxVal = GetMaxSkillValue(skillId);

    if (currentValue >= maxVal)
        return;

    uint32 newValue = std::min(currentValue + amount, maxVal);
    SetSkillValue(player, skillId, newValue);
}

void MortalCombatSkills::OnCombatKill(Player* player, Unit* victim)
{
    if (!victim || !victim->IsCreature())
        return;

    uint32 skillGain = 1;
    if (victim->getLevel() > player->GetLevel())
        skillGain = 2;

    uint32 weaponSkill = MORTAL_SKILL_SWORDS;
    if (Item* mainHand = player->GetItemByPos(INVENTORY_SLOT_BAG_0, EQUIPMENT_SLOT_MAINHAND))
    {
        uint32 subClass = mainHand->GetTemplate()->SubClass;
        switch (subClass)
        {
            case ITEM_SUBCLASS_WEAPON_SWORD:     weaponSkill = MORTAL_SKILL_SWORDS; break;
            case ITEM_SUBCLASS_WEAPON_AXE:       weaponSkill = MORTAL_SKILL_AXES; break;
            case ITEM_SUBCLASS_WEAPON_MACE:      weaponSkill = MORTAL_SKILL_MACES; break;
            case ITEM_SUBCLASS_WEAPON_POLEARM:   weaponSkill = MORTAL_SKILL_SPEARS; break;
            case ITEM_SUBCLASS_WEAPON_BOW:       weaponSkill = MORTAL_SKILL_BOWS; break;
            case ITEM_SUBCLASS_WEAPON_CROSSBOW:  weaponSkill = MORTAL_SKILL_CROSSBOWS; break;
        }
    }

    GainSkill(player, weaponSkill, skillGain);
    GainSkill(player, MORTAL_SKILL_DEFENSE, skillGain / 2);
}

void MortalCombatSkills::OnWeaponSwing(Player* player, uint32 weaponSkillId)
{
    GainSkill(player, weaponSkillId, 1);
}

void MortalCombatSkills::OnDamageTaken(Player* player, uint32 amount)
{
    if (amount > 0)
        GainSkill(player, MORTAL_SKILL_DEFENSE, 1);
}

void MortalCombatSkills::OnSpellCastSuccess(Player* player, uint32 spellSchool)
{
    uint32 magicSkillId;
    switch (spellSchool)
    {
        case SPELL_SCHOOL_ARCANE: magicSkillId = MORTAL_SKILL_MAGIC_ARCANE; break;
        case SPELL_SCHOOL_FIRE:   magicSkillId = MORTAL_SKILL_MAGIC_FIRE; break;
        case SPELL_SCHOOL_FROST:  magicSkillId = MORTAL_SKILL_MAGIC_FROST; break;
        case SPELL_SCHOOL_SHADOW: magicSkillId = MORTAL_SKILL_MAGIC_SHADOW; break;
        default: return;
    }
    GainSkill(player, magicSkillId, 1);
}

uint32 MortalCombatSkills::GetMaxSkillValue(uint32 skillId)
{
    if (skillId >= MORTAL_SKILL_COUNT)
        return 0;
    return s_skillMaxValues[skillId];
}

void MortalCombatSkills::SaveSkillToDB(Player* player, uint32 skillId)
{
    uint32 guid = player->GetGUID().GetCounter();
    auto& entry = s_playerSkills[guid][skillId];

    CharacterDatabasePreparedStatement* stmt = CharacterDatabase.GetPreparedStatement(CHAR_REP_MORTAL_SKILL);
    stmt->SetData(0, guid);
    stmt->SetData(1, skillId);
    stmt->SetData(2, entry.value);
    stmt->SetData(3, entry.maxValue);
    stmt->SetData(4, entry.state);
    CharacterDatabase.Execute(stmt);
}

void MortalCombatSkills::LoadSkillsFromDB(Player* player)
{
    uint32 guid = player->GetGUID().GetCounter();

    CharacterDatabasePreparedStatement* stmt = CharacterDatabase.GetPreparedStatement(CHAR_SEL_MORTAL_ALL_SKILLS);
    stmt->SetData(0, guid);
    PreparedQueryResult result = CharacterDatabase.Query(stmt);

    if (result)
    {
        do
        {
            Field* fields = result->Fetch();
            uint32 skillId = fields[0].Get<uint32>();
            uint32 value = fields[1].Get<uint32>();
            uint32 maxValue = fields[2].Get<uint32>();
            uint32 state = fields[3].Get<uint32>();

            s_playerSkills[guid][skillId] = { value, maxValue, state };
        } while (result->NextRow());
    }

    for (uint32 i = 0; i < MORTAL_SKILL_COUNT; ++i)
    {
        if (s_playerSkills[guid].find(i) == s_playerSkills[guid].end())
            s_playerSkills[guid][i] = { 0, s_skillMaxValues[i], 0 };
    }
}
