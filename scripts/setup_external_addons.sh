#!/bin/bash
# Mortal Warcraft Overhaul - External Addon Setup Helper
# Downloads and sets up external addons for the addon pack

set -e

# Configuration
ADDON_DIR="external-addons"
VERSION_WOTLK="3.3.5"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}=== Mortal Warcraft - External Addon Setup ===${NC}"
echo ""

# Create directory
mkdir -p "$ADDON_DIR"
cd "$ADDON_DIR"

# Addon download information
declare -A ADDON_INFO=(
    ["Bagnon"]="https://www.curseforge.com/wow/addons/bagnon/files"
    ["Bartender4"]="https://www.curseforge.com/wow/addons/bartender4/files"
    ["ShadowedUnitFrames"]="https://www.curseforge.com/wow/addons/shadowed-unit-frames/files"
    ["Mapster"]="https://www.curseforge.com/wow/addons/mapster/files"
)

echo -e "${YELLOW}External addons required for Mortal Warcraft:${NC}"
echo ""
for addon in "${!ADDON_INFO[@]}"; do
    echo -e "${BLUE}  - $addon${NC}"
    echo -e "    Download: ${ADDON_INFO[$addon]}"
    echo ""
done

echo -e "${YELLOW}Manual Installation Instructions:${NC}"
echo ""
echo "1. Download each addon from CurseForge (3.3.5a/WotLK compatible version)"
echo "2. Extract to: $ADDON_DIR/<AddonName>/"
echo "3. Run: ./scripts/bundle_addon_pack.sh"
echo ""
echo "Example structure:"
echo "  $ADDON_DIR/"
echo "    ├── Bagnon/"
echo "    │   ├── Bagnon.toc"
echo "    │   └── ..."
echo "    ├── Bartender4/"
echo "    │   ├── Bartender4.toc"
echo "    │   └── ..."
echo "    └── ..."
echo ""

# Check if any addons are already present
FOUND_ADDONS=()
for addon in "${!ADDON_INFO[@]}"; do
    if [ -d "$addon" ]; then
        FOUND_ADDONS+=("$addon")
    fi
done

if [ ${#FOUND_ADDONS[@]} -gt 0 ]; then
    echo -e "${GREEN}Found addons:${NC}"
    for addon in "${FOUND_ADDONS[@]}"; do
        echo -e "  ✓ $addon"
    done
    echo ""
fi

echo -e "${YELLOW}Note:${NC} Addons must be compatible with WoW 3.3.5a (WotLK)"
echo "Look for versions dated around 2010 or specifically marked as WotLK compatible."
echo ""

cd ..

