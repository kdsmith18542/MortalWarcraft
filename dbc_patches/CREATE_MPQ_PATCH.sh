#!/usr/bin/env bash
# Mortal Warcraft - MPQ Patch Creation Script
# Creates Patch-Mortal.MPQ with custom DBC files

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
OUTPUT_DIR="$PROJECT_ROOT/gameclientfiles"
PATCH_NAME="Patch-Mortal.MPQ"

echo "╔══════════════════════════════════════════════════════╗"
echo "║  Mortal Warcraft MPQ Patch Creator                  ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""

# Check if MPQ tools are installed
if ! command -v mpqeditor >/dev/null 2>&1; then
    echo "⚠️  MPQEditor not found. Please install MPQ tools:"
    echo ""
    echo "Option 1: Install ladik's MPQ Editor (Windows)"
    echo "  - Download from: http://www.zezula.net/en/mpq/download.html"
    echo ""
    echo "Option 2: Install StormLib (Linux/Mac)"
    echo "  - git clone https://github.com/ladislav-zezula/StormLib.git"
    echo "  - cd StormLib && mkdir build && cd build"
    echo "  - cmake .. && make && sudo make install"
    echo ""
    echo "For now, we'll create a marker file with instructions."
    echo ""
fi

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Check if we have DBC files to patch
DBC_SOURCE="$PROJECT_ROOT/azerothcore/data/dbc"
if [ ! -d "$DBC_SOURCE" ]; then
    echo "❌ DBC source directory not found: $DBC_SOURCE"
    echo "   Please extract client data first:"
    echo "   cd azerothcore && ./acore.sh dbc-import"
    exit 1
fi

echo "📁 DBC Source: $DBC_SOURCE"
echo "📁 Output: $OUTPUT_DIR/$PATCH_NAME"
echo ""

# Create temporary directory for MPQ contents
TEMP_MPQ="$OUTPUT_DIR/temp_mpq"
mkdir -p "$TEMP_MPQ/DBFilesClient"

echo "🔧 Copying DBC files to patch directory..."

# Copy DBC files that need to be patched
# Note: These should be pre-patched using the Rust patcher or WDBX Editor
if [ -f "$DBC_SOURCE/Spell.dbc" ]; then
    cp "$DBC_SOURCE/Spell.dbc" "$TEMP_MPQ/DBFilesClient/"
    echo "  ✅ Spell.dbc"
fi

if [ -f "$DBC_SOURCE/TalentTab.dbc" ]; then
    cp "$DBC_SOURCE/TalentTab.dbc" "$TEMP_MPQ/DBFilesClient/"
    echo "  ✅ TalentTab.dbc"
fi

if [ -f "$DBC_SOURCE/CreatureModelData.dbc" ]; then
    cp "$DBC_SOURCE/CreatureModelData.dbc" "$TEMP_MPQ/DBFilesClient/"
    echo "  ✅ CreatureModelData.dbc"
fi

if [ -f "$DBC_SOURCE/CreatureDisplayInfo.dbc" ]; then
    cp "$DBC_SOURCE/CreatureDisplayInfo.dbc" "$TEMP_MPQ/DBFilesClient/"
    echo "  ✅ CreatureDisplayInfo.dbc"
fi

echo ""
echo "📝 Creating MPQ instructions file..."

# Create instructions file
cat > "$OUTPUT_DIR/MPQ_CREATION_INSTRUCTIONS.txt" << 'EOF'
Mortal Warcraft - MPQ Patch Creation Instructions
==================================================

MANUAL MPQ CREATION STEPS:

1. Install MPQ Editor (ladik's MPQ Editor recommended)
   - Windows: http://www.zezula.net/en/mpq/download.html
   - Linux: Use StormLib tools

2. Create New MPQ Archive:
   - File → New
   - Name: Patch-Mortal.MPQ
   - Type: MPQ v1.0 (WoW 3.3.5a compatible)
   - Compression: ZLIB or BZIP2
   - Block Size: 16384 (default)

3. Add DBC Files:
   - Add → Files
   - Navigate to: temp_mpq/DBFilesClient/
   - Select all .dbc files
   - Path in MPQ: DBFilesClient\
   - Compression: Medium (ZLIB)

4. Add Custom Textures (optional):
   - Add → Files
   - Navigate to: custom_textures/
   - Select all .blp files
   - Path in MPQ: Interface\TalentFrame\
   - Compression: Medium (ZLIB)

5. Save and Close:
   - File → Compact Archive (removes fragmentation)
   - File → Close

6. Test MPQ:
   - Copy Patch-Mortal.MPQ to WoW/Data/ directory
   - Client will load Patch-Z MPQ files last
   - Naming convention: patch-X.MPQ (where X = letter)
   - Example: patch-M.MPQ (M for Mortal)

7. Verify:
   - Start WoW client
   - Check that custom spells appear
   - Check that talent tabs are modified
   - Check that hitboxes feel different

AUTOMATION (ADVANCED):
- Use StormLib command-line tools for automated MPQ creation
- See: create_mpq_automated.sh (requires StormLib installed)

EOF

echo "✅ Instructions created: $OUTPUT_DIR/MPQ_CREATION_INSTRUCTIONS.txt"
echo ""

# Try to create MPQ automatically if StormLib is available
if command -v mpqeditor >/dev/null 2>&1; then
    echo "🔨 Creating MPQ archive..."
    
    cd "$TEMP_MPQ"
    mpqeditor new "$OUTPUT_DIR/$PATCH_NAME" -v 1 -b 16384
    mpqeditor add "$OUTPUT_DIR/$PATCH_NAME" "DBFilesClient/*" "DBFilesClient\"
    mpqeditor compact "$OUTPUT_DIR/$PATCH_NAME"
    
    echo "✅ MPQ created: $OUTPUT_DIR/$PATCH_NAME"
    echo ""
    echo "📊 MPQ Contents:"
    mpqeditor list "$OUTPUT_DIR/$PATCH_NAME"
else
    echo "⚠️  Automatic MPQ creation skipped (no tools found)"
    echo ""
    echo "📋 Manual Steps:"
    echo "  1. Read: $OUTPUT_DIR/MPQ_CREATION_INSTRUCTIONS.txt"
    echo "  2. Use MPQ Editor to create patch from temp_mpq/"
    echo "  3. Place Patch-Mortal.MPQ in WoW/Data/ directory"
fi

echo ""
echo "╔══════════════════════════════════════════════════════╗"
echo "║  ✅ DBC Patch Preparation Complete                   ║"
echo "╠══════════════════════════════════════════════════════╣"
echo "║                                                      ║"
echo "║  📁 Temp Files: $OUTPUT_DIR/temp_mpq/"
echo "║  📄 Instructions: MPQ_CREATION_INSTRUCTIONS.txt      ║"
echo "║                                                      ║"
echo "║  Next Steps:                                         ║"
echo "║  1. Edit DBCs in temp_mpq/ with WDBX Editor         ║"
echo "║  2. Create MPQ using instructions                    ║"
echo "║  3. Distribute via launcher                          ║"
echo "║                                                      ║"
echo "╚══════════════════════════════════════════════════════╝"

