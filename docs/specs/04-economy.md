# Project Canvas: Mortal Warcraft Overhaul
### Version 26.1 — Hybrid Technical Design Document  
### File: 04-economy.md  
### Section: Economy, Markets, Logistics, and Resource Systems  

---

# 1. Overview

The economic system of Mortal Warcraft is modeled after **EVE Online**, **Runescape**, and **Mortal Online**, with a fully **regional**, **player-driven**, **physical-item** economy.  
Mail is limited to **messages (and optionally gold)**—**items cannot be mailed**. There is no shared bank, and no universal pickup marketplace.

## 1.1 Regional Mail System

### 1.1.1 Mail Restrictions by Risk Zone

The mail system is restricted based on zone risk tier to support regional economy and create demand for courier contracts:

**Green Zones:**
- **Full Mail Access**: Mail works within same region
- **Message & Gold Only**: Can send messages and gold (no items)
- **Regional Only**: Cannot send mail across regions
- **No Restrictions**: Full mail functionality within Green zones

**Yellow Zones:**
- **Limited Mail**: Mail only works to/from Green zones
- **No Yellow-to-Yellow**: Cannot send mail directly between Yellow zones
- **Must Use Green Hubs**: Must travel to Green zones to send/receive mail
- **Message & Gold Only**: Can send messages and gold (no items)

**Red Zones:**
- **No Mail**: All mail functionality disabled
- **Forces Courier Contracts**: Players must use courier contracts for item transport
- **No Message/Gold Transfer**: Cannot send messages or gold via mail in Red zones
- **Physical Transport Only**: All communication/transport must be physical

### 1.1.2 Mail System Rules

**Regional Mail Only:**
- Mail only works within the same region (e.g., Stormwind region, Ironforge region)
- No cross-region mail (forces physical transport)
- Items cannot be mailed (must use courier contracts)
- Messages and gold can be mailed within region

**Integration with Courier System:**
- Mail restrictions create demand for courier contracts
- Items must be physically transported (supports economy)
- Courier contracts become essential for cross-region transport
- Supports regional banking (players must travel to access banks)

**Implementation:**
- Mail restrictions controlled by zone risk tier
- Mail NPCs check zone risk before allowing mail
- Red zone mail NPCs removed or disabled
- Yellow zone mail NPCs only allow Green zone destinations

### 1.1.3 Economy Impact

**Regional Economy:**
- Forces physical transport between regions
- Creates demand for courier contracts
- Makes courier contracts valuable
- Supports regional banking (players must travel to access banks)

**Travel Decisions:**
- Players must choose: mail (Green zones) vs. courier (Yellow/Red zones)
- Ground travel through Yellow/Red zones requires preparation
- Courier escorts become essential for safe transport

---

This document defines:

- Regional banks  
- Market stalls  
- Courier contracts  
- Resource tiers  
- Caravans & hauling  
- Inflation control  
- Blueprint Originals/Copies  
- Vendor economies  
- Crafting material lifecycle  
- Gold sinks  
- Player taxation  
- Economic events and seasons  

This is one of the **core pillars** of the overhaul.

---

## Related Specs

For full context on economy systems, see:

- **`10-crafting-economy.md`** — Crafting economy, material costs, and production chains
- **`37-economy-system-extensions.md`** — Extended economy features (blessings, item decay, repair costs)
- **`13-caravans-contracts.md`** — Caravan system for transporting goods between regional banks
- **`03-risk-zones.md`** — Risk tiers that affect trade routes, market access, and outlaw restrictions
- **`05-crafting.md`** — Crafting system that produces goods for the economy
- **`19-itemization.md`** — Item tiers and values that drive economic activity
- **`51-factions-and-standing-system.md`** — Faction standing that affects market access and vendor prices

---

# 2. Regional Banking

## 2.1 Regional Bank Rules
- Each city has its own **separate** bank storage.
- Items do **not** transfer between regions automatically.
- Outlaws cannot use most banks.
- Bank size varies by city.

Example:
- Stormwind bank ≠ Ironforge bank ≠ Booty Bay bank.

## 2.2 Rationale
- Encourages meaningful travel.  
- Creates regional scarcity.  
- Enables hauling, piracy, and trade routes.

## 2.3 Implementation

C++:
- Override `Banker Gossip` logic.
- Add zone-based restrictions in `RegionalBank.cpp`.

SQL:
- `character_regional_bank.sql`

