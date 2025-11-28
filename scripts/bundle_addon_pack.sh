#!/bin/bash
# Mortal Warcraft Overhaul - Addon Pack Bundler
# Creates a distributable addon pack ZIP archive

set -e

# Configuration
PACK_NAME="mortal-addon-pack"
PACK_DIR="addon-pack"
OUTPUT_DIR="dist"
VERSION="1.0.0"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}=== Mortal Warcraft Addon Pack Bundler ===${NC}"
echo ""

# Check if we're in the right directory
if [ ! -d "addons/MortalUI" ]; then
    echo -e "${RED}Error: addons/MortalUI not found. Run from project root.${NC}"
    exit 1
fi

# Create pack directory
echo -e "${YELLOW}Creating addon pack directory...${NC}"
rm -rf "$PACK_DIR"
mkdir -p "$PACK_DIR"

# Copy MortalUI addon
echo -e "${YELLOW}Copying MortalUI addon...${NC}"
cp -r addons/MortalUI "$PACK_DIR/"

# Check for external addons
echo -e "${YELLOW}Checking for external addons...${NC}"

EXTERNAL_ADDONS=(
    "Bagnon"
    "Bartender4"
    "ShadowedUnitFrames"
    "Mapster"
)

MISSING_ADDONS=()

for addon in "${EXTERNAL_ADDONS[@]}"; do
    if [ -d "external-addons/$addon" ]; then
        echo -e "${GREEN}  Found: $addon${NC}"
        cp -r "external-addons/$addon" "$PACK_DIR/"
    else
        echo -e "${YELLOW}  Missing: $addon (will be noted in README)${NC}"
        MISSING_ADDONS+=("$addon")
    fi
done

# Create README
echo -e "${YELLOW}Creating README...${NC}"
cat > "$PACK_DIR/README.txt" << EOF
Mortal Warcraft Addon Pack v${VERSION}
=====================================

INSTALLATION:
1. Extract this ZIP to your WoW 3.3.5a client directory
2. Or copy the addon folders to: WoW/Interface/AddOns/
3. Launch WoW and enable addons in character selection

INCLUDED ADDONS:
- MortalUI (Required) - Core UI configuration and survival mechanics display
$(for addon in "${EXTERNAL_ADDONS[@]}"; do
    if [ -d "$PACK_DIR/$addon" ]; then
        echo "- $addon - Included"
    else
        echo "- $addon - NOT INCLUDED (download separately)"
    fi
done)

REQUIRED ADDONS (if not included):
$(for addon in "${MISSING_ADDONS[@]}"; do
    echo "- $addon - Download from CurseForge/WoWInterface (3.3.5a compatible)"
done)

MortalUI FEATURES:
- Automatic configuration enforcement on first run
- Weight display in bags
- Hunger/satiety display
- Server-to-client data sync
- Bagnon/Bartender4/Mapster configuration

SUPPORT:
See docs/MORTALUI_ADDON_IMPLEMENTATION.md for details

Version: ${VERSION}
Date: $(date +%Y-%m-%d)
EOF

# Create ZIP archive
echo -e "${YELLOW}Creating ZIP archive...${NC}"
mkdir -p "$OUTPUT_DIR"
ZIP_FILE="$OUTPUT_DIR/${PACK_NAME}-v${VERSION}.zip"

cd "$PACK_DIR"
zip -r "../$ZIP_FILE" . -q
cd ..

# Calculate checksum
if command -v sha256sum &> /dev/null; then
    CHECKSUM=$(sha256sum "$ZIP_FILE" | cut -d' ' -f1)
    echo "$CHECKSUM" > "${ZIP_FILE}.sha256"
    echo -e "${GREEN}Checksum: $CHECKSUM${NC}"
elif command -v shasum &> /dev/null; then
    CHECKSUM=$(shasum -a 256 "$ZIP_FILE" | cut -d' ' -f1)
    echo "$CHECKSUM" > "${ZIP_FILE}.sha256"
    echo -e "${GREEN}Checksum: $CHECKSUM${NC}"
fi

# Summary
echo ""
echo -e "${GREEN}=== Addon Pack Created Successfully! ===${NC}"
echo ""
echo "Pack location: $ZIP_FILE"
echo "Pack size: $(du -h "$ZIP_FILE" | cut -f1)"
echo ""
echo "To install:"
echo "  1. Extract to WoW client directory, OR"
echo "  2. Copy addon folders to WoW/Interface/AddOns/"
echo ""

# List contents
echo "Pack contents:"
ls -1 "$PACK_DIR" | sed 's/^/  - /'

