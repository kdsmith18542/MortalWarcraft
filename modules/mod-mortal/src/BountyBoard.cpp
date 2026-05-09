#include "BountyBoard.h"
#include "Player.h"
#include "DatabaseEnv.h"
#include "WorldSession.h"
#include "Chat.h"

void BountyBoard::Load() { LOG_INFO("module", ">> mod-mortal: BountyBoard system loaded"); LoadBounties(); }
void BountyBoard::Unload() {}

void BountyBoard::OnPlayerKill(Player* killer, Player* victim)
{
    if (!IsPlayerBountied(victim)) return;
    uint32 amount = GetBountyOnPlayer(victim);
    killer->ModifyMoney(amount * GOLD);
    ChatHandler(killer->GetSession()).PSendSysMessage("You claimed a bounty of %u gold!", amount);
    CharacterDatabasePreparedStatement* stmt = CharacterDatabase.GetPreparedStatement(CHAR_DEL_MORTAL_BOUNTIES_ON_TARGET);
    stmt->SetData(0, victim->GetGUID().GetCounter());
    CharacterDatabase.Execute(stmt);
}

bool BountyBoard::PostBounty(Player* poster, Player* target, uint32 amount)
{
    if (poster->GetMoney() < amount * GOLD)
        { ChatHandler(poster->GetSession()).SendSysMessage("You don't have enough gold."); return false; }
    poster->ModifyMoney(-static_cast<int32>(amount * GOLD));
    CharacterDatabasePreparedStatement* stmt = CharacterDatabase.GetPreparedStatement(CHAR_INS_MORTAL_BOUNTY);
    stmt->SetData(0, poster->GetGUID().GetCounter()); stmt->SetData(1, target->GetGUID().GetCounter());
    stmt->SetData(2, amount); stmt->SetData(3, time(nullptr));
    CharacterDatabase.Execute(stmt);
    ChatHandler(poster->GetSession()).PSendSysMessage("Bounty of %u gold placed on %s!", amount, target->GetName().c_str());
    return true;
}

bool BountyBoard::ClaimBounty(Player* claimer, Player* target) { return IsPlayerBountied(target); }

uint32 BountyBoard::GetBountyOnPlayer(Player* target)
{
    CharacterDatabasePreparedStatement* stmt = CharacterDatabase.GetPreparedStatement(CHAR_SEL_MORTAL_BOUNTY);
    stmt->SetData(0, target->GetGUID().GetCounter());
    PreparedQueryResult result = CharacterDatabase.Query(stmt);
    return result ? result->Fetch()[0].Get<uint32>() : 0;
}

bool BountyBoard::IsPlayerBountied(Player* target) { return GetBountyOnPlayer(target) > 0; }
void BountyBoard::LoadBounties() {}
