#include "MortalHooks.h"
#include "MortalLevel.h"
#include "MortalCombatSkills.h"
#include "MortalAttributes.h"
#include "ZoneRiskHandler.h"
#include "PvPHooks.h"
#include "RegionalBank.h"
#include "CraftingSystem.h"
#include "DynamicEcosystem.h"
#include "TaskBoard.h"
#include "NotorietySystem.h"
#include "BountyBoard.h"
#include "StrongholdHandler.h"
#include "TerritoryControl.h"
#include "CaravanSystem.h"
#include "ContractSystem.h"
#include "SiegeSystem.h"
#include "AdminHooks.h"
#include "LogHooks.h"
#include "ChatHandler.h"
#include "ScriptMgr.h"
#include "Chat.h"
#include "WorldSession.h"

class mod_mortal_WorldScript : public WorldScript
{
public:
    mod_mortal_WorldScript() : WorldScript("mod_mortal_WorldScript") { }

    void OnStartup() override
    {
        MortalHooks::Load();
        LOG_INFO("server.loading", ">> mod-mortal: Mortal Warcraft Overhaul loaded");
    }

    void OnShutdown() override
    {
        MortalHooks::Unload();
    }

    void OnUpdate(uint32 diff) override
    {
        NotorietySystem::Update(diff);
        DynamicEcosystem::Update(diff);
        SiegeSystem::Update(diff);
    }
};

class mod_mortal_PlayerScript : public PlayerScript
{
public:
    mod_mortal_PlayerScript() : PlayerScript("mod_mortal_PlayerScript") { }

    void OnLogin(Player* player) override
    {
        MortalHooks::OnPlayerLogin(player);
        MortalLevel::OnLogin(player);
        MortalAttributes::OnLogin(player);
        NotorietySystem::OnLogin(player);
    }

    void OnLogout(Player* player) override
    {
        MortalHooks::OnPlayerLogout(player);
    }

    void OnDeath(Player* player, Unit* killer) override
    {
        MortalHooks::OnPlayerDeath(player, killer);
        PvPHooks::OnDeath(player, killer);
        NotorietySystem::OnDeath(player, killer);
    }

    void OnGiveXP(Player* player, uint32& amount, Unit* victim) override
    {
        MortalHooks::OnPlayerGiveXP(player, amount, victim);
        amount = 0;
    }

    void OnLevelChanged(Player* player, uint8 oldLevel) override
    {
        MortalHooks::OnPlayerLevelUp(player);
    }

    void OnZoneChange(Player* player, uint32 newZone, uint32 newArea) override
    {
        MortalHooks::OnPlayerEnterZone(player, newZone);
        ZoneRiskHandler::OnZoneChange(player, newZone);
    }

    void OnReputationChange(Player* player, uint32 factionId, int32& standing, bool incremental) override
    {
        NotorietySystem::OnReputationChange(player, factionId, standing, incremental);
    }
};

class mod_mortal_SpellScript : public SpellScriptLoader
{
public:
    mod_mortal_SpellScript() : SpellScriptLoader("mod_mortal_SpellScript") { }

    void OnSpellCast(Spell* spell, bool skipCheck) override
    {
        if (Unit* caster = spell->GetCaster())
            if (Player* player = caster->ToPlayer())
                MortalHooks::OnSpellCast(player, spell, skipCheck);
    }
};

class mod_mortal_AllCreatureScript : public AllCreatureScript
{
public:
    mod_mortal_AllCreatureScript() : AllCreatureScript("mod_mortal_AllCreatureScript") { }

    void OnCreatureDeath(Creature* creature, Unit* killer) override
    {
        MortalHooks::OnCreatureDeath(creature, killer);
        DynamicEcosystem::OnCreatureDeath(creature, killer);
        TaskBoard::OnCreatureDeath(creature, killer);
    }

    void OnCreatureUpdate(Creature* creature, uint32 diff) override
    {
        DynamicEcosystem::OnCreatureUpdate(creature, diff);
    }
};

