#ifndef TASK_BOARD_H
#define TASK_BOARD_H
#include "Common.h"
#include "Player.h"

class TaskBoard
{
public:
    static void Load();
    static void Unload();
    static void OnCreatureDeath(Creature* creature, Unit* killer);
    static bool OfferTask(Player* player, uint32 taskId);
    static bool CompleteTask(Player* player, uint32 taskId);
    static bool IsOnTask(Player* player, uint32 taskId);
    static uint32 GetTaskProgress(Player* player, uint32 taskId);
    static void SetTaskProgress(Player* player, uint32 taskId, uint32 progress);
    static void GenerateDailyTasks(Player* player);
    static uint32 GetAvailableTaskCount(Player* player);
private:
    static void LoadTaskTemplates();
};
#endif
