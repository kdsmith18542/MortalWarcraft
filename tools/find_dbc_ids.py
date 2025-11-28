#!/usr/bin/env python3
"""
Mortal Warcraft - DBC ID Finder

Finds appropriate model IDs and display IDs from extracted DBC files
for use in creature_template and item_template entries.

Usage:
    python3 find_dbc_ids.py --type creature --name "Human Male"
    python3 find_dbc_ids.py --type item --name "Sword"
    python3 find_dbc_ids.py --type gameobject --name "Anvil"
    python3 find_dbc_ids.py --type gameobject --name "Iron Dwarf Relic" --db-name realm2_world
"""

import argparse
import struct
import os
import sys
from pathlib import Path

# DBC file paths
DBC_PATH = Path("azerothcore/data/dbc")

# Reference script paths
REFERENCE_PATH = Path("tools/reference")
TRINITYCORE_SCRIPTS = REFERENCE_PATH / "trinitycore-scripts" / "src" / "server" / "scripts"
CMANGOS_SCRIPTS = REFERENCE_PATH / "cmangos-wotlk" / "src" / "game" / "AI" / "ScriptDevAI" / "scripts"

# Try to import mysql connector for database searches
try:
    import mysql.connector
    HAS_MYSQL = True
except ImportError:
    HAS_MYSQL = False

def read_dbc_header(filepath):
    """Read DBC file header to get record count and field count."""
    with open(filepath, 'rb') as f:
        # DBC header: signature (4 bytes), record_count (4), field_count (4), record_size (4), string_block_size (4)
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

def search_creature_display_info(search_term=""):
    """Search CreatureDisplayInfo.dbc for display IDs."""
    dbc_file = DBC_PATH / "CreatureDisplayInfo.dbc"
    if not dbc_file.exists():
        print(f"Error: {dbc_file} not found")
        return []
    
    header = read_dbc_header(dbc_file)
    if not header:
        print(f"Error: Could not read DBC header from {dbc_file}")
        return []
    
    results = []
    with open(dbc_file, 'rb') as f:
        f.seek(20)  # Skip header
        
        # CreatureDisplayInfo structure (approximate):
        # ID (4), ModelID (4), SoundID (4), ExtendedDisplayInfoID (4), ...
        for i in range(min(header['record_count'], 1000)):  # Limit to first 1000 for performance
            record = f.read(header['record_size'])
            if len(record) < 16:
                break
            
            entry_id = struct.unpack('<I', record[0:4])[0]
            model_id = struct.unpack('<I', record[4:8])[0]
            
            results.append({
                'id': entry_id,
                'model_id': model_id,
                'type': 'creature_display'
            })
    
    return results[:20]  # Return first 20 results

def search_item_display_info(search_term=""):
    """Search ItemDisplayInfo.dbc for display IDs."""
    dbc_file = DBC_PATH / "ItemDisplayInfo.dbc"
    if not dbc_file.exists():
        print(f"Error: {dbc_file} not found")
        return []
    
    header = read_dbc_header(dbc_file)
    if not header:
        print(f"Error: Could not read DBC header from {dbc_file}")
        return []
    
    results = []
    with open(dbc_file, 'rb') as f:
        f.seek(20)  # Skip header
        
        # ItemDisplayInfo structure (approximate):
        # ID (4), ModelName_1 (string offset), ...
        for i in range(min(header['record_count'], 1000)):  # Limit to first 1000
            record = f.read(header['record_size'])
            if len(record) < 4:
                break
            
            entry_id = struct.unpack('<I', record[0:4])[0]
            
            results.append({
                'id': entry_id,
                'type': 'item_display'
            })
    
    return results[:20]  # Return first 20 results

