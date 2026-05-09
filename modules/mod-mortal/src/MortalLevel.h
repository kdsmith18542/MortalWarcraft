#ifndef MORTAL_LEVEL_H
#define MORTAL_LEVEL_H

#include "Common.h"
#include "Player.h"
#include "DatabaseEnv.h"

#define MAX_MORTAL_LEVEL 25
#define MIN_MORTAL_LEVEL 1
#define SKILL_POINTS_PER_LEVEL 48
#define MAX_SKILL_POINTS 1200
#define MAX_ATTRIBUTE_PER_STAT 150
#define MAX_ATTRIBUTE_TOTAL 400

class MortalLevel
{
public:
    static void Load();
    static void Unload();

    static void OnLogin(Player* player);
    static uint32 GetDerivedLevel(Player* player);
    static uint32 GetTotalSkillPoints(Player* player);
    static void OverridePlayerLevel(Player* player);

    static void OnSkillGain(Player* player, uint32 skillId, uint32 newValue);

private:
    static uint32 CalculateDerivedLevel(uint32 totalSkillPoints);
    static void SendLevelUpdate(Player* player);
};

#endif
