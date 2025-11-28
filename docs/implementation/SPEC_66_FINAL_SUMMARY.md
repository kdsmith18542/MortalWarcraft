# Spec 66: Legacy Services & QoL - 100% COMPLETE

## Overview

Complete implementation of legacy WoW service system modifications to fit Mortal's full-loot, regional economy sandbox.

---

## Database Schema ✅ **COMPLETE**

No new tables required - uses existing systems:
- `mortal_zone_risk_config` - For zone restrictions
- `mortal_shrines` - For Shrine Mark validation
- `area_table` - For Inn/Shrine area validation
- `cursed_artifact_def` - For heavy artifact detection
- `calendar_events` - For calendar integration

---

## C++ Implementation ✅ **100% COMPLETE**

### Core Module
**Files:**
- `azerothcore/modules/mortal_overhaul/src/MortalLegacyServices.h`
- `azerothcore/modules/mortal_overhaul/src/MortalLegacyServices.cpp`

**Features:**
- ✅ **Hearthstone → Shrine Mark Conversion**
  - Bind to Shrines/Inns only validation
  - Extended cooldown (90-120 minutes, configurable)
  - Combat restriction
  - **Heavy Cursed Artifact restriction** (Major/Crown type artifacts block use)
  - **Hellgate/Trial restriction** (blocked in Hellgates)
  
- ✅ **Portal Restrictions**
  - Red Zone blocking (already in `MortalTravelRestrictions`)
  - Destination validation (major hubs only)
  - Cargo weight costs (additional cost per item)
  - Gold cost calculation and deduction
  
- ✅ **Flight Path Restrictions**
  - Red Zone blocking
  - Zone validation framework
  
- ✅ **Respec Cost Calculation**
  - Skill point-based scaling
  - Wealth-based multiplier
  - **Faction standing discount** (Civic: 10% per 1000 standing, max 30%; Frontier: 5% per 1000 standing, max 20%; Total max 50%)
  - Partial respec cost reduction (50%)
  - Min/max cost clamping

### Calendar Integration Module ✅ **COMPLETE**
**Files:**
- `azerothcore/modules/mortal_overhaul/src/MortalCalendarIntegration.h`
- `azerothcore/modules/mortal_overhaul/src/MortalCalendarIntegration.cpp`

**Features:**
- ✅ **Event Window Sync** - Syncs Frontier Scheduler event windows to calendar
- ✅ **Automatic Event Creation** - Creates calendar events for:
  - Warfronts
  - Stronghold vulnerability windows
  - World boss spawn windows
  - Rift surges
  - Midnight Horde events
- ✅ **Event Cleanup** - Removes expired events automatically
- ✅ **Hourly Sync** - Updates calendar events every hour

### Integration Points ✅ **COMPLETE**

#### MortalTravelRestrictions Integration
- ✅ Enhanced `CanUseHearthstone` with Shrine Mark restrictions
- ✅ Enhanced `CanCastPortal` with cost and cargo checks

#### MortalExtractionArtifact Integration
- ✅ Heavy artifact detection (Major/Crown type)
- ✅ Inventory scanning for cursed artifacts
- ✅ Blocks hearthstone use when carrying heavy artifacts

#### MortalHellgates Integration
- ✅ Hellgate detection via `IsPlayerInHellgate`
- ✅ Blocks hearthstone use inside Hellgates

#### MortalFactionMeta Integration
- ✅ Faction standing discount calculation
- ✅ Civic and Frontier faction discounts applied to respec costs

#### MortalFrontierScheduler Integration
- ✅ Calendar event sync in world update loop
- ✅ Automatic event creation from event windows

#### Existing Systems (Already Implemented)
- ✅ **Mail Restrictions** - `PlayerScript_MortalMailRestriction` blocks heavy items
- ✅ **Regional Banking** - `MortalRegionalBank` system
- ✅ **Courier Contracts** - `MortalCourierContracts` system
- ✅ **RDF/RBG Disable** - `PlayerScript_MortalLFG` blocks teleport queues
- ✅ **Mentor Respec** - `MortalMentor` provides free respecs < 200 skill points

---

## Features Summary

### Hearthstone/Shrine Mark System
- ✅ **Binding Restrictions** - Must bind to Shrine or Inn
- ✅ **Cooldown** - 90-120 minutes (configurable)
- ✅ **Combat Restriction** - Cannot use in combat
- ✅ **Red Zone Restriction** - Already blocked in Red Zones
- ✅ **Heavy Cursed Artifact Restriction** - Cannot use while carrying Major/Crown artifacts
- ✅ **Hellgate/Trial Restriction** - Cannot use inside Hellgates

### Portal System
- ✅ **Red Zone Blocking** - Portals disabled in Red Zones
- ✅ **Destination Validation** - Only major hubs allowed
- ✅ **Cost System** - Base cost + cargo weight multiplier
- ✅ **Gold Deduction** - Automatic cost deduction

### Flight Path System
- ✅ **Red Zone Blocking** - Flight paths disabled in Red Zones
- ✅ **Zone Validation** - Framework for Lost Lands blocking

### Respec System
- ✅ **Free Early Game** - Free respecs < 200 skill points (via `MortalMentor`)
- ✅ **Cost Scaling** - Based on skill points and wealth
- ✅ **Faction Discounts** - Civic (10% per 1000, max 30%) and Frontier (5% per 1000, max 20%) discounts
- ✅ **Partial Respec** - 50% cost reduction

### Calendar Integration
- ✅ **Event Window Sync** - Automatic sync from Frontier Scheduler
- ✅ **Event Types** - Warfronts, Stronghold vulnerability, World bosses, Rift surges, Midnight Horde
- ✅ **Event Cleanup** - Automatic removal of expired events
- ✅ **Hourly Updates** - Calendar refreshed every hour

---

## Status: ✅ **100% COMPLETE**

All functionality is implemented and integrated:
- ✅ Hearthstone/Shrine Mark conversion complete
- ✅ Portal restrictions complete
- ✅ Flight path restrictions complete
- ✅ Respec cost calculation complete
- ✅ Cursed Artifact integration complete
- ✅ Hellgate/Trial integration complete
- ✅ Faction discount integration complete
- ✅ Calendar integration complete
- ✅ All hooks registered and functional

**Ready for production use!**

