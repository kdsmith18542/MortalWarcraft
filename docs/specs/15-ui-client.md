# Project Canvas: Mortal Warcraft Overhaul
### Version 26.1 — Hybrid Technical Design Document  
### File: 15-ui-client.md  
### Section: UI/Client Architecture, MortalUI Addon Suite, Nameplates, Tooltips, Maps, Launcher & DBC Modifications

---

# 1. Overview

This document defines the **complete UI/Client architecture** for Mortal Warcraft, including:

- MortalUI addon suite (meta-addon)
- Forked & wrapped addons
- Nameplate driver
- Tooltip injector
- Map overlay engine
- Character stats overhaul
- Config enforcement
- Launcher → Addon → Server integration
- DBC modifications for skill-based progression

This file assumes the **MortalUI addon already exists**, and will **extend, refine, and formalize** it based on all new systems we've created.

---

## Related Specs

For full context on UI and client systems, see:

- **`20-aio-ui-basics.md`** — AIO (AzerothCore IO) UI system architecture
- **`18-lfg-warfront-ui.md`** — LFG and warfront UI components
- **`84-mortal-core-stats-and-combat-model.md`** — Stat formulas displayed in UI
- **`03-risk-zones.md`** — Risk zone indicators shown in UI
- **`02-combat.md`** — Combat mechanics displayed in UI tooltips and nameplates
- **`85-mortal-chat-and-channels.md`** — Chat system integrated into UI
- **`24-webportal-mortal-atlas.md`** — Web portal that complements in-game UI

---

# 2. MortalUI Architecture

MortalUI is a **meta-addon**, meaning it:

- Depends on required third-party addons  
- Ships custom Mortal addons  
- Applies default configuration  
- Enforces compatibility  
- Bridges client → Lua → Server logic  
- Loads only the assets needed for the overhaul  

### 2.1 MortalUI Folder Structure

```
Interface/
└── AddOns/
    ├── MortalUI/
    │   ├── MortalUI.lua
    │   ├── MortalUI.xml
    │   ├── modules/
    │   │   ├── config_enforcer.lua
    │   │   ├── ui_map_pins.lua
    │   │   ├── ui_nameplate_driver.lua
    │   │   ├── ui_tooltip_injector.lua
    │   │   ├── ui_stats_overlay.lua
    │   │   ├── ui_hunger_display.lua
    │   │   ├── ui_encumbrance_display.lua
    │   │   ├── ui_crime_status.lua
    │   │   ├── ui_risk_zone_banner.lua
    │   ├── assets/
    │   │   ├── fonts/
    │   │   ├── textures/
    │   │   ├── icons/
    │   ├── embeds.xml
    │   └── TOC
```

---

# 3. Forked Addons (Mortal Versions)

## 3.1 Mortal_Nameplates (Fork of TidyPlates)

### Why fork:
Combat readability is the backbone of a high-risk sandbox MMO.

### Features:
- Criminal/Outlaw color coding  
- Guild war / alliance markers  
- Bounty icons  
- Caravaneer / Escort / Carrier icons  
- Derived Level display  
- Encumbrance indicator  
- Conditional styles per zone (Green/Yellow/Red)

### Required assets:
- Custom healthbar textures (SharedMedia)
- Icon set for:
  - Notoriety  
  - Guild war  
  - Bounty  
  - Caravan crates  
  - Stronghold defenders  

Lua:
- `ui_nameplate_driver.lua`

---

## 3.2 Mortal_Stats (Fork of Extended Character Stats)

### Removes:
- Hit rating  
- Spell penetration  
- Defense rating  
- Crit rating  
- Haste rating  

### Adds:
- Derived Level  
- Attribute cap tracking (150 per attribute / 400 total)  
- Skill summaries  
- Hunger  
- Encumbrance  
- Temperature exposure  
- Regional influence bonuses  
- Guild stronghold buffs  

---

## 3.3 Mortal_Tooltips (Wrapper + Injector)

