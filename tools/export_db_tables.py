#!/usr/bin/env python3
"""
Mortal Warcraft Database Export Tool

Exports entire database tables to CSV files for conversion scripts.
Supports exporting quest_template, spell_template, item_template, creature_template, etc.

Usage:
    python3 tools/export_db_tables.py --table quest_template --output data/quests_raw.csv
    python3 tools/export_db_tables.py --all --output-dir data/
    python3 tools/export_db_tables.py --tables quest_template,item_template,creature_template --output-dir data/
"""

import argparse
import sys
import os
import csv
from pathlib import Path
from typing import Optional, List

try:
    import mysql.connector
    from mysql.connector import Error
except ImportError:
    print("Error: mysql-connector-python not installed.")
    print("Install with: pip install mysql-connector-python")
    sys.exit(1)


class DBConfig:
    """Database configuration."""
    def __init__(self, host="127.0.0.1", port=3306, user="root", password="", database="azerothcore_world"):
        self.host = host
        self.port = port
        self.user = user
        self.password = password
        self.database = database

    @classmethod
    def from_env(cls):
        """Load config from environment variables."""
        return cls(
            host=os.getenv("DB_HOST", "127.0.0.1"),
            port=int(os.getenv("DB_PORT", "3306")),
            user=os.getenv("DB_USER", "root"),
            password=os.getenv("DB_PASS", ""),
            database=os.getenv("DB_NAME", "azerothcore_world"),
        )

    @classmethod
    def from_worldserver_conf(cls, conf_path="azerothcore/bin/etc/worldserver.conf"):
        """Load config from worldserver.conf file."""
        config = cls()
        if os.path.exists(conf_path):
            with open(conf_path, 'r') as f:
                for line in f:
                    line = line.strip()
                    if line.startswith("WorldDatabaseInfo"):
                        # Format: "127.0.0.1;3306;root;password;database"
                        parts = line.split("=", 1)[1].strip().strip('"').split(";")
                        if len(parts) >= 5:
                            config.host = parts[0]
                            config.port = int(parts[1])
                            config.user = parts[2]
                            config.password = parts[3]
                            config.database = parts[4]
        return config


class DatabaseExporter:
    """Tool for exporting database tables to CSV."""

    def __init__(self, db_config: DBConfig):
        self.db_config = db_config
        self.conn = None

    def connect(self) -> bool:
        """Connect to database."""
        try:
            self.conn = mysql.connector.connect(
                host=self.db_config.host,
                port=self.db_config.port,
                user=self.db_config.user,
                password=self.db_config.password,
                database=self.db_config.database,
                charset='utf8mb4'
            )
            return True
        except Error as e:
            print(f"Error connecting to database: {e}")
            return False

    def close(self):
        """Close database connection."""
        if self.conn and self.conn.is_connected():
            self.conn.close()

    def export_table(self, table_name: str, output_file: str) -> bool:
        """Export a single table to CSV."""
        if not self.conn or not self.conn.is_connected():
            print("Error: Not connected to database")
            return False

        try:
            cursor = self.conn.cursor()
            
            # Get all columns from the table
            cursor.execute(f"DESCRIBE {table_name}")
            columns = [row[0] for row in cursor.fetchall()]
            
            if not columns:
                print(f"Error: Table {table_name} not found or has no columns")
                return False
            
            # Query all data
            query = f"SELECT * FROM {table_name}"
            cursor.execute(query)
            
            # Fetch all rows
            rows = cursor.fetchall()
            
            # Write to CSV
            output_path = Path(output_file)
            output_path.parent.mkdir(parents=True, exist_ok=True)
            
            with open(output_path, 'w', newline='', encoding='utf-8') as f:
                writer = csv.writer(f)
                # Write header
                writer.writerow(columns)
                # Write data
                writer.writerows(rows)
            
            print(f"Exported {len(rows)} rows from {table_name} to {output_file}")
            cursor.close()
            return True
            
        except Error as e:
            print(f"Error exporting {table_name}: {e}")
            return False

    def export_tables(self, table_names: List[str], output_dir: str) -> bool:
        """Export multiple tables to CSV files in a directory."""
        output_path = Path(output_dir)
        output_path.mkdir(parents=True, exist_ok=True)
        
        success = True
        for table_name in table_names:
            output_file = output_path / f"{table_name}_raw.csv"
            if not self.export_table(table_name, str(output_file)):
                success = False
        
        return success

    def get_table_list(self) -> List[str]:
        """Get list of all tables in the database."""
        if not self.conn or not self.conn.is_connected():
            return []
        
        try:
            cursor = self.conn.cursor()
            cursor.execute("SHOW TABLES")
            tables = [row[0] for row in cursor.fetchall()]
            cursor.close()
            return tables
        except Error as e:
            print(f"Error getting table list: {e}")
            return []


