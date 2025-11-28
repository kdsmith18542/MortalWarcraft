# Project Canvas: Mortal Warcraft Overhaul
### Version 26.1 — Hybrid Technical Design Document
### File: 03-risk-zones.md
### Section: World Risk Tiers, Loot Rules, and Zone Redesign

---

# 1. Overview

The Risk Zone System defines the foundation of Mortal Warcraft’s danger, logistics, and progression ecosystem.  
It transforms Azeroth into a **risk‑layered world**, drawing from Mortal Online, EVE, and RuneScape.

This document defines:

- Green Zones (Safe)
- Yellow Zones (Mid-Risk)
- Red Zones (Full Loot)
- Outlaw Restrictions
- Border & signage rules
- Environmental hazards
- Zone-by-zone conversions
- Implementation notes

---

## Related Specs

For full context on risk zone systems, see:

- **`02-combat.md`** — Combat mechanics, crime system, and PvP rules that operate within these zones
- **`11-pvp-systems.md`** — Extended PvP systems, notoriety, and criminal logic that interact with zone rules
- **`56-negative-titles-and-notoriety-labels.md`** — Notoriety system that triggers Outlaw restrictions in zones
- **`04-economy.md`** — Regional banking and market access restrictions for Outlaws
- **`13-caravans-contracts.md`** — Caravan routes and contracts that must navigate risk zones
- **`05-crafting.md`** — Material gathering locations and workstation placement affected by risk tiers
- **`06-pve.md`** — PvE content placement and difficulty scaling by risk tier

---

# 2. Zone Types

---

## 2.1 Green Zones (Safe Zones)

### Purpose
- Onboarding
- Social hubs
- Crafting and trade centers
- Low-tier resource gathering

### Rules
- PvP disabled.
- No death loot.
- Guards instantly kill Outlaws.
- Tier 1 resources only.
- Mount stealing disabled.
- Crime system inactive.

### New Player Protection
- First **6 bag slots protected** (items cannot drop).
- Mentor NPCs available.

### Typical Zones
- Elwynn Forest  
- Dun Morogh  
- Teldrassil  
- Mulgore  
- Durotar (Valley of Trials area)  
- Eversong Woods  

---

## 2.2 Yellow Zones (Mid-Risk Sandbox)

### Purpose
- The bridge between safety and danger.
- Where most players spend their time.
- Encourages PvP without extreme punishment.

### PvP Rules
- Attacking an Innocent → Criminal Flag (15m).
- Criminals can be freely attacked.
- Friendly Fire disabled.
- Healing a Criminal → You become Criminal.

### Loot Rules

#### Innocent Death
**Keeps:**  
- Main Weapon  
- Chestpiece  
- Mount Reins  
- 1 Trinket Slot  

**Drops:**  
- All inventory  
- Consumables  
- All non-protected equipped items (rings, boots, helm, belt, shoulders, off-hand)

#### Criminal Death
- Drops **everything** (full loot).

### Zerg Penalty
- Killing a solo player with 5+ attackers → Double Notoriety for all attackers.

### Tiered Resources
- Tier 2–3 gathering nodes.
- Mid-grade crafting materials.
- Moderate Material Lore books.

### Typical Zones
- Westfall  
- Redridge  
- Duskwood  
- Loch Modan  
- Barrens  
- Thousand Needles  
- Hillsbrad Foothills  

---

## 2.3 Red Zones (Full-Loot)

### Purpose
- Highest risk, highest reward.
- Home of rare resources, world bosses, extraction raids.

### PvP Rules
- FFA PvP always enabled.
- Friendly Fire enabled.
- Healing anyone counts as aiding them (may flag you Criminal for interactions in Yellow border areas).

### Loot Rules
- Always drop ALL gear and inventory.
- Corpse chest spawns.
- Item decay still applies normally.
- **Exception:** Items with an active **Blessing** (see `37-economy-system-extensions.md`) do not drop, but consume a blessing charge and take extra durability loss.

### Border Grace Window
Players crossing into a Red Zone have:
```
10 seconds of reversible entry
```
If they turn around immediately, no PvP flag is applied.

### Tiered Resources
- Tier 4–5 rare nodes.
- Legendary blueprint fragments.
- High-end Material Lore.
- Extraction Raid artifacts.

### Typical Zones
- Stranglethorn Vale  
- Eastern Plaguelands  
- Burning Steppes  
- Silithus  
- Winterspring  
- Felwood  

---

# 3. Outlaw Restrictions (Zone-Interaction Layer)

Outlaws are players who exceed a Notoriety threshold (defined in 02-combat.md).

