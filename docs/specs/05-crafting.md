# Project Canvas: Mortal Warcraft Overhaul
### Version 26.1 — Hybrid Technical Design Document  
### File: 05-crafting.md  
### Section: Crafting, Materials, Refining, and Item Quality Systems

---

# 1. Overview

The crafting system in Mortal Warcraft is inspired by:
- **Mortal Online 1/2** (material depth, item variation, workstation dependency)  
- **Runescape** (skill-driven mastery, refinement loops)  
- **EVE Online** (BPO/BPC economy, industry specialization)  
- **Classic WoW** (intuitive item templates and iconic gear archetypes)

Crafting is designed as a **primary progression system** equal to combat.  
Every item crafted has:
- Material dependency  
- Procedural stat variation  
- Permanent decay  
- Required workstations  
- Success chance scaling with skill  

---

## Related Specs

For full context on crafting systems, see:

- **`10-crafting-economy.md`** — Crafting economy, material costs, and production chains
- **`04-economy.md`** — Regional banking, market stalls, and economic systems that support crafting
- **`19-itemization.md`** — Item tiers and stat budgets that crafted items must align with
- **`75-mortal-gear-and-runes-spec.md`** — Gear tiering and rune system for crafted gear
- **`01-progression.md`** — Skill system and progression that governs crafting skill gains
- **`03-risk-zones.md`** — Risk tiers that affect material gathering locations and workstation placement
- **`37-economy-system-extensions.md`** — Item decay, repair costs, and durability systems for crafted items

---

# 2. Material Lore System

## 2.1 Purpose
To allow **material expertise** to matter as much as raw crafting skill.

## 2.2 Rules
Each material type has its own Lore skill, e.g.:
- **Lore: Iron**
- **Lore: Thorium**
- **Lore: Dreamscale**
- **Lore: Oakwood**
- **Lore: Enchanted Leather**

## 2.3 Benefits
Higher Lore increases:
- Refining efficiency  
- Masterwork chance  
- Reduced resource loss  
- Lower decay rate on crafted items  
- Stat scaling accuracy  

## 2.4 Implementation
Lua:
- `MortalMaterialLore.cpp/h` (C++ implementation)
- `MortalRefiningLogic.cpp/h` (C++ implementation)

SQL:
- `material_lore_skills.sql`

---

# 3. Workstation-Based Crafting

Crafting is **no longer performed via spellbooks**.  
Players must interact physically with world objects.

## 3.1 Workstations
- Anvils (Weaponsmithing)
- Forges (Smelting/Refining)
- Looms (Cloth processing)
- Tanning Racks (Leather)
- Arcane Foci (Magical enhancements)
- Carpentry Tables (Woodcraft)
- Alchemy Labs (Advanced potions)
- Reagents Furnace (Flux/oil production)

## 3.2 Rules
- Cannot craft in open world unless using portable kits.
- Workstations may require:
  - Fuel (coal, oil)
  - Fluxes (alchemy materials)
- Higher-tier workstations exist only in dangerous zones or guild halls.

---

# 4. Crafting Stages

Every crafted item goes through the **industry pipeline**:

### Stage 1 — Raw Resources
Gathered in the world:
- Ore  
- Logs  
- Herbs  
- Hides  
- Magical Essences  

### Stage 2 — Refined Materials
Requires workstations:
- Bars  
- Planks  
- Oils  
- Cloth bolts  
- Leather  

### Stage 3 — Components
Requires high-skill specializations:
- Blades  
- Hilts  
- Plates  
- Bow Cores  
- Vine Grips  
- Magical Cores  

### Stage 4 — Final Items
Combines components:
- Swords  
- Armor  
- Potions  
- Tools  
- Enchantments  

---

# 5. Multi-Profession Dependencies

No single profession can complete an entire item.

Example: **Sword Crafting**
- **Blacksmithing:** Forge Blade  
- **Leatherworking:** Craft Hilt  
- **Alchemy:** Create Flux  
- **Material Lore:** Determine material traits  

