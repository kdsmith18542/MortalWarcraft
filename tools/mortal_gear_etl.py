#!/usr/bin/env python3
"""
Project Mortal Warcraft
Tool: Mortal Gear ETL Pipeline
Description: Generates Mortal items from WotLK visuals with proper stat budgets
Based on: docs/specs/27-gear-stats-and-etl.md
"""

import csv
import sys
import argparse
from dataclasses import dataclass
from typing import Optional, Dict, List, Tuple

# ============================================================================
# Configuration: Tier Attribute Budgets
# ============================================================================

TIER_ATTR_BUDGET = {
    # (tier, slot): attribute points
    ("M-T1", "head"): 10,
    ("M-T1", "shoulders"): 8,
    ("M-T1", "chest"): 12,
    ("M-T1", "hands"): 8,
    ("M-T1", "legs"): 12,
    ("M-T1", "belt"): 6,
    ("M-T1", "boots"): 6,
    ("M-T1", "bracers"): 4,
    
    ("M-T2", "head"): 15,
    ("M-T2", "shoulders"): 12,
    ("M-T2", "chest"): 18,
    ("M-T2", "hands"): 12,
    ("M-T2", "legs"): 18,
    ("M-T2", "belt"): 9,
    ("M-T2", "boots"): 9,
    ("M-T2", "bracers"): 7,
    
    ("M-T3", "head"): 20,
    ("M-T3", "shoulders"): 16,
    ("M-T3", "chest"): 24,
    ("M-T3", "hands"): 16,
    ("M-T3", "legs"): 24,
    ("M-T3", "belt"): 12,
    ("M-T3", "boots"): 12,
    ("M-T3", "bracers"): 8,
    
    ("M-T4", "head"): 25,
    ("M-T4", "shoulders"): 20,
    ("M-T4", "chest"): 30,
    ("M-T4", "hands"): 20,
    ("M-T4", "legs"): 30,
    ("M-T4", "belt"): 15,
    ("M-T4", "boots"): 15,
    ("M-T4", "bracers"): 10,
    
    ("M-T5", "head"): 28,
    ("M-T5", "shoulders"): 23,
    ("M-T5", "chest"): 34,
    ("M-T5", "hands"): 23,
    ("M-T5", "legs"): 34,
    ("M-T5", "belt"): 17,
    ("M-T5", "boots"): 17,
    ("M-T5", "bracers"): 12,
    
    # PvP tiers map to similar budgets
    ("P1", "head"): 10,
    ("P2", "head"): 12,
    ("P3", "head"): 15,
    ("P4", "head"): 20,
    ("P5", "head"): 25,
    ("P6", "head"): 28,
    # ... (apply same pattern for other slots)
}

# ============================================================================
# Configuration: Armor Budgets
# ============================================================================

ARMOR_BUDGET = {
    # (tier, armor_type, slot): armor value
    ("M-T1", "plate", "chest"): 350,
    ("M-T2", "plate", "chest"): 450,
    ("M-T3", "plate", "chest"): 550,
    ("M-T4", "plate", "chest"): 650,
    ("M-T5", "plate", "chest"): 725,
    
    ("M-T1", "mail", "chest"): 300,
    ("M-T2", "mail", "chest"): 375,
    ("M-T3", "mail", "chest"): 450,
    ("M-T4", "mail", "chest"): 525,
    ("M-T5", "mail", "chest"): 580,
    
    ("M-T1", "leather", "chest"): 250,
    ("M-T2", "leather", "chest"): 325,
    ("M-T3", "leather", "chest"): 400,
    ("M-T4", "leather", "chest"): 475,
    ("M-T5", "leather", "chest"): 520,
    
    ("M-T1", "cloth", "chest"): 200,
    ("M-T2", "cloth", "chest"): 260,
    ("M-T3", "cloth", "chest"): 320,
    ("M-T4", "cloth", "chest"): 380,
    ("M-T5", "cloth", "chest"): 410,
    # ... (smaller slots use 40-50% of chest)
}

# ============================================================================
# Configuration: Role Distribution Patterns
# ============================================================================