### 2.3.1 Regional Bank Schema

**Table: `character_regional_bank`**

Complete schema definition:

```sql
CREATE TABLE IF NOT EXISTS `character_regional_bank` (
  `guid` INT UNSIGNED NOT NULL COMMENT 'Player GUID (FK to characters.guid)',
  `zone_id` SMALLINT UNSIGNED NOT NULL COMMENT 'Zone ID (e.g., 1519 for Stormwind, 1537 for Ironforge)',
  `slot` TINYINT UNSIGNED NOT NULL COMMENT 'Bank Slot (0-27 for main bank, 28+ for bag slots)',
  `item_guid` INT UNSIGNED NOT NULL COMMENT 'GUID of the Item instance (FK to item_instance.guid)',
  `item_entry` MEDIUMINT UNSIGNED NOT NULL COMMENT 'Item Template ID (FK to item_template.entry)',
  `count` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Stack Count (1-255)',
  `last_updated` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Unix timestamp of last modification',
  PRIMARY KEY (`guid`, `zone_id`, `slot`),
  INDEX `idx_guid_zone` (`guid`, `zone_id`),
  INDEX `idx_item_guid` (`item_guid`),
  INDEX `idx_zone_id` (`zone_id`),
  CONSTRAINT `fk_regional_bank_character` FOREIGN KEY (`guid`) 
    REFERENCES `characters` (`guid`) ON DELETE CASCADE,
  CONSTRAINT `fk_regional_bank_item` FOREIGN KEY (`item_guid`) 
    REFERENCES `item_instance` (`guid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci 