This ensures:
- Trade interaction  
- Guild cooperative crafting  
- Regional specialization  

---

# 6. Procedural Item Quality

Every crafted item has a **randomized quality rating** based on:

```
Roll = CraftingSkill + MaterialLore + WorkstationTier + RNG(1–100)
```

## 6.1 Quality Tiers

| Tier | Multiplier | Description |
|------|------------|-------------|
| Shoddy | -20% | Poor workmanship |
| Common | +0% | Standard result |
| Fine | +5% | Above average |
| Superior | +10% | High workmanship |
| Exceptional | +15% | Rare high roll |
| Masterwork | +20% | Extremely rare |
| Legendary | +30% | Mythic roll, chase-tier |

### 6.1.1 Quality Score to Tier Mapping

The quality score from the crafting formula is mapped to quality tiers using the following thresholds:

**Quality Score Thresholds:**

| Quality Tier | Score Range | Stat Multiplier | Description |
|--------------|-------------|-----------------|-------------|
| **Shoddy** | < 0 | -20% (0.8x) | Poor workmanship, negative quality score |
| **Common** | 0 - 50 | +0% (1.0x) | Standard result, baseline quality |
| **Fine** | 51 - 100 | +5% (1.05x) | Above average workmanship |
| **Superior** | 101 - 150 | +10% (1.1x) | High workmanship, skilled crafting |
| **Exceptional** | 151 - 200 | +15% (1.15x) | Rare high roll, excellent work |
| **Masterwork** | 201 - 250 | +20% (1.2x) | Extremely rare, master-level crafting |
| **Legendary** | 251+ | +30% (1.3x) | Mythic roll, chase-tier quality |

**Mapping Formula:**
```
If QualityScore < 0:
    Tier = Shoddy
Else If QualityScore <= 50:
    Tier = Common
Else If QualityScore <= 100:
    Tier = Fine
Else If QualityScore <= 150:
    Tier = Superior
Else If QualityScore <= 200:
    Tier = Exceptional
Else If QualityScore <= 250:
    Tier = Masterwork
Else:
    Tier = Legendary
```

### 6.1.2 Quality Score Calculation Reminder

Quality score is calculated as:
```
QualityScore = (CrafterSkill + MaterialLore + WorkstationTier*10 + RNG) - ItemDifficulty
```

Where:
- **CrafterSkill**: Current crafting skill value (0-400+)
- **MaterialLore**: Material Lore skill for the material being used (0-400+)
- **WorkstationTier**: Tier of workstation (I=1, II=2, III=3, IV=4)
- **RNG**: Random roll (typically 0-50 or 0-100 depending on implementation)
- **ItemDifficulty**: Base difficulty of the item being crafted (typically 50-200+)

### 6.1.3 Quality Tier Examples

**Example 1: Low Skill, High Difficulty (Shoddy)**
```
CrafterSkill = 30
MaterialLore = 10
WorkstationTier = 1
RNG = 20
ItemDifficulty = 100

QualityScore = (30 + 10 + 10 + 20) - 100 = -30
Tier = Shoddy (-20% stats)
```

**Example 2: Moderate Skill (Common)**
```
CrafterSkill = 80
MaterialLore = 40
WorkstationTier = 2
RNG = 30
ItemDifficulty = 100

QualityScore = (80 + 40 + 20 + 30) - 100 = 70
Tier = Fine (+5% stats)
```

**Example 3: High Skill, Good Roll (Superior)**
```
CrafterSkill = 150
MaterialLore = 80
WorkstationTier = 3
RNG = 45
ItemDifficulty = 120

QualityScore = (150 + 80 + 30 + 45) - 120 = 185
Tier = Exceptional (+15% stats)
```

**Example 4: Master Crafting (Masterwork)**
```
CrafterSkill = 250
MaterialLore = 150
WorkstationTier = 4
RNG = 60
ItemDifficulty = 200

QualityScore = (250 + 150 + 40 + 60) - 200 = 300
Tier = Legendary (+30% stats)
```

