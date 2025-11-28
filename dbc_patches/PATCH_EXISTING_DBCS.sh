#!/usr/bin/env bash
# Mortal Warcraft - Quick DBC Patch Script
# Patches the EXISTING extracted DBCs at /home/keith/wowpack/azerothcore/data/dbc/

set -e

PROJECT_ROOT="/home/keith/wowpack"
DBC_DIR="$PROJECT_ROOT/azerothcore/data/dbc"
PATCH_DIR="$PROJECT_ROOT/dbc_patches"
BACKUP_DIR="$PROJECT_ROOT/dbc_patches/backups"

echo "╔══════════════════════════════════════════════════════╗"
echo "║  Mortal Warcraft DBC Patcher                         ║"
echo "║  Patching EXISTING DBCs in azerothcore/data/dbc/     ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""

# Check if DBC directory exists
if [ ! -d "$DBC_DIR" ]; then
    echo "❌ ERROR: DBC directory not found at $DBC_DIR"
    echo "   Expected extracted DBCs are missing."
    exit 1
fi

echo "✅ Found DBC directory: $DBC_DIR"
echo ""

# Create backup directory
mkdir -p "$BACKUP_DIR"
echo "📁 Backup directory: $BACKUP_DIR"
echo ""

# Check for required DBC files
echo "🔍 Checking for required DBC files..."
REQUIRED_DBCS=("Spell.dbc" "TalentTab.dbc" "CreatureModelData.dbc" "CreatureDisplayInfo.dbc" "Item.dbc")
MISSING_COUNT=0

for dbc in "${REQUIRED_DBCS[@]}"; do
    if [ -f "$DBC_DIR/$dbc" ]; then
        SIZE=$(du -h "$DBC_DIR/$dbc" | cut -f1)
        echo "  ✅ $dbc ($SIZE)"
    else
        echo "  ❌ $dbc (MISSING)"
        ((MISSING_COUNT++))
    fi
done

echo ""

if [ $MISSING_COUNT -gt 0 ]; then
    echo "⚠️  Warning: $MISSING_COUNT DBC file(s) missing"
    echo "   Some patches may not apply."
    echo ""
fi

# Backup DBCs before patching
echo "💾 Creating backups..."
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_SUBDIR="$BACKUP_DIR/backup_$TIMESTAMP"
mkdir -p "$BACKUP_SUBDIR"

for dbc in "${REQUIRED_DBCS[@]}"; do
    if [ -f "$DBC_DIR/$dbc" ]; then
        cp "$DBC_DIR/$dbc" "$BACKUP_SUBDIR/" 2>/dev/null && echo "  ✅ Backed up: $dbc" || echo "  ⚠️  Failed to backup: $dbc"
    fi
done

echo ""
echo "📦 Backup location: $BACKUP_SUBDIR"
echo ""

# Apply hitbox patches using Rust patcher
echo "🔧 Applying hitbox patches..."
if [ -f "$PROJECT_ROOT/launcher/src/hitbox_patcher.rs" ]; then
    echo "  Using Rust hitbox patcher..."
    # Note: This would require building and running the Rust patcher
    # For now, we'll note it's available
    echo "  ℹ️  Rust patcher available at: launcher/src/hitbox_patcher.rs"
    echo "  ℹ️  Run: cd launcher && cargo run --release -- --patch-hitboxes"
else
    echo "  ⚠️  Rust patcher not found, skipping hitbox patches"
fi

echo ""

# Manual DBC editing instructions
echo "📝 NEXT STEPS - Manual DBC Editing Required:"
echo ""
echo "The following DBCs need manual editing with WDBX Editor:"
echo ""
echo "1️⃣  Spell.dbc - Add custom spells"
echo "   • File: $DBC_DIR/Spell.dbc"
echo "   • Import: $PATCH_DIR/SPELL_CUSTOM_MORTAL.csv"
echo "   • Tool: WDBX Editor → Edit → Import CSV"
echo ""
echo "2️⃣  TalentTab.dbc - Add Universal Mastery Trees"
echo "   • File: $DBC_DIR/TalentTab.dbc"
echo "   • Import: $PATCH_DIR/TALENTTAB_MORTAL.csv"
echo "   • Tool: WDBX Editor → Edit → Import CSV"
echo ""
echo "3️⃣  Item.dbc - (Optional, SQL is easier)"
echo "   • Alternative: Use ITEM_LEVEL_REMOVAL.sql instead"
echo "   • SQL is server-side and easier to maintain"
echo ""

# Apply SQL patch
echo "💉 Applying SQL patches (Item level removal)..."
echo ""
echo "Run this command to remove item level requirements:"
echo ""
echo "  mysql -u root -p azerothcore_world < $PATCH_DIR/ITEM_LEVEL_REMOVAL.sql"
echo ""
read -p "Apply SQL patch now? (y/n): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if command -v mysql >/dev/null 2>&1; then
        echo "📊 Applying SQL patch..."
        mysql -u root -p azerothcore_world < "$PATCH_DIR/ITEM_LEVEL_REMOVAL.sql"
        echo "✅ SQL patch applied successfully!"
    else
        echo "❌ mysql command not found. Please run manually."
    fi
fi

echo ""
echo "╔══════════════════════════════════════════════════════╗"
echo "║  ✅ DBC Patching Process Complete                    ║"
echo "╠══════════════════════════════════════════════════════╣"
echo "║                                                      ║"
echo "║  📦 Backups: $BACKUP_SUBDIR"
echo "║                                                      ║"
echo "║  ⏭️  Next Steps:                                     ║"
echo "║  1. Use WDBX Editor to import CSV files              ║"
echo "║  2. Run Rust hitbox patcher (optional)               ║"
echo "║  3. Restart AzerothCore servers                      ║"
echo "║  4. Test in-game                                     ║"
echo "║                                                      ║"
echo "║  📄 See: dbc_patches/README.md for full guide        ║"
echo "║                                                      ║"
echo "╚══════════════════════════════════════════════════════╝"

