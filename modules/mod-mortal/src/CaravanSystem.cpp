#include "CaravanSystem.h"
#include "Player.h"
#include "WorldSession.h"
#include "Chat.h"
#include "DatabaseEnv.h"
#include <unordered_map>
#include <vector>

struct CaravanEntry { uint32 id, ownerGuid, routeId, currentWaypoint; std::vector<uint32> memberGuids; uint32 health; float speed; bool moving; uint32 cargoItemId, cargoCount; };
struct CaravanRoute { uint32 id, startZone, endZone, duration, rewardGold, riskTier; };

static std::unordered_map<uint32, CaravanEntry> s_caravans;
static std::unordered_map<uint32, CaravanRoute> s_routes;

void CaravanSystem::Load() { LOG_INFO("module", ">> mod-mortal: CaravanSystem loaded"); LoadCaravanRoutes(); }
void CaravanSystem::Unload() { s_caravans.clear(); s_routes.clear(); }

bool CaravanSystem::CreateCaravan(Player* player, uint32 routeId)
{
    auto it = s_routes.find(routeId);
    if (it == s_routes.end()) { ChatHandler(player->GetSession()).SendSysMessage("Route not found."); return false; }
    uint32 id = static_cast<uint32>(s_caravans.size()) + 1;
    s_caravans[id] = {id, player->GetGUID().GetCounter(), routeId, 0, {}, 100, 1.0f, false, 0, 0};
    s_caravans[id].memberGuids.push_back(player->GetGUID().GetCounter());
    ChatHandler(player->GetSession()).SendSysMessage("Caravan created!");
    return true;
}

bool CaravanSystem::JoinCaravan(Player* player, uint32 caravanId)
{
    auto it = s_caravans.find(caravanId);
    if (it == s_caravans.end()) return false;
    if (std::find(it->second.memberGuids.begin(), it->second.memberGuids.end(), player->GetGUID().GetCounter()) != it->second.memberGuids.end()) return false;
    it->second.memberGuids.push_back(player->GetGUID().GetCounter());
    return true;
}

bool CaravanSystem::LeaveCaravan(Player* player, uint32 caravanId)
{
    auto it = s_caravans.find(caravanId);
    if (it == s_caravans.end()) return false;
    auto memberIt = std::find(it->second.memberGuids.begin(), it->second.memberGuids.end(), player->GetGUID().GetCounter());
    if (memberIt == it->second.memberGuids.end()) return false;
    it->second.memberGuids.erase(memberIt);
    return true;
}

void CaravanSystem::StartCaravanMove(uint32 caravanId) { auto it = s_caravans.find(caravanId); if (it != s_caravans.end()) it->second.moving = true; }

void CaravanSystem::OnCaravanArrive(uint32 caravanId)
{
    auto it = s_caravans.find(caravanId);
    if (it == s_caravans.end()) return;
    auto routeIt = s_routes.find(it->second.routeId);
    if (routeIt == s_routes.end()) return;
    for (uint32 memberGuid : it->second.memberGuids)
        if (Player* member = ObjectAccessor::FindPlayer(ObjectGuid::Create<HighGuid::Player>(memberGuid)))
        {
            member->ModifyMoney(routeIt->second.rewardGold * GOLD);
            ChatHandler(member->GetSession()).PSendSysMessage("Caravan arrived! You earned %u gold.", routeIt->second.rewardGold);
        }
    s_caravans.erase(caravanId);
}

void CaravanSystem::OnCaravanAttacked(uint32 caravanId)
{
    auto it = s_caravans.find(caravanId);
    if (it == s_caravans.end()) return;
    it->second.health -= 10;
    if (it->second.health <= 0)
    {
        for (uint32 memberGuid : it->second.memberGuids)
            if (Player* member = ObjectAccessor::FindPlayer(ObjectGuid::Create<HighGuid::Player>(memberGuid)))
                ChatHandler(member->GetSession()).SendSysMessage("Your caravan was destroyed!");
        s_caravans.erase(caravanId);
    }
}

float CaravanSystem::GetCaravanSpeed(uint32 caravanId)
{ auto it = s_caravans.find(caravanId); return it != s_caravans.end() ? it->second.speed : 0.0f; }

uint32 CaravanSystem::GetCaravanHealth(uint32 caravanId)
{ auto it = s_caravans.find(caravanId); return it != s_caravans.end() ? it->second.health : 0; }

void CaravanSystem::LoadCaravanRoutes()
{
    s_routes[1] = {1, 1, 3, 300, 50, 0};
    s_routes[2] = {2, 3, 1, 300, 50, 1};
    s_routes[3] = {3, 1519, 1, 600, 100, 2};
}