### 3.1 Outlaw Rules in Each Zone

#### Green Zones
- Outlaws are **kill-on-sight** by invincible guards.
- Cannot enter main cities.
- Cannot use:
  - Banks
  - Vendors (except fence NPCs)
  - Repair NPCs
  - Crafting stations

#### Yellow Zones
- Guards attack Outlaws near towns.
- Outlaws may not use:
  - Regional banks  
  - Market stalls  
  - Quest hubs  

#### Red Zones
- No restrictions.
- Outlaws are at home here.

### 3.2 Outlaw Encampments
Special camp hubs for Outlaws include:
- Fence NPCs (sell stolen goods)
- Outlaw Banker (limited storage)
- Rough crafting stations
- Black market vendors (unique cosmetics, outlaw items)

Locations:
- Cape of Stranglethorn (hidden cave)  
- Eastern Plaguelands (ruined chapel)  
- Badlands (bandit stronghold)  

---

## 3.3 Guard Behavior & Law Enforcement

### 3.3.1 Notoriety-Based Guard Response

Guards respond to players based on their **Notoriety level** and **Faction Standing**:

**Response Levels:**
- **Low Notoriety (0-25)**: 
  - Warnings for minor crimes
  - Fines for repeated offenses
  - No aggressive action
- **Moderate Notoriety (26-50)**:
  - Aggressive warnings
  - Increased fines
  - Guard patrols may follow player
- **High Notoriety (51-75)**:
  - Guards respond aggressively
  - Arrest attempts (stun/disable)
  - Increased guard spawns near player
- **Outlaw (76+)**: 
  - **Instant kill on sight** in Green zones
  - Aggressive pursuit in Yellow zones
  - No guards in Red zones (player justice)

### 3.3.2 Zone-Based Enforcement

**Green Zones:**
- **Strict Enforcement**: Guards patrol actively
- **Fast Response**: Guards respond quickly to crimes
- **High Guard Density**: Many guards in towns/cities
- **Outlaw Policy**: Instant kill on sight

**Yellow Zones:**
- **Moderate Enforcement**: Guards patrol less frequently
- **Slower Response**: Guards take longer to respond
- **Lower Guard Density**: Fewer guards, mainly in towns
- **Outlaw Policy**: Guards attack but may not kill instantly

**Red Zones:**
- **No Guards**: Player-driven justice only
- **No Enforcement**: No guard response to crimes
- **Outlaw Policy**: Outlaws are at home here

### 3.3.3 Guard AI Behavior

**Patrol Patterns:**
- Guards follow defined patrol routes in towns/cities
- Patrol frequency increases with player notoriety
- Guards may follow suspicious players

**Response Time:**
- Based on faction standing (higher standing = faster response)
- Based on notoriety (higher notoriety = faster response)
- Based on zone type (Green = fastest, Yellow = slower)

**Escalation System:**
- First offense: Warning
- Second offense: Fine
- Third offense: Aggressive response
- Outlaw: Instant kill (Green zones)

**Implementation:**
- Guard behavior controlled by `MortalGuardAI.cpp/h`
- Notoriety checks on guard spawn/interaction
- Faction standing affects guard response time
- Zone type determines guard density and behavior

---

## 3.4 Flight Path Restrictions

### 3.4.1 Risk Zone-Based Flight Path Network

Flight paths are restricted based on zone risk tier to support regional economy and create meaningful travel decisions:

**Green Zones:**
- **Full Flight Path Network**: All flight paths active
- **Safe Travel**: Fast, safe transportation between Green zones
- **No Restrictions**: Players can fly freely within Green zone network

**Yellow Zones:**
- **Limited Flight Paths**: Only flight paths to/from Green zones
- **No Yellow-to-Yellow**: Cannot fly directly between Yellow zones
- **Must Travel Through Green**: Forces ground travel or caravan through Yellow zones
- **Economy Impact**: Creates demand for caravan escorts and courier contracts

**Red Zones:**
- **No Flight Paths**: All flight paths disabled
- **Forces Ground Travel**: Players must use caravans or walk
- **High Risk**: Ground travel through Red zones is dangerous
- **Economy Impact**: Makes courier contracts extremely valuable

### 3.4.2 Flight Path Conversion Strategy

**Original WoW Flight Paths:**
- Global flight network (any zone to any zone)
- No restrictions based on zone type

**Mortal Conversion:**
- **Green Zones**: Keep all original flight paths
- **Yellow Zones**: Remove Yellow-to-Yellow connections, keep Green connections
- **Red Zones**: Remove all flight paths
- **New Connections**: Add strategic Green-to-Green connections for regional hubs