### Provides:
- Item weight  
- Weight class  
- Material properties  
- Crafting requirements  
- Lore skill requirements  
- Zone-based risk indicators  
- “Drops on death: Yes/No”  
- Reputation bonuses  

Lua:
- `ui_tooltip_injector.lua`

---

# 4. Wrapped Addons (Pre-Configured)

These remain upstream but are **configured, locked, and themed** by MortalUI.

## 4.1 Immersion (Quest Dialogue Enhancer)
- Sandbox dialogue pacing  
- Auto-disable during PvP or criminal flag  
- Uses Mortal fonts & borders

## 4.2 DynamicCam
- “Over-the-shoulder” action cam presets  
- Auto-switches to classic camera during:
  - PvP  
  - Dungeons  
  - Raids  

## 4.3 Bagnon
- Required for inventory management in full-loot game  
- Adds “Drops on Death?” icon  
- Shows item weight per slot  
- Panic colorization (red) if overloaded

## 4.4 Bartender4
- Pre-made Mortal profile:
  - Centralized ability bar  
  - Left/right utility bars  
  - Shift+Scroll inventory bar toggles  

## 4.5 Mapster + HandyNotes
Used for:
- Territory overlays  
- World boss markers  
- Caravan routes  
- Trade hub highlights  

---

# 5. Map Overlay Engine

MortalUI’s map system extends HandyNotes with custom render layers.

### Layers:
1. **Guild Sovereignty**
2. **Stronghold Vulnerability Windows**
3. **Territory Control Points**
4. **Active World Bosses**
5. **Kill Hotspots** (5m heatmap)
6. **Caravan Routes (Live)**
7. **Caravan Patrols (NPC)**
8. **Seasonal Resource Bloom Areas**
9. **Hellgate Entrances**
10. **Outlaw Hotspots**

Lua:
- `ui_map_pins.lua`

---

# 6. UI Risk & Crime Indicators

### Risk Zone Banner
A large banner appears when entering:
- Yellow zone  
- Red zone  

Shows:
- Risk level  
- Loot rules  
- Crime consequences  

### Crime Status Display
Shows:
- Current notoriety tier  
- Timer for criminal flag  
- Bounty (if any)  
- Outlaw map visibility toggle  

Lua:
- `ui_crime_status.lua`
- `ui_risk_zone_banner.lua`

---

# 7. Hunger & Encumbrance Displays

### Hunger Bar
- Above player frame  
- Color-coded  
- Affects stamina & regen  

### Encumbrance Display
- Shows total weight  
- Updates movement speed  
- Flash red when overloaded  

Lua:
- `ui_hunger_display.lua`
- `ui_encumbrance_display.lua`

---

# 8. Derived Level & Skill UI

### Skill Interface
Adds:
- Skill search bar  
- Lore categories  
- Resource skills  
- Combat proficiencies  

### Derived Level UI
Placed:
- On player frame  
- On target frame  
- On nameplates  

Lua:
- `ui_stats_overlay.lua`

---

# 8.5 MortalUI Shared Data Contract
All MortalUI modules (forked or bespoke) should consume the same normalized datasets:

| Dataset | Provider | Notes |
|---------|----------|-------|
| `MortalProgressionAPI:GetDerivedLevel()` | Server → Lua (C++ bridge) | Returns clamped derived level (1–25) + skill band. Drives Mentor UI, nameplates, stats overlays. |
| `MortalRiskAPI:GetZoneRisk()` | `ui_risk_zone_banner.lua` | Emits `GREEN/YELLOW/RED`, outlaw state, signage text for banners + map overlays. |
| `MortalContractsAPI:GetActiveContracts()` | Atlas REST + Lua cache | Supplies Task/Contract listings with `min_derived_level`, risk tier, faction tags. Used by Task Board UI, LFG panel. |
| `MortalRenownAPI:GetSeasonProgress()` | Season service | Exposes current renown, rank, pending rewards for Season panels + HUD toasts. |
| `MortalEconomyAPI:GetRegionalPrices()` | Market Stall service | Feeds map pins, tooltip price hints, and caravan planning aids. |

