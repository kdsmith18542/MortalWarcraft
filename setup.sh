#!/bin/bash
# Mortal Warcraft - Quick Setup
# Initializes submodule, installs SQL, and builds

set -e

echo "=== Mortal Warcraft Setup ==="

# 1. Initialize azerothcore submodule (if not already done)
if [ ! -f "azerothcore/CMakeLists.txt" ]; then
    echo "[1/4] Initializing azerothcore submodule..."
    git submodule update --init --depth 1
else
    echo "[1/4] azerothcore already initialized"
fi

# 2. Install SQL schemas
echo "[2/4] Installing database schemas..."
if command -v mysql &> /dev/null; then
    mysql -u root -p"${MYSQL_PASSWORD}" acore_characters < modules/mod-mortal/sql/db_characters/mod_mortal_base.sql 2>/dev/null || echo "  (skip - no DB access)"
    mysql -u root -p"${MYSQL_PASSWORD}" acore_world < modules/mod-mortal/sql/db_world/mod_mortal_base.sql 2>/dev/null || echo "  (skip - no DB access)"
else
    echo "  (mysql not found, SQL can be loaded manually)"
fi

# 3. Build
echo "[3/4] Building..."
mkdir -p azerothcore/build
cd azerothcore/build
cmake .. -DMODULES="$(cd ../.. && pwd)/modules/mod-mortal" -DCMAKE_INSTALL_PREFIX="../env/dist"
make -j$(nproc)

cd ../..

# 4. Done
echo "[4/4] Setup complete!"
echo ""
echo "Start your server:"
echo "  cd azerothcore/env/dist/bin"
echo "  ./authserver"
echo "  ./worldserver"
