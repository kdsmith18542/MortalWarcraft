# Spec Document Audit and Update Report

**Date:** 2025-01-XX  
**Action:** Updated all specs to require C++ instead of Lua for performance/security critical systems

---

## Summary

- **Specs Audited:** 85
- **Specs Updated:** 21
- **Total Changes:** 67 file requirement updates
- **Status:** ✅ Complete

---

## Changes Applied

### Performance-Critical Systems → C++

All Lua requirements for performance-critical systems have been updated to require C++ implementations:

1. **Combat Systems:**
   - `brace_handler.lua` → `MortalBraceMechanic.cpp/h`
   - `combat_flag_logic.lua` → `MortalCombatFlags.cpp/h`
   - `combat_skills.lua` → `MortalCombatSkills.cpp/h`

2. **Security-Critical Systems:**
   - `crime_system.lua` → `MortalCrimeSystem.cpp/h` (or `MortalCriminalContracts.cpp/h`)
   - `outlaw_state.lua` → `MortalOutlawRestrictions.cpp/h`
   - `bounty_pot.lua` → `MortalBountyPot.cpp/h`
   - `bounty_board.lua` → `MortalBountyBoard.cpp/h`

3. **Economy Systems:**
   - `regional_banking.lua` → `MortalRegionalBank.cpp/h`
   - `market_stall_logic.lua` → `MortalMarketStalls.cpp/h`
   - `courier_contracts.lua` → `MortalCourierContracts.cpp/h`

4. **Crafting Systems:**
   - `durability_decay.lua` → `MortalDurabilityDecay.cpp/h`
   - `refining_logic.lua` → `MortalRefiningLogic.cpp/h`
   - `crafting_workstation.lua` → `MortalCraftingWorkstation.cpp/h`
   - `material_lore_system.lua` → `MortalMaterialLore.cpp/h`

5. **PvP/Zone Systems:**
   - `zone_pvp_system.lua` → `MortalZonePvP.cpp/h`
   - `risk_zone_logic.lua` → `MortalRiskZoneLogic.cpp/h`
   - `loot_rules.lua` → `PvPHooks.cpp/h`

6. **World Simulation:**
   - `dynamic_ecosystem.lua` → `MortalDynamicEcosystem.cpp/h`
   - `migration_controller.lua` → `MortalMigrationController.cpp/h`
   - `weather_controller.lua` → `MortalWeatherController.cpp/h`

7. **Guild Systems:**
   - `stronghold_system.lua` → `MortalStrongholdSystem.cpp/h`
   - `siege_window.lua` → `MortalSiegeWindow.cpp/h`
   - `tcp_capture.lua` → `MortalTCPCapture.cpp/h`

8. **And many more...** (67 total updates)

---

## Consistency Issues Found

### 1. Naming Inconsistencies (7 found)

Some terms have multiple variations across specs:
- **Crimson Phial:** Also referred to as "Crimson Flask", "phial"
- **Runes of Mastery:** Also "mastery runes"
- **Guard Counter:** Also "guardcounter"
- **Notoriety:** Sometimes "reputation"
- **Outlaw:** Sometimes "criminal"

**Recommendation:** Standardize terminology across all specs.

### 2. Duplicate Requirements (91 found)

Many files are mentioned in multiple specs (this is often intentional for cross-referencing):
- `admin_panel.lua` mentioned in 3 specs
- `MortalBraceMechanic.cpp` mentioned in 2 specs
- etc.

**Status:** Most are intentional cross-references. No action needed unless causing confusion.

### 3. Broken Cross-References (81 found)

Some spec references may need updating:
- References to other specs using different formats
- Some may be valid but use different naming

**Recommendation:** Review and fix broken references manually.

---

## Implementation Notes Added

All updated specs now include a note in their implementation sections:

> **Note:** Performance and security-critical systems are implemented in C++ rather than Lua for better performance and security.

---

## Files Updated

The following spec files were updated:

1. `01-progression.md`
2. `02-combat.md`
3. `03-risk-zones.md`
4. `04-economy.md`
5. `05-crafting.md`
6. `06-pve.md`
7. `07-mounts.md`
8. `08-guilds-sovereignty.md`
9. `10-crafting-economy.md`
10. `11-pvp-systems.md`
11. `12-world-simulation.md`
12. `13-caravans-contracts.md`
13. `17-implementation-roadmap.md`
14. `18-lfg-warfront-ui.md`
15. `21-elden-systems.md`
16. `22-healing-and-restoration.md`
17. `28-mounts-living-system-and-mapping.md`
18. `37-economy-system-extensions.md`
19. `68-prologue-and-act1-quest-pack.md`
20. `70-act2-price-of-life-quest-pack.md`
21. `76-dynamic-tasks-and-contracts-2-0-spec.md`

---

## Verification

After updates, the verification script now correctly identifies C++ implementations as valid alternatives to Lua requirements.

**Next Steps:**
1. Review naming inconsistencies and standardize terminology
2. Fix broken cross-references
3. Verify all C++ implementations match the updated spec requirements

---

## Scripts Created

1. `scripts/audit_spec_consistency.py` - Identifies Lua requirements that should be C++
2. `scripts/update_specs_to_cpp.py` - Updates spec files to require C++ instead of Lua
3. `scripts/check_spec_consistency.py` - Checks for consistency issues across all specs

All scripts can be run independently for future audits.

