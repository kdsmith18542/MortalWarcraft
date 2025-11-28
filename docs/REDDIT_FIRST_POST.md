# Mortal Warcraft: A Classless, Skill-Based Sandbox MMO

**Mortal Warcraft** is a complete overhaul of AzerothCore 3.3.5a (WotLK), transforming the WotLK-era world into a classless, skill-based sandbox MMO that combines elements from Mortal Online, EVE Online, and Runescape within WoW's polished framework.

---

## Core Design Philosophy

Mortal Warcraft eliminates traditional class and experience point systems in favor of skill-based progression. Character power is derived from over 1,200 skill points across combat, gathering, and crafting disciplines. Derived Level (1-25) is calculated as `MIN(25, FLOOR(Total_Primary_Skill_Points / 48))`.

The world is divided into three risk tiers:
- **Green Zones**: Safe areas with no PvP and no item drops on death
- **Yellow Zones**: Mid-risk areas with criminal flagging on aggression and partial loot (equipped items protected)
- **Red Zones**: Full-loot PvP zones with teleport restrictions and no safe areas

---

## Technical Architecture

**Core Foundation:**
- **Engine**: AzerothCore 3.3.5a (WotLK client compatibility)
- **Language**: C++ modules for performance-critical systems (combat, movement, spawn controllers, anti-cheat)
- **Scripting**: Lua for UI bridges, quest/gossip wrappers, configuration tables, and rapid prototypes
- **Database**: MySQL with complete Mortal schema (109 specification documents)
- **Client**: Custom MortalUI addon suite, Rust/Tauri launcher, DBC modifications

**Stat Calculation Pipeline:**
Seven-step process: Base Stats → Gear Modifiers → Rune Bonuses → Buff/Debuff Modifiers → Individual Attribute Clamp (150 per stat) → Total Attribute Clamp (400 total, proportional overflow normalization) → Derived Stats (HP, Mana, AP, SP, Crit, Mitigation).

**Combat Formulas:**
- Hit Chance: `BaseHitChance + (WeaponSkill - TargetDefense) * 0.04`
- Critical Strike: `BaseCrit + (Agility / 20) + (WeaponSkill / 100)`
- Damage: `(BaseDamage + AP/SP * Coefficient) * MaterialMultiplier * QualityMultiplier`
- Brace Mechanic: 50% damage reduction on successful timing-based defense
- Guard Counter: Perfect block triggers empowered counter-attack

**Economy Systems:**
- Regional banking: Separate `mortal_regional_bank` tables per city/region
- Market stalls: Player-owned vendors with physical locations and rental systems
- NPC Buy Orders: Dynamic buy order generation with regional price variation
- Hot Zones: Weekly rotating economic bonuses (1.2x-1.5x multipliers)
- Blessed Items: Soft insurance system (5 gold, 7-day duration, 3 charges)

---

## Key Systems

### Progression
- **Skill-Based Advancement**: Skills level through use with diminishing returns
- **Attribute System**: Individual cap 150, total cap 400 (proportional overflow normalization algorithm)
- **Mentor System**: PvE-only scaling (`ScaleFactor = TargetLevel / ActualLevel`) applied to HP, Damage, AP, SP, Mitigation
- **Mastery Trees**: Warlord, Guardian, Explorer trees with active and passive abilities

### Crafting
- **Material Lore**: Skill-based knowledge system affecting quality scores
- **Quality Calculation**: `(CrafterSkill + MaterialLore + WorkstationTier*10 + RNG) - ItemDifficulty`
- **Quality Tiers**: Shoddy (<0), Common (0-50), Fine (51-100), Superior (101-150), Exceptional (151-200), Masterwork (201-250), Legendary (251+)
- **Durability Decay**: Permanent durability loss on death and use
- **Failure Mechanics**: Skill deficit (+1% per point below required, max 50%), wrong workstation (+30%), missing flux/oils (+15%)

### PvP & Justice
- **Notoriety System**: Tracks player kills, triggers Criminal state (3+ kills) and Outlaw state (10+ kills)
- **Bounty System**: 25% of Outlaw's gold on death goes to bounty pot, claimable by other players
- **Anti-Zerg**: Damage reduction for outnumbered players in group combat
- **Guild Wars**: Formal war declarations bypass Notoriety penalties

### Guilds & Sovereignty
- **Strongholds**: Guild-owned structures with 5 levels, generating resources and taxation
- **Siege System**: Wintergrasp-adapted siege mechanics with infantry-first design
- **Territory Control**: Control points, taxation systems, regional buffs
- **Guild Storage**: Stronghold-based storage (1-5 tabs by level, regional access restrictions)

### World Systems
- **Ecosystem Simulation**: Predator-prey logic, migration events, alpha variants, mythic variants
- **Weather System**: Rain, fog, blizzard with gameplay modifiers
- **Anomalies & Rifts**: Micro-dungeons (signature scanning), planar rifts (zone invasions), hellgates (PvPvE instances)
- **Zone Invasions**: Midnight Horde events, zone state system (NEUTRAL, HOT, INVADED, OCCUPIED, PURGED)

---

## Content Systems

**PvE:**
- Public Dungeons (Delves): Open-world dungeons with M-T1 through M-T5 NPC tiers
- Extraction Raids: All raids converted to extraction raids requiring cursed artifact transport
- Task Boards: Procedurally generated tasks with dynamic reward scaling (`EffectiveReward = BaseReward * DifficultyMultiplier * RiskMultiplier * RegionModifier`)
- Endless Contracts: Wave-based defense and survival content

**PvP:**
- Warfronts: Instanced battlegrounds with full loot (Alterac Valley, Isle of Conquest, Arathi Basin conversions)
- Siege Warfare: Stronghold sieges with preparation contracts, signup flow, infantry-first design
- Arena System: Rating-based arena with Military Credits rewards

---

## Implementation Status

**Core Systems (Production Ready - 82%):**
- ✅ Progression & Stats Foundation
- ✅ Risk Zones & Death/Loot Rules
- ✅ Economy & Regional Banking
- ✅ Crafting & Material Lore
- ✅ PvP Systems & Notoriety
- ✅ Combat Formulas & Stat Pipeline
- ✅ Skill System & Attribute Caps
- ✅ Mentor System
- ✅ NPC Buy Orders, Hot Zones, Blessed Items
- ✅ Navigation & POI System

**Advanced Features (In Progress):**
- 🚧 Guilds & Sovereignty (Strongholds, Sieges)
- 🚧 World Simulation (Ecosystem, Weather, Seasons)
- 🚧 Anomalies & Rifts
- 🚧 Faction Systems (4 Major + 4 Meta Factions)
- 🚧 Extraction Raids

**Content Creation (Planned):**
- 📝 Campaign Quests (5-act campaign)
- 📝 Faction Quests
- 📝 Dynamic Task Generation
- 📝 Itemization ETL Pipeline

---

## Documentation

The project is documented through **109 specification documents** covering all systems, formulas, database schemas, and implementation details. Core documentation includes progression systems, combat mechanics, economy design, crafting depth, PvP systems, guild sovereignty, world simulation, and content creation pipelines.

---

## Discussion

This subreddit serves as a forum for discussion, feedback, and community engagement regarding Mortal Warcraft's development, systems design, and implementation progress. Technical questions, design feedback, and feature requests are welcome.

---

**Summary:** Mortal Warcraft is a classless, skill-based sandbox MMO built on AzerothCore 3.3.5a, featuring full-loot PvP zones, regional economy, deep crafting systems, and guild sovereignty. Core systems are 82% complete and production-ready. The project emphasizes player-driven economy, meaningful risk/reward, and emergent gameplay through world systems.
