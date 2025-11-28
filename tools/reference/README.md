# Reference Scripts Repository

**Purpose:** Reference sources for NPC IDs, script patterns, and event sequences

---

## Contents

### 1. TrinityCore Scripts
**Location:** `trinitycore-scripts/`  
**Source:** https://github.com/TrinityCore/TrinityCore  
**Type:** ScriptedAI (C++ scripts compatible with AzerothCore)  
**Use:** Reference for NPC IDs, script patterns, AzerothCore-compatible implementations

### 2. CMaNGOS WotLK
**Location:** `cmangos-wotlk/`  
**Source:** https://github.com/cmangos/mangos-wotlk  
**Type:** ScriptDevAI (CMaNGOS scripting framework)  
**Use:** Historical reference, complete NPC definitions, original script implementations

---

## Usage

### Finding NPC IDs

**TrinityCore:**
```bash
cd trinitycore-scripts
grep -r "NPC_BRANDON\|NPC_PATRICIA\|NPC_STEPHANIE" src/server/scripts/
```

**CMaNGOS:**
```bash
cd cmangos-wotlk
grep -r "NPC_BRANDON\|NPC_PATRICIA\|NPC_STEPHANIE" src/game/AI/ScriptDevAI/scripts/
```

### Finding Script Patterns

**TrinityCore:**
```bash
cd trinitycore-scripts
find src/server/scripts -name "*culling*" -type f
```

**CMaNGOS:**
```bash
cd cmangos-wotlk
find . -path "*/ScriptDevAI/scripts/*culling*" -type f
```

---

## Updating

### TrinityCore Scripts
```bash
cd trinitycore-scripts
git pull origin master
```

### CMaNGOS WotLK
```bash
cd cmangos-wotlk
git pull origin master
```

**Recommendation:** Update quarterly or when researching new issues

---

## Notes

- **Reference Only** - Do not integrate into build
- **Extract Information** - Use for NPC IDs, patterns, event sequences
- **Convert to SmartAI** - Translate findings to SmartAI scripts for AzerothCore
- **Both Sources** - Use TrinityCore for compatibility, CMaNGOS for completeness

---

**Last Updated:** 2025-01-23

