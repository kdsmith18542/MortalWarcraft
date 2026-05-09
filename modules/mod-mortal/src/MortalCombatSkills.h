#ifndef MORTAL_COMBAT_SKILLS_H
#define MORTAL_COMBAT_SKILLS_H

#include "Common.h"
#include "Player.h"
#include "DatabaseEnv.h"

#define MORTAL_SKILL_COUNT 20

enum MortalSkillId
{
    MORTAL_SKILL_SWORDS        = 0,
    MORTAL_SKILL_AXES          = 1,
    MORTAL_SKILL_MACES         = 2,
    MORTAL_SKILL_SPEARS        = 3,
    MORTAL_SKILL_BOWS          = 4,
    MORTAL_SKILL_CROSSBOWS     = 5,
    MORTAL_SKILL_DEFENSE       = 6,
    MORTAL_SKILL_BLOCKING      = 7,
    MORTAL_SKILL_PARRYING      = 8,
    MORTAL_SKILL_MAGIC_ARCANE  = 9,
    MORTAL_SKILL_MAGIC_FIRE    = 10,
    MORTAL_SKILL_MAGIC_FROST   = 11,
    MORTAL_SKILL_MAGIC_SHADOW  = 12,
    MORTAL_SKILL_MINING        = 13,
    MORTAL_SKILL_HERBALISM     = 14,
    MORTAL_SKILL_LUMBERJACKING = 15,
    MORTAL_SKILL_SKINNING      = 16,
    MORTAL_SKILL_FISHING       = 17,
    MORTAL_SKILL_STEALTH       = 18,
    MORTAL_SKILL_LOCKPICKING   = 19,
};

class MortalCombatSkills
{
public:
    static void Load();
    static void Unload();

    static void OnLogin(Player* player);

    static uint32 GetSkillValue(Player* player, uint32 skillId);
    static void SetSkillValue(Player* player, uint32 skillId, uint32 value);
    static void GainSkill(Player* player, uint32 skillId, uint32 amount);

    static void OnCombatKill(Player* player, Unit* victim);
    static void OnWeaponSwing(Player* player, uint32 weaponSkillId);
    static void OnDamageTaken(Player* player, uint32 amount);
    static void OnSpellCastSuccess(Player* player, uint32 spellSchool);

    static uint32 GetMaxSkillValue(uint32 skillId);

private:
    static void SaveSkillToDB(Player* player, uint32 skillId);
    static void LoadSkillsFromDB(Player* player);
};

#endif
