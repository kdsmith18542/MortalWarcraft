#include "MortalLevel.h"
#include "MortalCombatSkills.h"
#include "ScriptMgr.h"
#include "Chat.h"
#include "ObjectMgr.h"
#include "WorldSession.h"
#include <unordered_map>

static std::unordered_map<uint32, uint32> s_playerDerivedLevels;

void MortalLevel::Load()
{
    LOG_INFO("module", ">> mod-mortal: MortalLevel system loaded");
    LOG_INFO("module", ">> mod-mortal: Derived level formula: MIN(25, FLOOR(total_skill_points / 48))");
    LOG_INFO("module", ">> mod-mortal: Max skill points: {}", MAX_SKILL_POINTS);
    LOG_INFO("module", ">> mod-mortal: Attribute caps: {} per stat, {} total", MAX_ATTRIBUTE_PER_STAT, MAX_ATTRIBUTE_TOTAL);
}

void MortalLevel::Unload()
{
    s_playerDerivedLevels.clear();
}

void MortalLevel::OnLogin(Player* player)
{
    uint32 derivedLevel = CalculateDerivedLevel(GetTotalSkillPoints(player));
    s_playerDerivedLevels[player->GetGUID().GetCounter()] = derivedLevel;
    OverridePlayerLevel(player);
    SendLevelUpdate(player);
}

uint32 MortalLevel::GetDerivedLevel(Player* player)
{
    auto it = s_playerDerivedLevels.find(player->GetGUID().GetCounter());
    if (it != s_playerDerivedLevels.end())
        return it->second;

    uint32 derivedLevel = CalculateDerivedLevel(GetTotalSkillPoints(player));
    s_playerDerivedLevels[player->GetGUID().GetCounter()] = derivedLevel;
    return derivedLevel;
}

uint32 MortalLevel::GetTotalSkillPoints(Player* player)
{
    uint32 total = 0;
    for (uint32 i = 0; i < MORTAL_SKILL_COUNT; ++i)
        total += MortalCombatSkills::GetSkillValue(player, i);
    return total;
}

void MortalLevel::OverridePlayerLevel(Player* player)
{
    uint32 derivedLevel = GetDerivedLevel(player);
    if (derivedLevel < 1)
        derivedLevel = 1;
    if (derivedLevel > MAX_MORTAL_LEVEL)
        derivedLevel = MAX_MORTAL_LEVEL;

    player->SetLevel(derivedLevel);
}

void MortalLevel::OnSkillGain(Player* player, uint32 skillId, uint32 newValue)
{
    uint32 oldLevel = GetDerivedLevel(player);
    uint32 newLevel = CalculateDerivedLevel(GetTotalSkillPoints(player));

    if (newLevel != oldLevel)
    {
        s_playerDerivedLevels[player->GetGUID().GetCounter()] = newLevel;
        OverridePlayerLevel(player);
        SendLevelUpdate(player);
    }
}

uint32 MortalLevel::CalculateDerivedLevel(uint32 totalSkillPoints)
{
    uint32 level = totalSkillPoints / SKILL_POINTS_PER_LEVEL;
    if (level < MIN_MORTAL_LEVEL)
        level = MIN_MORTAL_LEVEL;
    if (level > MAX_MORTAL_LEVEL)
        level = MAX_MORTAL_LEVEL;
    return level;
}

void MortalLevel::SendLevelUpdate(Player* player)
{
    uint32 level = GetDerivedLevel(player);
    ChatHandler(player->GetSession()).SendSysMessage(player->GetSession()->GetAcoreString(LANG_LEVEL_UP));
}
