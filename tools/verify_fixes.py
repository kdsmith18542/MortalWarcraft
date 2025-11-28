#!/usr/bin/env python3
"""
Mortal Warcraft - Fix Verification Tool

Verifies our fixes against reference script sources (TrinityCore, CMaNGOS)
to ensure NPC IDs, script patterns, and implementations are correct.

Usage:
    python3 verify_fixes.py --fix 15629  # Verify crate RP events
    python3 verify_fixes.py --all        # Verify all Culling of Stratholme fixes
    python3 verify_fixes.py --list       # List all verifiable fixes
"""

import argparse
import re
from pathlib import Path
from collections import defaultdict

# Reference script paths
REFERENCE_PATH = Path("tools/reference")
TRINITYCORE_SCRIPTS = REFERENCE_PATH / "trinitycore-scripts" / "src" / "server" / "scripts"
CMANGOS_SCRIPTS = REFERENCE_PATH / "cmangos-wotlk" / "src" / "game" / "AI" / "ScriptDevAI" / "scripts"

# Our code paths
OUR_SCRIPTS = Path("realm2/azerothcore/src/server/scripts")
OUR_SQL = Path("realm2/azerothcore/data/sql/updates/db_world")

def extract_npc_ids_from_file(filepath):
    """Extract all NPC_ID = number patterns from a file."""
    npc_ids = {}
    try:
        with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
            # Pattern: NPC_NAME = number,
            pattern = r'NPC_(\w+)\s*=\s*(\d+),'
            matches = re.finditer(pattern, content)
            for match in matches:
                npc_name = match.group(1)
                npc_id = int(match.group(2))
                npc_ids[f"NPC_{npc_name}"] = npc_id
    except Exception as e:
        pass
    return npc_ids

def extract_npc_ids_from_sql(filepath):
    """Extract NPC IDs from SQL files (creature_text, smart_scripts, etc.)."""
    npc_ids = set()
    try:
        with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
            # Pattern: INSERT INTO creature_text (CreatureID, ...) VALUES (ID, ...
            pattern = r'\((\d+),\s*0,'
            matches = re.finditer(pattern, content)
            for match in matches:
                npc_id = int(match.group(1))
                npc_ids.add(npc_id)
            # Pattern: entryorguid = ID in smart_scripts
            pattern = r'entryorguid.*?(\d+)'
            matches = re.finditer(pattern, content, re.IGNORECASE)
            for match in matches:
                npc_id = int(match.group(1))
                npc_ids.add(npc_id)
    except Exception:
        pass
    return npc_ids

def get_reference_npc_ids(dungeon_name="culling"):
    """Get all NPC IDs from reference scripts for a dungeon."""
    results = {
        'trinitycore': {},
        'cmangos': {}
    }
    
    # Search TrinityCore
    if TRINITYCORE_SCRIPTS.exists():
        for script_file in TRINITYCORE_SCRIPTS.rglob("*"):
            if script_file.is_file() and dungeon_name.lower() in script_file.name.lower():
                if script_file.suffix in ['.h', '.cpp']:
                    npc_ids = extract_npc_ids_from_file(script_file)
                    if npc_ids:
                        results['trinitycore'].update(npc_ids)
    
    # Search CMaNGOS
    if CMANGOS_SCRIPTS.exists():
        for script_file in CMANGOS_SCRIPTS.rglob("*"):
            if script_file.is_file() and dungeon_name.lower() in script_file.name.lower():
                if script_file.suffix in ['.h', '.cpp']:
                    npc_ids = extract_npc_ids_from_file(script_file)
                    if npc_ids:
                        results['cmangos'].update(npc_ids)
    
    return results

def get_our_npc_ids(dungeon_name="culling"):
    """Get NPC IDs from our code and SQL files."""
    results = {
        'code': {},
        'sql': set()
    }
    
    # Search our C++ code
    if OUR_SCRIPTS.exists():
        for script_file in OUR_SCRIPTS.rglob("*"):
            if script_file.is_file() and dungeon_name.lower() in script_file.name.lower():
                if script_file.suffix in ['.h', '.cpp']:
                    npc_ids = extract_npc_ids_from_file(script_file)
                    if npc_ids:
                        results['code'].update(npc_ids)
    
    # Search our SQL files
    if OUR_SQL.exists():
        for sql_file in OUR_SQL.rglob("*culling*.sql"):
            npc_ids = extract_npc_ids_from_sql(sql_file)
            results['sql'].update(npc_ids)
        for sql_file in OUR_SQL.rglob("*cos*.sql"):
            npc_ids = extract_npc_ids_from_sql(sql_file)
            results['sql'].update(npc_ids)
    
    return results

