# Project Canvas: Mortal Warcraft Overhaul
### Version 28.3 — Hybrid Technical Design Document  
### File: 39-navigation-and-wayfinding.md  
### Section: Navigation, Wayfinding & Intel Exposure

---

## Related Specs

- `15-ui-client.md` - MortalUI and map overlay implementation
- `24-webportal-mortal-atlas.md` - Web portal intel and map integration
- `03-risk-zones.md` - Risk zones and Red/Yellow/Green zone rules
- `13-caravans-contracts.md` - Courier Contracts and route hints
- `76-dynamic-tasks-and-contracts-2-0-spec.md` - Tasks and contract system
- `08-guilds-sovereignty.md` - Strongholds and territory control
- `91-mortal-anomalies-rifts-hellgates.md` - Hellgates and navigation features
- `58-world-contracts-and-map-pins.md` - World contracts and map pins

---

## 1. Purpose

Define how players **navigate and understand the world** of Mortal Warcraft without:

- Turning it into a GPS-arrow theme park.
- Undermining risk, exploration, or intel advantage.
- Conflicting with full-loot PvP and fog-of-war rules.

This spec focuses on:

1. Point-of-Interest (POI) categories and visibility rules.
2. Map overlays & pins (MortalMap + HandyNotes/Mapster).
3. Route hints for Tasks, Courier Contracts, and Trade Runs.
4. Red-Zone intel restrictions (fog-of-war + limited markers).
5. Integration with Mortal Atlas (web portal) vs in-game intel.

---

## 2. POI Categories & Discovery Rules

### 2.1 POI Categories

We classify POIs as:

1. **Core Services**
   - Banks (Regional Banks)
   - Inns & Shrines (respawn/shrine system)
   - Task Boards & Town Request Boards
   - Expedition Masters & Staging Camps
   - LFG Boards & Guild Heralds
2. **Economic & PvP Infrastructure**
   - Strongholds
   - Market Stalls hubs
   - Hellgates (PvP dungeons)
   - Warfront portals
3. **Risk / PvP Features**
   - Red-Zone boundaries
   - Bounty targets (high Notoriety players)
   - Active world bosses
4. **Exploration & Secrets**
   - Black Market (Darkmoon-style mobile fence)
   - Hidden entrances (Lost Lands, secret dungeons, Admin event zones)
   - Rare resource nodes or hidden shrines

### 2.2 Discovery Rules

We define three **discovery modes** for POIs:

- **Always Known**
  - Visible on map for all players from character creation.
- **Visited / Learned**
  - Only becomes visible after:
    - Player physically enters the area, **or**
    - Player reads relevant Mortal Codex entry, **or**
    - Player completes a certain task/quest.
- **Never Auto-Exposed**
  - No pins; players rely on word-of-mouth, exploration, or external intel (web/Discord).

#### 2.2.1 Always Known POIs

- Capital city:
  - Banks, Inns, Mailboxes.
  - Key social NPCs (Mentor, Guild Herald, Expedition Master).
- Starter Shrines in Green Zones.
- First Task Board in each faction’s starting hub.
- First staging camp for each *entry-tier* dungeon (M-T1).

These ensure new players have **basic orientation** without reading a guide.

#### 2.2.2 Visited / Learned POIs

Becoming visible only after:

- Entering the zone or interacting with the POI.
- Or unlocking via Codex/tutorial:

Examples:

- Additional Task Boards in Yellow/Red zones.
- Stronghold locations (once approached within X range).
- Hellgate locations.
- Warfront portals.
- Secondary staging camps (for higher-tier dungeons/raids).

#### 2.2.3 Never Auto-Exposed

These **do not** get map pins by default:

- Black Market / Darkmoon-style rotating fairs.
- Hidden entrances to Lost Lands / secret dungeons.
- Admin event areas and any “GM surprise” content.
- Rare, high-yield resource nodes.

Players may still see:
- Chat/rumors about them.
- Mortal Atlas web intel (depending on how much you choose to expose externally).

---

## 3. MortalMap & Addon Integration

### 3.1 Components

We use the following addons & bridging scripts:

