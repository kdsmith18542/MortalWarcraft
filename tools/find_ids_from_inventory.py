#!/usr/bin/env python3
"""
Mortal Warcraft - Find IDs from Feature Inventory

Extracts feature names from the populated feature inventory and uses
the DBC ID finder script to find IDs, models, and display IDs.

Usage:
    python3 find_ids_from_inventory.py --category zones
    python3 find_ids_from_inventory.py --category dungeons
    python3 find_ids_from_inventory.py --category creatures --name "Kazzak"
    python3 find_ids_from_inventory.py --all --output ids_mapping.json
"""

import argparse
import re
import json
import subprocess
from pathlib import Path
from typing import List, Dict, Optional

# Paths
INVENTORY_FILE = Path("docs/wow-3.3.5a-feature-inventory-populated.md")
DBC_FINDER_SCRIPT = Path("tools/find_dbc_ids.py")

def extract_zones_from_inventory() -> List[str]:
    """Extract zone names from the feature inventory."""
    zones = []
    
    if not INVENTORY_FILE.exists():
        print(f"Error: {INVENTORY_FILE} not found")
        return zones
    
    with open(INVENTORY_FILE, 'r', encoding='utf-8') as f:
        content = f.read()
        
        # Extract zones from Eastern Kingdoms table
        ek_match = re.search(r'### Eastern Kingdoms.*?\n\n\|.*?\n(.*?)\n\n###', content, re.DOTALL)
        if ek_match:
            table_content = ek_match.group(1)
            # Match zone names from table rows
            zone_matches = re.findall(r'\| ([^|]+) \|', table_content)
            zones.extend([z.strip() for z in zone_matches if z.strip() and z.strip() != 'Zone'])
        
        # Extract zones from Kalimdor table
        kalimdor_match = re.search(r'### Kalimdor.*?\n\n\|.*?\n(.*?)\n\n###', content, re.DOTALL)
        if kalimdor_match:
            table_content = kalimdor_match.group(1)
            zone_matches = re.findall(r'\| ([^|]+) \|', table_content)
            zones.extend([z.strip() for z in zone_matches if z.strip() and z.strip() != 'Zone'])
        
        # Extract zones from Outland table
        outland_match = re.search(r'### Outland.*?\n\n\|.*?\n(.*?)\n\n###', content, re.DOTALL)
        if outland_match:
            table_content = outland_match.group(1)
            zone_matches = re.findall(r'\| ([^|]+) \|', table_content)
            zones.extend([z.strip() for z in zone_matches if z.strip() and z.strip() != 'Zone'])
        
        # Extract zones from Northrend table
        northrend_match = re.search(r'### Northrend.*?\n\n\|.*?\n(.*?)\n\n###', content, re.DOTALL)
        if northrend_match:
            table_content = northrend_match.group(1)
            zone_matches = re.findall(r'\| ([^|]+) \|', table_content)
            zones.extend([z.strip() for z in zone_matches if z.strip() and z.strip() != 'Zone'])
    
    # Remove duplicates and empty strings
    zones = list(set([z for z in zones if z and z != '...']))
    return sorted(zones)

