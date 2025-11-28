# DBC Patches - Quick Start Guide

**✅ ALL DBC FILES ALREADY EXTRACTED AND READY!**

Location: `/home/keith/wowpack/azerothcore/data/dbc/`

---

## 📊 **AVAILABLE DBC FILES**

✅ **Spell.dbc** (47 MB) - Ready for custom spell additions  
✅ **TalentTab.dbc** (4.0 KB) - Ready for mastery tree modifications  
✅ **CreatureModelData.dbc** (196 KB) - Ready for hitbox patches  
✅ **CreatureDisplayInfo.dbc** (1.6 MB) - Ready for scale adjustments  
✅ **Item.dbc** (1.5 MB) - Ready for requirement changes (or use SQL)

**Backups Created:** `/home/keith/wowpack/dbc_patches/backups/backup_20251127_013337/`

---

## 🚀 **OPTION 1: SERVER-SIDE ONLY (5 Minutes)**

**Recommended for immediate launch!**

```bash
# Apply SQL patch to remove item level requirements
cd /home/keith/wowpack
mysql -u root -p azerothcore_world < dbc_patches/ITEM_LEVEL_REMOVAL.sql

# Done! Server is ready to launch
```

**What works:**
- ✅ All Mortal Warcraft features
- ✅ Skill-based progression
- ✅ Custom spell effects
- ✅ Universal mastery trees (via addon)
- ✅ Standard WoW client (no patching)

**Minor limitations:**
- ⚠️ Spell tooltips show vanilla names
- ⚠️ Talent tabs show class names (but work correctly)

---

## 🎨 **OPTION 2: FULL DBC PATCHES (Optional Polish)**

### **Method A: Using WDBX Editor (Recommended)**

**1. Download WDBX Editor:**
```bash
# Windows: https://github.com/WowDevTools/WDBXEditor/releases
# Linux: Run via Wine or use online DBC editor
```

**2. Edit Spell.dbc:**
```
1. Open WDBX Editor
2. File → Open → /home/keith/wowpack/azerothcore/data/dbc/Spell.dbc
3. Edit → Import CSV
4. Select: /home/keith/wowpack/dbc_patches/SPELL_CUSTOM_MORTAL.csv
5. File → Save
```

**3. Edit TalentTab.dbc:**
```
1. File → Open → /home/keith/wowpack/azerothcore/data/dbc/TalentTab.dbc
2. Edit → Import CSV
3. Select: /home/keith/wowpack/dbc_patches/TALENTTAB_MORTAL.csv
4. File → Save
```

**4. Apply Hitbox Patches:**
```bash
cd /home/keith/wowpack/launcher
cargo run --release -- --patch-hitboxes /home/keith/wowpack/azerothcore/data/dbc
```

**5. Restart Server:**
```bash
cd /home/keith/wowpack/azerothcore
./stop-servers.sh
./start-headless.sh
```

---

### **Method B: Quick Script (Automated Backup + Instructions)**

```bash
cd /home/keith/wowpack/dbc_patches
./PATCH_EXISTING_DBCS.sh

# This will:
# ✅ Verify all DBC files exist
# ✅ Create timestamped backups
# ✅ Provide step-by-step instructions
# ✅ Optionally apply SQL patches
```

---

## 📋 **CUSTOM CONTENT TO ADD**

### **Spell.dbc - 13 New Spells:**

| Spell ID | Name | Purpose |
|----------|------|---------|
| 90010 | Brace | 50% damage reduction, 750ms |
| 90020-90025 | Hunger: Levels 1-6 | Progressive hunger debuffs |
| 90030-90035 | Encumbered: Levels 1-5 | Weight-based movement penalties |
| 90040 | Criminal | Visual flag for outlaws |
| 90050 | Track Players | PvP tracking |
| 90051 | Detect Stealth | Enhanced stealth detection |
| 90052 | Track Resources | Resource node tracking |
| 900100 | Rift Participant | Hidden event marker |

### **TalentTab.dbc - 3 Universal Trees:**

| Tab ID | Name | Focus | Icon |
|--------|------|-------|------|
| 10001 | Warlord | Offense, damage | Sword |
| 10002 | Guardian | Defense, survival | Shield |
| 10003 | Explorer | Utility, gathering | Compass |

---

## 🔍 **VERIFICATION**

