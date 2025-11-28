#!/usr/bin/env python3
"""
Mortal Warcraft - Issue Investigation Tool

Investigates specific AzerothCore issues using:
1. DBC files (Spell.dbc, etc.)
2. Database queries (spell_template, creature, etc.)
3. Online sources (Wowhead API, web scraping)

Usage:
    python3 investigate_issues.py --issue 16905  # Druid Berserk
    python3 investigate_issues.py --issue 23830    # Culling of Stratholme
"""

import argparse
import struct
import os
import sys
import subprocess
import json
from pathlib import Path
from urllib.request import urlopen
from urllib.parse import quote

# DBC file paths
DBC_PATH = Path("azerothcore/data/dbc")

# Reference script paths
REFERENCE_PATH = Path("tools/reference")
TRINITYCORE_SCRIPTS = REFERENCE_PATH / "trinitycore-scripts" / "src" / "server" / "scripts"
CMANGOS_SCRIPTS = REFERENCE_PATH / "cmangos-wotlk" / "src" / "game" / "AI" / "ScriptDevAI" / "scripts"

def read_dbc_header(filepath):
    """Read DBC file header."""
    with open(filepath, 'rb') as f:
        header = f.read(20)
        if len(header) < 20:
            return None
        
        signature = header[0:4]
        if signature != b'WDBC':
            return None
        
        record_count = struct.unpack('<I', header[4:8])[0]
        field_count = struct.unpack('<I', header[8:12])[0]
        record_size = struct.unpack('<I', header[12:16])[0]
        string_block_size = struct.unpack('<I', header[16:20])[0]
        
        return {
            'record_count': record_count,
            'field_count': field_count,
            'record_size': record_size,
            'string_block_size': string_block_size
        }

def read_spell_dbc(spell_id):
    """Read Spell.dbc to get spell information."""
    spell_dbc = DBC_PATH / "Spell.dbc"
    if not spell_dbc.exists():
        print(f"Error: {spell_dbc} not found")
        return None
    
    header = read_dbc_header(spell_dbc)
    if not header:
        print("Error: Invalid DBC file")
        return None
    
    # Spell.dbc structure (WotLK 3.3.5a)
    # Field 0: ID
    # Field 1: Category
    # Field 2: CastingTimeIndex
    # Field 3: DurationIndex
    # Field 4: RangeIndex
    # Field 5: Speed
    # Field 6: SpellVisualID
    # Field 7: SpellIconID
    # Field 8: ActiveIconID
    # Field 9: Name (string offset)
    # Field 10: NameSubtext (string offset)
    # Field 11: Description (string offset)
    # Field 12: AuraDescription (string offset)
    # Field 13: ManaCost
    # Field 14: ManaCostPerLevel
    # Field 15: ManaPerSecond
    # Field 16: ManaPerSecondPerLevel
    # Field 17: PowerType (0=Mana, 1=Rage, 3=Energy, etc.)
    # Field 18: PowerCost
    # Field 19: PowerCostPerLevel
    # Field 20: PowerPerSecond
    # Field 21: PowerPerSecondPerLevel
    # ... many more fields
    
    with open(spell_dbc, 'rb') as f:
        f.seek(20)  # Skip header
        record_size = header['record_size']
        
        # Find spell by ID
        for i in range(header['record_count']):
            pos = 20 + (i * record_size)
            f.seek(pos)
            record_id = struct.unpack('<I', f.read(4))[0]
            
            if record_id == spell_id:
                # Read key fields
                f.seek(pos)
                data = f.read(record_size)
                
                # Parse important fields (offsets may vary by DBC version)
                power_type = struct.unpack('<I', data[68:72])[0] if len(data) > 72 else 0  # Field 17
                power_cost = struct.unpack('<I', data[72:76])[0] if len(data) > 76 else 0  # Field 18
                power_per_second = struct.unpack('<I', data[80:84])[0] if len(data) > 84 else 0  # Field 20
                
                # Read string block for name
                string_block_offset = 20 + (header['record_count'] * record_size)
                name_offset = struct.unpack('<I', data[36:40])[0] if len(data) > 40 else 0  # Field 9
                
                f.seek(string_block_offset + name_offset)
                name = b''
                while True:
                    byte = f.read(1)
                    if byte == b'\x00' or not byte:
                        break
                    name += byte
                
                return {
                    'id': spell_id,
                    'name': name.decode('utf-8', errors='ignore'),
                    'power_type': power_type,
                    'power_cost': power_cost,
                    'power_per_second': power_per_second
                }
    
    return None

