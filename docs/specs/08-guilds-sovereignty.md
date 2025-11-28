# Project Canvas: Mortal Warcraft Overhaul
### Version 26.1 — Hybrid Technical Design Document  
### File: 08-guilds-sovereignty.md  
### Section: Guilds, Strongholds, Territory Control, Sieges & Politics

---

# 1. Overview

The Guild & Sovereignty system is the backbone of Mortal Warcraft’s endgame.  
Inspired by **EVE Online**, **Lineage 2**, **Albion Online**, and **Mortal Online 1**, this system creates:

- Guild-owned **Strongholds**  
- **Territory Control Points** across the world  
- **Seasonal map resets**  
- **Guild taxation & resource shipments**  
- **Siege warfare with vulnerability windows**  
- **Guild halls & instanced HQs**  
- **Political systems (alliances, wars, betrayals)**  

This document defines every layer.

---

## Related Specs

For full context on guild and sovereignty systems, see:

- **`92-mortal-warfronts-siege-flow.md`** — Siege warfare and warfront systems used by guilds
- **`97-mortal-guild-war-and-alliances.md`** — Guild war mechanics and alliance systems
- **`95-wintergrasp-to-mortal-siege-adaptation.md`** — Siege adaptation and territory control mechanics
- **`98-mortal-siege-prep-contracts.md`** — Contracts and preparation systems for sieges
- **`11-pvp-systems.md`** — PvP systems that guilds engage with in territory control
- **`04-economy.md`** — Economy system for guild taxation and resource management
- **`03-risk-zones.md`** — Risk tiers that affect stronghold placement and territory control
- **`72-act4-strongholds-and-invasions-campaign.md`** — Campaign content related to strongholds

---

# 2. Complete Guild Conversion Strategy

This section provides a comprehensive mapping of all WoW 3.3.5a guild features to Mortal Warcraft's Stronghold-based guild system.

## 2.1 Guild Conversion Rules

**All Guilds Convert to Mortal Guilds:**
- Original guild structure → Mortal guild structure
- Original guild features → Mortal stronghold features
- Original guild progression → Mortal stronghold progression

**Conversion Process:**
1. Original guild → Mortal guild (preserved)
2. Original guild bank → Regional guild storage (stronghold-based)
3. Original guild perks → Stronghold upgrades
4. Original guild progression → Stronghold level progression

## 2.2 Guild Feature Conversion

| WoW Guild Feature | Original Function | Mortal Conversion | Notes |
|-------------------|-------------------|-------------------|-------|
| **Guild Bank** | Shared storage | Regional guild storage | Stronghold-based, regional access |
| **Guild Tabard** | Cosmetic | Guild tabard | Preserved, cosmetic only |
| **Guild Perks** | XP/gold bonuses | Stronghold upgrades | No XP bonuses, stronghold benefits |
| **Guild Reputation** | Guild rep system | Faction standing | Faction standing system |
| **Guild Achievements** | Guild achievements | Guild achievements | Mortal achievement system |
| **Guild Calendar** | Event calendar | Event calendar | Preserved, stronghold events |
| **Guild News** | Guild news feed | Guild news feed | Preserved |
| **Guild Roster** | Member list | Member list | Preserved, stronghold access |

## 2.3 Guild Bank Conversion

**Original Guild Bank:**
- Global access (anywhere)
- Shared storage tabs
- Permission-based access

**Mortal Guild Storage:**
- **Regional access** (stronghold-based)
- Storage tabs tied to stronghold level
- Permission-based access (same system)
- **Regional restrictions:** Must be at stronghold or regional bank

**Guild Storage Tabs:**
- **Level 1 Stronghold:** 1 storage tab
- **Level 2 Stronghold:** 2 storage tabs
- **Level 3 Stronghold:** 3 storage tabs
- **Level 4 Stronghold:** 4 storage tabs
- **Level 5 Stronghold:** 5 storage tabs

## 2.4 Guild Perks Conversion

