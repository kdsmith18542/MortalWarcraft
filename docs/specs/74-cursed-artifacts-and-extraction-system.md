# Project Canvas: Mortal Warcraft Overhaul  
### Version 36.0 — Systems Implementation  
### File: 74-cursed-artifacts-and-extraction-system.md  
### Section: Cursed Artifacts, Crown, and Extraction System

---

## 1. Purpose

This spec defines the **Cursed Artifact System**, which powers:

- Act IV & V campaign beats involving:
  - **Major Cursed Artifacts** from raid wings,
  - The **Crown of the Hollow King** itself.
- The unique **Extraction gameplay**:
  - Heavy, non-bankable artifacts,
  - Full-loot risk during transport,
  - World-level consequences on success/failure.

This is a **cross-cutting system** touching:

- Items & loot tables,  
- Encumbrance & movement,  
- Death/loot logic,  
- World state (invasions, shrine penalties),  
- Atlas/MortalUI.

---

## Related Specs

For full context on cursed artifacts and extraction systems, see:

- **`06-pve.md`** — Extraction raids and PvE content that drops artifacts
- **`03-risk-zones.md`** — Risk zones where extraction occurs
- **`02-combat.md`** — Combat mechanics during artifact extraction
- **`11-pvp-systems.md`** — PvP systems that affect artifact transport
- **`13-caravans-contracts.md`** — Caravan system that shares mechanics with extraction
- **`73-act5-endgame-campaign-the-lost-crown.md`** — Campaign content that uses cursed artifacts
- **`15-ui-client.md`** — UI systems that display artifact status and extraction progress

---

## 2. Terminology & Types

### 2.1 Artifact Types

We define three main artifact tiers:

1. **Minor Cursed Relics**  
   - Flavorful drops from:
     - World bosses,
     - Invasions,
     - Rifts,  
   - Primarily economic or cosmetic; not involved in main Extraction loop.

2. **Major Cursed Artifacts**  
   - Dropped from:
     - Raid wings in the Crown Citadel (Act V):  
       - `Tallystone of the Unpaid` (Ledger of Bones),  
       - `Heart of the Forgewrought` (Forgewrought Hall),  
       - `Chorus of the Lost` (Frozen Choir).  
     - Other major raids (see complete mapping below)
   - Heavily interact with:
     - World state (invasion rates, shrine penalties, siege strength).

3. **The Crown of the Hollow King**  
   - Unique, **Primary Cursed Artifact**.  
   - Dropped from the final raid encounter (Hollow King in Icecrown Citadel).  
   - Triggers **Extraction Phase** when looted.

## 2.2 Complete Raid-to-Extraction Mapping

All WoW 3.3.5a raids are converted to **Extraction Raids**. Bosses drop Cursed Artifacts that must be extracted to Purification Altars in the open world.

### Classic Raids

| Raid | Original Type | Mortal Tier | Final Boss | Artifact Type | Extraction Zone | Notes |
|------|--------------|-------------|-----------|---------------|-----------------|-------|
| Molten Core | 40-man | M-T2 | Ragnaros | Major Artifact | Searing Gorge (Red) | High-risk extraction |
| Blackwing Lair | 40-man | M-T2 | Nefarian | Major Artifact | Burning Steppes (Red) | High-risk extraction |
| Zul'Gurub | 20-man | M-T2 | Hakkar | Major Artifact | Stranglethorn Vale (Red) | Full-loot PvP zone |
| Ruins of Ahn'Qiraj | 20-man | M-T2 | General Rajaxx | Major Artifact | Silithus (Red) | High-risk extraction |
| Temple of Ahn'Qiraj | 40-man | M-T2 | C'Thun | Major Artifact | Silithus (Red) | High-risk extraction |
| Onyxia's Lair | 40-man | M-T2 | Onyxia | Major Artifact | Dustwallow Marsh (Yellow) | Mid-risk extraction |

### TBC Raids