def query_spell_database(spell_id, db_config):
    """Query spell_template table for spell information."""
    # Build mysql command with proper password handling
    cmd = ['mysql']
    cmd.extend([f'-h{db_config["host"]}'])
    cmd.extend([f'-P{str(db_config["port"])}'])
    cmd.extend([f'-u{db_config["user"]}'])
    if db_config["password"]:
        cmd.extend([f'-p{db_config["password"]}'])
    cmd.append(db_config["database"])
    cmd.extend(['-B', '-N', '-e'])
    cmd.append(f"SELECT entry, name, powerType, powerCost, powerCostPercentage, powerPerSecond, "
                f"Effect1, Effect2, Effect3, EffectItemType1, EffectItemType2, EffectItemType3 "
                f"FROM spell_template WHERE entry = {spell_id} LIMIT 1")
    
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, check=True)
        if result.stdout.strip():
            parts = result.stdout.strip().split('\t')
            if len(parts) >= 12:
                return {
                    'entry': int(parts[0]),
                    'name': parts[1],
                    'powerType': int(parts[2]) if parts[2].isdigit() else 0,
                    'powerCost': int(parts[3]) if parts[3].isdigit() else 0,
                    'powerCostPercentage': int(parts[4]) if parts[4].isdigit() else 0,
                    'powerPerSecond': int(parts[5]) if parts[5].isdigit() else 0,
                    'effect1': int(parts[6]) if parts[6].isdigit() else 0,
                    'effect2': int(parts[7]) if parts[7].isdigit() else 0,
                    'effect3': int(parts[8]) if parts[8].isdigit() else 0,
                    'effectItemType1': int(parts[9]) if parts[9].isdigit() else 0,
                    'effectItemType2': int(parts[10]) if parts[10].isdigit() else 0,
                    'effectItemType3': int(parts[11]) if parts[11].isdigit() else 0,
                }
    except (subprocess.CalledProcessError, FileNotFoundError, ValueError) as e:
        print(f"Database query error: {e}")
    
    return None

def query_creature_spawns(instance_id, db_config):
    """Query creature spawns in an instance."""
    # Culling of Stratholme is map 595
    # Build mysql command with proper password handling
    cmd = ['mysql']
    cmd.extend([f'-h{db_config["host"]}'])
    cmd.extend([f'-P{str(db_config["port"])}'])
    cmd.extend([f'-u{db_config["user"]}'])
    if db_config["password"]:
        cmd.extend([f'-p{db_config["password"]}'])
    cmd.append(db_config["database"])
    cmd.extend(['-B', '-N', '-e'])
    cmd.append(f"SELECT c.id, c.id1, c.map, c.position_x, c.position_y, c.position_z, c.orientation, "
                f"ct.name FROM creature c "
                f"JOIN creature_template ct ON c.id1 = ct.entry "
                f"WHERE c.map = {instance_id} "
                f"ORDER BY c.position_x, c.position_y LIMIT 100")
    
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, check=True)
        spawns = []
        for line in result.stdout.strip().split('\n'):
            if line.strip():
                parts = line.split('\t')
                if len(parts) >= 8:
                    spawns.append({
                        'guid': parts[0],
                        'entry': parts[1],
                        'map': parts[2],
                        'x': float(parts[3]),
                        'y': float(parts[4]),
                        'z': float(parts[5]),
                        'o': float(parts[6]),
                        'name': parts[7]
                    })
        return spawns
    except (subprocess.CalledProcessError, FileNotFoundError) as e:
        print(f"Database query error: {e}")
    
    return []