def find_human_male_models():
    """Find common human male model IDs."""
    # Common human male model IDs (from WotLK)
    return [
        {'id': 49, 'model_id': 49, 'description': 'Human Male'},
        {'id': 50, 'model_id': 50, 'description': 'Human Female'},
        {'id': 51, 'model_id': 51, 'description': 'Orc Male'},
        {'id': 52, 'model_id': 52, 'description': 'Orc Female'},
    ]

def find_common_item_displays():
    """Find common item display IDs."""
    # Common item display IDs (from examples in codebase)
    return [
        {'id': 1542, 'description': 'Simple Sword'},
        {'id': 13488, 'description': 'Low-level Sword'},
        {'id': 57068, 'description': 'Heroes\' Earthshatter Helm'},
        {'id': 57023, 'description': 'Heroes\' Earthshatter Chest'},
    ]

def read_dbc_string_table(filepath, header):
    """Read the string table from a DBC file."""
    with open(filepath, 'rb') as f:
        # String table starts after header (20 bytes) + all records
        string_table_offset = 20 + (header['record_count'] * header['record_size'])
        f.seek(string_table_offset)
        string_data = f.read(header['string_block_size'])
        return string_data

def get_string_from_offset(string_table, offset):
    """Get a null-terminated string from the string table at the given offset."""
    if offset >= len(string_table):
        return None
    end = string_table.find(b'\x00', offset)
    if end == -1:
        return string_table[offset:].decode('utf-8', errors='ignore')
    return string_table[offset:end].decode('utf-8', errors='ignore')

def search_gameobject_template_db(search_term="", db_config=None):
    """Search gameobject_template database table by name."""
    if not HAS_MYSQL:
        # Fallback: try using subprocess to call mysql directly
        import subprocess
        if not db_config:
            db_config = {
                'host': '127.0.0.1',
                'port': 3306,
                'user': 'root',
                'password': '',
                'database': 'azerothcore_world'
            }
        
        try:
            # Use MYSQL_PWD environment variable for password to avoid warning
            env = os.environ.copy()
            if db_config['password']:
                env['MYSQL_PWD'] = db_config['password']
            # Use --batch and --raw for tab-separated output
            cmd = [
                'mysql',
                '--batch',
                '--raw',
                f"-h{db_config['host']}",
                f"-P{str(db_config['port'])}",
                f"-u{db_config['user']}",
                db_config['database'],
                '-e',
                f"SELECT entry, name, displayId FROM gameobject_template WHERE name LIKE '%{search_term}%' LIMIT 50;"
            ]
            result = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, text=True, env=env)
            if result.returncode == 0 and result.stdout:
                lines = [l.strip() for l in result.stdout.strip().split('\n') if l.strip()]
                if not lines:
                    return []
                
                results = []
                # --batch --raw gives tab-separated output, first line is header
                for line in lines[1:]:  # Skip header
                    parts = line.split('\t')
                    if len(parts) >= 2:
                        try:
                            entry_id = int(parts[0])
                            name = parts[1]
                            display_id = int(parts[2]) if len(parts) >= 3 and parts[2].strip().isdigit() else 0
                            results.append({
                                'id': entry_id,
                                'name': name,
                                'display_id': display_id
                            })
                        except (ValueError, IndexError):
                            continue
                return results
        except Exception:
            pass
        return []
    
    if not db_config:
        # Default config
        db_config = {
            'host': '127.0.0.1',
            'port': 3306,
            'user': 'root',
            'password': '',
            'database': 'azerothcore_world'
        }
    
    try:
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor(dictionary=True)
        
        query = "SELECT entry, name, displayId FROM gameobject_template WHERE name LIKE %s LIMIT 50"
        cursor.execute(query, (f'%{search_term}%',))
        results = cursor.fetchall()
        
        cursor.close()
        conn.close()
        
        return [{'id': r['entry'], 'name': r['name'], 'display_id': r['displayId']} for r in results]
    except Exception as e:
        print(f"Database search error: {e}", file=sys.stderr)
        return []

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
                    # Look for enum with NPC definitions
                    # Pattern: NPC_NAME = number,
                    pattern = rf'NPC_\w+\s*=\s*(\d+),'
                    matches = re.finditer(pattern, content)
                    for match in matches:
                        npc_id = match.group(1)
                        # Try to find the NPC name before the ID
                        line_start = content.rfind('\n', 0, match.start())
                        line_end = content.find('\n', match.end())
                        if line_start >= 0 and line_end > line_start:
                            line = content[line_start:line_end]
                            if search_term.lower() in line.lower():
                                # Extract NPC name
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
                    # Look for NPC definitions
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
                                # Avoid duplicates
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