| Raid | Original Type | Mortal Tier | Final Boss | Artifact Type | Extraction Zone | Notes |
|------|--------------|-------------|-----------|---------------|-----------------|-------|
| Karazhan | 10-man | M-T2/M-T3 | Prince Malchezaar | Major Artifact | Deadwind Pass (Red) | High-risk extraction |
| Gruul's Lair | 25-man | M-T3 | Gruul | Major Artifact | Blade's Edge Mountains (Yellow) | Mid-risk extraction |
| Magtheridon's Lair | 25-man | M-T3 | Magtheridon | Major Artifact | Hellfire Peninsula (Yellow) | Mid-risk extraction |
| Serpentshrine Cavern | 25-man | M-T3 | Lady Vashj | Major Artifact | Zangarmarsh (Yellow) | Mid-risk extraction |
| The Eye (Tempest Keep) | 25-man | M-T3 | Kael'thas Sunstrider | Major Artifact | Netherstorm (Yellow) | Mid-risk extraction |
| Hyjal Summit | 25-man | M-T3 | Archimonde | Major Artifact | Shadowmoon Valley (Red) | High-risk extraction |
| Black Temple | 25-man | M-T3 | Illidan Stormrage | Major Artifact | Shadowmoon Valley (Red) | High-risk extraction |
| Sunwell Plateau | 25-man | M-T3/M-T4 | Kil'jaeden | Major Artifact | Isle of Quel'Danas (Yellow) | Mid-risk extraction |

### WotLK Raids

| Raid | Original Type | Mortal Tier | Final Boss | Artifact Type | Extraction Zone | Notes |
|------|--------------|-------------|-----------|---------------|-----------------|-------|
| Naxxramas | 10/25-man | M-T3 | Kel'Thuzad | Major Artifact | Eastern Plaguelands (Red) | High-risk extraction |
| The Eye of Eternity | 10/25-man | M-T3 | Malygos | Major Artifact | Borean Tundra (Yellow) | Mid-risk extraction |
| The Obsidian Sanctum | 10/25-man | M-T3 | Sartharion | Major Artifact | Dragonblight (Yellow) | Mid-risk extraction |
| Ulduar | 10/25-man | M-T4 | Yogg-Saron | Major Artifact | The Storm Peaks (Yellow/Red) | Mixed risk extraction |
| Trial of the Crusader | 10/25-man | M-T4 | Anub'arak | Major Artifact | Icecrown (Red) | High-risk extraction |
| Onyxia's Lair (Revamped) | 10/25-man | M-T3 | Onyxia | Major Artifact | Dustwallow Marsh (Yellow) | Mid-risk extraction |
| **Icecrown Citadel** | 10/25-man | M-T4/M-T5 | **The Lich King** | **Crown (Primary)** | **Icecrown (Red)** | **Crown extraction, highest risk** |
| The Ruby Sanctum | 10/25-man | M-T4/M-T5 | Halion | Major Artifact | Dragonblight (Yellow) | Mid-risk extraction |

### Artifact Drop Rules

**Major Artifacts:**
- Drop from final boss of each raid wing
- One artifact per raid clear (first kill only)
- Artifact is soulbound on pickup
- Requires extraction to Purification Altar

**The Crown of the Hollow King:**
- Drops only from The Lich King (Icecrown Citadel final boss)
- Unique globally (only one exists at a time)
- Triggers world-wide Extraction Phase when looted
- Highest priority extraction target

### Extraction Mechanics by Raid Tier

**M-T2 Raids (Classic):**
- Artifacts: Major Artifacts
- Extraction zones: Red zones (high risk)
- Movement penalty: 50% speed reduction
- Extraction time limit: 30 minutes

**M-T3 Raids (TBC, Early WotLK):**
- Artifacts: Major Artifacts
- Extraction zones: Yellow/Red zones (mixed risk)
- Movement penalty: 50% speed reduction
- Extraction time limit: 45 minutes

**M-T4/M-T5 Raids (Late WotLK):**
- Artifacts: Major Artifacts or Crown
- Extraction zones: Red zones (high risk)
- Movement penalty: 50% speed reduction (Crown: 75% reduction)
- Extraction time limit: 60 minutes (Crown: 90 minutes)

