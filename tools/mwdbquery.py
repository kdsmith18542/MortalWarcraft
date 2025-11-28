#!/usr/bin/env python3
"""
Mortal Warcraft - General Purpose Database Query Tool
Description: Query AzerothCore database for creatures, items, quests, and other design data
Usage:
    # Creatures
    python3 mwdbquery.py creature --name "Lich King"
    python3 mwdbquery.py creature --entry 36597 --full
    python3 mwdbquery.py creature --name "Kazzak" --format sql
    
    # Items
    python3 mwdbquery.py item --name "Heroes'" --armor plate --slot chest
    python3 mwdbquery.py item --entry 39606
    python3 mwdbquery.py item --tier t7 --format json
    
    # Quests
    python3 mwdbquery.py quest --name "Defias"
    python3 mwdbquery.py quest --entry 12345
"""

import argparse
import sys
import os
import json
from typing import Optional, Dict, List
from dataclasses import dataclass

try:
    import mysql.connector
    from mysql.connector import Error
except ImportError:
    print("Error: mysql-connector-python not installed.")
    print("Install with: pip install mysql-connector-python")
    sys.exit(1)


@dataclass
class DBConfig:
    """Database configuration."""
    host: str = "127.0.0.1"
    port: int = 3306
    user: str = "root"
    password: str = ""
    database: str = "azerothcore_world"

    @classmethod
    def from_env(cls) -> "DBConfig":
        """Load config from environment variables."""
        return cls(
            host=os.getenv("DB_HOST", "127.0.0.1"),
            port=int(os.getenv("DB_PORT", "3306")),
            user=os.getenv("DB_USER", "root"),
            password=os.getenv("DB_PASS", ""),
            database=os.getenv("DB_NAME", "azerothcore_world"),
        )

    @classmethod
    def from_worldserver_conf(cls, conf_path: str = "azerothcore/bin/etc/worldserver.conf") -> "DBConfig":
        """Load config from worldserver.conf file."""
        config = cls()
        try:
            with open(conf_path, 'r') as f:
                for line in f:
                    line = line.strip()
                    if line.startswith('WorldDatabaseInfo') and '=' in line:
                        parts = line.split('=')[1].strip().strip('"').split(';')
                        if len(parts) >= 5:
                            config.host = parts[0]
                            config.port = int(parts[1])
                            config.user = parts[2]
                            config.password = parts[3]
                            config.database = parts[4] if len(parts) > 4 else config.database
                        break
        except FileNotFoundError:
            pass
        return config


