# C++ vs Lua Migration Analysis

**Date:** 2025-01-XX  
**Question:** Should we migrate Lua scripts to C++ for better performance and integration?

---

## Current State

### C++ Implementation (Already Done)
- ✅ **Combat Formulas** (`MortalCombat.cpp`) - Performance critical
- ✅ **Dynamic Level System** (`MortalLevel.cpp`) - Called frequently
- ✅ **NPC Rebalance** (`MortalCreature.cpp`) - Performance critical
- ✅ **Brace Mechanic** (`ScriptMgr.cpp` - `UnitScript_MortalBrace`)
- ✅ **Spell Scaling** (`ScriptMgr.cpp` - `UnitScript_MortalSpellScaling`)
- ✅ **XP Override** (`ScriptMgr.cpp` - `PlayerScript_MortalXP`)
- ✅ **Stat Caps** (`ScriptMgr.cpp` - `PlayerScript_MortalLevel`)

**Pattern:** Performance-critical, frequently-called systems are in C++

### Lua Implementation (Current)
- ⚠️ **Fishing System** - Event-driven, but hook is commented out
- ⚠️ **First Aid System** - Item usage, but no hooks
- ⚠️ **Factions System** - Chat commands only
- ⚠️ **Runes & Augments** - Item usage, but no hooks
- ⚠️ **Endless Contracts** - Event-driven, but no hooks
- ⚠️ **Build Presets** - Chat commands only

**Pattern:** Many systems have functions but no event hooks

---

## Why C++ Migration Makes Sense

### 1. Performance
- **C++**: Direct execution, no interpreter overhead
- **Lua**: Interpreted, slower for frequent calls
- **Impact**: Systems called every frame/tick should be C++

### 2. Event Hook Reliability
- **C++**: Direct AzerothCore hooks, guaranteed execution
- **Lua**: Eluna layer, potential compatibility issues
- **Impact**: Critical systems need reliable hooks

### 3. API Access
- **C++**: Full AzerothCore API access
- **Lua**: Eluna wrapper, may have limitations
- **Impact**: Complex operations need direct API access

### 4. Integration
- **C++**: Compiles with server, always available
- **Lua**: Runtime loading, potential errors
- **Impact**: Core systems should be C++

---

## Systems That Should Be C++

### High Priority (Performance-Critical)

1. **Fishing System**
   - **Why**: GameObject interaction, called frequently
   - **Current**: Lua with commented-out hook
   - **Migration**: `GameObjectScript` for fishing spots
   - **Benefit**: Reliable hooks, better performance

2. **First Aid System**
   - **Why**: Item usage, called frequently
   - **Current**: Lua with no hooks
   - **Migration**: `ItemScript` for first aid items
   - **Benefit**: Direct item usage handling

3. **Runes & Augments**
   - **Why**: Item usage, gear modification
   - **Current**: Lua with no hooks
   - **Migration**: `ItemScript` for runes/augments
   - **Benefit**: Reliable item socketing

4. **Endless Contracts**
   - **Why**: Wave spawning, frequent updates
   - **Current**: Lua with no hooks
   - **Migration**: `WorldScript` for wave management
   - **Benefit**: Better performance for wave logic

### Medium Priority (Integration-Critical)

5. **Factions System**
   - **Why**: NPC gossip, standing updates
   - **Current**: Lua with chat commands only
   - **Migration**: `CreatureScript` for gossip menus
   - **Benefit**: Reliable NPC interaction

6. **Build Presets**
   - **Why**: Gear swapping, attribute changes
   - **Current**: Lua with chat commands only
   - **Migration**: `PlayerScript` for preset loading
   - **Benefit**: Reliable gear/stat changes

### Low Priority (Can Stay Lua)

7. **Season Challenges**
   - **Why**: Infrequent updates, mostly data tracking
   - **Current**: Lua with chat commands
   - **Status**: Can stay Lua (not performance-critical)

8. **Navigation/Wayfinding**
   - **Why**: UI-driven, infrequent updates
   - **Status**: Can stay Lua

---

## Migration Strategy

### Phase 1: Critical Systems (Immediate)
1. **First Aid System** → `ItemScript`
   - Item usage is critical
   - No Lua hooks currently work
   - Direct C++ access needed

2. **Runes & Augments** → `ItemScript`
   - Item socketing needs reliability
   - Gear modification is critical
   - Performance matters

3. **Fishing System** → `GameObjectScript`
   - GameObject interaction
   - Currently commented out in Lua
   - Needs reliable hooks

### Phase 2: Integration Systems (Next)
4. **Factions System** → `CreatureScript`
   - NPC gossip menus
   - Standing updates
   - Better integration