## 2.3 Purification Altar Placement Strategy

Purification Altars are open-world locations where Cursed Artifacts must be delivered to complete extraction. Altar locations rotate weekly to prevent camping and add strategic variety.

### Altar Placement Rules

**Zone Risk Requirements:**
- **Major Artifacts:** Altars placed in Yellow or Red zones (mid to high risk)
- **Crown:** Altars placed only in Red zones (highest risk)
- Altars never placed in Green zones (too safe)

**Distance Requirements:**
- Altars must be at least 500-1000 yards from raid entrances
- Altars must be accessible via multiple routes (no single chokepoint)
- Altars should be visible from a distance (landmark placement)

**Rotation System:**
- Altar locations rotate weekly (server reset)
- 3-5 potential altar locations per raid tier
- Rotation announced via autobroadcast and Atlas web portal

### Altar Locations by Raid Tier

**M-T2 Raids (Classic) - Yellow/Red Zone Altars:**

| Raid | Altar Locations (Rotating) | Zone Risk | Notes |
|------|---------------------------|-----------|-------|
| Molten Core | Searing Gorge (3 locations) | Red | High-risk extraction |
| Blackwing Lair | Burning Steppes (3 locations) | Red | High-risk extraction |
| Zul'Gurub | Stranglethorn Vale (4 locations) | Red | Full-loot PvP zone |
| AQ (Both) | Silithus (3 locations) | Red | High-risk extraction |
| Onyxia | Dustwallow Marsh (2 locations) | Yellow | Mid-risk extraction |

**M-T3 Raids (TBC, Early WotLK) - Yellow/Red Zone Altars:**

| Raid | Altar Locations (Rotating) | Zone Risk | Notes |
|------|---------------------------|-----------|-------|
| Karazhan | Deadwind Pass (2 locations) | Red | High-risk extraction |
| Gruul's Lair | Blade's Edge Mountains (2 locations) | Yellow | Mid-risk extraction |
| Black Temple | Shadowmoon Valley (3 locations) | Red | High-risk extraction |
| Naxxramas | Eastern Plaguelands (3 locations) | Red | High-risk extraction |
| Ulduar | The Storm Peaks (3 locations) | Yellow/Red | Mixed risk extraction |

**M-T4/M-T5 Raids (Late WotLK) - Red Zone Altars:**

| Raid | Altar Locations (Rotating) | Zone Risk | Notes |
|------|---------------------------|-----------|-------|
| Trial of the Crusader | Icecrown (3 locations) | Red | High-risk extraction |
| **Icecrown Citadel** | **Icecrown (5 locations)** | **Red** | **Crown extraction, highest risk** |
| The Ruby Sanctum | Dragonblight (2 locations) | Yellow | Mid-risk extraction |

### Altar Mechanics

**Altar Interaction:**
- Player must be within 5 yards of altar
- Right-click altar with artifact in inventory
- 5-second channel time (interruptible by damage)
- On completion: Artifact purified, world effects applied

**Altar Protection:**
- Altars are indestructible (cannot be destroyed)
- Altars have 30-yard "safe zone" (no PvP flagging within zone)
- Safe zone disabled during Crown extraction (full PvP)

**Altar Visibility:**
- Altars visible on minimap when within 200 yards
- Altars marked on world map (Atlas integration)
- Altars have glowing particle effects (visible from distance)

### Crown-Specific Altar Rules

**Crown Extraction Altars:**
- Only 5 altars active during Crown extraction
- Altars rotate weekly (different set each week)
- Altars announced globally when Crown is looted
- Altars have no safe zone (full PvP at all times)
- Altars spawn additional NPC defenders during Crown extraction

---

## 3. Data Model

### 3.1 DB Tables

#### 3.1.1 `cursed_artifact_def`

Defines static properties of each artifact.

