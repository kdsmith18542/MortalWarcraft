#!/usr/bin/env python3
"""
Mortal Warcraft - Automated DBC Patcher
Programmatically patches DBC files without manual editing

Usage:
    python3 dbc_patcher.py --all
    python3 dbc_patcher.py --spell
    python3 dbc_patcher.py --talenttab
    python3 dbc_patcher.py --hitbox

Requirements:
    pip install pydbc
"""

import struct
import os
import sys
import shutil
from pathlib import Path
from datetime import datetime
import argparse

class DBCPatcher:
    """Base class for DBC file patching"""
    
    def __init__(self, dbc_path: str):
        self.dbc_path = Path(dbc_path)
        self.data = None
        self.header = {}
        self.string_block_offset = 0
        self.string_block = b''
        
    def read_dbc(self):
        """Read and parse DBC file"""
        if not self.dbc_path.exists():
            raise FileNotFoundError(f"DBC file not found: {self.dbc_path}")
        
        with open(self.dbc_path, 'rb') as f:
            self.data = bytearray(f.read())
        
        # Parse header
        if self.data[:4] != b'WDBC':
            raise ValueError("Invalid DBC file format (missing WDBC signature)")
        
        self.header = {
            'signature': self.data[:4],
            'record_count': struct.unpack('<I', self.data[4:8])[0],
            'field_count': struct.unpack('<I', self.data[8:12])[0],
            'record_size': struct.unpack('<I', self.data[12:16])[0],
            'string_block_size': struct.unpack('<I', self.data[16:20])[0]
        }
        
        # Calculate string block offset
        self.string_block_offset = 20 + (self.header['record_count'] * self.header['record_size'])
        self.string_block = self.data[self.string_block_offset:]
        
        return self.header
    
    def write_dbc(self, output_path: str = None):
        """Write modified DBC file"""
        output = output_path or self.dbc_path
        
        # Create backup
        backup_path = Path(str(output) + '.backup')
        if not backup_path.exists() and Path(output).exists():
            shutil.copy(output, backup_path)
            print(f"  💾 Backup created: {backup_path}")
        
        with open(output, 'wb') as f:
            f.write(self.data)
        
        print(f"  ✅ Written: {output}")
    
    def add_string(self, string: str) -> int:
        """Add string to string block, return offset"""
        string_bytes = string.encode('utf-8') + b'\x00'
        offset = len(self.string_block)
        self.string_block += string_bytes
        self.data = self.data[:self.string_block_offset] + self.string_block
        
        # Update string block size in header
        new_size = len(self.string_block)
        self.data[16:20] = struct.pack('<I', new_size)
        
        return offset
    
    def get_record_offset(self, record_index: int) -> int:
        """Get byte offset for a record"""
        return 20 + (record_index * self.header['record_size'])
    
    def read_uint32(self, offset: int) -> int:
        """Read uint32 at offset"""
        return struct.unpack('<I', self.data[offset:offset+4])[0]
    
    def write_uint32(self, offset: int, value: int):
        """Write uint32 at offset"""
        self.data[offset:offset+4] = struct.pack('<I', value)
    
    def read_float(self, offset: int) -> float:
        """Read float at offset"""
        return struct.unpack('<f', self.data[offset:offset+4])[0]
    
    def write_float(self, offset: int, value: float):
        """Write float at offset"""
        self.data[offset:offset+4] = struct.pack('<f', value)


