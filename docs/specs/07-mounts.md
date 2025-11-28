# Project Canvas: Mortal Warcraft Overhaul
### Version 26.1 — Hybrid Technical Design Document  
### File: 07-mounts.md  
### Section: Living Mounts, Durability, Breeding, Transport & Mounted Combat-lite

---

# 1. Overview

Mounts in Mortal Warcraft are **physical, living assets**, not learned spells.  
Inspired by Mortal Online, ArcheAge, and Red Dead systems, this design turns mounts into:

- Tradeable commodities  
- Lootable assets  
- Breeding stock (future expansion)  
- Transport tools  
- Light-combat mobility platforms  

This document defines:

- Mount items (Reins System)  
- Durability, death, and revival  
- Breeding genetics (future expansion)  
- Stable management  
- Caravan integration  
- Mounted Combat-lite (charges, trample)  
- Transport animals (pack mules, oxen)

**Implementation Note:** The current implementation uses the simpler `mortal_mount_visuals` system defined in `28-mounts-living-system-and-mapping.md`, which maps mount tiers (M-M1 through M-M4) to WotLK mount visuals. The breeding/genetics system described in this document is planned as a future expansion. See `30-db-migrations-mortal-core.md` for the current database schema.  

---

## Related Specs

For full context on mount systems, see:

- **`28-mounts-living-system-and-mapping.md`** — Mount living system and visual mapping implementation
- **`13-caravans-contracts.md`** — Caravan system that uses mounts and pack animals for transport
- **`03-risk-zones.md`** — Risk zones that affect mount loot rules on death
- **`37-economy-system-extensions.md`** — Blessed items system that can protect mounts from full loot
- **`90-mortal-living-assets-companions.md`** — Living assets system that includes mounts and companions
- **`05-crafting.md`** — Crafting system for stable kits and mount repair items

---

# 2. Mount Items (Reins System)

## 2.1 Core Concept
Mounts are **items**, not spells.

### When a player mounts:
- They must have **Reins of the Horse** (or other mount) in inventory.  
- The item is consumed *temporarily* to spawn the mount.  
- On dismount, the reins reappear in the inventory.

## 2.2 On Death in PvP
- **Yellow zones:** Innocents/defenders keep their mount reins (per Risk-Zone rules). Criminals drop reins with their full loot.  
- **Red zones:** Reins drop unless the item is **Blessed** (see `37-economy-system-extensions.md`), in which case the blessing is consumed and extra durability loss is applied.  
- Losing your mount is part of the risk economy.

## 2.3 Item Fields (SQL)

```
item_entry
mount_speed
stamina
temperament
durability
max_durability
bloodline_id
```

---

# 3. Mount Durability & Death

## 3.1 Durability Rules
- Being forcibly dismounted → reins take durability damage.  
- Mount taking damage → reins take damage.  

## 3.2 At 0 Durability
- Mount **dies permanently**.  
- Reins convert into **Carcass** item.  
- Carcass can be skinned or butchered.

## 3.3 Repairing a Mount
Repair item: **Stable Kit**

Repairing reins applies **permanent decay**:

```
MaxDurability = MaxDurability * 0.90
```

---

# 4. Mount Stats

Each mount has:

- **Speed** (base movement)
- **Acceleration**
- **Stamina** (sprint duration)
- **Temperament** (chance to panic)
- **Carrying Capacity**
- **Breed Type**
- **Hidden Genetic Traits**

---

# 5. Stable System

Mounts can be stored in city stables.

## 5.1 Stable Rules
- Small fee (gold sink)  
- Can store 5–20 mounts depending on upgrades  
- Outlaws cannot use stables in Green zones  
- Stables have unique NPC vendors:  
  - Feed vendor  
  - Breeding overseer  
  - Stable master  

---

# 6. Feeding & Care

Mounts must be fed occasionally:
- Hay  
- Apples  
- Special grains  

Feeding bonuses:
- +Speed buff (minor)
- +Stamina regen
- +Temperament stability

Caravan animals require **Bulk Feed**.

---

# 7. Breeding System

A full, genetic breeding system similar to MO1/MO2.

## 7.1 Parents Provide:
- Base Speed  
- Base Stamina  
- Coat color  
- Temperament  
- Pack capacity  

## 7.2 Genetics
Each stat uses a recombination formula:

```
ChildStat = (ParentA + ParentB) / 2 ± RNG
```

Rare genes may include:
- Albino coloration  
- Warbred lineage (+HP)
- Desert lineage (+heat resistance)
- Frostblood (+cold resistance)
- Fearless temperament  

## 7.3 Breeding Risks
- Offspring may be weak  
- Coat color mutations extremely rare  
- Parents may suffer minor durability loss during breeding  

## 7.4 Implementation Files
Lua:
- `breeding_system.lua`
- `genetics_handler.lua`

SQL:
- `mount_genetics.sql`

---

# 8. Transport Animals (Pack Mules & Oxen)

## 8.1 Purpose
Transport animals fill the hauling niche for:

- Courier contracts  
- Caravans  
- Guild logistics  

## 8.2 Rules
- Cannot sprint  
- High carrying capacity  
- Slow movement  
- Extremely vulnerable in Red zones  
- Must be leashed or they wander  

## 8.3 Pack Inventory
Similar to mount reins but includes:

```
pack_capacity
weight_modifier
panic_threshold
```

---

# 9. Caravans Integration

Caravans use:
- 1 player pulling  
- 1–2 pack animals attached  
- Optional mounted guards  

Death/destruction:
- Caravan drops a **Caravan Chest**  
- Animals drop **Carcass**  
- Contract collateral lost  

Lua:
- `MortalCaravanSystem.cpp/h` (C++ implementation)

---

# 10. Mounted Combat-lite

A simplified combat system is included:

## 10.1 Charge Attack
Triggered by sprinting for >1.5 seconds:
- Deals bonus opening damage  
- Knocks down small mobs  
- Does not dismount target players (to avoid cheese)  

## 10.2 Trample Attack
Standing mount + move through target:
- Deals small damage  
- Applies “Stagger”  
- PvE only  

## 10.3 Mounted Archery (Limited)
- -25% accuracy  
- +25% stamina cost  
- Only light bows allowed  

All mounted combat is meant to be:
- Low-impact  
- Flavorful  
- Non-meta  

---

# 11. Rare Mounts

Rare mounts come from:
- Breeding  
- World bosses  
- Extraction raids  
- Seasonal events  
- Regional caravans  

Examples:
- Nightmare Steed (EPL)
- Ash Warg (Burning Steppes)
- Dream Elk (Winterspring)
- Obsidian Charger (Silithus rare boss)

---

# 12. Implementation Summary

## 12.1 C++ Files
- `MountHandler.cpp`
- `MountedCombat.cpp`
- `Encumbrance.cpp`

## 12.2 Lua Files
- `MortalLivingMounts.cpp/h` (C++ implementation)
- `mount_durability.lua`
- `breeding_system.lua`
- `MortalCaravanSystem.cpp/h` (C++ implementation)

## 12.3 SQL
- `mount_genetics.sql` (future expansion)
- `mount_items.sql` (see `mortal_mount_visuals` in `30-db-migrations-mortal-core.md` for current implementation)
- `stable_database.sql` (future expansion)

**Current Implementation:** See `28-mounts-living-system-and-mapping.md` and `30-db-migrations-mortal-core.md` for the `mortal_mount_visuals` table that defines mount tiers and visual mappings.

---

# 13. Status
Living mounts are **Core** and tightly connected to hauling, caravans, and the economy.  
They serve as a bridge between PvP, PvE, and trade systems.