### 6.1.4 Design Rationale

**Threshold Distribution:**
- **Shoddy (< 0)**: Penalty for attempting content beyond skill level
- **Common (0-50)**: Baseline quality for average crafting
- **Fine to Superior (51-150)**: Rewards skill investment
- **Exceptional to Masterwork (151-250)**: Rewards high skill + good RNG
- **Legendary (251+)**: Ultra-rare, requires max skill + perfect conditions

**Stat Multipliers:**
- Multipliers apply to all item stats (damage, armor, durability, etc.)
- Encourages high-quality crafting for endgame content
- Creates meaningful progression and economy value

## 6.2 Masterwork Chance
```
BaseChance = (Skill + Lore - Difficulty) / 10,000
```

This remains extremely low for legendary materials, with **Legendary** acting as the ultra-rare top roll above Masterwork.

---

# 7. Permanent Durability & Decay

## 7.1 Repair Decay
Every repair:
```
MaxDurability = MaxDurability * 0.90
```

## 7.2 Purpose
- Creates constant demand for replacement tools/weapons.
- Drives resource economy.
- Ensures crafted items continuously re-enter markets.

## 7.3 Implementation
Lua:
- `MortalDurabilityDecay.cpp/h` (C++ implementation)

C++:
- `DecayHooks.cpp`

---

# 8. Failure & Break Chance

Crafting can fail for:
- Low skill  
- Wrong workstation  
- Low-quality materials  
- Missing flux/oils  

Failure results:
- Component loss  
- Reduced quality  
- Item break  

---

# 9. Specialty Crafts & Advanced Systems

## 9.1 Tempering
Items can be tempered using:
- Rare oils  
- Elemental cores  
- Magical shards  

Tempering changes:
- Damage type  
- Physical resistances  
- Visual effects  

## 9.2 Enchanting (Rebuilt)
Enchanting becomes:
- Component-based  
- Requires Arcane Lore  
- Adds unique affixes  
- Has a small failure chance  
- Uses magical essences found in Red Zones  

## 9.3 Carved Glyphs (Future Expansion)
Runecrafting trees that enhance:
- Warlord abilities  
- Guardian defensive skills  
- Explorer mobility  

---

# 10. Complete Profession-to-Skill Mapping

This section provides a comprehensive mapping of all WoW 3.3.5a professions to Mortal Warcraft's skill-based crafting system.

## 10.1 Gathering Professions → Gathering Skills

| WoW Profession | Original Function | Mortal Skill | Material Lore | Notes |
|----------------|-------------------|-------------|---------------|-------|
| **Mining** | Ore gathering | **Gathering: Mining** | Lore: [Ore Type] | Iron, Mithril, Thorium, etc. |
| **Herbalism** | Herb gathering | **Gathering: Herbalism** | Lore: [Herb Type] | Peacebloom, Mageroyal, Golden Sansam, etc. |
| **Skinning** | Hide gathering | **Gathering: Skinning** | Lore: [Leather Type] | Light, Medium, Thick, Rugged Leather |
| **Fishing** | Fish gathering | **Gathering: Fishing** | Lore: [Fish Type] | Lifeskill, regional fish types |

**Skill Progression:**
- Gathering skills gain XP from successful gathering
- Higher skill = better yield, rare material chance
- Material Lore skills unlock at skill milestones

## 10.2 Crafting Professions → Crafting Skills