def fetch_wowhead_spell(spell_id):
    """Fetch spell information from Wowhead."""
    url = f"https://www.wowhead.com/wotlk/spell={spell_id}"
    print(f"\nWowhead URL: {url}")
    print("(Open in browser to see spell details, tooltip, and comments)")
    print("\nNote: Wowhead does not have a public API.")
    print("You can:")
    print("  1. Visit the URL manually")
    print("  2. Check the tooltip for energy cost")
    print("  3. Search comments for 'energy' discussions")
    print("  4. Use browser DevTools to inspect tooltip data")
    return url

def search_reference_scripts_npc(search_term=""):
    """Search TrinityCore and CMaNGOS scripts for NPC IDs by name."""
    results = []
    
    # Search TrinityCore scripts
    if TRINITYCORE_SCRIPTS.exists():
        import re
        for script_file in TRINITYCORE_SCRIPTS.rglob("*.h"):
            try:
                with open(script_file, 'r', encoding='utf-8', errors='ignore') as f:
                    content = f.read()
                    pattern = rf'NPC_\w+\s*=\s*(\d+),'
                    matches = re.finditer(pattern, content)
                    for match in matches:
                        npc_id = match.group(1)
                        line_start = content.rfind('\n', 0, match.start())
                        line_end = content.find('\n', match.end())
                        if line_start >= 0 and line_end > line_start:
                            line = content[line_start:line_end]
                            if search_term.lower() in line.lower():
                                npc_name_match = re.search(r'NPC_(\w+)', line)
                                npc_name = npc_name_match.group(1) if npc_name_match else "Unknown"
                                results.append({
                                    'id': int(npc_id),
                                    'name': f"NPC_{npc_name}",
                                    'source': 'TrinityCore',
                                    'file': str(script_file.relative_to(TRINITYCORE_SCRIPTS))
                                })
            except Exception:
                continue
    
    # Search CMaNGOS ScriptDevAI
    if CMANGOS_SCRIPTS.exists():
        import re
        for script_file in CMANGOS_SCRIPTS.rglob("*.h"):
            try:
                with open(script_file, 'r', encoding='utf-8', errors='ignore') as f:
                    content = f.read()
                    pattern = rf'NPC_\w+\s*=\s*(\d+),'
                    matches = re.finditer(pattern, content)
                    for match in matches:
                        npc_id = match.group(1)
                        line_start = content.rfind('\n', 0, match.start())
                        line_end = content.find('\n', match.end())
                        if line_start >= 0 and line_end > line_start:
                            line = content[line_start:line_end]
                            if search_term.lower() in line.lower():
                                npc_name_match = re.search(r'NPC_(\w+)', line)
                                npc_name = npc_name_match.group(1) if npc_name_match else "Unknown"
                                if not any(r['id'] == int(npc_id) and r['source'] == 'CMaNGOS' for r in results):
                                    results.append({
                                        'id': int(npc_id),
                                        'name': f"NPC_{npc_name}",
                                        'source': 'CMaNGOS',
                                        'file': str(script_file.relative_to(CMANGOS_SCRIPTS))
                                    })
            except Exception:
                continue
    
    return results

def search_reference_scripts_by_dungeon(dungeon_name):
    """Search reference scripts for dungeon-related NPCs and scripts."""
    results = {
        'trinitycore': [],
        'cmangos': []
    }
    
    # Search TrinityCore scripts
    if TRINITYCORE_SCRIPTS.exists():
        import re
        for script_file in TRINITYCORE_SCRIPTS.rglob("*"):
            if script_file.is_file() and dungeon_name.lower() in script_file.name.lower():
                results['trinitycore'].append(str(script_file.relative_to(TRINITYCORE_SCRIPTS)))
    
    # Search CMaNGOS ScriptDevAI
    if CMANGOS_SCRIPTS.exists():
        import re
        for script_file in CMANGOS_SCRIPTS.rglob("*"):
            if script_file.is_file() and dungeon_name.lower() in script_file.name.lower():
                results['cmangos'].append(str(script_file.relative_to(CMANGOS_SCRIPTS)))
    
    return results

