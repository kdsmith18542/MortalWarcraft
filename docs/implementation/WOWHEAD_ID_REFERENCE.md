# Wowhead WotLK Database - ID Reference Guide

**URL:** https://www.wowhead.com/wotlk/database

---

## Why Wowhead is Useful

Wowhead's WotLK database is **essential** for finding accurate IDs for:
- **Spell IDs** - For spell scaling entries (`mortal_spell_scaling`)
- **Creature IDs** - For world boss mappings and NPC tier assignments
- **Item IDs** - For P-tier gear creation and vendor assignments
- **Quest IDs** - For custom quest integration
- **Achievement IDs** - For PvP vendor requirements

---

## How to Use Wowhead for Our Project

### 1. Finding Spell IDs for Spell Scaling

**Example: Lich King's Soul Reaper**
1. Go to: https://www.wowhead.com/wotlk/npc=36597/the-lich-king
2. Click on "Abilities" tab
3. Find "Soul Reaper" spell
4. Click the spell link → URL shows: `https://www.wowhead.com/wotlk/spell=69409`
5. **Spell ID = 69409** ✅

**Use for:**
```sql
INSERT INTO mortal_spell_scaling (spell_id, damage_scale, max_pct_hp, notes)
VALUES (69409, 0.25, 0.4, 'Soul Reaper (Lich King) scaled for Mortal');
```

### 2. Finding Creature IDs for World Bosses

**Example: Doom Lord Kazzak**
1. Search: "Doom Lord Kazzak"
2. URL: `https://www.wowhead.com/wotlk/npc=12397`
3. **Creature ID = 12397** ✅

**Use for:**
```sql
INSERT INTO mortal_creature_tier_map (creature_entry, mortal_tier_id, notes)
SELECT 12397, id, 'Doom Lord Kazzak - World Boss'
FROM mortal_creature_tiers WHERE code = 'WORLD_3';
```

### 3. Finding Item IDs for P-Tier Gear

**Example: PvP Gladiator Weapon**
1. Search: "Gladiator's Greatsword"
2. URL: `https://www.wowhead.com/wotlk/item=42527`
3. **Item ID = 42527** ✅

**Use for:**
```sql
INSERT INTO mortal_pvp_item_requirements 
(item_entry, rating_band_code, min_rating, bracket_mask, cost_tokens, cost_credits)
VALUES (42527, 'P5', 2100, 2, 2000, 500);
```

### 4. Finding Boss Ability Spell IDs

**Example: Lord Marrowgar's Bone Storm**
1. Go to: https://www.wowhead.com/wotlk/npc=36612/lord-marrowgar
2. Click "Abilities" tab
3. Find "Bone Storm" → `https://www.wowhead.com/wotlk/spell=69055`
4. **Spell ID = 69055** ✅

---

## Common Spell IDs We Need (From Spec)

Based on `docs/specs/32-npc-and-encounter-rebalance.md`:

| Boss | Spell Name | Spell ID | Notes |
|------|------------|----------|-------|
| Lich King | Soul Reaper | 69409 | Needs scaling |
| Lord Marrowgar (Heroic) | Quake | 72262 | Needs scaling |
| Doom Lord Kazzak | Shadow Bolt Volley | 25646 | Needs scaling |
| Lord Marrowgar | Bone Storm | 69055 | Needs scaling |
| Lord Marrowgar | Saber Lash | 69076 | Needs scaling |

**To find more:**
1. Search boss name on Wowhead
2. Check "Abilities" tab
3. Look for high-damage abilities that would one-shot in Mortal
4. Extract spell IDs from URLs

---

## World Boss Creature IDs

Common world bosses we need to map:

| Boss Name | Search Term | Expected ID Range |
|-----------|-------------|-------------------|
| Doom Lord Kazzak | "Doom Lord Kazzak" | ~12397 |
| Azuregos | "Azuregos" | ~6109 |
| Lord Kazzak | "Lord Kazzak" | ~18728 |
| Emeriss | "Emeriss" | ~14889 |
| Lethon | "Lethon" | ~14888 |
| Taerar | "Taerar" | ~14890 |
| Ysondre | "Ysondre" | ~14887 |

**To find:**
1. Search boss name
2. Check URL for NPC ID
3. Verify it's the correct version (WotLK, not Classic/Retail)

---

## P-Tier Gear Item IDs

For PvP vendor system, we need item IDs for:
- P1-P6 armor sets
- P1-P6 weapons
- PvP accessories

**Search pattern:**
- "Gladiator" for P1-P2 gear
- "Deadly Gladiator" for P3 gear
- "Furious Gladiator" for P4 gear
- "Relentless Gladiator" for P5 gear
- "Wrathful Gladiator" for P6 gear

**Example workflow:**
1. Search: "Wrathful Gladiator's Greatsword"
2. Get item ID from URL
3. Add to `mortal_pvp_item_requirements` with appropriate rating gates

---

## Tips for Using Wowhead

1. **Always use `/wotlk/` in URL** - Ensures WotLK 3.3.5a data
2. **Check "Abilities" tab for NPCs** - Shows all spells they cast
3. **Use "Comments" section** - Often has useful info about mechanics
4. **Check "Dropped by" for items** - Helps verify item sources
5. **Use filters** - Filter by expansion, level, etc.

---

## Automation Potential

While manual lookup works, you could also:
1. Use Wowhead's API (if available) for bulk lookups
2. Scrape spell lists from boss pages
3. Cross-reference with our existing creature_template data

**For now, manual lookup is recommended** for accuracy and to understand context.

---

## Example: Populating ICC Spell Scaling

**Workflow:**
1. Go to each ICC boss page on Wowhead
2. Check "Abilities" tab
3. Identify high-damage abilities
4. Extract spell IDs
5. Add to `mortal_spell_scaling` with appropriate scaling

**Example SQL:**
```sql
-- Lich King abilities
INSERT INTO mortal_spell_scaling (spell_id, damage_scale, max_pct_hp, notes) VALUES
(69409, 0.25, 0.4, 'Soul Reaper - Lich King'),
(72350, 0.3, 0.5, 'Fury of Frostmourne - Lich King'),
(72262, 0.3, 0.5, 'Quake - Marrowgar Heroic'),
(69055, 0.3, 0.5, 'Bone Storm - Marrowgar'),
(69076, 0.35, 0.6, 'Saber Lash - Marrowgar');
```

---

## Next Steps

1. **Spell Scaling Entries** - Use Wowhead to find all problematic boss abilities
2. **World Boss Mappings** - Find creature IDs for all world bosses
3. **P-Tier Gear** - Find item IDs for PvP vendor gear sets
4. **Achievement IDs** - Find achievement IDs for PvP vendor requirements

---

**Status:** ✅ **Recommended Tool** - Wowhead is the best resource for accurate WotLK 3.3.5a IDs