# Common tables for conversion
CONVERSION_TABLES = {
    'quests': 'quest_template',
    'spells': 'spell_template',
    'items': 'item_template',
    'npcs': 'creature_template',
    'gameobjects': 'gameobject_template',
    'npctext': 'npc_text',
}


def main():
    parser = argparse.ArgumentParser(
        description="Export database tables to CSV for conversion scripts",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Export a single table
  python3 tools/export_db_tables.py --table quest_template --output data/quests_raw.csv

  # Export all conversion tables
  python3 tools/export_db_tables.py --all-conversion --output-dir data/

  # Export specific tables
  python3 tools/export_db_tables.py --tables quest_template,item_template --output-dir data/

  # Export all tables in database
  python3 tools/export_db_tables.py --all --output-dir data/
        """
    )

    parser.add_argument("--table", help="Single table name to export")
    parser.add_argument("--tables", help="Comma-separated list of table names")
    parser.add_argument("--all-conversion", action="store_true",
                       help="Export all conversion tables (quest_template, spell_template, etc.)")
    parser.add_argument("--all", action="store_true",
                       help="Export all tables in database")
    parser.add_argument("--output", help="Output CSV file (for single table)")
    parser.add_argument("--output-dir", default="data",
                       help="Output directory (for multiple tables, default: data)")
    parser.add_argument("--db-host", help="Database host (default: from env or config)")
    parser.add_argument("--db-port", type=int, help="Database port (default: from env or config)")
    parser.add_argument("--db-user", help="Database user (default: from env or config)")
    parser.add_argument("--db-pass", help="Database password (default: from env or config)")
    parser.add_argument("--db-name", help="Database name (default: from env or config)")
    parser.add_argument("--config", help="Path to worldserver.conf")

    args = parser.parse_args()

    # Load database config
    if args.config:
        db_config = DBConfig.from_worldserver_conf(args.config)
    else:
        db_config = DBConfig.from_env()

    # Override with command-line arguments
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

    # Determine which tables to export
    tables_to_export = []

    if args.table:
        tables_to_export = [args.table]
        if not args.output:
            print("Error: --output required when using --table")
            return 1
    elif args.tables:
        tables_to_export = [t.strip() for t in args.tables.split(",")]
    elif args.all_conversion:
        tables_to_export = list(CONVERSION_TABLES.values())
    elif args.all:
        # Will be populated after connecting
        pass
    else:
        print("Error: Must specify --table, --tables, --all-conversion, or --all")
        return 1

    # Connect to database
    exporter = DatabaseExporter(db_config)
    if not exporter.connect():
        return 1

    try:
        if args.all:
            # Get all tables
            all_tables = exporter.get_table_list()
            tables_to_export = all_tables
            print(f"Found {len(all_tables)} tables in database")

        # Export tables
        if args.table and args.output:
            # Single table to single file
            success = exporter.export_table(args.table, args.output)
        else:
            # Multiple tables to directory
            success = exporter.export_tables(tables_to_export, args.output_dir)

        if success:
            print(f"\nSuccessfully exported {len(tables_to_export)} table(s)")
            return 0
        else:
            print("\nSome exports failed")
            return 1

    finally:
        exporter.close()


if __name__ == '__main__':
    sys.exit(main())

