#include "TaskBoard.h"
#include "Player.h"
#include "DatabaseEnv.h"
#include "ObjectMgr.h"
#include "WorldSession.h"
#include "Chat.h"
#include <unordered_map>
#include <vector>

struct TaskTemplate
{
    uint32 id;
    uint32 killEntry;
    uint32 killCount;
    uint32 rewardGold;
    uint32 rewardItemId;
    uint32 rewardItemCount;
    uint32 minLevel;
    uint32 maxLevel;
};

struct TaskProgress
{
    uint32 taskId;
    uint32 currentCount;
    uint32 targetCount;
    bool completed;
};

static std::unordered_map<uint32, TaskTemplate> s_taskTemplates;
static std::unordered_map<uint32, std::unordered_map<uint32, TaskProgress>> s_playerTasks;

void TaskBoard::Load()
{
    LOG_INFO("module", ">> mod-mortal: TaskBoard system loaded");
    LoadTaskTemplates();
}

void TaskBoard::Unload()
{
    s_taskTemplates.clear();
    s_playerTasks.clear();
}

void TaskBoard::OnCreatureDeath(Creature* creature, Unit* killer)
{
    if (!killer || !killer->IsPlayer())
        return;

    Player* player = killer->ToPlayer();

    auto playerIt = s_playerTasks.find(player->GetGUID().GetCounter());
    if (playerIt == s_playerTasks.end())
        return;

    for (auto& taskPair : playerIt->second)
    {
        TaskProgress& progress = taskPair.second;
        if (progress.completed)
            continue;

        auto templateIt = s_taskTemplates.find(taskPair.first);
        if (templateIt == s_taskTemplates.end())
            continue;

        if (templateIt->second.killEntry == creature->GetEntry())
        {
            progress.currentCount++;
            if (progress.currentCount >= progress.targetCount)
            {
                progress.completed = true;
                ChatHandler(player->GetSession()).SendSysMessage("Task completed! Return to the task board for your reward.");
            }
        }
    }
}

bool TaskBoard::OfferTask(Player* player, uint32 taskId)
{
    auto it = s_taskTemplates.find(taskId);
    if (it == s_taskTemplates.end())
        return false;

    uint32 guid = player->GetGUID().GetCounter();
    s_playerTasks[guid][taskId] = { taskId, 0, it->second.killCount, false };

    ChatHandler(player->GetSession()).PSendSysMessage("Task accepted: Kill %u %s",
        it->second.killCount, "creatures");

    return true;
}

bool TaskBoard::CompleteTask(Player* player, uint32 taskId)
{
    uint32 guid = player->GetGUID().GetCounter();
    auto playerIt = s_playerTasks.find(guid);
    if (playerIt == s_playerTasks.end())
        return false;

    auto taskIt = playerIt->second.find(taskId);
    if (taskIt == playerIt->second.end() || !taskIt->second.completed)
        return false;

    auto templateIt = s_taskTemplates.find(taskId);
    if (templateIt == s_taskTemplates.end())
        return false;

    if (templateIt->second.rewardGold > 0)
        player->ModifyMoney(templateIt->second.rewardGold * GOLD);

    if (templateIt->second.rewardItemId > 0)
    {
        ItemPosCountVec dest;
        if (player->CanStoreNewItem(NULL_BAG, NULL_SLOT, dest, templateIt->second.rewardItemId, templateIt->second.rewardItemCount) == EQUIP_ERR_OK)
        {
            Item* item = player->StoreNewItem(dest, templateIt->second.rewardItemId, templateIt->second.rewardItemCount, true);
            player->SendNewItem(item, templateIt->second.rewardItemCount, true, false);
        }
    }

    playerIt->second.erase(taskIt);
    ChatHandler(player->GetSession()).SendSysMessage("Task complete! You received your reward.");

    return true;
}

bool TaskBoard::IsOnTask(Player* player, uint32 taskId)
{
    uint32 guid = player->GetGUID().GetCounter();
    auto playerIt = s_playerTasks.find(guid);
    if (playerIt == s_playerTasks.end())
        return false;

    return playerIt->second.find(taskId) != playerIt->second.end();
}

uint32 TaskBoard::GetTaskProgress(Player* player, uint32 taskId)
{
    uint32 guid = player->GetGUID().GetCounter();
    auto playerIt = s_playerTasks.find(guid);
    if (playerIt == s_playerTasks.end())
        return 0;

    auto taskIt = playerIt->second.find(taskId);
    if (taskIt == playerIt->second.end())
        return 0;

    return taskIt->second.currentCount;
}

void TaskBoard::SetTaskProgress(Player* player, uint32 taskId, uint32 progress)
{
    uint32 guid = player->GetGUID().GetCounter();
    s_playerTasks[guid][taskId].currentCount = progress;
}

void TaskBoard::GenerateDailyTasks(Player* player)
{
}

uint32 TaskBoard::GetAvailableTaskCount(Player* player)
{
    return static_cast<uint32>(s_taskTemplates.size());
}

void TaskBoard::LoadTaskTemplates()
{
    s_taskTemplates[1] = { 1, 0, 10, 10, 0, 0, 1, 25 };
    s_taskTemplates[2] = { 2, 0, 20, 25, 0, 0, 5, 25 };
    s_taskTemplates[3] = { 3, 0, 30, 50, 0, 0, 10, 25 };
}
