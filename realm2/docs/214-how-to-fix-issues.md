# How to Fix Issues #16905 and #23830

**Using DBC Files, Database, and Online Sources**

---

## Quick Start

### For Issue #16905 (Druid Berserk):
1. Run: `mysql -h127.0.0.1 -uroot -p realm2_world < tools/check_spell_50334.sql`
2. Visit: https://www.wowhead.com/wotlk/spell=50334
3. Check comments for "energy" discussions
4. Compare with current code
5. Implement fix

### For Issue #23830 (Culling Wave Spawns):
1. Run: `mysql -h127.0.0.1 -uroot -p realm2_world < tools/check_culling_spawns.sql`
2. Visit: https://www.wowhead.com/wotlk/zone=4100/culling-of-stratholme
3. Watch YouTube: "Culling of Stratholme retail"
4. Compare coordinates with code
5. Update `WavesLocations` array

---

## Detailed Investigation Process

### Method 1: Database Queries

**Why:** Database contains our server's current implementation data.

**For #16905:**
```bash
# Check spell definition
mysql -h127.0.0.1 -uroot -p realm2_world -e "
SELECT entry, name, powerType, powerCost, powerCostPercentage 
FROM spell_template 
WHERE entry = 50334;"

# Check spell script
mysql -h127.0.0.1 -uroot -p realm2_world -e "
SELECT * FROM spell_script_names WHERE spell_id = 50334;"
```

**For #23830:**
```bash
# Check creature spawns in Culling
mysql -h127.0.0.1 -uroot -p realm2_world -e "
SELECT c.id1, ct.name, c.position_x, c.position_y, c.position_z
FROM creature c
JOIN creature_template ct ON c.id1 = ct.entry
WHERE c.map = 595
  AND c.id1 IN (27737, 28249, 28200, 28199, 27734, 28201, 27729, 27736)
ORDER BY c.id1;"
```

**What to Look For:**
- #16905: Does `powerType = 3` (Energy)? Does `powerCost > 0`?
- #23830: Do database spawns match hardcoded coordinates?

---

### Method 2: DBC Files (Client Data)

**Why:** DBC files contain retail client data - the "source of truth" for what spells/items should be.

**Location:** `azerothcore/data/dbc/`

**For #16905:**
```bash
# Use investigation tool
python3 tools/investigate_issues.py --issue 16905

# Or manually check Spell.dbc
# (requires DBC reading tool or hex editor)
```

**What to Check:**
- `Spell.dbc` entry 50334
- Field: PowerType (should be 3 for Energy)
- Field: PowerCost (should be > 0 if consumes energy)

**For #23830:**
- DBC files don't contain spawn positions
- But can verify NPC entries exist in `CreatureDisplayInfo.dbc`

---

### Method 3: Online Sources

#### A. Wowhead (Best Source)

**For #16905:**
1. Visit: https://www.wowhead.com/wotlk/spell=50334
2. **Read Tooltip:**
   - Does it mention energy cost?
   - What does description say?
3. **Read Comments:**
   - Search page for "energy" (Ctrl+F)
   - Look for bug reports
   - Check for retail behavior discussions
4. **Check Spell Details:**
   - Look at "How to get" section
   - Check spell effects listed

**For #23830:**
1. Visit: https://www.wowhead.com/wotlk/zone=4100/culling-of-stratholme
2. **Read Zone Comments:**
   - Search for "wave", "spawn", "position"
   - Look for bug reports
   - Check for coordinate discussions
3. **Check NPC Pages:**
   - Visit pages for wave NPCs:
     - https://www.wowhead.com/wotlk/npc=27737 (Risen Zombie)
     - https://www.wowhead.com/wotlk/npc=28249 (Devouring Ghoul)
     - etc.
   - Check "Spawns" section if available
   - Read comments about spawn locations

#### B. YouTube Videos

**For #23830:**
1. Search: "Culling of Stratholme retail" or "Culling of Stratholme wave spawns"
2. **Watch Retail Runs:**
   - Pause when waves spawn
   - Note spawn locations
   - Count mobs per wave
   - Compare with our hardcoded positions
3. **Take Screenshots:**
   - Save frames showing spawn positions
   - Note coordinates if visible in UI