def fetch_wowhead_zone(zone_id):
    """Fetch zone information from Wowhead."""
    url = f"https://www.wowhead.com/wotlk/zone={zone_id}"
    print(f"\nWowhead URL: {url}")
    print("(Open in browser to see zone details and comments)")
    print("\nNote: Wowhead does not have a public API.")
    print("You can:")
    print("  1. Visit the URL manually")
    print("  2. Read zone comments for 'wave' or 'spawn' discussions")
    print("  3. Check NPC pages for spawn locations")
    return url

def investigate_16905_berserk(db_config=None):
    """Investigate issue #16905: Druid Berserk energy bug."""
    print("=" * 80)
    print("Investigating Issue #16905: Druid Berserk Energy Bug")
    print("=" * 80)
    
    spell_id = 50334  # Berserk
    
    print(f"\n1. Checking DBC Files (Spell.dbc)...")
    spell_dbc_data = read_spell_dbc(spell_id)
    if spell_dbc_data:
        print(f"   Found in DBC:")
        print(f"     Name: {spell_dbc_data['name']}")
        print(f"     Power Type: {spell_dbc_data['power_type']} (3=Energy)")
        print(f"     Power Cost: {spell_dbc_data['power_cost']}")
        print(f"     Power Per Second: {spell_dbc_data['power_per_second']}")
    else:
        print("   Not found in DBC or DBC file missing")
    
    if db_config:
        print(f"\n2. Checking Database (spell_template)...")
        spell_db_data = query_spell_database(spell_id, db_config)
        if spell_db_data:
            print(f"   Found in database:")
            print(f"     Name: {spell_db_data['name']}")
            print(f"     Power Type: {spell_db_data['powerType']} (3=Energy)")
            print(f"     Power Cost: {spell_db_data['powerCost']}")
            print(f"     Power Cost %: {spell_db_data['powerCostPercentage']}")
            print(f"     Power Per Second: {spell_db_data['powerPerSecond']}")
            print(f"     Effects: {spell_db_data['effect1']}, {spell_db_data['effect2']}, {spell_db_data['effect3']}")
        else:
            print("   Not found in database")
    
    print(f"\n3. Online Sources:")
    wowhead_url = fetch_wowhead_spell(spell_id)
    
    print(f"\n4. Analysis:")
    print("   - Check if Power Type = 3 (Energy) in DBC/DB")
    print("   - Check if Power Cost > 0 (should consume energy)")
    print("   - Check Wowhead comments for retail behavior")
    print("   - Compare with current script implementation")
    
    print(f"\n5. Current Script Location:")
    print("   realm2/azerothcore/src/server/scripts/Spells/spell_druid.cpp")
    print("   Lines 1161-1190: spell_dru_berserk class")
    print("   - Currently only removes Tiger's Fury and resets Maul cooldown")
    print("   - Does NOT consume energy")
    
    print(f"\n6. Recommended Fix:")
    print("   If spell should consume all energy in cat form:")
    print("   - Add energy consumption in HandleAfterCast()")
    print("   - Check if player is in FORM_CAT")
    print("   - Set POWER_ENERGY to 0")

