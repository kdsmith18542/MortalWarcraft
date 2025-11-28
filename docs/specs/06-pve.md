# Project Canvas: Mortal Warcraft Overhaul
### Version 26.1 — Hybrid Technical Design Document  
### File: 06-pve.md  
### Section: PvE Content, Public Dungeons, Delves, Extraction Raids, and World Events

---

# 1. Overview

PvE content in Mortal Warcraft is designed to support:

- Solo progression  
- Small-group sandbox loops  
- Public dungeon chaos  
- Extraction-style raiding  
- Seasonal events  
- Resource-driven exploration  

This system borrows from:

- **Runescape** (open-world PvE, repeatable tasks)  
- **Mortal Online** (public dungeons, resource risk)  
- **Destiny 2** (public events, instanced encounters)  
- **Escape from Tarkov** (extraction mechanics)  
- **WoW Classic** (iconic dungeon architecture)

---

## Related Specs

For full context on PvE systems, see:

- **`03-risk-zones.md`** — Risk tiers that determine PvE content placement and loot rules
- **`01-progression.md`** — Derived level system and skill bands used for PvE content gating
- **`02-combat.md`** — Combat mechanics used in PvE encounters
- **`76-dynamic-tasks-and-contracts-2-0-spec.md`** — Task Board system and contract templates referenced in PvE content
- **`74-cursed-artifacts-and-extraction-system.md`** — Cursed artifacts system used in extraction raids
- **`48-zone-invasions-and-cross-faction-pve.md`** — Zone invasions and cross-faction PvE events
- **`52-season-of-the-frontier.md`** — Seasonal events and renown system that PvE content contributes to
- **`04-economy.md`** — Economy system that PvE rewards feed into

---

# 2. PvE Content Types

Mortal Warcraft features five major PvE pillars:

1. **Delves (Safe Solo PvE)**
2. **Public Dungeons (De-Instanced WoW Dungeons)**
3. **Extraction Raids**
4. **World Bosses**
5. **Task Boards (Infinite Procedural PvE)**

## 2.1 Risk & Derived-Level Alignment
- **Delves:** Green zones only, tuned for Derived Level bands 1–3 (≤ Level 15). Used for onboarding and low-risk material loops.
- **Public Dungeons:** Follow their surrounding zone tier (usually Yellow). Expect mixed groups in bands 2–4 (Levels 6–20); PvP flagging follows zone rules.
- **Extraction Raids:** Always launch from protected instances but end in Red or contested Yellow zones. Target bands 4–5 (Levels 16–25) once artifacts leave the instance.
- **World Bosses:** Spawn primarily in Yellow/Red regions; designers must declare the risk tier per boss so Task Boards and Contracts can reference correct drop tables.
- **Task Boards:** Each template must declare `min_derived_level`, `max_derived_level`, and risk tier, mirroring the schema in `76-dynamic-tasks-and-contracts-2-0-spec.md`.

---

# 3. Delves (Safe Solo PvE)

## 3.1 Purpose
- Provide progression for players who avoid PvP  
- Teach combat and resource loops  
- Reward materials and crafting components  

## 3.2 Rules
- PvP disabled  
- Mobs scale slightly to player skill level  
- Bosses drop:
  - Lore books  
  - Flux materials  
  - Mid-tier components  

## 3.3 Examples
- Deadmine cellars  
- Tirisfal crypts  
- Dustwallow caves  

## 3.4 Implementation
Lua:
- `MortalDelveInstances.cpp/h` (C++ implementation)  
- `solo_pve_rewards.lua`

---

# 4. Public Dungeons (Open-World WoW Dungeons)

## 4.1 Concept
Classic WoW dungeons are **repurposed as open-world spaces**.

Examples:
- Deadmines  
- Wailing Caverns  
- Shadowfang Keep  
- Razorfen Downs  
- Zul'Farrak

## 4.2 Complete Dungeon-to-Public Mapping

All WoW 3.3.5a dungeons are converted to Public Dungeons unless specified otherwise. This table provides the complete mapping:

### Classic 5-Man Dungeons

