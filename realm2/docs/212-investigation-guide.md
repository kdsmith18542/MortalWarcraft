# Issue Investigation Guide: Using DBC, Database, and Online Sources

**Purpose:** Guide for investigating issues #16905 and #23830 using all available resources.

---

## Investigation Methods

### 1. DBC Files (Client Data)

**Location:** `azerothcore/data/dbc/`

**Relevant Files:**
- `Spell.dbc` - Spell definitions, power costs, effects
- `SpellEffect.dbc` - Spell effect details
- `CreatureDisplayInfo.dbc` - Creature model/display info
- `AreaTable.dbc` - Zone/area definitions

**Tools:**
- `tools/investigate_issues.py` - Python script to read DBC files
- `tools/find_dbc_ids.py` - Existing DBC ID finder

**For Issue #16905 (Berserk):**
```bash
python3 tools/investigate_issues.py --issue 16905
```
- Checks `Spell.dbc` for spell 50334
- Looks for `PowerType` (should be 3 for Energy)
- Checks `PowerCost` (should be > 0 if it consumes energy)

**For Issue #23830 (Culling):**
- DBC files don't contain spawn positions (those are in database)
- But can verify NPC entries exist in `CreatureDisplayInfo.dbc`

---

### 2. Database Queries

**Database:** `realm2_world` (or `azerothcore_world`)

**Relevant Tables:**
- `spell_template` - Spell definitions
- `creature` - Creature spawns
- `creature_template` - Creature definitions
- `gameobject` - GameObject spawns
- `smart_scripts` - SmartAI scripts

**For Issue #16905 (Berserk):**

```sql
-- Check spell definition
SELECT entry, name, powerType, powerCost, powerCostPercentage, powerPerSecond,
       Effect1, Effect2, Effect3, EffectItemType1, EffectItemType2, EffectItemType3
FROM spell_template
WHERE entry = 50334;

-- Check spell script
SELECT * FROM spell_script_names WHERE spell_id = 50334;

-- Check linked spells
SELECT * FROM spell_linked_spell WHERE spell_trigger = 50334;
```

**For Issue #23830 (Culling):**

```sql
-- Get all creature spawns in Culling of Stratholme (map 595)
SELECT c.id, c.id1, c.map, c.position_x, c.position_y, c.position_z, c.orientation,
       ct.name, ct.entry
FROM creature c
JOIN creature_template ct ON c.id1 = ct.entry
WHERE c.map = 595
ORDER BY c.position_x, c.position_y;

-- Check wave NPCs specifically
SELECT c.id, c.id1, c.position_x, c.position_y, c.position_z, ct.name
FROM creature c
JOIN creature_template ct ON c.id1 = ct.entry
WHERE c.map = 595
  AND c.id1 IN (27737, 28249, 28200, 28199, 27734, 28201, 27729, 27736)
ORDER BY c.id1, c.position_x;
```

**Using the Tool:**
```bash
python3 tools/investigate_issues.py --issue 16905 --db-name realm2_world
python3 tools/investigate_issues.py --issue 23830 --db-name realm2_world
```

---

### 3. Online Sources

#### A. Wowhead (Primary Source)

**For Issue #16905:**
- URL: https://www.wowhead.com/wotlk/spell=50334
- Check:
  - Spell tooltip (shows energy cost if any)
  - Comments section (players discuss bugs/behavior)
  - "How to get" section (shows spell details)

**For Issue #23830:**
- URL: https://www.wowhead.com/wotlk/zone=4100/culling-of-stratholme
- Check:
  - Zone comments (players discuss wave spawns)
  - NPC pages for wave creatures
  - Quest guides (often show spawn locations)

#### B. YouTube Videos

**Search Terms:**
- "Culling of Stratholme wave spawns"
- "Culling of Stratholme retail"
- "WoW WotLK Culling of Stratholme"

**What to Look For:**
- Where waves actually spawn
- Timing of spawns
- Number of mobs per wave
- Spawn positions relative to Arthas