def search_reference_scripts_by_id(npc_id):
    """Search reference scripts for NPC by ID."""
    results = []
    
    # Search TrinityCore scripts
    if TRINITYCORE_SCRIPTS.exists():
        import re
        for script_file in TRINITYCORE_SCRIPTS.rglob("*.h"):
            try:
                with open(script_file, 'r', encoding='utf-8', errors='ignore') as f:
                    content = f.read()
                    pattern = rf'NPC_(\w+)\s*=\s*{npc_id},'
                    match = re.search(pattern, content)
                    if match:
                        results.append({
                            'id': npc_id,
                            'name': f"NPC_{match.group(1)}",
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
                    pattern = rf'NPC_(\w+)\s*=\s*{npc_id},'
                    match = re.search(pattern, content)
                    if match:
                        if not any(r['id'] == npc_id and r['source'] == 'CMaNGOS' for r in results):
                            results.append({
                                'id': npc_id,
                                'name': f"NPC_{match.group(1)}",
                                'source': 'CMaNGOS',
                                'file': str(script_file.relative_to(CMANGOS_SCRIPTS))
                            })
            except Exception:
                continue
    
    return results

def search_gameobject_dbc(search_term=""):
    """Search GameObject.dbc for gameobject entries by name."""
    # First try to search database if available
    db_results = search_gameobject_template_db(search_term)
    if db_results:
        return db_results
    
    # Fallback: try to read GameObject.dbc if it exists
    # Note: GameObject.dbc may not have name strings, so database search is preferred
    dbc_file = DBC_PATH / "GameObject.dbc"
    if not dbc_file.exists():
        return []
    
    header = read_dbc_header(dbc_file)
    if not header:
        return []
    
    results = []
    string_table = read_dbc_string_table(dbc_file, header)
    
    with open(dbc_file, 'rb') as f:
        f.seek(20)  # Skip header
        
        # GameObject.dbc structure (WotLK):
        # Field 0: ID (4 bytes)
        # Field 1: Type (4 bytes)
        # Field 2: DisplayID (4 bytes)
        # Field 3: Name (string offset, 4 bytes)
        # ... more fields
        
        for i in range(min(header['record_count'], 10000)):  # Search up to 10k records
            record = f.read(header['record_size'])
            if len(record) < 16:
                break
            
            entry_id = struct.unpack('<I', record[0:4])[0]
            
            # Try to read name string (usually at offset 12, but may vary)
            if header['record_size'] >= 16:
                name_offset = struct.unpack('<I', record[12:16])[0]
                name = get_string_from_offset(string_table, name_offset)
                
                if name and search_term.lower() in name.lower():
                    # Try to get display ID (usually at offset 8)
                    display_id = 0
                    if header['record_size'] >= 12:
                        display_id = struct.unpack('<I', record[8:12])[0]
                    
                    results.append({
                        'id': entry_id,
                        'name': name,
                        'display_id': display_id
                    })
    
    return results[:50]  # Return first 50 results

def main():
    parser = argparse.ArgumentParser(description='Find DBC IDs for creatures, items, and gameobjects')
    parser.add_argument('--type', choices=['creature', 'item', 'gameobject'],
                       help='Type of ID to search for (not required if using --npc-id)')
    parser.add_argument('--name', default='', help='Search term (optional)')
    parser.add_argument('--npc-id', type=int, help='Search for NPC by ID in reference scripts')
    parser.add_argument('--list-common', action='store_true',
                       help='List common IDs instead of searching DBC files')
    parser.add_argument('--no-reference', action='store_true',
                       help='Skip searching reference scripts (TrinityCore/CMaNGOS)')
    parser.add_argument('--db-host', default='127.0.0.1', help='Database host')
    parser.add_argument('--db-port', type=int, default=3306, help='Database port')
    parser.add_argument('--db-user', default='root', help='Database user')
    parser.add_argument('--db-pass', default='', help='Database password')
    parser.add_argument('--db-name', default='azerothcore_world', help='Database name')
    
    args = parser.parse_args()
    
    # Handle NPC ID search (doesn't require --type)
    if args.npc_id:
        if not args.no_reference:
            ref_results = search_reference_scripts_by_id(args.npc_id)
            if ref_results:
                print(f"Found NPC ID {args.npc_id} in reference scripts:")
                for r in ref_results:
                    print(f"  {r['name']} = {r['id']} (from {r['source']}, {r['file']})")
            else:
                print(f"NPC ID {args.npc_id} not found in reference scripts")
        return 0
    
    # --type is required for other operations
    if not args.type:
        parser.error("--type is required (unless using --npc-id)")
    
    if args.list_common:
        if args.type == 'creature':
            print("Common Creature Model IDs:")
            for model in find_human_male_models():
                print(f"  Display ID {model['id']}: {model['description']} (Model ID: {model['model_id']})")
        elif args.type == 'item':
            print("Common Item Display IDs:")
            for item in find_common_item_displays():
                print(f"  Display ID {item['id']}: {item['description']}")
        return 0
    
    db_config = None
    if args.type == 'gameobject' and (args.db_name or args.db_pass or args.db_host != '127.0.0.1'):
        # Create db_config if database parameters are provided (works with or without mysql-connector)
        db_config = {
            'host': args.db_host,
            'port': args.db_port,
            'user': args.db_user,
            'password': args.db_pass,
            'database': args.db_name
        }
    
    if args.type == 'creature':
        # First try reference scripts for NPC IDs
        if args.name and not args.no_reference:
            ref_results = search_reference_scripts_npc(args.name)
            if ref_results:
                print(f"Found {len(ref_results)} NPC IDs in reference scripts matching '{args.name}':")
                for r in ref_results:
                    print(f"  {r['name']} = {r['id']} (from {r['source']}, {r['file']})")
                print()
        
        # Also search DBC for display info
        results = search_creature_display_info(args.name)
        if results:
            print(f"Found {len(results)} creature display IDs:")
            for r in results:
                print(f"  Display ID {r['id']}: Model ID {r['model_id']}")
    elif args.type == 'item':
        results = search_item_display_info(args.name)
        print(f"Found {len(results)} item display IDs:")
        for r in results:
            print(f"  Display ID {r['id']}")
    elif args.type == 'gameobject':
        if not args.name:
            print("Error: --name is required for gameobject search")
            return 1
        
        # Try database search first (works with or without mysql-connector)
        if db_config:
            results = search_gameobject_template_db(args.name, db_config)
        else:
            results = search_gameobject_dbc(args.name)
        
        if not results:
            # Fallback to DBC search if database search failed
            results = search_gameobject_dbc(args.name)
        
        if results:
            print(f"Found {len(results)} gameobject entries matching '{args.name}':")
            for r in results:
                name = r.get('name', 'Unknown')
                display_id = r.get('display_id', 0)
                print(f"  Entry {r['id']}: {name} (Display ID: {display_id})")
        else:
            print(f"No gameobjects found matching '{args.name}'")
            if not HAS_MYSQL and not db_config:
                print("Note: Install mysql-connector-python for database searches: pip install mysql-connector-python")
    
    return 0

if __name__ == '__main__':
    exit(main())

