#ifndef MORTAL_HOOKS_H
#define MORTAL_HOOKS_H

#include "Common.h"
#include "DatabaseEnv.h"
#include "Define.h"
#include "Player.h"
#include "SpellMgr.h"
#include "World.h"
#include "WorldSession.h"

class MortalHooks
{
public:
    static void Load();
    static void Unload();

    static void OnPlayerLogin(Player* player);
    static void OnPlayerLogout(Player* player);
    static void OnPlayerDeath(Player* player, Unit* killer);
    static void OnPlayerEnterZone(Player* player, uint32 zoneId);
    static void OnPlayerGiveXP(Player* player, uint32 amount, Unit* victim);
    static void OnPlayerLevelUp(Player* player);

    static void OnCreatureDeath(Creature* creature, Unit* killer);
    static void OnSpellCast(Player* player, Spell* spell, bool skipCheck);

    static uint32 GetMortalDerivedLevel(Player* player);
    static uint32 GetMortalSkillValue(Player* player, uint32 skillId);
    static void SetMortalSkillValue(Player* player, uint32 skillId, uint32 value);
    static void GainMortalSkill(Player* player, uint32 skillId, uint32 amount);

    static bool IsAllowedArea(uint32 zoneId);
    static uint32 GetZoneRiskTier(uint32 zoneId);
};

#endif
