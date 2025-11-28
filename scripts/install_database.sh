#!/bin/bash
# Mortal Warcraft Overhaul - Database Installation Script
# This script runs all SQL files in the correct order

set -e

# Configuration
DB_WORLD="azerothcore_world"
DB_CHAR="azerothcore_characters"
DB_USER="root"
DB_PASS=""
SQL_DIR="modules/mortal_overhaul/sql"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to run SQL file
run_sql() {
    local db=$1
    local file=$2
    local description=$3
    
    echo -e "${YELLOW}Running: ${description}${NC}"
    
    if [ -z "$DB_PASS" ]; then
        mysql -u "$DB_USER" "$db" < "$file"
    else
        mysql -u "$DB_USER" -p"$DB_PASS" "$db" < "$file"
    fi
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ ${description} completed${NC}"
    else
        echo -e "${RED}✗ ${description} failed${NC}"
        exit 1
    fi
}

# Check if MySQL is available
if ! command -v mysql &> /dev/null; then
    echo -e "${RED}Error: mysql command not found. Please install MySQL client.${NC}"
    exit 1
fi

# Check if SQL directory exists
if [ ! -d "$SQL_DIR" ]; then
    echo -e "${RED}Error: SQL directory not found: $SQL_DIR${NC}"
    exit 1
fi

echo -e "${GREEN}=== Mortal Warcraft Overhaul - Database Installation ===${NC}"
echo ""

# World Database Scripts
echo -e "${YELLOW}=== Installing World Database Scripts ===${NC}"
run_sql "$DB_WORLD" "$SQL_DIR/01_create_tables.sql" "Core Tables"
run_sql "$DB_WORLD" "$SQL_DIR/02_systems_audit_soulbound.sql" "Remove Soulbound Items"
run_sql "$DB_WORLD" "$SQL_DIR/03_systems_audit_level_reqs.sql" "Remove Level Requirements"
run_sql "$DB_WORLD" "$SQL_DIR/04_systems_audit_flight_masters.sql" "Disable Flight Masters"
run_sql "$DB_WORLD" "$SQL_DIR/05_systems_audit_talents.sql" "Remove Talents"
run_sql "$DB_WORLD" "$SQL_DIR/06_token_economy_tables.sql" "Token Economy Tables"
run_sql "$DB_WORLD" "$SQL_DIR/07_token_economy_items.sql" "Token Economy Items"
run_sql "$DB_WORLD" "$SQL_DIR/08_fragment_drops.sql" "Fragment Drops"
run_sql "$DB_WORLD" "$SQL_DIR/09_guild_territories.sql" "Guild Territories"
run_sql "$DB_WORLD" "$SQL_DIR/10_resource_nodes.sql" "Resource Nodes"
run_sql "$DB_WORLD" "$SQL_DIR/11_world_bosses.sql" "World Bosses"
run_sql "$DB_WORLD" "$SQL_DIR/12_arena_rankings.sql" "Arena Rankings"
run_sql "$DB_WORLD" "$SQL_DIR/13_material_properties.sql" "Material Properties"
run_sql "$DB_WORLD" "$SQL_DIR/14_player_housing.sql" "Player Housing"

# Character Database Scripts
echo ""
echo -e "${YELLOW}=== Installing Character Database Scripts ===${NC}"
run_sql "$DB_CHAR" "$SQL_DIR/06_token_economy_tables.sql" "Token Economy Tables"
run_sql "$DB_CHAR" "$SQL_DIR/09_guild_territories.sql" "Guild Territories"
run_sql "$DB_CHAR" "$SQL_DIR/12_arena_rankings.sql" "Arena Rankings"
run_sql "$DB_CHAR" "$SQL_DIR/14_player_housing.sql" "Player Housing"

echo ""
echo -e "${GREEN}=== Database Installation Complete! ===${NC}"
echo ""
echo "Next steps:"
echo "1. Add prepared statements to CharacterDatabase.cpp"
echo "2. Copy Lua scripts to Eluna directory"
echo "3. Configure worldserver.conf"
echo "4. Recompile AzerothCore"