#### C. Other Private Servers

**Sources:**
- TrinityCore GitHub (check their implementation)
- Other server forums/Discords
- Server comparison videos

**What to Check:**
- How they handle wave spawns
- If they use hardcoded positions or dynamic spawning
- Coordinate values if available

#### D. WoW Wiki/Fandom

**URLs:**
- https://wowpedia.fandom.com/wiki/Culling_of_Stratholme
- https://wowpedia.fandom.com/wiki/Berserk_(druid_ability)

**Information:**
- Historical data
- Patch notes (if behavior changed)
- Technical details

---

## Investigation Workflow

### For Issue #16905 (Druid Berserk)

1. **Check DBC File:**
   ```bash
   python3 tools/investigate_issues.py --issue 16905
   ```
   - Verify PowerType = 3 (Energy)
   - Check PowerCost value

2. **Check Database:**
   ```sql
   SELECT * FROM spell_template WHERE entry = 50334;
   ```
   - Compare with DBC data
   - Check effect types

3. **Check Wowhead:**
   - Visit: https://www.wowhead.com/wotlk/spell=50334
   - Read tooltip (does it mention energy cost?)
   - Read comments (do players mention energy bug?)

4. **Check Current Code:**
   - `realm2/azerothcore/src/server/scripts/Spells/spell_druid.cpp:1161-1190`
   - Does it consume energy? (No, currently doesn't)

5. **Determine Fix:**
   - If retail consumes all energy in cat form → Add energy consumption
   - If retail consumes fixed amount → Add fixed cost
   - If retail doesn't consume energy → Issue might be different

### For Issue #23830 (Culling Wave Spawns)

1. **Check Database Spawns:**
   ```sql
   SELECT * FROM creature WHERE map = 595 AND id1 IN (27737, 28249, ...);
   ```
   - Are there static spawns for wave NPCs?
   - What are their coordinates?

2. **Compare with Code:**
   - `culling_of_stratholme.cpp:191-241` (WavesLocations array)
   - Do coordinates match database spawns?
   - Are positions correct?

3. **Check Wowhead:**
   - Visit zone page and read comments
   - Look for discussions about wave spawns
   - Check NPC pages for spawn locations

4. **Watch YouTube:**
   - Find retail Culling runs
   - Note where waves spawn
   - Compare with our hardcoded positions

5. **Check Other Servers:**
   - TrinityCore implementation
   - Other private server code
   - Compare coordinate values

6. **Determine Fix:**
   - Update hardcoded coordinates if wrong
   - Or implement dynamic spawning if needed
   - Verify with retail behavior

---

## Tools and Scripts

### Main Investigation Tool
```bash
python3 tools/investigate_issues.py --issue <16905|23830> [--db-name <database>]
```

### Manual Database Queries
```bash
mysql -h127.0.0.1 -uroot -p realm2_world -e "SELECT ..."
```

### DBC File Reading
- Use `tools/investigate_issues.py` (has DBC reading functions)
- Or use existing `tools/find_dbc_ids.py` for creature/item lookups

---

## Expected Results

### Issue #16905
**If Berserk should consume energy:**
- DBC/DB: PowerType = 3, PowerCost > 0 (or PowerCostPercentage > 0)
- Wowhead: Tooltip mentions energy cost
- Comments: Players mention energy consumption

**Fix:** Add energy consumption in `spell_dru_berserk::HandleAfterCast()`

### Issue #23830
**If positions are wrong:**
- Database spawns don't match hardcoded coordinates
- Wowhead comments mention incorrect spawns
- YouTube shows different positions

**Fix:** Update `WavesLocations` array with correct coordinates

---

## Next Steps

1. Run investigation tool for both issues
2. Check Wowhead for each issue
3. Compare findings with current code
4. Implement fixes based on evidence
5. Test in-game to verify

---

## Notes

- DBC files are client-side data (from WoW client)
- Database is server-side data (our implementation)
- Online sources provide retail behavior reference
- Combine all three for complete picture

