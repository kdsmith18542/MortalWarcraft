# Blizzlike Era Progression Branch

## Overview

This branch contains a **blizzlike WoW 3.3.5a server** based on AzerothCore, focused on providing an authentic era progression experience. This is separate from the custom Mortal Warcraft overhaul in other branches.

## Branch Purpose

- **Blizzlike Gameplay**: Authentic WoW 3.3.5a experience
- **Era Progression**: Classic content progression approach
- **Bug Fixes**: Includes critical gameplay fixes from upstream
- **Stable Base**: Uses official AzerothCore source code

## Differences from Main Branch

| Aspect | This Branch (Blizzlike) | Main Branch (Mortal Overhaul) |
|--------|------------------------|-------------------------------|
| **Core** | Stock AzerothCore | Custom modified core |
| **Classes** | Blizzlike classes | Custom skill system |
| **Crafting** | Standard professions | Procedural crafting + quality |
| **Combat** | Retail mechanics | Custom combat mechanics |
| **Progression** | Era-based unlock | Custom progression |
| **Purpose** | Authentic experience | Survival MMO overhaul |

## Repository Structure

```
MortalWarcraft/
├── src/                        # AzerothCore source code (C++)
├── data/                       # World data (maps, vmaps, mmaps, dbc)
├── sql/                        # Database scripts
│   ├── base/                   # Base database structure
│   ├── updates/                # Incremental updates
│   └── critical_fixes/         # Custom critical bug fixes (NEW)
├── modules/                    # Optional modules
├── conf/                       # Server configuration files
├── apps/                       # Docker and deployment tools
└── docs/                       # Documentation

Custom Documentation:
├── UPSTREAM_SYNC_GUIDE.md      # How to sync with AzerothCore upstream
├── BLIZZLIKE_BRANCH_README.md  # This file
└── sql/critical_fixes/         # 5 critical gameplay fixes applied
```

## Features

### Stock AzerothCore

This branch uses the complete, unmodified AzerothCore source:
- All 9 classes with retail abilities
- Standard talent trees
- Blizzlike spell mechanics
- Authentic dungeon/raid scripting
- Retail-like PvP and Battlegrounds

### Critical Fixes Applied

This branch includes fixes for 5 critical upstream issues:

1. **SAI Event Link Fix** - Corrects broken NPC behaviors
2. **Surveyor Candress Balance** - Fixes overtuned low-level NPC
3. **Blade of Eternal Darkness** - Enables proc crits properly
4. **Profession System** - Prevents profession limit exploits
5. **Eye of the Storm Bug** - Mitigates immunity falling exploit

See `sql/critical_fixes/README.md` for details.

### Era Progression

Configure your server for era-style progression:
- Unlock content in phases (Vanilla → TBC → WotLK)
- Disable or limit higher-tier content
- Progressive itemization
- Phased dungeon/raid availability

## Quick Start

### Prerequisites

- **OS**: Ubuntu 20.04+ or Docker
- **Database**: MySQL 8.0+ or MariaDB 10.5+
- **Compiler**: GCC 11+ or Clang 12+
- **CMake**: 3.16+
- **RAM**: 8GB+ recommended

### Build Instructions

```bash
# 1. Clone this branch
git clone -b copilot/update-upstream-without-breaking https://github.com/kdsmith18542/MortalWarcraft.git
cd MortalWarcraft

# 2. Create build directory
mkdir build && cd build

# 3. Configure build
cmake .. \
  -DCMAKE_INSTALL_PREFIX=$HOME/azeroth-server \
  -DCMAKE_C_COMPILER=/usr/bin/clang \
  -DCMAKE_CXX_COMPILER=/usr/bin/clang++ \
  -DWITH_WARNINGS=1 \
  -DTOOLS_BUILD=all \
  -DSCRIPTS=static \
  -DMODULES=static

# 4. Build (use all CPU cores)
make -j$(nproc)

# 5. Install
make install
```

### Database Setup