**What to Look For:**
- Where waves actually spawn
- Timing of spawns
- Number of mobs per wave
- Spawn positions relative to Arthas

#### C. Other Private Servers

**TrinityCore:**
- GitHub: https://github.com/TrinityCore/TrinityCore
- File: `src/server/scripts/Kalimdor/CavernsOfTime/CullingOfStratholme/culling_of_stratholme.cpp`
- Compare `WavesLocations` array with ours

**Other Servers:**
- Check forums/Discords
- Look for coordinate discussions
- Compare implementations

---

## Fix Implementation

### Fix for #16905 (If Berserk Should Consume Energy)

**Step 1: Verify Behavior**
- Check Wowhead tooltip/comments
- Confirm it should consume energy in cat form

**Step 2: Implement Fix**
```cpp
// File: realm2/azerothcore/src/server/scripts/Spells/spell_druid.cpp
// Function: spell_dru_berserk::HandleAfterCast()

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
        const uint32 TigerFury[6] = { 5217, 6793, 9845, 9846, 50212, 50213 };
        const uint32 DireMaul[6] = { 33878, 33986, 33987, 48563, 48564 };
        
        for (auto& i : TigerFury)
            caster->RemoveAurasDueToSpell(i);
        
        for (auto& i : DireMaul)
            player->RemoveSpellCooldown(i, true);
    }
}
```

**Step 3: Test**
- Cast Berserk in cat form
- Verify energy is consumed
- Test in bear form (should not consume energy)

### Fix for #23830 (If Positions Are Wrong)

**Step 1: Collect Correct Coordinates**
- From database spawns (if they exist)
- From Wowhead comments
- From YouTube videos
- From TrinityCore/other servers

**Step 2: Update Code**
```cpp
// File: realm2/azerothcore/src/server/scripts/Kalimdor/CavernsOfTime/CullingOfStratholme/culling_of_stratholme.cpp
// Array: WavesLocations[8][4][5]

float WavesLocations[ENCOUNTER_WAVES_NUMBER][ENCOUNTER_WAVES_MAX_SPAWNS][5] =
{
    {
        // Wave 0 - Update with correct coordinates
        {NPC_RISEN_ZOMBIE, <correct_x>, <correct_y>, <correct_z>, <correct_o>},
        {NPC_RISEN_ZOMBIE, <correct_x>, <correct_y>, <correct_z>, <correct_o>},
        {NPC_DEVOURING_GHOUL, <correct_x>, <correct_y>, <correct_z>, <correct_o>},
        {NPC_DEVOURING_GHOUL, <correct_x>, <correct_y>, <correct_z>, <correct_o>}
    },
    // ... update all 8 waves
};
```

**Step 3: Test**
- Run Culling of Stratholme
- Verify waves spawn at correct positions
- Compare with retail behavior

---

## Investigation Checklist

### Issue #16905:
- [ ] Run `tools/check_spell_50334.sql`
- [ ] Check DBC file (Spell.dbc entry 50334)
- [ ] Visit Wowhead spell page
- [ ] Search comments for "energy"
- [ ] Check current code
- [ ] Determine if energy should be consumed
- [ ] Implement fix
- [ ] Test in-game

### Issue #23830:
- [ ] Run `tools/check_culling_spawns.sql`
- [ ] Compare database spawns with code
- [ ] Visit Wowhead zone page
- [ ] Search comments for "wave" or "spawn"
- [ ] Watch YouTube retail videos
- [ ] Check TrinityCore implementation
- [ ] Collect correct coordinates
- [ ] Update `WavesLocations` array
- [ ] Test in-game

---

## Tools Available

1. **`tools/investigate_issues.py`** - Automated investigation
2. **`tools/check_spell_50334.sql`** - SQL queries for Berserk
3. **`tools/check_culling_spawns.sql`** - SQL queries for Culling
4. **`docs/212-investigation-guide.md`** - Complete guide
5. **`docs/213-investigation-results.md`** - Expected results

---

## Summary

**Three Sources of Truth:**
1. **DBC Files** - Retail client data (what it should be)
2. **Database** - Our server data (what we have)
3. **Online Sources** - Community knowledge (what players know)

**Combine all three** to get complete picture and implement correct fix.