```sql
CREATE TABLE cursed_artifact_def (
    id INT PRIMARY KEY AUTO_INCREMENT,
    artifact_key VARCHAR(64) UNIQUE NOT NULL,  -- e.g. 'MAJOR_TALLYSTONE', 'CROWN_PRIMARY'
    item_entry INT NOT NULL,                   -- reference to item_template entry
    type TINYINT NOT NULL,                     -- 1 = Minor, 2 = Major, 3 = Crown (Primary)
    base_weight INT NOT NULL DEFAULT 100,      -- used to compute encumbrance penalty
    max_stack INT NOT NULL DEFAULT 1,
    is_extraction_required TINYINT NOT NULL DEFAULT 0,  -- requires extraction phase to complete
    world_effect_key VARCHAR(64) DEFAULT NULL  -- links to world effect handler
);
```

#### 3.1.2 `cursed_artifact_instance`

Tracks live artifact instances in the world.

```sql
CREATE TABLE cursed_artifact_instance (
    guid BIGINT PRIMARY KEY AUTO_INCREMENT,
    artifact_id INT NOT NULL,             -- FK to cursed_artifact_def.id
    item_guid BIGINT NOT NULL,            -- reference to item instance GUID
    state TINYINT NOT NULL,               -- 0 = dormant, 1 = carried, 2 = in_extraction, 3 = purified, 4 = lost/returned
    owner_guid BIGINT NULL,               -- current player guid (if carried)
    location_map INT NULL,
    location_x FLOAT NULL,
    location_y FLOAT NULL,
    location_z FLOAT NULL,
    created_at INT NOT NULL,
    updated_at INT NOT NULL
);
```

#### 3.1.3 `cursed_world_state`

Tracks global effects of Major/Crown artifacts.

```sql
CREATE TABLE cursed_world_state (
    id INT PRIMARY KEY AUTO_INCREMENT,
    world_effect_key VARCHAR(64) UNIQUE NOT NULL,   -- e.g. 'MIDNIGHT_HORDE_RATE', 'SHRINE_PENALTY'
    value FLOAT NOT NULL DEFAULT 0.0,               -- signed scalar
    updated_at INT NOT NULL
);
```

---

## 4. Item Template Rules

### 4.1 General Flags

All Cursed Artifacts in `item_template` should:

- Be **soulbound** when picked up (`bonding` flag).
- Have:
  - `maxcount = 1` (per character),
  - `unique = 1` (for Crown).
- Not stack beyond 1 (enforced by both DB & code).
- Use a unique inventory type (e.g. `INVTYPES_RELIC` or custom) if needed for UI.

### 4.2 Restriction Flags

To enforce non-trivial handling:

- **Non-bankable**:
  - On attempt to deposit into:
    - Regular bank,
    - Guild bank,
    - Regional bank:
  - Hook a C++ check:
    - Reject operation,
    - Show custom error: “The artifact corrupts the vault; it cannot be stored.”

- **Non-auctionable & non-mail**:
  - Same approach via DB flags + C++ checks:
    - `AllowableClass` / `ExtraFlags`,
    - Auction and mail hooks.

- **Drop on death (Crown & optional Major Artifacts)**:
  - Decided by type:
    - Minor Relics: follow normal loot rules,  
    - Major Artifacts: optional drop-on-death (configurable),  
    - Crown: **always** drops on death (to corpse chest or to killer).

---

## 5. Encumbrance & Movement

### 5.1 Encumbrance Calculation

We reuse / extend your existing **encumbrance system**:

- Total carried weight includes `base_weight` from artifact_def.
- For Cursed Artifacts:

```text
encumbrance_penalty = (artifact_base_weight * curse_multiplier) / character_max_carry
```

- `curse_multiplier` higher for:
  - Major (e.g. 2.0),
  - Crown (e.g. 4.0).

### 5.2 Effects on Player

Suggested effects when carrying:

- **Movement Speed Reduction**:
  - Minimum 40–50% movement while carrying the Crown.
  - Slightly less severe for Major Artifacts (20–30%).

- **Combat Penalties**:
  - Optional but recommended:
    - Slightly longer GCD,
    - Reduced dodge/block,
    - Increased incoming damage by small %.

- **UI Feedback**:
  - Screen-edge darkening, heartbeat audio, or Ether visual overlay.
  - Buff icon: “Cursed Load” / “Weight of the World”.

