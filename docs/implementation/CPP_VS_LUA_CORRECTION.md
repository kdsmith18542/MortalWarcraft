# C++ vs Lua Correction
## What Should Actually Be C++ vs Lua

**Date:** 2025-01-XX  
**Issue:** Created Lua scripts for systems that should be C++ modules

---

## The Policy

**Lua is for:**
- ✅ UI bridges (client-server communication)
- ✅ Quest/gossip wrappers (simple NPC interactions)
- ✅ Configuration (data-driven systems)
- ✅ Rapid prototyping (experimental features)
- ✅ Infrequent updates (season challenges, one-time events)

**C++ is for:**
- ✅ Performance-critical systems (combat, skills, stats)
- ✅ Security-critical systems (economy, banking, transactions)
- ✅ Frequently-called systems (every frame/tick)
- ✅ NPC/Item/GameObject interaction (reliable hooks needed)
- ✅ Core game mechanics (combat, crafting, PvP)

---

## What I Created (WRONG)

### ❌ Lua Scripts Created (Should Be C++)

1. **`lua/buy_order_system.lua`** - ❌ **SHOULD BE C++**
   - **Why:** Economy system, NPC interaction, security-critical
   - **Should be:** `MortalBuyOrders.cpp/h` with `CreatureScript` for gossip
   - **Reason:** Economy transactions need security, NPC gossip needs reliable hooks

2. **`lua/hot_zones_system.lua`** - ⚠️ **COULD BE C++**
   - **Why:** Economy system, affects multiple systems
   - **Should be:** `MortalHotZones.cpp/h` with `WorldScript` for rotation
   - **Reason:** Economy system, affects task boards, buy orders, courier contracts

3. **`lua/blessed_items_system.lua`** - ❌ **SHOULD BE C++**
   - **Why:** Item protection, security-critical, item interaction
   - **Should be:** `MortalBlessedItems.cpp/h` with `ItemScript` for blessing
   - **Reason:** Item protection is security-critical, needs reliable hooks

4. **`lua/navigation_system.lua`** - ✅ **OK IN LUA** (maybe)
   - **Why:** UI-driven, infrequent updates, POI discovery
   - **Could stay Lua:** If it's just UI communication
   - **Should be C++:** If it affects gameplay (route hints, discovery mechanics)

---

## What Should Actually Exist

### ✅ C++ Modules Needed

1. **`MortalBuyOrders.cpp/h`**
   ```cpp
   class CreatureScript_MortalBuyOrders : public CreatureScript
   {
       bool OnGossipHello(Player* player, Creature* creature) override;
       bool OnGossipSelect(Player* player, Creature* creature, uint32 sender, uint32 action) override;
   };
   
   class WorldScript_MortalBuyOrders : public WorldScript
   {
       void OnUpdate(uint32 diff) override; // Refresh orders
   };
   ```

2. **`MortalHotZones.cpp/h`**
   ```cpp
   class WorldScript_MortalHotZones : public WorldScript
   {
       void OnUpdate(uint32 diff) override; // Rotation timer
       void RotateHotZones(); // Weekly rotation
   };
   ```

3. **`MortalBlessedItems.cpp/h`**
   ```cpp
   class ItemScript_MortalBlessedItems : public ItemScript
   {
       bool OnUse(Player* player, Item* item, SpellCastTargets const& targets) override;
   };
   
   class PlayerScript_MortalBlessedItems : public PlayerScript
   {
       void OnPlayerDeath(Player* player, Unit* killer) override; // Check blessed items
   };
   ```

---

## Existing C++ Economy Modules

Looking at existing code, there are already C++ modules for economy:

- ✅ `MortalRegionalBank.cpp/h` - Regional banking (C++)
- ✅ `MortalMarketStalls.cpp/h` - Market stalls (C++)
- ✅ `MortalCourierContracts.cpp/h` - Courier contracts (C++)

**Pattern:** All economy systems are in C++ for security and reliability.

---

## The Mistake

I created Lua scripts because:
1. ❌ Assumed Lua was acceptable for all systems
2. ❌ Didn't check existing C++ economy modules
3. ❌ Didn't follow the established pattern (economy = C++)

