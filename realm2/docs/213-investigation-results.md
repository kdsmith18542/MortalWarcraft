# Investigation Results: Issues #16905 and #23830

**Date:** 2025-01-23  
**Method:** DBC files, Database queries, Online sources

---

## Issue #16905: Druid Berserk Energy Bug

### Investigation Steps

#### 1. Database Query
```bash
mysql -h127.0.0.1 -uroot -p realm2_world < tools/check_spell_50334.sql
```

**Expected Results:**
- `powerType` should be 3 (Energy) if spell uses energy
- `powerCost` or `powerCostPercentage` should be > 0 if it consumes energy
- Check `EffectItemType` fields for energy consumption effects

#### 2. DBC File Check
```bash
python3 tools/investigate_issues.py --issue 16905
```

**What to Look For:**
- PowerType = 3 (Energy)
- PowerCost > 0 or PowerCostPercentage > 0

#### 3. Wowhead Research
**URL:** https://www.wowhead.com/wotlk/spell=50334

**Check:**
1. **Spell Tooltip:**
   - Does it mention energy cost?
   - What does the description say?

2. **Comments Section:**
   - Search for "energy" in comments
   - Look for bug reports
   - Check for retail behavior discussions

3. **Spell Details:**
   - Check "How to get" section
   - Look at spell effects listed

**Example Search in Comments:**
- "energy"
- "cat form"
- "feral"
- "bug"

#### 4. Current Code Analysis
**File:** `realm2/azerothcore/src/server/scripts/Spells/spell_druid.cpp:1161-1190`

**Current Behavior:**
- Removes Tiger's Fury auras
- Resets Dire Bear Maul cooldown
- **Does NOT consume energy**

#### 5. Fix Determination

**If retail Berserk consumes all energy in cat form:**
```cpp
void HandleAfterCast()
{
    Unit* caster = GetCaster();
    
    if (caster->IsPlayer())
    {
        Player* player = caster->ToPlayer();
        
        // Consume all energy if in cat form (feral)
        if (player->GetShapeshiftForm() == FORM_CAT)
        {
            player->SetPower(POWER_ENERGY, 0);
        }
        
        // Existing code: remove Tiger's Fury, reset Maul cooldown
        // ...
    }
}
```

**If retail Berserk consumes fixed amount:**
- Check DBC/DB for `powerCost` value
- Use that value instead of setting to 0

---

## Issue #23830: Culling of Stratholme Wave Spawn Positions

### Investigation Steps

#### 1. Database Query
```bash
mysql -h127.0.0.1 -uroot -p realm2_world < tools/check_culling_spawns.sql
```

**What to Check:**
- Are there static creature spawns for wave NPCs?
- What are their coordinates?
- Do they match the hardcoded positions in code?

#### 2. Code Comparison
**File:** `realm2/azerothcore/src/server/scripts/Kalimdor/CavernsOfTime/CullingOfStratholme/culling_of_stratholme.cpp:191-241`

**Current Hardcoded Positions:**
```cpp
float WavesLocations[8][4][5] = {
    // Wave 0
    {NPC_RISEN_ZOMBIE, 2164.698975f, 1255.392944f, 135.040878f, 0.490202f},
    // ... etc
};
```

**Compare with:**
- Database spawn coordinates
- Retail behavior (YouTube/Wowhead)

#### 3. Wowhead Research
**URL:** https://www.wowhead.com/wotlk/zone=4100/culling-of-stratholme

**Check:**
1. **Zone Comments:**
   - Search for "wave", "spawn", "position"
   - Look for bug reports about spawns
   - Check for coordinate discussions

2. **NPC Pages:**
   - Visit pages for wave NPCs (27737, 28249, etc.)
   - Check "Spawns" section if available
   - Read comments about spawn locations

3. **Quest Guides:**
   - Look for Culling of Stratholme guides
   - They often show spawn locations

#### 4. YouTube Research
**Search Terms:**
- "Culling of Stratholme wave spawns"
- "Culling of Stratholme retail"
- "WoW WotLK Culling of Stratholme"

**What to Look For:**
- Where waves actually spawn
- Timing of spawns
- Number of mobs per wave
- Spawn positions relative to Arthas

**Screenshot/Note:**
- Pause video when waves spawn
- Note coordinates if visible
- Compare with our hardcoded positions

#### 5. Other Server Comparisons
**TrinityCore:**
- Check their `culling_of_stratholme.cpp`
- Compare `WavesLocations` array
- See if they have different coordinates

**Other Private Servers:**
- Check forums/Discords
- Look for coordinate discussions
- Compare implementations

#### 6. Fix Determination

**If positions are wrong:**
1. Collect correct coordinates from:
   - Database spawns (if they exist)
   - Wowhead comments
   - YouTube videos
   - Other server implementations

2. Update `WavesLocations` array with correct coordinates

3. Test in-game to verify

**If positions should be dynamic:**
- May need to change spawn logic
- Use database spawns instead of hardcoded
- Or calculate positions based on Arthas location

---

## Investigation Checklist

### For Issue #16905:
- [ ] Run database query (`check_spell_50334.sql`)
- [ ] Check DBC file (Spell.dbc for entry 50334)
- [ ] Visit Wowhead and read tooltip
- [ ] Search Wowhead comments for "energy"
- [ ] Check current code implementation
- [ ] Determine if energy should be consumed
- [ ] Implement fix if needed

### For Issue #23830:
- [ ] Run database query (`check_culling_spawns.sql`)
- [ ] Compare database spawns with hardcoded positions
- [ ] Visit Wowhead zone page
- [ ] Search Wowhead comments for "wave" or "spawn"
- [ ] Watch YouTube videos of retail Culling
- [ ] Check TrinityCore implementation
- [ ] Collect correct coordinates
- [ ] Update code with correct positions

---

## Tools Created

1. **`tools/investigate_issues.py`** - Automated investigation tool
2. **`tools/check_spell_50334.sql`** - SQL queries for Berserk
3. **`tools/check_culling_spawns.sql`** - SQL queries for Culling
4. **`docs/212-investigation-guide.md`** - Complete investigation guide

---

## Next Steps

1. **Run SQL queries** to get database data
2. **Check Wowhead** for both issues
3. **Watch YouTube** for Culling wave spawns
4. **Compare findings** with current code
5. **Implement fixes** based on evidence
6. **Test in-game** to verify

---

## Notes

- Database queries may need password adjustment
- DBC file structure may vary by client version
- Online sources provide retail reference
- Combine all sources for complete picture