Implementation:

- Add aura/spell applied to carrier on pickup, removed on drop/purification.

---

## 6. Lifecycle & State Machine

### 6.1 States

For each `cursed_artifact_instance.state`:

- `0 = dormant` — artifact exists as an item but not actively tracked (minor relics).
- `1 = carried` — artifact is on a player and state is updated regularly.
- `2 = in_extraction` — artifact is within an Extraction event window.
- `3 = purified` — artifact has been successfully purified.
- `4 = lost/returned` — artifact lost or returned to its origin (e.g., Crown returning to Citadel).

### 6.2 State Transitions

#### 6.2.1 Major Artifacts (Raid Wings)

- **Drop**:
  - Boss dies, Major Artifact drops as loot.
  - On loot:
    - Create `cursed_artifact_instance` row,
    - Set state = `1 (carried)`, owner = looter.

- **Extract to Purification Camp**:
  - When player **uses** artifact on a designated altar/camp NPC:
    - Trigger short event or single interaction,
    - On success:
      - state = `3 (purified)`,
      - Apply world_effect changes.

- **Loss**:
  - If player deletes artifact or it is destroyed:
    - Set state = `4 (lost/returned)`,
    - Optionally respawn as future raid loot.

#### 6.2.2 The Crown

- **Drop**:
  - `Hollow King` dies,
  - Crown item spawns on corpse with special loot rules:
    - Only one at a time globally (`cursed_artifact_def` unique),
    - On loot:
      - Create or set instance,
      - state = `1 (carried)`,
      - Crown Carrier flag set on player.

- **Enter Extraction**:
  - When Crown leaves Citadel zone:
    - Automatically set state = `2 (in_extraction)`,
    - Start Extraction timer (world event),
    - Announce to realm via Killfeed/Atlas.

- **Extraction Success**:
  - Crown reaches Purification Altar and event completed:
    - state = `3 (purified)`,
    - Trigger world_effect changes and season outcome,
    - Remove Crown item from player’s inventory.

- **Extraction Failure**:
  - Crown Carrier dies and Crown:
    - Is looted by another player → state stays `2`, owner updated,  
    - Or is not looted and despawns after timer:
      - state = `4 (lost/returned)`,
      - Respawns at Citadel for next raid cycle.

---

## 7. Death, Loot, and PvP Interaction

### 7.1 Death Hooks

On `OnPlayerKilled`:

1. Check if victim carries any `cursed_artifact_instance` in state `1` or `2`.  
2. If yes:
   - For **Crown**:
     - Force drop rule:
       - Item drops as:
         - Corpse chest loot, and  
         - If killer is a player, Crown is prioritized in loot list.  
   - For **Major Artifacts**:
     - Configurable:
       - Drop to corpse chest,  
       - Or convert to Minor Relic if you want less harsh punishment.

3. Update `cursed_artifact_instance`:
   - `owner_guid = NULL`,
   - `location_*` set to corpse coordinates,
   - `state` remains `2` if in Extraction, else `1` (waiting to be looted).

### 7.2 Looting

When another player loots artifact:

- C++ checks:
  - Only one Crown carrier per realm at a time:
    - If Crown already tracked as `state=3` or `4`, deny loot.  
  - Assign new `owner_guid`, update state.

---

## 8. World Effects & Balancing

### 8.1 World Effect Keys

Examples:

- `MIDNIGHT_HORDE_RATE` — baseline multiplier for zombie/invasion frequency.  
- `SHRINE_PENALTY` — additional durability loss or cost on death.  
- `SIEGE_STRENGTH` — relative HP/damage of enemy siege engines.  
- `FRONTIER_STABILITY` — abstract score that can influence:
  - invasion chance,  
  - Stronghold vulnerability windows.

### 8.2 Applying World Effects

Each Major Artifact and the Crown have:

- A `world_effect_key` string, and/or
- A scripted handler registered in Lua/C++.

On **purification of a Major Artifact**:

