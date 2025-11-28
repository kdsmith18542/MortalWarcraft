#!/usr/bin/env python3
"""
Mortal Warcraft Spell Classification Script

Classifies spells from spell_template into Mortal categories based on Spec 64 rules:
- CORE: Universal abilities (always available)
- LEARNED: Books/tomes/trials/factions
- RUNE: Weapon Arts (Elden Ring style)
- MASTERY: Mastery tree actives/passives
- AUGMENT: Toggles and utilities
- REMOVED: Disabled/removed spells

Usage:
    python3 classify_spells.py [--input data/spells_raw.csv] [--output spell_tags.sql]
"""

import csv
import argparse
import re
from pathlib import Path

# Spell school mappings
SPELL_SCHOOLS = {
    1: 'PHYSICAL',
    2: 'HOLY',
    4: 'FIRE',
    8: 'NATURE',
    16: 'FROST',
    32: 'SHADOW',
    64: 'ARCANE',
}

# Category assignment rules based on Spec 64
CATEGORY_RULES = {
    'CORE': [
        # Basic attacks, movement, interaction
        lambda s: 'attack' in str(s.get('name', '')).lower() and s.get('level', 0) == 1,
        lambda s: s.get('Attributes', 0) & 0x00000040,  # SPELL_ATTR0_PASSIVE
    ],
    'LEARNED': [
        # Simple nukes / core attacks
        lambda s: s.get('SchoolMask', 0) in [2, 4, 8, 16, 32, 64] and s.get('DmgClass', 0) == 2,  # Magic damage
        lambda s: 'heal' in str(s.get('name', '')).lower() and s.get('DmgClass', 0) == 2,
        lambda s: 'shield' in str(s.get('name', '')).lower() and s.get('DmgClass', 0) == 2,
    ],
    'RUNE': [
        # High-impact mobility (Blink, Charge)
        lambda s: 'blink' in str(s.get('name', '')).lower() or 'charge' in str(s.get('name', '')).lower(),
        # Weapon arts (Whirlwind, Mortal Strike)
        lambda s: 'whirlwind' in str(s.get('name', '')).lower() or 'mortal strike' in str(s.get('name', '')).lower(),
        lambda s: 'shock' in str(s.get('name', '')).lower() and s.get('SchoolMask', 0) in [4, 8, 16],  # Fire/Nature/Frost shocks
    ],
    'MASTERY': [
        # Mastery tree abilities (would need manual tagging or separate system)
        # For now, leave empty - would be populated by mastery system
    ],
    'AUGMENT': [
        # Buffs & auras
        lambda s: s.get('Attributes', 0) & 0x00000040 and s.get('DmgClass', 0) == 0,  # Passive buffs
        lambda s: 'blessing' in str(s.get('name', '')).lower() or 'mark' in str(s.get('name', '')).lower(),
        lambda s: 'totem' in str(s.get('name', '')).lower() or 'shout' in str(s.get('name', '')).lower(),
    ],
    'REMOVED': [
        # Big immunities / raid-level CDs
        lambda s: 'divine shield' in str(s.get('name', '')).lower() or 'ice block' in str(s.get('name', '')).lower(),
        lambda s: 'time warp' in str(s.get('name', '')).lower() or 'bloodlust' in str(s.get('name', '')).lower(),
        # Class-specific abilities (in classless system)
        lambda s: s.get('ClassOptions', 0) != 0 and s.get('ClassOptions', 0) < 0x1000,  # Class-specific flags
    ],
}

# Subcategory assignment
SUBCATEGORY_RULES = {
    'MARTIAL': [
        lambda s: s.get('SchoolMask', 0) == 1,  # Physical
        lambda s: 'strike' in str(s.get('name', '')).lower() or 'slash' in str(s.get('name', '')).lower(),
    ],
    'ARCANE': [
        lambda s: s.get('SchoolMask', 0) == 64,  # Arcane
    ],
    'HEALING': [
        lambda s: 'heal' in str(s.get('name', '')).lower(),
        lambda s: s.get('DmgClass', 0) == 2 and s.get('Effect', 0) == 10,  # Heal effect
    ],
    'CC': [
        lambda s: 'fear' in str(s.get('name', '')).lower() or 'polymorph' in str(s.get('name', '')).lower(),
        lambda s: 'stun' in str(s.get('name', '')).lower() or 'charm' in str(s.get('name', '')).lower(),
        lambda s: s.get('Mechanic', 0) in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15],  # CC mechanics
    ],
    'MOBILITY': [
        lambda s: 'blink' in str(s.get('name', '')).lower() or 'charge' in str(s.get('name', '')).lower(),
        lambda s: 'teleport' in str(s.get('name', '')).lower() or 'dash' in str(s.get('name', '')).lower(),
    ],
    'UTILITY': [
        lambda s: 'track' in str(s.get('name', '')).lower() or 'detect' in str(s.get('name', '')).lower(),
        lambda s: 'water walking' in str(s.get('name', '')).lower() or 'breathing' in str(s.get('name', '')).lower(),
    ],
    'DEFENSIVE': [
        lambda s: 'shield' in str(s.get('name', '')).lower() or 'ward' in str(s.get('name', '')).lower(),
        lambda s: 'defense' in str(s.get('name', '')).lower() or 'protection' in str(s.get('name', '')).lower(),
    ],
    'PVE_ONLY': [
        lambda s: 'raid' in str(s.get('name', '')).lower() or 'boss' in str(s.get('name', '')).lower(),
    ],
}

