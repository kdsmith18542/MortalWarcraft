#!/usr/bin/env python3
"""
Update spec documents to require C++ instead of Lua for performance/security critical systems
"""

import re
from pathlib import Path

SPEC_DIR = Path("docs/specs")

# Mapping of Lua files to C++ classes
LUA_TO_CPP = {
    "brace_handler.lua": "MortalBraceMechanic.cpp/h",
    "brace_mechanic.lua": "MortalBraceMechanic.cpp/h",
    "crime_system.lua": "MortalCrimeSystem.cpp/h (or MortalCriminalContracts.cpp/h)",
    "outlaw_state.lua": "MortalOutlawRestrictions.cpp/h",
    "bounty_pot.lua": "MortalBountyPot.cpp/h",
    "bounty_board.lua": "MortalBountyBoard.cpp/h",
    "combat_flag_logic.lua": "MortalCombatFlags.cpp/h",
    "combat_skills.lua": "MortalCombatSkills.cpp/h",
    "gathering_skills.lua": "MortalGatheringSkills.cpp/h",
    "crafting_skill_gain.lua": "MortalCraftingSkills.cpp/h",
    "durability_decay.lua": "MortalDurabilityDecay.cpp/h",
    "encumbrance_system.lua": "MortalEncumbrance.cpp/h",
    "zone_pvp_system.lua": "MortalZonePvP.cpp/h",
    "risk_zone_logic.lua": "MortalRiskZoneLogic.cpp/h",
    "border_grace_window.lua": "MortalBorderGrace.cpp/h",
    "loot_rules.lua": "PvPHooks.cpp/h",
    "yellow_zone_logic.lua": "MortalZonePvP.cpp/h",
    "red_zone_logic.lua": "MortalZonePvP.cpp/h",
    "regional_banking.lua": "MortalRegionalBank.cpp/h",
    "market_stall_logic.lua": "MortalMarketStalls.cpp/h",
    "courier_contracts.lua": "MortalCourierContracts.cpp/h",
    "procedural_crafting.lua": "MortalProceduralCrafting.cpp/h",
    "refining_logic.lua": "MortalRefiningLogic.cpp/h",
    "crafting_workstation.lua": "MortalCraftingWorkstation.cpp/h",
    "material_lore_system.lua": "MortalMaterialLore.cpp/h",
    "item_bond.lua": "MortalItemBond.cpp/h",
    "cursed_loot_system.lua": "MortalCursedLoot.cpp/h",
    "blessed_items.lua": "MortalBlessedItems.cpp/h",
    "fragment_drops.lua": "MortalFragmentDrops.cpp/h",
    "living_mounts.lua": "MortalLivingMounts.cpp/h",
    "mounted_combat.lua": "MortalMountedCombat.cpp/h",
    "stable_system.lua": "MortalStableSystem.cpp/h",
    "mount_repair.lua": "MortalMountRepair.cpp/h",
    "stronghold_system.lua": "MortalStrongholdSystem.cpp/h",
    "guild_territory.lua": "MortalGuildTerritory.cpp/h",
    "siege_window.lua": "MortalSiegeWindow.cpp/h",
    "tcp_capture.lua": "MortalTCPCapture.cpp/h",
    "dynamic_ecosystem.lua": "MortalDynamicEcosystem.cpp/h",
    "migration_controller.lua": "MortalMigrationController.cpp/h",
    "predator_prey.lua": "MortalPredatorPrey.cpp/h",
    "alpha_variant_handler.lua": "MortalAlphaVariant.cpp/h",
    "daynight_modifiers.lua": "MortalDayNight.cpp/h",
    "weather_controller.lua": "MortalWeatherController.cpp/h",
    "delve_instances.lua": "MortalDelveInstances.cpp/h",
    "public_dungeon_ai.lua": "MortalPublicDungeonAI.cpp/h",
    "world_bosses.lua": "MortalWorldBosses.cpp/h",
    "extraction_artifact.lua": "MortalExtractionArtifact.cpp/h",
    "flask_system.lua": "MortalFlask.cpp/h (if implemented)",
    "restoration_magic.lua": "MortalSpellLearning.cpp/h",
    "healing_professions.lua": "MortalFirstAid.cpp/h",
    "caravan_system.lua": "MortalCaravanSystem.cpp/h",
    "caravan_movement.lua": "MortalCaravanMovement.cpp/h",
    "ambush_spawner.lua": "MortalAmbushSpawner.cpp/h",
    "lfg_system.lua": "MortalLFGSystem.cpp/h",
    "task_board_system.lua": "MortalTaskBoard.cpp/h",
    "contract_system.lua": "MortalCourierContracts.cpp/h",
    "anti_zerg.lua": "MortalAntiZerg.cpp/h",
    "hellgate_system.lua": "MortalHellgates.cpp/h",
    "pvp_season.lua": "MortalPvPSeason.cpp/h",
}

