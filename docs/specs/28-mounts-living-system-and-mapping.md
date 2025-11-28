# Project Canvas: Mortal Warcraft Overhaul
### Version 26.4 — Hybrid Technical Design Document  
### File: 28-mounts-living-system-and-mapping.md  
### Section: Living Mounts & Visual Mapping (WotLK 3.3.5a Models)

---

## Mount Breeding System (Future Expansion)

### Breeding System Status

**Decision: Defer to Season 2+ (Design Now, Implement Later)**

**Rationale:**
- Not critical for launch (Season 1 scope)
- Complex system better introduced when core is stable
- Can be designed now for future implementation
- Supports long-term progression

**Implementation Plan:**
- **Design Phase**: Create breeding system design now
- **Implementation**: Defer to Season 2+
- **Reasoning**: 
  - Core mount system must work first
  - Breeding adds complexity
  - Better as expansion feature
  - Supports long-term retention

**Design Notes:**
- Breeding system will allow players to combine mount traits
- Create new mount variants through breeding
- Breeding requires specific mounts and materials
- Breeding results are randomized with quality tiers
- Supports long-term progression and economy

**Status**: Marked as "Future Expansion" - Design complete, implementation deferred to Season 2+

---

## Related Specs

- `07-mounts.md` - Living mounts system design
- `26-gear-visual-mapping.md` - Visual mapping approach (similar pattern)
- `27-gear-stats-and-etl.md` - ETL pipeline approach (similar pattern)
- `90-mortal-living-assets-companions.md` - Unified living assets system
- `30-db-migrations-mortal-core.md` - Database migrations for mount tables
- `31-mortal-core-registry.md` - ID registry for mount items and spells
- `13-caravans-contracts.md` - Caravan system that uses mounts
- `04-economy.md` - Economy system for mount trading

---

## 1. Purpose

This document defines the **Living Mounts** system for Mortal Warcraft and specifies how we:

1. Reuse **WotLK 3.3.5a mount models** (visuals + spells).
2. Replace Blizzard’s original **progression & rules** with a **Mortal-specific mount ladder**.
3. Implement **Reins-as-items** with:
   - Durability.
   - Full-loot behavior.
   - Tiered speeds and capacity.
4. Provide a **mapping + data pipeline** similar to gear, but simpler.

This complements:

- `26-gear-visual-mapping.md`
- `27-gear-stats-and-etl.md`

---

## 2. Design Goals

- Make mounts **tangible assets**:
  - You own the **Reins item**, not a permanent spell.
  - Losing your mount is a real economic event.
- Keep a **clean, readable tier ladder**:
  - When you see a mount, you can roughly tell:
    - Its **tier**.
    - Its **function** (war/bulk/courier/prestige).
- Minimize art cost:
  - Use existing **WotLK mount spells/models**.
- Integrate tightly with:
  - **Red/Yellow/Green** zone risk model.
  - **Regional economy** (trade runs).
  - **Strongholds & PvP ranks**.

---

## 3. Core System Overview

### 3.1 Living Mounts – Rules

1. **No Spellbook Mounts**
   - Players do not permanently learn mounts.
   - There are no “Mount” tabs; all mounts are **items**.

2. **Reins Item**
   - Mounts are represented by **Reins of the X** items.
   - The item has:
     - Stack size 1.
     - Durability.
     - Use effect that casts a **mount spell**.
   - Reins must be:
     - In your bag to mount.
     - In good condition (durability > 0).

3. **Full Loot Behavior**
   - **Yellow zones:** Innocents/defenders keep reins; Criminals drop reins with their other gear.
   - **Red zones:** Reins drop unless the item is **Blessed** (see `37-economy-system-extensions.md`), which prevents the drop but consumes blessing charges and applies extra decay.
   - On PvE death:
     - Follow general corpse rules (configurable; default: can be recovered from your corpse chest).

4. **Durability & Death**
   - Being **force-dismounted** (taking significant damage while mounted) causes:
     - Reins durability loss.
   - When durability hits **0**:
     - Reins item is destroyed.
     - The mount is considered “dead”.

