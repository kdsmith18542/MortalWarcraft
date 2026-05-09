#ifndef CONTRACT_SYSTEM_H
#define CONTRACT_SYSTEM_H

#include "Common.h"
#include "Player.h"

class ContractSystem
{
public:
    static void Load();
    static void Unload();

    static bool CreateContract(Player* player, uint32 templateId, uint32 reward);
    static bool AcceptContract(Player* player, uint32 contractId);
    static bool CompleteContract(Player* player, uint32 contractId);
    static bool FailContract(Player* player, uint32 contractId);

    static uint32 GetActiveContractCount(Player* player);
    static uint32 GetMaxContracts(Player* player);

private:
    static void LoadContractTemplates();
};

#endif