ROLE_DISTRIBUTION = {
    # (armor_type, role): {attribute: fraction}
    ("plate", "offense"): {"str": 0.5, "sta": 0.3, "agi": 0.2},
    ("plate", "defense"): {"sta": 0.6, "str": 0.25, "spi": 0.15},
    ("mail", "offense"): {"agi": 0.5, "sta": 0.3, "str": 0.2},
    ("mail", "defense"): {"sta": 0.5, "str": 0.3, "agi": 0.2},
    ("leather", "offense"): {"agi": 0.6, "sta": 0.4},
    ("leather", "defense"): {"sta": 0.6, "agi": 0.4},
    ("cloth", "caster"): {"int": 0.6, "sta": 0.25, "spi": 0.15},
    ("cloth", "healer"): {"int": 0.4, "spi": 0.4, "sta": 0.2},
}

# ============================================================================
# Configuration: Tier Skill Requirements
# ============================================================================

TIER_SKILL_RANK = {
    "M-T1": 25,
    "M-T2": 50,
    "M-T3": 75,
    "M-T4": 100,
    "M-T5": 125,
    "P1": 25,
    "P2": 35,
    "P3": 50,
    "P4": 75,
    "P5": 100,
    "P6": 125,
}

# ============================================================================
# Configuration: Armor Mastery Skill IDs
# ============================================================================

ARMOR_MASTERY_SKILL_ID = {
    "plate": 8000,
    "mail": 8001,
    "leather": 8002,
    "cloth": 8003,
}

# ============================================================================
# Data Classes
# ============================================================================

@dataclass
class GearRow:
    mortal_item_entry: int
    mortal_tier: str
    category: str
    armor_type: str
    slot: str
    role: str
    source_type: str
    source_item_entry: int
    displayid: Optional[int]
    notes: str

# ============================================================================
# Helper Functions
# ============================================================================

def compute_attributes(row: GearRow) -> Dict[str, int]:
    """Compute attribute distribution based on tier, slot, and role."""
    key = (row.mortal_tier, row.slot)
    budget = TIER_ATTR_BUDGET.get(key, 10)  # Default to 10 if not found
    
    dist_key = (row.armor_type, row.role)
    dist = ROLE_DISTRIBUTION.get(dist_key, {"sta": 0.5, "str": 0.5})  # Default balanced
    
    attrs = {}
    remaining = budget
    
    items = list(dist.items())
    for i, (attr, frac) in enumerate(items):
        if i == len(items) - 1:
            attrs[attr] = remaining
        else:
            val = int(round(budget * frac))
            attrs[attr] = val
            remaining -= val
    
    return attrs

def compute_armor(row: GearRow) -> int:
    """Compute armor value based on tier, armor_type, and slot."""
    key = (row.mortal_tier, row.armor_type, row.slot)
    armor = ARMOR_BUDGET.get(key, 0)
    
    # If slot not found, try chest and scale down
    if armor == 0:
        chest_key = (row.mortal_tier, row.armor_type, "chest")
        chest_armor = ARMOR_BUDGET.get(chest_key, 0)
        if chest_armor > 0:
            # Smaller slots are 40-50% of chest
            slot_scale = {
                "head": 0.5,
                "shoulders": 0.45,
                "hands": 0.4,
                "legs": 0.5,
                "belt": 0.35,
                "boots": 0.4,
                "bracers": 0.3,
            }
            armor = int(chest_armor * slot_scale.get(row.slot, 0.4))
    
    return armor

def get_stat_type_id(attr: str) -> int:
    """Map attribute name to AzerothCore stat_type ID."""
    mapping = {
        "str": 0,  # STAT_STRENGTH
        "agi": 1,  # STAT_AGILITY
        "sta": 3,  # STAT_STAMINA
        "int": 4,  # STAT_INTELLECT
        "spi": 5,  # STAT_SPIRIT
    }
    return mapping.get(attr.lower(), 0)