class MWDBQuery:
    """General-purpose database query tool for Mortal Warcraft."""
    
    def __init__(self, db_config: DBConfig):
        self.config = db_config
        self.connection = None
    
    def connect(self):
        """Connect to database."""
        try:
            self.connection = mysql.connector.connect(
                host=self.config.host,
                port=self.config.port,
                user=self.config.user,
                password=self.config.password,
                database=self.config.database,
                charset='utf8mb4'
            )
            return True
        except Error as e:
            print(f"Error connecting to database: {e}")
            return False
    
    def disconnect(self):
        """Disconnect from database."""
        if self.connection and self.connection.is_connected():
            self.connection.close()
    
    def _has_table(self, table_name: str) -> bool:
        """Check if a table exists."""
        if not self.connection:
            return False
        try:
            cursor = self.connection.cursor()
            cursor.execute("""
                SELECT COUNT(*) as count 
                FROM information_schema.tables 
                WHERE table_schema = DATABASE() 
                AND table_name = %s
            """, (table_name,))
            result = cursor.fetchone()
            cursor.close()
            return result[0] > 0
        except:
            return False
    
    def query_creature(self, entry: Optional[int] = None, name: Optional[str] = None, full: bool = False) -> List[Dict]:
        """Query creature_template."""
        if not self.connection:
            if not self.connect():
                return []
        
        has_model_table = self._has_table('creature_template_model')
        
        # Base fields
        base_fields = """
            ct.entry, ct.name, ct.subname, ct.minlevel, ct.maxlevel,
            ct.faction, ct.npcflag, ct.rank, ct.type, ct.type_flags,
            ct.scale, ct.dmgschool, ct.lootid
        """
        
        # Design-relevant stat fields
        design_fields = """
            , ct.HealthModifier, ct.ManaModifier, ct.ArmorModifier,
            ct.DamageModifier, ct.BaseAttackTime, ct.RangeAttackTime,
            ct.speed_walk, ct.speed_run, ct.speed_swim, ct.speed_flight,
            ct.detection_range
        """ if full else ""
        
        if has_model_table:
            display_field = "GROUP_CONCAT(ctm.CreatureDisplayID ORDER BY ctm.Idx) as display_ids"
            query = f"""
                SELECT {base_fields}, {display_field}{design_fields}
                FROM creature_template ct
                LEFT JOIN creature_template_model ctm ON ct.entry = ctm.CreatureID
                WHERE {'ct.entry = %s' if entry else 'ct.name LIKE %s'}
                {'GROUP BY ct.entry, ct.name, ct.subname, ct.minlevel, ct.maxlevel, '
                 'ct.faction, ct.npcflag, ct.rank, ct.type, ct.type_flags, '
                 'ct.scale, ct.dmgschool, ct.lootid' + (', ct.HealthModifier, ct.ManaModifier, '
                 'ct.ArmorModifier, ct.DamageModifier, ct.BaseAttackTime, ct.RangeAttackTime, '
                 'ct.speed_walk, ct.speed_run, ct.speed_swim, ct.speed_flight, ct.detection_range' if full else '') if has_model_table else ''}
                ORDER BY ct.entry
                LIMIT 50
            """
        else:
            display_fields = "modelid1, modelid2, modelid3, modelid4, displayid1, displayid2, displayid3, displayid4"
            query = f"""
                SELECT {base_fields.replace('ct.', '')}, {display_fields}{design_fields.replace('ct.', '')}
                FROM creature_template
                WHERE {'entry = %s' if entry else 'name LIKE %s'}
                ORDER BY entry
                LIMIT 50
            """
        
        try:
            cursor = self.connection.cursor(dictionary=True)
            param = entry if entry else f'%{name}%'
            cursor.execute(query, (param,))
            results = cursor.fetchall()
            cursor.close()
            return results
        except Error as e:
            print(f"Error querying creatures: {e}")
            return []
    
    def query_item(self, entry: Optional[int] = None, name: Optional[str] = None,
                   armor_type: Optional[str] = None, slot: Optional[str] = None,
                   tier: Optional[str] = None, full: bool = False) -> List[Dict]:
        """Query item_template."""
        if not self.connection:
            if not self.connect():
                return []
        
        # Base fields
        base_fields = """
            entry, name, displayid, class, subclass, Quality, ItemLevel,
            RequiredLevel, armor, InventoryType, bonding, description,
            Flags, FlagsExtra, BuyCount, BuyPrice, SellPrice
        """
        
        # Design-relevant fields for full query
        design_fields = """
            , stat_type1, stat_value1, stat_type2, stat_value2,
            stat_type3, stat_value3, stat_type4, stat_value4,
            stat_type5, stat_value5, stat_type6, stat_value6,
            stat_type7, stat_value7, stat_type8, stat_value8,
            stat_type9, stat_value9, stat_type10, stat_value10,
            socketColor_1, socketColor_2, socketColor_3,
            socketContent_1, socketContent_2, socketContent_3,
            socketBonus, spellid_1, spelltrigger_1, spellcharges_1,
            spellid_2, spelltrigger_2, spellcharges_2,
            spellid_3, spelltrigger_3, spellcharges_3,
            spellid_4, spelltrigger_4, spellcharges_4,
            spellid_5, spelltrigger_5, spellcharges_5,
            MaxDurability, RequiredDisenchantSkill,
            AllowableClass, AllowableRace, ItemLimitCategory,
            MaxCount, Stackable, ContainerSlots
        """ if full else ""
        
        query = f"""
            SELECT {base_fields}{design_fields}
            FROM item_template
            WHERE """ + ('entry = %s' if entry else 'name LIKE %s')
        
        params = [entry if entry else f'%{name}%']
        
        # Armor type filter
        armor_map = {'cloth': 1, 'leather': 2, 'mail': 3, 'plate': 4}
        if armor_type and armor_type.lower() in armor_map:
            query += " AND subclass = %s"
            params.append(armor_map[armor_type.lower()])
        
        # Slot filter
        slot_map = {
            'head': 1, 'neck': 2, 'shoulder': 3, 'chest': 5, 'waist': 6,
            'legs': 7, 'feet': 8, 'wrist': 9, 'hands': 10, 'finger': 11,
            'trinket': 12, 'onehand': 13, 'shield': 14, 'ranged': 15,
            'back': 16, 'twohand': 17, 'bag': 18, 'tabard': 19, 'robe': 20,
            'mainhand': 21, 'offhand': 22
        }
        if slot and slot.lower() in slot_map:
            query += " AND InventoryType = %s"
            params.append(slot_map[slot.lower()])
        
        # Tier filter
        if tier:
            tier_patterns = {'t7': "Heroes'", 't8': "Ulduar", 't9': "Triumph", 't10': "Sanctified"}
            if tier.lower() in tier_patterns:
                query += " AND name LIKE %s"
                params.append(f"%{tier_patterns[tier.lower()]}%")
        
        query += " ORDER BY entry LIMIT 100"
        
        try:
            cursor = self.connection.cursor(dictionary=True)
            cursor.execute(query, params)
            results = cursor.fetchall()
            cursor.close()
            return results
        except Error as e:
            print(f"Error querying items: {e}")
            return []
    
    def query_quest(self, entry: Optional[int] = None, name: Optional[str] = None) -> List[Dict]:
        """Query quest_template."""
        if not self.connection:
            if not self.connect():
                return []
        
        query = """
            SELECT entry, QuestLevel, MinLevel, QuestSortID, QuestInfoID,
                   SuggestedGroupNum, RequiredFactionId1, RequiredFactionId2,
                   RequiredFactionValue1, RequiredFactionValue2, RewardMoney,
                   RewardXP, Title, Objectives, Details, OfferRewardText
            FROM quest_template
            WHERE """ + ('entry = %s' if entry else 'Title LIKE %s')
        
        param = entry if entry else f'%{name}%'
        
        try:
            cursor = self.connection.cursor(dictionary=True)
            cursor.execute(query, (param,))
            results = cursor.fetchall()
            cursor.close()
            return results
        except Error as e:
            print(f"Error querying quests: {e}")
            return []
    
    def format_output(self, results: List[Dict], format_type: str, query_type: str):
        """Format query results for output."""
        if not results:
            print("No results found.")
            return
        
        if format_type == "table":
            self._format_table(results, query_type)
        elif format_type == "json":
            print(json.dumps(results, indent=2, default=str))
        elif format_type == "sql":
            self._format_sql(results, query_type)
        elif format_type == "csv":
            self._format_csv(results, query_type)
        else:
            print(f"Unknown format: {format_type}")
    
    def _format_table(self, results: List[Dict], query_type: str):
        """Format as table."""
        if query_type == "creature":
            print(f"\nFound {len(results)} creature(s):\n")
            print(f"{'Entry':<10} {'Name':<40} {'Display IDs':<20} {'Level':<12} {'Faction':<8}")
            print("-" * 100)
            for r in results:
                display_ids = r.get('display_ids', 'N/A')
                if isinstance(display_ids, str) and ',' in display_ids:
                    display_ids = display_ids.split(',')[0] + '...'
                level = f"{r.get('minlevel', 0)}-{r.get('maxlevel', 0)}" if r.get('maxlevel', 0) > r.get('minlevel', 0) else str(r.get('minlevel', 0))
                name = (r.get('name', 'Unknown')[:37] + '...') if len(r.get('name', '')) > 40 else r.get('name', 'Unknown')
                print(f"{r.get('entry', 0):<10} {name:<40} {str(display_ids)[:18]:<20} {level:<12} {r.get('faction', 0):<8}")
            
            print("\nDetailed Information:")
            for r in results[:5]:  # Limit detailed output
                print(f"\nEntry: {r.get('entry', 0)}")
                print(f"  Name: {r.get('name', 'Unknown')}")
                if r.get('subname'):
                    print(f"  Subname: {r.get('subname')}")
                if r.get('display_ids'):
                    print(f"  Display IDs: {r.get('display_ids')}")
                print(f"  Level: {r.get('minlevel', 0)}-{r.get('maxlevel', 0)}")
                print(f"  Faction: {r.get('faction', 0)}")
                print(f"  Rank: {r.get('rank', 0)}")
                if r.get('HealthModifier'):
                    print(f"  Health Modifier: {r.get('HealthModifier')}")
                    print(f"  Damage Modifier: {r.get('DamageModifier')}")
        
        elif query_type == "item":
            print(f"\nFound {len(results)} item(s):\n")
            print(f"{'Entry':<8} {'DisplayID':<10} {'Name':<50} {'Quality':<3} {'ILvl':<5} {'Slot':<10} {'Flags':<8}")
            print("-" * 110)
            for r in results:
                slot_map = {1: 'head', 5: 'chest', 7: 'legs', 10: 'hands', 8: 'feet', 3: 'shoulder', 6: 'waist', 9: 'wrist', 11: 'finger', 12: 'trinket', 16: 'back'}
                slot = slot_map.get(r.get('InventoryType', 0), f"type{r.get('InventoryType', 0)}")
                name = (r.get('name', 'Unknown')[:48] + '...') if len(r.get('name', '')) > 50 else r.get('name', 'Unknown')
                flags = r.get('Flags', 0) or 0
                print(f"{r.get('entry', 0):<8} {r.get('displayid', 0):<10} {name:<50} {r.get('Quality', 0):<3} {r.get('ItemLevel', 0):<5} {slot:<10} {flags:<8}")
            
            # Show detailed info for first few results
            print("\nDetailed Information:")
            for r in results[:5]:
                print(f"\nEntry: {r.get('entry', 0)}")
                print(f"  Name: {r.get('name', 'Unknown')}")
                print(f"  Display ID: {r.get('displayid', 0)}")
                print(f"  Class: {r.get('class', 0)} (Subclass: {r.get('subclass', 0)})")
                print(f"  Quality: {r.get('Quality', 0)} | Item Level: {r.get('ItemLevel', 0)}")
                print(f"  Required Level: {r.get('RequiredLevel', 0)}")
                print(f"  Inventory Type: {r.get('InventoryType', 0)}")
                print(f"  Flags: {r.get('Flags', 0)} | FlagsExtra: {r.get('FlagsExtra', 0)}")
                print(f"  Bonding: {r.get('bonding', 0)}")
                if r.get('armor', 0):
                    print(f"  Armor: {r.get('armor', 0)}")
                
                # Show stats if available
                stats = []
                for i in range(1, 11):
                    stat_type = r.get(f'stat_type{i}', 0)
                    stat_value = r.get(f'stat_value{i}', 0)
                    if stat_type and stat_value:
                        stat_names = {0: 'STR', 1: 'AGI', 3: 'STA', 4: 'INT', 5: 'SPI', 6: 'ARMOR', 7: 'DAMAGE', 32: 'HIT', 36: 'HASTE', 38: 'EXPERTISE', 40: 'STRENGTH', 45: 'SPELL_POWER'}
                        stat_name = stat_names.get(stat_type, f'type{stat_type}')
                        stats.append(f"{stat_name}+{stat_value}")
                if stats:
                    print(f"  Stats: {', '.join(stats)}")
                
                # Show sockets if available
                sockets = []
                for i in range(1, 4):
                    socket_color = r.get(f'socketColor_{i}', 0)
                    if socket_color:
                        socket_names = {1: 'Meta', 2: 'Red', 4: 'Yellow', 8: 'Blue'}
                        socket_name = socket_names.get(socket_color, f'color{socket_color}')
                        sockets.append(socket_name)
                if sockets:
                    print(f"  Sockets: {', '.join(sockets)}")
                    if r.get('socketBonus', 0):
                        print(f"  Socket Bonus: {r.get('socketBonus', 0)}")
                
                # Show spells/enchants if available
                spells = []
                for i in range(1, 6):
                    spell_id = r.get(f'spellid_{i}', 0)
                    if spell_id:
                        trigger = r.get(f'spelltrigger_{i}', 0)
                        charges = r.get(f'spellcharges_{i}', 0)
                        trigger_names = {0: 'Use', 1: 'Equip', 2: 'Chance', 4: 'Socket'}
                        trigger_name = trigger_names.get(trigger, f'trig{trigger}')
                        spells.append(f"Spell {spell_id} ({trigger_name})")
                if spells:
                    print(f"  Spells/Enchants: {', '.join(spells)}")
        
        elif query_type == "quest":
            print(f"\nFound {len(results)} quest(s):\n")
            print(f"{'Entry':<8} {'Level':<6} {'Title':<60}")
            print("-" * 80)
            for r in results:
                title = (r.get('Title', 'Unknown')[:58] + '...') if len(r.get('Title', '')) > 60 else r.get('Title', 'Unknown')
                print(f"{r.get('entry', 0):<8} {r.get('QuestLevel', 0):<6} {title:<60}")
    
    def _format_sql(self, results: List[Dict], query_type: str):
        """Format as SQL."""
        if query_type == "creature":
            print("-- Creature Template Data")
            for r in results:
                print(f"-- Entry: {r.get('entry')}, Name: {r.get('name')}")
                if r.get('display_ids'):
                    print(f"UPDATE creature_template SET displayid1 = {r.get('display_ids', '').split(',')[0]} WHERE entry = {r.get('entry')};")
        elif query_type == "item":
            print("-- Item Template Data")
            for r in results:
                print(f"UPDATE item_template SET displayid = {r.get('displayid', 0)} WHERE entry = {r.get('entry')}; -- {r.get('name')}")
    
    def _format_csv(self, results: List[Dict], query_type: str):
        """Format as CSV."""
        if not results:
            return
        
        # Print header
        if query_type == "creature":
            print("entry,name,subname,display_ids,minlevel,maxlevel,faction,rank,HealthModifier,DamageModifier")
        elif query_type == "item":
            # Check if full data is available
            has_full = any('stat_type1' in r for r in results)
            if has_full:
                print("entry,name,displayid,class,subclass,quality,itemlevel,requiredlevel,armor,inventory_type,flags,flagsExtra,bonding,stat_type1,stat_value1,stat_type2,stat_value2,socketColor_1,socketColor_2,spellid_1")
            else:
                print("entry,name,displayid,class,subclass,quality,itemlevel,requiredlevel,armor,inventory_type,flags,bonding")
        elif query_type == "quest":
            print("entry,level,title,objectives,rewardMoney,rewardXP")
        
        # Print rows
        for r in results:
            if query_type == "creature":
                print(f"{r.get('entry', 0)},{r.get('name', '')},{r.get('subname', '')},"
                      f"{r.get('display_ids', '')},{r.get('minlevel', 0)},{r.get('maxlevel', 0)},"
                      f"{r.get('faction', 0)},{r.get('rank', 0)},{r.get('HealthModifier', 0)},{r.get('DamageModifier', 0)}")
            elif query_type == "item":
                has_full = 'stat_type1' in r
                if has_full:
                    print(f"{r.get('entry', 0)},\"{r.get('name', '')}\",{r.get('displayid', 0)},"
                          f"{r.get('class', 0)},{r.get('subclass', 0)},{r.get('Quality', 0)},"
                          f"{r.get('ItemLevel', 0)},{r.get('RequiredLevel', 0)},{r.get('armor', 0)},"
                          f"{r.get('InventoryType', 0)},{r.get('Flags', 0)},{r.get('FlagsExtra', 0)},"
                          f"{r.get('bonding', 0)},{r.get('stat_type1', 0)},{r.get('stat_value1', 0)},"
                          f"{r.get('stat_type2', 0)},{r.get('stat_value2', 0)},"
                          f"{r.get('socketColor_1', 0)},{r.get('socketColor_2', 0)},{r.get('spellid_1', 0)}")
                else:
                    print(f"{r.get('entry', 0)},\"{r.get('name', '')}\",{r.get('displayid', 0)},"
                          f"{r.get('class', 0)},{r.get('subclass', 0)},{r.get('Quality', 0)},"
                          f"{r.get('ItemLevel', 0)},{r.get('RequiredLevel', 0)},{r.get('armor', 0)},"
                          f"{r.get('InventoryType', 0)},{r.get('Flags', 0)},{r.get('bonding', 0)}")
            elif query_type == "quest":
                print(f"{r.get('entry', 0)},{r.get('QuestLevel', 0)},\"{r.get('Title', '')}\","
                      f"\"{r.get('Objectives', '')}\",{r.get('RewardMoney', 0)},{r.get('RewardXP', 0)}")