- Example:
  - Tallystone:
    - Reduce `MIDNIGHT_HORDE_RATE` by 5–10%.  
  - Heart of the Forgewrought:
    - Reduce `SIEGE_STRENGTH`.  
  - Chorus of the Lost:
    - Reduce `SHRINE_PENALTY`.

On **Crown purification**:

- Apply a larger bundle:
  - e.g.:
    - `MIDNIGHT_HORDE_RATE -= 20%`,  
    - `SHRINE_PENALTY -= 25%`,  
    - `FRONTIER_STABILITY += N`.

### 8.3 Seasonality (Optional)

- When a new “Season” begins:
  - Reset `cursed_world_state` values to baseline,  
  - Reset Crown state to dormant in Citadel,
  - Announce in UI.

---

## 9. Atlas & MortalUI Integration

### 9.1 Atlas Web Portal

- Add an **Artifacts Panel**:

  - Shows:
    - Current status of:
      - Major Artifacts (purified/not),
      - Crown (dormant, in Citadel, in Extraction, purified).  
    - World effect modifiers:
      - e.g., “Midnight Horde activity: -15% (3 artifacts purified)”.

- Crown Tracker:
  - If state `1` or `2`:
    - Show approximate location:
      - Zone, region, not exact coordinates,
      - For tension but not griefing-level precision.

### 9.2 MortalUI In-Game

- Buff icon and debuff text when carrying artifacts.
- World status window:
  - “Crown Influence” bar,
  - Last purification time,
  - Upcoming Citadel re-open time.

- Announcements:
  - Killing blow on Hollow King,
  - Crown looted,
  - Crown dropped,
  - Crown purified/returned.

---

## 10. Configuration & Tuning

### 10.1 Config Keys

Add a config section, e.g. `CursedArtifacts` in your server conf:

```ini
CursedArtifacts.Enable = 1
CursedArtifacts.CrownMovementPenalty = 0.5      # 50% move speed
CursedArtifacts.MajorMovementPenalty = 0.75     # 75% move speed (25% slow)
CursedArtifacts.CrownWorldAnnouncements = 1
CursedArtifacts.ExtractionTimeLimit = 1800      # seconds
CursedArtifacts.CrownMaxConcurrent = 1
```

### 10.2 Difficulty

- Movement penalty and combat debuffs must be tested:
  - Too harsh → no one wants to carry,  
  - Too soft → Crown runs become trivial.

- World effect magnitudes:
  - Enough to be **felt**, but not so massive that:
    - One successful season trivializes all content.

---

## 11. Implementation Checklist

1. **DB:**
   - Create `cursed_artifact_def`, `cursed_artifact_instance`, `cursed_world_state`.  
   - Populate definitions for:
     - Minor relics,  
     - Tallystone, Heart, Chorus,  
     - Crown.

2. **Items & Loot:**
   - Add items in `item_template`.  
   - Wire loot into:
     - Raid wing bosses,  
     - Hollow King final boss,  
     - Optional world bosses.

3. **Core Hooks (C++):**
   - Encumbrance & movement penalty when carrying.  
   - Block bank/auction/mail operations for Cursed Artifacts.  
   - Handle artifact behavior on `OnPlayerKilled` and loot.  
   - State sync to `cursed_artifact_instance`.

4. **Extraction Event Script (Lua/C++ hybrid):**
   - Trigger when Crown leaves Citadel.  
   - Start timers, spawn ambushes, manage Purification Altars.  
   - Resolve success/failure and update `cursed_world_state`.

5. **UI Integration:**
   - Buff icons, messages, and panels in MortalUI.  
   - Atlas Artifacts panel + world effect display.

6. **Testing Plan:**
   - Single-realm test:
     - Simulate raid kills and Crown runs with GM commands,  
     - Verify drop, carry, death, and purification flows.  
   - Load test:
     - Ensure DB writes for `cursed_artifact_instance` aren’t excessive.

---

This system is what makes your endgame **feel Mortal** instead of “just WotLK with tweaks”:

- Items that **matter at the world level**,  
- Extraction runs that the whole server can see and react to,  
- And real consequences for success or failure that ripple back through:
  - invasions,
  - Strongholds,
  - Shrines,
  - and the economy.  