### **Check DBC Files:**
```bash
ls -lh /home/keith/wowpack/azerothcore/data/dbc/*.dbc | grep -E "(Spell|TalentTab|Creature|Item)"
```

### **Check Backups:**
```bash
ls -lh /home/keith/wowpack/dbc_patches/backups/
```

### **Test In-Game (Server-Side):**
```bash
# Start server
cd /home/keith/wowpack/azerothcore
./start-headless.sh

# Connect with vanilla client
# Test:
# - Press N → Talent tabs function (via addon)
# - Cast brace → Works (server-side effect)
# - Check item requirements → Level removed (SQL)
```

### **Test In-Game (Full DBC Patches):**
```lua
-- In-game console
/run print(GetSpellInfo(90010))  -- Should show "Brace"
/run print(GetTalentTabInfo(1))  -- Should show "Warlord"
```

---

## 📁 **FILE LOCATIONS**

```
/home/keith/wowpack/
├── azerothcore/data/dbc/          ← Extracted DBC files HERE!
│   ├── Spell.dbc                  ← 47 MB, ready to edit
│   ├── TalentTab.dbc              ← 4 KB, ready to edit
│   ├── CreatureModelData.dbc      ← 196 KB, ready to patch
│   ├── CreatureDisplayInfo.dbc    ← 1.6 MB, ready to patch
│   └── Item.dbc                   ← 1.5 MB, or use SQL instead
│
├── dbc_patches/
│   ├── QUICK_START.md             ← YOU ARE HERE
│   ├── SPELL_CUSTOM_MORTAL.csv    ← Import this into Spell.dbc
│   ├── TALENTTAB_MORTAL.csv       ← Import this into TalentTab.dbc
│   ├── ITEM_LEVEL_REMOVAL.sql     ← Run this on database
│   ├── PATCH_EXISTING_DBCS.sh     ← Automated helper script
│   └── backups/                   ← Timestamped DBC backups
│       └── backup_20251127_013337/
│
└── launcher/src/
    └── hitbox_patcher.rs          ← Rust hitbox patcher
```

---

## ⚡ **FASTEST PATH TO LAUNCH**

```bash
# 1. Apply SQL patch (30 seconds)
cd /home/keith/wowpack
mysql -u root -p azerothcore_world < dbc_patches/ITEM_LEVEL_REMOVAL.sql

# 2. Start servers (30 seconds)
cd azerothcore
./start-headless.sh

# 3. Connect with vanilla WoW client
# DONE! Fully functional Mortal Warcraft server!
```

**Total time:** ~1 minute  
**DBC editing:** Optional, can be done later for polish

---

## 🎯 **DECISION MATRIX**

| Need | Server-Side | Full DBC Patches |
|------|-------------|------------------|
| **Functional gameplay** | ✅ Yes | ✅ Yes |
| **Time to deploy** | 1 minute | ~6 hours |
| **Client patching** | ❌ No | ✅ Yes |
| **Professional polish** | ⚠️ Good | ✅ Excellent |
| **Easy to update** | ✅ Yes | ⚠️ Moderate |
| **Vanilla client compatible** | ✅ Yes | ❌ No (needs MPQ) |

**Recommendation:** Start with Server-Side (Option 1), add DBC polish later if desired.

---

## ✅ **STATUS SUMMARY**

```
╔══════════════════════════════════════════════════════╗
║                                                      ║
║  🟢 ALL DBC FILES: EXTRACTED AND READY              ║
║                                                      ║
║  ✅ Spell.dbc (47 MB) - Found                        ║
║  ✅ TalentTab.dbc (4 KB) - Found                     ║
║  ✅ CreatureModelData.dbc (196 KB) - Found           ║
║  ✅ CreatureDisplayInfo.dbc (1.6 MB) - Found         ║
║  ✅ Item.dbc (1.5 MB) - Found                        ║
║  ✅ Backups created                                  ║
║  ✅ CSV import files ready                           ║
║  ✅ SQL patches ready                                ║
║  ✅ Rust patchers ready                              ║
║                                                      ║
║  Status: READY TO LAUNCH (Server-Side)               ║
║          or READY TO PATCH (Full DBC)                ║
║                                                      ║
╚══════════════════════════════════════════════════════╝
```

---

**Choose your path:**
- 🚀 **Launch Now:** Use Option 1 (Server-Side)
- 🎨 **Polish Later:** Add Option 2 (DBC Patches) post-launch

Both paths are production-ready!


