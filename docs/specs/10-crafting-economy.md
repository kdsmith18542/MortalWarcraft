# Project Canvas: Mortal Warcraft Overhaul
### Version 26.1 — Hybrid Technical Design Document  
### File: 10-crafting-economy.md  
### Section: Crafting, Refining, Material Lore, Workstations, Quality, Decay & Regional Economy

---

# 1. Overview

The Mortal Warcraft crafting system merges concepts from:

- **Mortal Online 1/2** (deep material simulation)  
- **Runescape** (refining tiers & utility crafting)  
- **EVE Online** (BPO/BPC manufacturing chains)  
- **WoW Classic** (iconic recipes & professions)  

Crafting is the backbone of the **player-driven economy**, with full integration into:

- PvP risk  
- PvE loot  
- Resource seasons  
- Territory control  
- Guild sovereignty  
- Travel logistics  
- Decay & item sinks  

This document fully defines the crafting and economy layer.

---

## Related Specs

For full context on crafting and economy systems, see:

- **`05-crafting.md`** — Core crafting mechanics, material lore, and workstation systems
- **`04-economy.md`** — Regional banking, market stalls, and economic infrastructure
- **`37-economy-system-extensions.md`** — Extended economy features (blessings, item decay, repair costs)
- **`13-caravans-contracts.md`** — Caravan system for transporting crafted goods between regions
- **`19-itemization.md`** — Item tiers and stat budgets that crafted items must align with
- **`03-risk-zones.md`** — Risk tiers that affect material gathering and trade routes

---

# 2. Material Families

Every material belongs to a **Material Family**, defining its properties:

### Metals
- Copper  
- Tin  
- Iron  
- Steel  
- Mithril  
- Thorium  
- Elementium  

### Woods
- Softwood  
- Hardwood  
- Heartwood  
- Dreamwood  

### Leathers
- Light hide  
- Medium hide  
- Heavy hide  
- Demon hide  

### Fabrics
- Linen  
- Silk  
- Dreamcloth  

### Magical Essences
- Fire Essence  
- Frost Essence  
- Shadow Essence  
- Dream Essence  

Each material type has **properties** affecting crafting outcomes.

---

# 3. Material Properties

Materials use 5 standardized stats:

- **Hardness**  
- **Flexibility**  
- **Weight**  
- **Conductivity**  
- **Purity**  

These values influence:
- Weapon damage  
- Armor weight & encumbrance  
- Durability  
- Crafting difficulty  
- Success chance  

Stored in SQL:
- `schema_material_properties.sql`

---

# 4. Material Lore Skill System

Players must learn **Material Lore** before refining or crafting with complex resources.

### Examples:
- Iron Lore  
- Steel Lore  
- Thorium Lore  
- Dreamwood Lore  

Lore increases:
- Refining efficiency  
- Crafting success  
- Quality roll potential  

Gained by:
- Refining  
- Crafting  
- Studying item “Lore Books”

Lua:
- `material_lore_handler.lua`

---

# 5. Workstations (World Objects)

Crafting **cannot** be done from a menu.  
Players must interact with **physical world objects**:

- Anvils  
- Looms  
- Tanning racks  
- Arcane forges  
- Refineries  
- Mortar & pestle stations  

Workstations have **tiers** (I–IV), affecting crafting difficulty.

SQL:
- `workstation_definitions.sql`

Lua:
- `MortalCraftingWorkstation.cpp/h` (C++ implementation)

---

# 6. Refining Process

Refining is a **multi-step process**:

## 6.1 Smelting (Metals)
Requires:
- Ore  
- Flux  
- Furnace workstation  

Outcome:
- Ingots  
- Slag (byproduct)  

Thorium and higher require Lore skills.

## 6.2 Tanning (Leathers)
Requires:
- Hide  
- Chemicals  
- Tanning rack  

## 6.3 Milling (Woods)
Requires:
- Logs  
- Sawhorse  