### 3.4.3 Economy & Travel Impact

**Regional Economy:**
- Forces physical transport between regions
- Creates demand for caravan escorts
- Makes courier contracts valuable
- Supports regional banking (players must travel to access banks)

**Travel Decisions:**
- Players must choose: fast (Green zones) vs. risky (Yellow/Red zones)
- Ground travel through Yellow/Red zones requires preparation
- Caravan escorts become essential for safe transport

**Implementation:**
- Flight path restrictions controlled by zone risk tier
- Flight master NPCs check zone risk before allowing flight
- Red zone flight masters removed or disabled
- Yellow zone flight masters only show Green zone destinations

---

# 4. World Signage, Lighting & Audio

To ensure risk is always clear:

### 4.1 Signage
- Giant **colored banners** at borders:
  - Green → Yellow  
  - Yellow → Red  
- Skull icons for Red Zone entries.
- Warning floating text:  
  **“You are entering a Full-Loot Zone!”**

### 4.2 Lighting Cues
- Yellow zones have warmer tone & slight overcast.
- Red zones use:
  - Saturated reds/oranges
  - Heavier fog or particle density

### 4.3 Audio Cues
- Zone transition sound stinger.
- Combat drums fade-in when near Red zone borders.

---

# 5. Zone-by-Zone Conversion

Complete zone risk tier mapping for all WoW 3.3.5a zones. This mapping is based on original zone characteristics, level ranges, and Mortal Warcraft's risk/reward philosophy.

## 5.1 Eastern Kingdoms

| Zone | Original Type | Level Range | Risk Tier | Notes |
|------|---------------|-------------|-----------|-------|
| Elwynn Forest | Alliance Starting | 1-10 | **Green** | Safe starting zone |
| Dun Morogh | Alliance Starting | 1-10 | **Green** | Safe starting zone |
| Loch Modan | Alliance | 10-20 | **Green** | Safe zone |
| Westfall | Contested | 10-15 | **Yellow** | Mid-risk farming zone |
| Redridge Mountains | Contested | 15-20 | **Yellow** | Mid-risk PvP zone |
| Duskwood | Contested | 20-25 | **Yellow** (high-risk pockets) | Mixed risk, dark theme |
| Stranglethorn Vale | Contested | 25-35 | **Red** | Full-loot PvP zone |
| Wetlands | Contested | 20-30 | **Yellow** | Mid-risk zone |
| Arathi Highlands | Contested | 30-40 | **Yellow** | Mid-risk PvP zone |
| Hillsbrad Foothills | Contested | 20-30 | **Yellow** | Mid-risk zone |
| Badlands | Contested | 35-45 | **Yellow** | Mid-risk zone |
| Searing Gorge | Contested | 43-50 | **Yellow** | Mid-risk zone |
| Burning Steppes | Contested | 50-55 | **Red** | High-risk zone |
| Swamp of Sorrows | Contested | 35-45 | **Yellow** | Mid-risk zone |
| Blasted Lands | Contested | 45-55 | **Red** | High-risk zone (Kazzak world boss) |
| Hinterlands | Contested | 40-50 | **Yellow** | Mid-risk zone |
| Western Plaguelands | Contested | 50-60 | **Yellow** (Red pockets) | Mixed risk |
| Eastern Plaguelands | Contested | 53-60 | **Red** | High-risk zone |
| Deadwind Pass | Contested | 55-60 | **Red** | High-risk zone |
| Stormwind | Alliance Capital | N/A | **Green** | Safe capital |
| Ironforge | Alliance Capital | N/A | **Green** | Safe capital |
| Eversong Woods | Horde Starting | 1-10 | **Green** | Safe starting zone |
| Ghostlands | Contested | 10-20 | **Yellow** | Mid-risk zone |

## 5.2 Kalimdor

