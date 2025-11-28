# WoW 3.3.5a Feature Analysis Framework

## Purpose

This document provides a systematic framework for analyzing AzerothCore 3.3.5a and researching original World of Warcraft 3.3.5a features to identify what needs overhaul or rework to blend optimally with Mortal Warcraft's design.

---

## Analysis Categories

### 1. Zones & World Geography
- **Original WoW 3.3.5a Features:**
  - All zones (Kalimdor, Eastern Kingdoms, Northrend, Outland)
  - Zone types (Contested, Alliance, Horde, Sanctuary)
  - Zone levels and scaling
  - Flight paths and travel networks
  - Zone-specific mechanics (weather, events)

- **Mortal Overhaul Requirements:**
  - Risk tier classification (Green/Yellow/Red)
  - Zone-by-zone redesign for risk-based gameplay
  - Travel restrictions and logistics
  - Resource distribution by risk tier
  - Stronghold placement opportunities

- **Analysis Methods:**
  - Search: `Map.dbc`, `AreaTable.dbc` references
  - Web: "WoW 3.3.5a zone list complete"
  - Codebase: `03-risk-zones.md`, zone conversion specs
  - Database: `zones_risk_flags.sql`, zone tables

### 2. Dungeons & Instances
- **Original WoW 3.3.5a Features:**
  - All dungeons (5-man, 10-man, 25-man)
  - Instance lockouts and reset mechanics
  - Dungeon difficulty modes (Normal, Heroic)
  - Instance portals and entrances
  - Dungeon-specific mechanics and bosses

- **Mortal Overhaul Requirements:**
  - Public dungeon conversion (de-instanced)
  - Extraction raid mechanics
  - Delve system (safe solo PvE)
  - Instance tier mapping for progression
  - Risk-based dungeon placement

- **Analysis Methods:**
  - Search: "WoW 3.3.5a dungeon list complete"
  - Codebase: `06-pve.md`, `33-instance-and-battleground-tier-mapping.md`
  - Database: Instance tables, dungeon definitions
  - Web: Dungeon boss lists, mechanics documentation

### 3. Raids & Bosses
- **Original WoW 3.3.5a Features:**
  - All raid instances (Naxxramas, Ulduar, ICC, etc.)
  - Raid bosses and encounter mechanics
  - Raid lockouts and loot systems
  - World bosses (Kazzak, Azuregos, etc.)
  - Boss abilities and phases

- **Mortal Overhaul Requirements:**
  - Extraction raid conversion
  - World boss rebalancing
  - Cursed artifact system integration
  - Public raid mechanics
  - Boss scaling for skill-based progression

- **Analysis Methods:**
  - Search: "WoW 3.3.5a raid list bosses"
  - Codebase: `06-pve.md`, `74-cursed-artifacts-and-extraction-system.md`
  - Database: Boss tables, encounter data
  - Web: Boss ability lists, encounter guides

### 4. User Interface (UI)
- **Original WoW 3.3.5a Features:**
  - Minimap and world map
  - Quest log and tracking
  - Action bars and hotkeys
  - Character panel
  - Inventory and bags
  - Chat system
  - Tooltips
  - Addon API

- **Mortal Overhaul Requirements:**
  - MortalUI suite (custom panels)
  - Risk zone overlays
  - Territory control displays
  - Task board UI
  - Contract management UI
  - Nameplate modifications
  - Map restrictions (Red Zone fog-of-war)

- **Analysis Methods:**
  - Search: "WoW 3.3.5a UI features minimap"
  - Codebase: `15-ui-client.md`, `20-aio-ui-basics.md`
  - Web: UI documentation, addon API references
  - Client: DBC files, UI frame references

### 5. Quest System
- **Original WoW 3.3.5a Features:**
  - Quest types (Kill, Collect, Escort, etc.)
  - Quest chains and storylines
  - Daily quests
  - Quest rewards (XP, gold, items)
  - Quest tracking and objectives

- **Mortal Overhaul Requirements:**
  - Task board system (replaces XP quests)
  - Contract system
  - No XP rewards (skill-based only)
  - Quest conversion strategy
  - Dynamic task generation

- **Analysis Methods:**
  - Search: "WoW 3.3.5a quest types complete"
  - Codebase: `63-quest-conversion-strategy.md`, `76-dynamic-tasks-and-contracts-2-0-spec.md`
  - Database: Quest tables, quest templates
  - Web: Quest database references

### 6. NPCs & Creatures
- **Original WoW 3.3.5a Features:**
  - All NPC types (vendors, quest givers, guards, etc.)
  - Creature families and types
  - NPC scaling and levels
  - Guard systems
  - Vendor inventories

- **Mortal Overhaul Requirements:**
  - NPC rebalancing for skill-based progression
  - Guard behavior by risk zone
  - Regional vendor systems
  - Faction standing integration
  - Mercenary system integration

- **Analysis Methods:**
  - Search: "WoW 3.3.5a NPC types complete"
  - Codebase: `32-npc-and-encounter-rebalance.md`
  - Database: Creature templates, NPC data
  - Web: NPC database references