def extract_dungeons_from_inventory() -> List[str]:
    """Extract dungeon names from the feature inventory."""
    dungeons = []
    
    if not INVENTORY_FILE.exists():
        return dungeons
    
    with open(INVENTORY_FILE, 'r', encoding='utf-8') as f:
        content = f.read()
        
        # Extract from Classic 5-Man Dungeons table
        classic_match = re.search(r'### Classic 5-Man Dungeons.*?\n\n\|.*?\n(.*?)\n\n###', content, re.DOTALL)
        if classic_match:
            table_content = classic_match.group(1)
            dungeon_matches = re.findall(r'\| ([^|]+) \|', table_content)
            dungeons.extend([d.strip() for d in dungeon_matches if d.strip() and d.strip() != 'Dungeon'])
        
        # Extract from TBC 5-Man Dungeons table
        tbc_match = re.search(r'### TBC 5-Man Dungeons.*?\n\n\|.*?\n(.*?)\n\n###', content, re.DOTALL)
        if tbc_match:
            table_content = tbc_match.group(1)
            dungeon_matches = re.findall(r'\| ([^|]+) \|', table_content)
            dungeons.extend([d.strip() for d in dungeon_matches if d.strip() and d.strip() != 'Dungeon'])
        
        # Extract from WotLK 5-Man Dungeons table
        wotlk_match = re.search(r'### WotLK 5-Man Dungeons.*?\n\n\|.*?\n(.*?)\n\n###', content, re.DOTALL)
        if wotlk_match:
            table_content = wotlk_match.group(1)
            dungeon_matches = re.findall(r'\| ([^|]+) \|', table_content)
            dungeons.extend([d.strip() for d in dungeon_matches if d.strip() and d.strip() != 'Dungeon'])
    
    dungeons = list(set([d for d in dungeons if d and d != '...']))
    return sorted(dungeons)

def extract_raids_from_inventory() -> List[str]:
    """Extract raid names from the feature inventory."""
    raids = []
    
    if not INVENTORY_FILE.exists():
        return raids
    
    with open(INVENTORY_FILE, 'r', encoding='utf-8') as f:
        content = f.read()
        
        # Extract from Classic Raids table
        classic_match = re.search(r'### Classic Raids.*?\n\n\|.*?\n(.*?)\n\n###', content, re.DOTALL)
        if classic_match:
            table_content = classic_match.group(1)
            raid_matches = re.findall(r'\| ([^|]+) \|', table_content)
            raids.extend([r.strip() for r in raid_matches if r.strip() and r.strip() != 'Raid'])
        
        # Extract from TBC Raids table
        tbc_match = re.search(r'### TBC Raids.*?\n\n\|.*?\n(.*?)\n\n###', content, re.DOTALL)
        if tbc_match:
            table_content = tbc_match.group(1)
            raid_matches = re.findall(r'\| ([^|]+) \|', table_content)
            raids.extend([r.strip() for r in raid_matches if r.strip() and r.strip() != 'Raid'])
        
        # Extract from WotLK Raids table
        wotlk_match = re.search(r'### WotLK Raids.*?\n\n\|.*?\n(.*?)\n\n###', content, re.DOTALL)
        if wotlk_match:
            table_content = wotlk_match.group(1)
            raid_matches = re.findall(r'\| ([^|]+) \|', table_content)
            raids.extend([r.strip() for r in raid_matches if r.strip() and r.strip() != 'Raid'])
    
    raids = list(set([r for r in raids if r and r != '...']))
    return sorted(raids)

def extract_world_bosses_from_inventory() -> List[str]:
    """Extract world boss names from the feature inventory."""
    bosses = []
    
    if not INVENTORY_FILE.exists():
        return bosses
    
    with open(INVENTORY_FILE, 'r', encoding='utf-8') as f:
        content = f.read()
        
        # Extract from World Bosses table
        boss_match = re.search(r'### World Bosses.*?\n\n\|.*?\n(.*?)\n\n\*\*Gap', content, re.DOTALL)
        if boss_match:
            table_content = boss_match.group(1)
            boss_matches = re.findall(r'\| ([^|]+) \|', table_content)
            bosses.extend([b.strip() for b in boss_matches if b.strip() and b.strip() != 'Boss'])
    
    bosses = list(set([b for b in bosses if b and b != '...']))
    return sorted(bosses)

def call_dbc_finder(feature_type: str, name: str) -> Optional[Dict]:
    """Call the DBC ID finder script and return results."""
    if not DBC_FINDER_SCRIPT.exists():
        print(f"Error: {DBC_FINDER_SCRIPT} not found")
        return None
    
    try:
        result = subprocess.run(
            ['python3', str(DBC_FINDER_SCRIPT), '--type', feature_type, '--name', name],
            capture_output=True,
            text=True,
            timeout=30
        )
        
        if result.returncode == 0:
            return {
                'success': True,
                'output': result.stdout,
                'error': result.stderr
            }
        else:
            return {
                'success': False,
                'output': result.stdout,
                'error': result.stderr
            }
    except subprocess.TimeoutExpired:
        return {'success': False, 'error': 'Timeout'}
    except Exception as e:
        return {'success': False, 'error': str(e)}