**Original Guild Perks:**
- XP bonuses (removed in Mortal)
- Gold bonuses (converted to stronghold benefits)
- Reputation bonuses (converted to faction standing bonuses)
- Mount speed bonuses (converted to stronghold benefits)

**Mortal Stronghold Benefits:**
- **Resource Bonuses:** +10-50% resource gathering (stronghold territory)
- **Crafting Bonuses:** +10-50% crafting success rate (stronghold workstations)
- **Tax Revenue:** Guild taxation from territory control
- **Spawn Point:** Shrine respawn at stronghold
- **Market Access:** Market stall access (Level 3+)
- **Caravan Bonuses:** Reduced caravan costs (Level 4+)

## 2.5 Guild Progression Conversion

**Original Guild Progression:**
- Guild level (1-25)
- Guild experience (XP from members)
- Guild perks unlocked at levels

**Mortal Stronghold Progression:**
- **Stronghold Level (1-5):** Replaces guild level
- **Stronghold Upgrades:** Replaces guild perks
- **Territory Control:** Replaces guild experience
- **Seasonal Rankings:** Replaces guild progression

**Stronghold Level Requirements:**
- **Level 1:** Basic stronghold (outpost)
- **Level 2:** Fortified outpost (guard patrols, T2 crafting)
- **Level 3:** Keep (market stall, taxation, T3 crafting)
- **Level 4:** Fortress (high-tier crafting, siege artillery, T4 crafting)
- **Level 5:** Citadel (legendary crafting, global influence, T5 crafting)

## 2.6 Guild Role Conversion

**Original Guild Roles:**
- Guildmaster
- Officer
- Member
- Recruit

**Mortal Guild Roles:**
- **Guildmaster:** Full control, stronghold ownership
- **Council Officers:** Stronghold management, territory control
- **Captains:** Squad management, siege leadership
- **Quartermasters:** Storage/tax management, resource management
- **Members:** Standard access, stronghold benefits
- **Recruits:** Limited access, no stronghold benefits

## 2.7 Guild Conversion Examples

### Example 1: Small Guild (10-20 members)

**Original Guild:**
- Level 5 guild
- Basic guild bank
- Basic guild perks

**Mortal Conversion:**
- Level 1-2 Stronghold (outpost)
- 1-2 storage tabs
- Basic stronghold benefits
- Territory control: 0-1 TCPs

### Example 2: Medium Guild (20-50 members)

**Original Guild:**
- Level 15 guild
- Advanced guild bank
- Advanced guild perks

**Mortal Conversion:**
- Level 2-3 Stronghold (fortified outpost/keep)
- 2-3 storage tabs
- Advanced stronghold benefits
- Territory control: 1-3 TCPs

### Example 3: Large Guild (50+ members)

**Original Guild:**
- Level 25 guild
- Full guild bank
- All guild perks

**Mortal Conversion:**
- Level 4-5 Stronghold (fortress/citadel)
- 4-5 storage tabs
- All stronghold benefits
- Territory control: 3+ TCPs

## 2.8 Guild Migration Strategy

**Migration Process:**
1. **Preserve Guild Structure:** All existing guilds preserved
2. **Convert Guild Banks:** Guild banks → Regional guild storage
3. **Assign Strongholds:** Guilds can claim strongholds (first-come, first-served)
4. **Convert Guild Perks:** Guild perks → Stronghold upgrades
5. **Reset Guild Progression:** Guild level → Stronghold level (fresh start)

**Migration Timeline:**
- **Phase 1:** Preserve guild structure (immediate)
- **Phase 2:** Convert guild banks (Week 1)
- **Phase 3:** Stronghold claiming period (Week 2-4)
- **Phase 4:** Stronghold upgrades (ongoing)

## 2.9 Guild Conversion Benefits

