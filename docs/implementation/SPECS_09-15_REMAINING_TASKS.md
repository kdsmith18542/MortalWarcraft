# Specs 09-15: Remaining Tasks

**Date:** 2025-01-XX  
**Status:** ⚠️ **7/50+ Tasks Completed (14%)**

---

## ✅ Completed Tasks (7)

1. ✅ Title System (Spec 09)
2. ✅ Character Bio System (Spec 09)
3. ✅ Material Properties SQL (Spec 10)
4. ✅ Anti-Zerg Mechanics (Spec 11)
5. ✅ PvP Season System (Spec 11)
6. ✅ Alpha Variant Handler (Spec 12)
7. ✅ Weather Controller (Spec 12)

---

## 🔴 Remaining Tasks by Spec

### Spec 09: Social Systems (22% → 35%)

#### High Priority:
- [ ] **Tavern Games System** (`lua/tavern_games.lua`)
  - Card games (Dragon Deck)
  - Drinking contests
  - Knife toss mini-game
  - Bard NPCs
  - Bulletin boards
  - Rumors system
- [ ] **Radio Silence** (`lua/radio_silence.lua`)
  - Disable world chat in Red zones
  - Disable global channels in Red zones
- [ ] **Social Events** (`lua/social_events.lua`)
  - Weekly events (Tavern Brawl, Dice Tournament, Treasure Hunt, Fishing Derby)
  - Monthly events (Guild Festivals, Market Day, Outlaw Carnival)
  - Seasonal events

#### Medium Priority:
- [ ] **Criminal Contracts** (`lua/criminal_contracts.lua`)
  - Assassination contracts
  - Illegal goods delivery
  - Caravan theft contracts
- [ ] **Outlaw Hideouts** (`lua/outlaw_hideouts.lua`)
  - Fence vendors
  - Outlaw dueling pits
  - Hidden quest chains
  - Black Market crafting bench

#### Low Priority:
- [ ] **Discord Integration** (`lua/discord_integration.lua`)
- [ ] **Enhanced Emotes** (C++ hooks needed)
- [ ] **Inspect Extensions** (C++ hooks needed)
- [ ] **Tavern Minigame Tables** (`sql/tavern_minigame_tables.sql`)

**Remaining: 10 tasks**

---

### Spec 10: Crafting Economy (93% → 100%)

#### Completed:
- ✅ Material Properties SQL

**Remaining: 0 tasks** ✅ **COMPLETE**

---

### Spec 11: PvP Systems (69% → 80%)

#### High Priority:
- [ ] **Fog of War** (`lua/fog_of_war.lua`)
  - Hide party dots on minimap in Red zones
  - No raid icons unless manually set
  - Reduced visibility
  - **Note:** Requires C++ hooks

#### Medium Priority:
- [ ] **Hitbox Rewrites** (C++ hooks only)
- [ ] **Stagger System** (C++ hooks only)

**Remaining: 3 tasks (2 require C++)**

---

### Spec 12: World Simulation (58% → 70%)

#### High Priority:
- [ ] **Day/Night Cycle** (`lua/daynight_modifiers.lua`)
  - Night modifiers (Undead spawns, Wolves +10% damage, Fireflies, Spectral variants)
  - Day modifiers (Herbivore density, Node respawns, Merchant activity)

#### Medium Priority:
- [ ] **Migratory Mobs** (`lua/migration_controller.lua`)
  - Migration rules (night, heavy hunting, weather, seasons)
  - Migration events (Kodo herds, Dragon whelps, Undead packs)
  - Zone-wide broadcasts

#### Low Priority:
- [ ] **Predator-Prey Logic** (`lua/predator_prey.lua`)
  - Relationship definitions
  - Population balance tracking
  - Migration triggers
- [ ] **Ecosystem Relations SQL** (`sql/ecosystem_relations.sql`)
- [ ] **Ecosystem Spawn Weights SQL** (`sql/ecosystem_spawn_weights.sql`)

**Remaining: 5 tasks**

---

### Spec 13: Caravans & Contracts (57% → 57%)