5. **Mount Tiers**
   - Mount tiers define:
     - **Speed**.
     - **Capacity** (weight or extra slots).
     - **Acquisition difficulty**.
   - Visuals are chosen from curated WotLK mounts.

---

## 4. Mount Tiers & Roles

### 4.1 Ground Mount Tiers

We define four main **ground mount tiers**:

- **M-M1 – Pack Beasts**
  - Speed: ~60% (slower than typical riding).
  - Capacity: +10–20% carrying weight or +4 slots in a special “Saddlebag”.
  - Role: Early economy, trade runs in safer zones.
  - Sources: Basic horses/boars/wolves visuals.

- **M-M2 – Riding Mounts**
  - Speed: ~100% (baseline fast riding).
  - Capacity: small bonus only.
  - Role: General travel, couriers in Yellow zones.
  - Sources: Standard racial mounts.

- **M-M3 – War Mounts**
  - Speed: ~110–120% (fast combat mounts).
  - Capacity: minimal; tuned for combat.
  - Role: PvP operations, patrols, warbands.
  - Sources: Armored horses, war bears, charger-type mounts.

- **M-M4 – Prestige / Elite**
  - Speed: ~120–130% (margin over M-M3).
  - Capacity: small; mostly cosmetic advantage.
  - Role: prestige, guild leaders, top PvP ranks.
  - Sources: Raid/PvP mounts (Deathcharger, Frostbrood, Wrathful mounts, etc.).

Flying mounts are **disabled in Red zones** by core design. If they exist at all, they should be:

- Heavily restricted to specific events/instances.
- Not mainstream travel.

---

## 5. Data Model – mortal_mount_visuals

### 5.1 Mapping Table

Create:

```sql
CREATE TABLE mortal_mount_visuals (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  mortal_item_entry     INT NOT NULL,          -- new Reins item ID (e.g. 72001)
  mortal_mount_tier     VARCHAR(8) NOT NULL,   -- 'M-M1', 'M-M2', 'M-M3', 'M-M4'
  speed_multiplier      FLOAT NOT NULL,        -- 0.6, 1.0, 1.2, etc.
  capacity_slots        INT NOT NULL,         -- extra saddlebag slots (0–16)
  source_item_entry     INT NOT NULL,         -- original WotLK mount item
  source_spell_id       INT NOT NULL,         -- original mount spell
  source_creature_id    INT NULL,             -- creature ID if needed
  notes                 VARCHAR(255) NULL
);
```

### 5.2 Item Range Reservation

Reserve a **custom item range** for Mortal mounts:

- e.g. `720000–729999` (per `31-mortal-core-registry.md`).

All Mortal Reins use entries in this range.

---

## 6. Mount Item Template Rules

Each Mortal Reins item in `item_template`:

- **Class/Subclass**: misc / mount (match existing mount items).
- **Stackable**: 1.
- **Durability**: set to a baseline per tier:
  - M-M1: 50
  - M-M2: 75
  - M-M3: 100
  - M-M4: 125
- **Use Effect**:
  - Casts `source_spell_id` from `mortal_mount_visuals`.
- **Required Skill**:
  - Uses a Mortal-specific riding skill:
    - `Riding: Pack`, `Riding: Standard`, `Riding: War`, `Riding: Elite`.
  - Each tier has a minimum required skill rank.
- **Flags**:
  - Bind on Equip or Bind on Pickup, depending on design:
    - Pack/Riding mounts might be tradable.
    - War/Prestige mounts might be BoP or guild-bound.

Example skeleton for item row (conceptual):

```sql
INSERT INTO item_template (
  entry, class, subclass, name, displayid,
  Quality, Flags, Stackable,
  RequiredSkill, RequiredSkillRank,
  MaxDurability,
  spellid_1, spelltrigger_1,
  description
)
VALUES (
  72001, 15, 5, 'Reins of the Mortal Warhorse', 0,
  4, 0, 1,
  91001, 75,          -- Riding: War, rank 75
  100,
  55555, 0,           -- source_spell_id, trigger "on use"
  'A battle-trained charger bred in the Mortal war stables.'
);
```

> Note: `displayid` for mount items themselves is usually trivial; the **visual** comes from the mount spell. You can optionally set a nice icon display, but actual mount model is spell-driven.