**Benefits of Mortal Guild System:**
- **Territory Control:** Guilds control actual territory
- **Economic Impact:** Guild taxation and resource control
- **Strategic Gameplay:** Siege warfare and territory control
- **Seasonal Progression:** Seasonal rankings and rewards
- **Social Structure:** Stronghold-based social hubs

**Preserved Features:**
- Guild structure (roles, permissions)
- Guild communication (chat, calendar, news)
- Guild achievements
- Guild tabards (cosmetic)

---

# 3. Guild Structure

## 3.1 Guild Roles
- **Guildmaster**
- **Council Officers** (optional)
- **Captains** (manage squads)
- **Quartermasters** (manage storage/tax)
- **Members**
- **Recruits**

## 3.2 Guild Stats
Each guild tracks:
- Territory owned  
- Stronghold level  
- Weekly tax revenue  
- War status  
- Seasonal ranking  

---

# 3. Strongholds (Guild Bases)

Strongholds are **claimable landmark structures** placed across Azeroth.

Examples:
- Ruined towers  
- Abandoned fortresses  
- Caverns  
- Ancient shrines  

## 3.0 Zone Stronghold Placement Opportunities

Strongholds can be placed in specific zones based on strategic value, resource access, and territorial control. This section maps stronghold placement opportunities by zone.

### Stronghold Placement Rules

**Zone Restrictions:**
- **Green Zones:** No stronghold placement (safe zones, no territorial control)
- **Yellow Zones:** Limited stronghold placement (strategic locations only)
- **Red Zones:** Full stronghold placement (high-value territories)

**Placement Requirements:**
- Zone must be Yellow or Red risk tier
- Location must be a landmark structure (tower, fortress, cave, etc.)
- Minimum distance from other strongholds (500+ yards)
- Must be accessible (not in unreachable areas)

### Stronghold Placement by Zone

#### Eastern Kingdoms

| Zone | Risk Tier | Stronghold Opportunities | Strategic Value | Notes |
|------|-----------|--------------------------|-----------------|-------|
| Westfall | Yellow | 2-3 locations | Medium | Mid-risk, resource access |
| Redridge Mountains | Yellow | 2-3 locations | Medium | Mid-risk, strategic chokepoint |
| Duskwood | Yellow | 1-2 locations | Low | Mid-risk, limited strategic value |
| Stranglethorn Vale | Red | 3-4 locations | High | High-risk, resource-rich, strategic |
| Arathi Highlands | Yellow | 2-3 locations | Medium | Mid-risk, battleground proximity |
| Badlands | Yellow | 1-2 locations | Low | Mid-risk, limited resources |
| Searing Gorge | Yellow | 2-3 locations | High | Mid-risk, Blackrock proximity |
| Burning Steppes | Red | 2-3 locations | High | High-risk, Blackrock Depths access |
| Blasted Lands | Red | 1-2 locations | Medium | High-risk, world boss proximity |
| Eastern Plaguelands | Red | 3-4 locations | High | High-risk, strategic territory |
| Western Plaguelands | Yellow/Red | 2-3 locations | Medium | Mixed risk, strategic value |

#### Kalimdor

| Zone | Risk Tier | Stronghold Opportunities | Strategic Value | Notes |
|------|-----------|--------------------------|-----------------|-------|
| The Barrens | Yellow | 3-4 locations | High | Mid-risk, central location, high traffic |
| Ashenvale | Yellow | 2-3 locations | Medium | Mid-risk, strategic chokepoint |
| Stonetalon Mountains | Yellow | 1-2 locations | Low | Mid-risk, limited strategic value |
| Feralas | Yellow | 2-3 locations | Medium | Mid-risk, resource access |
| Tanaris | Yellow | 2-3 locations | Medium | Mid-risk, central location |
| Silithus | Red | 2-3 locations | High | High-risk, AQ raid proximity |
| Winterspring | Yellow | 1-2 locations | Low | Mid-risk, limited resources |
| Felwood | Yellow | 1-2 locations | Low | Mid-risk, limited strategic value |
| Azshara | Yellow | 2-3 locations | Medium | Mid-risk, world boss proximity |