| WoW Profession | Original Function | Mortal Skill | Material Lore | Workstation | Notes |
|----------------|-------------------|-------------|---------------|-------------|-------|
| **Blacksmithing** | Metalwork crafting | **Crafting: Blacksmithing** | Lore: Iron, Mithril, Thorium | Anvil, Forge | Weapons, armor, tools |
| **Leatherworking** | Leather crafting | **Crafting: Leatherworking** | Lore: Light/Medium/Thick Leather | Tanning Rack | Armor, bags, components |
| **Tailoring** | Cloth crafting | **Crafting: Tailoring** | Lore: Linen/Wool/Silk/Mageweave | Loom | Cloth armor, bags, components |
| **Engineering** | Mechanical crafting | **Crafting: Engineering** | Lore: Metal, Gems | Engineering Station | Devices, gadgets, siege equipment |
| **Alchemy** | Potion crafting | **Crafting: Alchemy** | Lore: Herbs, Essences | Alchemy Lab | Potions, flasks, oils, fluxes |
| **Enchanting** | Item enchanting | **Crafting: Runecrafting** | Lore: Magical Essences | Arcane Focus | Rune creation (replaces enchanting) |
| **Inscription** | Glyph crafting | **Crafting: Runecrafting** | Lore: Herbs, Inks | Arcane Focus | Rune creation (replaces inscription) |
| **Jewelcrafting** | Gem crafting | **Crafting: Runecrafting** | Lore: Gems, Metals | Arcane Focus | Rune creation (replaces jewelcrafting) |
| **Cooking** | Food crafting | **Crafting: Cooking** | Lore: [Food Type] | Cooking Fire | Food, buff items (lifeskill) |
| **First Aid** | Bandage crafting | **Crafting: First Aid** | Lore: Cloth | None (portable) | Bandages, healing items (lifeskill) |

## 10.3 Profession Conversion Details

### Gathering Skills

**Mining:**
- **Skill:** Gathering: Mining
- **Material Lore:** Lore: Iron, Lore: Mithril, Lore: Thorium, etc.
- **Progression:** Mine ore → gain Mining skill → unlock Material Lore skills
- **Workstation:** None (gathering in world)

**Herbalism:**
- **Skill:** Gathering: Herbalism
- **Material Lore:** Lore: Peacebloom, Lore: Mageroyal, Lore: Golden Sansam, etc.
- **Progression:** Gather herbs → gain Herbalism skill → unlock Material Lore skills
- **Workstation:** None (gathering in world)

**Skinning:**
- **Skill:** Gathering: Skinning
- **Material Lore:** Lore: Light Leather, Lore: Medium Leather, Lore: Thick Leather, etc.
- **Progression:** Skin creatures → gain Skinning skill → unlock Material Lore skills
- **Workstation:** None (gathering in world)

### Crafting Skills

**Blacksmithing:**
- **Skill:** Crafting: Blacksmithing
- **Material Lore:** Lore: Iron, Lore: Mithril, Lore: Thorium
- **Workstation:** Anvil (weapons), Forge (refining)
- **Products:** Weapons, armor, tools, components

**Leatherworking:**
- **Skill:** Crafting: Leatherworking
- **Material Lore:** Lore: Light Leather, Lore: Medium Leather, Lore: Thick Leather
- **Workstation:** Tanning Rack
- **Products:** Leather armor, bags, components, hilts

**Tailoring:**
- **Skill:** Crafting: Tailoring
- **Material Lore:** Lore: Linen, Lore: Wool, Lore: Silk, Lore: Mageweave
- **Workstation:** Loom
- **Products:** Cloth armor, bags, components, cloth bolts

**Engineering:**
- **Skill:** Crafting: Engineering
- **Material Lore:** Lore: Metal, Lore: Gems
- **Workstation:** Engineering Station
- **Products:** Devices, gadgets, siege equipment, mechanical components

**Alchemy:**
- **Skill:** Crafting: Alchemy
- **Material Lore:** Lore: Herbs, Lore: Magical Essences
- **Workstation:** Alchemy Lab
- **Products:** Potions, flasks, oils, fluxes, refining materials

**Runecrafting (Replaces Enchanting/Inscription/Jewelcrafting):**
- **Skill:** Crafting: Runecrafting
- **Material Lore:** Lore: Magical Essences, Lore: Gems, Lore: Inks
- **Workstation:** Arcane Focus
- **Products:** Runes (replaces enchants, glyphs, gems)
- **Note:** All three professions merge into single Runecrafting skill