def main():
    parser = argparse.ArgumentParser(
        description='Mortal Warcraft Database Query Tool',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Query creatures
  python3 mwdbquery.py creature --name "Lich King"
  python3 mwdbquery.py creature --entry 36597 --full
  python3 mwdbquery.py creature --name "Kazzak" --format sql
  
  # Query items
  python3 mwdbquery.py item --name "Heroes'" --armor plate --slot chest
  python3 mwdbquery.py item --entry 39606 --full
  python3 mwdbquery.py item --tier t7 --format json --full
  
  # Query quests
  python3 mwdbquery.py quest --name "Defias"
  python3 mwdbquery.py quest --entry 12345
        """
    )
    
    subparsers = parser.add_subparsers(dest='type', help='Query type')
    
    # Creature parser
    creature_parser = subparsers.add_parser('creature', help='Query creatures')
    creature_parser.add_argument('--name', help='Search by name (partial match)')
    creature_parser.add_argument('--entry', type=int, help='Query by entry ID')
    creature_parser.add_argument('--full', action='store_true', help='Include full design stats')
    creature_parser.add_argument('--format', choices=['table', 'json', 'sql', 'csv'], default='table')
    
    # Item parser
    item_parser = subparsers.add_parser('item', help='Query items')
    item_parser.add_argument('--name', help='Search by name (partial match)')
    item_parser.add_argument('--entry', type=int, help='Query by entry ID')
    item_parser.add_argument('--armor', choices=['cloth', 'leather', 'mail', 'plate'], help='Filter by armor type')
    item_parser.add_argument('--slot', help='Filter by slot (head, chest, legs, etc.)')
    item_parser.add_argument('--tier', choices=['t7', 't8', 't9', 't10'], help='Filter by tier')
    item_parser.add_argument('--full', action='store_true', help='Include full design stats (stats, sockets, spells, flags)')
    item_parser.add_argument('--format', choices=['table', 'json', 'sql', 'csv'], default='table')
    
    # Quest parser
    quest_parser = subparsers.add_parser('quest', help='Query quests')
    quest_parser.add_argument('--name', help='Search by title (partial match)')
    quest_parser.add_argument('--entry', type=int, help='Query by entry ID')
    quest_parser.add_argument('--format', choices=['table', 'json', 'sql', 'csv'], default='table')
    
    # Common args
    parser.add_argument('--config', help='Path to worldserver.conf')
    parser.add_argument('--db-host', help='Database host')
    parser.add_argument('--db-port', type=int, help='Database port')
    parser.add_argument('--db-user', help='Database user')
    parser.add_argument('--db-pass', help='Database password')
    parser.add_argument('--db-name', help='Database name')
    
    args = parser.parse_args()
    
    if not args.type:
        parser.print_help()
        return 1
    
    # Load database config
    if args.config:
        db_config = DBConfig.from_worldserver_conf(args.config)
    else:
        db_config = DBConfig.from_worldserver_conf()
    
    if not db_config.password:
        db_config = DBConfig.from_env()
    
    # Override with command-line args
    if args.db_host:
        db_config.host = args.db_host
    if args.db_port:
        db_config.port = args.db_port
    if args.db_user:
        db_config.user = args.db_user
    if args.db_pass:
        db_config.password = args.db_pass
    if args.db_name:
        db_config.database = args.db_name
    
    # Create query tool
    tool = MWDBQuery(db_config)
    
    try:
        if args.type == 'creature':
            if not args.name and not args.entry:
                creature_parser.error("Must specify either --name or --entry")
            results = tool.query_creature(entry=args.entry, name=args.name, full=args.full)
            tool.format_output(results, args.format, 'creature')
        
        elif args.type == 'item':
            if not args.name and not args.entry:
                item_parser.error("Must specify either --name or --entry")
            results = tool.query_item(entry=args.entry, name=args.name,
                                     armor_type=args.armor, slot=args.slot, tier=args.tier, full=args.full)
            tool.format_output(results, args.format, 'item')
        
        elif args.type == 'quest':
            if not args.name and not args.entry:
                quest_parser.error("Must specify either --name or --entry")
            results = tool.query_quest(entry=args.entry, name=args.name)
            tool.format_output(results, args.format, 'quest')
        
        return 0
    
    finally:
        tool.disconnect()


if __name__ == '__main__':
    exit(main())

