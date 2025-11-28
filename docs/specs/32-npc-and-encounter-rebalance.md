# Project Canvas: Mortal Warcraft Overhaul
### Version 26.8 — Hybrid Technical Design Document  
### File: 32-npc-and-encounter-rebalance.md  
### Section: NPC & Encounter Rebalance (Mortal Stat Curve + ICC/Lich King Strategy)

---

## Related Specs

- `19-itemization.md` - Mortal gear tiers and loot tables referenced in creature tier mapping
- `84-mortal-core-stats-and-combat-model.md` - Core stat system that NPCs are scaled to match
- `33-instance-and-battleground-tier-mapping.md` - Dungeon and raid tier mapping that integrates with creature tiers
- `06-pve.md` - PvE content types and encounter design
- `74-cursed-artifacts-and-extraction-system.md` - Cursed Artifacts from ICC Heroic and extraction mechanics
- `02-combat.md` - Combat formulas and damage scaling
- `64-spell-and-ability-library.md` - Spell system that spell scaling integrates with

---

## 1. Purpose

This spec defines a **small, focused “compatibility layer”** between:

- Original WotLK NPCs/encounters, and  
- Mortal Warcraft’s **flattened level curve**, **attribute caps**, and **custom gear tiers**.

Goals:

1. Provide a **data-driven way** to rescale NPC stats and ability damage to Mortal’s power band.
2. Avoid breaking most existing scripts (especially raids).
3. Clarify how we treat **iconic raids like Icecrown Citadel (ICC) and the Lich King**:
   - Keep the *encounter beats* intact.
   - Integrate Mortal itemization and difficulty.

---

## 2. Design: Two-Tier Strategy for ICC / Lich King

Because ICC is sacred ground for a lot of OG WoW players, but we’re also building a new game, we’ll use a **dual-focus approach**:

### 2.1 ICC Normal – “Legacy-Feeling, Mortal-Tuned”

- **Keep**:
  - Original encounter flow:
    - Phase structure, RP events, transitions, val’kyr grabs, Defile, etc.
  - Instance structure and map IDs.
- **Change**:
  - NPC stats to Mortal power band (via the system in this doc).
  - Loot tables to drop **Mortal PvE tiers** (e.g., M-T3 / M-T4).
  - Entry gating to:
    - Require Mortal Raid Sigils, skill-based checks, etc.

This becomes:

> The “story/PvE pinnacle” that feels like ICC, but with Mortal’s stats and progression.

### 2.2 ICC Heroic – “Mortalized Arthas”

- **Leans hard into Mortal systems**:
  - Harsher fail states (e.g., higher durability loss on wipes, special cursed drops).
  - Possible **extraction-style** twist for final wing rewards:
    - Cursed Artifacts must be carried out.
  - Tighter tuning for groups built around Mortal tiers.
- Still **preserves the recognizable LK fight**, but:
  - Damage numbers, enrage timers, mechanics punishing sloppy play are tuned for Mortal’s lower HP / higher risk.

In other words:

- We **do not** keep a 1:1 WotLK numeric experience (that’s impossible with Mortal caps).
- We **do** keep the narrative + mechanical skeleton, while Mortalizing the stats and itemization.

---

## 3. Mortal Creature Tiers

We introduce a **tier system** for NPCs and encounters.

### 3.1 Table: mortal_creature_tiers