def investigate_23830_culling(db_config=None):
    """Investigate issue #23830: Culling of Stratholme wave spawn positions."""
    print("=" * 80)
    print("Investigating Issue #23830: Culling of Stratholme Wave Spawn Positions")
    print("=" * 80)
    
    instance_map = 595  # Culling of Stratholme
    
    print(f"\n1. Checking Database (creature spawns in map {instance_map})...")
    if db_config:
        spawns = query_creature_spawns(instance_map, db_config)
        if spawns:
            print(f"   Found {len(spawns)} creature spawns")
            print(f"   Sample spawns:")
            for spawn in spawns[:10]:
                print(f"     {spawn['name']} (Entry {spawn['entry']}): "
                      f"({spawn['x']:.2f}, {spawn['y']:.2f}, {spawn['z']:.2f})")
        else:
            print("   No spawns found or database error")
    
    print(f"\n2. Current Code Implementation:")
    print("   realm2/azerothcore/src/server/scripts/Kalimdor/CavernsOfTime/CullingOfStratholme/")
    print("   culling_of_stratholme.cpp lines 191-241: WavesLocations array")
    print("   - 8 waves, 4 spawns per wave")
    print("   - Hardcoded coordinates")
    
    print(f"\n3. Online Sources:")
    wowhead_url = fetch_wowhead_zone(4100)
    print("   - YouTube: Search 'Culling of Stratholme wave spawns'")
    print("   - Other private servers: Check their implementations")
    print("   - TrinityCore: https://github.com/TrinityCore/TrinityCore")
    
    print(f"\n4. Investigation Steps:")
    print("   a) Compare current hardcoded positions with database spawns")
    print("   b) Check Wowhead comments for wave spawn locations")
    print("   c) Watch YouTube videos of retail Culling runs")
    print("   d) Check if positions should be dynamic vs static")
    print("   e) Verify coordinates match retail behavior")
    
    print(f"\n5. Reference Scripts:")
    ref_scripts = search_reference_scripts_by_dungeon("culling")
    if ref_scripts['trinitycore'] or ref_scripts['cmangos']:
        print("   Found Culling of Stratholme scripts:")
        if ref_scripts['trinitycore']:
            print("     TrinityCore:")
            for script in ref_scripts['trinitycore'][:5]:  # Limit to 5
                print(f"       - {script}")
        if ref_scripts['cmangos']:
            print("     CMaNGOS:")
            for script in ref_scripts['cmangos'][:5]:  # Limit to 5
                print(f"       - {script}")
    
    print(f"\n6. Wave NPCs to Check:")
    wave_npcs = [
        (27737, "Risen Zombie"),
        (28249, "Devouring Ghoul"),
        (28200, "Dark Necromancer"),
        (28199, "Tomb Stalker"),
        (27734, "Crypt Fiend"),
        (28201, "Bile Golem"),
        (27729, "Enraging Ghoul"),
        (27736, "Patchwork Construct")
    ]
    print("   Wave NPCs:")
    for entry, name in wave_npcs:
        print(f"     {entry}: {name}")
    
    # Search reference scripts for wave NPCs
    print(f"\n7. Searching Reference Scripts for Wave NPCs:")
    for entry, name in wave_npcs[:3]:  # Check first 3 as example
        ref_results = search_reference_scripts_npc(name.lower())
        if ref_results:
            print(f"     {name} (ID {entry}):")
            for r in ref_results[:2]:  # Limit to 2 results per NPC
                print(f"       - {r['name']} = {r['id']} (from {r['source']})")

def main():
    parser = argparse.ArgumentParser(description='Investigate AzerothCore issues')
    parser.add_argument('--issue', type=int, required=True,
                       choices=[16905, 23830],
                       help='Issue number to investigate')
    parser.add_argument('--db-host', default='127.0.0.1', help='Database host')
    parser.add_argument('--db-port', type=int, default=3306, help='Database port')
    parser.add_argument('--db-user', default='root', help='Database user')
    parser.add_argument('--db-pass', default='', help='Database password')
    parser.add_argument('--db-name', default='azerothcore_world', help='Database name')
    
    args = parser.parse_args()
    
    db_config = {
        'host': args.db_host,
        'port': args.db_port,
        'user': args.db_user,
        'password': args.db_pass,
        'database': args.db_name
    }
    
    if args.issue == 16905:
        investigate_16905_berserk(db_config)
    elif args.issue == 23830:
        investigate_23830_culling(db_config)
    
    return 0

if __name__ == '__main__':
    exit(main())

