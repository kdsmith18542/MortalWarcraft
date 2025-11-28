#!/usr/bin/env python3
"""
Spec Document Consistency Audit
- Identifies Lua requirements that should be C++ (performance/security)
- Checks for inconsistencies across specs
- Updates specs to require C++ where appropriate
"""

import os
import re
from pathlib import Path
from collections import defaultdict

SPEC_DIR = Path("docs/specs")

# Lua files that should be C++ due to performance/security
LUA_TO_CPP_MIGRATIONS = {
    # Security-critical
    "crime_system.lua": "MortalCrimeSystem",
    "outlaw_state.lua": "MortalOutlawRestrictions",
    "security_tracking.lua": "MortalSecurityTracking",
    "anti_zerg.lua": "MortalAntiZerg",
    "mod_sandbox_watchdog.lua": "MortalSandboxWatchdog",
    
    # Performance-critical (frequent calls)
    "brace_handler.lua": "MortalBraceMechanic",
    "brace_mechanic.lua": "MortalBraceMechanic",
    "combat_flag_logic.lua": "MortalCombatFlags",
    "durability_decay.lua": "MortalDurabilityDecay",
    "encumbrance_system.lua": "MortalEncumbrance",
    "hunger_system.lua": "MortalSurvivalMechanics",
    "skill_gain.lua": "MortalCombatSkills/MortalGatheringSkills/MortalCraftingSkills",
    "combat_skills.lua": "MortalCombatSkills",
    "gathering_skills.lua": "MortalGatheringSkills",
    "crafting_skill_gain.lua": "MortalCraftingSkills",
    
    # Real-time systems
    "zone_pvp_system.lua": "MortalZonePvP",
    "risk_zone_logic.lua": "MortalRiskZoneLogic",
    "border_grace_window.lua": "MortalBorderGrace",
    "loot_rules.lua": "PvPHooks",
    "yellow_zone_logic.lua": "MortalZonePvP",
    "red_zone_logic.lua": "MortalZonePvP",
    
    # Economy (security)
    "regional_banking.lua": "MortalRegionalBank",
    "market_stall_logic.lua": "MortalMarketStalls",
    "courier_contracts.lua": "MortalCourierContracts",
    "bounty_pot.lua": "MortalBountyPot",
    "bounty_board.lua": "MortalBountyBoard",
    
    # PvP systems (performance)
    "anti_zerg.lua": "MortalAntiZerg",
    "hellgate_system.lua": "MortalHellgates",
    "pvp_season.lua": "MortalPvPSeason",
    
    # Crafting (performance)
    "procedural_crafting.lua": "MortalProceduralCrafting",
    "refining_logic.lua": "MortalRefiningLogic",
    "crafting_workstation.lua": "MortalCraftingWorkstation",
    "material_lore_system.lua": "MortalMaterialLore",
    
    # Item systems (performance)
    "item_bond.lua": "MortalItemBond",
    "cursed_loot_system.lua": "MortalCursedLoot",
    "blessed_items.lua": "MortalBlessedItems",
    "fragment_drops.lua": "MortalFragmentDrops",
    
    # Mount systems (performance)
    "living_mounts.lua": "MortalLivingMounts",
    "mounted_combat.lua": "MortalMountedCombat",
    "stable_system.lua": "MortalStableSystem",
    "mount_repair.lua": "MortalMountRepair",
    
    # Guild systems (security)
    "stronghold_system.lua": "MortalStrongholdSystem",
    "guild_territory.lua": "MortalGuildTerritory",
    "siege_window.lua": "MortalSiegeWindow",
    "tcp_capture.lua": "MortalTCPCapture",
    
    # World simulation (performance)
    "dynamic_ecosystem.lua": "MortalDynamicEcosystem",
    "migration_controller.lua": "MortalMigrationController",
    "predator_prey.lua": "MortalPredatorPrey",
    "alpha_variant_handler.lua": "MortalAlphaVariant",
    "daynight_modifiers.lua": "MortalDayNight",
    "weather_controller.lua": "MortalWeatherController",
    
    # PvE systems (performance)
    "delve_instances.lua": "MortalDelveInstances",
    "public_dungeon_ai.lua": "MortalPublicDungeonAI",
    "world_bosses.lua": "MortalWorldBosses",
    "extraction_artifact.lua": "MortalExtractionArtifact",
    
    # Healing systems (performance)
    "flask_system.lua": "MortalFlask",  # If exists
    "restoration_magic.lua": "MortalSpellLearning",
    "healing_professions.lua": "MortalFirstAid",
    
    # Caravan systems (performance)
    "caravan_system.lua": "MortalCaravanSystem",
    "caravan_movement.lua": "MortalCaravanMovement",
    "ambush_spawner.lua": "MortalAmbushSpawner",
    
    # LFG systems (performance)
    "lfg_system.lua": "MortalLFGSystem",
    
    # Task/Contract systems (performance)
    "task_board_system.lua": "MortalTaskBoard",
    "contract_system.lua": "MortalCourierContracts",
}

