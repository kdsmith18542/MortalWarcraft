# Mortal Warcraft - DBC Patches

**Purpose:** Complete DBC modification files for Mortal Warcraft Overhaul  
**Target Client:** World of Warcraft 3.3.5a (Build 12340)  
**Date:** November 27, 2025

---

## 📁 **CONTENTS**

```
dbc_patches/
├── README.md                      ← You are here
├── DBC_PATCH_SPECIFICATION.md     ← Full specification (in parent dir)
├── SPELL_CUSTOM_MORTAL.csv        ← Custom spells for import
├── TALENTTAB_MORTAL.csv           ← Universal Mastery Trees
├── ITEM_LEVEL_REMOVAL.sql         ← SQL patch for item requirements
├── CREATE_MPQ_PATCH.sh            ← MPQ creation script
└── [Generated files after running script]
```

---

## 🎯 **QUICK START**

### **Option 1: Server-Side Only (RECOMMENDED)**

**No DBC patching needed!** The server already handles everything:

```bash
# Apply SQL patches (removes level requirements)
cd /home/keith/wowpack
mysql -u root -p azerothcore_world < dbc_patches/ITEM_LEVEL_REMOVAL.sql

# Done! Server is functional with standard WoW 3.3.5a client
```

**What works:**
- ✅ Skill-based progression (server-side)
- ✅ Custom spells (server-side effects)
- ✅ Talent system (addon-based UI)
- ✅ Item requirements (SQL override)
- ✅ Hitboxes (server-side collision)

**Limitations:**
- ⚠️ Spell names/descriptions show vanilla text in client
- ⚠️ Talent tabs show class names (but function as mastery trees)
- ⚠️ Client tooltips may show incorrect data

**Verdict:** Fully playable, just not "polished"

---

### **Option 2: Full DBC Patches (OPTIONAL POLISH)**

For professional client experience with proper spell names, talent tabs, etc.

#### **Step 1: Install Tools**

**Windows:**
```
Download WDBX Editor from:
https://github.com/WowDevTools/WDBXEditor/releases

Download ladik's MPQ Editor from:
http://www.zezula.net/en/mpq/download.html
```

**Linux:**
```bash
# Install StormLib for MPQ manipulation
git clone https://github.com/ladislav-zezula/StormLib.git
cd StormLib && mkdir build && cd build
cmake .. && make && sudo make install

# Install WDBX Editor via Wine or use online DBC editor
```

#### **Step 2: Extract Client DBCs**

```bash
# Extract DBCs from WoW client MPQ archives
# Use MPQ Editor or StormLib to extract:
# - common.MPQ → DBFilesClient/Spell.dbc
# - common.MPQ → DBFilesClient/TalentTab.dbc
# - common.MPQ → DBFilesClient/CreatureModelData.dbc
# - common.MPQ → DBFilesClient/CreatureDisplayInfo.dbc

# Or extract from AzerothCore data:
cd /home/keith/wowpack/azerothcore
./acore.sh dbc-import
# DBCs will be in azerothcore/data/dbc/
```

#### **Step 3: Edit DBCs**

**A. Spell.dbc - Add Custom Spells**

```bash
# Open WDBX Editor
wdbxeditor

# 1. File → Open → Spell.dbc
# 2. Edit → Import CSV
# 3. Select: SPELL_CUSTOM_MORTAL.csv
# 4. File → Save As → Spell.dbc (patched)
```

**Manual Entries (if CSV import fails):**

| ID | Name | Effect | Duration | Icon |
|----|------|--------|----------|------|
| 90010 | Brace | -50% damage | 750ms | 18 |
| 90020 | Hunger: Peckish | -2% stats | Permanent | 1 |
| 90030 | Encumbered: Light | -5% speed | Permanent | 10 |
| 90040 | Criminal | Visual flag | 15min | 20 |

**B. TalentTab.dbc - Universal Mastery Trees**

```bash
# Open WDBX Editor
wdbxeditor

# 1. File → Open → TalentTab.dbc
# 2. Edit → Import CSV
# 3. Select: TALENTTAB_MORTAL.csv
# 4. File → Save As → TalentTab.dbc (patched)
```