# PvP flags assignment
PVP_FLAG_RULES = {
    'PVP_DISABLED': [
        lambda s: 'divine shield' in str(s.get('name', '')).lower() or 'ice block' in str(s.get('name', '')).lower(),
    ],
    'PVP_CC_CAP': [
        lambda s: 'fear' in str(s.get('name', '')).lower() or 'polymorph' in str(s.get('name', '')).lower(),
        lambda s: 'stun' in str(s.get('name', '')).lower() or 'charm' in str(s.get('name', '')).lower(),
    ],
    'PVP_REDUCED': [
        lambda s: 'heal' in str(s.get('name', '')).lower() and s.get('DmgClass', 0) == 2,
    ],
    'PVP_DURATION_CAP': [
        lambda s: s.get('Attributes', 0) & 0x00000040 and s.get('DurationIndex', 0) > 0,  # Passive buffs with duration
    ],
}

def load_keystone_spells(keystone_file='data/keystone_spells.txt'):
    """Load manual override list of keystone spells."""
    keystones = set()
    keystone_path = Path(keystone_file)
    if keystone_path.exists():
        with open(keystone_path, 'r') as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith('#'):
                    try:
                        keystones.add(int(line))
                    except ValueError:
                        pass
    return keystones

def classify_spell(spell, keystone_spells):
    """Classify a single spell based on rules."""
    spell_id = spell.get('Id', 0) or spell.get('entry', 0)
    
    if not spell_id:
        return None, None, None, None, None
    
    # Manual override: keystone spells get special handling
    is_keystone = spell_id in keystone_spells
    
    # Determine category (priority order: REMOVED > CORE > others)
    category = None
    for cat_name, rules in CATEGORY_RULES.items():
        for rule in rules:
            try:
                if rule(spell):
                    category = cat_name
                    break
            except (KeyError, TypeError, ValueError):
                continue
        if category:
            break
    
    # Default to LEARNED if no category matched
    if not category:
        category = 'LEARNED'
    
    # Determine subcategory
    subcategory = None
    for subcat_name, rules in SUBCATEGORY_RULES.items():
        for rule in rules:
            try:
                if rule(spell):
                    subcategory = subcat_name
                    break
            except (KeyError, TypeError, ValueError):
                continue
        if subcategory:
            break
    
    # Determine PvP flags
    pvp_flags = []
    for flag_name, rules in PVP_FLAG_RULES.items():
        for rule in rules:
            try:
                if rule(spell):
                    pvp_flags.append(flag_name)
                    break
            except (KeyError, TypeError, ValueError):
                continue
    
    # Determine if combat ability (counts toward 8-12 cap)
    is_combat_ability = False
    if category in ['LEARNED', 'RUNE', 'MASTERY']:
        # Check if it's an active ability (not passive)
        if not (spell.get('Attributes', 0) & 0x00000040):  # Not passive
            # Check if it has damage/healing/CC effects
            if subcategory in ['MARTIAL', 'ARCANE', 'HEALING', 'CC', 'MOBILITY', 'DEFENSIVE']:
                is_combat_ability = True
    
    # Determine source type
    source_type = 'BASELINE'
    if category == 'CORE':
        source_type = 'BASELINE'
    elif category == 'LEARNED':
        source_type = 'BOOK'  # Default, can be overridden
    elif category == 'RUNE':
        source_type = 'RUNE_ITEM'
    elif category == 'MASTERY':
        source_type = 'BASELINE'  # From mastery system
    
    # PvP duration cap (for CC and buffs)
    pvp_duration_cap = None
    if 'PVP_CC_CAP' in pvp_flags or 'PVP_DURATION_CAP' in pvp_flags:
        # Default CC cap: 4 seconds, buff cap: 10 seconds
        if subcategory == 'CC':
            pvp_duration_cap = 4
        else:
            pvp_duration_cap = 10
    
    # PvP coefficient modifier (for heals/damage)
    pvp_coefficient = 1.0
    if 'PVP_REDUCED' in pvp_flags:
        if subcategory == 'HEALING':
            pvp_coefficient = 0.5  # 50% healing in PvP
        else:
            pvp_coefficient = 0.75  # 75% damage in PvP
    
    notes = f"Auto-classified: School={spell.get('SchoolMask', 0)}, DmgClass={spell.get('DmgClass', 0)}"
    if is_keystone:
        notes += " [Keystone - manual review recommended]"
    
    pvp_flags_str = ','.join(pvp_flags) if pvp_flags else None
    
    return category, subcategory, pvp_flags_str, is_combat_ability, source_type, pvp_duration_cap, pvp_coefficient, notes