5. **Endless Contracts** → `WorldScript` + `CreatureScript`
   - Wave spawning
   - Contract start NPCs
   - Performance for wave logic

### Phase 3: Quality of Life (Later)
6. **Build Presets** → `PlayerScript`
   - Gear swapping
   - Attribute changes
   - Can be Lua if performance is acceptable

---

## C++ Implementation Pattern

### Example: First Aid Item Script

```cpp
// MortalFirstAid.cpp
class ItemScript_MortalFirstAid : public ItemScript
{
public:
    ItemScript_MortalFirstAid() : ItemScript("ItemScript_MortalFirstAid") { }

    bool OnUse(Player* player, Item* item, SpellCastTargets const& targets) override
    {
        uint32 itemEntry = item->GetEntry();
        
        // Get first aid item definition from DB
        // Apply healing/debuff removal
        // Gain skill
        // Consume item
        
        return true;
    }
};

// In ScriptMgr.cpp
void AddSC_MortalOverhaul()
{
    new ItemScript_MortalFirstAid();
}
```

### Example: Fishing GameObject Script

```cpp
// MortalFishing.cpp
class GameObjectScript_MortalFishing : public GameObjectScript
{
public:
    GameObjectScript_MortalFishing() : GameObjectScript("GameObjectScript_MortalFishing") { }

    bool OnGossipHello(Player* player, GameObject* go) override
    {
        // Check if fishing spot
        // Start fishing minigame
        // Handle catch logic
        return true;
    }
};
```

---

## Benefits of C++ Migration

### Performance
- **10-100x faster** for frequently-called functions
- No interpreter overhead
- Direct memory access

### Reliability
- **Guaranteed execution** - no Eluna compatibility issues
- **Compile-time checks** - catch errors early
- **Better debugging** - C++ debuggers work

### Integration
- **Direct API access** - no wrapper limitations
- **Better event hooks** - native AzerothCore hooks
- **Type safety** - compile-time type checking

### Maintenance
- **Single codebase** - C++ for core systems
- **Easier testing** - unit tests in C++
- **Better documentation** - C++ is self-documenting

---

## Trade-offs

### Pros of C++
- ✅ Performance
- ✅ Reliability
- ✅ Full API access
- ✅ Better integration

### Cons of C++
- ❌ Requires recompilation
- ❌ More complex code
- ❌ Longer development time

### Pros of Lua
- ✅ Easy to modify
- ✅ No recompilation
- ✅ Faster iteration
- ✅ Good for prototyping

### Cons of Lua
- ❌ Performance overhead
- ❌ Eluna compatibility issues
- ❌ Limited API access
- ❌ Runtime errors

---

## Recommendation

**YES, migrate critical systems to C++:**

1. **Item Usage Systems** (First Aid, Runes, Augments)
   - Need reliable `OnUseItem` hooks
   - Lua hooks are unreliable
   - C++ `ItemScript` is the solution

2. **GameObject Interaction** (Fishing, Contracts)
   - Need reliable GameObject hooks
   - Lua hooks are commented out/unreliable
   - C++ `GameObjectScript` is the solution

3. **NPC Interaction** (Factions, Vendors)
   - Need reliable gossip menus
   - Lua gossip is complex
   - C++ `CreatureScript` is cleaner

4. **Performance-Critical** (Wave spawning, frequent updates)
   - Need performance
   - Lua is too slow
   - C++ is necessary

**Keep in Lua:**
- UI-driven systems (Navigation, Wayfinding)
- Infrequent updates (Season Challenges)
- Prototyping/experimental features

---

## Migration Priority

1. **First Aid** → C++ `ItemScript` (HIGH - No hooks work)
2. **Runes & Augments** → C++ `ItemScript` (HIGH - No hooks work)
3. **Fishing** → C++ `GameObjectScript` (HIGH - Hook commented out)
4. **Factions** → C++ `CreatureScript` (MEDIUM - Need gossip)
5. **Endless Contracts** → C++ `WorldScript` (MEDIUM - Performance)
6. **Build Presets** → Keep Lua or C++ `PlayerScript` (LOW - Can work in Lua)

---

## Conclusion

**Yes, migrate critical systems to C++.**

The pattern shows:
- **Performance-critical systems are already in C++** (combat, leveling, NPC scaling)
- **Lua systems with missing hooks** should migrate to C++
- **Item/GameObject/NPC interaction** needs C++ for reliability
- **UI-driven systems can stay Lua**

**Estimated migration effort:**
- High priority: 3-4 systems (First Aid, Runes, Fishing)
- Medium priority: 2-3 systems (Factions, Contracts)
- **Total: ~2-3 weeks of focused work**

This will solve the "missing event hooks" problem and improve performance significantly.

