# Quick Start Guide

## 5-Minute Setup

### 1. Prerequisites Check
```bash
# Check if you have the required tools
which mysql cmake gcc
```

### 2. Install Dependencies (if missing)
```bash
sudo apt-get update
sudo apt-get install -y ccache libmysqlclient-dev libboost-all-dev google-perftools
```

### 3. Database Setup
```bash
cd /path/to/azerothcore
./modules/mortal_overhaul/scripts/install_database.sh
```

### 4. Lua Scripts
```bash
./modules/mortal_overhaul/scripts/setup_lua.sh
```

### 5. Add Prepared Statements
Edit `src/Server/Database/CharacterDatabase.cpp` - see `IMPLEMENTATION_GUIDE.md`

### 6. Compile
```bash
mkdir -p build && cd build
cmake ..
make -j$(nproc)
```

### 7. Configure
Edit `worldserver.conf`:
```ini
MortalOverhaul.Enable = 1
RandomDungeonFinder.Enable = 0
Eluna.Enabled = 1
```

### 8. Start Server
```bash
./bin/worldserver
```

## Verification Checklist

- [ ] Server starts without errors
- [ ] Can log into game
- [ ] XP gain is disabled
- [ ] Level is 1 for new character
- [ ] Weapon skills are 400
- [ ] No soulbound items (except quest items)

## Next Steps

1. Configure zones in Lua scripts
2. Set up world bosses
3. Configure NPC entry IDs
4. Test crafting system
5. Test PvP systems

For detailed information, see `IMPLEMENTATION_GUIDE.md`