def generate_sql(spells, keystone_spells, output_file):
    """Generate SQL INSERT statements for mortal_spell_tags."""
    with open(output_file, 'w') as f:
        f.write("-- Spell Tags - Generated by classify_spells.py\n")
        f.write("-- This file can be imported into the world database\n\n")
        
        for spell in spells:
            spell_id = spell.get('Id', 0) or spell.get('entry', 0)
            if not spell_id:
                continue
            
            result = classify_spell(spell, keystone_spells)
            if result[0] is None:
                continue
            
            category, subcategory, pvp_flags, is_combat_ability, source_type, pvp_duration_cap, pvp_coefficient, notes = result
            
            # Escape strings for SQL
            subcategory_sql = f"'{subcategory}'" if subcategory else "NULL"
            pvp_flags_sql = f"'{pvp_flags}'" if pvp_flags else "NULL"
            source_type_sql = f"'{source_type}'" if source_type else "NULL"
            notes_escaped = notes.replace("'", "''") if notes else "NULL"
            notes_sql = f"'{notes_escaped}'" if notes else "NULL"
            pvp_duration_cap_sql = f"{pvp_duration_cap}" if pvp_duration_cap else "NULL"
            
            f.write(f"INSERT INTO mortal_spell_tags "
                   f"(spell_id, category, subcategory, pvp_flags, source_type, "
                   f"is_combat_ability, pvp_duration_cap_seconds, pvp_coefficient_modifier, notes) "
                   f"VALUES ({spell_id}, '{category}', {subcategory_sql}, {pvp_flags_sql}, {source_type_sql}, "
                   f"{1 if is_combat_ability else 0}, {pvp_duration_cap_sql}, {pvp_coefficient}, {notes_sql}) "
                   f"ON DUPLICATE KEY UPDATE "
                   f"category = '{category}', "
                   f"subcategory = {subcategory_sql}, "
                   f"pvp_flags = {pvp_flags_sql}, "
                   f"source_type = {source_type_sql}, "
                   f"is_combat_ability = {1 if is_combat_ability else 0}, "
                   f"pvp_duration_cap_seconds = {pvp_duration_cap_sql}, "
                   f"pvp_coefficient_modifier = {pvp_coefficient}, "
                   f"notes = {notes_sql};\n")
        
        # Update statistics
        f.write("\n-- Update statistics\n")
        f.write("UPDATE mortal_conversion_stats SET stat_value = "
               f"(SELECT COUNT(*) FROM mortal_spell_tags), "
               f"last_updated = UNIX_TIMESTAMP() "
               f"WHERE stat_key = 'spells_classified';\n")

def main():
    parser = argparse.ArgumentParser(description='Classify spells for Mortal Warcraft conversion')
    parser.add_argument('--input', default='data/spells_raw.csv',
                       help='Input CSV file (default: data/spells_raw.csv)')
    parser.add_argument('--output', default='spell_tags.sql',
                       help='Output SQL file (default: spell_tags.sql)')
    parser.add_argument('--keystones', default='data/keystone_spells.txt',
                       help='Keystone spells override file (default: data/keystone_spells.txt)')
    
    args = parser.parse_args()
    
    # Load keystone spells
    keystone_spells = load_keystone_spells(args.keystones)
    print(f"Loaded {len(keystone_spells)} keystone spells from {args.keystones}")
    
    # Load spells from CSV
    spells = []
    input_path = Path(args.input)
    if not input_path.exists():
        print(f"Error: Input file {args.input} not found")
        print("Please export spell_template from your database first")
        print("Use: python3 tools/export_db_tables.py --table spell_template --output data/spells_raw.csv")
        return 1
    
    with open(input_path, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        spells = list(reader)
    
    print(f"Loaded {len(spells)} spells from {args.input}")
    
    # Generate SQL
    generate_sql(spells, keystone_spells, args.output)
    print(f"Generated SQL file: {args.output}")
    print(f"Run: mysql -u root -p world < {args.output}")
    
    return 0

if __name__ == '__main__':
    exit(main())

