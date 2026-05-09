#include "ContractSystem.h"
#include "Player.h"
#include "DatabaseEnv.h"
#include "WorldSession.h"
#include "Chat.h"
#include <unordered_map>
#include <vector>

struct ContractTemplate { uint32 id, type, targetEntry, targetCount, duration, baseReward, penalty, minLevel; };
struct ContractEntry { uint32 id, templateId, ownerGuid, contractorGuid, progress, targetCount, timeRemaining; bool completed, failed; };

static std::unordered_map<uint32, ContractTemplate> s_contractTemplates;
static std::unordered_map<uint32, ContractEntry> s_activeContracts;
static std::unordered_map<uint32, std::vector<uint32>> s_playerContracts;

void ContractSystem::Load() { LOG_INFO("module", ">> mod-mortal: ContractSystem loaded"); LoadContractTemplates(); }
void ContractSystem::Unload() { s_contractTemplates.clear(); s_activeContracts.clear(); s_playerContracts.clear(); }

bool ContractSystem::CreateContract(Player* player, uint32 templateId, uint32 reward)
{
    auto it = s_contractTemplates.find(templateId);
    if (it == s_contractTemplates.end()) { ChatHandler(player->GetSession()).SendSysMessage("Contract template not found."); return false; }
    uint32 contractId = static_cast<uint32>(s_activeContracts.size()) + 1;
    s_activeContracts[contractId] = {contractId, templateId, player->GetGUID().GetCounter(), 0, 0, it->second.targetCount, it->second.duration, false, false};
    s_playerContracts[player->GetGUID().GetCounter()].push_back(contractId);
    ChatHandler(player->GetSession()).SendSysMessage("Contract created!");
    return true;
}

bool ContractSystem::AcceptContract(Player* player, uint32 contractId)
{
    auto it = s_activeContracts.find(contractId);
    if (it == s_activeContracts.end() || it->second.contractorGuid != 0) return false;
    it->second.contractorGuid = player->GetGUID().GetCounter();
    s_playerContracts[player->GetGUID().GetCounter()].push_back(contractId);
    ChatHandler(player->GetSession()).SendSysMessage("Contract accepted!");
    return true;
}

bool ContractSystem::CompleteContract(Player* player, uint32 contractId)
{
    auto it = s_activeContracts.find(contractId);
    if (it == s_activeContracts.end() || it->second.contractorGuid != player->GetGUID().GetCounter()) return false;
    auto templateIt = s_contractTemplates.find(it->second.templateId);
    if (templateIt == s_contractTemplates.end()) return false;
    it->second.completed = true;
    player->ModifyMoney(templateIt->second.baseReward * GOLD);
    ChatHandler(player->GetSession()).PSendSysMessage("Contract completed! You earned %u gold.", templateIt->second.baseReward);
    return true;
}

bool ContractSystem::FailContract(Player* player, uint32 contractId)
{
    auto it = s_activeContracts.find(contractId);
    if (it == s_activeContracts.end()) return false;
    it->second.failed = true;
    auto templateIt = s_contractTemplates.find(it->second.templateId);
    if (templateIt != s_contractTemplates.end())
    {
        int32 penalty = templateIt->second.penalty * GOLD;
        if (player->GetMoney() >= static_cast<uint32>(penalty)) player->ModifyMoney(-penalty);
    }
    return true;
}

uint32 ContractSystem::GetActiveContractCount(Player* player)
{
    auto it = s_playerContracts.find(player->GetGUID().GetCounter());
    if (it == s_playerContracts.end()) return 0;
    uint32 count = 0;
    for (uint32 cid : it->second)
    { auto cit = s_activeContracts.find(cid); if (cit != s_activeContracts.end() && !cit->second.completed && !cit->second.failed) count++; }
    return count;
}

uint32 ContractSystem::GetMaxContracts(Player* player) { return 5; }

void ContractSystem::LoadContractTemplates()
{
    s_contractTemplates[1] = {1, 0, 0, 10, 3600, 25, 10, 1};
    s_contractTemplates[2] = {2, 1, 0, 1, 7200, 100, 50, 5};
    s_contractTemplates[3] = {3, 2, 0, 5, 3600, 50, 25, 10};
}