```bash
# Create databases
mysql -u root -p << EOF
CREATE DATABASE acore_world DEFAULT CHARACTER SET UTF8MB4 COLLATE utf8mb4_general_ci;
CREATE DATABASE acore_characters DEFAULT CHARACTER SET UTF8MB4 COLLATE utf8mb4_general_ci;
CREATE DATABASE acore_auth DEFAULT CHARACTER SET UTF8MB4 COLLATE utf8mb4_general_ci;

CREATE USER 'acore'@'localhost' IDENTIFIED BY 'acore';
GRANT ALL PRIVILEGES ON acore_world.* TO 'acore'@'localhost';
GRANT ALL PRIVILEGES ON acore_characters.* TO 'acore'@'localhost';
GRANT ALL PRIVILEGES ON acore_auth.* TO 'acore'@'localhost';
EOF

# Import base databases
cd ~/azeroth-server
mysql -u acore -p acore_auth < data/sql/base/db_auth/auth_database.sql
mysql -u acore -p acore_characters < data/sql/base/db_characters/characters_database.sql
mysql -u acore -p acore_world < data/sql/base/db_world/world_database.sql

# Apply critical fixes
cd /path/to/MortalWarcraft
mysql -u acore -p acore_world < sql/critical_fixes/001_sai_event_link_fix.sql
mysql -u acore -p acore_world < sql/critical_fixes/002_surveyor_candress_fix.sql
mysql -u acore -p acore_world < sql/critical_fixes/003_blade_of_eternal_darkness_crit.sql
mysql -u acore -p acore_characters < sql/critical_fixes/004_profession_learning_fix.sql
mysql -u acore -p acore_world < sql/critical_fixes/005_eots_immunity_death_fix.sql
```

### Docker Setup (Alternative)

```bash
# Use Docker for easy deployment
docker-compose up -d

# Databases will be automatically set up
# Server will be available on port 8085 (auth) and 8086 (world)
```

### Client Data

Download required client data files:

```bash
cd ~/azeroth-server/data

# Download from official sources
# DBC, Maps, VMaps, MMaps files
# See: https://github.com/wowgaming/client-data
```

### Configuration

```bash
cd ~/azeroth-server/etc

# Copy config templates
cp worldserver.conf.dist worldserver.conf
cp authserver.conf.dist authserver.conf

# Edit configurations
nano worldserver.conf  # Set database credentials, rates, etc.
nano authserver.conf   # Set database credentials
```

### Start Server

```bash
cd ~/azeroth-server/bin

# Start auth server
./authserver

# In another terminal, start world server
./worldserver

# Create admin account in worldserver console:
# account create <username> <password>
# account set gmlevel <username> 3 -1
```

## Era Progression Configuration

To enable era progression, edit `worldserver.conf`:

```ini
###################################################################################################
# ERA PROGRESSION SETTINGS
###################################################################################################

# Disable expansion content
Expansion = 0  # 0 = Vanilla only, 1 = + TBC, 2 = + WotLK

# Limit max level
MaxPlayerLevel = 60  # Set to 60 for Vanilla, 70 for TBC, 80 for WotLK

# Disable flying (for Vanilla/TBC phases)
AllowFlying = 0

# Disable death knights (for pre-WotLK)
AllowDeathKnight = 0

# XP rates (optional, 1x for blizzlike)
Rate.XP.Kill    = 1
Rate.XP.Quest   = 1
Rate.XP.Explore = 1

# Honor/reputation rates (optional, 1x for blizzlike)
Rate.Honor = 1
Rate.Reputation.Gain = 1

# Drop rates (1x for blizzlike)
Rate.Drop.Item.Poor             = 1
Rate.Drop.Item.Normal           = 1
Rate.Drop.Item.Uncommon         = 1
Rate.Drop.Item.Rare             = 1
Rate.Drop.Item.Epic             = 1
Rate.Drop.Item.Legendary        = 1
Rate.Drop.Item.Artifact         = 1
Rate.Drop.Money                 = 1
```

## Syncing with Upstream

This branch tracks AzerothCore upstream. To update:

```bash
# 1. Fetch latest upstream changes
git fetch upstream master

# 2. Review what's new
git log HEAD..upstream/master --oneline

# 3. Merge carefully
git merge upstream/master

# 4. Resolve any conflicts
# 5. Test thoroughly before deploying
```

See `UPSTREAM_SYNC_GUIDE.md` for detailed sync procedures.

## Modules

Add optional modules to `modules/` directory:

- `mod-transmog` - Transmog system
- `mod-ah-bot` - Auction house bot
- `mod-weekend-xp` - Weekend XP bonus
- `mod-cfbg` - Cross-faction battlegrounds
- etc.

Browse modules at: https://github.com/azerothcore/modules

## Testing

```bash
# Build tests
cmake .. -DBUILD_TESTING=1
make -j$(nproc)

# Run unit tests
ctest --output-on-failure

# Run specific test
./tests/unit/UnitTest
```

## Troubleshooting

### Build Errors

```bash
# Update submodules
git submodule update --init --recursive

# Clean build
rm -rf build/
mkdir build && cd build
cmake ..
make clean && make -j$(nproc)
```

### Database Issues

```bash
# Check database updates
./worldserver --update-databases-only

# Reset databases (WARNING: deletes all data)
mysql -u acore -p acore_world < data/sql/base/db_world/world_database.sql
```

### Server Crashes

Check logs in `~/azeroth-server/logs/`:
- `Server.log` - General server log
- `DBErrors.log` - Database errors
- `Crashes/` - Crash dumps

## Performance Tuning

### Database Optimization

```sql
-- Add indexes for better performance
USE acore_world;
CREATE INDEX idx_creature_guid ON creature(guid);
CREATE INDEX idx_gameobject_guid ON gameobject(guid);

USE acore_characters;
CREATE INDEX idx_character_guid ON characters(guid);
CREATE INDEX idx_skill_guid ON character_skills(guid, skill);
```

### Server Configuration

```ini
# In worldserver.conf

# Increase update rates for smoother gameplay
Rate.Creature.Aggro = 1

# Adjust thread count (use CPU cores - 1)
WorldServerPort = 8085
Threads.WorldUpdate = 1
Threads.DatabaseAsync = 2

# Enable caching
Cache.DataQueries = 1
```

## Security

```ini
# In worldserver.conf

# Disable .gm commands for non-GMs
GM.StartLevel = 3

# Require secure GM login
GM.LoginState = 1

# Log GM commands
GM.LogTrade = 1

# Prevent account sharing
Warden.Enabled = 1
```

## Backup Strategy

```bash
# Backup script
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backups/azerothcore"

# Backup databases
mysqldump -u acore -p acore_world > $BACKUP_DIR/world_$DATE.sql
mysqldump -u acore -p acore_characters > $BACKUP_DIR/characters_$DATE.sql
mysqldump -u acore -p acore_auth > $BACKUP_DIR/auth_$DATE.sql

# Compress
tar -czf $BACKUP_DIR/backup_$DATE.tar.gz $BACKUP_DIR/*_$DATE.sql

# Clean up old SQL files
rm $BACKUP_DIR/*_$DATE.sql
```

## Community Resources

- **AzerothCore**: https://www.azerothcore.org/
- **Wiki**: https://www.azerothcore.org/wiki/
- **Discord**: https://discord.gg/gkt4y2x
- **Issue Tracker**: https://github.com/azerothcore/azerothcore-wotlk/issues
- **Module Catalogue**: https://github.com/azerothcore/modules-catalogue

## Contributing

When contributing to this blizzlike branch:

1. Keep changes blizzlike (no custom systems)
2. Test with stock AzerothCore configs
3. Document any configuration changes
4. Provide rollback procedures
5. Reference upstream issues when fixing bugs

## Branch Maintenance

This branch is maintained separately from:
- `mortal-overhaul` - Custom survival overhaul
- `main` - May contain other content
- `realm2-era-progression` - Alternative era config

Do not merge custom overhaul changes into this branch.

## Support

- **Branch-specific issues**: Open an issue in this repository
- **AzerothCore bugs**: Report to upstream AzerothCore
- **Critical fixes**: See `sql/critical_fixes/README.md`
- **Sync issues**: See `UPSTREAM_SYNC_GUIDE.md`

## License

This project uses AzerothCore which is licensed under AGPL-3.0.
See `LICENSE` file for details.

## Credits

- **AzerothCore Team** - Core development
- **Community Contributors** - Modules and fixes
- **This Branch** - Blizzlike era progression configuration + critical fixes

---

**Last Updated**: December 3, 2025
**AzerothCore Version**: Merged from upstream/master (commit ef8d421)
**Status**: Active Development - Blizzlike Focus
