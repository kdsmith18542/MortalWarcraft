#!/bin/bash
# ==================================================
# Project Mortal Warcraft
# Script: Run ETL Pipeline
# Description: Runs the mortal_gear_etl.py script to generate item SQL
# ==================================================

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ETL_SCRIPT="$PROJECT_ROOT/tools/mortal_gear_etl.py"
SEED_CSV="$PROJECT_ROOT/data/mortal_gear_visuals_seed.csv"
OUTPUT_DIR="$PROJECT_ROOT/out"

# Database configuration (can be overridden with environment variables)
DB_HOST="${DB_HOST:-localhost}"
DB_USER="${DB_USER:-root}"
DB_PASSWORD="${DB_PASSWORD:-}"
DB_NAME="${DB_NAME:-azerothcore_world}"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}==================================================${NC}"
echo -e "${GREEN}Mortal Warcraft - ETL Pipeline Runner${NC}"
echo -e "${GREEN}==================================================${NC}"
echo ""

# Check if Python 3 is available
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}Error: python3 not found. Please install Python 3.${NC}"
    exit 1
fi

# Check if ETL script exists
if [ ! -f "$ETL_SCRIPT" ]; then
    echo -e "${RED}Error: ETL script not found at $ETL_SCRIPT${NC}"
    exit 1
fi

# Check if seed CSV exists
if [ ! -f "$SEED_CSV" ]; then
    echo -e "${RED}Error: Seed CSV not found at $SEED_CSV${NC}"
    exit 1
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

echo -e "${YELLOW}Configuration:${NC}"
echo "  Database Host: $DB_HOST"
echo "  Database User: $DB_USER"
echo "  Database Name: $DB_NAME"
echo "  Seed CSV: $SEED_CSV"
echo "  Output Directory: $OUTPUT_DIR"
echo ""

# Check if mysql-connector-python is installed
if ! python3 -c "import mysql.connector" 2>/dev/null; then
    echo -e "${YELLOW}Warning: mysql-connector-python not installed. DisplayID backfill will be skipped.${NC}"
    echo "  Install with: pip3 install mysql-connector-python"
    SKIP_BACKFILL="--skip-backfill"
else
    SKIP_BACKFILL=""
fi

# Run ETL script
echo -e "${GREEN}Running ETL pipeline...${NC}"
python3 "$ETL_SCRIPT" "$SEED_CSV" \
    --output-items "$OUTPUT_DIR/mortal_item_template.sql" \
    --output-visuals "$OUTPUT_DIR/mortal_gear_visuals.sql" \
    --db-host "$DB_HOST" \
    --db-user "$DB_USER" \
    --db-password "$DB_PASSWORD" \
    --db-name "$DB_NAME" \
    $SKIP_BACKFILL

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}==================================================${NC}"
    echo -e "${GREEN}ETL Pipeline Complete!${NC}"
    echo -e "${GREEN}==================================================${NC}"
    echo ""
    echo -e "${YELLOW}Generated Files:${NC}"
    echo "  - $OUTPUT_DIR/mortal_item_template.sql"
    echo "  - $OUTPUT_DIR/mortal_gear_visuals.sql"
    echo ""
    echo -e "${YELLOW}Next Steps:${NC}"
    echo "  1. Review the generated SQL files"
    echo "  2. Apply to database:"
    echo "     mysql -u $DB_USER -p $DB_NAME < $OUTPUT_DIR/mortal_item_template.sql"
    echo "     mysql -u $DB_USER -p $DB_NAME < $OUTPUT_DIR/mortal_gear_visuals.sql"
    echo ""
else
    echo ""
    echo -e "${RED}==================================================${NC}"
    echo -e "${RED}ETL Pipeline Failed!${NC}"
    echo -e "${RED}==================================================${NC}"
    exit 1
fi