def find_ids_for_features(features: List[str], feature_type: str) -> Dict[str, Dict]:
    """Find IDs for a list of features."""
    results = {}
    
    for feature in features:
        print(f"Searching for {feature_type}: {feature}...")
        result = call_dbc_finder(feature_type, feature)
        if result:
            results[feature] = result
        else:
            results[feature] = {'success': False, 'error': 'No result'}
    
    return results

def main():
    parser = argparse.ArgumentParser(
        description='Find DBC IDs for features from the populated inventory'
    )
    parser.add_argument(
        '--category',
        choices=['zones', 'dungeons', 'raids', 'world-bosses', 'creatures', 'items'],
        help='Category of features to process'
    )
    parser.add_argument(
        '--name',
        help='Specific feature name to search for'
    )
    parser.add_argument(
        '--all',
        action='store_true',
        help='Process all categories'
    )
    parser.add_argument(
        '--output',
        help='Output file for results (JSON format)'
    )
    parser.add_argument(
        '--list',
        action='store_true',
        help='List features in category without searching'
    )
    
    args = parser.parse_args()
    
    results = {}
    
    if args.list:
        if args.category == 'zones':
            zones = extract_zones_from_inventory()
            print(f"Found {len(zones)} zones:")
            for zone in zones:
                print(f"  - {zone}")
        elif args.category == 'dungeons':
            dungeons = extract_dungeons_from_inventory()
            print(f"Found {len(dungeons)} dungeons:")
            for dungeon in dungeons:
                print(f"  - {dungeon}")
        elif args.category == 'raids':
            raids = extract_raids_from_inventory()
            print(f"Found {len(raids)} raids:")
            for raid in raids:
                print(f"  - {raid}")
        elif args.category == 'world-bosses':
            bosses = extract_world_bosses_from_inventory()
            print(f"Found {len(bosses)} world bosses:")
            for boss in bosses:
                print(f"  - {boss}")
        return 0
    
    if args.name:
        # Search for specific feature
        if args.category == 'creatures':
            result = call_dbc_finder('creature', args.name)
            if result:
                print(result['output'])
        elif args.category == 'items':
            result = call_dbc_finder('item', args.name)
            if result:
                print(result['output'])
        return 0
    
    if args.all or args.category:
        if args.category == 'zones' or args.all:
            zones = extract_zones_from_inventory()
            print(f"Processing {len(zones)} zones...")
            # Note: Zones need database queries, not DBC finder
            results['zones'] = {'features': zones, 'note': 'Use database queries for zone IDs'}
        
        if args.category == 'dungeons' or args.all:
            dungeons = extract_dungeons_from_inventory()
            print(f"Processing {len(dungeons)} dungeons...")
            # Note: Dungeons need database queries, not DBC finder
            results['dungeons'] = {'features': dungeons, 'note': 'Use database queries for instance IDs'}
        
        if args.category == 'raids' or args.all:
            raids = extract_raids_from_inventory()
            print(f"Processing {len(raids)} raids...")
            # Note: Raids need database queries, not DBC finder
            results['raids'] = {'features': raids, 'note': 'Use database queries for instance IDs'}
        
        if args.category == 'world-bosses' or args.all:
            bosses = extract_world_bosses_from_inventory()
            print(f"Processing {len(bosses)} world bosses...")
            # Search for creatures
            boss_results = find_ids_for_features(bosses, 'creature')
            results['world_bosses'] = boss_results
    
    if args.output:
        with open(args.output, 'w', encoding='utf-8') as f:
            json.dump(results, f, indent=2)
        print(f"Results saved to {args.output}")
    else:
        print(json.dumps(results, indent=2))
    
    return 0

if __name__ == '__main__':
    exit(main())