# Patterns that indicate performance/security critical
PERFORMANCE_INDICATORS = [
    r'on\s+(every|each|per)\s+(hit|attack|damage|kill|death|update|tick)',
    r'register.*event.*damage',
    r'register.*event.*attack',
    r'register.*event.*death',
    r'register.*event.*update',
    r'periodic|timer|cooldown',
    r'real.?time|real.?time',
    r'frequent|often|always',
]

SECURITY_INDICATORS = [
    r'security|anticheat|anti.?cheat',
    r'validation|verify|check.*permission',
    r'crime|criminal|outlaw|bounty',
    r'economy|bank|gold|currency',
    r'item.*drop|item.*loss|loot',
    r'pvp.*flag|pvp.*state',
]

def find_lua_requirements(spec_file):
    """Find all Lua file requirements in a spec"""
    lua_files = []
    try:
        with open(spec_file, 'r', encoding='utf-8') as f:
            content = f.read()
            
            # Find all Lua file mentions
            patterns = [
                r'`([a-z_]+\.lua)`',
                r'([a-z_]+\.lua)',
                r'file:\s*([a-z_]+\.lua)',
                r'File:\s*([a-z_]+\.lua)',
            ]
            
            for pattern in patterns:
                for match in re.finditer(pattern, content, re.IGNORECASE):
                    lua_file = match.group(1).lower()
                    if lua_file not in lua_files:
                        lua_files.append(lua_file)
    except Exception as e:
        print(f"Error reading {spec_file}: {e}")
    
    return lua_files

def check_performance_critical(spec_file, lua_file):
    """Check if a Lua requirement is performance-critical"""
    try:
        with open(spec_file, 'r', encoding='utf-8') as f:
            content = f.read()
            
            # Check for performance indicators
            for pattern in PERFORMANCE_INDICATORS:
                if re.search(pattern, content, re.IGNORECASE):
                    return True
    except:
        pass
    return False

def check_security_critical(spec_file, lua_file):
    """Check if a Lua requirement is security-critical"""
    try:
        with open(spec_file, 'r', encoding='utf-8') as f:
            content = f.read()
            
            # Check for security indicators
            for pattern in SECURITY_INDICATORS:
                if re.search(pattern, content, re.IGNORECASE):
                    return True
    except:
        pass
    return False

def audit_spec(spec_file):
    """Audit a single spec file"""
    spec_name = spec_file.stem
    issues = []
    recommendations = []
    
    lua_files = find_lua_requirements(spec_file)
    
    for lua_file in lua_files:
        # Check if it's in our migration list
        if lua_file in LUA_TO_CPP_MIGRATIONS:
            cpp_class = LUA_TO_CPP_MIGRATIONS[lua_file]
            issues.append({
                "type": "should_be_cpp",
                "lua_file": lua_file,
                "cpp_class": cpp_class,
                "reason": "Performance/Security critical - in migration list"
            })
            recommendations.append(f"Replace `{lua_file}` with C++ class `{cpp_class}`")
        
        # Check if it's performance-critical
        elif check_performance_critical(spec_file, lua_file):
            issues.append({
                "type": "should_be_cpp",
                "lua_file": lua_file,
                "cpp_class": None,
                "reason": "Performance-critical (frequent calls detected)"
            })
            recommendations.append(f"Consider C++ implementation for `{lua_file}` (performance-critical)")
        
        # Check if it's security-critical
        elif check_security_critical(spec_file, lua_file):
            issues.append({
                "type": "should_be_cpp",
                "lua_file": lua_file,
                "cpp_class": None,
                "reason": "Security-critical"
            })
            recommendations.append(f"Consider C++ implementation for `{lua_file}` (security-critical)")
    
    return {
        "spec_name": spec_name,
        "spec_file": str(spec_file),
        "lua_files": lua_files,
        "issues": issues,
        "recommendations": recommendations
    }

def main():
    """Main audit function"""
    print("=" * 80)
    print("SPEC CONSISTENCY AUDIT")
    print("=" * 80)
    print()
    
    all_specs = sorted(SPEC_DIR.glob("*.md"))
    results = []
    
    for spec_file in all_specs:
        result = audit_spec(spec_file)
        if result["issues"]:
            results.append(result)
    
    # Print summary
    print(f"Audited {len(all_specs)} spec files")
    print(f"Found {len(results)} specs with issues")
    print()
    
    # Print issues
    print("SPECS REQUIRING C++ INSTEAD OF LUA:")
    print("=" * 80)
    
    for result in results:
        print(f"\n{result['spec_name']}:")
        print(f"  File: {result['spec_file']}")
        for issue in result["issues"]:
            print(f"  ⚠️  {issue['lua_file']}")
            print(f"     Reason: {issue['reason']}")
            if issue['cpp_class']:
                print(f"     Should be: {issue['cpp_class']}")
        print()
    
    # Generate update recommendations
    print("\n" + "=" * 80)
    print("UPDATE RECOMMENDATIONS")
    print("=" * 80)
    
    for result in results:
        if result["recommendations"]:
            print(f"\n{result['spec_name']}:")
            for rec in result["recommendations"]:
                print(f"  - {rec}")
    
    return results

if __name__ == "__main__":
    main()

