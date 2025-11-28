# Stubs and Incomplete Implementations - Scan Report

**Date:** 2025-01-XX  
**Status:** Comprehensive scan of all stubs, TODOs, and placeholders

---

## Summary

**Total Stubs Found:** ~50+ across codebase

**Categories:**
- **Critical (Production Blocking):** 3
- **High Priority (Feature Incomplete):** 8
- **Medium Priority (Enhancements):** 15
- **Low Priority (Polish/Optional):** 24+

---

## 🔴 Critical Stubs (Production Blocking)

### 1. Web Portal - Wiki Create/Update Handlers
**File:** `webportal/backend/internal/api/handlers/wiki.go`
**Lines:** 272, 291
**Status:** Returns `501 Not Implemented`
**Impact:** Wiki editing functionality completely missing

```go
// Line 272
c.JSON(http.StatusNotImplemented, gin.H{"error": "Not implemented"})

// Line 291
c.JSON(http.StatusNotImplemented, gin.H{"error": "Not implemented", "slug": slug})
```

**TODOs:**
- Line 261: Add authentication check
- Line 268: Validate user permissions
- Line 269: Generate slug from title if not provided
- Line 270: Set created_by_user_id from auth context
- Line 277: Add authentication check
- Line 286: Check if page exists
- Line 287: Check user permissions
- Line 288: Create version snapshot
- Line 289: Update page

**Fix Required:** Implement full CRUD operations for wiki pages

---

### 2. Web Portal - Market Trends Handler
**File:** `webportal/backend/internal/api/handlers/market.go`
**Line:** 236
**Status:** Returns `501 Not Implemented`
**Impact:** Market trends feature missing

```go
c.JSON(http.StatusNotImplemented, gin.H{"error": "Not implemented"})
```

**Fix Required:** Implement market trend analysis and endpoint

---

### 3. Web Portal - Map Resources Handler
**File:** `webportal/backend/internal/api/handlers/map.go`
**Line:** 82
**Status:** Returns `501 Not Implemented`
**Impact:** Resource node locations missing

```go
c.JSON(http.StatusNotImplemented, gin.H{"error": "Not implemented"})
```

**Fix Required:** Implement resource node query endpoint

---

## 🟠 High Priority Stubs (Feature Incomplete)

### 4. Web Portal - Shop Payment Integration
**File:** `webportal/backend/internal/api/handlers/shop.go`
**Line:** 115
**Status:** TODO comment, creates pending purchase but no payment processing
**Impact:** Shop purchases don't actually process payments

```go
// TODO: Integrate with payment processor (Stripe, PayPal, etc.)
// For now, create a pending purchase record
```

**Fix Required:** Integrate Stripe/PayPal payment processing

---

### 5. Web Portal - Discourse Sync Webhook
**File:** `webportal/backend/internal/api/handlers/discourse.go`
**Line:** 121
**Status:** Returns `501 Not Implemented`
**Impact:** Discourse user sync not working

```go
// TODO: Implement webhook handler for Discourse user updates
c.JSON(501, gin.H{"error": "Not implemented"})
```

**Fix Required:** Implement webhook handler for Discourse user updates

---

### 6. Launcher - File Dialog for Client Path
**File:** `launcher/src/pages/Settings.tsx`
**Line:** 15
**Status:** Uses `prompt()` instead of Tauri dialog
**Impact:** Poor UX for selecting client path

```typescript
// TODO: Use Tauri dialog API to browse for folder
const path = prompt('Enter WoW client path:')
```

**Fix Required:** Use Tauri's `dialog.open()` API

---

### 7. Launcher - Log Loading
**File:** `launcher/src/pages/Logs.tsx`
**Line:** 8
**Status:** Hardcoded placeholder logs
**Impact:** Log viewer doesn't show actual logs

```typescript
// TODO: Load logs from file or Tauri command
setLogs([
  '[2025-01-XX 10:00:00] Launcher started',
  // ... hardcoded
])
```

**Fix Required:** Implement log file reading or Tauri command

---

### 8. Web Portal - Shop Payment Method Selection
**File:** `webportal/frontend/src/pages/Shop.tsx`
**Line:** 74
**Status:** Hardcoded to 'stripe'
**Impact:** Users can't select payment method

