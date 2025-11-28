#!/bin/bash
# Mortal Warcraft Migration Verification and Execution Script

DB_USER="root"
DB_PASS="mwdbpass"
WORLD_DB="azerothcore_world"
CHAR_DB="azerothcore_characters"
SQL_DIR="sql"

echo "=========================================="
echo "Mortal Warcraft Migration Verification"
echo "=========================================="
echo ""

# Get existing tables
echo "Checking existing tables..."
WORLD_TABLES=$(mysql -u "$DB_USER" -p"$DB_PASS" "$WORLD_DB" -N -e "SHOW TABLES LIKE 'mortal%';" 2>/dev/null | sort)
CHAR_TABLES=$(mysql -u "$DB_USER" -p"$DB_PASS" "$CHAR_DB" -N -e "SHOW TABLES LIKE 'mortal%';" 2>/dev/null | sort)

echo "Found $(echo "$WORLD_TABLES" | grep -c .) tables in world database"
echo "Found $(echo "$CHAR_TABLES" | grep -c .) tables in characters database"
echo ""

# Expected critical tables
CRITICAL_TABLES=(
    "mortal_character_skills:characters"
    "mortal_character_attributes:characters"
    "mortal_derived_level_cache:characters"
    "mortal_material_properties:world"
    "mortal_crafting_components:world"
    "mortal_blueprints:world"
    "mortal_notoriety:characters"
    "mortal_bounties:world"
    "mortal_regional_bank:characters"
    "mortal_market_stalls:world"
    "mortal_courier_contracts:world"
    "mortal_strongholds:world"
    "mortal_feature_flags:world"
    "mortal_gear_visuals:world"
    "mortal_mount_visuals:world"
    "mortal_companions:characters"
    "mortal_merc_templates:world"
    "mortal_merc_contracts:world"
    "mortal_titles:world"
    "mortal_character_titles:characters"
)

echo "=== Checking Critical Tables ==="
MISSING_COUNT=0
for entry in "${CRITICAL_TABLES[@]}"; do
    table="${entry%%:*}"
    db="${entry##*:}"
    
    found=0
    if [ "$db" = "world" ]; then
        if echo "$WORLD_TABLES" | grep -q "^$table$"; then
            found=1
        fi
    else
        if echo "$CHAR_TABLES" | grep -q "^$table$"; then
            found=1
        fi
    fi
    
    if [ $found -eq 0 ]; then
        echo "  ✗ MISSING: $table (in $db database)"
        MISSING_COUNT=$((MISSING_COUNT + 1))
    else
        echo "  ✓ Found: $table"
    fi
done

echo ""
echo "Missing critical tables: $MISSING_COUNT"
echo ""

# Find SQL files that create these tables
echo "=== Finding SQL Migration Files ==="
SQL_FILES=($(ls -1 "$SQL_DIR"/*.sql 2>/dev/null | sort))
echo "Found ${#SQL_FILES[@]} SQL files"

# Check which files need to be run
echo ""
echo "=== Files to Check ==="
for file in "${SQL_FILES[@]}"; do
    filename=$(basename "$file")
    # Check if file creates any mortal_ tables
    if grep -q "CREATE TABLE.*mortal_\|CREATE TABLE IF NOT EXISTS.*mortal_" "$file" 2>/dev/null; then
        echo "  - $filename (creates mortal_ tables)"
    fi
done

echo ""
echo "=========================================="
echo "To run missing migrations, execute:"
echo "  ./run_missing_migrations.sh"
echo "=========================================="

