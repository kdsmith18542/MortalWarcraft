# Project Canvas: Mortal Warcraft Overhaul
### Version 26.1 — Hybrid Technical Design Document  
### File: 17-implementation-roadmap.md  
### Section: Implementation Roadmap, Milestones, Dependencies & Team Workflow

---

## Related Specs

- `01-progression.md` - M1: Progression & Stats Foundation
- `03-risk-zones.md` - M2: Risk Zones & Death/Loot Rules
- `04-economy.md` - M3: Core Economy & Regional Banking
- `05-crafting.md` - M4: Crafting & Material Lore
- `06-pve.md` - M5: World Simulation Lite & PvE Loops
- `11-pvp-systems.md` - M6: PvP Systems & Notoriety
- `08-guilds-sovereignty.md` - M7: Guild Sovereignty & Strongholds
- `84-mortal-core-stats-and-combat-model.md` - Core stats system
- `02-combat.md` - Combat system implementation
- `15-ui-client.md` - UI and client implementation

---

# 1. Purpose

This roadmap turns the **design stack (v26.1 spec docs)** into a **buildable plan** for:

- You + Cursor as the primary “team”
- A long-term, non-rushed implementation
- Clean layering (C++ core, Lua systems, SQL, UI, Launcher)
- Safe iteration without constantly refactoring fundamentals

This is a **sequence of milestones**, each one:

- Builds on the last  
- Produces something testable  
- Minimizes rework  
- Keeps the server always “bootable”  

---

# 2. High-Level Milestone Overview

**M0 – Environment & Baseline Core**  
AC fork, module layout, build pipeline, basic logging.

**M1 – Progression & Stats Foundation**  
Dynamic level, attributes, skills, hunger, encumbrance.

**M2 – Risk Zones & Death/Loot Rules**  
Green/Yellow/Red framework, corpse chests, criminal flags (barebones).

**M3 – Core Economy & Regional Banking**  
Regional banks, base market stalls, simple gold sinks.

**M4 – Crafting & Material Lore (Vertical Slice)**  
Workstations, one or two material families, durability decay, simple quality tiers.

**M5 – World Simulation Lite & PvE Loops**  
Dynamic spawns, task boards, 1–2 public dungeons, basic seasonal toggles.

**M6 – PvP Systems & Notoriety**  
Notoriety, bounty board v1, hellgates, brace mechanic, anti-zerg.

**M7 – Guild Sovereignty & Strongholds**  
Strongholds, TCPs, sieges (simple pass), guild scoring.

**M8 – Caravans & Contracts**  
Courier contracts, caravans, ambush hooks, pack animals.

**M9 – Social & MortalUI Polish Pass**  
Tavern games, social titles, MortalUI integration, UI enforcement.

**M10 – Alpha Hardening & Tools**  
Admin panels, analytics, feature flags, bugfix phase.

---

# 3. Cross-Cutting Tracks

Throughout all milestones there are parallel “tracks”:

1. **C++ Core Track**  
   - Hooks, performance-sensitive logic, security checks.

2. **Lua Gameplay Track**  
   - Skills, events, risk logic, spawn handling, contracts.

3. **SQL Schema Track**  
   - Schema creation, migrations, indexes, initial seed data.

4. **UI/Client Track**  
   - MortalUI addon suite, overlays, stats, nameplates, tooltips.

5. **Launcher & Ops Track**  
   - Rust/Tauri launcher, DBC patching, sanity checks, build tooling.

Cursor should be used primarily on **one track at a time**, but milestones coordinate between them.

## 3.1 C++ vs Lua Guardrails
- Performance- or security-critical logic (combat formulas, heartbeat timers, spawn controllers, anti-cheat, serialization) belongs in the AzerothCore module; avoid implementing those in Lua.  
- When a spec lists `*.lua`, treat it as an interface name—implement in C++ where it makes sense and expose only a thin Lua shim for AIO/UI triggers or configuration.  
- Keep Lua focused on AIO bridges, gossip/quest wrappers, configuration tables, and quick prototypes; plan to port prototypes that stick to C++ for maintainability and throughput.  

---

# 4. Milestone 0 – Environment & Baseline Core

### Goals
- Get to a **stable AzerothCore fork** with:
  - Custom `mod-mortal` skeleton  
  - Eluna ready  
  - AIO ready  
  - Minimal “hello world” Lua script running.

