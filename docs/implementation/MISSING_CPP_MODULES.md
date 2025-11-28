# Missing C++ Modules
## Systems That Need C++ Implementation

**Date:** 2025-01-XX  
**Status:** ⚠️ **C++ MODULES NEEDED** - Lua scripts removed, C++ modules need to be created

---

## Systems That Need C++ Implementation

### 1. NPC Buy Orders System

**Should be:** `src/MortalBuyOrders.cpp/h`

**Requirements:**
- `CreatureScript` for NPC gossip menus
- `WorldScript` for automatic order generation/refresh
- Database queries for `mortal_buy_orders` table
- Order fulfillment logic
- Price calculation with multipliers

**Integration:**
- Register in `ScriptMgr.cpp`
- Use existing `MortalOverhaul` pattern

---

### 2. Hot Zones System

**Should be:** `src/MortalHotZones.cpp/h`

**Requirements:**
- `WorldScript` for weekly rotation timer
- Database queries for `mortal_regional_bonuses` table
- Bonus multiplier application to:
  - Task board rewards
  - Buy order prices
  - Courier contract rewards
- World announcements

**Integration:**
- Register in `ScriptMgr.cpp`
- Integrate with `MortalTaskRewards.cpp` for task gold bonuses
- Integrate with `MortalBuyOrders.cpp` for buy order price bonuses
- Integrate with `MortalCourierContracts.cpp` for courier gold bonuses

---

### 3. Blessed Items System

**Should be:** `src/MortalBlessedItems.cpp/h`

**Requirements:**
- `ItemScript` for blessing items (item usage)
- `PlayerScript` for death protection (check blessed items on death)
- Database queries for `mortal_blessed_items` table
- Charge consumption logic
- Expiration cleanup

**Integration:**
- Register in `ScriptMgr.cpp`
- Integrate with Red Zone death system (check if item is blessed before dropping)
- Use existing `MortalOverhaul` death handling

---

### 4. Navigation System

**Status:** ⚠️ **UNCERTAIN** - Check if UI-only or gameplay-affecting

**If UI-only:**
- ✅ Can stay Lua (client-server communication)

**If gameplay-affecting:**
- Should be: `src/MortalNavigation.cpp/h`
- `PlayerScript` for POI discovery
- `WorldScript` for route hints
- Database queries for `mortal_map_pois` and `mortal_poi_discoveries`

---

## Implementation Priority

1. **High Priority:**
   - `MortalBuyOrders.cpp/h` - Economy system, NPC interaction
   - `MortalBlessedItems.cpp/h` - Security-critical, item protection

2. **Medium Priority:**
   - `MortalHotZones.cpp/h` - Economy system, affects multiple systems

3. **Low Priority:**
   - `MortalNavigation.cpp/h` - Only if gameplay-affecting (not just UI)

---

## Database Tables (Already Created)

All required database tables already exist:
- ✅ `mortal_buy_orders` - `sql/85_economy_extensions.sql`
- ✅ `mortal_regional_bonuses` - `sql/85_economy_extensions.sql`
- ✅ `mortal_blessed_items` - `sql/85_economy_extensions.sql`
- ✅ `mortal_map_pois` - `sql/119_navigation_poi_tables.sql`
- ✅ `mortal_poi_discoveries` - `sql/119_navigation_poi_tables.sql`

---

## Next Steps

1. **Create C++ modules:**
   - `src/MortalBuyOrders.cpp/h`
   - `src/MortalHotZones.cpp/h`
   - `src/MortalBlessedItems.cpp/h`

2. **Register in ScriptMgr.cpp:**
   - Add script registrations
   - Follow existing pattern

3. **Update CMakeLists.txt:**
   - Add new source files to build

4. **Test integration:**
   - Verify NPC gossip works
   - Verify order generation works
   - Verify blessed item protection works

---

**Status:** ⚠️ **C++ MODULES NEEDED** - Lua scripts removed, awaiting C++ implementation

