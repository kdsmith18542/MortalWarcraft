# Project Canvas: Mortal Warcraft Overhaul
### Version 26.1 — Hybrid Technical Design Document
### File: 01-progression.md
### Section: Character Progression & Skill Systems

# 1. Overview
Character progression in Mortal Warcraft is entirely classless and skill-based, 
inspired by Runescape, Mortal Online, and Ultima Online. All combat and 
non-combat power comes from skills that level through use.

This file details:
- Skill Categories
- Derived Level Formula
- Attribute Caps
- Mastery Trees
- Mentor System (Early Respec Protection)
- Progression pacing

---

## Related Specs

For full context on progression systems, see:

- **`84-mortal-core-stats-and-combat-model.md`** — Attribute caps (150 per stat, 400 total) and how attributes translate to combat power
- **`47-mentoring-and-build-loadouts.md`** — Extended mentor system, build presets, and loadout management
- **`88-mortal-progression-era-map.md`** — Progression eras and skill band definitions used for content gating
- **`02-combat.md`** — How skills and derived level affect combat effectiveness
- **`75-mortal-gear-and-runes-spec.md`** — How progression unlocks gear tiers and rune access
- **`52-season-of-the-frontier.md`** — Season Renown system (meta-progress, separate from skill progression)

---

# 2. Skill System

## 2.1 Total Skill Capacity
- Characters may earn **up to 1,200 Skill Points**.
- Skills increase through usage.
- No XP, no quests granting power **(all combat power comes from skills and attributes). Meta-progress tracks like Seasons or Codex reputation may grant cosmetic/social rewards only and must never modify combat stats.**

## 2.2 Skill Categories
### Combat Skills
- Weapon Mastery (Swords, Axes, Maces, Spears)
- Ranged Mastery (Bows, Crossbows)
- Defense
- Blocking
- Parrying
- Magic Affinity (Arcane, Fire, Frost, Shadow)

### Gathering Skills
- Mining
- Herbalism
- Lumberjacking
- Skinning
- Fishing

### Crafting Skills
- Blacksmithing
- Leatherworking
- Alchemy
- Carpentry
- Material Lore (per material type)

### Utility Skills
- Stealth
- Lockpicking
- Pickpocket
- Riding
- Encumbrance Training

# 3. Derived Level System

## 3.1 Formula
```
Derived_Level = MIN(25, FLOOR(Total_Primary_Skill_Points / 48))
```

- Minimum Level: 1
- Maximum Level: 25

## 3.2 Purpose
- Keeps stat scaling tight.
- Level gap never becomes oppressive.
- Level communicates “general progression,” not class power.

# 4. Attributes

## 4.1 Attribute Pool
Players distribute points in:
- Strength
- Agility
- Stamina
- Intellect
- Spirit

## 4.2 Attribute Rules
- **Max 150** in any single stat.
- **Max 400** total attribute points.

Enforced by:
- C++: `MortalLevel.h` with attribute cap logic.

# 5. Mastery Trees

## 5.1 Overview
Mastery Trees replace talents and provide:
- Passive bonuses
- Unique skill interactions
- Utility enhancements

## 5.2 Categories
- **Warlord** (Offense)
- **Guardian** (Defense)
- **Explorer** (Utility/Survival)

## 5.3 Points Awarded
```
1 Mastery Point per 50 Skill Points earned
```
(Up to 24 total)

# 6. Mentor System (Early Respec Safety)

## 6.1 Purpose
Prevent new players from “bricking” their character.

## 6.2 Rules
- Free attribute and skill respecs until **200 Skill Points** (~Level 4).
- Mentor NPC explains:
  - Attribute limits
  - Mastery Trees
  - Skill synergy
  - Risk of specialization

# 7. Progression Pacing

## 7.1 Skill Gains

Each skill has a chance to increase on relevant actions. Gains scale with:
- Difficulty of action
- Player's current skill
- Weapon/tool tier

### 7.1.1 Base Skill Gain Formula

The core skill gain formula is:

```
SkillGain = BaseGain * DiminishingReturnsMultiplier * DifficultyModifier * TierModifier
```

