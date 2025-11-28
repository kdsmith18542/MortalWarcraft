# ScriptDevAI Reference - Recommendation

**Date:** 2025-01-23

---

## Answer: ScriptDevAI is from CMaNGOS, NOT TrinityCore

**ScriptDevAI Origin:**
- **Original:** MaNGOS project
- **Current Maintainer:** CMaNGOS (http://www.cmangos.net)
- **TrinityCore:** Used it initially, then replaced with SmartAI

---

## Should We Get an Updated Copy?

**YES - For Reference Purposes**

### Why:
1. **NPC IDs** - More complete NPC definitions
2. **Script Patterns** - Better understanding of event sequences
3. **Issue Research** - Helps us find missing NPCs/events
4. **Historical Reference** - Useful for understanding original implementations

### Where to Get It:
1. **CMaNGOS ScriptDevAI** (Original source)
   - Repository: Likely `https://github.com/cmangos/scriptdev2` or integrated in CMaNGOS core
   - Still maintained by CMaNGOS
   - Most complete reference

2. **TrinityCore Scripts** (Alternative)
   - Repository: `https://github.com/TrinityCore/TrinityCore` (scripts directory)
   - Uses ScriptedAI (compatible with AzerothCore)
   - May have more up-to-date NPC IDs
   - Better compatibility with our codebase

### Recommendation:
**Fetch BOTH for maximum reference coverage:**
1. **CMaNGOS ScriptDevAI** - For complete historical reference
2. **TrinityCore Scripts** - For AzerothCore-compatible patterns

---

## Implementation Plan

### Option 1: Fetch CMaNGOS ScriptDevAI
```bash
# Clone to reference directory
cd tools/reference/
git clone https://github.com/cmangos/scriptdev2.git scriptdevai-cmangos
# Or if integrated:
git clone https://github.com/cmangos/mangos-wotlk.git cmangos-wotlk
```

### Option 2: Fetch TrinityCore Scripts
```bash
# Clone TrinityCore scripts only
cd tools/reference/
git clone --depth 1 --filter=blob:none --sparse https://github.com/TrinityCore/TrinityCore.git trinitycore-scripts
cd trinitycore-scripts
git sparse-checkout set src/server/scripts
```

### Option 3: Both (Recommended)
- Keep both for maximum coverage
- Use CMaNGOS for historical reference
- Use TrinityCore for AzerothCore-compatible patterns

---

## Usage Strategy

1. **Keep as Reference Only** - Don't integrate into build
2. **Extract Information** - Use for NPC IDs, patterns, event sequences
3. **Convert to SmartAI** - Translate findings to SmartAI scripts
4. **Update Periodically** - Refresh quarterly or when needed

---

## Current Status

- **What we have:** CMaNGOS ScriptDevAI backup (older version)
- **What we need:** Updated CMaNGOS ScriptDevAI + TrinityCore scripts
- **Purpose:** Reference for NPC IDs and script patterns
- **Integration:** None - reference only

---

**Last Updated:** 2025-01-23

