# Project Canvas: Mortal Warcraft Overhaul
### Version 26.1 — Hybrid Technical Design Document
### File: 02-combat.md
### Section: Combat, PvP, Crime, and Justice Systems

# 1. Overview
Combat in Mortal Warcraft is a hybrid between WoW’s responsive tab-target system 
and Mortal Online’s risk-oriented, timing-dependent combat.

This document defines:
- Combat formulas
- Brace mechanic
- PvP rules
- Crime system
- Outlaw state
- Bounty mechanics
- Friendly fire rules
- Loot rules by zone
- Implementation notes

---

## Related Specs

For full context on combat systems, see:

- **`84-mortal-core-stats-and-combat-model.md`** — Core stat formulas (AP, SP, HP, Mana, Crit) used in combat calculations
- **`03-risk-zones.md`** — Zone-based PvP rules, loot rules, and outlaw restrictions referenced throughout this document
- **`11-pvp-systems.md`** — Extended PvP mechanics, warfronts, and siege systems
- **`56-negative-titles-and-notoriety-labels.md`** — Notoriety system that triggers Outlaw state and affects crime penalties
- **`01-progression.md`** — Derived level system and skill mastery that affect combat effectiveness
- **`75-mortal-gear-and-runes-spec.md`** — Gear and runes that modify combat capabilities

**⚠️ IMPLEMENTATION GAP: Missing Integration Between Combat Formulas and Gear System**
- **Status**: Both systems exist but integration not fully specified
- **Need**: How gear stats integrate with base combat formulas (damage, hit/miss, crit, etc.)
- **Recommendation**: Document integration points: gear stats → base formulas, rune modifiers → combat calculations, stat calculation order
- **Impact**: Combat formulas and gear system may not integrate correctly
- **`64-spell-and-ability-library.md`** — Spell and ability definitions used in combat

---

# 2. Core Combat Philosophy

1. **Player skill > gear power**
2. **Combat readability > complexity**
3. **Risk must be clear at all times**
4. **Time-to-kill must allow reaction**
5. **Every fight has a winner & a story**

---

# 3. Combat Formulas

## 3.1 Damage

Final damage is calculated as:
```
FinalDamage = (BaseWeaponDamage + StatScaling + SkillBonus) * MaterialMultiplier
```

### 3.1.1 Damage Formula Components

**BaseWeaponDamage:**
- Derived from weapon's base damage stats (DPS × weapon speed)
- For unarmed: 10.0 base damage

**StatScaling:**
- Melee weapons: `Strength * 0.5`
- Ranged/Spell weapons: `Intellect * 0.5`
- 1 point of stat = 0.5 damage

**SkillBonus:**
- `WeaponMasterySkill * 0.1`
- 1 point of weapon mastery skill = 0.1 damage

**MaterialMultiplier:**
- Based on material tier (M-T0 to M-T5) used to craft the weapon
- See Material Multiplier Table below

### 3.1.2 Material Multiplier Formula

The material multiplier is determined by the **material tier** (M-T0 through M-T5) used to craft the weapon. Material tiers are defined in `19-itemization.md` and `05-crafting.md`.

**Material Multiplier Table:**

| Material Tier | Multiplier | Damage Bonus | Notes |
|---------------|------------|--------------|-------|
| M-T0 (Scraps) | 0.8 | 80% | Starter/scrap materials |
| M-T1 (Basic) | 1.0 | 100% | Basic crafted gear |
| M-T2 (Advanced) | 1.1 | 110% | Advanced crafted/dungeon-grade |
| M-T3 (Raid-Grade) | 1.2 | 120% | High-tier crafted/raid-grade |
| M-T4 (Legendary) | 1.3 | 130% | Legendary/seasonal prestige |
| M-T5 (Relic) | 1.5 | 150% | Pinnacle prestige gear |

**Formula:**
```
MaterialMultiplier = 0.8 + (MaterialTier * 0.1)
// Where MaterialTier: 0 (M-T0) to 5 (M-T5)
```