class SpellDBCPatcher(DBCPatcher):
    """Automated Spell.dbc patcher"""
    
    CUSTOM_SPELLS = [
        # Brace Mechanic
        {
            'id': 90010,
            'name': 'Brace',
            'description': 'Brace yourself, reducing damage taken by 50% for 0.75 seconds.',
            'duration_index': 9,  # 750ms
            'cooldown': 5000,  # 5 seconds
            'effect_type': 6,  # SPELL_AURA_MOD_DAMAGE_PERCENT_TAKEN
            'effect_base_points': -50,
        },
        # Hunger Debuffs
        {
            'id': 90020,
            'name': 'Hunger: Peckish',
            'description': 'You are slightly hungry. Stats reduced by 2%.',
            'duration_index': 21,  # Permanent
            'effect_type': 6,  # SPELL_AURA_MOD_STAT_PERCENT
            'effect_base_points': -2,
        },
        {
            'id': 90021,
            'name': 'Hunger: Hungry',
            'description': 'You are hungry. Stats reduced by 5%. Regeneration reduced by 5%.',
            'duration_index': 21,
            'effect_type': 6,
            'effect_base_points': -5,
        },
        # Add more spells as needed...
    ]
    
    def add_custom_spells(self):
        """Add all custom Mortal spells"""
        print("\n🔧 Adding custom spells to Spell.dbc...")
        
        self.read_dbc()
        original_count = self.header['record_count']
        
        for spell in self.CUSTOM_SPELLS:
            # For simplicity, we'll append new records
            # In production, you'd want to find unused spell IDs
            
            spell_id = spell['id']
            name_offset = self.add_string(spell['name'])
            desc_offset = self.add_string(spell['description'])
            
            # Create minimal spell record (simplified)
            # Real implementation would need all fields
            record = bytearray(self.header['record_size'])
            
            # Field 0: Spell ID
            struct.pack_into('<I', record, 0, spell_id)
            
            # Field 1: Name string offset
            struct.pack_into('<I', record, 4, name_offset)
            
            # Field 2: Description string offset
            struct.pack_into('<I', record, 8, desc_offset)
            
            # ... (many more fields for a complete spell)
            
            # Insert record at appropriate position
            insert_offset = self.string_block_offset
            self.data = self.data[:insert_offset] + record + self.data[insert_offset:]
            self.string_block_offset += len(record)
            
            print(f"  ✅ Added: {spell['name']} (ID: {spell_id})")
        
        # Update record count
        new_count = original_count + len(self.CUSTOM_SPELLS)
        self.data[4:8] = struct.pack('<I', new_count)
        
        print(f"  📊 Records: {original_count} → {new_count}")


class TalentTabDBCPatcher(DBCPatcher):
    """Automated TalentTab.dbc patcher"""
    
    MASTERY_TREES = [
        {
            'id': 10001,
            'name': 'Warlord',
            'icon_id': 135,
            'race_mask': 0,  # Universal
            'class_mask': 0,  # Universal
            'order_index': 0,
        },
        {
            'id': 10002,
            'name': 'Guardian',
            'icon_id': 134,
            'race_mask': 0,
            'class_mask': 0,
            'order_index': 1,
        },
        {
            'id': 10003,
            'name': 'Explorer',
            'icon_id': 136,
            'race_mask': 0,
            'class_mask': 0,
            'order_index': 2,
        },
    ]
    
    def add_mastery_trees(self):
        """Add Universal Mastery Trees"""
        print("\n🔧 Adding Universal Mastery Trees to TalentTab.dbc...")
        
        self.read_dbc()
        original_count = self.header['record_count']
        
        for tree in self.MASTERY_TREES:
            name_offset = self.add_string(tree['name'])
            
            # TalentTab.dbc record structure (simplified)
            record = bytearray(self.header['record_size'])
            
            # Field 0: ID
            struct.pack_into('<I', record, 0, tree['id'])
            
            # Field 1: Name offset
            struct.pack_into('<I', record, 4, name_offset)
            
            # Field 2: Icon ID
            struct.pack_into('<I', record, 8, tree['icon_id'])
            
            # Field 3: Race Mask (0 = universal)
            struct.pack_into('<I', record, 12, tree['race_mask'])
            
            # Field 4: Class Mask (0 = universal)
            struct.pack_into('<I', record, 16, tree['class_mask'])
            
            # Field 5: Order Index
            struct.pack_into('<I', record, 20, tree['order_index'])
            
            # Insert record
            insert_offset = self.string_block_offset
            self.data = self.data[:insert_offset] + record + self.data[insert_offset:]
            self.string_block_offset += len(record)
            
            print(f"  ✅ Added: {tree['name']} (ID: {tree['id']})")
        
        # Update record count
        new_count = original_count + len(self.MASTERY_TREES)
        self.data[4:8] = struct.pack('<I', new_count)
        
        print(f"  📊 Records: {original_count} → {new_count}")