| Zone | Original Type | Level Range | Risk Tier | Notes |
|------|---------------|-------------|-----------|-------|
| Teldrassil | Alliance Starting | 1-10 | **Green** | Safe starting zone |
| Darkshore | Contested | 10-20 | **Yellow** | Mid-risk zone |
| Ashenvale | Contested | 18-30 | **Yellow** | Mid-risk PvP zone |
| Stonetalon Mountains | Contested | 25-35 | **Yellow** | Mid-risk zone |
| Desolace | Contested | 30-40 | **Yellow** | Mid-risk zone |
| Feralas | Contested | 40-50 | **Yellow** | Mid-risk zone |
| Durotar | Horde Starting | 1-10 | **Green** | Safe starting zone |
| Mulgore | Horde Starting | 1-10 | **Green** | Safe starting zone |
| The Barrens | Contested | 10-25 | **Yellow** | Mid-risk zone |
| Thousand Needles | Contested | 25-35 | **Yellow** | Mid-risk zone |
| Tanaris | Contested | 40-50 | **Yellow** | Mid-risk zone |
| Un'Goro Crater | Contested | 48-55 | **Yellow** | Mid-risk zone |
| Silithus | Contested | 55-60 | **Red** | High-risk zone (AQ raid) |
| Winterspring | Contested | 55-60 | **Yellow** | Mid-risk zone |
| Felwood | Contested | 48-55 | **Yellow** | Mid-risk zone |
| Azshara | Contested | 45-55 | **Yellow** | Mid-risk zone (Azuregos world boss) |
| Darnassus | Alliance Capital | N/A | **Green** | Safe capital |
| Orgrimmar | Horde Capital | N/A | **Green** | Safe capital |
| Thunder Bluff | Horde Capital | N/A | **Green** | Safe capital |

## 5.3 Outland (The Burning Crusade)

| Zone | Original Type | Level Range | Risk Tier | Notes |
|------|---------------|-------------|-----------|-------|
| Hellfire Peninsula | Contested | 58-63 | **Yellow** | Mid-risk zone |
| Zangarmarsh | Contested | 60-64 | **Yellow** | Mid-risk zone |
| Nagrand | Contested | 64-67 | **Yellow** | Mid-risk zone |
| Blade's Edge Mountains | Contested | 65-68 | **Yellow** | Mid-risk zone |
| Netherstorm | Contested | 67-70 | **Yellow** | Mid-risk zone |
| Shadowmoon Valley | Contested | 67-70 | **Red** | High-risk zone (Doomwalker world boss) |
| Terokkar Forest | Contested | 62-65 | **Yellow** | Mid-risk zone |
| Shattrath City | Neutral Capital | N/A | **Green** | Safe capital |

## 5.4 Northrend (Wrath of the Lich King)

| Zone | Original Type | Level Range | Risk Tier | Notes |
|------|---------------|-------------|-----------|-------|
| Borean Tundra | Contested | 68-72 | **Yellow** | Mid-risk zone |
| Howling Fjord | Contested | 68-72 | **Yellow** | Mid-risk zone |
| Dragonblight | Contested | 71-75 | **Yellow** | Mid-risk zone |
| Grizzly Hills | Contested | 73-75 | **Yellow** | Mid-risk zone |
| Zul'Drak | Contested | 74-77 | **Yellow** | Mid-risk zone |
| Sholazar Basin | Contested | 76-78 | **Yellow** | Mid-risk zone |
| The Storm Peaks | Contested | 77-80 | **Yellow** (Red pockets) | Mixed risk |
| Icecrown | Contested | 77-80 | **Red** | High-risk zone (ICC raid) |
| Crystalsong Forest | Contested | 77-80 | **Green** | Safe zone (Dalaran) |
| Wintergrasp | PvP Zone | 77-80 | **Red** | World PvP zone (siege warfare) |
| Dalaran | Neutral Capital | N/A | **Green** | Safe capital |

## 5.5 Zone Risk Tier Summary

**Green Zones (Safe):**
- All starting zones (Elwynn Forest, Dun Morogh, Teldrassil, Durotar, Mulgore, Eversong Woods)
- All capital cities (Stormwind, Ironforge, Darnassus, Orgrimmar, Thunder Bluff, Shattrath, Dalaran)
- Loch Modan (safe training zone)
- Crystalsong Forest (Dalaran protection)

**Yellow Zones (Mid-Risk):**
- Most contested zones (Westfall, Redridge, Duskwood, Barrens, Ashenvale, etc.)
- All Outland zones except Shadowmoon Valley
- Most Northrend zones except Icecrown and Wintergrasp
- Mixed-risk zones may have Red pockets (Duskwood, Western Plaguelands, Storm Peaks)

**Red Zones (Full-Loot):**
- Stranglethorn Vale (classic PvP zone)
- Burning Steppes (high-level danger)
- Blasted Lands (Kazzak world boss)
- Eastern Plaguelands (high-level danger)
- Deadwind Pass (high-level danger)
- Silithus (AQ raid zone)
- Shadowmoon Valley (Doomwalker world boss)
- Icecrown (ICC raid zone)
- Wintergrasp (world PvP siege zone)