**Fallback for Non-Crafted Items:**
For items that don't have material tier data, the multiplier defaults based on item quality:
- Poor: 0.8
- Normal: 1.0
- Uncommon: 1.1
- Rare: 1.2
- Epic: 1.3
- Legendary: 1.5

### 3.1.3 Complete Damage Calculation Example

**Example: Level 10 Player with M-T2 Sword**
```
BaseWeaponDamage = 25.0 (from weapon stats)
Strength = 50
StatScaling = 50 * 0.5 = 25.0
WeaponMasterySkill = 60
SkillBonus = 60 * 0.1 = 6.0
MaterialMultiplier = 1.1 (M-T2)

FinalDamage = (25.0 + 25.0 + 6.0) * 1.1 = 61.6 damage
```

## 3.2 Hit/Miss

Hit chance is derived from:
- Player's derived level (1–25)
- Weapon Mastery skill
- Target's derived level (for players) or level (for NPCs)

**Goal:** Level 1 can hit Level 25 with reduced chance, but never "0%".

### 3.2.1 Hit Chance Formula

```
HitChance = BaseHitChance + LevelPenalty + MasteryBonus
```

Where:
- **BaseHitChance**: 95% (0.95)
- **LevelPenalty**: `-2% per level difference` (attacker level - target level), maximum -50%
- **MasteryBonus**: `+0.1% per weapon mastery skill point`, maximum +10% at 100 skill

### 3.2.2 Formula Components

**Base Hit Chance:**
```
BaseHitChance = 0.95 (95%)
```

**Level Difference Penalty:**
```
LevelDiff = AttackerLevel - TargetLevel
LevelPenalty = max(-0.50, LevelDiff * -0.02)
// -2% per level difference, capped at -50%
```

**Weapon Mastery Bonus:**
```
MasteryBonus = min(0.10, WeaponMastery * 0.001)
// +0.1% per skill point, capped at +10% at 100 skill
```

**Final Hit Chance:**
```
HitChance = clamp(0.05, 1.0, BaseHitChance + LevelPenalty + MasteryBonus)
// Minimum 5%, maximum 100%
```

### 3.2.3 Examples

**Example 1: Level 1 vs Level 25 (No Mastery)**
```
BaseHitChance = 0.95
LevelPenalty = (1 - 25) * -0.02 = -0.48 (capped at -0.50)
MasteryBonus = 0.0
HitChance = max(0.05, 0.95 - 0.50 + 0.0) = 0.45 (45%)
```

**Example 2: Level 10 vs Level 10 (50 Mastery)**
```
BaseHitChance = 0.95
LevelPenalty = (10 - 10) * -0.02 = 0.0
MasteryBonus = min(0.10, 50 * 0.001) = 0.05
HitChance = max(0.05, 0.95 + 0.0 + 0.05) = 1.0 (100%)
```

**Example 3: Level 20 vs Level 15 (100 Mastery)**
```
BaseHitChance = 0.95
LevelPenalty = (20 - 15) * -0.02 = -0.10
MasteryBonus = min(0.10, 100 * 0.001) = 0.10
HitChance = max(0.05, 0.95 - 0.10 + 0.10) = 0.95 (95%)
```

**Example 4: Level 5 vs Level 25 (25 Mastery)**
```
BaseHitChance = 0.95
LevelPenalty = (5 - 25) * -0.02 = -0.40
MasteryBonus = min(0.10, 25 * 0.001) = 0.025
HitChance = max(0.05, 0.95 - 0.40 + 0.025) = 0.575 (57.5%)
```

## 3.3 Crit Chance
```
CritChance = Agility / 20
```
Max ~7.5%. Creates stable numbers without runaway crit meta.

## 3.4 Health
```
MaxHP = 50 + (Stamina * 10)
```

## 3.5 Mana / Energy
```
Mana = 100 + (Intellect * 10)
Energy = fixed 100
```