```typescript
payment_method: 'stripe', // TODO: Let user select payment method
```

**Fix Required:** Add payment method selector UI

---

## 🟡 Medium Priority Stubs (Enhancements)

### 9. C++ Material System Integration
**File:** `src/MortalCombat.cpp`
**Line:** 227
**Status:** TODO comment
**Impact:** Material multipliers not applied

```cpp
// TODO: Integrate with material system to get actual material multiplier
return 1.0f;
```

**Fix Required:** Query material properties from database

---

### 10. Discourse - Game Account Linking
**File:** `webportal/backend/internal/api/handlers/discourse.go`
**Line:** 58
**Status:** TODO comment, placeholder query
**Impact:** Character names not linked to Discourse accounts

```go
// TODO: Link atlas_users to game accounts if needed
var characterName sql.NullString
h.db.QueryRow(
    "SELECT name FROM characters WHERE account = (SELECT account_id FROM atlas_user_game_link WHERE atlas_user_id = ? LIMIT 1) LIMIT 1",
    userID,
).Scan(&characterName)
```

**Fix Required:** Create `atlas_user_game_link` table and implement linking

---

### 11. Lua - C++ Hook Dependencies

Multiple Lua files have TODOs for C++ hooks:

#### 11a. Public Grouping
**File:** `lua/public_grouping.lua`
**Lines:** 101, 109
```lua
-- TODO: C++ hook for group invite
-- TODO: C++ hook for group creation and invite
```

#### 11b. Caravan Movement
**File:** `lua/caravan_movement.lua`
**Line:** 116
```lua
-- player:AddAura(SPELL_CARAVAN_SLOW, player) -- TODO: Define spell ID
```

#### 11c. Outlaw Hideouts
**File:** `lua/outlaw_hideouts.lua`
**Lines:** 74, 100, 242
```lua
-- TODO: Teleport player away or apply restrictions
-- TODO: Spawn or return fence vendor NPC
-- TODO: Define hidden quest chains for outlaws
```

#### 11d. Social Events
**File:** `lua/social_events.lua`
**Line:** 149
```lua
-- TODO: Implement reward distribution
```

#### 11e. Criminal Contracts
**File:** `lua/criminal_contracts.lua`
**Line:** 176
```lua
-- TODO: Verify caravan exists and is active
```

#### 11f. Tavern Games
**File:** `lua/tavern_games.lua`
**Lines:** 198, 204, 211, 279, 293
```lua
-- TODO: Apply vision blur effect (C++ hook)
-- TODO: Apply control wobble effect (C++ hook)
-- TODO: Apply pass out effect (C++ hook)
-- TODO: Integrate with weapon skill or accuracy system
-- TODO: Update daily leaderboard
```

#### 11g. Fog of War
**File:** `lua/fog_of_war.lua`
**Line:** 49
```lua
-- TODO: Call C++ hook to hide party dots and raid icons
```

#### 11h. Ambush Spawner
**File:** `lua/ambush_spawner.lua`
**Line:** 150
```lua
-- TODO: Integrate with trade route heatmap system
```

#### 11i. Caravan Events
**File:** `lua/caravan_event_controller.lua`
**Lines:** 22-24, 52-54, 82-84, 134, 140
```lua
-- TODO: Spawn NPC merchant caravan
-- TODO: Create escort quest/objective
-- TODO: Spawn escort rewards
-- TODO: Spawn NPC smuggler caravan
-- TODO: Check player notoriety for assistance
-- TODO: Spawn rewards for outlaws
-- TODO: Spawn guild-owned caravan
-- TODO: Check guild relations for ambush eligibility
-- TODO: Spawn siege materials on delivery
-- TODO: Grant rewards (multiple)
```

#### 11j. Escort System
**File:** `lua/escort_system.lua`
**Lines:** 101, 104, 108
```lua
-- TODO: Implement merit point system
-- TODO: Implement reputation system
-- TODO: Grant special reward crate
```

#### 11k. Migration Controller
**File:** `lua/migration_controller.lua`
**Lines:** 46, 49, 52, 101
```lua
-- TODO: Check weather
-- TODO: Check season (multiple)
-- TODO: Spawn creatures in destination zone
```