| Dungeon | Original Level | Mortal Tier | Conversion Type | Zone Risk | Notes |
|---------|----------------|-------------|-----------------|-----------|-------|
| Ragefire Chasm | 13-18 | M-T1 | Public Dungeon | Yellow | Orgrimmar entrance, mid-risk |
| Wailing Caverns | 15-25 | M-T1 | Public Dungeon | Yellow | Barrens, mid-risk |
| The Deadmines | 10-20 | M-T1 | Public Dungeon | Yellow | Westfall, mid-risk |
| Shadowfang Keep | 18-25 | M-T1 | Public Dungeon | Yellow | Silverpine Forest, mid-risk |
| Blackfathom Deeps | 20-30 | M-T1 | Public Dungeon | Yellow | Ashenvale, mid-risk |
| Stormwind Stockade | 22-30 | M-T1 | Delve | Green | Stormwind, safe solo content |
| Razorfen Kraul | 25-35 | M-T1 | Public Dungeon | Yellow | The Barrens, mid-risk |
| Razorfen Downs | 35-45 | M-T2 | Public Dungeon | Yellow | The Barrens, mid-risk |
| Scarlet Monastery (all wings) | 30-45 | M-T1 | Public Dungeon | Yellow | Tirisfal Glades, mid-risk |
| Uldaman | 35-45 | M-T1 | Public Dungeon | Yellow | Badlands, mid-risk |
| Zul'Farrak | 44-54 | M-T2 | Public Dungeon | Yellow | Tanaris, mid-risk |
| Maraudon | 46-55 | M-T2 | Public Dungeon | Yellow | Desolace, mid-risk |
| Sunken Temple | 50-60 | M-T2 | Public Dungeon | Yellow | Swamp of Sorrows, mid-risk |
| Blackrock Depths | 52-60 | M-T2 | Public Dungeon | Yellow/Red | Searing Gorge, mixed risk |
| Lower Blackrock Spire | 55-60 | M-T2 | Public Dungeon | Yellow/Red | Searing Gorge, mixed risk |
| Upper Blackrock Spire | 55-60 | M-T2 | Public Dungeon | Yellow/Red | Searing Gorge, mixed risk |
| Scholomance | 58-60 | M-T2 | Public Dungeon | Yellow | Western Plaguelands, mid-risk |
| Stratholme | 58-60 | M-T2 | Public Dungeon | Yellow | Eastern Plaguelands, mid-risk |
| Dire Maul (all wings) | 55-60 | M-T2 | Public Dungeon | Yellow | Feralas, mid-risk. All wings open simultaneously. No lockouts. Bosses respawn on timer. Resource nodes inside. Key access for certain areas. |

### TBC 5-Man Dungeons

| Dungeon | Original Level | Mortal Tier | Conversion Type | Zone Risk | Notes |
|---------|----------------|-------------|-----------------|-----------|-------|
| Hellfire Ramparts | 60-62 | M-T2/M-T3 | Public Dungeon | Yellow | Hellfire Peninsula, mid-risk |
| Blood Furnace | 61-63 | M-T2/M-T3 | Public Dungeon | Yellow | Hellfire Peninsula, mid-risk |
| Shattered Halls | 70 | M-T3 | Public Dungeon | Yellow | Hellfire Peninsula, mid-risk |
| Slave Pens | 62-64 | M-T2/M-T3 | Public Dungeon | Yellow | Zangarmarsh, mid-risk |
| Underbog | 63-65 | M-T2/M-T3 | Public Dungeon | Yellow | Zangarmarsh, mid-risk |
| Steamvault | 70 | M-T3 | Public Dungeon | Yellow | Zangarmarsh, mid-risk |
| Mana-Tombs | 64-66 | M-T2/M-T3 | Public Dungeon | Yellow | Terokkar Forest, mid-risk |
| Auchenai Crypts | 65-67 | M-T2/M-T3 | Public Dungeon | Yellow | Terokkar Forest, mid-risk |
| Sethekk Halls | 67-69 | M-T2/M-T3 | Public Dungeon | Yellow | Terokkar Forest, mid-risk |
| Shadow Labyrinth | 70 | M-T3 | Public Dungeon | Yellow | Terokkar Forest, mid-risk |
| Old Hillsbrad | 66-68 | M-T2/M-T3 | Public Dungeon | Yellow | Caverns of Time, mid-risk |
| Black Morass | 68-70 | M-T2/M-T3 | Public Dungeon | Yellow | Caverns of Time, mid-risk |
| Mechanar | 69-70 | M-T2/M-T3 | Public Dungeon | Yellow | Netherstorm, mid-risk |
| Botanica | 70 | M-T3 | Public Dungeon | Yellow | Netherstorm, mid-risk |
| Arcatraz | 70 | M-T3 | Public Dungeon | Yellow | Netherstorm, mid-risk |
| Magister's Terrace | 70 | M-T3 | Public Dungeon | Yellow | Isle of Quel'Danas, mid-risk |

### WotLK 5-Man Dungeons