#### High Priority:
- [ ] **Ambush Spawner** (`lua/ambush_spawner.lua`)
  - Ambush AI mobs (bandits) spawn on high-risk points
  - Weather event triggers
  - Hot trade route detection
  - Player ambush handling
  - Caravan chest drops
- [ ] **Caravan Movement Physics** (`lua/caravan_movement.lua`)
  - Damped physics (slow acceleration, slow turning, heavy braking)
  - Cannot traverse steep slopes
  - Cannot enter buildings
  - Turn rate limitations
  - **Note:** Requires C++ hooks for full physics

#### Medium Priority:
- [ ] **Escort System** (`lua/escort_system.lua`)
  - Escort merit points
  - Bonus gold for escorts
  - Reputation with trade factions
  - Special caravan reward crates
- [ ] **Caravan Upgrades** (`lua/caravan_upgrades.lua` + `sql/caravan_upgrades.sql`)
  - Reinforced wheels
  - Heavy armor plating
  - Faster pack animals
  - Magical lantern
  - Decoy wagon

#### Low Priority:
- [ ] **Smuggler Routes** (`lua/smuggler_routes.lua`)
  - Outlaw-exclusive secret tunnels
  - Hidden passages
  - Abandoned mines
  - High-risk, high-reward paths
- [ ] **Caravan Events** (`lua/caravan_event_controller.lua`)
  - Merchant Convoy
  - Smuggler Convoy
  - Siege Supply Caravan
- [ ] **Caravan Wagon Stats SQL** (`sql/caravan_wagon_stats.sql`)
- [ ] **Contract Crates SQL** (`sql/contract_crates.sql`)

**Remaining: 8 tasks**

---

### Spec 14: Admin Tools (13% → 13%)

#### High Priority:
- [ ] **GM Roles & Permissions** (`sql/gm_roles.sql` + `sql/gm_permissions.sql`)
  - Admin, Senior GM, GM, Event GM, Observer roles
  - Permission layer system
- [ ] **Logging System** (5 SQL files)
  - `sql/log_economy.sql` - Economy logs
  - `sql/log_pvp.sql` - PvP logs
  - `sql/log_crime.sql` - Crime logs
  - `sql/log_guild.sql` - Guild logs
  - `sql/log_admin.sql` - Admin logs
- [ ] **Sandbox Watchdog** (`lua/mod_sandbox_watchdog.lua`)
  - Resource injection alerts
  - Gold spike detection
  - High-frequency kill detection
  - Suspicious caravan attack detection

#### Medium Priority:
- [ ] **AIO Admin Panel** (`lua/admin_panel.lua` + client addon)
  - Players tab (search, teleport, jail, mute, kick, ban)
  - Economy tab (regional banks, gold holders, auctions, caravans)
  - Territory tab (strongholds, TCPs, sieges)
  - Events tab (trigger events, schedule)
  - PvP & Crime tab (killers, notoriety, bounties)
  - Logs & Alerts tab (view logs, filter)
- [ ] **Feature Flags** (`sql/feature_flags.sql` + `lua/live_balance.lua`)
  - Tunable flags (decay rate, notoriety thresholds, etc.)
  - Hotfix hooks (damage multipliers, spawn rates, etc.)
  - Configurable without restart

#### Low Priority:
- [ ] **Analytics Collector** (`lua/analytics_collector.lua`)
  - Player retention by zone
  - Popular risk tiers
  - Trade route heatmaps
  - PvP hotspots
  - Crafting bottlenecks
  - CSV export
  - External API export
- [ ] **Error Reporter** (`lua/error_reporter.lua`)
  - Crash logs
  - Lua errors
  - Script stack traces
- [ ] **AzerothAdmin Integration** (client addon)
- [ ] **MortalAdmin Addon** (client-side)

**Remaining: 12 tasks**

---

### Spec 15: UI/Client (33% → 33%)