void Addmod_mortalScripts()
{
    AddSC_mod_mortal();
}

void AddSC_mod_mortal()
{
    new mod_mortal_WorldScript();
    new mod_mortal_PlayerScript();
    new mod_mortal_SpellScript();
    new mod_mortal_AllCreatureScript();

    MortalLevel::Load();
    MortalAttributes::Load();
    ZoneRiskHandler::Load();
    RegionalBank::Load();
    CraftingSystem::Load();
    TaskBoard::Load();
    NotorietySystem::Load();
    BountyBoard::Load();
    StrongholdHandler::Load();
    TerritoryControl::Load();
    CaravanSystem::Load();
    ContractSystem::Load();
    SiegeSystem::Load();
    AdminHooks::Load();
}

void MortalHooks::Load()
{
    LOG_INFO("module", "mod-mortal: Loading Mortal Warcraft Overhaul systems");
    MortalLevel::Load();
    MortalAttributes::Load();
    ZoneRiskHandler::Load();
    RegionalBank::Load();
    CraftingSystem::Load();
    DynamicEcosystem::Load();
    TaskBoard::Load();
    NotorietySystem::Load();
    BountyBoard::Load();
    StrongholdHandler::Load();
    TerritoryControl::Load();
    CaravanSystem::Load();
    ContractSystem::Load();
    SiegeSystem::Load();
    AdminHooks::Load();
    LogHooks::Load();
}

void MortalHooks::Unload()
{
}

void MortalHooks::OnPlayerLogin(Player* player)
{
    LOG_DEBUG("module", "mod-mortal: Player {} logged in", player->GetName());
    AdminHooks::OnPlayerLogin(player);
}

void MortalHooks::OnPlayerLogout(Player* player)
{
    LOG_DEBUG("module", "mod-mortal: Player {} logged out", player->GetName());
    RegionalBank::OnPlayerLogout(player);
}

void MortalHooks::OnPlayerDeath(Player* player, Unit* killer)
{
    LOG_DEBUG("module", "mod-mortal: Player {} died", player->GetName());
    PvPHooks::OnDeath(player, killer);
}

void MortalHooks::OnPlayerEnterZone(Player* player, uint32 zoneId)
{
    LOG_DEBUG("module", "mod-mortal: Player {} entered zone {}", player->GetName(), zoneId);
}

void MortalHooks::OnPlayerGiveXP(Player* player, uint32 amount, Unit* victim)
{
    if (victim)
        MortalCombatSkills::OnCombatKill(player, victim);
}

void MortalHooks::OnPlayerLevelUp(Player* player)
{
    LOG_DEBUG("module", "mod-mortal: Player {} leveled to {}", player->GetName(), uint32(player->GetLevel()));
}

void MortalHooks::OnCreatureDeath(Creature* creature, Unit* killer)
{
    LOG_DEBUG("module", "mod-mortal: Creature {} died", creature->GetEntry());
}

void MortalHooks::OnSpellCast(Player* player, Spell* spell, bool skipCheck)
{
}

uint32 MortalHooks::GetMortalDerivedLevel(Player* player)
{
    return MortalLevel::GetDerivedLevel(player);
}

uint32 MortalHooks::GetMortalSkillValue(Player* player, uint32 skillId)
{
    return MortalCombatSkills::GetSkillValue(player, skillId);
}

void MortalHooks::SetMortalSkillValue(Player* player, uint32 skillId, uint32 value)
{
    MortalCombatSkills::SetSkillValue(player, skillId, value);
}

void MortalHooks::GainMortalSkill(Player* player, uint32 skillId, uint32 amount)
{
    MortalCombatSkills::GainSkill(player, skillId, amount);
}

bool MortalHooks::IsAllowedArea(uint32 zoneId)
{
    return ZoneRiskHandler::IsAllowedZone(zoneId);
}

uint32 MortalHooks::GetZoneRiskTier(uint32 zoneId)
{
    return ZoneRiskHandler::GetRiskTier(zoneId);
}