class HitboxDBCPatcher(DBCPatcher):
    """Automated hitbox adjustment patcher"""
    
    def adjust_hitboxes(self, reduction_factor: float = 0.90):
        """Reduce hitboxes by reduction_factor (e.g., 0.90 = 10% reduction)"""
        print(f"\n🔧 Adjusting hitboxes in CreatureModelData.dbc (factor: {reduction_factor})...")
        
        self.read_dbc()
        
        # CreatureModelData.dbc field offsets
        COLLISION_WIDTH_FIELD = 14
        COLLISION_HEIGHT_FIELD = 15
        MISSILE_RADIUS_FIELD = 18
        
        patched_count = 0
        
        for i in range(self.header['record_count']):
            record_offset = self.get_record_offset(i)
            
            # Patch collision width (field 14)
            width_offset = record_offset + (COLLISION_WIDTH_FIELD * 4)
            width = self.read_float(width_offset)
            if width > 0:
                self.write_float(width_offset, width * reduction_factor)
            
            # Patch collision height (field 15)
            height_offset = record_offset + (COLLISION_HEIGHT_FIELD * 4)
            height = self.read_float(height_offset)
            if height > 0:
                self.write_float(height_offset, height * reduction_factor)
            
            # Patch missile collision radius (field 18)
            radius_offset = record_offset + (MISSILE_RADIUS_FIELD * 4)
            radius = self.read_float(radius_offset)
            if radius > 0:
                self.write_float(radius_offset, radius * reduction_factor)
                patched_count += 1
        
        print(f"  ✅ Patched {patched_count} creature models")


def main():
    parser = argparse.ArgumentParser(description='Mortal Warcraft Automated DBC Patcher')
    parser.add_argument('--all', action='store_true', help='Patch all DBC files')
    parser.add_argument('--spell', action='store_true', help='Patch Spell.dbc')
    parser.add_argument('--talenttab', action='store_true', help='Patch TalentTab.dbc')
    parser.add_argument('--hitbox', action='store_true', help='Patch hitboxes')
    parser.add_argument('--dbc-dir', default='/home/keith/wowpack/azerothcore/data/dbc',
                        help='DBC directory path')
    
    args = parser.parse_args()
    
    if not any([args.all, args.spell, args.talenttab, args.hitbox]):
        parser.print_help()
        return
    
    dbc_dir = Path(args.dbc_dir)
    if not dbc_dir.exists():
        print(f"❌ ERROR: DBC directory not found: {dbc_dir}")
        return
    
    print("╔══════════════════════════════════════════════════════╗")
    print("║  Mortal Warcraft - Automated DBC Patcher            ║")
    print("╚══════════════════════════════════════════════════════╝")
    print(f"\n📁 DBC Directory: {dbc_dir}")
    
    # Create backup directory
    backup_dir = Path(__file__).parent.parent.parent / 'dbc_patches' / 'backups'
    backup_dir.mkdir(parents=True, exist_ok=True)
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    backup_subdir = backup_dir / f'auto_backup_{timestamp}'
    backup_subdir.mkdir(exist_ok=True)
    
    try:
        # Patch Spell.dbc
        if args.all or args.spell:
            spell_dbc = dbc_dir / 'Spell.dbc'
            if spell_dbc.exists():
                shutil.copy(spell_dbc, backup_subdir / 'Spell.dbc')
                patcher = SpellDBCPatcher(spell_dbc)
                patcher.add_custom_spells()
                patcher.write_dbc()
            else:
                print("\n⚠️  Spell.dbc not found, skipping")
        
        # Patch TalentTab.dbc
        if args.all or args.talenttab:
            talenttab_dbc = dbc_dir / 'TalentTab.dbc'
            if talenttab_dbc.exists():
                shutil.copy(talenttab_dbc, backup_subdir / 'TalentTab.dbc')
                patcher = TalentTabDBCPatcher(talenttab_dbc)
                patcher.add_mastery_trees()
                patcher.write_dbc()
            else:
                print("\n⚠️  TalentTab.dbc not found, skipping")
        
        # Patch hitboxes
        if args.all or args.hitbox:
            hitbox_dbc = dbc_dir / 'CreatureModelData.dbc'
            if hitbox_dbc.exists():
                shutil.copy(hitbox_dbc, backup_subdir / 'CreatureModelData.dbc')
                patcher = HitboxDBCPatcher(hitbox_dbc)
                patcher.adjust_hitboxes(reduction_factor=0.90)
                patcher.write_dbc()
            else:
                print("\n⚠️  CreatureModelData.dbc not found, skipping")
        
        print("\n╔══════════════════════════════════════════════════════╗")
        print("║  ✅ Automated DBC Patching Complete!                 ║")
        print("╠══════════════════════════════════════════════════════╣")
        print(f"║  💾 Backups: {backup_subdir.name}")
        print("║                                                      ║")
        print("║  Next Steps:                                         ║")
        print("║  1. Restart AzerothCore servers                      ║")
        print("║  2. Test in-game                                     ║")
        print("║                                                      ║")
        print("╚══════════════════════════════════════════════════════╝")
        
    except Exception as e:
        print(f"\n❌ ERROR: {e}")
        import traceback
        traceback.print_exc()
        return 1
    
    return 0


if __name__ == '__main__':
    sys.exit(main())