def verify_npc_ids(our_ids, ref_ids, fix_name):
    """Verify NPC IDs match between our code and reference sources."""
    print(f"\n{'='*80}")
    print(f"Verifying NPC IDs for: {fix_name}")
    print(f"{'='*80}")
    
    # Convert our code NPC IDs to a set of IDs
    our_id_set = set(our_ids['code'].values())
    our_id_set.update(our_ids['sql'])
    
    # Get reference IDs
    ref_tc_ids = set(ref_ids['trinitycore'].values())
    ref_cm_ids = set(ref_ids['cmangos'].values())
    ref_all_ids = ref_tc_ids | ref_cm_ids
    
    # Find matches
    matches = our_id_set & ref_all_ids
    our_only = our_id_set - ref_all_ids
    ref_only = ref_all_ids - our_id_set
    
    print(f"\n✅ Matches: {len(matches)} NPC IDs found in both our code and references")
    if matches:
        print("   Matched IDs:")
        for npc_id in sorted(matches):
            # Find names
            our_name = [name for name, id in our_ids['code'].items() if id == npc_id]
            tc_name = [name for name, id in ref_ids['trinitycore'].items() if id == npc_id]
            cm_name = [name for name, id in ref_ids['cmangos'].items() if id == npc_id]
            
            names = []
            if our_name:
                names.append(f"Our: {our_name[0]}")
            if tc_name:
                names.append(f"TC: {tc_name[0]}")
            if cm_name:
                names.append(f"CM: {cm_name[0]}")
            
            print(f"     {npc_id}: {', '.join(names)}")
    
    if our_only:
        print(f"\n⚠️  Our Only: {len(our_only)} NPC IDs in our code but not in references")
        print("   (These might be correct but not in reference scripts)")
        for npc_id in sorted(our_only):
            our_name = [name for name, id in our_ids['code'].items() if id == npc_id]
            print(f"     {npc_id}: {our_name[0] if our_name else 'Unknown'}")
    
    if ref_only:
        print(f"\n📋 Reference Only: {len(ref_only)} NPC IDs in references but not in our code")
        print("   (These might be NPCs we should consider adding)")
        for npc_id in sorted(ref_only)[:10]:  # Limit to 10
            tc_name = [name for name, id in ref_ids['trinitycore'].items() if id == npc_id]
            cm_name = [name for name, id in ref_ids['cmangos'].items() if id == npc_id]
            names = []
            if tc_name:
                names.append(f"TC: {tc_name[0]}")
            if cm_name:
                names.append(f"CM: {cm_name[0]}")
            print(f"     {npc_id}: {', '.join(names) if names else 'Unknown'}")
        if len(ref_only) > 10:
            print(f"     ... and {len(ref_only) - 10} more")
    
    return {
        'matches': len(matches),
        'our_only': len(our_only),
        'ref_only': len(ref_only),
        'match_ids': matches,
        'our_only_ids': our_only,
        'ref_only_ids': ref_only
    }

def verify_crate_rp_events():
    """Verify crate RP event NPC IDs."""
    print("\n" + "="*80)
    print("Verifying: Crate RP Events (#15629)")
    print("="*80)
    
    # Expected NPC IDs from our fix
    expected_npcs = {
        27903: "Roger Owens",
        27877: "Sergeant Morigan",
        27885: "Jena Anderson",
        27891: "Malcolm Moore",
        27892: "Scruffy",
        27907: "Bartleby Battson",
        27913: "Lordaeron Crier"
    }
    
    # Get reference NPC IDs
    ref_ids = get_reference_npc_ids("culling")
    
    # Get our NPC IDs
    our_ids = get_our_npc_ids("culling")
    
    print("\nExpected NPC IDs:")
    for npc_id, name in expected_npcs.items():
        in_tc = npc_id in set(ref_ids['trinitycore'].values())
        in_cm = npc_id in set(ref_ids['cmangos'].values())
        in_our_code = npc_id in set(our_ids['code'].values())
        in_our_sql = npc_id in our_ids['sql']
        
        status = []
        if in_tc:
            status.append("TC")
        if in_cm:
            status.append("CM")
        if in_our_code:
            status.append("Code")
        if in_our_sql:
            status.append("SQL")
        
        status_str = ", ".join(status) if status else "NOT FOUND"
        symbol = "✅" if (in_tc or in_cm) and (in_our_code or in_our_sql) else "❌"
        print(f"  {symbol} {npc_id}: {name} - {status_str}")
    
    return verify_npc_ids(our_ids, ref_ids, "Crate RP Events (#15629)")