Adhere to these contracts when adding new UI modules or forked addons to avoid divergent terminology or stale data.

---

# 9. MortalUI Config Enforcer

Ensures players cannot break critical UI layers.

### Enforces:
- Nameplates always on in Yellow/Red zones  
- Combat text style  
- Map overlays active  
- Action bars never hidden  
- Tooltip formatting required  
- Hunger/encumbrance display cannot be disabled  

Lua:
- `config_enforcer.lua`

---

# 10. Client-Side Performance Rules

### In Red Zones:
- Lower draw distance  
- Reduce clutter  
- Disable cosmetic particle spam  
- Simplify nameplate textures  
- Auto-disable Immersion & DynamicCam  

### In Green Zones:
- Full UI  
- Immersion re-enabled  
- Action cam allowed  
- Cosmetic extras enabled  

---

# 11. Launcher Integration (Rust/Tauri)

Launcher enforces:
- Addons installed correctly  
- Hash checks for Mortal forks  
- DBC patches applied  
- Client settings locked for:
  - Camera distance  
  - Spell detail  
  - Nameplate distance  
- “Repair UI” button resets Mortal profiles  

---

# 12. DBC Modifications

### 12.1 TalentTab.dbc
Replaced with:
- Universal Mastery Trees  
- 3 Tabs:
  - Warlord  
  - Guardian  
  - Explorer  

### 12.2 Item.dbc
Modifications include:
- Removes level requirements  
- Adds skill requirements  
- Adds item categories for:
  - Material families  
  - Weight classes  
  - Craft tiers  

### 12.3 Spell.dbc
Used for:
- Brace mechanic  
- Hunger debuffs  
- Encumbrance penalties  
- Crime flag visual effects  

---

# 13. Complete UI Element Conversion Mapping

This section provides a comprehensive mapping of all WoW 3.3.5a UI elements to Mortal Warcraft's UI system.

## 13.1 Core UI Elements

| WoW 3.3.5a UI Element | Original Function | Mortal Conversion | Implementation | Status |
|------------------------|-------------------|-------------------|----------------|--------|
| **Minimap** | Standard minimap with quest pins | Risk zone overlays, fog-of-war | `ui_map_pins.lua` | ✅ Designed |
| **World Map** | Full visibility, all POIs | Red Zone fog-of-war, conditional POI visibility | `ui_map_pins.lua`, `39-navigation-and-wayfinding.md` | ✅ Designed |
| **Quest Log** | XP quest tracking | Task board UI, contract tracking | `76-dynamic-tasks-and-contracts-2-0-spec.md` | ✅ Designed |
| **Character Panel** | Class-based stats, talents | Skill-based stats, mastery trees | `Mortal_Stats` addon, `84-mortal-core-stats-and-combat-model.md` | ✅ Designed |
| **Inventory** | Standard bags | Encumbrance display, weight tracking | `Bagnon` (wrapped), `ui_encumbrance_display.lua` | ✅ Designed |
| **Action Bars** | Class spells/abilities | Skill-based abilities, build loadouts | `Bartender4` (wrapped), custom ability system | ✅ Designed |
| **Spellbook** | Class spells | Skill abilities, ability library | Custom UI, `64-spell-and-ability-library.md` | ✅ Designed |
| **Talent Panel** | Class talent trees | Mastery trees (Warlord/Guardian/Explorer) | Custom UI, `01-progression.md` | ✅ Designed |
| **Equipment Manager** | Gear sets | Build loadouts (gear + runes) | Custom UI, `75-mortal-gear-and-runes-spec.md` | ✅ Designed |
| **Quest Tracking** | Quest objectives | Task tracking, contract objectives | Task board UI | ✅ Designed |
| **Calendar** | Event calendar | Event calendar (seasons, warfronts) | Standard calendar, `43-long-term-progression-and-seasons.md` | ✅ Designed |
| **Achievement Panel** | Achievements | Mortal achievement system | Custom UI, `36-mortal-achievements-and-titles-core.md` | ✅ Designed |
| **Dungeon Finder** | LFG tool | Public grouping, warfront signup | `18-lfg-warfront-ui.md` | ✅ Designed |
| **Nameplates** | Standard nameplates | Mortal nameplates (criminal/outlaw indicators) | `Mortal_Nameplates` (forked), `ui_nameplate_driver.lua` | ✅ Designed |
| **Tooltips** | Standard tooltips | Enhanced tooltips (risk zone, weight, etc.) | `Mortal_Tooltips` (wrapped), `ui_tooltip_injector.lua` | ✅ Designed |
| **Chat System** | Standard chat channels | Mortal chat channels (Red Zone restrictions) | `85-mortal-chat-and-channels.md` | ✅ Designed |
| **Unit Frames** | Standard frames | Enhanced frames (skill-based info) | Custom frames, `ui_stats_overlay.lua` | ✅ Designed |