### Tasks
- Fork AzerothCore → `mortal-warcraft-core` repo.
- Add `modules/mod-mortal/` with:
  - `MortalHooks.cpp`  
  - `CMakeLists`  
  - Basic logging helper.
- Enable Eluna & mod-aio in CMake.
- Add **SQL migration structure**:
  - `/sql/mortal/00_base/`  
  - `/sql/mortal/patches/`  

### Exit Criteria
- Server compiles & runs.  
- Test: simple Lua `OnLogin` script prints to server log.

---

# 5. Milestone 1 – Progression & Stats Foundation

### Goals
Implement the **non-negotiable fundamentals**:

- Dynamic level
- Attribute caps (150 / 400)
- Core skill table
- Hunger & encumbrance data hooks

### Tasks (C++)
- Implement `MortalLevel.h`/`.cpp`:
  - Override `Player::GetLevel()` to use skills/50.
- Override `Player::GiveXP()` → no-op.
- Attribute validation hook:
  - Enforce 150 per stat / 400 total.
- Expose APIs for:
  - Getting skills  
  - Getting derived level  
  - Getting encumbrance weight  

### Tasks (SQL)
- Add:
  - `mortal_character_skills`  
  - `mortal_character_attributes`  
  - `mortal_derived_level_cache` (optional, may come later).

### Tasks (Lua)
- `MortalCombatSkills.cpp/h` (C++ implementation) (basic version):  
  - On melee/ranged hit → tiny skill gain for weapon skill.
- `hunger_stub.lua` & `encumbrance_stub.lua`:
  - For now, just compute values and print to debug.

### Tasks (UI)
- MortalUI:
  - `ui_stats_overlay.lua` – display derived level & attribute totals.
  - `ui_hunger_display.lua` – placeholder bar.
  - `ui_encumbrance_display.lua` – placeholder.

### Exit Criteria
- Character levels no longer tied to XP.
- Attributes are enforced.
- Derived level shows in MortalUI.
- Hunger/encumbrance can be seen as debug bars (even if not yet impactful).

---

# 6. Milestone 2 – Risk Zones & Death/Loot Rules

### Goals
- Establish **risk tier framework**:
  - Green / Yellow / Red.
- Implement **basic loot-on-death** rules.
- Introduce **criminal flag** skeleton.

### Tasks (SQL)
- `zones_risk_flags` table & initial mapping for:
  - A few zones in each category (Elwynn green, Westfall yellow, STV red).

### Tasks (C++)
- `ZoneRiskHandler.cpp`:
  - On zone change → set risk tier on player.
- `PvPHooks.cpp`:
  - On player death → apply loot rules depending on risk tier and flags.
- `CorpseChest` initial implementation:
  - Single chest at corpse with all items in Red.

### Tasks (Lua)
- `MortalRiskZoneLogic.cpp/h` (C++ implementation):
  - Basic risk banner (server message).
- `corpse_chest.lua`:
  - Lua glue for chest creation & cleanup.

### Tasks (UI)
- MortalUI:
  - `ui_risk_zone_banner.lua` – big banner on zone transition.
  - Color-coded (Green/Yellow/Red).

### Exit Criteria
- Small test area with:
  - One Green zone (no PvP, no loot on death).
  - One Yellow zone (flag criminals in a basic way).
  - One Red zone (full loot chest on death).

---

# 7. Milestone 3 – Core Economy & Regional Banking

### Goals
- Establish **regional banks**.
- Create basic **market stalls**.
- Implement **initial gold sinks**.

### Tasks (SQL)
- Add:
  - `mortal_regional_bank`  
  - `mortal_market_stalls`  
  - `mortal_market_items`  

### Tasks (C++)
- Bank NPC hooks:
  - Override to route to `mortal_regional_bank` by region.
- Simple item persistence logic for regional bank slots.

### Tasks (Lua)
- `MortalMarketStalls.cpp/h` (C++ implementation):
  - Renting a stall.
  - Adding/removing an item with price.
- `simple_gold_sinks.lua`:
  - Mount repairs / early sink points.

### Tasks (UI)
- Add a simple **“Region” label** in bank window (via MortalUI).
- Add a minimal `Market Stall` gossip option (text UI acceptable at this stage).

### Exit Criteria
- Player can:
  - Use different banks in SW vs IF.
  - Rent a stall in one test city.
  - List an item and buy it (pickup in that city).

---