COMMENT='Stores items per zone-based bank. Each player has separate bank storage per zone.';
```

**Schema Details:**

**Primary Key:**
- Composite key: `(guid, zone_id, slot)` ensures one item per slot per zone per player

**Indexes:**
- `idx_guid_zone`: Fast lookup of all items for a player in a specific zone
- `idx_item_guid`: Fast lookup of item instances (for item tracking)
- `idx_zone_id`: Fast lookup of all players' items in a zone (for admin queries)

**Foreign Keys:**
- `guid` → `characters.guid`: Cascades delete when character is deleted
- `item_guid` → `item_instance.guid`: Cascades delete when item is deleted

**Constraints:**
- `slot`: 0-27 for main bank, 28+ for bag slots (max 255)
- `count`: 1-255 (stack size limit)
- `zone_id`: Valid WoW zone ID (SMALLINT UNSIGNED)

**Zone ID Reference:**
Common zone IDs for regional banking:
- Stormwind: 1519
- Ironforge: 1537
- Darnassus: 1657
- Orgrimmar: 1637
- Thunder Bluff: 1638
- Undercity: 1497
- Booty Bay: 35
- Gadgetzan: 440
- Ratchet: 17

**Bank Size by City:**
- Major Cities (Stormwind, Ironforge, Orgrimmar, etc.): 28 main slots + 6 bag slots
- Minor Cities (Booty Bay, Gadgetzan, etc.): 14 main slots + 3 bag slots
- Outlaw Encampments: 7 main slots (no bag slots)

## 2.4 Complete Vendor-to-Regional Mapping

All WoW 3.3.5a vendors are converted to regional vendors, creating localized economies and trade routes.

### Vendor Conversion Rules

**Global Vendors → Regional Vendors:**
- Each vendor belongs to a specific region
- Outlaws cannot use vendors in Green/Yellow zones
- Vendor inventory varies by region
- Prices may vary by region (supply/demand)

**Vendor Types by Region:**

| Vendor Type | Original Function | Mortal Conversion | Regional Access | Notes |
|-------------|-------------------|-------------------|----------------|-------|
| **General Goods** | Global access | Regional vendors | Green/Yellow zones | Basic supplies, varies by region |
| **Weapon Vendors** | Global access | Regional vendors | Green/Yellow zones | Basic weapons, regional stock |
| **Armor Vendors** | Global access | Regional vendors | Green/Yellow zones | Basic armor, regional stock |
| **Food Vendors** | Global access | Regional vendors | All zones | Food/drink, regional recipes |
| **Repair Vendors** | Global access | Regional vendors | Green/Yellow zones | Repair services, regional pricing |
| **Reagent Vendors** | Global access | Regional vendors | Green/Yellow zones | Crafting materials, regional stock |
| **Mount Vendors** | Global access | Regional vendors | Green zones only | Mount reins, regional mounts |
| **Pet Vendors** | Global access | Regional vendors | Green zones only | Companion items, regional pets |
| **Auctioneers** | Global AH | Market stall NPCs | Green/Yellow zones | Replaced by market stall system |
| **Bankers** | Global banks | Regional bankers | Green/Yellow zones | Regional bank access |
| **Innkeepers** | Rest/repair | Innkeepers | All zones | Rest services, regional inns |
| **Stable Masters** | Pet stables | Mount stables | Green zones only | Mount storage, regional stables |
| **Flight Masters** | Flight paths | Flight paths | Green/Yellow zones | Regional flight network |

### Regional Vendor Placement

**Green Zones (Starting Areas):**
- Full vendor access (all types)
- Safe trading hubs
- Examples: Stormwind, Ironforge, Orgrimmar, Thunder Bluff

**Yellow Zones (Mid-Game):**
- Limited vendor access (basic goods, repair, food)
- Regional banks available
- Market stalls available
- Examples: Port Meridian, Greycrag, regional hubs

**Red Zones (End-Game):**
- No standard vendors (too dangerous)
- Fence NPCs only (outlaw vendors)
- Black market vendors (rare, hidden)
- Examples: Outlaw encampments, hidden caves

### Vendor Restrictions by Notoriety

**Innocent Players:**
- Full access to all vendors in Green/Yellow zones
- No access to Red zone vendors (except fences)

**Criminals:**
- Limited access in Yellow zones (fence NPCs only)
- No access to Green zone vendors
- Full access to Red zone vendors

**Outlaws:**
- No access to Green/Yellow zone vendors
- Fence NPCs only in Yellow zones
- Full access to Red zone vendors
- Outlaw-specific vendors (black market)

### Regional Vendor Inventory

**Inventory Variation:**
- Each region has unique vendor stock
- Stock rotates weekly (supply/demand simulation)
- Regional specialties (e.g., Stormwind = cloth, Ironforge = metalwork)
- Prices vary by region (local economy)

**Stock Examples:**
- **Stormwind:** Cloth, tailoring materials, Alliance-themed items
- **Ironforge:** Metalwork, blacksmithing materials, Dwarf-themed items
- **Orgrimmar:** Leather, Horde-themed items, tribal materials
- **Port Meridian:** General goods, trade materials, neutral items

### Vendor Conversion Implementation

**SQL Mapping:**
```sql
-- Map vendors to regions
CREATE TABLE mortal_vendor_regions (
    vendor_entry INT PRIMARY KEY,
    region_id INT NOT NULL,
    vendor_type VARCHAR(32) NOT NULL,
    access_restriction TINYINT NOT NULL DEFAULT 0, -- 0=all, 1=criminals, 2=outlaws
    notes VARCHAR(255) NULL
);
```

**C++ Implementation:**
- `MortalVendorSystem.cpp/h` - Regional vendor access control
- `VendorInventoryManager.cpp/h` - Regional inventory management
- `OutlawVendorRestrictions.cpp/h` - Outlaw access restrictions

---

# 3. Market Stalls (Player Vendors)

## 3.1 Overview
There is **no** global auction house.  
Instead, every major city contains **rentable stalls**.

## 3.2 Rules
- Player rents a stall for X days with gold.
- Each stall is a static NPC with:
  - Custom name
  - Items for sale
  - Inventory limit
- Stalls display items **physically** in the world.

## 3.3 Search Visibility
- Global visibility:  
  Players can **see listings from all cities**, but **must travel** to the originating city to pick up goods. This is the same “regional auction board” concept referenced elsewhere—**no mail or remote pickup**.

## 3.4 Terminology (Used Across Economy Specs)
- “Market Stalls,” “Regional Auction Board,” and “Global Listing Board” all refer to the **same system**:
  - Global search visibility, **local pickup only**
  - No item delivery by mail or remote claim
  - Regional banking rules still apply

## 3.4 Implementation
Lua:
- `MortalMarketStalls.cpp/h` (C++ implementation)
- `stall_inventory.lua`

SQL:
- `market_stalls.sql`

### 3.3.1 Market Stall Schema

**Table: `market_stalls`**

Complete schema definition:

```sql
CREATE TABLE IF NOT EXISTS `market_stalls` (
    `stall_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `owner_guid` INT UNSIGNED NOT NULL COMMENT 'Player GUID who owns this stall (FK to characters.guid)',
    `stall_name` VARCHAR(100) NOT NULL DEFAULT 'Player Stall' COMMENT 'Custom name for the stall',
    `creature_entry` INT UNSIGNED NOT NULL COMMENT 'NPC entry for the stall vendor',
    `creature_guid` INT UNSIGNED DEFAULT NULL COMMENT 'Spawned creature GUID (if spawned)',
    `map_id` SMALLINT UNSIGNED NOT NULL COMMENT 'Map ID where stall is located',
    `zone_id` SMALLINT UNSIGNED NOT NULL COMMENT 'Zone ID where stall is located',
    `x` FLOAT NOT NULL COMMENT 'X coordinate',
    `y` FLOAT NOT NULL COMMENT 'Y coordinate',
    `z` FLOAT NOT NULL COMMENT 'Z coordinate',
    `o` FLOAT NOT NULL DEFAULT 0 COMMENT 'Orientation',
    `is_active` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT '1=active/open, 0=closed',
    `rent_cost` INT UNSIGNED NOT NULL DEFAULT 100000 COMMENT 'Daily rent in copper (10 gold default)',
    `rent_due` TIMESTAMP NOT NULL DEFAULT 0 COMMENT 'When rent is next due (Unix timestamp)',
    `created_at` TIMESTAMP NOT NULL DEFAULT 0 COMMENT 'When stall was created',
    PRIMARY KEY (`stall_id`),
    KEY `idx_owner` (`owner_guid`),
    KEY `idx_location` (`map_id`, `zone_id`),
    KEY `idx_creature` (`creature_entry`, `creature_guid`),
    CONSTRAINT `fk_stall_owner` FOREIGN KEY (`owner_guid`) 
        REFERENCES `characters` (`guid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Player-owned market stalls';
```

**Table: `market_stall_items`**

Items for sale at each stall:

```sql
CREATE TABLE IF NOT EXISTS `market_stall_items` (
    `stall_id` INT UNSIGNED NOT NULL COMMENT 'FK to market_stalls.stall_id',
    `slot` TINYINT UNSIGNED NOT NULL COMMENT 'Vendor slot (0-39, max 40 items per stall)',
    `item_entry` INT UNSIGNED NOT NULL COMMENT 'Item template ID (FK to item_template.entry)',
    `item_count` INT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Quantity for sale',
    `price` INT UNSIGNED NOT NULL COMMENT 'Price in copper per item',
    `max_count` INT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Max items in this slot',
    `current_count` INT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Current stock remaining',
    PRIMARY KEY (`stall_id`, `slot`),
    KEY `idx_item` (`item_entry`),
    CONSTRAINT `fk_stall_items_stall` FOREIGN KEY (`stall_id`) 
        REFERENCES `market_stalls` (`stall_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Items for sale at market stalls';
```

**Table: `market_stall_transactions`**

Purchase history and transaction logging:

```sql
CREATE TABLE IF NOT EXISTS `market_stall_transactions` (
    `transaction_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `stall_id` INT UNSIGNED NOT NULL COMMENT 'FK to market_stalls.stall_id',
    `buyer_guid` INT UNSIGNED NOT NULL COMMENT 'Buyer player GUID',
    `seller_guid` INT UNSIGNED NOT NULL COMMENT 'Stall owner GUID',
    `item_entry` INT UNSIGNED NOT NULL COMMENT 'Item purchased',
    `item_count` INT UNSIGNED NOT NULL COMMENT 'Quantity purchased',
    `price_paid` INT UNSIGNED NOT NULL COMMENT 'Total price paid in copper',
    `transaction_time` TIMESTAMP NOT NULL DEFAULT 0 COMMENT 'When transaction occurred',
    PRIMARY KEY (`transaction_id`),
    KEY `idx_stall` (`stall_id`),
    KEY `idx_buyer` (`buyer_guid`),
    KEY `idx_seller` (`seller_guid`),
    KEY `idx_time` (`transaction_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Market stall purchase history';
```

**Table: `market_stall_locations`**

Pre-defined stall locations in cities:

```sql
CREATE TABLE IF NOT EXISTS `market_stall_locations` (
    `location_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `map_id` SMALLINT UNSIGNED NOT NULL COMMENT 'Map ID',
    `zone_id` SMALLINT UNSIGNED NOT NULL COMMENT 'Zone ID',
    `x` FLOAT NOT NULL COMMENT 'X coordinate',
    `y` FLOAT NOT NULL COMMENT 'Y coordinate',
    `z` FLOAT NOT NULL COMMENT 'Z coordinate',
    `o` FLOAT NOT NULL DEFAULT 0 COMMENT 'Orientation',
    `is_occupied` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '1=occupied, 0=available',
    `stall_id` INT UNSIGNED DEFAULT NULL COMMENT 'Currently rented stall (FK to market_stalls.stall_id)',
    `rent_cost` INT UNSIGNED NOT NULL DEFAULT 100000 COMMENT 'Daily rent in copper',
    PRIMARY KEY (`location_id`),
    KEY `idx_location` (`map_id`, `zone_id`),
    KEY `idx_occupied` (`is_occupied`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Available stall locations in cities';
```

**Schema Details:**

**Rental System:**
- Stalls must be rented daily (default: 10 gold/day)
- Rent is due at `rent_due` timestamp
- If rent is not paid, stall becomes inactive (`is_active = 0`)
- After 7 days of non-payment, stall is automatically closed and items returned to owner

**Inventory Limits:**
- Maximum 40 items per stall (slots 0-39)
- Each slot can hold a stackable item with `max_count` limit
- `current_count` tracks remaining stock (decrements on purchase)

**Location System:**
- Pre-defined locations in major cities (Stormwind, Orgrimmar, Ironforge, Booty Bay)
- Players rent available locations (where `is_occupied = 0`)
- Location coordinates stored for NPC spawning

**Transaction Logging:**
- All purchases are logged for economic tracking
- Supports analytics and anti-fraud measures
- Indexed by stall, buyer, seller, and time for fast queries

---

# 4. Courier Contracts (Logistics Layer)

Modeled after EVE’s contract system.

## 4.1 What They Do
Players create:
- Delivery contracts  
- Hauling tasks  
- Protected escort missions  

Contracts include:
- Pickup location
- Dropoff location
- Reward
- Collateral

## 4.2 Purpose
- Creates hauling careers
- Introduces piracy opportunities
- Supports guild logistics networks
- Enables trade route gameplay loops

## 4.3 Implementation
Lua:
- `MortalCourierContracts.cpp/h` (C++ implementation)
- `player_contract_board.lua`

SQL:
- `contracts.sql`

---

# 5. Resource Tiers & Distribution

### Resource progression defines risk progression.

| Tier | Zone Type | Examples | Used For |
|------|-----------|----------|----------|
| 1 | Green | Copper, Light Leather | Early tools/gear |
| 2 | Yellow Low | Iron, Medium Leather | Mid-tier equipment |
| 3 | Yellow High | Mithril, Thick Leather | Endgame crafting |
| 4 | Red | Thorium, Enchanted Woods | High-end gear, masterwork components |
| 5 | Red Rare | Dreamscale, Blood of Legends | Legendary blueprints & artifacts |

## 5.1 Seasonal Variation
Every **season**, some zones shift resource spawns to maintain:
- Economic freshness
- Long-term replayability
- Dynamic hotspots

Lua:
- `resource_rotation.lua`

---

# 5.5 Regional Currency & Tokens

### 5.5.1 Emblem Conversion to Regional Tokens

Original WoW 3.3.5a **Emblems** (currency items) are converted to **Regional Tokens** that support Mortal's regional economy and faction system.

**Conversion Strategy:**
- Each region has its own token type (e.g., Stormwind Token, Ironforge Token, Orgrimmar Token)
- Emblems become region-specific tokens
- Tokens are earned from task boards, contracts, and faction activities
- Tokens can be traded between players (economy opportunity)

### 5.5.2 Regional Token System

**Token Types:**
- **Civic Tokens**: City-specific tokens (Stormwind, Ironforge, etc.)
- **Faction Tokens**: Faction-specific tokens (Iron Ledger, Shrine Orders, etc.)
- **Regional Tokens**: Zone-specific tokens (Westfall, Redridge, etc.)

**Token Acquisition:**
- Task board rewards (region-specific tasks)
- Contract completion (courier contracts, etc.)
- Faction standing rewards (higher standing = more tokens)
- Regional vendor purchases (can buy tokens with gold)

**Token Usage:**
- Regional vendor purchases (special items, recipes, etc.)
- Faction vendor access (unlock faction-specific items)
- Regional services (bank upgrades, market stall discounts, etc.)
- Can be traded/sold (economy opportunity)

### 5.5.3 Faction Integration

**Faction Standing Affects Tokens:**
- Higher faction standing = more token rewards
- Higher faction standing = better token exchange rates
- Faction standing unlocks token-based purchases
- Supports faction progression system

**Economy Impact:**
- Creates regional economy (different tokens by region)
- Supports faction system (faction standing affects tokens)
- Creates trade opportunities (token trading between players)
- Supports regional banking (tokens stored in regional banks)

### 5.5.4 Implementation

**Token Items:**
- Tokens are items in `item_template` with special flags
- Tokens are stackable and tradeable
- Tokens have regional restrictions (can only use in originating region)
- Tokens can be converted to gold (at regional vendors)

**Database:**
- Token definitions in `item_template`
- Token rewards in task board/contract templates
- Token exchange rates in regional vendor tables

**Integration:**
- Works with regional banking (tokens stored regionally)
- Supports faction system (faction standing affects tokens)
- Creates economy opportunities (token trading)
- Supports regional economy (different tokens by region)

---

# 6. Caravans & Hauling

## 6.1 System Overview
Players can:
- Rent pack animals  
- Load materials onto caravans  
- Travel with physical cargo  
- Hire escorts via contracts  

## 6.2 Caravan Rules
- Moves at reduced speed  
- Cannot mount  
- Automatically dismounts in combat  
- Cargo drops on death  

## 6.3 Implementation
Lua:
- `MortalCaravanSystem.cpp/h` (C++ implementation)

C++:
- `Encumbrance.cpp`

---

# 7. Inflation Control & Gold Sinks

## 7.1 Gold Sinks

- Mount repairs  
- Item repairs (hard decay)  
- Stall rental fees  
- Crafting fluxes  
- Siege costs  
- Guild hall upgrades  
- Stronghold taxation  
- Contract collateral losses  
- Transportation permits  

## 7.2 Controlled Sources of Gold
- Quests award **items**, not gold  
- Task boards generate small, controlled gold  
- No raw gold drops beyond Tier 1 mobs  
- High-end zones drop **resources**, not gold

---

# 8. Blueprint System (BPO/BPC Model)

## 8.1 Blueprint Originals (BPO)
- Permanent  
- Extremely rare  
- Usually acquired via:
  - World bosses
  - Extraction raids
  - Territory warfare victories

## 8.2 Blueprint Copies (BPC)
- Consumable  
- Limited uses (1–5 uses)
- Common trade good  
- Drives crafting economy

## 8.3 Implementation Notes
SQL:
- `schema_blueprints.sql`

Lua:
- `blueprint_usage.lua`

---

# 9. Material Lifecycle

Every material flows through a **4-stage pipeline**:

1. **Raw** (Ore, Logs, Herbs)  
2. **Refined** (Bars, Planks, Oils)  
3. **Components** (Blades, Hilts, Plates)  
4. **Final Items** (Weapons, Armor, Tools)

Each stage requires:
- Workstation objects
- Fuel/fluxes
- Relevant skill levels
- Material Lore

---

# 10. Player Taxation (Guild Sovereignty Integration)

Guilds owning regions may set:
- Resource tax  
- Market stall tax  
- Hauling tariff  
- Repair fees  

Gold goes to:
- Guild stronghold treasury  
- Siege funding  
- NPC guards/upgrades  

---

# 11. Server Economic Events

### Examples:
- “Dreamscale Bloom” (temporary resource spike)  
- “Bandit King Season” (increased caravans)  
- “Market Recession” (stall fees drop)  
- “Plague Year” (alchemy mats spike in value)  

These shift gameplay loops and player behavior.

Lua:
- `seasonal_events.lua`

---

# 12. Implementation Summary

## 12.1 C++ Files
- `RegionalBank.cpp`
- `Encumbrance.cpp`
- `EconomyHooks.cpp`

## 12.2 Lua Files
- `MortalMarketStalls.cpp/h` (C++ implementation)
- `MortalCourierContracts.cpp/h` (C++ implementation)
- `MortalCaravanSystem.cpp/h` (C++ implementation)
- `resource_rotation.lua`
- `seasonal_events.lua`

## 12.3 SQL Files
- `schema_market_stalls.sql`
- `character_regional_bank.sql`
- `schema_blueprints.sql`
- `contracts.sql`
- `resource_distribution.sql`

---

# 13. Status
This subsystem is considered **Core** and expected to evolve with the Sovereignty and Crafting chapters.