---

# 4. Brace Mechanic (Skill Expression Layer)

### 4.1 Description
**Brace** is a universal timing-based defensive skill.

### 4.2 Function
```
Reduces incoming damage by 50% for 0.75 seconds.
Cooldown = 5 sec.
Off-GCD.
```

### 4.3 Purpose
- Adds reaction-based gameplay  
- Helps solo players survive ambushes  
- Separates skilled players from zergs  

### 4.4 Implementation (Lua)
`MortalBraceMechanic.cpp/h` (C++ implementation):
- Register spell ID
- Monitor timestamps
- Apply 50% reduction via aura

---

# 5. PvP System

## 5.1 Zone-Based PvP
Defined fully in `03-risk-zones.md` but summarized:

- **Green**: No PvP  
- **Yellow**: Mid-risk PvP, partial loot  
- **Red**: Full loot, FFA  

## 5.2 Flag States
- Innocent  
- Criminal  
- Outlaw  
- War Hostile (Guild War)  

---

# 6. Crime System

## 6.1 Criminal Flag
Player becomes **Criminal** for:
- Attacking an Innocent in Yellow zones
- Healing a Criminal
- Performing theft/pickpocket

Duration: **15 minutes**

## 6.2 Criminal Penalties
- Guards attack on sight
- Drops **all gear** on death (full loot), even in Yellow
- Gains double Notoriety for unfair fights (5v1)

---

# 7. Outlaw System (Advanced Justice)

Outlaw = hard criminal state that restricts access to civilization.

## 7.1 Threshold

Outlaw triggered when:
```
Notoriety >= OUTLAW_THRESHOLD
```

**Default Outlaw Threshold: 10 notoriety points**

The threshold is configurable via feature flag `notoriety.threshold.outlaw`, but defaults to **10 notoriety points** if not set.

**Notoriety Tiers:**
- **Suspect**: 1+ notoriety (minor suspicion)
- **Criminal**: 2+ notoriety (criminal flag, 15 minutes)
- **Outlaw**: 10+ notoriety (restricted from Green zones, cannot use banks/markets)
- **Infamous**: 20+ notoriety (extreme notoriety, maximum restrictions)

**Tuning Notes:**
- Lower threshold (5-7): More restrictive, faster progression to outlaw state
- Higher threshold (15-20): More lenient, allows more criminal activity before restrictions
- Default 10 balances between allowing some criminal activity and preventing abuse

## 7.2 Outlaw Restrictions
- Cannot enter Green Zones (capital guards kill instantly)
- Cannot use:
  - Banks
  - Market stalls
  - Crafting stations
- Must use outlaw encampments for services

## 7.3 Reversion

Outlaws can reduce their notoriety through:

### 7.3.1 Passive Notoriety Decay

**Default Decay Rate: 1 notoriety point per day**

Notoriety decays automatically over time:
```
Notoriety = max(0, Notoriety - (DecayRate * DaysPassed))
```

Where:
- **DecayRate**: Configurable via feature flag `notoriety.decay.rate` (default: 1 point/day)
- **DaysPassed**: Number of full days since last update
- **Minimum**: Notoriety cannot go below 0

**Decay Calculation:**
- Decay is calculated when notoriety is queried
- Only applies if at least 1 full day (86400 seconds) has passed
- Decay is applied in full-day increments (no partial day decay)

**Example:**
- Player has 15 notoriety, last updated 3 days ago
- Decay: 15 - (1 * 3) = 12 notoriety
- If still >= 10, player remains Outlaw

### 7.3.2 Active Notoriety Reduction

Players can actively reduce notoriety through:
- **Penance Quests**: Courier contracts, slaying monsters (reduces 1-3 notoriety per quest)
- **Paying Fines**: In capital cities (dangerous for outlaws, reduces 5-10 notoriety)
- **Time Served**: Passive decay while offline or avoiding criminal activity

---

# 8. Bounty System

## 8.1 Bounty Pot

