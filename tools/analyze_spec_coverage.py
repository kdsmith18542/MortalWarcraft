#!/usr/bin/env python3
"""
Spec Coverage Analyzer - Maps spec requirements to implementation status
"""
import os
import re
from pathlib import Path
from collections import defaultdict

SPECS_DIR = '/home/keith/wowpack/docs/specs'
SRC_DIR = '/home/keith/wowpack/azerothcore/modules/mortal_overhaul/src'
ADDON_DIR = '/home/keith/wowpack/addons/MortalUI'

# Critical systems from 94-mortal-season1-launch-scope.md
LAUNCH_CRITICAL = {
    '01-progression.md': {
        'name': 'Dynamic Level System',
        'cpp_files': ['MortalLevel.cpp', 'MortalStats.cpp', 'MortalSkills.cpp'],
        'priority': 'CRITICAL'
    },
    '02-combat.md': {
        'name': 'Basic Combat Loop',
        'cpp_files': ['CombatRewrites.cpp', 'MortalCombat.cpp', 'MortalBraceMechanic.cpp', 'MortalFlask.cpp'],
        'priority': 'CRITICAL'
    },
    '03-risk-zones.md': {
        'name': 'Risk Zones',
        'cpp_files': ['MortalRiskZoneLogic.cpp', 'CriminalFlags.cpp'],
        'priority': 'CRITICAL'
    },
    '04-economy.md': {
        'name': 'Core Economy',
        'cpp_files': ['MortalRegionalBank.cpp', 'MortalMarketStalls.cpp', 'MortalGoldSinks.cpp'],
        'priority': 'CRITICAL'
    },
    '05-crafting.md': {
        'name': 'Crafting',
        'cpp_files': ['MortalCraftingSkills.cpp', 'MortalCraftingQuality.cpp', 'MortalMaterialLore.cpp'],
        'priority': 'CRITICAL'
    },
    '75-mortal-gear-and-runes-spec.md': {
        'name': 'Rune-Based Abilities',
        'cpp_files': ['MortalSpellLibrary.cpp', 'MortalSpellLibraryIntegration.cpp'],
        'priority': 'CRITICAL'
    },
    '92-mortal-warfronts-siege-flow.md': {
        'name': 'Warfronts & Sieges',
        'cpp_files': ['MortalWarfrontEngine.cpp', 'MortalSiegeInfantry.cpp', 'MortalSiegePrepManager.cpp'],
        'priority': 'HIGH'
    },
    '13-caravans-contracts.md': {
        'name': 'Task Boards & Contracts',
        'cpp_files': ['MortalTaskBoard.cpp', 'MortalCourierContracts.cpp'],
        'priority': 'HIGH'
    },
    '08-guilds-sovereignty.md': {
        'name': 'Guild Sovereignty',
        'cpp_files': ['MortalStrongholdSystem.cpp', 'MortalGuildTerritory.cpp', 'MortalGuildTaxation.cpp'],
        'priority': 'HIGH'
    },
    '90-mortal-living-assets-companions.md': {
        'name': 'Living Assets',
        'cpp_files': ['MortalPets.cpp', 'MortalUtilityCompanions.cpp', 'MortalLivingMounts.cpp'],
        'priority': 'HIGH'
    },
    '91-mortal-anomalies-rifts-hellgates.md': {
        'name': 'Anomalies/Rifts/Hellgates',
        'cpp_files': ['MortalAnomalies.cpp', 'MortalRifts.cpp', 'MortalHellgates.cpp'],
        'priority': 'MEDIUM (S1.5)'
    }
}

def count_implementation_lines(filepath):
    """Count lines of actual implementation (excluding empty functions, comments)"""
    try:
        with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
            
        # Remove comments
        content = re.sub(r'//.*', '', content)
        content = re.sub(r'/\*.*?\*/', '', content, flags=re.DOTALL)
        
        # Count non-empty, non-whitespace lines
        lines = [line.strip() for line in content.split('\n')]
        impl_lines = [line for line in lines if line and line not in ['{', '}', '};']]
        
        return len(impl_lines)
    except:
        return 0