**Reality:**
- Economy systems = C++ (security, reliability)
- NPC interaction = C++ (reliable hooks)
- Item protection = C++ (security-critical)

---

## What Needs to Happen

### Immediate Action

1. **Delete Lua scripts:**
   - ❌ `lua/buy_order_system.lua` - Delete
   - ❌ `lua/blessed_items_system.lua` - Delete
   - ⚠️ `lua/hot_zones_system.lua` - Delete or keep for UI only
   - ✅ `lua/navigation_system.lua` - Keep if UI-only, move to C++ if gameplay

2. **Create C++ modules:**
   - ✅ `src/MortalBuyOrders.cpp/h` - NPC buy order system
   - ✅ `src/MortalHotZones.cpp/h` - Regional economic bonuses
   - ✅ `src/MortalBlessedItems.cpp/h` - Item protection system

3. **Update ScriptMgr.cpp:**
   - Register `CreatureScript_MortalBuyOrders`
   - Register `WorldScript_MortalHotZones`
   - Register `ItemScript_MortalBlessedItems`
   - Register `PlayerScript_MortalBlessedItems`

---

## Correct Implementation Pattern

### Buy Orders (C++)

```cpp
// MortalBuyOrders.h
class CreatureScript_MortalBuyOrders : public CreatureScript
{
public:
    CreatureScript_MortalBuyOrders() : CreatureScript("CreatureScript_MortalBuyOrders") { }
    
    bool OnGossipHello(Player* player, Creature* creature) override;
    bool OnGossipSelect(Player* player, Creature* creature, uint32 sender, uint32 action) override;
    
private:
    void ShowBuyOrders(Player* player, Creature* creature);
    void FulfillOrder(Player* player, uint32 orderId, uint32 quantity);
    void GenerateBuyOrders(uint32 npcEntry);
};

// MortalBuyOrders.cpp
bool CreatureScript_MortalBuyOrders::OnGossipHello(Player* player, Creature* creature)
{
    // Check if NPC has buy orders
    // Show gossip menu with buy orders
    return true;
}
```

### Hot Zones (C++)

```cpp
// MortalHotZones.h
class WorldScript_MortalHotZones : public WorldScript
{
public:
    WorldScript_MortalHotZones() : WorldScript("WorldScript_MortalHotZones") { }
    
    void OnUpdate(uint32 diff) override;
    void RotateHotZones();
    
private:
    uint32 m_rotationTimer;
    static const uint32 ROTATION_INTERVAL = 7 * 24 * 60 * 60 * IN_MILLISECONDS; // 7 days
};
```

### Blessed Items (C++)

```cpp
// MortalBlessedItems.h
class ItemScript_MortalBlessedItems : public ItemScript
{
public:
    ItemScript_MortalBlessedItems() : ItemScript("ItemScript_MortalBlessedItems") { }
    
    bool OnUse(Player* player, Item* item, SpellCastTargets const& targets) override;
};

class PlayerScript_MortalBlessedItems : public PlayerScript
{
public:
    PlayerScript_MortalBlessedItems() : PlayerScript("PlayerScript_MortalBlessedItems") { }
    
    void OnPlayerDeath(Player* player, Unit* killer) override;
    
private:
    bool IsItemBlessed(Player* player, Item* item);
    void ConsumeBlessingCharge(Player* player, Item* item);
};
```

---

## Conclusion

**I made a mistake:** Created Lua scripts for systems that should be C++ modules.

**Correct approach:**
- ✅ Economy systems → C++ (security, reliability)
- ✅ NPC interaction → C++ (reliable hooks)
- ✅ Item protection → C++ (security-critical)
- ✅ UI communication → Lua (OK)
- ✅ Infrequent updates → Lua (OK)

**Next steps:**
1. Delete incorrect Lua scripts
2. Create C++ modules instead
3. Follow established pattern (economy = C++)

---

**Status:** ❌ **INCORRECT IMPLEMENTATION** - Needs correction to C++ modules

