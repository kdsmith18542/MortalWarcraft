# Reference Scripts Setup - Complete

**Date:** 2025-01-23  
**Status:** ✅ Setup Complete

---

## What Was Fetched

### 1. TrinityCore Scripts
- **Repository:** https://github.com/TrinityCore/TrinityCore
- **Location:** `tools/reference/trinitycore-scripts/`
- **Type:** ScriptedAI (C++ scripts compatible with AzerothCore)
- **Content:** Only `src/server/scripts/` directory (sparse checkout)
- **Use:** Reference for NPC IDs, AzerothCore-compatible patterns

### 2. CMaNGOS WotLK
- **Repository:** https://github.com/cmangos/mangos-wotlk
- **Location:** `tools/reference/cmangos-wotlk/`
- **Type:** ScriptDevAI (CMaNGOS scripting framework)
- **Content:** Full repository including ScriptDevAI
- **Use:** Historical reference, complete NPC definitions

---

## How to Use

### Finding NPC IDs

**Example: Find Brandon Eiredeck, Patricia O'Reilly, Stephanie Sindree**

**TrinityCore:**
```bash
cd tools/reference/trinitycore-scripts
grep -r "NPC_BRANDON\|NPC_PATRICIA\|NPC_STEPHANIE\|31023\|31028\|31019" src/server/scripts/
```

**CMaNGOS:**
```bash
cd tools/reference/cmangos-wotlk
grep -r "NPC_BRANDON\|NPC_PATRICIA\|NPC_STEPHANIE\|31023\|31028\|31019" src/game/AI/ScriptDevAI/scripts/
```

### Finding Culling of Stratholme Scripts

**TrinityCore:**
```bash
cd tools/reference/trinitycore-scripts
find src/server/scripts -path "*CullingOfStratholme*" -type f
```

**CMaNGOS:**
```bash
cd tools/reference/cmangos-wotlk
find . -path "*/ScriptDevAI/scripts/*culling*" -type f
```

---

## Updating

### Update TrinityCore Scripts
```bash
cd tools/reference/trinitycore-scripts
git pull origin master
```

### Update CMaNGOS WotLK
```bash
cd tools/reference/cmangos-wotlk
git pull origin master
```

**Recommendation:** Update quarterly or when researching new issues

---

## Benefits

1. **More NPC IDs** - Both sources have extensive NPC definitions
2. **Script Patterns** - Understand event sequences and logic
3. **Issue Research** - Find missing NPCs/events quickly
4. **Historical Reference** - Original implementations
5. **Compatibility** - TrinityCore scripts are compatible with AzerothCore

---

## Verification Results

### ✅ Both Sources Successfully Cloned

**TrinityCore Scripts:**
- Location: `tools/reference/trinitycore-scripts/`
- Size: ~517MB (sparse checkout of scripts only)
- Culling of Stratholme: ✅ Found (6 files)
- NPC IDs: Contains NPC_STEPHANIE_SINDREE (31019), NPC_PATRICIA_O_REILLY (31028)

**CMaNGOS WotLK:**
- Location: `tools/reference/cmangos-wotlk/`
- Size: ~197MB (full repository)
- ScriptDevAI: ✅ Found at `src/game/AI/ScriptDevAI/`
- Culling of Stratholme: ✅ Found (3 files)
- NPC IDs: Contains comprehensive list including:
  - NPC_STEPHANIE_SINDREE = 31019
  - NPC_PATRICIA_O_REILLY = 31028
  - NPC_MAGISTRATE_BARTHILAS = 30994
  - NPC_AGIATED_STRATHOLME_CITIZEN = 31126
  - NPC_AGIATED_STRATHOLME_RESIDENT = 31127
  - And many more we've been using

### Example: Finding NPC IDs

**CMaNGOS has more complete NPC definitions:**
```cpp
// From cmangos-wotlk/culling_of_stratholme.h
NPC_STEPHANIE_SINDREE           = 31019,
NPC_PATRICIA_O_REILLY           = 31028,
NPC_MAGISTRATE_BARTHILAS        = 30994,
NPC_AGIATED_STRATHOLME_CITIZEN  = 31126,
NPC_AGIATED_STRATHOLME_RESIDENT = 31127,
```

**TrinityCore has compatible script patterns:**
- Uses ScriptedAI (same as AzerothCore)
- Better for understanding AzerothCore-compatible implementations

---

## Next Steps

1. ✅ **Test searches** - Verified both sources have Culling of Stratholme scripts
2. ✅ **Compare sources** - CMaNGOS has more complete NPC IDs, TrinityCore has better compatibility
3. **Document findings** - This document
4. **Update tools** - Consider enhancing `find_dbc_ids.py` to search these references

---

**Last Updated:** 2025-01-23