---

## 7. Living Mounts Logic (Gameplay Scripts)

### 7.1 Core Events

In `MortalLivingMounts.cpp/h` (C++ implementation) or equivalent C++/Lua combo:

1. **On Use (OnItemUse hook)**
   - Check:
     - Is player in allowed zone (not in restricted interior if you want)?
     - Has player `Riding` skill high enough?
     - Is Reins durability > 0?
   - If OK:
     - Cast `source_spell_id`.
     - Mark player as having `active_mount_item_entry = X`.

2. **On Forced Dismount / Damage Threshold**
   - Hook into:
     - OnAuraRemove for mount spells.
     - OnDamageTaken events.
   - If:
     - Player is mounted.
     - They take a significant hit / forced dismount.
   - Then:
     - Reduce Reins durability by X (tier-dependent).
     - If durability == 0: destroy item, send flavor message (horse dies).

3. **On Player Death (PvP)**
   - If player dies in **Yellow/Red** zone:
     - Move Reins item from inventory into corpse chest like other gear.
     - Your existing corpse-chest logic can handle this if item is flagged as “Mortal Mount”.

4. **On Player Death (PvE / Green)**
   - Configurable:
     - Default: Reins go into corpse chest but can be recovered.
     - You may decide to not lose mounts in Green zones.

### 7.2 Skill Integration

Define riding skills:

- `SKILL_RIDING_PACK` (ID e.g. 91000)
- `SKILL_RIDING_STANDARD` (91001)
- `SKILL_RIDING_WAR` (91002)
- `SKILL_RIDING_ELITE` (91003)

Mount tiers require:

| Tier | Skill           | Rank |
|------|-----------------|------|
| M-M1 | PACK            | 1–25 |
| M-M2 | STANDARD        | 50   |
| M-M3 | WAR             | 75   |
| M-M4 | ELITE           | 100  |

You can allow **skill training** via:

- Riding trainers in major cities.
- Contracts / achievements.

---

## 8. Complete Mount-to-Reins Conversion Mapping

This section provides a comprehensive mapping of all WoW 3.3.5a mounts to Mortal Warcraft's Reins system.

### 8.1 Mount Conversion Rules

**All Mounts Convert to Reins:**
- Original mount spells → Reins items
- Mount visuals preserved (same model/display ID)
- Mount speed converted to Mortal tier system
- Mount acquisition converted to Mortal progression

**Conversion Process:**
1. Original mount spell → Reins item entry
2. Mount visual → Preserved in Reins item
3. Mount speed → Converted to Mortal tier (M-M1 to M-M4)
4. Mount acquisition → Converted to Mortal progression (skill-based)

### 8.2 Mount Tier Conversion

| WoW Mount Type | Original Speed | Mortal Tier | Speed Multiplier | Capacity | Notes |
|----------------|----------------|-------------|-----------------|----------|-------|
| **60% Ground Mounts** | 60% | M-M1 (Pack Beast) | 0.6 | +8-16 slots | Early mounts, pack animals |
| **100% Ground Mounts** | 100% | M-M2 (Riding Mount) | 1.0 | +2-4 slots | Standard mounts |
| **Epic Ground Mounts** | 100% | M-M3 (War Mount) | 1.1-1.2 | +0-2 slots | Combat mounts |
| **Rare/Epic Mounts** | 100% | M-M4 (Prestige) | 1.2-1.3 | +0-2 slots | Prestige mounts |
| **Flying Mounts** | 280% | **Disabled** | N/A | N/A | Not available (Red Zone restriction) |

### 8.3 Complete Mount Conversion Examples

#### Classic Mounts

