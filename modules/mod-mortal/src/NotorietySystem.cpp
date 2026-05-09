#include "NotorietySystem.h"
#include "Player.h"
#include "DatabaseEnv.h"
#include "WorldSession.h"
#include "Chat.h"
#include <unordered_map>

struct NotorietyEntry
{
    int32 notoriety;
    uint32 lastUpdated;
    uint32 criminalUntil;
};

static std::unordered_map<uint32, NotorietyEntry> s_notorietyData;
static uint32 s_notorietyUpdateTimer = 0;

void NotorietySystem::Load()
{
    LOG_INFO("module", ">> mod-mortal: NotorietySystem loaded");
    LOG_INFO("module", ">> mod-mortal: Criminal threshold: {}, Outlaw threshold: {}", CRIMINAL_THRESHOLD, OUTLAW_THRESHOLD);
}

void NotorietySystem::Unload()
{
    s_notorietyData.clear();
}

void NotorietySystem::Update(uint32 diff)
{
    s_notorietyUpdateTimer += diff;
    if (s_notorietyUpdateTimer >= NOTORIETY_DECAY_INTERVAL)
    {
        CharacterDatabasePreparedStatement* stmt = CharacterDatabase.GetPreparedStatement(CHAR_UPD_MORTAL_NOTORIETY_BULK_DECAY);
        stmt->SetData(0, time(nullptr));
        CharacterDatabase.Execute(stmt);

        for (auto& pair : s_notorietyData)
        {
            if (pair.second.notoriety > 0)
                pair.second.notoriety--;
        }

        s_notorietyUpdateTimer = 0;
    }
}

void NotorietySystem::OnLogin(Player* player)
{
    LoadNotoriety(player);
}

void NotorietySystem::OnDeath(Player* player, Unit* killer)
{
    if (!killer || !killer->IsPlayer())
        return;

    if (killer->ToPlayer() != player)
        ModifyNotoriety(player, 5);
}

void NotorietySystem::OnPlayerKill(Player* killer, Player* victim)
{
    uint32 zoneId = killer->GetZoneId();
    uint32 victimZone = victim->GetZoneId();

    ModifyNotoriety(killer, 25);
    ModifyNotoriety(victim, -5);
}

void NotorietySystem::OnReputationChange(Player* player, uint32 factionId, int32& standing, bool incremental)
{
}

int32 NotorietySystem::GetNotoriety(Player* player)
{
    auto it = s_notorietyData.find(player->GetGUID().GetCounter());
    if (it != s_notorietyData.end())
        return it->second.notoriety;
    return 0;
}

void NotorietySystem::ModifyNotoriety(Player* player, int32 delta)
{
    uint32 guid = player->GetGUID().GetCounter();
    int32 newValue = s_notorietyData[guid].notoriety + delta;

    if (newValue > NOTORIETY_MAX)
        newValue = NOTORIETY_MAX;
    if (newValue < 0)
        newValue = 0;

    s_notorietyData[guid].notoriety = newValue;
    s_notorietyData[guid].lastUpdated = time(nullptr);

    if (IsCriminal(player))
        ApplyCriminalFlag(player, 300000);

    SaveNotoriety(player);
}

void NotorietySystem::SetNotoriety(Player* player, int32 value)
{
    if (value > NOTORIETY_MAX)
        value = NOTORIETY_MAX;
    if (value < 0)
        value = 0;

    s_notorietyData[player->GetGUID().GetCounter()].notoriety = value;
    s_notorietyData[player->GetGUID().GetCounter()].lastUpdated = time(nullptr);
    SaveNotoriety(player);
}

bool NotorietySystem::IsCriminal(Player* player)
{
    return GetNotoriety(player) >= CRIMINAL_THRESHOLD;
}

bool NotorietySystem::IsOutlaw(Player* player)
{
    return GetNotoriety(player) >= OUTLAW_THRESHOLD;
}

uint32 NotorietySystem::GetCriminalFlagDuration(Player* player)
{
    auto it = s_notorietyData.find(player->GetGUID().GetCounter());
    if (it != s_notorietyData.end())
    {
        uint32 now = time(nullptr);
        if (it->second.criminalUntil > now)
            return it->second.criminalUntil - now;
    }
    return 0;
}

void NotorietySystem::SaveNotoriety(Player* player)
{
    uint32 guid = player->GetGUID().GetCounter();
    auto it = s_notorietyData.find(guid);
    if (it == s_notorietyData.end())
        return;

    CharacterDatabasePreparedStatement* stmt = CharacterDatabase.GetPreparedStatement(CHAR_INS_OR_UPD_MORTAL_NOTORIETY);
    stmt->SetData(0, guid);
    stmt->SetData(1, it->second.notoriety);
    stmt->SetData(2, it->second.lastUpdated);
    stmt->SetData(3, 0);
    stmt->SetData(4, it->second.lastUpdated);
    CharacterDatabase.Execute(stmt);
}

void NotorietySystem::LoadNotoriety(Player* player)
{
    uint32 guid = player->GetGUID().GetCounter();

    CharacterDatabasePreparedStatement* stmt = CharacterDatabase.GetPreparedStatement(CHAR_SEL_MORTAL_NOTORIETY);
    stmt->SetData(0, guid);
    PreparedQueryResult result = CharacterDatabase.Query(stmt);

    if (result)
    {
        Field* fields = result->Fetch();
        s_notorietyData[guid].notoriety = fields[0].Get<int32>();

        CharacterDatabasePreparedStatement* flagStmt = CharacterDatabase.GetPreparedStatement(CHAR_SEL_MORTAL_CRIMINAL_FLAG);
        flagStmt->SetData(0, guid);
        PreparedQueryResult flagResult = CharacterDatabase.Query(flagStmt);

        if (flagResult)
            s_notorietyData[guid].criminalUntil = flagResult->Fetch()[0].Get<uint32>();
        else
            s_notorietyData[guid].criminalUntil = 0;
    }
    else
    {
        s_notorietyData[guid] = { 0, static_cast<uint32>(time(nullptr)), 0 };
    }
}

void NotorietySystem::ApplyCriminalFlag(Player* player, uint32 durationMs)
{
    uint32 guid = player->GetGUID().GetCounter();
    uint32 until = time(nullptr) + (durationMs / 1000);
    s_notorietyData[guid].criminalUntil = until;

    CharacterDatabasePreparedStatement* stmt = CharacterDatabase.GetPreparedStatement(CHAR_REP_MORTAL_CRIMINAL_FLAG);
    stmt->SetData(0, guid);
    stmt->SetData(1, until);
    CharacterDatabase.Execute(stmt);

    ChatHandler(player->GetSession()).SendSysMessage("|cffff0000You are now flagged as a Criminal!|r");
}

void NotorietySystem::RemoveCriminalFlag(Player* player)
{
    uint32 guid = player->GetGUID().GetCounter();
    s_notorietyData[guid].criminalUntil = 0;

    CharacterDatabasePreparedStatement* stmt = CharacterDatabase.GetPreparedStatement(CHAR_DEL_MORTAL_CRIMINAL_FLAG);
    stmt->SetData(0, guid);
    CharacterDatabase.Execute(stmt);

    ChatHandler(player->GetSession()).SendSysMessage("|cff00ff00Criminal flag removed.|r");
}