**Manual Entries:**

| ID | Name | RaceMask | ClassMask | Order |
|----|------|----------|-----------|-------|
| 10001 | Warlord | 0 | 0 | 0 |
| 10002 | Guardian | 0 | 0 | 1 |
| 10003 | Explorer | 0 | 0 | 2 |

#### **Step 4: Apply Hitbox Patches**

```bash
# Use Rust patcher (already implemented)
cd /home/keith/wowpack/launcher
cargo run --release -- --patch-hitboxes /path/to/wow/client

# This will:
# - Reduce collision boxes by 10%
# - Reduce model scales by 5%
# - Create backups (.dbc.backup)
```

#### **Step 5: Create MPQ Patch**

```bash
cd /home/keith/wowpack/dbc_patches
chmod +x CREATE_MPQ_PATCH.sh
./CREATE_MPQ_PATCH.sh

# Follow instructions in:
# gameclientfiles/MPQ_CREATION_INSTRUCTIONS.txt
```

**Manual MPQ Creation:**

```
1. Open MPQ Editor
2. File → New → Patch-Mortal.MPQ
3. Add Files:
   - Spell.dbc → DBFilesClient\Spell.dbc
   - TalentTab.dbc → DBFilesClient\TalentTab.dbc
   - CreatureModelData.dbc → DBFilesClient\CreatureModelData.dbc
   - CreatureDisplayInfo.dbc → DBFilesClient\CreatureDisplayInfo.dbc
4. File → Compact Archive
5. File → Close
```

#### **Step 6: Deploy MPQ**

```bash
# Copy to WoW client Data directory
cp gameclientfiles/Patch-Mortal.MPQ /path/to/wow/Data/patch-M.MPQ

# Note: MPQ files are loaded alphabetically
# patch-M.MPQ will override base MPQs (common.MPQ, expansion.MPQ, etc.)
```

#### **Step 7: Test**

```bash
# Start WoW client
# Login to Mortal Warcraft server
# Check:
# - Press N → See "Warlord", "Guardian", "Explorer" tabs
# - Cast custom spells → See proper names
# - Hover over items → See skill requirements
```

---

## 📊 **FILE SPECIFICATIONS**

### **SPELL_CUSTOM_MORTAL.csv**

**Format:** CSV compatible with WDBX Editor  
**Spells Included:**
- 90010: Brace (defensive)
- 90020-90025: Hunger debuffs (6 levels)
- 90030-90035: Encumbrance penalties (5 levels)
- 90040: Criminal flag (visual)
- 90050-90052: Tracking variants
- 900100: Rift participant aura

**Usage:**
1. Open Spell.dbc in WDBX Editor
2. Edit → Import CSV
3. Select this file
4. Save patched Spell.dbc

---

### **TALENTTAB_MORTAL.csv**

**Format:** CSV compatible with WDBX Editor  
**Tabs Included:**
- 10001: Warlord (Offense)
- 10002: Guardian (Defense)
- 10003: Explorer (Utility)

**Usage:**
1. Open TalentTab.dbc in WDBX Editor
2. Edit → Import CSV
3. Select this file
4. Save patched TalentTab.dbc

---

### **ITEM_LEVEL_REMOVAL.sql**

**Format:** MySQL script  
**Purpose:** Remove level requirements from all items

**Usage:**
```bash
mysql -u root -p azerothcore_world < ITEM_LEVEL_REMOVAL.sql
```

**What it does:**
- Sets `RequiredLevel = 0` for all items
- Adds `RequiredSkill = 1001` (Combat Mastery)
- Sets `RequiredSkillRank = ItemLevel * 2`

---

### **CREATE_MPQ_PATCH.sh**

**Format:** Bash script  
**Purpose:** Automate MPQ creation

**Usage:**
```bash
chmod +x CREATE_MPQ_PATCH.sh
./CREATE_MPQ_PATCH.sh
```

**What it does:**
- Checks for MPQ tools
- Copies DBC files to temp directory
- Creates instructions file
- Attempts automatic MPQ creation (if tools installed)

---