def get_inventory_type(slot: str) -> int:
    """Map slot name to AzerothCore InventoryType."""
    mapping = {
        "head": 1,      # INVTYPE_HEAD
        "shoulders": 3, # INVTYPE_SHOULDERS
        "chest": 5,    # INVTYPE_CHEST
        "hands": 10,   # INVTYPE_HANDS
        "legs": 7,     # INVTYPE_LEGS
        "belt": 6,     # INVTYPE_WAIST
        "boots": 8,    # INVTYPE_FEET
        "bracers": 9,  # INVTYPE_WRISTS
    }
    return mapping.get(slot.lower(), 5)

def get_item_class_subclass(armor_type: str) -> Tuple[int, int]:
    """Map armor_type to AzerothCore item class and subclass."""
    # ITEM_CLASS_ARMOR = 4
    mapping = {
        "plate": (4, 4),   # ITEM_SUBCLASS_ARMOR_PLATE
        "mail": (4, 3),    # ITEM_SUBCLASS_ARMOR_MAIL
        "leather": (4, 2), # ITEM_SUBCLASS_ARMOR_LEATHER
        "cloth": (4, 1),   # ITEM_SUBCLASS_ARMOR_CLOTH
    }
    return mapping.get(armor_type.lower(), (4, 1))

# ============================================================================
# Main ETL Logic
# ============================================================================

def load_csv(filename: str) -> List[GearRow]:
    """Load gear visual mapping CSV."""
    rows = []
    with open(filename, 'r', newline='') as f:
        reader = csv.DictReader(f)
        for r in reader:
            displayid = int(r["displayid"]) if r.get("displayid") and r["displayid"].strip() else None
            rows.append(GearRow(
                mortal_item_entry=int(r["mortal_item_entry"]),
                mortal_tier=r["mortal_tier"],
                category=r["category"],
                armor_type=r["armor_type"],
                slot=r["slot"],
                role=r["role"],
                source_type=r["source_type"],
                source_item_entry=int(r["source_item_entry"]),
                displayid=displayid,
                notes=r.get("notes", ""),
            ))
    return rows

def backfill_displayid(rows: List[GearRow], db_config: Dict) -> None:
    """Backfill displayid from database if missing."""
    try:
        import mysql.connector
    except ImportError:
        print("Warning: mysql-connector-python not installed. Skipping displayid backfill.")
        print("Install with: pip install mysql-connector-python")
        return
    
    try:
        db = mysql.connector.connect(**db_config)
        cur = db.cursor()
        
        for row in rows:
            if row.displayid is None:
                cur.execute(
                    "SELECT displayid FROM item_template WHERE entry = %s",
                    (row.source_item_entry,)
                )
                result = cur.fetchone()
                if result:
                    row.displayid = int(result[0])
                    print(f"Backfilled displayid {row.displayid} for item {row.mortal_item_entry}")
                else:
                    print(f"Warning: No item_template found for entry {row.source_item_entry}")
        
        db.close()
    except Exception as e:
        print(f"Error backfilling displayid: {e}")

