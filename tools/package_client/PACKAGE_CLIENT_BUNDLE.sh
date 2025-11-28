#!/usr/bin/env bash
# Mortal Warcraft - Client Bundle Packager
# Creates a ready-to-play client bundle with addons, patches, and configuration

set -e

PROJECT_ROOT="/home/keith/wowpack"
CLIENT_SOURCE="/home/keith/wowpack/gameclientfiles/World of Warcraft - WoTLK"
OUTPUT_DIR="/home/keith/wowpack/gameclientfiles/mortal_client_bundle"
ADDONS_DIR="$PROJECT_ROOT/addons"
DBC_DIR="$PROJECT_ROOT/azerothcore/data/dbc"
PATCHES_DIR="$PROJECT_ROOT/dbc_patches"

echo "╔══════════════════════════════════════════════════════╗"
echo "║  Mortal Warcraft - Client Bundle Packager           ║"
echo "║  Creates fully-configured downloadable client        ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""

# Check if client source exists
if [ ! -d "$CLIENT_SOURCE" ]; then
    echo "❌ ERROR: Client source not found at: $CLIENT_SOURCE"
    echo "   Please place a clean WoW 3.3.5a client there first"
    exit 1
fi

echo "📁 Source Client: $CLIENT_SOURCE"
echo "📁 Output Bundle: $OUTPUT_DIR"
echo ""

# Create output directory structure
mkdir -p "$OUTPUT_DIR"
cd "$OUTPUT_DIR"

echo "🔧 Creating client bundle structure..."

# Step 1: Copy base client (excluding Cache, Logs, Screenshots)
echo "  📦 Step 1/6: Copying base client files..."
rsync -av --progress \
    --exclude 'Cache/' \
    --exclude 'Logs/' \
    --exclude 'Screenshots/' \
    --exclude 'WTF/' \
    --exclude 'Interface/AddOns/' \
    "$CLIENT_SOURCE/" \
    "$OUTPUT_DIR/" 2>/dev/null || cp -r "$CLIENT_SOURCE/"* "$OUTPUT_DIR/" 2>/dev/null || echo "  ⚠️  Using fallback copy method"

echo "  ✅ Base client copied"
echo ""

# Step 2: Install MortalUI addons
echo "  📦 Step 2/6: Installing MortalUI addons..."
mkdir -p "$OUTPUT_DIR/Interface/AddOns"

if [ -d "$ADDONS_DIR/MortalUI" ]; then
    cp -r "$ADDONS_DIR/MortalUI" "$OUTPUT_DIR/Interface/AddOns/"
    echo "  ✅ MortalUI installed"
else
    echo "  ⚠️  MortalUI not found at: $ADDONS_DIR/MortalUI"
fi

