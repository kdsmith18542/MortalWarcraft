# Project Canvas: Mortal Warcraft Overhaul
### Version 26.1 — Hybrid Technical Design Document  
### File: 14-admin-tools.md  
### Section: Admin Tools, GM UIs, Moderation, Logging & Live Operations

---

# 1. Overview

Admin & GM tooling is critical to operate Mortal Warcraft as a **live service sandbox** with:

- High-risk PvP  
- Player-driven economy  
- Territorial control  
- Outlaws & bounties  
- Caravans & contracts  

This document defines all **non-player** tools and systems for:

- Game Masters (GMs)  
- Administrators  
- Support staff  
- Developers  

It includes:

- AIO (AzerothCore IO) server-side UIs  
- AzerothAdmin integration  
- Moderation commands  
- Logging & audit trails  
- Analytics hooks  
- Dev operations and feature flags  

---

## Related Specs

For full context on admin and moderation systems, see:

- **`81-archon-and-staff-chat-tags-eluna-spec.md`** — Staff roles, titles, and chat tags for GMs and admins
- **`85-mortal-chat-and-channels.md`** — Chat system that admins monitor and moderate
- **`42-gm-tools-and-live-events.md`** — Extended GM tools and live event management
- **`40-anti-bot-rmt-and-security.md`** — Security systems and anti-cheat tools used by admins
- **`41-telemetry-and-balancing.md`** — Analytics and telemetry systems that inform admin decisions

---

# 2. Tooling Stack

## 2.1 AzerothAdmin (Client Addon)
Used for:
- Basic GM commands  
- Ticket handling  
- Player lookup  
- Quick teleport & item tools  

## 2.2 AIO (AzerothCore IO)
Used for:
- Rendering server-side admin UIs  
- Dashboards and configuration panels  
- Integrated management screens  

## 2.3 Custom Admin Addon
**MortalAdmin** addon:
- Installed only for GMs  
- Provides:
  - Quick-access menus  
  - Risk-map overlays  
  - Live event controls  

---

# 3. GM Roles & Permissions

## 3.1 Roles

- **Admin**  
  Full permissions, including DB-level controls.

- **Senior GM**  
  High-level support and enforcement.

- **GM**  
  Player support, minor world adjustments.

- **Event GM**  
  Controls for running world events and RP scenarios.

- **Observer**  
  Read-only access to logs and map overlays.

## 3.2 Permission Layers

Permissions stored in:
- `gm_roles.sql`  
- `gm_permissions.sql`  

---

# 4. AIO-Based Admin Panels

## 4.1 Mortal Control Panel (MCP)

Main AIO UI for GMs:

### Tabs:
1. **Players**
   - Search by:
     - Name  
     - GUID  
     - IP  
     - Notoriety  
   - Actions:
     - Teleport  
     - Jail / Mute / Kick / Ban  
     - Reset position  
     - Summon to GM  
     - Clear corpse chest  

2. **Economy**
   - View:
     - Regional bank inventories (aggregated)  
     - Top gold holders  
     - Auction listings by region  
     - In-flight caravan count  
   - Tools:
     - Temporarily freeze market stalls  
     - Adjust tax multipliers (for debugging)  

3. **Territory**
   - Visual map of:
     - Stronghold ownership  
     - TCP control points  
     - Seasonal influence scores  
   - Controls:
     - Forcibly flip a TCP (debug/admin only)  
     - Start/stop sieges (emergency only)  

4. **Events**
   - Trigger:
     - Midnight Horde  
     - Elemental invasions  
     - Merchant caravan events  
     - World boss spawns  
   - Schedule:
     - Set recurring events  
     - Adjust seasonal start/end dates  

5. **PvP & Crime**
   - View:
     - Top killers  
     - Notoriety distribution  
     - Current Outlaws & Infamous list  
   - Apply:
     - Global crime amnesty  
     - Wipe bounties (season end)  

6. **Logs & Alerts**
   - View logs (see section 6)  
   - Filter:
     - Economy  
     - PvP  
     - Crafting  
     - Admin commands  

7. **Database Lookup** (Design Data)
   - Query creatures by name/entry:
     - Display IDs, stats, faction, rank
     - Full design stats (HealthModifier, DamageModifier, speeds)
   - Query items by name/entry/tier:
     - Display IDs, stats, sockets, spells, flags
     - Full design data for itemization
   - Query quests by title/entry:
     - Objectives, rewards, requirements
   - Integration:
     - Copy IDs for event templates
     - Validate data for content creation
     - Quick reference for balancing

Lua:
- `admin_panel.lua` (AIO backend)
- `admin_panel_ui.lua` (client addon)
- `mwdbquery_lua.lua` (database query functions)

