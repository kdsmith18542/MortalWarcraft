# Systematic Implementation Approach

**Date**: 2025-01-XX  
**Purpose**: Systematic approach to implementation that accounts for ALL 106 spec documents, not just the old roadmap

---

## Problem with Old Roadmap

The `17-implementation-roadmap.md` only references ~10 specs (M0-M10), but we have **106 spec documents**. It's outdated and doesn't account for:
- All the new specs created since v26.1
- The new design decisions we just made
- The actual implementation status

---

## Better Approach: Spec-by-Spec Verification

Instead of following the old roadmap, we should:

1. **Start with Core Specs (00-15)** - Foundation systems
2. **Verify what's implemented** - Check C++/Lua/SQL against each spec
3. **Identify gaps** - What's missing from new design decisions
4. **Implement systematically** - One spec at a time, verify completion

---

## Implementation Status Overview

**Current State**:
- ✅ **~200+ C++ modules** exist in `azerothcore/modules/mortal_overhaul/src/`
- ✅ **Many systems partially implemented**
- ⚠️ **Need to verify alignment** with all 106 specs
- ⚠️ **Need to add missing pieces** from new design decisions

---

## Systematic Verification Process

### Phase 1: Core Foundation (Specs 00-15)

**Priority**: Critical - These are the foundation

1. **00-overview.md** - Vision & pillars ✅ (Reference only)
2. **01-progression.md** - Skills, levels, attributes
   - ✅ `MortalLevel.cpp` exists
   - ✅ `MortalCombatSkills.cpp` exists
   - ❌ `MortalSkillTrainer.cpp/h` - **MISSING** (new design decision)
3. **02-combat.md** - Combat formulas, PvP, crime
   - ✅ `MortalCombat.cpp` exists
   - ⚠️ Need to verify formulas match spec
4. **03-risk-zones.md** - Green/Yellow/Red zones
   - ✅ `MortalRiskZoneLogic.cpp` exists
   - ❌ `MortalGuardAI.cpp/h` - **MISSING** (new design decision)
   - ⚠️ Flight path restrictions need completion
5. **04-economy.md** - Regional banking, markets
   - ✅ `MortalRegionalBank.cpp` exists
   - ✅ `MortalMarketStalls.cpp` exists
   - ⚠️ Regional mail needs completion
   - ❌ Regional tokens system - **MISSING** (new design decision)
6. **05-crafting.md** - Crafting, materials
   - ✅ `MortalCraftingSkills.cpp` exists
   - ✅ `MortalMaterialLore.cpp` exists
7. **06-pve.md** - PvE content, dungeons
   - ✅ `MortalPublicDungeonAI.cpp` exists
   - ✅ `MortalDelveInstances.cpp` exists
   - ⚠️ Need to verify lockouts removed
   - ❌ Key access system - **MISSING** (new design decision)
8. **07-mounts.md** - Mount system
   - ✅ `MortalLivingMounts.cpp` exists
9. **08-guilds-sovereignty.md** - Guilds, strongholds
   - ✅ `MortalStrongholdSystem.cpp` exists
10. **09-social-systems.md** - Social systems
    - ✅ Friend/ignore system exists
    - ✅ Real ID removal (verify no code exists)
11. **10-crafting-economy.md** - Crafting economy
    - ✅ `MortalCraftingWorkstation.cpp` exists
12. **11-pvp-systems.md** - PvP systems
    - ✅ `MortalBountyBoard.cpp` exists
    - ✅ `MortalBountyPot.cpp` exists
13. **12-world-simulation.md** - World simulation
    - ✅ `MortalDynamicEcosystem.cpp` exists
    - ✅ `MortalEnvironmentalHazards.cpp` exists
    - ⚠️ Northrend cold weather - **NEEDS ADDITION** (new design decision)
14. **13-caravans-contracts.md** - Caravans, contracts
    - ✅ `MortalCaravanSystem.cpp` exists
    - ✅ `MortalCourierContracts.cpp` exists
15. **14-admin-tools.md** - Admin tools
    - ✅ `MortalAnalytics.cpp` exists
16. **15-ui-client.md** - UI/Client
    - ✅ MortalUI addon exists

---

### Phase 2: Extended Systems (Specs 16-50)

**Priority**: High - Extended features

- **16-database-schema.md** - Database structure
- **17-implementation-roadmap.md** - Old roadmap (reference only)
- **18-lfg-warfront-ui.md** - LFG/Warfront UI
- **19-itemization.md** - Item system
  - ⚠️ Heirloom conversion - **NEEDS VERIFICATION** (new design decision)