---

# 7. Crafting Formula

Every crafted item uses:

```
QualityScore = (CrafterSkill + MaterialLore + WorkstationTier*10 + RNG) - ItemDifficulty
```

QualityScore determines the **result tier**:

### Quality Tiers:
- **Shoddy (-20% stats)**
- **Common (normal)**
- **Fine (+5% stats)**
- **Superior (+10% stats)**
- **Exceptional (+15% stats)**
- **Masterwork (+20% stats)**
- **Legendary (+30% stats, ultra rare)**

---

# 8. BPO / BPC Manufacturing (EVE-Style)

### BPO — Blueprint Original
- Permanent  
- Very rare  
- Often sourced from:
  - Extraction raids  
  - World bosses  
  - Legendary questlines  

### BPC — Blueprint Copy
- Consumable  
- 1–10 uses  
- Dropped more frequently  

Stored in:
- `schema_blueprints.sql`

Examples:
- Katana Mold  
- Nightmare Steed Harness Pattern  
- Arcane Furnace Blueprint  

---

# 9. Component-Based Item Construction

Items require **multiple components**, often from multiple professions.

### Example: Sword
- Blade (Smith)  
- Hilt (Leatherworker)  
- Pommel (Jeweler)  
- Flux (Alchemist)  

Final stats determined by:
- Each component’s material properties  
- Quality of each part  
- Crafter’s skill roll  

---

# 10. Permanent Durability Decay

Repairing reduces maximum durability:

```
MaxDurability *= 0.90
```

Purpose:
- Item sink  
- Supports a stable economy  
- Encourages continued crafting  

Lua:
- `MortalDurabilityDecay.cpp/h` (C++ implementation)

---

# 11. Encumbrance & Weight Simulation

Items have **real weight** based on material.

Encumbrance affects:
- Movement speed  
- Stamina regen  
- Dodge ability  
- Carrying capacity  

### 11.1 Encumbrance Calculation Formula

**Max Carry Capacity:**
```
MaxCarryCapacity = BaseCapacity + (Strength * 2.0)
```

Where:
- **BaseCapacity**: Default 250 lbs (configurable via feature flag `encumbrance.base_capacity`)
- **Strength**: Player's Strength stat (capped at 150)
- **Max Capacity Example**: 250 + (100 Strength * 2) = 450 lbs

**Current Weight Calculation:**
```
CurrentWeight = Sum of (ItemDensity * ItemCount) for all items in inventory
```

Where:
- **ItemDensity**: Material density in lbs per item (from `item_material_properties` table)
- **ItemCount**: Stack count of the item
- Items in main backpack (slots 0-22) and equipped bags are counted

**Encumbrance Ratio:**
```
EncumbranceRatio = CurrentWeight / MaxCarryCapacity
```

### 11.2 Encumbrance Penalties

Penalties are applied based on encumbrance ratio:

| Ratio | Status | Penalty | Effect |
|-------|--------|---------|--------|
| 0.0 - 1.0 | Normal | None | No penalties |
| 1.0 - 2.0 | Encumbered | -20% Movement Speed | Minor Burden spell applied |
| 2.0+ | Overburdened | Cannot Move | Overburdened spell applied (root/pacify) |

**Penalty Details:**
- **Encumbered (100-200% capacity)**: 20% movement speed reduction via spell ID 60002
- **Overburdened (200%+ capacity)**: Complete movement lock via spell ID 60003
- Penalties are applied/removed automatically when weight changes

### 11.3 Material Density

Item weight is determined by material density:
- Density values stored in `item_material_properties` table
- Default density: 0.1 lbs per item (for unknown items)
- Material density varies by material type and tier:
  - Light materials (cloth, leather): 0.05-0.2 lbs/item
  - Medium materials (wood, basic metals): 0.2-0.5 lbs/item
  - Heavy materials (iron, steel): 0.5-1.0 lbs/item
  - Very heavy materials (plate armor, large weapons): 1.0-5.0 lbs/item