#### Outland

| Zone | Risk Tier | Stronghold Opportunities | Strategic Value | Notes |
|------|-----------|--------------------------|-----------------|-------|
| Hellfire Peninsula | Yellow | 2-3 locations | Medium | Mid-risk, central Outland location |
| Zangarmarsh | Yellow | 2-3 locations | Medium | Mid-risk, resource-rich |
| Nagrand | Yellow | 2-3 locations | Medium | Mid-risk, central location |
| Shadowmoon Valley | Red | 2-3 locations | High | High-risk, Black Temple proximity |
| Netherstorm | Yellow | 2-3 locations | Medium | Mid-risk, strategic locations |

#### Northrend

| Zone | Risk Tier | Stronghold Opportunities | Strategic Value | Notes |
|------|-----------|--------------------------|-----------------|-------|
| Borean Tundra | Yellow | 2-3 locations | Medium | Mid-risk, entry point to Northrend |
| Howling Fjord | Yellow | 2-3 locations | Medium | Mid-risk, entry point to Northrend |
| Dragonblight | Yellow | 2-3 locations | Medium | Mid-risk, central Northrend |
| Grizzly Hills | Yellow | 1-2 locations | Low | Mid-risk, limited strategic value |
| Zul'Drak | Yellow | 2-3 locations | Medium | Mid-risk, strategic locations |
| The Storm Peaks | Yellow/Red | 2-3 locations | High | Mixed risk, Ulduar proximity |
| Icecrown | Red | 3-4 locations | Very High | High-risk, ICC raid proximity, endgame territory |
| Wintergrasp | Red | 1 location | Very High | World PvP zone, siege warfare focus |

### Stronghold Placement Strategy

**High-Value Locations:**
- Near raid entrances (ICC, Black Temple, AQ)
- Resource-rich zones (Stranglethorn Vale, Eastern Plaguelands)
- Strategic chokepoints (Searing Gorge, Ashenvale)
- Central locations (The Barrens, Dragonblight)

**Placement Density:**
- **Yellow Zones:** 1-3 strongholds per zone (moderate competition)
- **Red Zones:** 2-4 strongholds per zone (high competition)
- **Strategic Zones:** Higher density (The Barrens, Icecrown, Stranglethorn Vale)

**Seasonal Resets:**
- Stronghold ownership resets at season end
- New placement opportunities may open
- Strategic value may shift based on world events

## 3.1 How Guilds Claim Strongholds
1. Clear the area  
2. Plant a **Stronghold Banner**  
3. Banner channels for 5 minutes  
4. If uninterrupted, the guild claims ownership  

## 3.2 Stronghold Features
- **Local Banking Hub** (regional, for members only)  
- **Guild Storage**  
- **Crafting Stations** (upgradeable)  
- **Spawn Point (Shrine)**  
- **Territory Bonuses**  
- **NPC Guards** (configurable)  

---

# 4. Stronghold Progression Tree

Strongholds have levels (1–5).  
Each level unlocks buildings/upgrades:

## Level 1: Outpost
- Basic storage  
- Shrine respawn  
- T1 crafting station  

## Level 2: Fortified Outpost
- Guard patrols  
- Siege equipment vendor  
- T2 crafting station  

## Level 3: Keep
- Market stall access  
- Taxation system  
- Regional caravans  

## Level 4: Fortress
- High-tier crafting (Arcane stations)  
- Multi-layer walls  
- Siege artillery  

## Level 5: Citadel
- Guild Hall portal  
- Legendary crafting stations  
- Global event influence  
- Season victory rewards  

---

# 5. Territory Control Points (TCPs)

TCPs are spread across every Yellow and Red zone.

## 5.1 Capturing a TCP
1. Kill the neutral guardian  
2. Channel the flag (30–120 sec depending on zone)  
3. Control periodic resource ticks  