def generate_sql(rows: List[GearRow]) -> Tuple[List[str], List[str]]:
    """Generate SQL INSERT statements."""
    item_template_inserts = []
    visual_inserts = []
    
    for row in rows:
        if row.displayid is None:
            print(f"Warning: Skipping item {row.mortal_item_entry} - no displayid")
            continue
        
        # Compute stats
        attrs = compute_attributes(row)
        armor = compute_armor(row)
        skill_rank = TIER_SKILL_RANK.get(row.mortal_tier, 25)
        skill_id = ARMOR_MASTERY_SKILL_ID.get(row.armor_type, 8000)
        
        # Build item name
        tier_name = row.mortal_tier.replace("-", " ")
        armor_name = row.armor_type.capitalize()
        slot_name = row.slot.capitalize()
        name = f"Mortal {tier_name} {armor_name} {slot_name}"
        
        # Get item class/subclass
        item_class, item_subclass = get_item_class_subclass(row.armor_type)
        inventory_type = get_inventory_type(row.slot)
        
        # Build stat columns
        stat_pairs = []
        for attr, value in attrs.items():
            if value > 0:
                stat_type = get_stat_type_id(attr)
                stat_pairs.append((stat_type, value))
        
        # Build item_template INSERT
        stat_cols = []
        stat_vals = []
        for i, (stat_type, stat_value) in enumerate(stat_pairs[:10]):  # Max 10 stats
            stat_cols.append(f"stat_type{i+1}, stat_value{i+1}")
            stat_vals.append(f"{stat_type}, {stat_value}")
        
        # Fill remaining stat slots with 0
        for i in range(len(stat_pairs), 10):
            stat_cols.append(f"stat_type{i+1}, stat_value{i+1}")
            stat_vals.append("0, 0")
        
        stat_cols_str = ", ".join(stat_cols)
        stat_vals_str = ", ".join(stat_vals)
        
        item_sql = f"""-- Item {row.mortal_item_entry}: {name}
INSERT INTO item_template (
    entry, name, displayid, class, subclass, InventoryType, Quality, RequiredLevel,
    RequiredSkill, RequiredSkillRank, Armor, StatsCount, {stat_cols_str}
) VALUES (
    {row.mortal_item_entry}, '{name}', {row.displayid}, {item_class}, {item_subclass},
    {inventory_type}, 4, 1, {skill_id}, {skill_rank}, {armor}, {len(stat_pairs)}, {stat_vals_str}
);"""
        
        item_template_inserts.append(item_sql)
        
        # Build visual INSERT
        visual_sql = f"""INSERT INTO mortal_gear_visuals (
    mortal_item_entry, mortal_tier, category, armor_type, slot, role, source_type,
    source_item_entry, displayid, notes
) VALUES (
    {row.mortal_item_entry}, '{row.mortal_tier}', '{row.category}', '{row.armor_type}',
    '{row.slot}', '{row.role}', '{row.source_type}', {row.source_item_entry},
    {row.displayid}, '{row.notes.replace("'", "''")}'
);"""
        
        visual_inserts.append(visual_sql)
    
    return item_template_inserts, visual_inserts

def main():
    parser = argparse.ArgumentParser(description="Mortal Gear ETL Pipeline")
    parser.add_argument("input_csv", help="Input CSV file (mortal_gear_visuals_seed.csv)")
    parser.add_argument("--output-items", default="out/mortal_item_template.sql",
                       help="Output SQL file for item_template")
    parser.add_argument("--output-visuals", default="out/mortal_gear_visuals.sql",
                       help="Output SQL file for mortal_gear_visuals")
    parser.add_argument("--db-host", default="localhost", help="Database host")
    parser.add_argument("--db-user", default="root", help="Database user")
    parser.add_argument("--db-password", default="", help="Database password")
    parser.add_argument("--db-name", default="azerothcore_world", help="Database name")
    parser.add_argument("--skip-backfill", action="store_true",
                       help="Skip displayid backfill from database")
    
    args = parser.parse_args()
    
    # Load CSV
    print(f"Loading CSV: {args.input_csv}")
    rows = load_csv(args.input_csv)
    print(f"Loaded {len(rows)} rows")
    
    # Backfill displayid if needed
    if not args.skip_backfill:
        db_config = {
            "host": args.db_host,
            "user": args.db_user,
            "password": args.db_password,
            "database": args.db_name,
        }
        print("Backfilling displayid from database...")
        backfill_displayid(rows, db_config)
    
    # Generate SQL
    print("Generating SQL...")
    item_inserts, visual_inserts = generate_sql(rows)
    
    # Write output files
    import os
    os.makedirs("out", exist_ok=True)
    
    with open(args.output_items, "w") as f:
        f.write("-- ==================================================\n")
        f.write("-- Project Mortal Warcraft\n")
        f.write("-- Generated by mortal_gear_etl.py\n")
        f.write("-- ==================================================\n\n")
        f.write("\n".join(item_inserts))
    
    with open(args.output_visuals, "w") as f:
        f.write("-- ==================================================\n")
        f.write("-- Project Mortal Warcraft\n")
        f.write("-- Generated by mortal_gear_etl.py\n")
        f.write("-- ==================================================\n\n")
        f.write("\n".join(visual_inserts))
    
    print(f"Generated {len(item_inserts)} item_template inserts")
    print(f"Generated {len(visual_inserts)} visual inserts")
    print(f"Output files:")
    print(f"  - {args.output_items}")
    print(f"  - {args.output_visuals}")

if __name__ == "__main__":
    main()