### 11.4 Example Calculations

**Example 1: Normal Load**
```
Strength = 50
BaseCapacity = 250
MaxCarryCapacity = 250 + (50 * 2) = 350 lbs
CurrentWeight = 200 lbs
EncumbranceRatio = 200 / 350 = 0.57 (57%)
Status: Normal (no penalties)
```

**Example 2: Encumbered**
```
Strength = 75
BaseCapacity = 250
MaxCarryCapacity = 250 + (75 * 2) = 400 lbs
CurrentWeight = 450 lbs
EncumbranceRatio = 450 / 400 = 1.125 (112.5%)
Status: Encumbered (-20% movement speed)
```

**Example 3: Overburdened**
```
Strength = 100
BaseCapacity = 250
MaxCarryCapacity = 250 + (100 * 2) = 450 lbs
CurrentWeight = 1000 lbs
EncumbranceRatio = 1000 / 450 = 2.22 (222%)
Status: Overburdened (cannot move)
```

SQL:
- `item_weight_table.sql`

Lua:
- `encumbrance_logic.lua`

---

# 12. Regional Economy (EVE-inspired)

## 12.1 Regional Banking
Stormwind Bank != Ironforge Bank.

## 12.2 Global Listing Board (Market Stalls)
Global view of stall listings, **local pickup only** (same system as Market Stalls; no mail delivery).

## 12.3 Trade Runs
Hauling goods between cities  
→ Dangerous in Yellow/Red zones  
→ Core loop for caravans & couriers  

## 12.4 Localized Resources
Each zone produces different:
- Ores  
- Herbs  
- Essences  
- Woods  

Guilds fight over regions due to resource control.

---

# 13. Item Weight Classes

Items fall into:

- Ultra-light  
- Light  
- Medium  
- Heavy  
- Ultra-heavy  

Used to determine:
- Stamina cost  
- Encumbrance penalties  
- Movement modifiers  

---

# 14. Gathering Overhaul

### 14.1 Tool Requirements
Pickaxe, hatchet, sickle  
→ Each crafted with quality tiers

### 14.2 Node System
Nodes respawn dynamically based on:
- Region control  
- Player activity  
- Seasonal rules  

Lua:
- `dynamic_node_system.lua`

---

# 15. Crafting Professions Overview

Players are **classless**, but professions provide direction:

- Weaponsmith  
- Armorsmith  
- Leatherworker  
- Clothier  
- Alchemist  
- Scribe  
- Carpenter  
- Beast Tamer (mount gear/breeding)  

Each has a mastery tree.

---

# 16. Crafting Mastery Trees

Each profession has 3–4 branches, e.g.:

### Weaponsmith:
- Blades  
- Blunts  
- Polearms  
- Exotic weapons  

### Armorsmith:
- Light armor  
- Medium armor  
- Heavy armor  

Each point gives passive bonuses.

---

# 17. Integration with PvP & Economy

Crafting impacts:
- PvP gear  
- Mount gear  
- Guild sieges  
- Caravans  
- Extraction raids  
- World boss loot  
- Stronghold upgrades  

Crafting is **not optional** — it is the economy.

---

# 18. Implementation Summary

## 18.1 Lua Files
- `MortalCraftingWorkstation.cpp/h` (C++ implementation)
- `material_lore_handler.lua`
- `MortalDurabilityDecay.cpp/h` (C++ implementation)
- `encumbrance_logic.lua`
- `dynamic_node_system.lua`

## 18.2 SQL Files
- `schema_material_properties.sql`
- `schema_blueprints.sql`
- `item_weight_table.sql`
- `workstation_definitions.sql`

## 18.3 C++ Files
- `CraftingHooks.cpp`
- `Encumbrance.cpp`

---

# 19. Status
Crafting & Economy are **Core Systems**, essential to Mortal Warcraft’s sandbox identity and long-term retention.