## 5.2 TCP Rewards
- Resource shipments  
- Local buffs  
- Increased node respawns  
- “Territory Influence” score  

Influence determines **seasonal map rankings**.

---

# 6. Siege Warfare

## 6.1 Vulnerability Windows
Strongholds are only attackable during:
```
A 2-hour vulnerability period set by the guild.
```
This prevents 4 A.M. ninja sieges.

## 6.2 Siege Phases

### Phase 1: Declaration
- Attacker pays a **siege declaration fee**  
- 24-hour notice begins  
- Defender notified via mail & Discord integration  

### Phase 2: War Preparation
Both sides:
- Build siege engines  
- Rally allies  
- Move resources  

### Phase 3: Battle
During the window:
- Walls destructible  
- Siege vehicles usable  
- Outpost NPCs fight attackers  
- Players respawn at nearby shrines  

### Phase 4: Capture or Fail
- If attackers capture the Stronghold Banner → **ownership flips**  
- If not → defender retains control  

---

# 7. Siege Equipment

## 7.1 Craftable Engines
- **Meat Wagons**  
- **Catapults**  
- **Rams**  
- **Cannons**  
- **Siege Towers**  
- **Field Barricades** (temporary walls)

## 7.2 Requirements
- Blueprints (BPO/BPC)  
- Guild-only crafting stations  
- Large material cost  
- Time-based construction  

---

# 8. Guild Halls (Instanced)

Guilds can purchase a **Guild Hall Key** using seasonal resources.

## 8.1 Hall Types
- Shadowfang Keep (ID 33)  
- Scarlet Monastery wing  
- Custom map (Development Land)

## 8.2 Features
- Decoration placement  
- Trophies from events  
- Storage  
- War room  
- Crafting stations  
- Member portals  

All decorations persist server-side.

---

# 9. Alliances & Guild Politics

## 9.1 Alliance System
Guilds may formally ally:
- Shared stronghold access  
- Shared crafting stations  
- Reduced friendly fire  
- Shared caravan missions  

## 9.2 Betrayal System
Breaking an alliance:
- Applies a temporary **Dishonor** debuff  
- Reduces seasonal influence  
- Sends server-wide message  

## 9.3 Guild Wars
- Any guild may declare war on another (fee required)  
- War removes Notoriety penalties for PvP  
- War lasts until:
  - One guild surrenders  
  - Time limit expires  

---

# 10. Taxation System

Guild-owned zones automatically generate taxes:

## 10.1 Tax Sources
- Resource node extractions  
- Market stall fees  
- Stronghold NPC services  
- Member activity tax (optional)  
- Courier tariffs  

## 10.2 Tax Storage
Collected taxes go to:
- **Stronghold Treasury**  
- Used for sieges, upgrades, guard upkeep  

---

# 11. Seasonal Map Resets

Every **6–12 weeks**, sovereignty resets.

## 11.1 What Resets
- Stronghold ownership  
- Territory influence  
- War statuses  

## 11.2 What Does NOT Reset
- Player skills  
- Gear  
- Crafting progression  
- Guild membership  

## 11.3 Seasonal Rewards
- Unique cosmetics  
- Guild Hall decorations  
- Rare mounts  
- Resource multipliers  

---

# 12. Implementation Summary

## 12.1 C++ Files
- `TerritoryControl.cpp`
- `StrongholdHandler.cpp`
- `SiegeHooks.cpp`
- `GuildWar.cpp`

## 12.2 Lua Files
- `MortalStrongholdSystem.cpp/h` (C++ implementation)
- `MortalTCPCapture.cpp/h` (C++ implementation)
- `MortalSiegeWindow.cpp/h` (C++ implementation)
- `guild_taxation.lua`
- `alliance_logic.lua`

## 12.3 SQL Files
- `schema_strongholds.sql`
- `schema_tcp.sql`
- `guild_seasonal_scores.sql`

---

# 13. Status
The Sovereignty System is **Core Endgame Content**, designed for long-term retention and seasonal replay.

