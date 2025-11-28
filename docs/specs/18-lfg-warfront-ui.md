# Project Canvas: Mortal Warcraft Overhaul
### Version 26.1 — Hybrid Technical Design Document  
### File: 18-lfg-warfront-ui.md  
### Section: LFG System, Tavern Boards, Warfront & Hellgate UI (Replacing RDF/BG Finder)

---

# 1. Overview

This document defines how Mortal Warcraft replaces:

- **Random Dungeon Finder (RDF)**
- **Random Battleground Finder / BG Queue**

with **non-teleport, world-respecting systems**:

- Tavern & city **LFG Boards** (for dungeons/raids/delves).
- A **Warfront & Hellgate Panel** (for PvP & large-scale conflicts).

Key principles:

- **No automatic teleportation** into dungeons or battlegrounds.
- All content is accessed via **physical portals / entrances**.
- UI acts as **information + social tooling**, not an instant queue.

---

## Related Specs

For full context on LFG and warfront UI systems, see:

- **`15-ui-client.md`** — UI architecture and MortalUI system that these panels integrate with
- **`20-aio-ui-basics.md`** — AIO system used for server-driven UI panels
- **`38-social-and-onboarding-systems.md`** — Expedition Finder and LFG Board systems
- **`92-mortal-warfronts-siege-flow.md`** — Warfront system that this UI supports
- **`91-mortal-anomalies-rifts-hellgates.md`** — Hellgate system that appears in warfront panel
- **`06-pve.md`** — PvE content (dungeons, raids, delves) that LFG supports
- **`33-instance-and-battleground-tier-mapping.md`** — Instance mapping used for LFG content

---

# 2. LFG System (PvE/Tanks/Healers/Support)

## 2.1 Concept

The **LFG Board** is an **in-world and UI-backed listing system**:

- Players create/join **groups** for:
  - Public dungeons (Deadmines, WC, SFK, etc.)
  - Raids (MC, BWL, AQ, Naxx)
  - Public delves and world events
- The system **does not** teleport players:
  - They must physically travel to the entrance.

Both:

- **Tavern Bulletin Boards** (world objects)
- **LFG Panel** (replacing the RDF button)

are just different front-ends to the same backend data.

---

# 3. LFG Data Model

## 3.1 Table: `mortal_lfg_listings`

Stores open group listings.

**Columns:**

- `id` (PK)
- `leader_guid` (FK → `characters.guid`)
- `content_type` (ENUM: `dungeon`, `raid`, `delve`, `event`)
- `content_tag` (VARCHAR)  
  e.g., `DEADMINES`, `MOLTEN_CORE`, `DEADMINES_PUBLIC`, `HELLGATE_BARRENS`
- `title` (VARCHAR) – short description: “DM public farm”, “MC extraction run”
- `required_role_flags` (INT bitmask):
  - FRONTLINE  
  - SUPPORT  
  - HEALING  
  - RANGED  
  - SCOUT  
- `min_derived_level` (TINYINT, nullable)
- `max_group_size` (TINYINT)
- `current_member_count` (TINYINT)
- `notes` (TEXT, small – “Need healer, bring FR gear”)
- `created_at` (INT)
- `last_updated` (INT)
- `is_active` (BOOLEAN)

## 3.2 Table: `mortal_lfg_members`

Tracks which players have joined a listing.

**Columns:**

- `id` (PK)
- `listing_id` (FK → `mortal_lfg_listings.id`)
- `guid` (FK → `characters.guid`)
- `role_flags` (INT bitmask)
- `joined_at` (INT)

---

# 4. LFG Interactions

## 4.1 Creating a Listing

From tavern board or LFG Panel:

1. Player opens **“Create Listing”**.
2. Selects:
   - Content type: `dungeon`, `raid`, `delve`, `event`.
   - Content tag from dropdown (or quick-type with auto-suggest).
   - Roles needed (checklist).
   - Max group size.
   - Min derived level (optional).
   - Short title + notes.
3. Listing appears in global LFG listing (visible from any city board).

Server-side validation:

- Only party/raid leaders can create listing tied to their group.
- A character can only be leader of **one active listing** at a time.

Lua:
- `MortalLFGSystem.cpp/h` (C++ implementation)

---

## 4.2 Joining a Listing

Players browsing LFG can:

- **Apply to join** → sends a whisper/notification to leader.
- Or leader can enable **auto-accept** below a certain derived level threshold.

Once accepted:

- The player is invited to group.
- Their GUID is added to `mortal_lfg_members`.
- Listing auto-updates `current_member_count`.

No teleportation occurs.

---

## 4.3 Closing a Listing

Listing closes when:

- Leader manually closes it.
- Group disbands.
- Timeout (e.g., 60 minutes with no updates).
- Group enters instance and chooses “Lock listing” (optional toggle).

Lua handles cleanup:

