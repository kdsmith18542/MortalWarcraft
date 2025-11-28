#!/usr/bin/env python3
"""
Patch Item.dbc to remove level requirements
Project: Mortal Warcraft Overhaul
Usage: python3 patch_item_dbc.py <input.dbc> <output.dbc>
"""

import struct
import sys

def patch_item_dbc(input_file, output_file):
    """
    Patches Item.dbc to set all RequiredLevel fields to 0
    """
    try:
        with open(input_file, 'rb') as f:
            data = bytearray(f.read())
    except FileNotFoundError:
        print(f"Error: File '{input_file}' not found")
        return False
    except Exception as e:
        print(f"Error reading file: {e}")
        return False
    
    # Verify DBC signature
    signature = data[0:4]
    if signature != b'WDBC':
        print("Error: Not a valid DBC file (missing 'WDBC' signature)")
        return False
    
    # Parse DBC header (3.3.5a format)
    record_count = struct.unpack('<I', data[4:8])[0]
    field_count = struct.unpack('<I', data[8:12])[0]
    record_size = struct.unpack('<I', data[12:16])[0]
    string_block_size = struct.unpack('<I', data[16:20])[0]
    
    print(f"DBC File Info:")
    print(f"  Records: {record_count}")
    print(f"  Fields per record: {field_count}")
    print(f"  Record size: {record_size} bytes")
    print(f"  String block size: {string_block_size} bytes")
    
    # RequiredLevel field index (typically field 15 in Item.dbc)
    # WARNING: Verify this index with a DBC editor first!
    # Common Item.dbc structure (3.3.5a):
    # Field 0: Entry
    # Field 1: Class
    # Field 2: SubClass
    # ...
    # Field 15: RequiredLevel (approximate - VERIFY!)
    
    required_level_field = 15  # ADJUST THIS based on your DBC structure
    required_level_offset = required_level_field * 4  # 4 bytes per UInt32
    
    if required_level_offset >= record_size:
        print(f"Warning: RequiredLevel offset ({required_level_offset}) >= record size ({record_size})")
        print("Please verify the field index with a DBC editor")
        return False
    
    # Patch all records
    header_size = 20  # Standard DBC header size
    patched_count = 0
    
    for i in range(record_count):
        record_offset = header_size + (i * record_size)
        level_offset = record_offset + required_level_offset
        
        # Read current level requirement
        current_level = struct.unpack('<I', data[level_offset:level_offset + 4])[0]
        
        if current_level > 0:
            # Set RequiredLevel to 0
            data[level_offset:level_offset + 4] = struct.pack('<I', 0)
            patched_count += 1
    
    # Write patched file
    try:
        with open(output_file, 'wb') as f:
            f.write(data)
        print(f"\nSuccess: Patched {patched_count} items (set RequiredLevel to 0)")
        print(f"Output saved to: {output_file}")
        return True
    except Exception as e:
        print(f"Error writing file: {e}")
        return False

def main():
    if len(sys.argv) != 3:
        print("Usage: python3 patch_item_dbc.py <input.dbc> <output.dbc>")
        print("\nExample:")
        print("  python3 patch_item_dbc.py item.dbc item_patched.dbc")
        sys.exit(1)
    
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    
    print(f"Patching Item.dbc...")
    print(f"  Input:  {input_file}")
    print(f"  Output: {output_file}")
    print()
    
    if patch_item_dbc(input_file, output_file):
        print("\n✅ Patch completed successfully!")
        print("\nNext steps:")
        print("  1. Verify the patched file with a DBC editor")
        print("  2. Repack into MPQ archive")
        print("  3. Test in-game")
    else:
        print("\n❌ Patch failed!")
        sys.exit(1)

if __name__ == "__main__":
    main()