## 13.2 Mortal-Specific UI Elements

| UI Element | Function | Implementation | Status |
|------------|----------|----------------|--------|
| **Risk Zone Banner** | Zone transition warnings | `ui_risk_zone_banner.lua` | ✅ Designed |
| **Crime Status Display** | Notoriety, criminal flag, bounty | `ui_crime_status.lua` | ✅ Designed |
| **Hunger Bar** | Hunger/food status | `ui_hunger_display.lua` | ✅ Designed |
| **Encumbrance Display** | Weight/encumbrance tracking | `ui_encumbrance_display.lua` | ✅ Designed |
| **Derived Level Display** | Skill-based level (1-25) | `ui_stats_overlay.lua` | ✅ Designed |
| **Task Board UI** | Task/contract interface | AIO UI, `76-dynamic-tasks-and-contracts-2-0-spec.md` | ✅ Designed |
| **Faction Standing UI** | Faction reputation display | AIO UI, `51-factions-and-standing-system.md` | ✅ Designed |
| **Stronghold Management UI** | Guild stronghold interface | AIO UI, `08-guilds-sovereignty.md` | ✅ Designed |
| **Warfront Signup UI** | Warfront entry interface | AIO UI, `18-lfg-warfront-ui.md` | ✅ Designed |
| **Mortal Control Panel** | Admin/GM tools | AIO UI, `14-admin-tools.md` | ✅ Designed |

## 13.3 UI Element Specifications

### Minimap Enhancements

**Risk Zone Overlays:**
- Green zones: No overlay
- Yellow zones: Yellow border overlay
- Red zones: Red border overlay + warning icon

**Fog-of-War:**
- Red zones: POIs hidden until discovered
- Yellow zones: POIs visible but not auto-exposed
- Green zones: Full visibility

**Implementation:** `ui_map_pins.lua`, `39-navigation-and-wayfinding.md`

### World Map Enhancements

**Fog-of-War System:**
- Red zones: Areas hidden until explored
- Yellow zones: Conditional POI visibility
- Green zones: Full map visibility

**POI Visibility Rules:**
- Never auto-exposed: Secret dungeons, Black Market, hidden shrines
- Conditionally exposed: Task boards, regional banks, strongholds (based on standing)
- Always exposed: Capital cities, major hubs, shrines

**Implementation:** `ui_map_pins.lua`, `39-navigation-and-wayfinding.md`

### Character Panel Overhaul

**Removed:**
- Class-specific stats
- Hit rating, defense rating, resilience rating
- Spell penetration, expertise rating
- Haste rating, crit rating (as item lines)

**Added:**
- Derived Level (1-25)
- Attribute cap tracking (150 per stat, 400 total)
- Skill summaries (combat, crafting, gathering)
- Hunger status
- Encumbrance status
- Temperature exposure
- Regional influence bonuses
- Guild stronghold buffs

**Implementation:** `Mortal_Stats` addon (forked), `ui_stats_overlay.lua`

### Inventory Enhancements

**Encumbrance Display:**
- Total weight shown
- Weight capacity indicator
- Movement speed penalty display
- Red flash when overloaded

**Weight Classes:**
- Light (0-50 lbs)
- Medium (51-150 lbs)
- Heavy (151-300 lbs)
- Overloaded (300+ lbs)