def analyze_file_status(filepath):
    """Analyze a file to determine stub status"""
    if not os.path.exists(filepath):
        return 'MISSING', 0, []
    
    try:
        with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
        
        impl_lines = count_implementation_lines(filepath)
        
        # Count stub markers
        todos = len(re.findall(r'//\s*(TODO|FIXME|STUB)', content, re.IGNORECASE))
        empty_funcs = len(re.findall(r'(void|bool|int|uint32_t?)\s+\w+\s*\([^)]*\)\s*{\s*}', content))
        not_impl = len(re.findall(r'(Not implemented|not implemented)', content, re.IGNORECASE))
        
        issues = []
        if todos > 0:
            issues.append(f"{todos} TODO markers")
        if empty_funcs > 0:
            issues.append(f"{empty_funcs} empty functions")
        if not_impl > 0:
            issues.append(f"{not_impl} 'not implemented' markers")
        
        # Determine status
        if impl_lines < 50:
            return 'STUB', impl_lines, issues
        elif empty_funcs > 5 or todos > 10:
            return 'INCOMPLETE', impl_lines, issues
        elif todos > 0 or empty_funcs > 0:
            return 'PARTIAL', impl_lines, issues
        else:
            return 'IMPLEMENTED', impl_lines, issues
            
    except Exception as e:
        return 'ERROR', 0, [str(e)]

def main():
    print("=" * 80)
    print("SPEC COVERAGE ANALYSIS - LAUNCH CRITICAL SYSTEMS")
    print("=" * 80)
    print()
    
    results = {}
    
    for spec_file, spec_info in LAUNCH_CRITICAL.items():
        print(f"\n{'=' * 80}")
        print(f"SPEC: {spec_file}")
        print(f"SYSTEM: {spec_info['name']}")
        print(f"PRIORITY: {spec_info['priority']}")
        print(f"{'=' * 80}")
        
        file_results = []
        total_impl_lines = 0
        
        for cpp_file in spec_info['cpp_files']:
            filepath = os.path.join(SRC_DIR, cpp_file)
            status, lines, issues = analyze_file_status(filepath)
            total_impl_lines += lines
            
            file_results.append({
                'file': cpp_file,
                'status': status,
                'lines': lines,
                'issues': issues
            })
            
            status_icon = {
                'MISSING': '❌',
                'STUB': '🔴',
                'INCOMPLETE': '🟡',
                'PARTIAL': '🟠',
                'IMPLEMENTED': '✅',
                'ERROR': '⚠️'
            }.get(status, '❓')
            
            print(f"\n  {status_icon} {cpp_file}")
            print(f"     Status: {status}")
            print(f"     Implementation Lines: {lines}")
            if issues:
                for issue in issues:
                    print(f"     - {issue}")
        
        # Overall system status
        statuses = [r['status'] for r in file_results]
        if all(s == 'IMPLEMENTED' for s in statuses):
            system_status = '✅ COMPLETE'
        elif any(s in ['MISSING', 'STUB'] for s in statuses):
            system_status = '🔴 CRITICAL GAPS'
        elif any(s == 'INCOMPLETE' for s in statuses):
            system_status = '🟡 MAJOR GAPS'
        else:
            system_status = '🟠 MINOR GAPS'
        
        print(f"\n  Overall System Status: {system_status}")
        print(f"  Total Implementation Lines: {total_impl_lines}")
        
        results[spec_info['name']] = {
            'status': system_status,
            'priority': spec_info['priority'],
            'files': file_results,
            'total_lines': total_impl_lines
        }
    
    # Summary
    print("\n\n" + "=" * 80)
    print("SUMMARY - LAUNCH READINESS")
    print("=" * 80)
    
    critical_ready = 0
    critical_total = 0
    
    for system_name, data in results.items():
        if data['priority'] == 'CRITICAL':
            critical_total += 1
            if data['status'] == '✅ COMPLETE':
                critical_ready += 1
        
        print(f"\n{data['status']} {system_name} ({data['priority']})")
        print(f"   {data['total_lines']} implementation lines")
        for file_data in data['files']:
            if file_data['status'] in ['MISSING', 'STUB', 'INCOMPLETE']:
                print(f"   ⚠️  {file_data['file']}: {file_data['status']}")
    
    print(f"\n{'=' * 80}")
    print(f"CRITICAL SYSTEMS READY: {critical_ready}/{critical_total}")
    if critical_ready == critical_total:
        print("✅ ALL CRITICAL SYSTEMS IMPLEMENTED")
    else:
        print(f"🔴 {critical_total - critical_ready} CRITICAL SYSTEMS NEED WORK")
    print("=" * 80)

if __name__ == '__main__':
    main()