See `mwdbquery-admin-integration.md` for implementation details.

---

# 5. Moderation & Enforcement Tools

## 5.1 Soft Tools
- Mute player  
- Freeze movement (for interrogation)  
- Temporary jail teleport  
- Warning whispers via template messages  

## 5.2 Hard Tools
- Kick  
- Ban (temp/permanent)  
- Hardware-ID ban (if in scope)  
- IP-based restrictions  

## 5.3 Automated Sanity Checks
Alerts for:
- Extreme resource injection  
- Gold spikes  
- High-frequency kills by same attacker  
- Suspicious caravan attacks  

Triggered via:
- `mod_sandbox_watchdog.lua`

---

# 6. Logging & Audit Trails

## 6.1 Log Categories

1. **Economy Logs**
   - Gold gains/losses  
   - Stall sales  
   - Caravan completions  
   - Contract failures  
   - Tax distribution  

2. **PvP Logs**
   - Kills & deaths  
   - Looted items  
   - Bounty claims  
   - Hellgate matches  

3. **Crime Logs**
   - Notoriety changes  
   - Criminal flag triggers  
   - Outlaw promotion  
   - Bounty board changes  

4. **Guild Logs**
   - Stronghold captures  
   - TCP flips  
   - Siege declarations  
   - Alliance/betrayal events  

5. **Admin Logs**
   - GM commands  
   - Role changes  
   - Bans/mutes  
   - Economy adjustments  

## 6.2 Storage

SQL:
- `log_economy.sql`
- `log_pvp.sql`
- `log_crime.sql`
- `log_guild.sql`
- `log_admin.sql`

---

# 7. Analytics & Telemetry

Telemetry is used to analyze:

- Player retention by zone  
- Popular risk tiers  
- Trade route heatmaps  
- PvP hotspots  
- Crafting bottlenecks  
- Stronghold churn  

## 7.1 Metric Examples

- Daily Active Players (DAP)  
- Red zone participation rate  
- Outlaw population percentage  
- Average caravan contract success rate  
- PvP K/D ratios by Derived Level  

## 7.2 Export Mechanisms

Periodic exports to:
- CSV  
- External API (optional, configurable)  

Lua:
- `analytics_collector.lua`

---

# 8. Live Balancing & Feature Flags

## 8.1 Feature Flags

Certain systems have tunable flags:

- Decay rate  
- Notoriety thresholds  
- Bounty payout multipliers  
- Seasonal duration  
- Resource drop rates  

Stored in:
- `feature_flags.sql`

Controlled via:
- **Mortal Control Panel → Config tab**

## 8.2 Hotfix Hooks

Configurable without restart:
- Damage multipliers  
- Node spawn rates  
- Dungeon spawn density  
- Boss HP multipliers  

Lua:
- `live_balance.lua`

---

# 9. Dev Operations (DevOps) Integration

## 9.1 Build Channels

Three recommended environments:

- **DEV** – local/dev-only testing  
- **STAGE** – small player group testing  
- **LIVE** – public deployment  

Each has separate config & DB endpoints.

## 9.2 Crash Reporting

Hooks into:
- Crash logs  
- Lua errors  
- Script stack traces  

Lua:
- `error_reporter.lua`

---

# 10. Admin Workflows

## 10.1 Handling Exploits
1. Observe via logs  
2. Temporarily disable affected feature via feature flags  
3. Investigate accounts  
4. Reverse or compensate where needed  
5. Patch logic via Lua/C++  

## 10.2 Handling Harassment
1. Receive ticket  
2. Teleport invisibly to observe  
3. Mute offenders if needed  
4. Apply ban if needed  
5. Log action in `log_admin.sql`  

## 10.3 Handling Economic Crashes
1. Check economy logs  
2. Freeze suspicious accounts  
3. Adjust market stall or tax parameters  
4. Communicate via global message  

---

# 11. Implementation Summary

## 11.1 Lua Files
- `admin_panel.lua`
- `admin_panel_ui.lua`
- `mod_sandbox_watchdog.lua`
- `analytics_collector.lua`
- `live_balance.lua`
- `error_reporter.lua`

## 11.2 SQL Files
- `gm_roles.sql`
- `gm_permissions.sql`
- `log_economy.sql`
- `log_pvp.sql`
- `log_crime.sql`
- `log_guild.sql`
- `log_admin.sql`
- `feature_flags.sql`

## 11.3 C++ Files
- `AdminHooks.cpp`
- `LogHooks.cpp`
- `AnalyticsHooks.cpp`

---

# 12. Status
Admin tooling is **Core** for launch and must remain stable and secure.  
Future updates will expand analytics and in-game dashboards.