# 8. Milestone 4 – Crafting & Material Lore (Vertical Slice)

### Goals
- Launch a **vertical slice**: one or two material families fully wired.

Example slice:
- Metals: Copper + Iron.
- Basic workstation: Forge + Anvil.
- 2–3 simple recipes (sword, axe, pickaxe).

### Tasks (SQL)
- `mortal_material_properties` for Copper/Iron.
- `mortal_crafting_components`.
- `mortal_blueprints` minimal set.

### Tasks (C++)
- `CraftingHooks.cpp`:
  - Expose material stats to Lua.
  - Integrate durability decay (simple pass).

### Tasks (Lua)
- `MortalCraftingWorkstation.cpp/h` (C++ implementation):
  - Forge Anvil objects → open crafting UI.
- `MortalDurabilityDecay.cpp/h` (C++ implementation):
  - On use and on repair, reduce max durability.

### Tasks (UI)
- Minimal crafting UI via AIO or simple gossip menu:
  - Choose recipe → choose materials → craft → see quality result.

### Exit Criteria
- Player can:
  - Gather ore.
  - Refine to bars (via workstation).
  - Craft a weapon.
  - See quality/durability differences.
  - Watch durability decay when repairing/using.

---

# 9. Milestone 5 – World Simulation Lite & PvE Core

### Goals
- Add **dynamic spawns** and **task boards**.
- Convert **1–2 dungeons** to public mode.
- Implement **simple seasonal switch**.

### Tasks (SQL)
- `mortal_ecosystem_spawn_weights`.
- `dungeon_spawn_overrides` for 1–2 dungeons (ex. Deadmines, WC).
- `task_board_entries` – minimal entries.

### Tasks (Lua)
- `MortalDynamicEcosystem.cpp/h` (C++ implementation) – adjust spawn weights based on kills.
- `public_dungeon_spawns.lua` – handle open dungeon spawns.
- `MortalTaskBoard.cpp/h` (C++ implementation) – basic “kill X” tasks.

### Tasks (C++)
- `SpawnOverride.cpp` – allow dynamic spawn overrides.

### Exit Criteria
- One zone shows dynamic spawn changes based on hunting.
- One public dungeon with multiple groups present.
- A task board in a town with infinite repeatable tasks.

---

# 10. Milestone 6 – PvP Systems & Notoriety

### Goals
- Implement **Notoriety**, **Bounty Board v1**, and **Brace mechanic**.
- Add basic **anti-zerg** logic.

### Tasks (SQL)
- `mortal_notoriety`.
- `mortal_bounties`, `mortal_bounty_claims`.
- `mortal_pvp_kills`.

### Tasks (C++)
- `CriminalFlags.cpp`:
  - Flag handling for crimes.
- `BraceMechanic.cpp` + Spell DBC entry:
  - Off-GCD mitigation skill.
- Zerg detection flags in kill log.

### Tasks (Lua)
- `notoriety_handler.lua`.
- `MortalBountyBoard.cpp/h` (C++ implementation).
- `MortalHellgates.cpp/h` (C++ implementation) (simple version).

### Tasks (UI)
- Crime bar via `ui_crime_status.lua`.
- Bounty marker second pass in nameplates.

### Exit Criteria
- Players can become Criminal/Outlaw.
- Bounties can be placed and claimed.
- Brace is usable and meaningful in duels.

---

# 11. Milestone 7 – Guild Sovereignty & Strongholds

### Goals
- Implement strongholds, TCPs, and basic siege flow.
- Implement guild seasonal scoring.

### Tasks (SQL)
- `mortal_strongholds`.
- `mortal_tcp`.
- `mortal_guild_season_scores`.

### Tasks (C++)
- `StrongholdHandler.cpp`.
- `TerritoryControl.cpp`.
- `SiegeHooks.cpp` (simple: one-phase siege).

### Tasks (Lua)
- `MortalStrongholdSystem.cpp/h` (C++ implementation) – claim banner, buffs.
- `MortalTCPCapture.cpp/h` (C++ implementation) – influence gain.
- `guild_taxation.lua` – simple tax flows.

### Exit Criteria
- One test region where:
  - A guild can claim a stronghold.
  - A TCP can flip ownership.
  - Guild score updates on capture.

---

# 12. Milestone 8 – Caravans & Contracts

### Goals
- Implement courier contracts, caravans, and pack animals in a **contained loop**.

