# ScriptDevAI Reference Strategy

**Date:** 2025-01-23  
**Purpose:** Determine if we should fetch an updated ScriptDevAI copy for reference

---

## ScriptDevAI Origin

**ScriptDevAI (ScriptDev2/SD2)** is **NOT from TrinityCore**:
- **Origin:** MaNGOS/CMaNGOS project
- **Current Maintainer:** CMaNGOS (http://www.cmangos.net)
- **Status:** Still maintained by CMaNGOS, but **not used** in TrinityCore/AzerothCore

**TrinityCore History:**
- TrinityCore initially used ScriptDevAI
- Replaced it with **SmartAI** (SmartScripts)
- No longer maintains or uses ScriptDevAI

---

## Current Situation

### What We Have
- **Location:** `mod-playerbots.backup/src/game/AI/ScriptDevAI/`
- **Source:** CMaNGOS-based backup (likely from an older version)
- **Use:** Reference only - we extract NPC IDs and script patterns

### What We Use It For
1. **NPC IDs** - Finding NPC entry IDs (e.g., Brandon Eiredeck = 31023)
2. **Script Patterns** - Understanding event sequences and logic
3. **NPC Relationships** - Which NPCs interact with each other
4. **Event Structure** - How events are organized in dungeons

---

## Should We Fetch an Updated Copy?

### Pros of Getting Updated CMaNGOS ScriptDevAI:
1. **More NPC IDs** - Newer scripts may have more NPCs defined
2. **More Complete Scripts** - More dungeons/raids fully scripted
3. **Better Reference** - More accurate data for our fixes
4. **Bug Fixes** - CMaNGOS may have fixed issues in their scripts

### Cons:
1. **Not Actively Used** - We don't compile/run ScriptDevAI
2. **Reference Only** - We convert to SmartAI anyway
3. **Storage** - Takes up space (though not critical)
4. **Maintenance** - Need to update periodically

---

## Recommendation

**YES - Fetch Updated Copy for Reference**

### Strategy:
1. **Fetch CMaNGOS ScriptDevAI** as a reference repository
2. **Store separately** from our codebase (e.g., `tools/reference/scriptdevai/`)
3. **Use for:**
   - NPC ID lookups
   - Script pattern reference
   - Event sequence understanding
4. **Don't integrate** - Keep it as reference only
5. **Update periodically** - Maybe quarterly or when we need new data

### Implementation:
- Clone CMaNGOS ScriptDevAI repo to `tools/reference/scriptdevai/`
- Use it like we use the backup - for information extraction only
- Document which version we're using for reference

---

## CMaNGOS ScriptDevAI Repository

**Likely Location:**
- CMaNGOS GitHub: `https://github.com/cmangos/scriptdev2` (or similar)
- May be integrated into CMaNGOS core repo

**What to Fetch:**
- Script files (`.cpp`, `.h`) from `scripts/` directory
- Focus on WotLK scripts (Kalimdor, Eastern Kingdoms, Northrend, Outland)
- NPC definitions in header files

---

## Alternative: TrinityCore Scripts

**Note:** TrinityCore also has C++ scripts (not ScriptDevAI, but similar structure):
- Location: `TrinityCore/src/server/scripts/`
- These are **ScriptedAI** scripts (AzerothCore compatible)
- May have more up-to-date NPC IDs and patterns
- **Better option** since it's compatible with AzerothCore

**Recommendation:** Consider fetching TrinityCore scripts as reference instead:
- More compatible with AzerothCore
- Actively maintained
- Similar structure to what we use

---

## Next Steps

1. **Research CMaNGOS ScriptDevAI repo** - Find exact location
2. **Research TrinityCore scripts** - Check if they have better reference data
3. **Compare** - Which has more complete NPC IDs and script patterns?
4. **Fetch best option** - Clone to `tools/reference/`
5. **Document** - Update this doc with what we fetched and why

---

**Last Updated:** 2025-01-23