### 7. Items & Equipment
- **Original WoW 3.3.5a Features:**
  - Item tiers and quality (Common, Rare, Epic, Legendary)
  - Item stats and ratings
  - Set bonuses
  - Enchantments and gems
  - Item level system

- **Mortal Overhaul Requirements:**
  - Stat budget system (STR/AGI/STA/INT/SPI only)
  - Rune system (replaces talents/enchants)
  - Quality tiers (Shoddy to Legendary)
  - Material-based crafting
  - Durability decay system

- **Analysis Methods:**
  - Search: "WoW 3.3.5a item system stats"
  - Codebase: `19-itemization.md`, `75-mortal-gear-and-runes-spec.md`
  - Database: Item templates, stat definitions
  - Web: Item database, stat system documentation

### 8. Combat & Abilities
- **Original WoW 3.3.5a Features:**
  - Class abilities and talents
  - Spell system
  - Combat formulas
  - PvP mechanics
  - Crowd control

- **Mortal Overhaul Requirements:**
  - Classless system
  - Skill-based abilities
  - Brace mechanic
  - Rewritten combat formulas
  - Risk-based PvP

- **Analysis Methods:**
  - Search: "WoW 3.3.5a combat system formulas"
  - Codebase: `02-combat.md`, `84-mortal-core-stats-and-combat-model.md`
  - Database: Spell tables, ability definitions
  - Web: Combat system documentation

### 9. Economy & Trading
- **Original WoW 3.3.5a Features:**
  - Auction house
  - Global mail system
  - Vendor pricing
  - Currency systems
  - Trade skills

- **Mortal Overhaul Requirements:**
  - Regional banking (no global mail)
  - Market stalls (local pickup)
  - Courier contracts
  - Regional economy
  - Blueprint system (BPO/BPC)

- **Analysis Methods:**
  - Search: "WoW 3.3.5a economy auction house"
  - Codebase: `04-economy.md`, `37-economy-system-extensions.md`
  - Database: Economy tables, vendor data
  - Web: Economy documentation

### 10. Social & Group Systems
- **Original WoW 3.3.5a Features:**
  - Guild system
  - Group finder
  - Friend list
  - Ignore list
  - Chat channels

- **Mortal Overhaul Requirements:**
  - Guild sovereignty system
  - Stronghold ownership
  - Territory control
  - Faction system (not Alliance/Horde)
  - Public grouping for events

- **Analysis Methods:**
  - Search: "WoW 3.3.5a guild system"
  - Codebase: `08-guilds-sovereignty.md`, `38-social-and-onboarding-systems.md`
  - Database: Guild tables, social systems
  - Web: Social system documentation

---

## Research Methods

### 1. Codebase Analysis
```bash
# Search for AzerothCore/WoW references
grep -r "azerothcore\|wotlk\|3\.3\.5" docs/specs/
grep -r "zone\|dungeon\|instance\|raid" docs/specs/
grep -r "ui\|minimap\|map\|interface" docs/specs/

# Search implementation files
find . -name "*.cpp" -o -name "*.h" | xargs grep -l "zone\|dungeon\|instance"
```

### 2. Database Analysis
```sql
-- Zone analysis
SELECT * FROM area_table WHERE ...;
SELECT * FROM map WHERE ...;

-- Instance analysis
SELECT * FROM instance_template WHERE ...;
SELECT * FROM creature WHERE map IN (...);

-- Quest analysis
SELECT * FROM quest_template WHERE ...;
```

### 3. Web Research Queries
- "World of Warcraft 3.3.5a [feature] complete list"
- "WoW WotLK [feature] database"
- "AzerothCore 3.3.5a [feature] implementation"
- "WoW 3.3.5a [feature] mechanics"

### 4. DBC File Analysis
- `Map.dbc` - Zone and map definitions
- `AreaTable.dbc` - Area definitions
- `DungeonMap.dbc` - Dungeon mappings
- `WorldMapArea.dbc` - World map data
- `WorldMapOverlay.dbc` - Map overlays

---

## Feature Inventory Tracker

See `wow-3.3.5a-feature-inventory.md` for detailed tracking of:
- Original features cataloged
- Overhaul requirements identified
- Implementation status
- Priority and dependencies

---

## Priority Framework

### Critical (Must Overhaul)
- Zones → Risk tier classification
- Combat system → Classless, skill-based
- Economy → Regional banking, no global mail
- Progression → Skill-based, no XP

### High Priority (Major Impact)
- Dungeons → Public dungeon conversion
- Raids → Extraction raid mechanics
- UI → MortalUI suite, risk overlays
- Items → Stat budget, rune system

### Medium Priority (Enhancement)
- Quests → Task board conversion
- NPCs → Rebalancing for skill system
- Social → Faction system overhaul
- Abilities → Skill-based system

### Low Priority (Polish)
- Visual effects
- Sound design
- Animation updates
- Cosmetic systems

---

## Next Steps

1. **Create Feature Inventory Tracker** - Systematic catalog of all features
2. **Research Original Features** - Web searches and documentation review
3. **Map Overhaul Requirements** - Link original features to Mortal requirements
4. **Prioritize Overhauls** - Create implementation roadmap
5. **Track Progress** - Update inventory as work progresses

