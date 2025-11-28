# AzerothCore Scripting Systems Explained

**Date:** 2025-01-23

---

## ScriptDevAI vs AzerothCore Scripting

### ScriptDevAI (SD2)
- **Status:** ❌ **NOT used in AzerothCore**
- **Origin:** MaNGOS/CMaNGOS scripting framework
- **Type:** C++ scripting framework
- **Location in this repo:** Only found in `mod-playerbots.backup/` (legacy backup)

### AzerothCore's Scripting Systems

AzerothCore uses **two complementary systems**:

#### 1. **SmartAI (SmartScripts)** - Database-Driven Scripting
- **Location:** `src/server/game/AI/SmartScripts/`
- **Type:** Database-driven (SQL-based)
- **How it works:**
  - Scripts defined in `smart_scripts` database table
  - No C++ code required for basic NPC behavior
  - Event-driven system (triggers → actions)
  - Used for: NPC dialogue, movement, emotes, quest triggers, etc.

**Example:**
```sql
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `event_type`, `action_type`, ...) VALUES
(31023, 0, 0, 1, 5, ...);  -- NPC 31023, periodic emote
```

#### 2. **ScriptedAI** - C++ Scripting
- **Location:** `src/server/game/AI/ScriptedAI/`
- **Type:** C++ class-based scripting
- **How it works:**
  - C++ classes that inherit from `ScriptedAI` or `CreatureScript`
  - Used for complex boss mechanics, instance scripts, etc.
  - More powerful but requires C++ knowledge

**Example:**
```cpp
class boss_arthas : public CreatureScript
{
    struct boss_arthasAI : public ScriptedAI
    {
        // Complex boss logic here
    };
};
```

---

## Key Differences

| Feature | ScriptDevAI | SmartAI | ScriptedAI |
|---------|-------------|---------|------------|
| **Used in AzerothCore?** | ❌ No | ✅ Yes | ✅ Yes |
| **Type** | C++ Framework | Database (SQL) | C++ Classes |
| **Complexity** | Medium | Low | High |
| **Best For** | N/A (legacy) | Simple NPC behavior | Complex mechanics |
| **Requires Recompile?** | Yes | No | Yes |
| **Database Changes?** | No | Yes | No |

---

## Why We Used ScriptDevAI Backup

The `mod-playerbots.backup/` folder contains **legacy ScriptDevAI scripts** from an older emulator. We used it as a **reference source** to find:
- NPC IDs (e.g., Brandon Eiredeck = 31023)
- Script structure patterns
- Event sequences

**We don't use ScriptDevAI directly** - we convert the information to SmartAI (SQL) scripts for AzerothCore.

---

## Current AzerothCore Approach

1. **SmartAI First** - Use SQL scripts for most NPC behavior
2. **ScriptedAI When Needed** - Use C++ for complex boss mechanics
3. **Modules** - Custom features in separate modules
4. **No ScriptDevAI** - Completely replaced by SmartAI

---

## Summary

- **ScriptDevAI:** Legacy system, not in AzerothCore
- **SmartAI:** AzerothCore's primary scripting system (SQL-based)
- **ScriptedAI:** AzerothCore's C++ scripting system (for complex mechanics)
- **Our use:** ScriptDevAI backup is only a reference for NPC IDs and patterns

---

**Last Updated:** 2025-01-23