| Dungeon | Original Level | Mortal Tier | Conversion Type | Zone Risk | Notes |
|---------|----------------|-------------|-----------------|-----------|-------|
| Utgarde Keep | 70-72 | M-T3 | Public Dungeon | Yellow | Howling Fjord, mid-risk |
| Utgarde Pinnacle | 80 | M-T3 | Public Dungeon | Yellow | Howling Fjord, mid-risk |
| The Nexus | 71-73 | M-T3 | Public Dungeon | Yellow | Borean Tundra, mid-risk |
| The Oculus | 80 | M-T3 | Public Dungeon | Yellow | Borean Tundra, mid-risk |
| Azjol-Nerub | 72-74 | M-T3 | Public Dungeon | Yellow | Dragonblight, mid-risk |
| Ahn'kahet: The Old Kingdom | 73-75 | M-T3 | Public Dungeon | Yellow | Dragonblight, mid-risk |
| Drak'Tharon Keep | 74-76 | M-T3 | Public Dungeon | Yellow | Grizzly Hills, mid-risk |
| The Violet Hold | 75-77 | M-T3 | Public Dungeon | Green | Dalaran, safe zone |
| Gundrak | 76-78 | M-T3 | Public Dungeon | Yellow | Zul'Drak, mid-risk |
| Halls of Stone | 77-79 | M-T3 | Public Dungeon | Yellow | The Storm Peaks, mid-risk |
| Halls of Lightning | 80 | M-T3 | Public Dungeon | Yellow | The Storm Peaks, mid-risk |
| Culling of Stratholme | 80 | M-T3 | Public Dungeon | Yellow | Caverns of Time, mid-risk |
| Trial of the Champion | 80 | M-T3/M-T4 | Public Dungeon | Yellow | Icecrown, mid-risk |
| The Forge of Souls | 80 | M-T3/M-T4 | Public Dungeon | Red | Icecrown, high-risk |
| Pit of Saron | 80 | M-T3/M-T4 | Public Dungeon | Red | Icecrown, high-risk |
| Halls of Reflection | 80 | M-T3/M-T4 | Public Dungeon | Red | Icecrown, high-risk |

### Delve Conversions

Some smaller dungeons or dungeon sections are converted to **Delves** (safe solo PvE):

| Dungeon | Original Level | Mortal Tier | Conversion Type | Zone Risk | Notes |
|---------|----------------|-------------|-----------------|-----------|-------|
| Stormwind Stockade | 22-30 | M-T1 | Delve | Green | Safe solo content in capital |
| Deadmines cellars | 10-20 | M-T1 | Delve | Green | Safe solo section of Deadmines |
| Tirisfal crypts | 1-10 | M-T1 | Delve | Green | Safe solo content |
| Dustwallow caves | 30-40 | M-T1 | Delve | Green | Safe solo content |

**Note:** Delves are always in Green zones and provide safe solo progression without PvP risk.  

## 4.2 Rules
- **No Instance Lockouts**: Completely removed for public dungeons - players can farm/compete freely
- **PvP enabled** based on zone type  
- **High gathering node density**  
- **Rare blueprint fragment drops**  
- **Increased alpha spawn chance**

## 4.2.1 Dungeon Keys & Access Requirements

**Key System Conversion:**
- Original WoW instance keys are converted to **crafted access items**
- Keys are required for certain boss rooms or treasure vaults
- Keys can be:
  - **Crafted** by players (player-driven economy)
  - **Looted** from mobs within the dungeon
  - **Traded/sold** on market stalls (economy opportunity)
- Keys have **durability** (consumable = economy sink)
- Keys create **demand** for crafting and trading

**Access Requirements:**
- Some areas require keys to access (creates progression goals)
- Key requirements vary by dungeon tier
- Higher-tier dungeons may require multiple keys or key combinations
- Supports crafting economy and creates meaningful progression gates

**Examples:**
- **Dire Maul**: Requires crafted keys for certain wing access
- **Blackrock Depths**: Key combinations for deeper areas
- **Scholomance**: Crafted keys for secret rooms

**Implementation:**
- Keys are items in `item_template` with special flags
- Key requirements checked on door/portal interaction
- Key durability consumed on use (creates economy sink)  

## 4.3 Player Capacity
- Designed for 10–40 players at once  
- More players increases:
  - Spawn rates  
  - Material drop rates  

## 4.4 Implementation
Lua:
- `MortalPublicDungeonAI.cpp/h` (C++ implementation)  
- `public_dungeon_spawns.lua`  

SQL:
- `dungeon_spawn_overrides.sql`

---

# 5. Extraction Raids

## 5.1 Concept
Borrowing ideas from Tarkov and The Division’s Dark Zone:

- WoW raids stay **instanced**, but…  
- Bosses drop **Cursed Artifacts**  
- These artifacts must be physically carried out  
- Player must travel to a **Purification Altar** in the open world  
- PvP risk begins once the artifact is picked up  

## 5.2 Rules
- Artifacts are **heavy** (slow movement)  
- Artifact carrier is visible on map  
- Dropping the artifact spawns a loot chest  
- Altar locations rotate weekly  

## 5.3 Rewards
- Blueprint Originals  
- Rare crafting materials  
- High-tier Lore books  
- Unique cosmetic dyes  

## 5.4 Implementation
Lua:
- `MortalExtractionArtifact.cpp/h` (C++ implementation)
- `altar_rotation.lua`

SQL:
- `cursed_artifacts.sql`

---

# 6. World Bosses

World bosses are high-tier open-world encounters that spawn in specific zones. They follow zone risk rules and provide high-value rewards for coordinated groups.

## 6.1 Complete World Boss List

### Classic World Bosses

| Boss | Location | Zone Risk Tier | Mortal Tier | Spawn Type | Notes |
|------|----------|----------------|-------------|------------|-------|
| Lord Kazzak | Blasted Lands | Red | WORLD_3 | Timed | High-risk zone, full-loot PvP |
| Azuregos | Azshara | Yellow | WORLD_3 | Timed | Mid-risk zone, criminal flagging |
| Dragons of Nightmare | Various (Kalimdor) | Yellow/Red | WORLD_3 | Timed | Multiple spawn locations |
| - Lethon | Ashenvale | Yellow | WORLD_3 | Timed | Mid-risk zone |
| - Emeriss | Duskwood | Yellow | WORLD_3 | Timed | Mid-risk zone |
| - Taerar | Feralas | Yellow | WORLD_3 | Timed | Mid-risk zone |
| - Ysondre | The Hinterlands | Yellow | WORLD_3 | Timed | Mid-risk zone |

### TBC World Bosses

| Boss | Location | Zone Risk Tier | Mortal Tier | Spawn Type | Notes |
|------|----------|----------------|-------------|------------|-------|
| Doomwalker | Shadowmoon Valley | Red | WORLD_3 | Timed | High-risk zone, full-loot PvP |
| Doom Lord Kazzak | Hellfire Peninsula | Yellow | WORLD_3 | Timed | Mid-risk zone, criminal flagging |

### WotLK World Bosses

| Boss | Location | Zone Risk Tier | Mortal Tier | Spawn Type | Notes |
|------|----------|----------------|-------------|------------|-------|
| Time-Lost Proto-Drake | The Storm Peaks | Yellow/Red | WORLD_4 | Rare Spawn | Mixed risk zone |
| Vyragosa | The Storm Peaks | Yellow/Red | WORLD_4 | Rare Spawn | Mixed risk zone |

**Note:** Additional world bosses may be added through seasonal events and zone invasions (see `48-zone-invasions-and-cross-faction-pve.md`).

## 6.2 Spawning Mechanics

### Spawn Windows
- Spawn windows announced globally via whispers and autobroadcast
- Typical spawn window: 2-4 hours after previous kill
- Spawn locations may shift seasonally based on world events
- Rare resource nodes appear around boss zones during spawn windows

### Spawn Announcements
- **15 minutes before spawn:** Zone-wide whisper to all players in zone
- **5 minutes before spawn:** Global autobroadcast message
- **On spawn:** Zone-wide announcement with approximate location

### Spawn Protection
- **Green/Yellow zones:** 30-second spawn protection (no PvP flag)
- **Red zones:** No spawn protection (FFA PvP from spawn)

## 6.3 Rebalancing Strategy

All world bosses are rebalanced using the Mortal tier system (see `32-npc-and-encounter-rebalance.md`):

- **Tier Assignment:** All world bosses use `WORLD_3` or `WORLD_4` tier codes
- **HP Scaling:** 0.4-0.5x original HP (Mortal stat curve)
- **Damage Scaling:** 0.4-0.55x original damage
- **Ability Scaling:** Spell damage reduced proportionally
- **Loot Tier:** M-T3 to M-T4 gear, legendary blueprints, high-tier materials

### Rebalancing Examples

| Boss | Original HP | Mortal HP (WORLD_3) | Original Damage | Mortal Damage | Loot Tier |
|------|-------------|---------------------|----------------|---------------|-----------|
| Lord Kazzak | ~1,000,000 | ~400,000 | ~5,000 | ~2,000 | M-T3 |
| Azuregos | ~800,000 | ~320,000 | ~4,000 | ~1,600 | M-T3 |
| Doomwalker | ~1,200,000 | ~480,000 | ~6,000 | ~2,400 | M-T3 |
| Time-Lost Proto-Drake | ~600,000 | ~300,000 | ~3,000 | ~1,500 | M-T4 |

