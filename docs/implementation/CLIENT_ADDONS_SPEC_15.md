# Client-Side Addons for Spec 15

**Date:** 2025-01-XX  
**Status:** 📋 **Structure and Documentation for Client Addon Development**

---

## Overview

Spec 15 requires extensive client-side addon development. This document provides the structure and requirements for all client-side addons.

---

## MortalUI Meta-Addon Structure

```
Interface/AddOns/
└── MortalUI/
    ├── MortalUI.lua
    ├── MortalUI.xml
    ├── modules/
    │   ├── config_enforcer.lua
    │   ├── ui_map_pins.lua
    │   ├── ui_nameplate_driver.lua
    │   ├── ui_tooltip_injector.lua
    │   ├── ui_stats_overlay.lua
    │   ├── ui_hunger_display.lua
    │   ├── ui_encumbrance_display.lua
    │   ├── ui_crime_status.lua
    │   └── ui_risk_zone_banner.lua
    ├── assets/
    │   ├── fonts/
    │   ├── textures/
    │   └── icons/
    ├── embeds.xml
    └── MortalUI.toc
```

---

## Required Addons

### 1. Mortal_Nameplates (Fork of TidyPlates)

**Features:**
- Criminal/Outlaw color coding
- Guild war/alliance markers
- Bounty icons
- Caravaneer/Escort/Carrier icons
- Derived Level display
- Encumbrance indicator
- Conditional styles per zone (Green/Yellow/Red)

**Files:**
- `Mortal_Nameplates/Mortal_Nameplates.lua`
- `Mortal_Nameplates/Mortal_Nameplates.xml`
- `Mortal_Nameplates/Mortal_Nameplates.toc`

**Integration:**
- Server sends nameplate data via custom packets
- Client renders based on zone and player state

---

### 2. Mortal_Stats (Fork of Extended Character Stats)

**Removes:**
- Hit rating
- Spell penetration
- Defense rating
- Crit rating
- Haste rating

**Adds:**
- Derived Level
- Attribute cap tracking (150 per attribute / 400 total)
- Skill summaries
- Hunger
- Encumbrance
- Temperature exposure
- Regional influence bonuses
- Guild stronghold buffs

**Files:**
- `Mortal_Stats/Mortal_Stats.lua`
- `Mortal_Stats/Mortal_Stats.xml`
- `Mortal_Stats/Mortal_Stats.toc`

**Integration:**
- Query stats from server via custom packets
- Display in character frame

---

### 3. Mortal_Tooltips (Wrapper + Injector)

**Features:**
- Item weight display
- Weight class display
- Material properties display
- Crafting requirements display
- Lore skill requirements display
- Zone-based risk indicators
- "Drops on death: Yes/No" display
- Reputation bonuses display

**Files:**
- `Mortal_Tooltips/Mortal_Tooltips.lua`
- `Mortal_Tooltips/Mortal_Tooltips.xml`
- `Mortal_Tooltips/Mortal_Tooltips.toc`

**Integration:**
- Hook into `GameTooltip` events
- Query item data from server
- Inject custom tooltip lines

---

### 4. Crime Status Display

**Features:**
- Current notoriety tier display
- Timer for criminal flag
- Bounty (if any) display
- Outlaw map visibility toggle

**Files:**
- `MortalUI/modules/ui_crime_status.lua`

**Integration:**
- Server sends crime status via custom packets
- Display as UI frame near minimap

---

### 5. Encumbrance Display

**Features:**
- Total weight display
- Movement speed updates
- Flash red when overloaded

**Files:**
- `MortalUI/modules/ui_encumbrance_display.lua`

**Integration:**
- Server sends encumbrance data
- Display as bar above player frame

---

### 6. Risk Zone Banner

**Features:**
- Risk level display (Green/Yellow/Red)
- Loot rules
- Crime consequences

**Files:**
- `MortalUI/modules/ui_risk_zone_banner.lua`

**Integration:**
- Server sends zone change event
- Display large banner on zone entry

---

### 7. Hunger Display

**Features:**
- Hunger bar above player frame
- Color-coded (green/yellow/red)
- Affects stamina & regen display

**Files:**
- `MortalUI/modules/ui_hunger_display.lua`

**Integration:**
- Server sends hunger data
- Display as bar

---

## Wrapped Addons Configuration

### Immersion
- Auto-disable during PvP or criminal flag
- Sandbox dialogue pacing
- Mortal fonts & borders

### DynamicCam
- "Over-the-shoulder" action cam presets
- Auto-switch to classic camera during PvP/dungeons/raids

### Bagnon
- Add "Drops on Death?" icon
- Show item weight per slot
- Panic colorization (red) if overloaded

### Bartender4
- Pre-made Mortal profile
- Centralized ability bar
- Left/right utility bars
- Shift+Scroll inventory bar toggles

### Mapster + HandyNotes
- Territory overlays
- World boss markers
- Caravan routes
- Trade hub highlights

---

## Client-Side Performance Rules

### Red Zones:
- Lower draw distance
- Reduce clutter
- Disable cosmetic particle spam
- Simplify nameplate textures
- Auto-disable Immersion & DynamicCam

### Green Zones:
- Full UI
- Immersion re-enabled
- Action cam allowed
- Cosmetic extras enabled

---

## Launcher Integration (Rust/Tauri)

**Required Features:**
- Addons installed correctly
- Hash checks for Mortal forks
- DBC patches applied
- Client settings locked:
  - Camera distance
  - Spell detail
  - Nameplate distance
- "Repair UI" button resets Mortal profiles

---

## DBC Modifications

### TalentTab.dbc
- Replace with Universal Mastery Trees
- 3 Tabs: Warlord, Guardian, Explorer

### Item.dbc
- Remove level requirements
- Add skill requirements
- Add item categories:
  - Material families
  - Weight classes
  - Craft tiers

### Spell.dbc
- Brace mechanic spell
- Hunger debuffs
- Encumbrance penalties
- Crime flag visual effects

---

## Implementation Priority

### Phase 1 (Critical):
1. Mortal_Nameplates
2. Mortal_Stats
3. Mortal_Tooltips
4. Risk Zone Banner

### Phase 2 (Important):
5. Crime Status Display
6. Encumbrance Display
7. Hunger Display
8. Config Enforcer

### Phase 3 (Polish):
9. Wrapped addons configuration
10. Client-side performance rules
11. Launcher integration
12. DBC modifications

---

## Development Notes

- All addons must be compatible with WoW 3.3.5a
- Use standard WoW API functions
- Custom packets for server communication
- Follow WoW addon coding standards
- Test with multiple UI scales
- Ensure accessibility (readable fonts, clear indicators)

---

**Status:** 📋 **Structure documented - Ready for addon development**

