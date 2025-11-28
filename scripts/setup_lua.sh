#!/bin/bash
# Mortal Warcraft Overhaul - Lua Script Setup
# Copies all Lua scripts to Eluna directory

set -e

# Configuration
LUA_SOURCE="modules/mortal_overhaul/lua"
LUA_TARGET="${1:-bin/lua_scripts}"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}=== Mortal Warcraft Overhaul - Lua Script Setup ===${NC}"
echo ""

# Check if source directory exists
if [ ! -d "$LUA_SOURCE" ]; then
    echo -e "${RED}Error: Lua source directory not found: $LUA_SOURCE${NC}"
    exit 1
fi

# Create target directory if it doesn't exist
if [ ! -d "$LUA_TARGET" ]; then
    echo -e "${YELLOW}Creating directory: $LUA_TARGET${NC}"
    mkdir -p "$LUA_TARGET"
fi

# Copy all Lua files
echo -e "${YELLOW}Copying Lua scripts...${NC}"
cp "$LUA_SOURCE"/*.lua "$LUA_TARGET/"

# Count files
FILE_COUNT=$(ls -1 "$LUA_SOURCE"/*.lua 2>/dev/null | wc -l)
echo -e "${GREEN}✓ Copied $FILE_COUNT Lua scripts to $LUA_TARGET${NC}"

echo ""
echo -e "${GREEN}=== Lua Script Setup Complete! ===${NC}"
echo ""
echo "Scripts copied:"
ls -1 "$LUA_TARGET"/*.lua | sed 's|.*/||' | sed 's/^/  - /'