#### High Priority:
- [ ] **Mortal_Stats Addon** (client-side)
  - Remove: Hit rating, Spell penetration, Defense rating, Crit rating, Haste rating
  - Add: Derived Level, Attribute caps, Skill summaries, Hunger, Encumbrance, Temperature, Regional influence, Guild buffs
- [ ] **Mortal_Tooltips Addon** (client-side)
  - Item weight display
  - Weight class display
  - Material properties display
  - Crafting requirements display
  - Lore skill requirements display
  - Zone-based risk indicators
  - "Drops on death: Yes/No" display
  - Reputation bonuses display
- [ ] **Crime Status Display** (`lua/ui_crime_status.lua` client-side)
  - Current notoriety tier
  - Criminal flag timer
  - Bounty display
  - Outlaw map visibility toggle

#### Medium Priority:
- [ ] **Encumbrance Display** (client-side)
  - Total weight display
  - Movement speed updates
  - Flash red when overloaded
- [ ] **Risk Zone Banner** (client-side)
  - Risk level display
  - Loot rules
  - Crime consequences
- [ ] **Wrapped Addons Configuration**
  - Immersion (quest dialogue)
  - DynamicCam (action cam)
  - Bagnon (inventory with "Drops on Death?" icon)
  - Bartender4 (pre-made Mortal profile)
  - Mapster + HandyNotes (territory overlays)

#### Low Priority:
- [ ] **Client-Side Performance Rules**
  - Red Zones: Lower draw distance, reduce clutter, disable particles
  - Green Zones: Full UI, Immersion enabled, action cam allowed
- [ ] **Launcher Integration** (Rust/Tauri)
  - Addon installation verification
  - Hash checks for Mortal forks
  - DBC patches applied
  - Client settings locked
  - "Repair UI" button
- [ ] **DBC Modifications**
  - TalentTab.dbc (Universal Mastery Trees)
  - Item.dbc (remove level reqs, add skill reqs, item categories)
  - Spell.dbc (Brace mechanic, Hunger debuffs, Encumbrance penalties, Crime flag visuals)

**Remaining: 12 tasks (mostly client-side)**

---

## 📊 Summary

| Spec | Completed | Remaining | Total | % Complete |
|------|-----------|-----------|-------|------------|
| **09: Social Systems** | 2 | 10 | 12 | 17% |
| **10: Crafting Economy** | 1 | 0 | 1 | 100% ✅ |
| **11: PvP Systems** | 2 | 3 | 5 | 40% |
| **12: World Simulation** | 2 | 5 | 7 | 29% |
| **13: Caravans & Contracts** | 0 | 8 | 8 | 0% |
| **14: Admin Tools** | 0 | 12 | 12 | 0% |
| **15: UI/Client** | 0 | 12 | 12 | 0% |
| **Total** | **7** | **50** | **57** | **12%** |

---

## 🎯 Priority Breakdown

### Critical (Must Have):
- GM Roles & Permissions (Spec 14)
- Logging System (Spec 14)
- Ambush Spawner (Spec 13)
- Radio Silence (Spec 09)

### High Priority:
- Caravan Movement Physics (Spec 13)
- Fog of War (Spec 11)
- Day/Night Cycle (Spec 12)
- Tavern Games System (Spec 09)
- Sandbox Watchdog (Spec 14)

### Medium Priority:
- Escort System (Spec 13)
- Migratory Mobs (Spec 12)
- Social Events (Spec 09)
- Feature Flags (Spec 14)
- AIO Admin Panel (Spec 14)

### Low Priority:
- Client-side addons (Spec 15)
- Discord Integration (Spec 09)
- Analytics (Spec 14)
- Launcher Integration (Spec 15)
- DBC Modifications (Spec 15)

---

## 📝 Notes

- **50 tasks remaining** across specs 09-15
- **7 tasks completed** (14% of remaining work)
- **Spec 10 is 100% complete** ✅
- **Many tasks require C++ hooks** (noted in each spec)
- **Client-side work** (Spec 15) requires addon development
- **Admin Tools** (Spec 14) is critical for launch but currently 0% complete

---

**Status:** ⚠️ **Significant work remaining - 50 tasks to complete**

