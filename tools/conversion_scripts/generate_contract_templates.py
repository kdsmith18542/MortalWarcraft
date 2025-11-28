#!/usr/bin/env python3
"""
Mortal Warcraft Contract Template Generator

Generates contract templates from legacy quests based on Spec 63 classification.
Converts quest objectives into contract templates for Task Board and World Contracts.

Usage:
    python3 generate_contract_templates.py [--input data/quests_classified.csv] [--output contract_templates.sql]
"""

import csv
import argparse
import json
from pathlib import Path

def classify_quest_objectives(quest):
    """Classify quest objectives into contract types."""
    objectives = []
    
    # Check quest objectives (would need quest_template export)
    # For now, use heuristics based on quest type
    
    quest_type = quest.get('Type', 0)
    
    if quest_type == 1:  # KILL
        objectives.append({
            'type': 'KILL',
            'target_entry': quest.get('RequiredNpcOrGo1', 0),
            'count': quest.get('RequiredNpcOrGoCount1', 0)
        })
    elif quest_type == 2:  # ITEM
        objectives.append({
            'type': 'COLLECT',
            'item_entry': quest.get('RequiredItemId1', 0),
            'count': quest.get('RequiredItemCount1', 0)
        })
    elif quest_type == 3:  # EXPLORE
        objectives.append({
            'type': 'EXPLORE',
            'area_id': quest.get('RequiredSpellCast1', 0)
        })
    
    return objectives

def generate_contract_template(quest, conversion_type):
    """Generate contract template from quest."""
    quest_id = quest.get('entry', 0) or quest.get('Id', 0)
    quest_name = quest.get('Title', 'Unknown Quest')
    quest_level = quest.get('QuestLevel', 1)
    zone_id = quest.get('ZoneOrSort', 0)
    
    # Determine contract type
    if conversion_type == 'CONTRACT_BOARD':
        contract_type = 'TASK_BOARD'
    elif conversion_type == 'CONTRACT_LOCAL':
        contract_type = 'LOCAL_CONTRACT'
    else:
        return None
    
    # Get objectives
    objectives = classify_quest_objectives(quest)
    
    # Determine risk tier (would need zone risk data)
    risk_tier = 'GREEN'  # Default
    
    # Generate contract template SQL
    template = {
        'quest_id': quest_id,
        'name': quest_name.replace("'", "''"),
        'contract_type': contract_type,
        'zone_id': zone_id,
        'level_min': max(1, quest_level - 5),
        'level_max': quest_level + 5,
        'risk_tier': risk_tier,
        'objectives_json': json.dumps(objectives),
        'reward_gold': quest.get('RewOrReqMoney', 0) * 0.5,  # Scaled for Mortal economy
        'reward_materials': True
    }
    
    return template

def generate_sql(templates, output_file):
    """Generate SQL INSERT statements for contract templates."""
    with open(output_file, 'w') as f:
        f.write("-- Contract Templates - Generated from Quest Conversion\n")
        f.write("-- This file can be imported into the world database\n\n")
        
        for template in templates:
            if not template:
                continue
            
            f.write(f"INSERT INTO mortal_task_template "
                   f"(name, zone_id, level_min, level_max, risk_tier, objectives_json, "
                   f"reward_gold_base, reward_materials) "
                   f"VALUES ("
                   f"'{template['name']}', "
                   f"{template['zone_id']}, "
                   f"{template['level_min']}, "
                   f"{template['level_max']}, "
                   f"'{template['risk_tier']}', "
                   f"'{template['objectives_json']}', "
                   f"{template['reward_gold']}, "
                   f"{1 if template['reward_materials'] else 0}"
                   f") "
                   f"ON DUPLICATE KEY UPDATE "
                   f"name = '{template['name']}', "
                   f"zone_id = {template['zone_id']}, "
                   f"level_min = {template['level_min']}, "
                   f"level_max = {template['level_max']}, "
                   f"risk_tier = '{template['risk_tier']}', "
                   f"objectives_json = '{template['objectives_json']}', "
                   f"reward_gold_base = {template['reward_gold']}, "
                   f"reward_materials = {1 if template['reward_materials'] else 0};\n")
        
        # Update statistics
        f.write("\n-- Update statistics\n")
        f.write("UPDATE mortal_conversion_stats SET stat_value = "
               f"(SELECT COUNT(*) FROM mortal_task_template), "
               f"last_updated = UNIX_TIMESTAMP() "
               f"WHERE stat_key = 'contract_templates_generated';\n")

def main():
    parser = argparse.ArgumentParser(description='Generate contract templates from quest conversions')
    parser.add_argument('--input', default='data/quests_classified.csv',
                       help='Input CSV file with quest classifications (default: data/quests_classified.csv)')
    parser.add_argument('--output', default='contract_templates.sql',
                       help='Output SQL file (default: contract_templates.sql)')
    
    args = parser.parse_args()
    
    # Load quest conversions
    quest_conversions = {}
    conversion_path = Path('data/quest_conversions.csv')
    if conversion_path.exists():
        with open(conversion_path, 'r', encoding='utf-8') as f:
            reader = csv.DictReader(f)
            for row in reader:
                quest_id = int(row.get('quest_id', 0))
                conversion_type = row.get('conversion_type', 'FLAVOR')
                quest_conversions[quest_id] = conversion_type
    
    # Load quests
    templates = []
    input_path = Path(args.input)
    if not input_path.exists():
        print(f"Error: Input file {args.input} not found")
        print("Please export quest_template from your database first")
        return 1
    
    with open(input_path, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for quest in reader:
            quest_id = int(quest.get('entry', 0) or quest.get('Id', 0))
            conversion_type = quest_conversions.get(quest_id, 'FLAVOR')
            
            if conversion_type in ['CONTRACT_BOARD', 'CONTRACT_LOCAL']:
                template = generate_contract_template(quest, conversion_type)
                if template:
                    templates.append(template)
    
    print(f"Generated {len(templates)} contract templates")
    
    # Generate SQL
    generate_sql(templates, args.output)
    print(f"Generated SQL file: {args.output}")
    print(f"Run: mysql -u root -p world < {args.output}")
    
    return 0

if __name__ == '__main__':
    exit(main())

