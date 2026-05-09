#!/bin/bash
# Mortal Warcraft Overhaul - Build Script
# Usage: ./build.sh [cmake-options...]
# Presumes azerothcore/ submodule is initialized (git submodule update --init)

set -e

BUILD_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AC_DIR="$BUILD_DIR/azerothcore"
MODULE_DIR="$BUILD_DIR/modules/mod-mortal"
BUILD_OUT="$AC_DIR/build"

echo "=== Mortal Warcraft Overhaul Build ==="

if [ ! -d "$AC_DIR" ] || [ ! -f "$AC_DIR/CMakeLists.txt" ]; then
    echo "Error: azerothcore/ not found. Run: git submodule update --init"
    exit 1
fi

mkdir -p "$BUILD_OUT"
cd "$BUILD_OUT"

# Configure with external module path
cmake .. \
    -DMODULES="$MODULE_DIR" \
    -DCMAKE_INSTALL_PREFIX="$BUILD_DIR/env/dist" \
    "$@"

# Build
echo "Building with $(nproc) threads..."
make -j$(nproc)

echo "=== Build complete! ==="
echo "Binaries: $BUILD_OUT/bin/"
echo "Install:  make install"