| Original Mount | Original Spell | Mortal Reins Item | Mortal Tier | Speed | Capacity | Acquisition |
|----------------|----------------|-------------------|-------------|-------|----------|-------------|
| Brown Horse | Spell 458 | Reins of the Brown Horse (72001) | M-M2 | 1.0 | +4 slots | Vendor (basic) |
| White Stallion | Spell 470 | Reins of the White Stallion (72002) | M-M2 | 1.0 | +4 slots | Vendor (basic) |
| Palomino | Spell 472 | Reins of the Palomino (72003) | M-M2 | 1.0 | +4 slots | Vendor (basic) |
| Pinto | Spell 6648 | Reins of the Pinto (72004) | M-M2 | 1.0 | +4 slots | Vendor (basic) |
| Black Stallion | Spell 470 | Reins of the Black Stallion (72005) | M-M2 | 1.0 | +4 slots | Vendor (rare) |
| Deathcharger | Spell 17481 | Reins of the Deathcharger (72050) | M-M4 | 1.3 | +2 slots | Rare drop (prestige) |

#### TBC Mounts

| Original Mount | Original Spell | Mortal Reins Item | Mortal Tier | Speed | Capacity | Acquisition |
|----------------|----------------|-------------------|-------------|-------|----------|-------------|
| Nether Drake | Spell 37015 | Reins of the Nether Drake (72100) | M-M4 | 1.3 | +2 slots | Rare (prestige) |
| Ashes of Al'ar | Spell 40192 | Reins of the Phoenix (72101) | M-M4 | 1.3 | +2 slots | Rare drop (prestige) |
| Swift Nether Drake | Spell 37015 | Reins of the Swift Nether Drake (72102) | M-M4 | 1.3 | +2 slots | Rare (prestige) |

#### WotLK Mounts

| Original Mount | Original Spell | Mortal Reins Item | Mortal Tier | Speed | Capacity | Acquisition |
|----------------|----------------|-------------------|-------------|-------|----------|-------------|
| Frostbrood Vanquisher | Spell 72807 | Reins of the Frostbrood Vanquisher (72200) | M-M4 | 1.3 | +2 slots | ICC achievement (prestige) |
| Invincible | Spell 72286 | Reins of Invincible (72201) | M-M4 | 1.3 | +2 slots | Lich King drop (prestige) |
| Mimiron's Head | Spell 63796 | Reins of Mimiron's Head (72202) | M-M4 | 1.3 | +2 slots | Ulduar rare drop (prestige) |
| Blue Proto-Drake | Spell 59996 | Reins of the Blue Proto-Drake (72203) | M-M4 | 1.3 | +2 slots | Rare drop (prestige) |

### 8.4 Pack Beast Conversions (M-M1)

**Purpose:** Heavy transport mounts for trade runs and caravans.

| Original Mount | Mortal Reins Item | Speed | Capacity | Notes |
|----------------|-------------------|-------|----------|-------|
| Kodo (Pack) | Reins of the Pack Kodo (72010) | 0.6 | +16 slots | Heavy transport |
| Ram (Pack) | Reins of the Pack Ram (72011) | 0.6 | +16 slots | Heavy transport |
| Elekk (Pack) | Reins of the Pack Elekk (72012) | 0.6 | +16 slots | Heavy transport |

### 8.5 Flight Path Conversion Strategy

**Flight Path Rules:**
- **Green Zones:** Full flight network (safe travel)
- **Yellow Zones:** Limited flight paths (regional hubs only)
- **Red Zones:** No flight paths (must travel on foot/mount)

**Flight Path Restrictions:**
- Cannot fly directly into Red zones
- Must land at Yellow zone border, then travel on foot
- Flight paths connect regional hubs (not all zones)

**Flight Master Conversion:**
- Green zone flight masters: Full network access
- Yellow zone flight masters: Regional network only
- Red zones: No flight masters (too dangerous)

### 8.6 Mount Acquisition Conversion

**Original Acquisition → Mortal Acquisition:**

| Original Method | Mortal Conversion | Notes |
|----------------|-------------------|-------|
| Vendor purchase | Regional vendor purchase | Requires Riding skill, regional access |
| Quest reward | Task/Contract reward | No XP, gold/material rewards |
| Achievement reward | Achievement reward | Mortal achievement system |
| Rare drop | Rare drop (same) | Preserved, but drops Reins item |
| Reputation reward | Faction standing reward | Faction standing system |
| PvP reward | Warfront/Military Credits | PvP currency system |