## 6.4 Rewards

### Loot Table Structure
- **Legendary Blueprints:** 5-10% drop chance (unique crafting recipes)
- **High-Yield Crafting Resources:** 100% drop (rare materials)
- **M-T3/M-T4 Gear:** 20-30% drop chance per player
- **Guild Reputation:** 50-100 reputation per kill (if guild-tagged)
- **Seasonal Cosmetics:** Event-specific rewards during seasonal periods

### Reward Distribution
- **Loot Rules:** Follow zone risk tier (Yellow = partial loot, Red = full loot)
- **Tag System:** First group to engage gets primary loot rights
- **Assist System:** Groups that deal 25%+ damage get secondary loot rights
- **Griefing Penalty:** Zerging (5+ attackers) reduces loot quality by 50%

## 6.5 PvP Rules

### Zone-Based Rules
- **Green Zones:** PvP disabled, world bosses spawn in Green zones only during special events
- **Yellow Zones:** Criminal flagging applies, bounty system active
- **Red Zones:** FFA PvP, full-loot rules, no restrictions

### Bounty System
- Killing a solo player during world boss encounters in Yellow zones → Bounty applied
- Bounty value: 50-200 gold (scales with victim's gear value)
- Bounty hunters can claim bounties by killing the criminal

## 6.6 Implementation

**C++:**
- `MortalWorldBossManager.cpp/h` - Spawn management and rebalancing
- `WorldBossRebalance.cpp/h` - Tier scaling and stat adjustments

**Lua:**
- `world_boss_spawns.lua` - Spawn window management
- `world_boss_announcements.lua` - Announcement system
- `world_boss_loot.lua` - Loot distribution logic

**SQL:**
- `world_boss_definitions.sql` - Boss definitions and spawn locations
- `world_boss_spawn_history.sql` - Spawn history tracking

---

# 7. Task Boards (Procedural PvE)

## 7.1 Purpose
- Provide endless content  
- Support solo, duo, and small groups  
- Replace traditional XP quests  

## 7.2 Task Types
- “Kill X beasts”  
- “Collect resources”  
- “Deliver crate to outpost”  
- “Scout area and return”  
- “Slay rare variant”  

## 7.3 Rewards
- Gold  
- Crafting resources  
- Lore books  
- Reputation  

SQL:
- `task_board_entries.sql`

Lua:
- `MortalTaskBoard.cpp/h` (C++ implementation)

---

# 8. Seasonal PvE Events

## 8.1 The Midnight Horde
- Hundreds of zombies spawn across several zones  
- Players must clear waves  
- Drops:
  - Zombie ichor (alchemy mat)
  - Necrotic essences  
  - Event cosmetics  

## 8.2 Eruption Season
- Fire elementals swarm Burning Steppes  
- Players gather volcanic cores  

## 8.3 Dreamstate Bloom
- Rare herbs spawn across Winterspring/Ashenvale  

Everything ties into the economy.

Lua:
- `seasonal_event_controller.lua`

---

# 9. PvE Progression

## 9.1 PvE Skill Gains
Relevant skills increase from PvE actions:
- Combat Masteries  
- Gathering  
- Lore skills  
- Material specialization  

## 9.2 Loot Scaling
Rewards scale by:
- Player Derived Level  
- Zone risk tier  
- Task difficulty  
- Monster rank  

## 9.3 PvE Build Paths
- Explorer build (gathering speed, stealth bonuses)  
- Beast Hunter build (bonuses vs wildlife)  
- Elemental Adept (magic damage bonuses vs elementals)  

---

# 10. Implementation Summary

## 10.1 Lua Files
- `MortalDelveInstances.cpp/h` (C++ implementation)
- `MortalPublicDungeonAI.cpp/h` (C++ implementation)
- `public_dungeon_spawns.lua`
- `MortalExtractionArtifact.cpp/h` (C++ implementation)
- `altar_rotation.lua`
- `world_boss_manager.lua`
- `MortalTaskBoard.cpp/h` (C++ implementation)
- `seasonal_event_controller.lua`

## 10.2 SQL Files
- `dungeon_spawn_overrides.sql`
- `task_board_entries.sql`
- `cursed_artifacts.sql`

---

# 11. Status
PvE is designed to be **evergreen**, non-linear, and integrated directly into risk/economy systems.  
This subsystem is considered **Core** with major seasonal expansion hooks.

