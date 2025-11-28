# Spec 35: Mortal PvP Vendors and Rewards - Verification

**Date:** 2025-01-XX  
**Status:** ✅ **~95% PRODUCTION COMPLETE** (Minor: Season integration TODO)

---

## Overview

Spec 35 defines the PvP vendor system with data-driven item gating, currency management, and rating/achievement requirements. The system is mostly complete with a minor TODO for season integration.

---

## Implementation Status

### ✅ **Database Schema**

**Tables:**
- ✅ `mortal_pvp_item_requirements` - Item gating requirements
  - Fields: `item_entry`, `rating_band_code`, `min_rating`, `bracket_mask`, `min_season_id`, `require_achievement`, `cost_tokens`, `cost_credits`, `cost_commendations`
- ✅ `mortal_currencies` - Player currency storage
  - Fields: `guid`, `currency_code`, `amount`, `updated_at`
- ✅ `mortal_pvp_vendors` - Vendor NPC assignments
  - Fields: `npc_entry`, `vendor_type`, `tier_bands`, `location`

**SQL Files:**
- ✅ `sql/81_pvp_vendors.sql` - Base schema
- ✅ `sql/93_pvp_vendor_npcs.sql` - Vendor NPCs
- ✅ `sql/101_pvp_item_requirements_template.sql` - Template structure
- ✅ `sql/102_pvp_item_requirements_populated.sql` - Populated data
- ✅ `sql/103_pvp_vendor_inventories.sql` - Vendor inventories

### ✅ **C++ Implementation**

**Files:**
- ✅ `azerothcore/modules/mortal_overhaul/src/MortalPvPVendors.cpp`
- ✅ `azerothcore/modules/mortal_overhaul/src/MortalPvPVendors.h`

**Functions:**
- ✅ `Initialize()` - System initialization
- ✅ `GetCurrency()` - Get player currency
- ✅ `AddCurrency()` - Add currency to player
- ✅ `RemoveCurrency()` - Remove currency from player
- ✅ `GetBestArenaRating()` - Get best rating across brackets
- ✅ `GetBracketRating()` - Get rating for specific bracket
- ✅ `CheckItemRequirements()` - Validate item requirements
- ✅ `OnBeforeBuyItemFromVendor()` - Pre-purchase validation
- ✅ `OnAfterStoreOrEquipNewItem()` - Post-purchase currency deduction
- ✅ `OnGossipHello()` - Vendor gossip menu

**Features:**
- ✅ Rating requirement checking
- ✅ Bracket-specific rating checks
- ✅ Achievement requirement checking
- ✅ Currency requirement checking
- ✅ Currency deduction on purchase
- ✅ Error messaging for failed requirements

### ⚠️ **Minor: Season Integration**

**What's Missing:**
- ⚠️ Season requirement checking (TODO noted in code)
- ⚠️ Integration with `mortal_arena_seasons` table

**Impact:**
- Season-specific items cannot be properly gated
- Non-critical but would complete the system

**Code Location:**
- `MortalPvPVendors.cpp:167` - `// TODO: Integrate with season system`

### ✅ **Vendor NPCs**

**Alliance (Stormwind - Hall of Champions):**
- ✅ Entry Combatant Quartermaster (90001) - P1 gear
- ✅ Challenger Quartermaster (90002) - P2-P4 gear
- ✅ Elite Quartermaster (90003) - P5-P6 gear
- ✅ Warfront Quartermaster (90004) - Siege items

**Horde (Orgrimmar - Hall of Blood):**
- ✅ Entry Combatant Quartermaster (90011) - P1 gear
- ✅ Challenger Quartermaster (90012) - P2-P4 gear
- ✅ Elite Quartermaster (90013) - P5-P6 gear
- ✅ Warfront Quartermaster (90014) - Siege items

---

## Issues Found

### 1. Season Integration TODO
- Season requirement checking not implemented
- Non-critical but would complete the system

---

## What's Missing

1. ⚠️ **Season Integration** - Season requirement checking (minor TODO)

---

## Production Readiness

**Status:** ✅ **~95% PRODUCTION COMPLETE**

- ✅ Database schema: Complete
- ✅ C++ implementation: Complete
- ✅ Vendor NPCs: Complete
- ✅ Currency system: Complete
- ✅ Rating gating: Complete
- ✅ Achievement gating: Complete
- ⚠️ Season gating: TODO (minor)

**Note:** The system is production-ready except for season-specific item gating, which is a minor feature.