### Lifeskills

**Cooking:**
- **Skill:** Crafting: Cooking (Lifeskill)
- **Material Lore:** Lore: [Food Type]
- **Workstation:** Cooking Fire (portable)
- **Products:** Food items, buff consumables
- **Note:** Lifeskill (no profession limit)

## 10.6 Cooking System Details

Cooking is a **lifeskill** (no profession limit) that provides food items for stat buffs, hunger management, and survival gameplay.

### Cooking Skill Progression

**Skill Gains:**
- Gain skill points from successful cooking
- Higher skill = better success rate, quality, buff duration
- Material Lore unlocks at skill milestones (50, 100, 150, 200)

**Material Lore:**
- **Lore: Meat** - Unlocks meat-based recipes
- **Lore: Fish** - Unlocks fish-based recipes
- **Lore: Vegetables** - Unlocks vegetable-based recipes
- **Lore: Spices** - Unlocks advanced recipes with buffs

### Cooking Workstations

**Portable Cooking Fire:**
- Can be placed anywhere (Green/Yellow zones)
- Requires fuel (wood, coal)
- Portable (can be picked up)
- Basic cooking only

**Inn Cooking Fire:**
- Found in inns and taverns
- No fuel required
- Better success rate
- Access to advanced recipes

**Guild Stronghold Kitchen:**
- Found in guild strongholds
- Highest success rate
- Access to all recipes
- Can cook in bulk

### Food Types & Buffs

**Stat Foods:**
- **Strength Food:** +5-15 Strength (30 minutes)
- **Agility Food:** +5-15 Agility (30 minutes)
- **Stamina Food:** +5-15 Stamina (30 minutes)
- **Intellect Food:** +5-15 Intellect (30 minutes)
- **Spirit Food:** +5-15 Spirit (30 minutes)

**Combat Foods:**
- **Attack Power Food:** +10-30 Attack Power (30 minutes)
- **Spell Power Food:** +10-30 Spell Power (30 minutes)
- **Crit Food:** +2-5% Crit Chance (30 minutes)
- **Resistance Food:** +10-30 Resistance (30 minutes)

**Survival Foods:**
- **Hunger Reduction:** Reduces hunger by 20-50%
- **Health Regen:** +5-15 HP/5 sec (30 minutes)
- **Mana Regen:** +5-15 MP/5 sec (30 minutes)
- **Stamina Regen:** +10-30% Stamina regen (30 minutes)

**Travel Foods:**
- **Movement Speed:** +5-10% Movement Speed (30 minutes)
- **Mount Speed:** +5-10% Mount Speed (30 minutes)
- **Swim Speed:** +10-20% Swim Speed (30 minutes)

### Cooking Recipes

**Recipe Sources:**
- Task Board rewards
- Faction vendors (standing-based)
- World drops (rare)
- Crafting discovery (experimentation)
- Regional specialties (zone-specific recipes)

**Recipe Tiers:**
- **Basic Recipes:** Low skill requirement, basic buffs
- **Advanced Recipes:** High skill requirement, strong buffs
- **Master Recipes:** Very high skill requirement, legendary buffs

### Cooking Materials

**Meat:**
- Raw meat from creatures
- Processed meat (requires Cooking skill)
- Regional specialties (zone-specific meat types)

**Fish:**
- Raw fish from Fishing skill
- Processed fish (requires Cooking skill)
- Regional fish types (freshwater, saltwater, deep sea)

**Vegetables:**
- Herbs from Herbalism
- Vegetables from gathering nodes
- Regional specialties (zone-specific vegetables)

**Spices:**
- Rare herbs
- Alchemical ingredients
- Regional spices (zone-specific)

### Food Quality System

**Quality Tiers:**
- **Burnt:** -10% buff effectiveness (failure)
- **Edible:** Standard buffs (success)
- **Well-Cooked:** +10% buff effectiveness (high skill)
- **Perfect:** +20% buff effectiveness (rare success)
- **Masterwork:** +30% buff effectiveness (legendary success)