- **20-aio-ui-basics.md** - AIO UI
- **21-elden-systems.md** - Elden systems
- **22-healing-and-restoration.md** - Healing
- **23-mercenary-healers.md** - Mercenaries
- **24-webportal-mortal-atlas.md** - Web portal
- **25-launcher-mortal-client.md** - Launcher
- **26-gear-visual-mapping.md** - Gear visuals
- **27-gear-stats-and-etl.md** - Gear stats
- **28-mounts-living-system-and-mapping.md** - Mount mapping
  - ✅ Mount breeding deferred (new design decision)
- **29-companion-bond-and-mercenary-system.md** - Companions
  - ⚠️ Vanity pet conversion - **NEEDS VERIFICATION** (new design decision)
- **30-db-migrations-mortal-core.md** - Migrations
- **31-mortal-core-registry.md** - ID registry
- **32-npc-and-encounter-rebalance.md** - NPC rebalance
- **33-instance-and-battleground-tier-mapping.md** - Instance mapping
- **34-mortal-arena-and-rating.md** - Arena
- **35-mortal-pvp-vendors-and-rewards.md** - PvP vendors
- **36-mortal-achievements-and-titles-core.md** - Achievements
- **37-economy-system-extensions.md** - Economy extensions
- **38-social-and-onboarding-systems.md** - Social/onboarding
- **39-navigation-and-wayfinding.md** - Navigation
- **40-anti-bot-rmt-and-security.md** - Security
- **41-telemetry-and-balancing.md** - Telemetry
- **42-gm-tools-and-live-events.md** - GM tools
  - ✅ Holiday conversion exists (new design decision)
- **43-long-term-progression-and-seasons.md** - Seasons
- **44-accessibility-and-ux-guidelines.md** - Accessibility
- **45-eldens-eve-layer.md** - Elden's Eve
- **46-public-grouping-and-contribution.md** - Grouping
- **47-mentoring-and-build-loadouts.md** - Mentoring
- **48-zone-invasions-and-cross-faction-pve.md** - Invasions
- **49-webportal-wiki-spec.md** - Wiki
- **50-lifeskills-fishing-and-first-aid.md** - Life skills

---

### Phase 3: Advanced Features (Specs 51-99)

**Priority**: Medium - Advanced features

- **51-factions-and-standing-system.md** - Factions
- **52-season-of-the-frontier.md** - Seasons
- **53-rune-augments-and-gear-build-system.md** - Runes
- **54-endless-contracts-defense-and-survival.md** - Contracts
- **55-build-presets-and-loadouts.md** - Build presets
- **56-negative-titles-and-notoriety-labels.md** - Titles
- **57-appearance-codex-and-transmog.md** - Transmog
  - ⚠️ Heirloom integration - **NEEDS VERIFICATION** (new design decision)
- **58-world-contracts-and-map-pins.md** - World contracts
- **59-shrine-and-faction-trials.md** - Shrines
- **60-faction-sanctums.md** - Sanctums
- **61-weapon-legacy-and-history.md** - Weapon legacy
- **62-core-lore-and-campaign-skeleton.md** - Lore
- **63-quest-conversion-strategy.md** - Quest conversion
- **64-spell-and-ability-library.md** - Spell library
- **65-endgame-rhythm-and-lockouts.md** - Endgame
- **66-legacy-services-and-qol.md** - Legacy services
- **67-conversion-automation-plan.md** - Automation
- **68-104** - Content packs, campaigns, etc.

---

## Immediate Action Plan

### Step 1: Verify Core Specs (00-15)

For each spec:
1. Check if C++ modules exist
2. Check if they match the spec
3. Check if new design decisions are implemented
4. Document gaps

### Step 2: Implement Missing Pieces

Priority order:
1. **MortalSkillTrainer.cpp/h** - Trainer system (01-progression.md)
2. **MortalGuardAI.cpp/h** - Guard behavior (03-risk-zones.md)
3. **Complete flight path restrictions** - Zone risk checks (03-risk-zones.md)
4. **Complete regional mail** - Zone risk checks (04-economy.md)
5. **Regional tokens system** - Emblem conversion (04-economy.md)
6. **Key access system** - Dungeon keys (06-pve.md)
7. **Northrend cold weather** - Environmental hazard (12-world-simulation.md)
8. **Verify heirloom conversion** - Transmog integration (19-itemization.md, 57-appearance-codex-and-transmog.md)
9. **Verify vanity pet conversion** - Companion system (29-companion-bond-and-mercenary-system.md)

### Step 3: Work Through Remaining Specs

After core is verified, work through specs 16-104 systematically, verifying implementation status.

---

## How to Use This

1. **Start with Phase 1** - Verify core specs (00-15)
2. **Fix gaps** - Implement missing pieces from new design decisions
3. **Move to Phase 2** - Extended systems
4. **Move to Phase 3** - Advanced features

**Don't follow the old roadmap** - it's outdated. Use this systematic spec-by-spec approach instead.

