# Project Canvas: Mortal Warcraft Overhaul
### Version 26.7b — Hybrid Technical Design Document  
### File: 31-mortal-core-registry.md  
### Section: ID & Range Registry (Items, Spells, Skills, Creatures, GameObjects)

---

## Related Specs

- `19-itemization.md` - Item ID ranges and itemization
- `64-spell-and-ability-library.md` - Spell ID ranges and ability library
- `01-progression.md` - Skill ID ranges and progression
- `30-db-migrations-mortal-core.md` - Database migrations that use these ID ranges
- `26-gear-visual-mapping.md` - Gear visual mapping using item IDs
- `27-gear-stats-and-etl.md` - Gear stats using item IDs
- `28-mounts-living-system-and-mapping.md` - Mount system using item/spell IDs
- `29-companion-bond-and-mercenary-system.md` - Companion system using creature IDs

---

## 1. Purpose

This document is the **single source of truth** for all custom ID ranges used by the Mortal Warcraft Overhaul, so that:

- Cursor, devs, and tools do **not collide** with AzerothCore / WotLK stock IDs.
- Every new system (gear, mounts, skills, etc.) pulls from **pre-agreed ranges**.
- You can see at a glance:
  - What each range is for.
  - Which specs depend on it.

This is a **planning/coordination** registry, not a migration file.

---

## 2. Engine Constraints (Quick Reality Check)

From AzerothCore:

- `item_template.entry` is a **MEDIUMINT UNSIGNED** field (max `16,777,215`).【AC docs】
- Similar limits apply to many other IDs (spells, skills, etc., are usually within 24‑bit or 32‑bit safe ranges).

So:

- We **can** safely jump to **6–7 digit IDs** (e.g. `700000+`) without hitting type limits.
- We just need to:
  - Avoid overlapping with existing entries.
  - Make sure custom items/spells are exported into the client DBC (which you’re already doing via Patch‑Z).

Going “way outside” the stock ranges by “adding a zero or two” is actually a good strategy, as long as we stay below `16,777,215`.

---

## 3. Items (`item_template.entry`)

We’ll use **high, clearly Mortal-only blocks**.

> Before finalizing, you should run on your world DB:  
> `SELECT MAX(entry) FROM item_template;`  
> and ensure nothing is already using these ranges. If there is, bump them up further but keep the structure.

### 3.1 Gear, PvE & PvP

- **700000–709999** → Mortal **PvE gear** (M-T1–M-T5)
  - Used by:
    - `26-gear-visual-mapping.md`
    - `27-gear-stats-and-etl.md`
  - Notes:
    - Armor sets & weapons tied to dungeon/raid progression.

- **710000–719999** → Mortal **PvP gear** (P1–P6)
  - Used by:
    - Same gear specs as above.
  - Notes:
    - Visuals mapped to S5–S8 Gladiator sets.

### 3.2 Mounts, Feed, Bonds, Tokens

- **720000–729999** → **Mortal Mount Reins** (Living Mounts)
  - Used by:
    - `28-mounts-living-system-and-mapping.md`
    - `mortal_mount_visuals.mortal_item_entry`.

- **730000–734999** → **Companion Feed & Upkeep Items**
  - Examples:
    - `Mortal Pet Ration`
    - `Mortal Mount Oats`
  - Used by:
    - `29-companion-bond-and-mercenary-system.md`.

- **735000–739999** → **Contracts, Tokens & Licenses**
  - Examples:
    - Mercenary contract scrolls (if items).
    - `Adventurer's License` (tradable token).
  - Used by:
    - Monetization / token economy specs.

### 3.3 Utility / Debug

- **790000–799999** → **Developer & Debug Items**
  - Examples:
    - Test gear/mounts.
    - GM-only spawn/test items.

---

## 4. Spells (`spell.id`)

Reserve a **clearly separated** high range for Mortal-specific spells. Spell IDs are generally int-like and safely support these ranges, as long as you patch client DBCs for custom spells.

- **900000–909999** → Mortal **combat / systemic spells**
  - Examples:
    - `SPELL_MORTAL_BRACE`
    - Guard Counter / Opportunity buffs.
    - Flask/Phial-style heals (if custom, not reusing stock).
    - Companion mood auras (Devoted/Neglected).

- **910000–914999** → Companion & Merc **utility spells**
  - Examples:
    - Summon/Despawn mercs.
    - “Bond surge” cosmetic procs.
    - Mount spook / calm effects.

(Exact spell definitions will be in their respective spec docs; this registry just reserves ranges.)

---

## 5. Skills (`SkillLine.dbc` / `skillline` table)

For custom skills (Armor/Riding masteries, Material Lore, etc.):

- **8000–8099** → **Armor Mastery Skills**
  - `8000` → Armor Mastery: Plate
  - `8001` → Armor Mastery: Mail
  - `8002` → Armor Mastery: Leather
  - `8003` → Armor Mastery: Cloth

- **8100–8199** → **Weapon / Combat Mastery** (if needed)
  - E.g. `8100` → Two-Hand Mastery, `8101` → Polearm Mastery, etc.

- **8200–8299** → **Riding Masteries**
  - `8200` → Riding: Pack
  - `8201` → Riding: Standard
  - `8202` → Riding: War
  - `8203` → Riding: Elite

- **8300–8399** → **Material Lore Skills**
  - `8300` → Lore: Copper
  - `8301` → Lore: Iron
  - `8302` → Lore: Thorium
  - etc.

Actual use of these IDs will be spelled out when you finalize your Skill design doc; this just blocks out the ranges.

---

## 6. Creatures (`creature_template.entry`)

Reserve blocks for new Mortal systems:

- **600000–609999** → **Mercenaries & Hirelings**
  - Used by:
    - `mortal_merc_templates.creature_entry`.
  - Includes:
    - Healer merc variants.
    - Tank/DPS archetypes.

- **610000–619999** → **Stronghold / Siege NPCs**
  - Guards, siege engineers, quartermasters.

- **620000–629999** → **Event Mobs / Special Systems**
  - Zombie hordes (Midnight Horde event).
  - Special alpha variants for public dungeons.

---

## 7. GameObjects (`gameobject_template.entry`)

For shrines, crafting stations, territory flags, etc.:

- **500000–509999** → **Shrines & Spirit Healers (Mortal variants)**
  - Used by:
    - Shrine-based respawn system.
    - Flask refills.

- **510000–519999** → **Crafting Workstations**
  - Anvils, forges, looms, alchemy tables tied to deep crafting.

- **520000–529999** → **Territory & Stronghold Objects**
  - Control points, banners, siege objectives.

---

## 8. SmartAI / Script IDs (If Needed)

If you want to keep **SmartAI** entryorguid-specific scripts in their own ranges, you can adopt:

- **1000000+** for `smart_scripts.id` in Mortal-only contexts, but SmartAI IDs are usually per-entry scoped so collision is less of a problem. This is just a note if you want strongly separated ID spaces.

---

## 9. How to Use This Registry

- When writing/spec’ing a new system:
  - Pick IDs from the proper range here.
  - Reference them in that system’s spec doc by **symbolic constant** (e.g. `ITEM_MORTAL_PVE_CHEST_M_T3 = 700123`).
- When using Cursor:
  - Point it at this doc so it never invents random IDs; it should always choose from the reserved ranges.

---

## 10. Status

This file supersedes any earlier low-ID range guesses (like `70000–70999`). From now on:

- Treat **all Mortal custom items/spells/etc. as living in the high ranges defined here**.
- If you discover conflicts with your actual DB (via `SELECT MAX(entry)` checks), bump the ranges upward but keep this structure and update this registry first.