#### 11l. Day/Night Modifiers
**File:** `lua/daynight_modifiers.lua`
**Line:** 114
```lua
-- TODO: Define wolf creature entries
```

#### 11m. Sandbox Watchdog
**File:** `lua/mod_sandbox_watchdog.lua`
**Line:** 146
```lua
-- TODO: Implement caravan attack tracking
```

#### 11n. Caravan Upgrades
**File:** `lua/caravan_upgrades.lua`
**Line:** 158
```lua
-- TODO: Implement proper JSON parsing
```

#### 11o. Smuggler Routes
**File:** `lua/smuggler_routes.lua`
**Lines:** 144, 169
```lua
-- TODO: Apply movement speed bonus, increased ambush chance, etc.
-- TODO: Apply bonus rewards
```

#### 11p. Predator/Prey
**File:** `lua/predator_prey.lua`
**Line:** 79
```lua
-- TODO: Trigger predator migration
```

---

### 12. Client Addon - Custom Packet Registration

Multiple addon files have TODOs for custom packet registration:

#### 12a. Encumbrance Display
**File:** `addons/MortalUI/modules/ui_encumbrance_display.lua`
**Line:** 47
```lua
-- TODO: Register for custom packet from server
```

#### 12b. Hunger Display
**File:** `addons/MortalUI/modules/ui_hunger_display.lua`
**Line:** 51
```lua
-- TODO: Register for custom packet from server
```

#### 12c. Stats Overlay
**File:** `addons/MortalUI/modules/ui_stats_overlay.lua`
**Lines:** 40, 63
```lua
-- TODO: Display skill summaries
-- TODO: Register for custom packet from server
```

#### 12d. Map Pins
**File:** `addons/MortalUI/modules/ui_map_pins.lua`
**Lines:** 35, 41, 46, 51
```lua
-- TODO: Register with HandyNotes
-- TODO: Remove from HandyNotes
-- TODO: Parse server data and update pins
-- TODO: Register for custom packet from server
```

#### 12e. Tooltip Injector
**File:** `addons/MortalUI/modules/ui_tooltip_injector.lua`
**Line:** 36
```lua
-- TODO: Query item data from server via custom packet
```

#### 12f. Nameplate Driver
**File:** `addons/MortalUI/modules/ui_nameplate_driver.lua`
**Lines:** 26, 37
```lua
-- TODO: Get player data from server via custom packet
-- TODO: Hook into nameplate addon's update function
```

#### 12g. Risk Zone Banner
**File:** `addons/MortalUI/modules/ui_risk_zone_banner.lua`
**Line:** 56
```lua
-- TODO: Get zone type from server via custom packet
```

#### 12h. Crime Status
**File:** `addons/MortalUI/modules/ui_crime_status.lua`
**Line:** 81
```lua
-- TODO: Register for custom packet from server
```

#### 12i. Config Enforcer
**File:** `addons/MortalUI/modules/config_enforcer.lua`
**Lines:** 40, 48
```lua
-- TODO: Check zone type and enforce
-- TODO: Ensure tooltip addon is loaded
```

---

## 🟢 Low Priority Stubs (Polish/Optional)

### 13. Placeholder Values

#### 13a. Insurance Vouchers
**File:** `lua/insurance_vouchers.lua`
**Line:** 42
```lua
local baseValue = 10000 -- Placeholder: 1g base
```

#### 13b. Navigation POIs
**File:** `lua/navigation_pois.lua`
**Line:** 165
```lua
-- For now, it's a placeholder that would be called from player update events
```

#### 13c. Public Grouping
**File:** `lua/public_grouping.lua`
**Line:** 28
```lua
-- For now, return false (placeholder)
```

#### 13d. Buy Orders
**File:** `lua/buy_orders.lua`
**Line:** 140
```lua
-- For now, it's a placeholder for the generation logic
```

#### 13e. Alpha Variant Handler
**File:** `lua/alpha_variant_handler.lua`
**Lines:** 109-110, 114
```lua
{ entry = 900010, count = 1, chance = 100 }, -- Placeholder: Mythic Essence
{ entry = 900011, count = 1, chance = 50 }, -- Placeholder: Legendary Trophy
{ entry = 900012, count = 1, chance = 75 }, -- Placeholder: Alpha Essence
```