**Special Cases:**
- Zones with "Yellow/Red split" or "high-risk pockets" have mixed risk areas within the zone
- World boss locations (Kazzak, Azuregos, Doomwalker) are typically Red zones
- Raid zones (Silithus/AQ, Icecrown/ICC) are Red zones
- Capital cities and their immediate safe zones are always Green

---

# 6. Zone Resource Distribution

Resources are distributed across zones based on risk tier, creating economic incentives for players to venture into dangerous areas.

## 6.1 Resource Tier by Zone Risk

**Green Zones (Tier 1 Resources):**
- Basic materials only (Copper Ore, Linen Cloth, Light Leather)
- Low-tier gathering nodes
- Safe gathering for new players
- Examples: Elwynn Forest, Dun Morogh, Teldrassil

**Yellow Zones (Tier 2-3 Resources):**
- Mid-tier materials (Iron Ore, Wool Cloth, Medium Leather)
- Moderate Material Lore books
- Tier 2-3 gathering nodes
- Examples: Westfall, Redridge, The Barrens

**Red Zones (Tier 4-5 Resources):**
- High-tier materials (Thorium Ore, Mageweave Cloth, Thick Leather)
- Legendary blueprint fragments
- High-end Material Lore
- Tier 4-5 rare nodes
- Examples: Stranglethorn Vale, Eastern Plaguelands, Icecrown

## 6.2 Resource Distribution by Zone Type

### Starting Zones (Green)
- **Mining:** Copper Ore, Tin Ore
- **Herbalism:** Peacebloom, Silverleaf, Earthroot
- **Skinning:** Light Leather, Ruined Leather Scraps
- **Fishing:** Basic fish (Raw Brilliant Smallfish, etc.)

### Mid-Game Zones (Yellow)
- **Mining:** Iron Ore, Mithril Ore, Truesilver Ore
- **Herbalism:** Mageroyal, Briarthorn, Stranglekelp
- **Skinning:** Medium Leather, Heavy Leather, Thick Leather
- **Fishing:** Mid-tier fish (Raw Bristle Whisker Catfish, etc.)

### End-Game Zones (Red)
- **Mining:** Thorium Ore, Dark Iron Ore, Rich Thorium Veins
- **Herbalism:** Golden Sansam, Mountain Silversage, Black Lotus
- **Skinning:** Rugged Leather, Thick Leather, Worn Leather
- **Fishing:** High-tier fish (Raw Nightfin Snapper, etc.)

## 6.3 Material Lore Distribution

**Material Lore books** are distributed by zone risk tier:

- **Green Zones:** Basic Material Lore (Iron, Oakwood, Basic Leather)
- **Yellow Zones:** Moderate Material Lore (Mithril, Yew Wood, Medium Leather)
- **Red Zones:** Advanced Material Lore (Thorium, Ironwood, Thick Leather)

**Legendary Blueprint Fragments:**
- Only drop in Red Zones
- Rare drop from world bosses, extraction raids
- Required for Masterwork items

## 6.4 Resource Node Density

**Node Density by Risk Tier:**
- **Green Zones:** High density, low-tier nodes (safe farming)
- **Yellow Zones:** Medium density, mid-tier nodes (balanced risk/reward)
- **Red Zones:** Low density, high-tier nodes (high risk, high reward)

**Node Respawn Rates:**
- Green Zones: Fast respawn (5-10 minutes)
- Yellow Zones: Medium respawn (10-20 minutes)
- Red Zones: Slow respawn (20-30 minutes)

---

# 7. Environmental Hazards

Red Zones should feel inherently dangerous. Add:

### 7.1 Ambient Hazards
- Poison swamps  
- Volcanic ash debuff  
- Radiation pockets (Silithus)  
- Frostbite (Winterspring)

### 7.2 Rare Predators
- Alpha beasts with high aggro radius  
- Rare drops linked to crafting & blueprints

---

# 7. Implementation Details

## 7.1 C++ Layers
- `ZoneRiskHandler.cpp`  
- `Player::OnZoneChange()` hook  
- `OutlawRestrictions.cpp`  

## 7.2 Lua Systems
- `PvPHooks.cpp/h` (C++ implementation)  
- `MortalZonePvP.cpp/h` (C++ implementation)  
- `MortalZonePvP.cpp/h` (C++ implementation)  
- `risk_signage.lua`  
- `outlaw_restrictions.lua`  

## 7.3 SQL
- `zones_risk_flags.sql`  
- `risk_zone_overrides.sql`  

---

# 8. Final Notes
Risk zones define:
- PvP culture  
- Economy flow  
- Logistics gameplay  
- Player retention  

This system is considered **Core & Stable**, and all future systems assume this risk map.