Where:
- **BaseGain**: Base skill points per action (varies by skill type)
- **DiminishingReturnsMultiplier**: Reduces gain as skill increases
- **DifficultyModifier**: Bonus for challenging actions
- **TierModifier**: Bonus for using higher-tier weapons/tools

### 7.1.2 Base Gain Values by Skill Type

| Skill Category | Base Gain | Notes |
|---------------|-----------|-------|
| Combat Skills | 0.1 | Per successful hit |
| Gathering Skills | 0.3-0.5 | Mining/Herbalism: 0.5, Skinning: 0.3, Fishing: 0.4, Lumberjacking: 0.5 |
| Crafting Skills | 0.3-0.4 | Per successful craft |
| Utility Skills | 0.2-0.3 | Stealth: 0.2, Lockpicking: 0.3, Pickpocket: 0.2 |

### 7.1.3 Diminishing Returns Multiplier

The diminishing returns formula ensures skills slow down as they increase:

```
If CurrentSkill <= 100:
    DiminishingReturnsMultiplier = 1.0

Else If CurrentSkill <= 200:
    DiminishingReturnsMultiplier = 1.0 - ((CurrentSkill - 100) / 200.0)
    // Linear reduction from 1.0 at 100 to 0.5 at 200

Else If CurrentSkill <= 300:
    DiminishingReturnsMultiplier = 0.5 * (1.0 - ((CurrentSkill - 200) / 200.0))
    // Further reduction from 0.5 at 200 to 0.25 at 300

Else:
    DiminishingReturnsMultiplier = 0.25
    // Minimum 25% of base gain at 300+
```

**Examples:**
- Skill 50: 100% gain (1.0 multiplier)
- Skill 100: 100% gain (1.0 multiplier)
- Skill 150: 75% gain (0.75 multiplier)
- Skill 200: 50% gain (0.5 multiplier)
- Skill 250: 37.5% gain (0.375 multiplier)
- Skill 300: 25% gain (0.25 multiplier)
- Skill 400: 25% gain (0.25 multiplier, minimum)

### 7.1.4 Difficulty Modifier

The difficulty modifier rewards challenging actions:

**For Combat Skills:**
```
If TargetLevel > PlayerLevel:
    DifficultyModifier = 1.0 + ((TargetLevel - PlayerLevel) * 0.1)
    // +10% per level above player
Else:
    DifficultyModifier = 1.0
```

**For Gathering/Crafting Skills:**
```
If RequiredSkill > CurrentSkill:
    DifficultyModifier = 1.0 + ((RequiredSkill - CurrentSkill) / 50.0)
    // Bonus for gathering/crafting above current skill
Else:
    DifficultyModifier = 1.0
```

### 7.1.5 Tier Modifier

Higher-tier weapons/tools provide bonus skill gain:

```
TierModifier = 1.0 + (ItemTier * 0.1)
// +10% per tier (M-T0 = 0, M-T1 = 0.1, M-T2 = 0.2, etc.)
```

**Example:** Crafting with M-T3 materials gives 30% bonus skill gain.

### 7.1.6 Complete Formula Examples

**Combat Skill Gain (Player Level 10, Target Level 15, Skill 50):**
```
BaseGain = 0.1
DiminishingReturnsMultiplier = 1.0 (skill <= 100)
DifficultyModifier = 1.0 + (15 - 10) * 0.1 = 1.5
TierModifier = 1.0 (assuming no tier bonus)
SkillGain = 0.1 * 1.0 * 1.5 * 1.0 = 0.15 skill points
```

**Gathering Skill Gain (Skill 150, Required 180, M-T2 tool):**
```
BaseGain = 0.5 (Mining)
DiminishingReturnsMultiplier = 0.75 (skill 150)
DifficultyModifier = 1.0 + (180 - 150) / 50.0 = 1.6
TierModifier = 1.0 + (2 * 0.1) = 1.2
SkillGain = 0.5 * 0.75 * 1.6 * 1.2 = 0.72 skill points
```