**Riding Skill Requirements:**
- **M-M1 (Pack Beast):** Riding: Pack skill rank 1-25
- **M-M2 (Riding Mount):** Riding: Standard skill rank 50
- **M-M3 (War Mount):** Riding: War skill rank 75
- **M-M4 (Prestige):** Riding: Elite skill rank 100

---

## 9. Visual Mapping Workflow

Unlike gear, mounts are few; we can **curate them manually** with light tooling.

### 9.1 Seed CSV

`data/mortal_mounts_seed.csv`:

```csv
mortal_item_entry,mortal_mount_tier,speed_multiplier,capacity_slots,source_item_entry,source_spell_id,source_creature_id,notes
72001,M-M2,1.0,4,ITEM_ID_BASIC_HORSE,470,0,"Standard warhorse visual"
72002,M-M3,1.2,2,ITEM_ID_ARMORED_HORSE,60114,0,"Armored ICC-style charger"
72003,M-M1,0.6,8,ITEM_ID_PACK_KODO,18990,0,"Heavy pack kodo"
72004,M-M4,1.3,2,ITEM_ID_PRESTIGE_MOUNT,72807,0,"Prestige Frostbrood-style mount"
```

Populate:

- `source_item_entry` and `source_spell_id` from Wowhead/DB.
- `speed_multiplier` based on tier.
- `capacity_slots` for pack beasts.

### 8.2 ETL Script Behavior (Simple)

A small Python/Go script should:

1. Read `mortal_mounts_seed.csv`.
2. Generate:
   - `INSERT` into `mortal_mount_visuals`.
   - `INSERT` into `item_template` for each `mortal_item_entry`.

No complex stat budgets here; just:

- Durability per tier.
- Required skill IDs & ranks.
- Description/name templating (e.g. `Mortal Warhorse`, `Mortal Pack Kodo`).

---

## 9. Acquisition & Economy Hooks

### 9.1 Crafting

- **M-M1 / M-M2**:
  - Crafted via:
    - Leatherworker (saddles, tack).
    - Stablemaster NPC (animals).
    - Alchemist (feed/tonics).
  - Recipe example:
    - `Reins of the Mortal Packhorse`:
      - 10x Leather
      - 5x Iron Ingots
      - 1x Taming Contract (quest reward)
  - Creates tradable Reins.

### 9.2 Strongholds & Guild Rewards

- **M-M3 – War Mounts**:
  - Purchased or crafted **only** in strongholds owned by a guild.
  - Each stronghold type might grant a unique war mount skin.

- **M-M4 – Prestige**:
  - Drops from:
    - Cursed raid loot.
    - Warfront victory caches.
    - Seasonal PvP achievements.
  - Often **BoP** to the player or guild that earned it.

### 9.3 Trade & Theft

- Pack mounts (M-M1) can have:
  - Special flag: if killed in Red zone, **cargo theft** event triggered.
- Couriers rely on M-M2/M-M3:
  - Losing them is part of the risk in trade runs.

---

## 10. UI & Feedback

### 10.1 Tooltips

MortalUI `ui_tooltip_injector.lua` should add to Reins tooltips:

- Mount Tier: `Pack Mount (M-M1)` / `War Mount (M-M3)`
- Speed: `+60% Movement Speed`.
- Capacity: `+4 Saddlebag Slots`.
- Durability: `Durability X/Y (Mount dies at 0).`
- Risk: `Drops on death in Yellow/Red zones.`

### 10.2 Visual Cues

- Different **saddlebag size** in icon or description for pack mounts.
- Specific **name prefixes**:
  - `Pack`, `Riding`, `War`, `Elite`.

---

## 11. File & Spec Placement

Place this document at:

- `docs/28-mounts-living-system-and-mapping.md`

And the seed CSV at:

- `data/mortal_mounts_seed.csv`

so Cursor can:

- Scaffold the `mortal_mount_visuals` table migration.
- Generate the mount `item_template` SQL.
- Wire up the `MortalLivingMounts.cpp/h` (C++ implementation) logic according to this spec.

---

## 12. Status

This file is now the **authoritative spec** for:

- The Living Mounts system.
- Mount tier definitions (M-M1 → M-M4).
- How we reuse WotLK 3.3.5a mount visuals & spells.
- The data mapping + ETL approach for Mortal Reins items.