```sql
CREATE TABLE IF NOT EXISTS mortal_creature_tiers (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  code                  VARCHAR(32) NOT NULL,  -- e.g. 'TRASH_T1', 'BOSS_T3', 'WORLD_3', 'RAID_ICC_HC'
  description           VARCHAR(255) NOT NULL,

  -- Stat scaling factors (relative to original creature_template)
  hp_scale              FLOAT NOT NULL DEFAULT 1.0,
  damage_scale          FLOAT NOT NULL DEFAULT 1.0,
  armor_scale           FLOAT NOT NULL DEFAULT 1.0,
  resist_scale          FLOAT NOT NULL DEFAULT 1.0,

  -- Optional caps / tuning hints
  max_hp_override       INT NULL,    -- if set, clamp HP to this after scaling
  max_damage_override   INT NULL,    -- clamp average melee hit to this
  loot_tier_hint        VARCHAR(16) NULL,  -- 'M-T2','M-T3','M-T4', etc.

  UNIQUE KEY uk_code (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

Examples:

| code          | description                     | hp_scale | dmg_scale | loot_tier_hint |
|---------------|---------------------------------|----------|-----------|----------------|
| TRASH_T1      | Early dungeon trash             | 0.25     | 0.25      | M-T1           |
| BOSS_T1       | Early dungeon bosses            | 0.3      | 0.3       | M-T1           |
| TRASH_T3      | Late heroic trash               | 0.35     | 0.35      | M-T3           |
| BOSS_T3       | Late heroic bosses              | 0.4      | 0.4       | M-T3           |
| WORLD_3       | High-tier world bosses          | 0.4      | 0.45      | M-T4           |
| RAID_ICC_N    | ICC Normal raid bosses          | 0.4      | 0.4       | M-T4           |
| RAID_ICC_H    | ICC Heroic raid bosses          | 0.5      | 0.55      | M-T5           |

Values are **relative multipliers** against original WotLK stats and can be tuned by playtesting.

---

## 4. Mapping Creatures to Mortal Tiers

We don’t want to edit `creature_template` schema directly if we can avoid it. Instead we use a mapping table:

### 4.1 Table: mortal_creature_tier_map

```sql
CREATE TABLE IF NOT EXISTS mortal_creature_tier_map (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  creature_entry        INT NOT NULL,         -- creature_template.entry
  mortal_tier_id        INT NOT NULL,         -- mortal_creature_tiers.id
  notes                 VARCHAR(255) NULL,
  UNIQUE KEY uk_creature (creature_entry),
  INDEX idx_tier (mortal_tier_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

We then populate it using SQL, grouping by dungeon/raid:

- All "normal" trash in a T1 heroic → `TRASH_T3`.
- All bosses in that heroic → `BOSS_T3`.
- ICC bosses → `RAID_ICC_N` or `RAID_ICC_H` depending on mode/entry.

If ICC uses separate entries for Heroic (as WotLK does in some cases), we map those to `RAID_ICC_H`.

### 4.2 Complete NPC Mapping Strategy

To systematically map all WoW 3.3.5a NPCs to Mortal tiers, we use a **bulk mapping approach** based on creature characteristics:

#### Mapping by Creature Rank

| WoW Rank | Mortal Tier Code | HP Scale | Damage Scale | Loot Tier | Notes |
|----------|------------------|----------|--------------|-----------|-------|
| Normal (0) | `TRASH_T1` to `TRASH_T3` | 0.25-0.35 | 0.25-0.35 | M-T1 to M-T3 | Based on zone/dungeon tier |
| Elite (1) | `ELITE_T1` to `ELITE_T3` | 0.3-0.4 | 0.3-0.4 | M-T1 to M-T3 | Based on zone/dungeon tier |
| Rare Elite (2) | `RARE_T2` to `RARE_T3` | 0.35-0.45 | 0.35-0.45 | M-T2 to M-T3 | Rare spawns |
| Boss (3) | `BOSS_T1` to `BOSS_T5` | 0.3-0.55 | 0.3-0.55 | M-T1 to M-T5 | Based on dungeon/raid tier |
| Rare (4) | `RARE_T1` to `RARE_T3` | 0.3-0.4 | 0.3-0.4 | M-T1 to M-T3 | Rare spawns |

#### Mapping by Zone/Dungeon Tier

**Green Zones (Starting Areas):**
- Normal creatures → `TRASH_T1` (hp_scale: 0.25, dmg_scale: 0.25)
- Elite creatures → `ELITE_T1` (hp_scale: 0.3, dmg_scale: 0.3)
- Bosses → `BOSS_T1` (hp_scale: 0.3, dmg_scale: 0.3)

**Yellow Zones (Mid-Game):**
- Normal creatures → `TRASH_T2` (hp_scale: 0.3, dmg_scale: 0.3)
- Elite creatures → `ELITE_T2` (hp_scale: 0.35, dmg_scale: 0.35)
- Bosses → `BOSS_T2` (hp_scale: 0.35, dmg_scale: 0.35)

**Red Zones (End-Game):**
- Normal creatures → `TRASH_T3` (hp_scale: 0.35, dmg_scale: 0.35)
- Elite creatures → `ELITE_T3` (hp_scale: 0.4, dmg_scale: 0.4)
- Bosses → `BOSS_T3` (hp_scale: 0.4, dmg_scale: 0.4)

#### Mapping by Dungeon/Raid Tier

**M-T1 Dungeons (Early):**
- Trash → `TRASH_T1` (hp_scale: 0.25, dmg_scale: 0.25)
- Bosses → `BOSS_T1` (hp_scale: 0.3, dmg_scale: 0.3)

**M-T2 Dungeons (Mid-Game):**
- Trash → `TRASH_T2` (hp_scale: 0.3, dmg_scale: 0.3)
- Bosses → `BOSS_T2` (hp_scale: 0.35, dmg_scale: 0.35)

**M-T3 Dungeons (Late-Game):**
- Trash → `TRASH_T3` (hp_scale: 0.35, dmg_scale: 0.35)
- Bosses → `BOSS_T3` (hp_scale: 0.4, dmg_scale: 0.4)

**M-T4 Raids (End-Game):**
- Trash → `TRASH_T4` (hp_scale: 0.4, dmg_scale: 0.4)
- Bosses → `BOSS_T4` (hp_scale: 0.45, dmg_scale: 0.45)

**M-T5 Raids (Pinnacle):**
- Trash → `TRASH_T5` (hp_scale: 0.45, dmg_scale: 0.45)
- Bosses → `BOSS_T5` (hp_scale: 0.5, dmg_scale: 0.55)

#### Bulk Mapping SQL Examples

**Map all creatures in a zone by rank:**

```sql
-- Map all Normal creatures in Elwynn Forest (zone 12) to TRASH_T1
INSERT INTO mortal_creature_tier_map (creature_entry, mortal_tier_id)
SELECT ct.entry, (SELECT id FROM mortal_creature_tiers WHERE code = 'TRASH_T1')
FROM creature_template ct
JOIN creature c ON ct.entry = c.id
WHERE c.zone = 12 AND ct.rank = 0;

-- Map all Elite creatures in Westfall (zone 40) to ELITE_T1
INSERT INTO mortal_creature_tier_map (creature_entry, mortal_tier_id)
SELECT ct.entry, (SELECT id FROM mortal_creature_tiers WHERE code = 'ELITE_T1')
FROM creature_template ct
JOIN creature c ON ct.entry = c.id
WHERE c.zone = 40 AND ct.rank = 1;
```

**Map all creatures in a dungeon:**

```sql
-- Map all creatures in Deadmines (map 36) to M-T1 tiers
INSERT INTO mortal_creature_tier_map (creature_entry, mortal_tier_id)
SELECT ct.entry, 
  CASE 
    WHEN ct.rank = 0 THEN (SELECT id FROM mortal_creature_tiers WHERE code = 'TRASH_T1')
    WHEN ct.rank = 1 THEN (SELECT id FROM mortal_creature_tiers WHERE code = 'ELITE_T1')
    WHEN ct.rank = 3 THEN (SELECT id FROM mortal_creature_tiers WHERE code = 'BOSS_T1')
    ELSE (SELECT id FROM mortal_creature_tiers WHERE code = 'TRASH_T1')
  END
FROM creature_template ct
JOIN creature c ON ct.entry = c.id
WHERE c.map = 36;
```

**Map all world bosses:**

```sql
-- Map all world bosses to WORLD_3 tier
INSERT INTO mortal_creature_tier_map (creature_entry, mortal_tier_id)
SELECT ct.entry, (SELECT id FROM mortal_creature_tiers WHERE code = 'WORLD_3')
FROM creature_template ct
WHERE ct.rank = 3 AND ct.type_flags & 0x00000001 = 0; -- World boss flag check
```

#### Special Cases

**Rare Spawns:**
- Rare (rank 4) → `RARE_T1` to `RARE_T3` (based on zone tier)
- Rare Elite (rank 2) → `RARE_T2` to `RARE_T3` (based on zone tier)

**Quest NPCs:**
- Quest givers → No scaling (non-combat)
- Quest objectives → Use zone/dungeon tier mapping

**Guards:**
- City guards → `GUARD_T1` (hp_scale: 0.5, dmg_scale: 0.5, invincible)
- Zone guards → `GUARD_T2` (hp_scale: 0.4, dmg_scale: 0.4, high threat)

**Vendors/Trainers:**
- No scaling (non-combat NPCs)

### 4.3 Mapping Progress Tracking

To track mapping progress, use:

```sql
-- Count total creatures
SELECT COUNT(*) as total_creatures FROM creature_template;

-- Count mapped creatures
SELECT COUNT(*) as mapped_creatures FROM mortal_creature_tier_map;

-- Count unmapped creatures
SELECT COUNT(*) as unmapped_creatures 
FROM creature_template ct
LEFT JOIN mortal_creature_tier_map mctm ON ct.entry = mctm.creature_entry
WHERE mctm.creature_entry IS NULL AND ct.rank IN (0, 1, 2, 3, 4);
```

**Target:** Map all combat NPCs (ranks 0-4) to Mortal tiers. Non-combat NPCs (vendors, trainers, quest givers) do not need mapping.

---

## 5. Runtime Scaling Hook (C++ Concept)

We add a hook that normalizes creatures **on spawn**:

Pseudo C++:

```cpp
void MortalNormalizeCreature(Creature* creature)
{
    uint32 entry = creature->GetEntry();

    // Look up Mortal tier for this creature
    auto tierInfo = MortalTierManager::GetTierForCreature(entry);
    if (!tierInfo)
        return; // no special scaling, leave original

    // Base stats from template
    auto const* tmpl = creature->GetCreatureTemplate();
    if (!tmpl)
        return;

    // Scale HP
    float baseHp = tmpl->MaxLevelHealth;
    float scaledHp = baseHp * tierInfo->hp_scale;
    if (tierInfo->max_hp_override > 0 && scaledHp > tierInfo->max_hp_override)
        scaledHp = float(tierInfo->max_hp_override);

    creature->SetMaxHealth((uint32)scaledHp);
    creature->SetHealth((uint32)scaledHp);

    // Scale melee damage
    float baseMinDmg = tmpl->mindmg;
    float baseMaxDmg = tmpl->maxdmg;

    float scaledMinDmg = baseMinDmg * tierInfo->damage_scale;
    float scaledMaxDmg = baseMaxDmg * tierInfo->damage_scale;

    if (tierInfo->max_damage_override > 0)
    {
        float avg = (scaledMinDmg + scaledMaxDmg) / 2.0f;
        if (avg > tierInfo->max_damage_override)
        {
            float factor = float(tierInfo->max_damage_override) / avg;
            scaledMinDmg *= factor;
            scaledMaxDmg *= factor;
        }
    }

    creature->SetBaseWeaponDamage(BASE_ATTACK, MINDAMAGE, scaledMinDmg);
    creature->SetBaseWeaponDamage(BASE_ATTACK, MAXDAMAGE, scaledMaxDmg);

    // Scale armor/resists if desired
    uint32 armor = uint32(float(tmpl->armor) * tierInfo->armor_scale);
    creature->SetArmor(armor);
}
```

Call this from:

- `Creature::InitStatsForLevel` or a similar `OnSpawn`-type hook.
- Ensure it runs **after** standard initialization but before combat.

This gives you a single point where all NPC stats are pulled into the Mortal band.

---

## 6. Spell & Ability Scaling

We want to keep original spell IDs for scripting but **scale the damage**.

### 6.1 Table: mortal_spell_scaling

```sql
CREATE TABLE IF NOT EXISTS mortal_spell_scaling (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  spell_id        INT NOT NULL,
  damage_scale    FLOAT NOT NULL DEFAULT 1.0,   -- multiply original damage by this
  max_pct_hp      FLOAT NULL,                  -- cap at % of target max HP
  notes           VARCHAR(255) NULL,
  UNIQUE KEY uk_spell (spell_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

Examples:

| spell_id | damage_scale | max_pct_hp | notes                          |
|----------|--------------|------------|--------------------------------|
| 69409    | 0.25         | 0.4        | Soul Reaper (LK)               |
| 72262    | 0.3          | 0.5        | Quake (Marrowgar heroic)       |
| 25646    | 0.35         | 0.5        | Kazzak Shadow Bolt Volley      |

At runtime, you intercept spell damage application (or use an aura hook) and:

1. Look up `spell_id` in `mortal_spell_scaling`.
2. Multiply base damage by `damage_scale`.
3. If `max_pct_hp` is set:
   - Clamp final damage to `target->GetMaxHealth() * max_pct_hp`.

This keeps big, scary abilities scary **relative to Mortal HP** without nuking entire raids.

---

## 7. Examples

### 7.1 World Boss Example – Kazzak

- Map Kazzak’s entry to Mortal tier:

```sql
INSERT INTO mortal_creature_tiers (code, description, hp_scale, damage_scale, loot_tier_hint)
VALUES ('WORLD_3', 'High-tier world boss for Mortal', 0.4, 0.45, 'M-T4');

INSERT INTO mortal_creature_tier_map (creature_entry, mortal_tier_id)
SELECT 12397, id FROM mortal_creature_tiers WHERE code = 'WORLD_3'; -- 12397 = Doom Lord Kazzak (example)
```

- Add spell scaling:

```sql
INSERT INTO mortal_spell_scaling (spell_id, damage_scale, max_pct_hp, notes)
VALUES (32960, 0.35, 0.50, 'Kazzak Shadow Bolt Volley scaled for Mortal');
```

Result:

- Kazzak uses his original AI & spells,  
- But HP/damage are in the Mortal range, and Shadow Bolt Volley now does at most 50% of a Mortal tank’s HP per hit instead of a full oneshot.

### 7.2 ICC Boss Example – Lord Marrowgar (Normal)

- Map to ICC Normal tier:

```sql
INSERT INTO mortal_creature_tiers (code, description, hp_scale, damage_scale, loot_tier_hint)
VALUES ('RAID_ICC_N', 'ICC Normal raid bosses (Mortal)', 0.4, 0.4, 'M-T4');

INSERT INTO mortal_creature_tier_map (creature_entry, mortal_tier_id)
SELECT 36612, id FROM mortal_creature_tiers WHERE code = 'RAID_ICC_N'; -- 36612 = Lord Marrowgar
```

- Scale key spells:

```sql
INSERT INTO mortal_spell_scaling (spell_id, damage_scale, max_pct_hp, notes)
VALUES
  (69055, 0.3, 0.5, 'Bone Storm ticks scaled for Mortal'),
  (69076, 0.35, 0.6, 'Saber Lash scaled for Mortal');
```

Result:

- Marrowgar still does:
  - Bone Storm.
  - Saber Lash.
  - Bone Spike Graveyard.
- But his numbers are grounded in the Mortal stats, and you can tune to desired difficulty without modifying encounter logic.

---

## 8. Workflow Summary

1. **Define tiers** in `mortal_creature_tiers`:
   - For dungeons, raids, world bosses.

2. **Map creatures** via `mortal_creature_tier_map`:
   - By dungeon/raid/world boss.

3. **Implement `MortalNormalizeCreature`**:
   - Apply scaling on spawn using tier data.

4. **Fill `mortal_spell_scaling`**:
   - For problematic/big-hit spells (especially in ICC and world bosses).

5. **Tune ICC Normal & Heroic**:
   - ICC Normal → `RAID_ICC_N` tier + moderate spell scaling.
   - ICC Heroic → `RAID_ICC_H` tier + more punishing numbers & Mortal-flavored extras (cursed loot, extraction hooks).

---

## 9. ICC / Lich King Decision – Final Position

- **We do not ship a “pure vanilla ICC”** inside Mortal, because:
  - Stats, HP, and class power are fundamentally different.
- **We do ship:**
  - **ICC Normal** as a **Mortal-tuned, legacy-feeling raid**:
    - Original encounter scripting kept.
    - Numbers and loot are Mortal.
  - **ICC Heroic** as a **Mortal endgame raid**:
    - Harder tuning via the tier system and spell scaling.
    - Optional extra Mortal mechanics (extraction, cursed artifacts).

This way:

- Original enthusiasts still “recognize” the raid and the LK fight.
- Your custom tiered gear and stat system are front and center.
- You maintain a **single, consistent Mortal game** instead of an awkward “retail emu inside Mortal”.

---

## 10. Status

This spec is intentionally small and focused. It introduces:

- `mortal_creature_tiers`
- `mortal_creature_tier_map`
- `mortal_spell_scaling`
- A conceptual `MortalNormalizeCreature()` hook

and defines the **philosophy and practical plan** for:

- Rescaling NPCs/encounters globally.
- Keeping ICC/Lich King both **familiar** and **Mortalized**.