- Marks `is_active = 0`.
- Removes pending applicants.

---

# 5. Tavern Bulletin Boards (World Objects)

## 5.1 Placement

Placed in:

- Capital taverns (SW, IF, Org, UC, etc.)
- Key hub taverns (Gadgetzan, Booty Bay, etc.)
- Some stronghold taverns (for high-level LFG)

Gossip Option:

- “Look at Group Listings”
- “Post a Listing”
- “Filter for specific content”

These open the **same LFG UI** as the RDF button but with RP flavor.

Lua:
- `tavern_lfg_gossip.lua`

---

# 6. Dungeon Finder Button Repurpose

The classic **Dungeon Finder (RDF) button** in the micro menu is repurposed to:

- Open the **Mortal LFG Panel**.

No queue, no teleport. Just:

- Tabs:
  - All Listings
  - My Listings
  - Favorites (optional)
- Filters:
  - Content type (Dungeon/Raid/Delve/Event)
  - Level range
  - Risk tier
  - Zone

UI Implementation:

- MortalUI module: `ui_lfg_panel.lua`

---

# 7. Warfront & Hellgate UI (PvP Panel)

The **Battleground / PvP button** is repurposed to open the **War & PvP Panel**:

## 7.1 Data Model

We reuse existing/allied systems:

- `mortal_warfronts` (virtual, can be a view or a new table)
- `mortal_hellgate_status` (simple status table)
- `mortal_pvp_season_scores` (already spec’d)

Minimal new table if needed:

### `mortal_warfront_state` (optional)

- `id` (PK)
- `name` (VARCHAR)
- `map_id` (INT)
- `portal_zone_id` (SMALLINT)
- `portal_pos_x` (FLOAT)
- `portal_pos_y` (FLOAT)
- `controlling_guild_id` (FK → `guild.id`, nullable)
- `status` (ENUM: closed, preparing, open, resolving)
- `next_open_time` (INT)
- `last_result` (VARCHAR or FK to a result table)

---

## 7.2 War & PvP Panel Layout

Tabs:

1. **Warfronts**
   - List of Warfronts with:
     - Name (e.g., “Arathi Basin Warfront”)
     - Status (Closed / Preparing / Open)
     - Controlling Guild
     - Rewards summary
     - Next open time (if closed)
   - Buttons:
     - “Show on Map” → ping portal on world map
     - “Set Waypoint” (for compatible map addons)

2. **Hellgates**
   - List of Hellgate entrances:
     - Zone
     - Risk tier
     - Status (Dormant / Active)
   - Buttons:
     - “Show on Map”

3. **My PvP Season**
   - Displays:
     - Season rating
     - K/D stats
     - Bounties claimed
     - Time in Red zones
     - Titles earned

4. **Bounties**
   - Quick access list for:
     - Top bounties
     - Nearby bounties (approximate)
     - Self status if you’re wanted

UI Implementation:

- MortalUI module: `ui_pvp_panel.lua`

---

# 8. Interaction with World Map

Both LFG and PvP panels integrate with **`ui_map_pins.lua`**:

- LFG:
  - “Show dungeon entrance” → adds a temporary pin for:
    - Dungeon portals
    - Public dungeon entrance
- PvP:
  - “Show Warfront” → highlights Warfront portal region.
  - “Show Hellgate” → marks Hellgate entrance.

No teleport, only guidance.

---

# 9. Dungeons & Warfront Rules (No Teleportation)

To avoid design drift back toward RDF/BG:

- **No UI button** may call teleports to:
  - Dungeons
  - Raids
  - Warfronts
  - Hellgates

All travel must use:

- Physical walking/riding
- Caravans
- Flight paths (where not removed by Mortal design)
- Stronghold or guild hall teleport hooks (if explicitly allowed by design)

This is enforced by:

- Lua checks on any teleport-like action invoked from these panels.

---

# 10. Implementation Summary

## Lua (Server / Gameplay)
- `MortalLFGSystem.cpp/h` (C++ implementation)
- `tavern_lfg_gossip.lua`
- `warfront_state.lua` (simple wrapper)
- `MortalHellgates.cpp/h` (C++ implementation) (already spec’d)
- `MortalPvPSeason.cpp/h` (C++ implementation) (already spec’d)

## Lua (Client / MortalUI)
- `ui_lfg_panel.lua`
- `ui_pvp_panel.lua`
- `ui_map_pins.lua` (extended for LFG + PvP pins)

## SQL
- `mortal_lfg_listings`
- `mortal_lfg_members`
- Optional: `mortal_warfront_state`

---

# 11. Status

This file is the **authoritative plan** for:

- Replacing RDF with a **sandbox-respecting LFG system**.
- Replacing BG Finder with a **Warfront/Hellgate information panel**, not a queue.
- Ensuring players **always travel** into content, preserving your risk, economy, and world identity.