**Implementation:** `Bagnon` (wrapped), `ui_encumbrance_display.lua`

### Action Bar System

**Skill-Based Abilities:**
- Abilities unlocked via skills (not class)
- Build loadouts (gear + runes + abilities)
- Ability cooldowns and costs displayed

**Build Loadouts:**
- Save/load ability configurations
- Tied to equipment sets
- Quick-swap between builds

**Implementation:** `Bartender4` (wrapped), custom ability system

### Nameplate System

**Criminal/Outlaw Indicators:**
- Criminal: Orange nameplate
- Outlaw: Red nameplate
- Infamous: Skull icon

**Additional Markers:**
- Guild war / alliance markers
- Bounty icons
- Caravaneer / Escort / Carrier icons
- Derived Level display
- Encumbrance indicator

**Zone-Based Styling:**
- Green zones: Standard nameplates
- Yellow zones: Enhanced nameplates (criminal indicators)
- Red zones: Full nameplate info (all indicators)

**Implementation:** `Mortal_Nameplates` (forked), `ui_nameplate_driver.lua`

### Tooltip Enhancements

**Item Tooltips:**
- Item weight
- Weight class
- Material properties
- Crafting requirements
- Lore skill requirements
- Zone-based risk indicators
- "Drops on death: Yes/No"
- Reputation bonuses

**Creature Tooltips:**
- Mortal tier (M-T1 to M-T5)
- Risk zone indicator
- Criminal/outlaw status
- Bounty value (if applicable)

**Implementation:** `Mortal_Tooltips` (wrapped), `ui_tooltip_injector.lua`

### Chat System

**Channel Restrictions:**
- Green zones: All channels available
- Yellow zones: Global chat available (criminal flagging)
- Red zones: No global chat ("radio silence")

**Channel Types:**
- `/say`, `/yell`, `/emote` (zone-local)
- `/whisper` (player-to-player)
- `/party`, `/raid` (group channels)
- `/guild`, `/officer` (guild channels)
- `/world` (global, opt-in, rate-limited)

**Implementation:** `85-mortal-chat-and-channels.md`

## 13.4 UI Configuration Enforcement

**Required UI Elements (Cannot Disable):**
- Nameplates (in Yellow/Red zones)
- Risk zone banner
- Hunger/encumbrance display
- Crime status display
- Combat text style
- Map overlays

**Optional UI Elements:**
- Immersion (quest dialogue enhancer)
- DynamicCam (action camera)
- Cosmetic addons (in Green zones only)

**Implementation:** `config_enforcer.lua`

## 13.5 Performance Optimization

**Red Zone Performance:**
- Lower draw distance
- Reduced clutter
- Simplified nameplate textures
- Auto-disable Immersion & DynamicCam
- Disable cosmetic particle spam

**Green Zone Performance:**
- Full UI enabled
- Immersion re-enabled
- Action cam allowed
- Cosmetic extras enabled

**Implementation:** Zone-based performance rules in `config_enforcer.lua`

---

# 14. Implementation Summary

## Lua Modules (MortalUI)
- `config_enforcer.lua`
- `ui_map_pins.lua`
- `ui_nameplate_driver.lua`
- `ui_tooltip_injector.lua`
- `ui_hunger_display.lua`
- `ui_encumbrance_display.lua`
- `ui_stats_overlay.lua`
- `ui_crime_status.lua`
- `ui_risk_zone_banner.lua`

## Forked Addons
- `Mortal_Nameplates`
- `Mortal_Stats`
- `Mortal_Tooltips`

## Wrapped Addons
- Immersion  
- DynamicCam  
- Bagnon  
- Bartender4  
- Mapster  
- HandyNotes  

## Launcher Actions
- Enforce UI bundle  
- Apply DBC patches  
- Verify hashes  
- Offer “Fix MortalUI” button  

---

# 14. Status
The UI/Client layer is **Core**, tightly integrated into risk exposure, economy travel, combat readability, and sandbox atmosphere.
It is designed for **clarity, immersion, and survival awareness**.