### Tasks (SQL)
- `mortal_courier_contracts`.
- `mortal_contract_crates`.
- `mortal_caravan_wagons`.

### Tasks (C++)
- `CaravanHooks.cpp` – movement + damage + drop logic.
- `ContractHooks.cpp` – link accept/complete/fail states.

### Tasks (Lua)
- `MortalCourierContracts.cpp/h` (C++ implementation).
- `MortalCaravanMovement.cpp/h` (C++ implementation).
- `MortalAmbushSpawner.cpp/h` (C++ implementation).

### Exit Criteria
- One demonstrable caravan route between two cities.
- Players can:
  - Create a contract.
  - Accept it with collateral.
  - Move a caravan.
  - Get attacked in a Red segment.
  - Finish or fail the contract.

---

# 13. Milestone 9 – Social Systems & MortalUI Polish

### Goals
- Polish **social hubs**, mini-games, titles.
- Finalize **MortalUI** as the coherent UX layer.

### Tasks (Lua)
- `tavern_games.lua`.
- `wager_system.lua`.
- `criminal_contracts.lua`.
- `discord_integration.lua`.

### Tasks (SQL)
- `mortal_titles`, `mortal_character_titles`.
- `mortal_character_bio`.

### Tasks (UI)
- Flesh out:
  - `ui_nameplate_driver.lua` (final icon sets & logic).
  - `ui_map_pins.lua` (full overlays).
  - `config_enforcer.lua` (lock critical settings).
- Make sure all **risk, crime, hunger, encumbrance, bounty, sovereignty** data is visible at-a-glance.

### Exit Criteria
- Social hubs feel alive (at least in core cities).
- UI feels cohesive and “Mortal branded”.
- Addon pack behaves reliably for new players via launcher.

---

# 14. Milestone 10 – Admin Tools, Analytics & Hardening

### Goals
- Provide **operational tooling** to actually run the server long-term.
- Harden against obvious exploits and data issues.

### Tasks (SQL)
- `mortal_log_*` tables created and verified.
- `mortal_feature_flags` live.

### Tasks (Lua)
- `admin_panel.lua` + UI (AIO).
- `mod_sandbox_watchdog.lua`.
- `analytics_collector.lua`.
- `live_balance.lua`.

### Tasks (C++)
- `AdminHooks.cpp`.
- `LogHooks.cpp`.
- `AnalyticsHooks.cpp`.

### Tasks (Launcher/Ops)
- Integrate “Report Bug / Send Logs” in launcher.
- Simple backup script (DB + configs).

### Exit Criteria
- You can:
  - See economy/pvp logs in admin UI.
  - Toggle key gameplay parameters live.
  - Identify and react to major economy or PvP anomalies.

---

# 15. Parallelization Guidance

For a solo or very small team:

- **Always keep one “system” in focus** (e.g., risk zones) and one “supporting track” (e.g., MortalUI).
- Use feature flags to:
  - Merge half-finished systems without enabling them globally.
- Avoid spreading across **too many** big systems at once (PvP + Caravans + Sovereignty will fry your stack).

Recommended order if you want “playability” early:
1. M0–M3 to get a weird-but-playable sandbox.
2. Then M4 (crafting) for long-term loops.
3. Then M6 (PvP) and **only afterward** big sovereignty/sieges.

---

# 16. Cursor Workflow Hints

When using Cursor:

- Create one **top-level folder per milestone** in your design (not in code) to hold:
  - Tasks checklist  
  - Relevant spec doc links  
  - Open TODO notes  

- For each milestone:
  1. Open the relevant spec files:  
     - e.g., `02-combat.md`, `03-risk-zones.md`, `04-economy.md`, etc.
  2. Use Cursor “cmd+enter” style prompts on **single files**:
     - “Implement this TODO in MortalLevel.cpp according to 01-core.md & 02-combat.md.”
  3. Keep commits small and milestone-tagged:
     - `feat(m1): add mortal skill tables`
     - `feat(m2): basic red-zone full-loot`

This keeps AI assistance **anchored to each spec doc** instead of hallucinating architecture.

---

# 17. Status

This roadmap is the **recommended build order for v26.1**.  
It intentionally:

- Locks in fundamentals early (progression, risk, economy).
- Delays “flashy” but complex systems (sieges, caravans) until a strong base exists.
- Gives you multiple “playable checkpoints” so the game is fun long before everything is finished.