def update_spec_file(spec_file, dry_run=True):
    """Update a spec file to use C++ instead of Lua"""
    try:
        with open(spec_file, 'r', encoding='utf-8') as f:
            content = f.read()
        
        original_content = content
        changes = []
        
        # Replace Lua file mentions with C++ equivalents
        for lua_file, cpp_files in LUA_TO_CPP.items():
            # Pattern 1: `filename.lua`
            pattern1 = rf'`{re.escape(lua_file)}`'
            replacement1 = f'`{cpp_files}` (C++ implementation)'
            if re.search(pattern1, content, re.IGNORECASE):
                content = re.sub(pattern1, replacement1, content, flags=re.IGNORECASE)
                changes.append(f"Replaced `{lua_file}` with `{cpp_files}`")
            
            # Pattern 2: filename.lua (without backticks)
            pattern2 = rf'\b{re.escape(lua_file)}\b'
            replacement2 = f'{cpp_files} (C++ implementation)'
            if re.search(pattern2, content, re.IGNORECASE) and lua_file not in content:
                content = re.sub(pattern2, replacement2, content, flags=re.IGNORECASE)
                changes.append(f"Replaced {lua_file} with {cpp_files}")
            
            # Pattern 3: File: filename.lua or file: filename.lua
            pattern3 = rf'(File|file):\s*{re.escape(lua_file)}'
            replacement3 = f'File: {cpp_files} (C++ implementation)'
            if re.search(pattern3, content, re.IGNORECASE):
                content = re.sub(pattern3, replacement3, content, flags=re.IGNORECASE)
                changes.append(f"Replaced File: {lua_file} with File: {cpp_files}")
        
        # Update implementation notes section
        if "## 13. Implementation Notes" in content or "## Implementation" in content:
            # Add note about C++ preference
            note = "\n**Note:** Performance and security-critical systems are implemented in C++ rather than Lua for better performance and security."
            if note not in content:
                impl_section = content.split("## 13. Implementation Notes")[-1] if "## 13. Implementation Notes" in content else ""
                if not impl_section:
                    impl_section = content.split("## Implementation")[-1] if "## Implementation" in content else ""
                
                if impl_section and "C++ rather than Lua" not in content:
                    # Insert note at start of implementation section
                    if "## 13. Implementation Notes" in content:
                        content = content.replace("## 13. Implementation Notes", f"## 13. Implementation Notes{note}\n")
                    elif "## Implementation" in content:
                        content = content.replace("## Implementation", f"## Implementation{note}\n")
                    changes.append("Added C++ preference note")
        
        if content != original_content and changes:
            if not dry_run:
                with open(spec_file, 'w', encoding='utf-8') as f:
                    f.write(content)
                return True, changes
            else:
                return True, changes
        
        return False, []
    
    except Exception as e:
        print(f"Error processing {spec_file}: {e}")
        return False, []

def main():
    """Main update function"""
    import sys
    
    dry_run = "--apply" not in sys.argv
    
    if dry_run:
        print("=" * 80)
        print("DRY RUN - No files will be modified")
        print("Add --apply to actually update files")
        print("=" * 80)
        print()
    
    all_specs = sorted(SPEC_DIR.glob("*.md"))
    updated_count = 0
    total_changes = []
    
    for spec_file in all_specs:
        updated, changes = update_spec_file(spec_file, dry_run=dry_run)
        if updated:
            updated_count += 1
            print(f"{spec_file.name}:")
            for change in changes:
                print(f"  - {change}")
            print()
            total_changes.extend(changes)
    
    print("=" * 80)
    print(f"Summary: {updated_count} specs would be updated with {len(total_changes)} changes")
    if dry_run:
        print("Run with --apply to apply changes")

if __name__ == "__main__":
    main()

