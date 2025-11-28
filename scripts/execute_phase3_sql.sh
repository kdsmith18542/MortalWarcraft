#!/bin/bash
# Mortal Warcraft Overhaul - Phase 3 SQL Execution Helper
# Executes all Phase 3 SQL scripts on the appropriate databases

set -e

# Configuration
DB_WORLD="azerothcore_world"
DB_CHAR="azerothcore_characters"
SQL_DIR="sql"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}=== Mortal Warcraft - Phase 3 SQL Execution ===${NC}"
echo ""

# Check for MySQL
if ! command -v mysql &> /dev/null; then
    echo -e "${RED}Error: mysql command not found. Install MySQL client.${NC}"
    exit 1
fi

# Prompt for database credentials
read -p "MySQL username [root]: " DB_USER
DB_USER=${DB_USER:-root}

read -sp "MySQL password: " DB_PASS
echo ""

# Test connection
echo -e "${YELLOW}Testing database connection...${NC}"
if ! mysql -u "$DB_USER" -p"$DB_PASS" -e "USE $DB_WORLD;" 2>/dev/null; then
    echo -e "${RED}Error: Cannot connect to database. Check credentials.${NC}"
    exit 1
fi
echo -e "${GREEN}Connection successful!${NC}"
echo ""

# World Database Scripts
echo -e "${YELLOW}=== World Database Scripts ===${NC}"
WORLD_SCRIPTS=(
    "23_loot_table_nuke_fixed.sql"
    "49_zone_overrides.sql"
    "13_material_properties.sql"
    "56_crafting_blueprints.sql"
    "35_quest_xp_to_gold.sql"
    "26_emblem_cleanup.sql"
    "34_market_stalls.sql"
    "31_territory_control_points.sql"
)

for script in "${WORLD_SCRIPTS[@]}"; do
    script_path="$SQL_DIR/$script"
    if [ -f "$script_path" ]; then
        echo -e "${YELLOW}Executing: $script${NC}"
        if mysql -u "$DB_USER" -p"$DB_PASS" "$DB_WORLD" < "$script_path" 2>/dev/null; then
            echo -e "${GREEN}  ✓ Success${NC}"
        else
            echo -e "${RED}  ✗ Failed${NC}"
            read -p "Continue anyway? (y/n): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                exit 1
            fi
        fi
    else
        echo -e "${YELLOW}  ⚠ Not found: $script${NC}"
    fi
done

# Character Database Scripts
echo ""
echo -e "${YELLOW}=== Character Database Scripts ===${NC}"
CHAR_SCRIPTS=(
    "28_courier_contracts.sql"
    "57_character_attributes.sql"
    "60_guild_wars.sql"
)

for script in "${CHAR_SCRIPTS[@]}"; do
    script_path="$SQL_DIR/$script"
    if [ -f "$script_path" ]; then
        echo -e "${YELLOW}Executing: $script${NC}"
        if mysql -u "$DB_USER" -p"$DB_PASS" "$DB_CHAR" < "$script_path" 2>/dev/null; then
            echo -e "${GREEN}  ✓ Success${NC}"
        else
            echo -e "${RED}  ✗ Failed${NC}"
            read -p "Continue anyway? (y/n): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                exit 1
            fi
        fi
    else
        echo -e "${YELLOW}  ⚠ Not found: $script${NC}"
    fi
done

echo ""
echo -e "${GREEN}=== SQL Execution Complete! ===${NC}"
echo ""
echo "Next steps:"
echo "  1. Verify tables were created: SHOW TABLES;"
echo "  2. Test systems in-game"
echo "  3. Check server logs for any errors"
echo ""