# Copy any other required addons
for addon_dir in "$ADDONS_DIR"/*; do
    if [ -d "$addon_dir" ] && [ "$(basename "$addon_dir")" != "MortalUI" ]; then
        addon_name=$(basename "$addon_dir")
        cp -r "$addon_dir" "$OUTPUT_DIR/Interface/AddOns/"
        echo "  ✅ $addon_name installed"
    fi
done

echo ""

# Step 3: Configure realmlist.wtf
echo "  📦 Step 3/6: Configuring realmlist..."
mkdir -p "$OUTPUT_DIR/Data/enUS"

cat > "$OUTPUT_DIR/Data/enUS/realmlist.wtf" << 'REALMLIST'
# Mortal Warcraft - Realmlist Configuration
# Auto-configured by client bundle

set realmlist mortalwarcraft.com
set patchlist mortalwarcraft.com

# Backup realmlists (if primary fails)
# set realmlist login.mortalwarcraft.com
# set realmlist 0.0.0.0  # Replace with your server IP
REALMLIST

echo "  ✅ Realmlist configured: mortalwarcraft.com"
echo ""

# Step 4: Configure WTF settings (Config.wtf)
echo "  📦 Step 4/6: Creating default Config.wtf..."
mkdir -p "$OUTPUT_DIR/WTF"

cat > "$OUTPUT_DIR/WTF/Config.wtf" << 'CONFIG'
SET locale "enUS"
SET realmList "mortalwarcraft.com"
SET patchlist "mortalwarcraft.com"
SET accountName ""
SET portal "US"
SET gameEnvironment "production"

# Graphics Settings (default to balanced)
SET gxResolution "1920x1080"
SET gxRefresh "60"
SET gxMultisampleQuality "0.000000"
SET gxFixLag "0"
SET fullAlpha "1"
SET lodDist "100.000000"
SET SmallCull "0.040000"
SET DistCull "500.000000"
SET trilinear "1"
SET frillDensity "32"
SET farclip "777"
SET specular "1"
SET pixelShaders "1"
SET particleDensity "1.000000"
SET unitDrawDist "300.000000"
SET spellEffectLevel "0"

# Camera Settings (optimized for Mortal Warcraft)
SET cameraDistanceMaxZoomFactor "2.6"
SET cameraYawMoveSpeed "180"
SET cameraPitchMoveSpeed "90"

# Sound Settings
SET Sound_EnableAllSound "1"
SET Sound_MasterVolume "0.60000002384186"

# Interface Settings
SET useUiScale "1"
SET uiScale "0.9"
SET ShowClassColorInNameplate "1"
SET nameplateShowEnemies "1"

# Network Settings
SET networkQuality "2"
SET maxFPS "60"
SET maxFPSBk "30"

# Mortal Warcraft Specific
SET violenceLevel "5"
SET weatherDensity "3"
SET expandQuestList "1"
SET showTargetOfTarget "1"
CONFIG

echo "  ✅ Config.wtf created with optimized settings"
echo ""

# Step 5: Apply DBC patches (if available)
echo "  📦 Step 5/6: Applying DBC patches..."
mkdir -p "$OUTPUT_DIR/Data/dbc"

DBC_PATCHED=0

# Check if we have pre-patched DBCs
if [ -d "$DBC_DIR" ]; then
    for dbc in Spell.dbc TalentTab.dbc CreatureModelData.dbc CreatureDisplayInfo.dbc; do
        if [ -f "$DBC_DIR/$dbc" ]; then
            cp "$DBC_DIR/$dbc" "$OUTPUT_DIR/Data/dbc/"
            echo "  ✅ Copied: $dbc"
            ((DBC_PATCHED++))
        fi
    done
fi

if [ $DBC_PATCHED -eq 0 ]; then
    echo "  ⚠️  No pre-patched DBCs found"
    echo "  ℹ️  Client will use server-side modifications"
    
    # Create marker file for launcher to patch on first run
    cat > "$OUTPUT_DIR/Data/.mortal_patch_required" << 'PATCHMARKER'
# Mortal Warcraft - Patch Marker
# This file indicates the client needs DBC patching on first run

PATCH_REQUIRED=1
PATCH_TYPE=DBC
PATCH_VERSION=1.0.0

# The launcher will:
# 1. Detect this file
# 2. Apply DBC patches automatically
# 3. Remove this file when complete
PATCHMARKER
    echo "  ✅ Patch marker created (launcher will patch on first run)"
else
    echo "  ✅ $DBC_PATCHED DBC files included (pre-patched)"
fi

echo ""

# Step 6: Create MPQ patch (if available)
echo "  📦 Step 6/6: Checking for Patch-Mortal.MPQ..."

if [ -f "$PATCHES_DIR/Patch-Mortal.MPQ" ]; then
    cp "$PATCHES_DIR/Patch-Mortal.MPQ" "$OUTPUT_DIR/Data/patch-M.MPQ"
    echo "  ✅ Patch-Mortal.MPQ included"
elif [ -f "$OUTPUT_DIR/Data/patch-M.MPQ" ]; then
    echo "  ✅ Patch-M.MPQ already present"
else
    echo "  ℹ️  No Patch-Mortal.MPQ found (optional)"
    echo "  ℹ️  Server-side modifications will handle everything"
fi

echo ""

# Step 7: Create README for users
echo "  📄 Creating README for users..."

cat > "$OUTPUT_DIR/README_MORTAL_WARCRAFT.txt" << 'README'
╔══════════════════════════════════════════════════════╗
║                                                      ║
║  MORTAL WARCRAFT - OFFICIAL CLIENT                  ║
║  Version 1.0.0 - Season of the Frontier             ║
║                                                      ║
╚══════════════════════════════════════════════════════╝

INSTALLATION:
1. Extract this folder anywhere on your computer
2. Run Wow.exe to start the game
3. Login with your account credentials

WHAT'S INCLUDED:
✅ World of Warcraft 3.3.5a (Build 12340)
✅ MortalUI - Complete UI overhaul
✅ Pre-configured realmlist (mortalwarcraft.com)
✅ Optimized settings for Mortal Warcraft
✅ DBC patches (if applicable)

FIRST RUN:
- The launcher may apply additional patches on first run
- This is normal and takes ~2 minutes
- Do not close the game during patching

LAUNCHER (OPTIONAL):
- Use the Mortal Launcher for easy updates
- Download from: https://mortalwarcraft.com/launcher
- The launcher can auto-update your client

SYSTEM REQUIREMENTS:
- OS: Windows 7+ / Linux (Wine) / Mac (Wine)
- RAM: 2 GB minimum, 4 GB recommended
- GPU: DirectX 9 compatible
- HDD: 15 GB free space
- Internet: Stable connection

ADDONS:
- MortalUI is pre-installed and required
- Do not disable or remove MortalUI
- Additional addons can be added to Interface/AddOns/

REALMLIST:
- Pre-configured to: mortalwarcraft.com
- If you need to change it, edit:
  Data/enUS/realmlist.wtf

SUPPORT:
- Website: https://mortalwarcraft.com
- Discord: https://discord.gg/mortalwarcraft
- Forums: https://forums.mortalwarcraft.com

TROUBLESHOOTING:
- Won't connect? Check realmlist.wtf
- Black screen? Update graphics drivers
- Crashes? Disable addons temporarily
- FPS issues? Lower graphics settings in-game

LEGAL:
This is a private server for World of Warcraft 3.3.5a.
Blizzard Entertainment owns all World of Warcraft assets.
This is a fan project and is not affiliated with Blizzard.

Enjoy Mortal Warcraft!
README

echo "  ✅ README created"
echo ""

# Step 8: Create version manifest for launcher
echo "  📄 Creating version manifest..."

cat > "$OUTPUT_DIR/mortal_manifest.json" << MANIFEST
{
  "version": "1.0.0",
  "build": "12340",
  "game": "wotlk",
  "server": "mortal_warcraft",
  "released": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "realmlist": "mortalwarcraft.com",
  "required_addons": [
    "MortalUI"
  ],
  "optional_addons": [],
  "patches": {
    "dbc_patched": $([ $DBC_PATCHED -gt 0 ] && echo "true" || echo "false"),
    "mpq_patched": $([ -f "$OUTPUT_DIR/Data/patch-M.MPQ" ] && echo "true" || echo "false"),
    "auto_patch": $([ -f "$OUTPUT_DIR/Data/.mortal_patch_required" ] && echo "true" || echo "false")
  },
  "files": {
    "wow_exe": "Wow.exe",
    "data_dir": "Data/",
    "addons_dir": "Interface/AddOns/",
    "wtf_dir": "WTF/",
    "realmlist": "Data/enUS/realmlist.wtf",
    "config": "WTF/Config.wtf"
  },
  "checksums": {
    "note": "SHA256 checksums will be generated by launcher"
  }
}
MANIFEST

echo "  ✅ Manifest created: mortal_manifest.json"
echo ""

# Step 9: Calculate bundle size
echo "  📊 Calculating bundle statistics..."

BUNDLE_SIZE=$(du -sh "$OUTPUT_DIR" | cut -f1)
FILE_COUNT=$(find "$OUTPUT_DIR" -type f | wc -l)
ADDON_COUNT=$(ls -1 "$OUTPUT_DIR/Interface/AddOns" 2>/dev/null | wc -l)

echo ""
echo "╔══════════════════════════════════════════════════════╗"
echo "║  ✅ Client Bundle Created Successfully!              ║"
echo "╠══════════════════════════════════════════════════════╣"
echo "║                                                      ║"
echo "║  📁 Location: $OUTPUT_DIR"
echo "║                                                      ║"
echo "║  📊 Statistics:                                      ║"
echo "║  • Total Size: $BUNDLE_SIZE"
echo "║  • File Count: $FILE_COUNT files"
echo "║  • Addons: $ADDON_COUNT installed"
echo "║  • DBCs: $DBC_PATCHED patched"
echo "║                                                      ║"
echo "║  ✅ Included:                                        ║"
echo "║  • Base WoW 3.3.5a client                           ║"
echo "║  • MortalUI addon (pre-installed)                   ║"
echo "║  • Realmlist.wtf (configured)                       ║"
echo "║  • Config.wtf (optimized)                           ║"
$([ $DBC_PATCHED -gt 0 ] && echo "║  • DBC patches (pre-applied)                         ║" || echo "║  • Patch marker (will patch on first run)            ║")
echo "║  • README and manifest                               ║"
echo "║                                                      ║"
echo "║  🚀 Next Steps:                                      ║"
echo "║  1. Compress for distribution:                       ║"
echo "║     tar -czf mortal_client_v1.0.0.tar.gz \\          ║"
echo "║       -C $(dirname "$OUTPUT_DIR") \\                 ║"
echo "║       $(basename "$OUTPUT_DIR")                      ║"
echo "║                                                      ║"
echo "║  2. Upload to CDN/file host                          ║"
echo "║  3. Update launcher download URL                     ║"
echo "║  4. Test download and installation                   ║"
echo "║                                                      ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""

# Create compression script
cat > "$OUTPUT_DIR/../compress_for_distribution.sh" << 'COMPRESS'
#!/usr/bin/env bash
# Compress client bundle for distribution

OUTPUT_DIR="/home/keith/wowpack/gameclientfiles/mortal_client_bundle"
ARCHIVE_NAME="mortal_warcraft_client_v1.0.0.tar.gz"

cd "$(dirname "$OUTPUT_DIR")"

echo "🗜️  Compressing client bundle..."
tar -czf "$ARCHIVE_NAME" \
    --exclude='*.log' \
    --exclude='Cache/*' \
    --exclude='Logs/*' \
    --exclude='Screenshots/*' \
    "$(basename "$OUTPUT_DIR")"

SIZE=$(du -h "$ARCHIVE_NAME" | cut -f1)
echo "✅ Created: $ARCHIVE_NAME ($SIZE)"
echo ""
echo "Upload to:"
echo "  • https://mortalwarcraft.com/downloads/$ARCHIVE_NAME"
echo "  • Or use CDN: https://cdn.mortalwarcraft.com/client/$ARCHIVE_NAME"
COMPRESS

chmod +x "$OUTPUT_DIR/../compress_for_distribution.sh"

echo "📦 Compression script created: compress_for_distribution.sh"
echo ""
echo "Ready to distribute!"