def verify_npc_behavior_fixes():
    """Verify NPC behavior fix NPC IDs."""
    print("\n" + "="*80)
    print("Verifying: NPC Behavior Fixes (#15621, #15620, #15623)")
    print("="*80)
    
    # Expected NPC IDs
    expected_npcs = {
        31023: "Brandon Eiredeck",
        31028: "Patricia O'Reilly",
        31019: "Stephanie Sindree",
        30994: "Magistrate Barthilas",
        31126: "Agitated Stratholme Citizen",
        31127: "Agitated Stratholme Resident"
    }
    
    # Get reference NPC IDs
    ref_ids = get_reference_npc_ids("culling")
    
    # Get our NPC IDs
    our_ids = get_our_npc_ids("culling")
    
    print("\nExpected NPC IDs:")
    for npc_id, name in expected_npcs.items():
        in_tc = npc_id in set(ref_ids['trinitycore'].values())
        in_cm = npc_id in set(ref_ids['cmangos'].values())
        in_our_code = npc_id in set(our_ids['code'].values())
        in_our_sql = npc_id in our_ids['sql']
        
        status = []
        if in_tc:
            status.append("TC")
        if in_cm:
            status.append("CM")
        if in_our_code:
            status.append("Code")
        if in_our_sql:
            status.append("SQL")
        
        status_str = ", ".join(status) if status else "NOT FOUND"
        symbol = "✅" if (in_tc or in_cm) and (in_our_code or in_our_sql) else "❌"
        print(f"  {symbol} {npc_id}: {name} - {status_str}")
    
    return verify_npc_ids(our_ids, ref_ids, "NPC Behavior Fixes (#15621, #15620, #15623)")

def verify_all_culling_fixes():
    """Verify all Culling of Stratholme fixes."""
    print("\n" + "="*80)
    print("Verifying: All Culling of Stratholme Fixes")
    print("="*80)
    
    # Get all reference NPC IDs
    ref_ids = get_reference_npc_ids("culling")
    
    # Get all our NPC IDs
    our_ids = get_our_npc_ids("culling")
    
    print(f"\nReference Scripts:")
    print(f"  TrinityCore: {len(ref_ids['trinitycore'])} NPC IDs found")
    print(f"  CMaNGOS: {len(ref_ids['cmangos'])} NPC IDs found")
    
    print(f"\nOur Code:")
    print(f"  C++ Code: {len(our_ids['code'])} NPC IDs found")
    print(f"  SQL Files: {len(our_ids['sql'])} NPC IDs found")
    
    # Run individual verifications
    verify_crate_rp_events()
    verify_npc_behavior_fixes()
    
    # Overall verification
    return verify_npc_ids(our_ids, ref_ids, "All Culling of Stratholme Fixes")

def list_verifiable_fixes():
    """List all fixes that can be verified."""
    fixes = [
        ("#15629", "Crate RP Events", "verify_crate_rp_events"),
        ("#15621, #15620, #15623", "NPC Behavior Fixes", "verify_npc_behavior_fixes"),
        ("All", "All Culling of Stratholme Fixes", "verify_all_culling_fixes"),
    ]
    
    print("\n" + "="*80)
    print("Verifiable Fixes")
    print("="*80)
    for issue, name, func in fixes:
        print(f"\n{issue}: {name}")
        print(f"  Function: {func}()")

def main():
    parser = argparse.ArgumentParser(description='Verify fixes against reference scripts')
    parser.add_argument('--fix', type=str, help='Fix number to verify (e.g., 15629, 15621)')
    parser.add_argument('--all', action='store_true', help='Verify all Culling of Stratholme fixes')
    parser.add_argument('--list', action='store_true', help='List all verifiable fixes')
    
    args = parser.parse_args()
    
    if args.list:
        list_verifiable_fixes()
        return 0
    
    if args.all:
        verify_all_culling_fixes()
        return 0
    
    if args.fix:
        fix_num = args.fix
        if fix_num == "15629":
            verify_crate_rp_events()
        elif fix_num in ["15621", "15620", "15623"]:
            verify_npc_behavior_fixes()
        else:
            print(f"Unknown fix number: {fix_num}")
            print("Use --list to see available fixes")
            return 1
        return 0
    
    # Default: verify all
    verify_all_culling_fixes()
    return 0

if __name__ == '__main__':
    exit(main())