**Quality Factors:**
- Cooking skill level
- Material Lore level
- Workstation quality
- Recipe difficulty
- RNG roll

### Food Spoilage System

**Spoilage Rules:**
- Food items have durability/expiration
- Food spoils over time (24-48 hours)
- Spoiled food: No buffs, may cause debuffs
- Preservation methods: Salt, smoking, magical preservation

**Preservation:**
- **Salt:** Extends food life by 50%
- **Smoking:** Extends food life by 100%
- **Magical Preservation:** Extends food life by 200% (rare)

### Cooking Integration

**Hunger System:**
- Food reduces hunger
- Hunger affects stamina regen
- Well-fed buffs from quality food
- See `22-healing-and-restoration.md` for hunger mechanics

**Economy Integration:**
- Food items tradeable
- Regional food specialties
- Market stall food sales
- Caravan food transport

**Social Integration:**
- Tavern food service
- Guild feast events
- Cooking contests
- Food sharing (party buffs)

**First Aid:**
- **Skill:** Crafting: First Aid (Lifeskill)
- **Material Lore:** Lore: Cloth
- **Workstation:** None (portable crafting)
- **Products:** Bandages, healing items
- **Note:** Lifeskill (no profession limit)

**Fishing:**
- **Skill:** Gathering: Fishing (Lifeskill)
- **Material Lore:** Lore: [Fish Type]
- **Workstation:** None (fishing in world)
- **Products:** Fish, cooking materials
- **Note:** Lifeskill (no profession limit)

## 10.4 Skill Limits & Progression

**No Profession Limits:**
- Players can learn all gathering skills
- Players can learn all crafting skills
- No "2 profession limit" (classless system)

**Skill Caps:**
- Gathering skills: 400 skill points max
- Crafting skills: 400 skill points max
- Material Lore skills: 200 skill points max per material

**Skill Progression:**
- Gain skill points from successful actions
- Higher skill = better success rate, quality, yield
- Material Lore unlocks at skill milestones (50, 100, 150, 200)

## 10.5 Recipe Conversion Strategy

**Original Recipes → Mortal Recipes:**
- All recipes converted to skill-based requirements
- Level requirements removed
- Material Lore requirements added
- Workstation requirements added
- Quality system replaces recipe tiers

**Recipe Sources:**
- Task Board rewards
- Faction vendors (standing-based)
- World drops (rare)
- Crafting discovery (experimentation)
- Blueprint Originals/Copies

---

# 11. Crafting Progression

## 11.1 Skill Gains
Gains scale by:
- Difficulty  
- Workstation tier  
- Material tier  
- Tool quality  

## 10.2 Soft Caps
- 100: Beginner mastery  
- 200: Advanced crafting  
- 300+: Rare specialization  
- 400+: Legendary-tier crafting  

---

# 11. Economic Integration

Crafting is tied tightly to the economy via:
- Regional scarcity  
- Blueprint Originals (permanent)  
- Blueprint Copies (consumable)  
- Workstation placement  
- Upkeep costs  
- Resource decay  
- Guild taxation  
- Seasonal changes  

---

# 12. Implementation Summary

## 12.1 C++ Files
- `MortalCraft.cpp`
- `DecayHooks.cpp`
- `CraftingStats.h`

## 12.2 Lua Files
- `MortalCraftingWorkstation.cpp/h` (C++ implementation)
- `MortalMaterialLore.cpp/h` (C++ implementation)
- `MortalDurabilityDecay.cpp/h` (C++ implementation)
- `procedural_quality.lua`

## 12.3 SQL Files
- `schema_crafting_materials.sql`
- `schema_crafting_components.sql`
- `schema_blueprints.sql`
- `material_lore_skills.sql`

---

# 13. Status
This subsystem is considered **Core** and is one of the main endgame gameplay loops.