## 🎨 **CUSTOM TEXTURES** (Optional)

For visual polish, create custom talent tree backgrounds:

```
Interface/
└── TalentFrame/
    ├── TalentBackground_Warlord.blp
    ├── TalentBackground_Guardian.blp
    └── TalentBackground_Explorer.blp
```

**Tools:**
- BLP Converter: Convert PNG → BLP
- Photoshop/GIMP: Create 256x512 backgrounds
- Reference existing: `TalentFramePaladinHoly.blp`

**Add to MPQ:**
```
MPQ Path: Interface\TalentFrame\
Files: TalentBackground_*.blp
```

---

## 🔍 **VERIFICATION**

### **Test Custom Spells:**

```lua
-- In-game console (client-side)
/run print(GetSpellInfo(90010))  -- Should show "Brace"
/run print(GetSpellInfo(90020))  -- Should show "Hunger: Peckish"
```

### **Test Talent Tabs:**

```lua
-- In-game console
/run print(GetNumTalentTabs())  -- Should show 3
/run print(GetTalentTabInfo(1))  -- Should show "Warlord"
```

### **Test Item Requirements:**

```sql
-- Database query
SELECT entry, name, RequiredLevel, RequiredSkill, RequiredSkillRank 
FROM item_template 
WHERE ItemLevel > 60 
LIMIT 10;

-- Expected: RequiredLevel = 0, RequiredSkill = 1001
```

---

## 📈 **IMPACT ANALYSIS**

### **Server-Side Only:**
- ✅ Fully functional
- ✅ Zero client patching
- ✅ Easy updates
- ⚠️ Vanilla text in tooltips
- **Recommended for:** Beta testing, rapid iteration

### **Full DBC Patches:**
- ✅ Professional appearance
- ✅ Proper spell/item names
- ✅ Custom talent tabs
- ❌ Requires client distribution
- ❌ Harder to update
- **Recommended for:** Release build, marketing

---

## 🚀 **DEPLOYMENT**

### **Via Launcher:**

The Rust launcher can automatically apply DBC patches:

```rust
// In launcher/src/patcher.rs
pub fn apply_all_patches(client_path: &Path) -> Result<(), String> {
    spell_patcher::patch_spell_dbc(client_path)?;
    talenttab_patcher::patch_talenttab_dbc(client_path)?;
    hitbox_patcher::patch_hitboxes(client_path)?;
    Ok(())
}
```

**Status:** ⚠️ Placeholders exist, full implementation needed

---

## 📝 **NOTES**

1. **Backup Everything:** DBC editing can corrupt files
2. **Test on Copy:** Always test on a copy of your client first
3. **Version Control:** Keep original DBCs for reverting
4. **Client Updates:** Reapply patches after client updates
5. **Server Sync:** Ensure server spell IDs match client spell IDs

---

## 🔗 **RESOURCES**

**Tools:**
- WDBX Editor: https://github.com/WowDevTools/WDBXEditor
- ladik's MPQ Editor: http://www.zezula.net/en/mpq/download.html
- StormLib: https://github.com/ladislav-zezula/StormLib
- BLP Converter: https://www.wowinterface.com/downloads/info17127

**Guides:**
- DBC Editing: https://wowdev.wiki/DBC
- MPQ Format: https://wowdev.wiki/MPQ
- Spell.dbc Structure: https://wowdev.wiki/DB/Spell
- TalentTab.dbc: https://wowdev.wiki/DB/TalentTab

---

## ✅ **CHECKLIST**

**Minimum Viable (Server-Side):**
- [x] Apply ITEM_LEVEL_REMOVAL.sql
- [x] Verify skill-based progression works
- [x] Test with vanilla client

**Full Polish (Client Patches):**
- [ ] Extract DBCs from client
- [ ] Edit Spell.dbc with custom entries
- [ ] Edit TalentTab.dbc with mastery trees
- [ ] Apply hitbox patches
- [ ] Create Patch-Mortal.MPQ
- [ ] Test all modifications
- [ ] Distribute via launcher

---

**Status:** Server-Side ✅ COMPLETE | Client Polish ⏭️ OPTIONAL


