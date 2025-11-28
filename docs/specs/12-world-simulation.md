# Project Canvas: Mortal Warcraft Overhaul
### Version 26.1 — Hybrid Technical Design Document  
### File: 12-world-simulation.md  
### Section: Dynamic World Simulation, Ecosystem AI, Seasons, Weather, Resources & Environmental Hazards

---

# 1. Overview

The world simulation layer transforms Azeroth into a **living sandbox** where:  
- Creatures migrate  
- Ecosystems respond to player activity  
- Nodes dry up or bloom  
- Rare variants emerge  
- Weather affects gameplay  
- Day/night cycles alter mob spawns  
- Seasonal rotations reshape the world  

This system merges ideas from:
- **Mortal Online ecosystem shifts**  
- **Red Dead Redemption wildlife logic**  
- **Guild Wars 2 dynamic events**  
- **Runescape seasonal nodes**  
- **Valheim weather modifiers**

---

## Related Specs

For full context on world simulation systems, see:

- **`03-risk-zones.md`** — Risk tiers that affect ecosystem behavior and resource distribution
- **`06-pve.md`** — PvE content that interacts with dynamic ecosystems and world events
- **`05-crafting.md`** — Crafting system that uses dynamically spawned resources
- **`04-economy.md`** — Economy system affected by resource availability and seasonal changes
- **`52-season-of-the-frontier.md`** — Seasonal system that drives world simulation changes
- **`48-zone-invasions-and-cross-faction-pve.md`** — Zone invasions that affect ecosystem pressure

---

# 2. Dynamic Creature Ecosystem

## 2.1 Spawn Weight System
Creatures no longer spawn with fixed percentages.  
Spawn weights shift dynamically based on:

- Player kill rate  
- Player location density  
- Time of day  
- Regional season  
- Territory control  
- Weather status  

SQL Table:
- `ecosystem_spawn_weights.sql`

### 2.1.1 World Simulation Schema Definitions

**Table: `mortal_ecosystem_spawn_weights`**

Tracks dynamic spawn weights for creatures based on ecosystem state:

```sql
CREATE TABLE IF NOT EXISTS `mortal_ecosystem_spawn_weights` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `creature_entry` INT UNSIGNED NOT NULL COMMENT 'creature_template.entry',
    `zone_id` SMALLINT UNSIGNED NOT NULL COMMENT 'Zone ID where creature spawns',
    `base_weight` FLOAT NOT NULL DEFAULT 10.0 COMMENT 'Base spawn weight (default 10)',
    `current_weight` FLOAT NOT NULL DEFAULT 10.0 COMMENT 'Current dynamic weight',
    `min_weight` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Minimum weight (never 0)',
    `max_weight` FLOAT NOT NULL DEFAULT 50.0 COMMENT 'Maximum weight cap',
    `kill_count_24h` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Kills in last 24 hours',
    `last_kill_time` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Unix timestamp of last kill',
    `player_density_modifier` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Modifier from player activity',
    `season_modifier` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Modifier from current season',
    `weather_modifier` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Modifier from current weather',
    `time_of_day_modifier` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Modifier from day/night cycle',
    `territory_modifier` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Modifier from territory control',
    `updated_at` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Last update timestamp',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_creature_zone` (`creature_entry`, `zone_id`),
    INDEX `idx_zone_id` (`zone_id`),
    INDEX `idx_creature_entry` (`creature_entry`),
    INDEX `idx_current_weight` (`current_weight`),
    FOREIGN KEY (`creature_entry`) REFERENCES `creature_template` (`entry`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci 
COMMENT='Dynamic spawn weights for ecosystem simulation';
```

**Table: `mortal_ecosystem_relations`**

Defines predator-prey relationships and ecosystem interactions:

```sql
CREATE TABLE IF NOT EXISTS `mortal_ecosystem_relations` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `predator_entry` INT UNSIGNED NOT NULL COMMENT 'Predator creature entry',
    `prey_entry` INT UNSIGNED NOT NULL COMMENT 'Prey creature entry',
    `relation_type` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT '1=predator-prey, 2=competitor, 3=symbiotic',
    `hunt_rate` FLOAT NOT NULL DEFAULT 0.1 COMMENT 'Rate at which predator hunts prey (0.0-1.0)',
    `population_impact` FLOAT NOT NULL DEFAULT 0.05 COMMENT 'Impact on prey population per hunt',
    `migration_trigger_threshold` FLOAT NOT NULL DEFAULT 0.3 COMMENT 'Predator density that triggers prey migration',
    `zone_id` SMALLINT UNSIGNED NULL COMMENT 'Zone-specific relation (NULL = global)',
    `is_active` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1=active, 0=disabled',
    `notes` VARCHAR(255) NULL COMMENT 'Description of relationship',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_predator_prey_zone` (`predator_entry`, `prey_entry`, `zone_id`),
    INDEX `idx_predator` (`predator_entry`),
    INDEX `idx_prey` (`prey_entry`),
    INDEX `idx_zone` (`zone_id`),
    FOREIGN KEY (`predator_entry`) REFERENCES `creature_template` (`entry`) ON DELETE CASCADE,
    FOREIGN KEY (`prey_entry`) REFERENCES `creature_template` (`entry`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci 
COMMENT='Predator-prey and ecosystem relationships';
```

**Table: `mortal_territory_world_modifiers`**

Tracks how guild territory control affects world simulation:

```sql
CREATE TABLE IF NOT EXISTS `mortal_territory_world_modifiers` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `territory_id` INT UNSIGNED NOT NULL COMMENT 'FK to mortal_territory_control_points.id',
    `guild_id` INT UNSIGNED NULL COMMENT 'Guild that controls territory (NULL = neutral)',
    `node_respawn_multiplier` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Resource node respawn rate (1.0 = normal, 1.5 = 50% faster)',
    `predator_aggression_multiplier` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Predator aggression (1.0 = normal, 0.5 = 50% less)',
    `seasonal_bonus_multiplier` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Seasonal bonus stacking (1.0 = normal, 1.2 = 20% bonus)',
    `unique_harvest_zones` TEXT NULL COMMENT 'JSON array of unique harvest zone IDs',
    `guild_only_access` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '1=guild members only, 0=public',
    `updated_at` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Last update timestamp',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_territory` (`territory_id`),
    INDEX `idx_guild` (`guild_id`),
    FOREIGN KEY (`territory_id`) REFERENCES `mortal_territory_control_points` (`id`) ON DELETE CASCADE,
    FOREIGN KEY (`guild_id`) REFERENCES `guild` (`guildid`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci 
COMMENT='Territory control effects on world simulation';
```

**Table: `mortal_migration_events`**

Tracks creature migration events between zones:

```sql
CREATE TABLE IF NOT EXISTS `mortal_migration_events` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `creature_entry` INT UNSIGNED NOT NULL COMMENT 'Migrating creature entry',
    `source_zone_id` SMALLINT UNSIGNED NOT NULL COMMENT 'Zone migrating from',
    `target_zone_id` SMALLINT UNSIGNED NOT NULL COMMENT 'Zone migrating to',
    `migration_type` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT '1=normal, 2=weather, 3=seasonal, 4=pressure',
    `creature_count` INT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Number of creatures migrating',
    `trigger_reason` VARCHAR(255) NULL COMMENT 'Reason for migration',
    `started_at` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Migration start time',
    `completed_at` INT UNSIGNED NULL COMMENT 'Migration completion time (NULL = in progress)',
    `is_broadcast` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '1=broadcast to zone, 0=silent',
    PRIMARY KEY (`id`),
    INDEX `idx_creature` (`creature_entry`),
    INDEX `idx_source_zone` (`source_zone_id`),
    INDEX `idx_target_zone` (`target_zone_id`),
    INDEX `idx_started_at` (`started_at`),
    FOREIGN KEY (`creature_entry`) REFERENCES `creature_template` (`entry`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci 
COMMENT='Creature migration events between zones';
```

**Table: `mortal_alpha_variants`**

Tracks rare alpha variant spawns and their properties:

```sql
CREATE TABLE IF NOT EXISTS `mortal_alpha_variants` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `base_creature_entry` INT UNSIGNED NOT NULL COMMENT 'Base creature template',
    `alpha_entry` INT UNSIGNED NOT NULL COMMENT 'Alpha variant creature entry',
    `spawn_chance` FLOAT NOT NULL DEFAULT 0.01 COMMENT 'Base spawn chance (1% default)',
    `pressure_trigger_threshold` FLOAT NOT NULL DEFAULT 0.7 COMMENT 'Ecosystem pressure that increases spawn chance',
    `stat_multiplier` FLOAT NOT NULL DEFAULT 1.5 COMMENT 'Stat multiplier vs base creature',
    `loot_tier_bonus` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Loot tier bonus (M-T1 to M-T5)',
    `zone_id` SMALLINT UNSIGNED NULL COMMENT 'Zone-specific alpha (NULL = global)',
    `is_active` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1=active, 0=disabled',
    `description` VARCHAR(255) NULL COMMENT 'Alpha variant description',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_base_alpha_zone` (`base_creature_entry`, `alpha_entry`, `zone_id`),
    INDEX `idx_base_creature` (`base_creature_entry`),
    INDEX `idx_alpha_entry` (`alpha_entry`),
    INDEX `idx_zone` (`zone_id`),
    FOREIGN KEY (`base_creature_entry`) REFERENCES `creature_template` (`entry`) ON DELETE CASCADE,
    FOREIGN KEY (`alpha_entry`) REFERENCES `creature_template` (`entry`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci 
COMMENT='Alpha variant creature definitions';
```

**Table: `mortal_weather_zones`**

Tracks current weather state per zone:

```sql
CREATE TABLE IF NOT EXISTS `mortal_weather_zones` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `zone_id` SMALLINT UNSIGNED NOT NULL UNIQUE COMMENT 'Zone ID',
    `current_weather_type` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0=clear, 1=rain, 2=storm, 3=fog, 4=snow, 5=heatwave',
    `weather_intensity` FLOAT NOT NULL DEFAULT 0.0 COMMENT 'Weather intensity (0.0-1.0)',
    `started_at` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Weather start time',
    `duration_sec` INT UNSIGNED NOT NULL DEFAULT 3600 COMMENT 'Weather duration in seconds',
    `transition_chance` FLOAT NOT NULL DEFAULT 0.1 COMMENT 'Chance to transition to different weather',
    `season_modifier` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Season-based weather frequency',
    `updated_at` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Last update timestamp',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_zone` (`zone_id`),
    INDEX `idx_weather_type` (`current_weather_type`),
    INDEX `idx_started_at` (`started_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci 
COMMENT='Current weather state per zone';
```

**Table: `mortal_daynight_cycle`**

Tracks day/night cycle state and modifiers:

```sql
CREATE TABLE IF NOT EXISTS `mortal_daynight_cycle` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `zone_id` SMALLINT UNSIGNED NOT NULL COMMENT 'Zone ID',
    `current_phase` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0=dawn, 1=day, 2=dusk, 3=night',
    `phase_start_time` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Current phase start time (server time)',
    `phase_duration_sec` INT UNSIGNED NOT NULL DEFAULT 3600 COMMENT 'Phase duration in seconds',
    `spawn_modifier` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Spawn rate modifier for current phase',
    `creature_behavior_modifier` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Creature behavior modifier',
    `updated_at` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Last update timestamp',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_zone` (`zone_id`),
    INDEX `idx_phase` (`current_phase`),
    INDEX `idx_phase_start` (`phase_start_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci 
COMMENT='Day/night cycle state per zone';
```

**Table: `mortal_seasonal_states`**

Tracks seasonal world state and rotations:

```sql
CREATE TABLE IF NOT EXISTS `mortal_seasonal_states` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `zone_id` SMALLINT UNSIGNED NOT NULL COMMENT 'Zone ID',
    `current_season` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0=spring, 1=summer, 2=autumn, 3=winter',
    `season_start_date` DATE NOT NULL COMMENT 'Season start date',
    `season_end_date` DATE NOT NULL COMMENT 'Season end date',
    `resource_rotation_multiplier` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Resource spawn multiplier',
    `creature_spawn_modifier` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Creature spawn modifier',
    `weather_frequency_modifier` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Weather frequency modifier',
    `migration_trigger_chance` FLOAT NOT NULL DEFAULT 0.1 COMMENT 'Chance to trigger migrations',
    `updated_at` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Last update timestamp',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_zone_season` (`zone_id`, `current_season`),
    INDEX `idx_zone` (`zone_id`),
    INDEX `idx_season` (`current_season`),
    INDEX `idx_dates` (`season_start_date`, `season_end_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci 
COMMENT='Seasonal state per zone';
```

**Table: `mortal_resource_node_simulation`**

Tracks dynamic resource node spawns and depletion:

```sql
CREATE TABLE IF NOT EXISTS `mortal_resource_node_simulation` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `node_entry` INT UNSIGNED NOT NULL COMMENT 'GameObject entry for resource node',
    `zone_id` SMALLINT UNSIGNED NOT NULL COMMENT 'Zone ID',
    `spawn_location_x` FLOAT NOT NULL COMMENT 'X coordinate',
    `spawn_location_y` FLOAT NOT NULL COMMENT 'Y coordinate',
    `spawn_location_z` FLOAT NOT NULL COMMENT 'Z coordinate',
    `current_state` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT '0=depleted, 1=active, 2=blooming',
    `depletion_count` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Times harvested',
    `last_harvest_time` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Last harvest timestamp',
    `respawn_timer_sec` INT UNSIGNED NOT NULL DEFAULT 300 COMMENT 'Respawn timer in seconds',
    `bloom_chance` FLOAT NOT NULL DEFAULT 0.1 COMMENT 'Chance to bloom (rare state)',
    `territory_modifier` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Territory control respawn modifier',
    `season_modifier` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Season-based spawn modifier',
    `created_at` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Node creation time',
    `updated_at` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Last update timestamp',
    PRIMARY KEY (`id`),
    INDEX `idx_node_entry` (`node_entry`),
    INDEX `idx_zone` (`zone_id`),
    INDEX `idx_state` (`current_state`),
    INDEX `idx_location` (`zone_id`, `spawn_location_x`, `spawn_location_y`),
    FOREIGN KEY (`node_entry`) REFERENCES `gameobject_template` (`entry`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci 
COMMENT='Dynamic resource node simulation and depletion';
```

### 2.1.2 Schema Relationships

**Ecosystem Flow:**
1. `mortal_ecosystem_spawn_weights` → Tracks current spawn weights
2. `mortal_ecosystem_relations` → Defines predator-prey interactions
3. `mortal_migration_events` → Records migration history
4. `mortal_alpha_variants` → Defines rare spawn variants
5. `mortal_territory_world_modifiers` → Applies territory effects
6. `mortal_weather_zones` → Weather state affects spawns
7. `mortal_daynight_cycle` → Day/night affects creature behavior
8. `mortal_seasonal_states` → Seasons affect all systems
9. `mortal_resource_node_simulation` → Dynamic resource spawning

**Update Frequency:**
- Spawn weights: Updated every 5-15 minutes
- Weather: Updated every 30-60 minutes
- Day/night: Updated every hour (phase transitions)
- Seasons: Updated daily or on season change
- Resource nodes: Updated on harvest/respawn
- Migration events: Created on-demand when triggered

Lua:
- `MortalDynamicEcosystem.cpp/h` (C++ implementation)

## 2.2 Ecosystem Pressure
If players overhunt wolves in Elwynn:
- Wolf spawn weight decreases  
- Boar/Deer spawn weight increases  
- Rare variants appear due to stress  

Opposite occurs if area is ignored.

## 2.3 Predator–Prey Logic
If predators become too abundant:
- Herbivore populations shrink  
- Predators migrate to new zones  

Predator/Prey relationships defined in:
- `ecosystem_relations.sql`

---

# 3. Migratory Mobs

## 3.1 Migration Rules
Creatures may migrate:
- At night  
- When hunted heavily  
- During weather events  
- Between seasons  
- When pushed by guild activity  

Example:
- Raptors in the Barrens move toward Stonetalon during storm season.

Lua:
- `MortalMigrationController.cpp/h` (C++ implementation)

## 3.2 Migration Events
Rare migration events:
- Kodo herds travel across the Barrens  
- Dragon whelps migrate to Winterspring  
- Undead packs roam EPL at midnight  

Migration events broadcast zone-wide.

---

# 4. Rare Variants (Alpha Spawns)

## 4.1 Alpha Variant Rules
5% base chance to spawn a rare variant.

Alphas have:
- Increased stats  
- Unique visuals/effects  
- Better material drops  
- Chance to drop “Essence” items  

## 4.2 Ultra-Rare Mythic Variants
0.05% chance (1 in 2000)

Mythic variants drop:
- Legendary crafting mats  
- Unique cosmetic trophies  
- Rare mount components  

Lua:
- `MortalAlphaVariant.cpp/h` (C++ implementation)

---

# 5. Weather System

Weather affects:
- Movement  
- Visibility  
- Elemental damage  
- Resource spawns  
- Creature aggression  

## 5.1 Weather Types
- Clear  
- Rain  
- Storm  
- Fog  
- Blizzard  
- Heatwave  
- Magical anomaly (rare)  

## 5.2 Weather Effects Examples
### Rain
- -10% fire damage  
- +10% lightning damage  

### Fog
- -40% visibility  
- +20% rogue stealth efficiency  
- Rare ghost mobs spawn  

### Blizzard
- Movement slow  
- +Cold resistance nodes spawn  

Lua:
- `MortalWeatherController.cpp/h` (C++ implementation)

---

# 6. Day/Night Cycle Enhancements

## 6.1 Night Modifier Set
At night:
- Undead spawn more frequently  
- Wolves gain +10% damage  
- Fireflies spawn  
- Rare spectral variants appear  

## 6.2 Day Modifier Set
Daylight boosts:
- Herbivore density  
- Node respawns  
- Merchant NPC activity  

Lua:
- `MortalDayNight.cpp/h` (C++ implementation)

---

# 7. Seasonal World States

Seasons shift every **4–8 weeks**.

### Seasons:
1. **Spring – Bloom Cycle**
2. **Summer – Heat Cycle**
3. **Autumn – Harvest Cycle**
4. **Winter – Frost Cycle**

## 7.1 Seasonal Effects

### Spring
- Herb spawns doubled  
- Dream essence nodes appear  
- Animals reproduce → more mobs

### Summer
- Fire elementals spawn  
- Water mobs weaken  
- Heatwave weather events

### Autumn
- Best gathering season  
- Nodes yield increased  
- Bandit activity increases

### Winter
- Undead invasion  
- Blizzard storms  
- Ice fishing nodes spawn  

Lua:
- `seasonal_world_controller.lua`

---

# 8. Resource Node Simulation

Nodes react to:
- Overharvesting  
- Player density  
- Season  
- Weather  
- Guild territory control  

## 8.1 Node Fatigue
If overharvested:
- Nodes go dormant  
- New nodes spawn in neighboring zones  

## 8.2 Node Bloom Events
During seasonal boosts:
- Massive cluster spawns  
- Temporary rare resource hotspots  

Lua:
- `dynamic_node_system.lua`

---

# 9. Environmental Hazards

Environmental hazards add depth to risk zones and create emergent gameplay opportunities. Players must prepare for environmental challenges, creating demand for crafted items and consumables.

## 9.1 Hazard Types
- Lava fields  
- Frostbite zones  
- Void rifts  
- Cursed tombs  
- Storm strike zones  
- **Cold Weather (Northrend-specific)** - See section 9.4

## 9.2 Effects
Hazards apply:
- DoT  
- Slows  
- Vision distortion  
- Random debuffs  

## 9.3 Risk/Reward
Hazards spawn:
- Best resource nodes  
- Rare alphas  
- Event bosses  

## 9.4 Northrend Cold Weather System

### 9.4.1 Cold Weather Mechanics

Northrend zones feature a **Cold Weather environmental hazard system** that adds depth to risk zones and creates emergent gameplay:

**Cold Weather Effects:**
- **Frostbite DoT**: Continuous damage over time in cold zones
- **Movement Speed Reduction**: Cold slows movement
- **Stamina Drain**: Cold weather drains stamina faster
- **Visibility Reduction**: Blizzards reduce visibility (increases PvP risk)

**Mitigation:**
- **Warm Clothing**: Crafted items that reduce cold effects
- **Consumables**: Hot drinks/food that provide temporary cold resistance
- **Shelter**: Buildings and caves provide temporary warmth
- **Fire Sources**: Campfires and torches provide warmth radius

### 9.4.2 Integration with Risk Zones

**Cold Weather Scaling:**
- **Green Zones (Northrend)**: Minimal cold effects (safe zones)
- **Yellow Zones (Northrend)**: Moderate cold effects (requires preparation)
- **Red Zones (Northrend)**: Severe cold effects (cold + PvP = higher stakes)

**Risk/Reward:**
- Cold weather zones spawn:
  - Rare cold-weather resources
  - Unique crafting materials
  - High-value nodes
  - Rare alpha variants adapted to cold

### 9.4.3 Economy Impact

**Crafting Demand:**
- Warm clothing becomes essential for Northrend exploration
- Hot consumables create crafting economy
- Cold-resistant gear becomes valuable trade goods
- Supports player-driven economy (crafting, trading)

**Travel Decisions:**
- Players must prepare for cold weather
- Creates meaningful choices (gear vs. inventory space)
- Cold weather increases risk in Red zones (cold + PvP)
- Makes courier contracts more valuable (cold + danger)

### 9.4.4 Implementation

**Zone-Based Cold:**
- All Northrend zones have cold weather mechanics
- Cold intensity varies by zone risk tier
- Cold effects stack with other environmental hazards

**Crafting Integration:**
- Warm clothing recipes available from crafting trainers
- Hot consumables from cooking/alchemy
- Cold-resistant materials from Northrend resource nodes

**Integration:**
- Part of `12-world-simulation.md` environmental hazards
- Scales with zone risk tier
- Creates crafting demand (supports economy)
- Increases risk in Red zones (supports risk-based world)

Lua:
- `environmental_hazards.lua`
- `northrend_cold_weather.lua`

---

# 10. World Event Integration

World simulation ties directly into events:

### Examples:
- Midnight Horde (undead season)  
- Elemental storm invasions  
- Caravan ambushes during storm weather  
- Kodo migrations during Summer  
- Emerald Dream blooms in Spring  

Events trigger dynamically from simulation signals.

---

# 11. Territory Control Interaction

Guild-owned regions modify simulation:
- Higher node respawn  
- Lower predator aggression  
- Seasonal bonuses stacked  
- Unique guild-only harvest zones appear  

SQL:
- `territory_world_modifiers.sql`

---

# 12. Complete GameObject Conversion Strategy

This section provides a comprehensive mapping of all WoW 3.3.5a GameObjects to Mortal Warcraft's world simulation system.

## 12.1 GameObject Conversion Rules

**All GameObjects Convert to Mortal GameObjects:**
- Original GameObject entries → Mortal GameObject entries
- GameObject visuals preserved (same model/display ID)
- GameObject functions converted to Mortal systems
- GameObject placement converted to Mortal risk zones

**Conversion Process:**
1. Original GameObject entry → Mortal GameObject entry
2. GameObject visual → Preserved in Mortal GameObject
3. GameObject function → Converted to Mortal system
4. GameObject placement → Converted to Mortal risk zones

## 12.2 GameObject Type Conversion

| WoW GameObject Type | Original Function | Mortal Conversion | Placement | Notes |
|---------------------|-------------------|-------------------|-----------|-------|
| **Workstations** | Crafting stations | Crafting workstations | Green/Yellow zones | Anvils, forges, looms, etc. |
| **Resource Nodes** | Gathering nodes | Dynamic resource nodes | All zones | Mining/herb nodes, dynamic spawns |
| **Shrines** | Respawn points | Shrine respawn system | Green/Yellow zones | Shrine Order shrines |
| **Altars** | Ritual altars | Purification altars | Red zones | Extraction raid altars |
| **Chests** | Loot containers | Loot containers | All zones | Full-loot rules apply |
| **Doors** | Zone barriers | Zone barriers | All zones | Preserved |
| **Mailboxes** | Mail access | Regional mailboxes | Green/Yellow zones | Regional mail system |
| **Bank Vaults** | Bank access | Regional banks | Green/Yellow zones | Regional banking |
| **Auction Houses** | AH access | Market stalls | Green/Yellow zones | Market stall system |
| **Inns** | Rest/repair | Inns | All zones | Rest services |
| **Stables** | Pet storage | Mount stables | Green zones only | Mount storage |
| **Flight Masters** | Flight paths | Flight paths | Green/Yellow zones | Regional flight network |

## 12.3 Workstation Conversion

**Crafting Workstations:**
- **Anvils:** Blacksmithing workstations (Green/Yellow zones)
- **Forges:** Smelting/refining workstations (Green/Yellow zones)
- **Looms:** Tailoring workstations (Green/Yellow zones)
- **Tanning Racks:** Leatherworking workstations (Green/Yellow zones)
- **Alchemy Labs:** Alchemy workstations (Green/Yellow zones)
- **Engineering Stations:** Engineering workstations (Green/Yellow zones)
- **Arcane Foci:** Runecrafting workstations (Green/Yellow zones)
- **Cooking Fires:** Cooking workstations (All zones, portable)

**Workstation Placement:**
- **Green Zones:** Full workstation access (all types)
- **Yellow Zones:** Limited workstation access (basic types)
- **Red Zones:** No standard workstations (too dangerous)
- **Guild Strongholds:** Upgraded workstations (T2-T5)

## 12.4 Resource Node Conversion

**Mining Nodes:**
- **Original:** Fixed spawn locations
- **Mortal:** Dynamic spawn system (ecosystem-based)
- **Placement:** All zones (tier-based)
- **Respawn:** Dynamic (based on player activity)

**Herb Nodes:**
- **Original:** Fixed spawn locations
- **Mortal:** Dynamic spawn system (ecosystem-based)
- **Placement:** All zones (tier-based)
- **Respawn:** Dynamic (based on player activity)

**Fishing Nodes:**
- **Original:** Water bodies
- **Mortal:** Dynamic fishing spots (ecosystem-based)
- **Placement:** All zones (tier-based)
- **Respawn:** Dynamic (based on player activity)

## 12.5 Shrine Conversion

**Shrine Order Shrines:**
- **Original:** Various shrines (Light, Nature, etc.)
- **Mortal:** Shrine Order shrines (regional respawn points)
- **Placement:** Green/Yellow zones (strategic locations)
- **Function:** Respawn points, faction standing bonuses

**Shrine Types:**
- **Light Shrines:** Green zones (safe respawn)
- **Nature Shrines:** Yellow zones (mid-risk respawn)
- **Shadow Shrines:** Red zones (high-risk respawn, rare)

## 12.6 Altar Conversion

**Purification Altars:**
- **Original:** Various altars (ritual, etc.)
- **Mortal:** Purification altars (extraction raid altars)
- **Placement:** Red zones (extraction raid locations)
- **Function:** Purify cursed artifacts

**Altar Types:**
- **Minor Altars:** Public dungeons (M-T1-T2)
- **Major Altars:** Extraction raids (M-T3-T4)
- **Grand Altars:** Legendary raids (M-T5)

## 12.7 New GameObject Placements

**Mortal-Specific GameObjects:**
- **Task Boards:** Green/Yellow zones (task/contract access)
- **Market Stalls:** Green/Yellow zones (player vendors)
- **Regional Banks:** Green/Yellow zones (regional banking)
- **Courier Stations:** Green/Yellow zones (contract pickup)
- **Stronghold Banners:** Yellow/Red zones (guild claiming)
- **Purification Altars:** Red zones (extraction raids)

## 12.8 GameObject Access Restrictions

**Zone-Based Restrictions:**
- **Green Zones:** Full GameObject access (all types)
- **Yellow Zones:** Limited GameObject access (basic types)
- **Red Zones:** Restricted GameObject access (altars, chests only)

**Notoriety-Based Restrictions:**
- **Innocent Players:** Full GameObject access (Green/Yellow zones)
- **Criminals:** Limited GameObject access (fence NPCs only)
- **Outlaws:** No GameObject access (Green/Yellow zones)

## 12.9 GameObject Conversion Examples

### Workstations

| Original GameObject | Original Entry | Mortal GameObject | Mortal Entry | Placement |
|---------------------|---------------|-------------------|--------------|-----------|
| Anvil | GO 1 | Mortal Anvil | GO 80001 | Green/Yellow zones |
| Forge | GO 2 | Mortal Forge | GO 80002 | Green/Yellow zones |
| Loom | GO 3 | Mortal Loom | GO 80003 | Green/Yellow zones |
| Tanning Rack | GO 4 | Mortal Tanning Rack | GO 80004 | Green/Yellow zones |

### Shrines

| Original GameObject | Original Entry | Mortal GameObject | Mortal Entry | Placement |
|---------------------|---------------|-------------------|--------------|-----------|
| Light Shrine | GO 100 | Shrine: Light | GO 80100 | Green zones |
| Nature Shrine | GO 101 | Shrine: Nature | GO 80101 | Yellow zones |
| Shadow Shrine | GO 102 | Shrine: Shadow | GO 80102 | Red zones (rare) |

### Altars

| Original GameObject | Original Entry | Mortal GameObject | Mortal Entry | Placement |
|---------------------|---------------|-------------------|--------------|-----------|
| Ritual Altar | GO 200 | Purification Altar (Minor) | GO 80200 | Red zones (M-T1-T2) |
| Grand Altar | GO 201 | Purification Altar (Major) | GO 80201 | Red zones (M-T3-T4) |
| Legendary Altar | GO 202 | Purification Altar (Grand) | GO 80202 | Red zones (M-T5) |

---

# 13. Implementation Summary

## 12.1 Lua Files
- `MortalDynamicEcosystem.cpp/h` (C++ implementation)
- `MortalMigrationController.cpp/h` (C++ implementation)
- `MortalAlphaVariant.cpp/h` (C++ implementation)
- `MortalWeatherController.cpp/h` (C++ implementation)
- `MortalDayNight.cpp/h` (C++ implementation)
- `seasonal_world_controller.lua`
- `dynamic_node_system.lua`
- `environmental_hazards.lua`

## 12.2 SQL Files
- `ecosystem_spawn_weights.sql`
- `ecosystem_relations.sql`
- `territory_world_modifiers.sql`

## 12.3 C++ Files
- `WeatherHooks.cpp`
- `DayNightHooks.cpp`
- `SpawnOverride.cpp`

---

# 13. Status
World Simulation is **Core** and feeds directly into PvE, PvP, crafting, caravans, and seasonal content.

