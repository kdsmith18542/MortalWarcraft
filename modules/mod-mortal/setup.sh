#!/bin/bash
# Mortal Warcraft Overhaul - Module Setup Script
# Run this from the AzerothCore build directory after configuring with -DMODULES=mod-mortal

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULE_DIR="$SCRIPT_DIR/modules/mod-mortal"

echo "=== Mortal Warcraft Overhaul - Module Setup ==="

# Install character database tables
echo "[1/3] Installing character database tables..."
mysql -u root -p"${MYSQL_PASSWORD:-}" "${CHARACTER_DATABASE:-acore_characters}" < "$MODULE_DIR/sql/db_characters/mod_mortal_base.sql"
echo "  ✓ Character tables installed"

# Install world database tables
echo "[2/3] Installing world database tables..."
mysql -u root -p"${MYSQL_PASSWORD:-}" "${WORLD_DATABASE:-acore_world}" < "$MODULE_DIR/sql/db_world/mod_mortal_base.sql"
echo "  ✓ World tables installed"

# Run pending migrations
echo "[3/3] Running pending migrations..."
for migration in "$MODULE_DIR/sql/migrations/"*.sql; do
    if [ -f "$migration" ]; then
        echo "  Applying $(basename "$migration")..."
        mysql -u root -p"${MYSQL_PASSWORD:-}" "${CHARACTER_DATABASE:-acore_characters}" < "$migration"
    fi
done
echo "  ✓ Migrations complete"

echo "=== Setup complete! ==="
echo "Build AzerothCore with: cmake .. -DMODULES=mod-mortal && make -j\$(nproc)"