**Crafting Skill Gain (Skill 250, Required 240, M-T4 materials):**
```
BaseGain = 0.3
DiminishingReturnsMultiplier = 0.375 (skill 250)
DifficultyModifier = 1.0 (required <= current)
TierModifier = 1.0 + (4 * 0.1) = 1.4
SkillGain = 0.3 * 0.375 * 1.0 * 1.4 = 0.1575 skill points
```

## 7.2 Diminishing Returns Summary
- Skills 1-100: Full gain (100%)
- Skills 101-200: Linear reduction (100% → 50%)
- Skills 201-300: Further reduction (50% → 25%)
- Skills 300+: Minimum gain (25%)

# 8. Skill Trainer System

## 8.1 Trainer System Redesign

Original WoW **Class Trainers** are converted to **Skill Trainers** that support Mortal's classless, skill-driven progression system.

### 8.1.1 Skill Trainers

**Conversion from Class Trainers:**
- Replace class trainers with skill trainers
- Trainers teach specific skill categories (Combat, Gathering, Crafting, Utility)
- Regional specialization (some trainers better for certain skills)
- Supports player-driven economy (trainers create travel demand)

**Trainer Services:**
- **Skill Training**: Basic skills (starter skills for new players)
- **Skill Respec**: Limited, costly respecs (economy sink)
- **Skill Information**: Guidance on skill progression and synergies
- **Skill Books**: Purchase skill books for advanced techniques

### 8.1.2 Regional Specialization

**Trainer Placement by Zone Risk:**

**Green Zones:**
- **Basic Trainers**: Teach fundamental skills
- **All Skill Categories**: Combat, Gathering, Crafting, Utility
- **Safe Access**: No risk, full trainer access
- **Standard Pricing**: Normal training costs

**Yellow Zones:**
- **Specialized Trainers**: Advanced skills, specific specializations
- **Limited Categories**: Focused on specific skill types
- **Moderate Risk**: Some risk accessing trainers
- **Higher Pricing**: Slightly higher training costs

**Red Zones:**
- **Outlaw Trainers**: Risky but powerful training
- **Advanced Techniques**: Unique skills not available elsewhere
- **High Risk**: Full-loot PvP risk accessing trainers
- **Premium Pricing**: Expensive training costs
- **Outlaw Access**: Only accessible to outlaws or high-risk players

### 8.1.3 Economy Integration

**Training Costs:**
- Training costs gold (economy sink)
- Advanced training costs more
- Respecs are expensive (prevents abuse)
- Creates travel demand (players must visit trainers)

**Regional Economy:**
- Players must travel to access trainers
- Creates demand for caravan escorts (Yellow/Red zone trainers)
- Supports regional economy (different trainers by region)
- Creates meaningful choices (safe vs. risky training)

### 8.1.4 Implementation

**Trainer NPCs:**
- Convert class trainer NPCs to skill trainers
- Trainer NPCs check zone risk before allowing training
- Trainer NPCs check player notoriety (outlaws restricted in Green zones)
- Trainer NPCs provide skill information and guidance

**Database:**
- Trainer definitions in `creature_template`
- Trainer services in `npc_trainer` table
- Skill training costs in trainer configuration
- Regional trainer placement in zone configuration

**Integration:**
- Works with skill system (trainers teach skills)
- Supports faction system (faction standing affects trainer access)
- Creates economy opportunities (training costs, travel demand)
- Supports regional economy (different trainers by region)

---

# 9. Implementation Notes

## 9.1 C++ Hooks
- `Player::GetLevel()` overridden.
- `MortalAdvanceSkill()` handles caps & gain logic.
- `MortalSkillTrainer.cpp/h` (Skill trainer system)

## 9.2 Lua Scripts
- `MortalCombatSkills.cpp/h` (C++ implementation)
- `MortalGatheringSkills.cpp/h` (C++ implementation)
- `MortalCraftingSkills.cpp/h` (C++ implementation)
- `mentor_system.lua`
- `skill_trainer_system.lua`

# 9. Status
This subsystem is considered **Core & Stable** for all future design.