- **Mapster** – Fog of War, enhanced map frame.
- **HandyNotes** – POI pins and notes.
- **Custom MortalMap addon** – Overlays for sovereignty, heatmaps, and POI categories.
- **`ui_map_pins.lua`** – Bridge to register Mortal-specific pins.
- **`ui_nameplate_driver.lua`** – For in-world PvP intel (criminals, bounty targets).

### 3.2 Pin Data Schema (Server-Side Registry)

Server-driven POIs use a shared registry table:

```sql
CREATE TABLE IF NOT EXISTS mortal_map_pois (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  code            VARCHAR(64) NOT NULL,     -- 'POI_BANK_SW','POI_SHRINE_ELWYNN01'
  category        VARCHAR(32) NOT NULL,     -- 'SERVICE','STRONGHOLD','HELLGATE','WARFRONT','SECRET'
  map_id          INT NOT NULL,
  position_x      FLOAT NOT NULL,
  position_y      FLOAT NOT NULL,
  position_z      FLOAT NOT NULL,
  discovery_mode  VARCHAR(16) NOT NULL,     -- 'ALWAYS','VISITED','NEVER'
  zone_id         INT NOT NULL,
  flags           INT NOT NULL DEFAULT 0,   -- e.g., 1=red-zone only, 2=pvp objective
  icon_hint       VARCHAR(32) NULL,         -- 'bank','shrine','stronghold','hellgate'
  label           VARCHAR(64) NULL,         -- in-game name
  notes           VARCHAR(255) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

The server can expose only a subset of POIs to the client based on:

- Player discovery history.
- Zone rules (e.g., temporarily hidden during events).

### 3.3 HandyNotes Integration

`ui_map_pins.lua`:

- Requests a filtered list of POIs from server via custom opcode/API:
  - Includes only POIs the player **should** see (per discovery rules).
- Registers pins with HandyNotes using category-appropriate icons and tooltips.

This keeps the **source of truth** server-side and allows dynamic changes (e.g. a stronghold changing ownership).

---

## 4. Route Hints for Tasks, Contracts & Trade Runs

### 4.1 Principles

- We **hint** routes, but do not:
  - Auto-path,
  - Render giant “follow this line” arrows.
- Routes are:
  - Optional overlays on the world map,
  - Light suggestion, not locked rails.

### 4.2 Task Route Hints

For Task Board objectives:

- When a Task is accepted:
  - MortalMap highlights:
    - The **target zone**,
    - A soft overlay/contour around likely objective areas (e.g., a semi-transparent outline).
- For Hunt/Gather tasks:
  - Can optionally render:
    - A subtle dotted-circle region where targets are known to spawn.

No minimap arrow; players still orient themselves using the bigger map and world geography.

### 4.3 Courier & Contract Routes

For Courier Tasks and player-created courier contracts:

- When accepted:
  - Show origin and destination POIs (banks, cities, strongholds).
  - Optionally draw a **suggested route** along roads:
    - Computed using a simple server-side path over road nodes.
- Route lines:
  - Visible on the **world map** only.
  - Color-coded by risk tier:
    - Green | Yellow | Red segments.

Player can still deviate, but can at a glance see where the “safe-ish” and “dangerous” stretches are.

---

## 5. Red-Zone Intel & Fog-of-War

### 5.1 Existing Rules (Reaffirmed)

From previous specs:

- **Map dots for party/raid members do NOT appear** for Red Zones.
- **Global chat disabled** in Red Zones.
- Stealth is visible as a shimmer at close range only.
- High Notoriety players appear on world map as skull icons (Bounty Board).

### 5.2 Map Restrictions in Red Zones

Inside Red Zones:

- MortalMap:
  - Continues to show geography, shrines, and **core services** that the player has discovered.
  - Hides:
    - Friendly player dots (allies, guild).
    - Enemy player positions (except limited Bounty skulls).
- No route hints:
  - Contract route overlays **end** at Red-Zone boundaries.
  - The Red segments on the world map show “danger corridor” but not precise safe paths.

### 5.3 Bounty Target Icons

- Players with high Notoriety can appear as **skull icons** on the world map:
  - Position updates at **low frequency** (e.g., every 30–60 seconds).
  - Accuracy may include small random jitter to avoid perfect tracking.

This maintains the **hunter vs hunted** gameplay without turning into a radar.

---

## 6. Mortal Atlas (Web) vs In-Game Intel

### 6.1 Mortal Atlas: Web Portal View

Mortal Atlas (Leaflet-based web map) will generally show **more aggregated intel** than the in-game map:

- Territory control overlays (strongholds, sovereignty).
- Known Warfronts & public events.
- Historical kill hotspots (heatmaps aggregated from killfeed).
- Trade hub activity (volume of buy/sell orders, not exact listings).

### 6.2 Separation of Concerns

- **Web Atlas**:
  - Strategic, macro-level intel,
  - Helpful for planning: where to live, which route to invest in, what conflicts are ongoing.
- **In-game MortalMap**:
  - Tactical, immediate navigation:
    - Service POIs,
    - Your tasks/contracts,
    - Local stronghold status (if discovered).
  - Subject to fog-of-war and Red-Zone intel limits.

### 6.3 Opt-In Linking

Where needed, we can expose:

- Unique POI codes to Mortal Atlas for rendering.
- But still respect:
  - Certain POIs flagged as “SECRET” or “EVENT_ONLY” (never auto-scraped).

---

## 7. Compass & Micro-UI Elements

### 7.1 Compass

Optionally, MortalUI can show a **simple compass bar**:

- Displays:
  - Cardinal directions,
  - Tiny markers for:
    - Active task objectives (as icons near the heading),
    - Nearby shrines/banks if within X range.
- Does **not** show:
  - Enemy players,
  - Exact contract routes.

### 7.2 Minimap Icons

Minimap should show:

- Core services (bank, inn, shrine, task board) when within local radius.
- POIs discovered & relevant to current tasks/contracts.

Minimap should not:

- Display other players beyond default Blizzard rules,
- Add new real-time enemy tracking.

---

## 8. Implementation Hooks

### 8.1 Server APIs

We need:

1. **POI Discovery Tracking**
   - Track which `mortal_map_pois.id` each character has discovered.
   - Table example:

```sql
CREATE TABLE IF NOT EXISTS mortal_map_pois_discovered (
  guid            INT NOT NULL,  -- characters.guid
  poi_id          INT NOT NULL,  -- FK to mortal_map_pois.id
  PRIMARY KEY (guid, poi_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

2. **POI Query Endpoint**
   - Custom server opcode or AIO endpoint:
     - Input: player guid, filters (map_id, zone_id).
     - Output: POIs to show (with category, coords, icon_hint, label).

3. **Route Endpoint**
   - For tasks/contracts:
     - Calculate suggested road routes server-side.
     - Return list of waypoints for the MortalMap client.

### 8.2 Client Addons

- **MortalMap**
  - Renders overlays:
    - Territory, heatmaps (if desired), POIs.
  - Renders route hints for tasks/contracts.
- **HandyNotes + ui_map_pins.lua**
  - Manages actual pin rendering & icon usage.
- **MortalUI**
  - Provides:
    - Map toggles (show routes, show tasks, show discovered shrines).
    - Compass and micro-UI for task markers.

---

## 9. Design Summary

This navigation spec ensures:

- New players **aren’t lost**:
  - Always-visible basics (banks, shrines, initial task boards, first staging camps).
  - Route hints for tasks and contracts.
- Explorers still have mysteries:
  - Secret dungeons, Black Market, hidden shrines **never auto-exposed**.
- Sandbox PvP remains tense:
  - No live enemy radar,
  - No group dots in Red Zones,
  - Bounty info is coarse, not pin-point.
- Economic play has visibility:
  - Trade routes suggested on map,
  - Strongholds, Warfronts, and banks clearly identifiable once discovered.
- Web Atlas provides macro intel, in-game map handles immediate navigation under stricter rules.

This keeps the **Mortal/EVE vibe** while avoiding the “where the hell do I go / what do I do” problem that kills retention in harsh sandboxes.