#### 13f. Anti-Zerg
**File:** `lua/anti_zerg.lua`
**Lines:** 33, 44
```lua
-- Placeholder implementation
```

#### 13g. Day/Night Modifiers
**File:** `lua/daynight_modifiers.lua`
**Lines:** 51, 64
```lua
-- This is a placeholder for the logic
```

#### 13h. Weather Controller
**File:** `lua/weather_controller.lua`
**Line:** 140
```lua
-- This is a placeholder for the logic
```

#### 13i. TCP Capture
**File:** `lua/tcp_capture.lua`
**Lines:** 183, 213
```lua
-- For now, return a placeholder
```

#### 13j. Caravan Movement
**File:** `lua/caravan_movement.lua`
**Line:** 50
```lua
-- This is a placeholder - full implementation needs C++ hook
```

#### 13k. Material Lore Integration
**File:** `lua/material_lore_integration.lua`
**Line:** 66
```lua
-- For now, we'll use a placeholder
```

#### 13l. Mounted Combat
**File:** `lua/mounted_combat.lua`
**Line:** 154
```lua
-- These are placeholders for when C++ support is added
```

#### 13m. Sky Predator AI
**File:** `lua/sky_predator_ai.lua`
**Line:** 66
```lua
-- Note: This is a placeholder - actual implementation may require C++ support
```

#### 13n. Ether Ghost Nerf
**File:** `lua/ether_ghost_nerf.lua`
**Line:** 47
```lua
-- This is a placeholder - actual visibility blocking requires core modification
```

#### 13o. UI Enforcer
**File:** `lua/ui_enforcer.lua`
**Line:** 124
```lua
-- This is just a placeholder for future client-side logic
```

#### 13p. Addon Placeholders
**Files:** Multiple addon files
```lua
-- For now, placeholder
```

---

## 📊 Summary by Category

### By Priority
- **Critical:** 3 stubs
- **High Priority:** 8 stubs
- **Medium Priority:** 15 stubs
- **Low Priority:** 24+ stubs

### By Type
- **Web Portal Handlers:** 5 stubs
- **C++ Hook Dependencies:** 20+ stubs
- **Client Addon Packets:** 9 stubs
- **Placeholder Values:** 15+ stubs
- **Launcher UI:** 2 stubs
- **Payment Integration:** 1 stub

### By Component
- **Web Portal Backend:** 5 stubs
- **Web Portal Frontend:** 1 stub
- **Launcher:** 2 stubs
- **Lua Scripts:** 30+ stubs
- **Client Addons:** 9 stubs
- **C++ Code:** 1 stub

---

## 🎯 Recommended Action Plan

### Phase 1: Critical Fixes (Production Blocking)
1. ✅ Implement Wiki Create/Update handlers
2. ✅ Implement Market Trends handler
3. ✅ Implement Map Resources handler

### Phase 2: High Priority (Feature Complete)
4. ✅ Integrate payment processor (Stripe)
5. ✅ Implement Discourse sync webhook
6. ✅ Replace launcher `prompt()` with Tauri dialog
7. ✅ Implement launcher log loading
8. ✅ Add payment method selector to shop

### Phase 3: Medium Priority (Enhancements)
9. ✅ Integrate material system in combat formulas
10. ✅ Create game account linking for Discourse
11. ✅ Document C++ hook requirements (many are optional)

### Phase 4: Low Priority (Polish)
12. ✅ Replace placeholder values with real data
13. ✅ Implement custom packet system for addons
14. ✅ Complete optional features

---

## Notes

- **C++ Hooks:** Many Lua TODOs are for C++ hooks that are optional for core functionality. These can be implemented incrementally.
- **Client Addons:** Custom packet registration requires C++ server-side packet implementation.
- **Payment Integration:** Shop system is functional but needs payment processor integration for production.
- **Placeholders:** Many placeholder values are functional but should be replaced with real data/config.

---

**Status:** Most stubs are non-blocking for core functionality. Critical stubs are in web portal handlers.