When an Outlaw kills an Innocent player:
```
BountyAdded = VictimRepairCost * BOUNTY_PERCENTAGE
```

**Default Bounty Percentage: 25% of victim's repair cost**

The percentage is configurable via feature flag `bounty.percentage`, but defaults to **25%** if not set.

**Bounty Accumulation:**
- Only applies when an **Outlaw** (notoriety >= 10) kills an **Innocent** player
- Bounty is added to the Outlaw's total bounty pot
- Bounty persists until the Outlaw is killed or notoriety drops below threshold
- Multiple kills accumulate: TotalBounty = Sum of all individual bounties

**Repair Cost Calculation:**
- Based on victim's equipped gear durability loss
- Uses standard WoW repair cost formula
- Only counts gear that was damaged in the fight

**Example:**
- Outlaw kills Innocent player
- Victim's repair cost: 50 gold
- Bounty added: 50 * 0.25 = 12.5 gold (rounded to 13 gold)
- Outlaw's total bounty: 13 gold

**Tuning Notes:**
- Lower percentage (15-20%): Smaller bounties, less economic impact
- Higher percentage (30-50%): Larger bounties, more incentive to hunt outlaws
- Default 25% balances between meaningful rewards and economic stability

## 8.2 Claiming a Bounty
Killing an Outlaw in Yellow/Red zones:
- Grants 100% of bounty
- Awards reputation
- Unlocks cosmetic titles (e.g., Witch Hunter)

---

# 9. Friendly Fire & Group Combat

## 9.1 Red Zones
- Friendly Fire ENABLED  
- Healing an enemy flags you Criminal  
- Group positioning becomes vital  

## 9.2 Yellow Zones
- Friendly Fire DISABLED  
- Healing a Criminal flags you Criminal  

---

# 10. Loot Rules

## 10.1 Green Zones
- No death loot  
- 0 gear loss  

## 10.2 Yellow Zones (Mid-Risk)
### Innocent Death:
- **Keep:**  
  - Weapon  
  - Chest  
  - Mount reins  
  - 1 trinket  
- **Drop:**  
  - All inventory  
  - All consumables  
  - All non-protected slots  

### Criminal Death:
- Drops **everything**  
- Treated like Red-zone kill

## 10.3 Red Zones (Full Risk)
- Always drop all items  
- Corpse chest spawns  
- 10s border grace on entering

---

# 11. Combat Roles (No Classes)

Roles emerge from:
- Stat distribution  
- Mastery Trees  
- Gear weight/material  
- Skill specialization  

Examples:
- Light duelist  
- Heavy frontline  
- Ranged skirmisher  
- Stealth assassin  
- Mounted lancer  

---

# 12. Anti-Zerg Mechanics

## 12.1 Zerg Detection
If 5+ players kill one player:
- All attackers gain **double Notoriety**
- Reduced loot quality from repeated kills of same target

## 12.2 Purpose
Prevents “MO2 bully squads” who ruin retention.

---

# 13. Implementation Notes

## 13.1 C++ Files
- `MortalCombat.cpp`
- `MortalDamage.h`
- `MortalLevel.h`  
- `Player::KillHook()`

## 13.2 C++ Implementation Files
**Note:** Performance and security-critical systems are implemented in C++ rather than Lua for better performance and security.

- `MortalBraceMechanic.cpp/h` (Brace mechanic - performance critical)
- `MortalCrimeSystem.cpp/h` or `MortalCriminalContracts.cpp/h` (Crime system - security critical)
- `MortalOutlawRestrictions.cpp/h` (Outlaw restrictions - security critical)
- `MortalBountyPot.cpp/h` (Bounty pot - security critical)
- `MortalCombatFlags.cpp/h` (Combat flags - performance critical)

## 13.3 SQL
- `bounty_pot.sql`
- `notoriety_table.sql`
- `criminal_flags.sql`

---

# 14. Status
Combat & PvP systems are **Core & Stable** for expansion.
