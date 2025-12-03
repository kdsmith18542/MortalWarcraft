# Mortal Warcraft - Custom AzerothCore Fork

> **⚠️ This is a custom fork of [AzerothCore](https://github.com/azerothcore/azerothcore-wotlk)** maintained by Mortal Warcraft for our blizzlike era progression realm.
> 
> **Upstream Project**: https://github.com/azerothcore/azerothcore-wotlk

This repository features both custom survival gameplay and a blizzlike era progression realm, built on the robust AzerothCore emulator framework for World of Warcraft 3.3.5a servers.

## 🌿 About This Fork

This is a **custom fork** of AzerothCore maintained by Mortal Warcraft for our blizzlike era progression realm.

### Branches

This repository contains multiple server configurations:

- **`mortal-overhaul`**: Mortal Warcraft custom server with survival mechanics (main)
- **`realm2-era-progression`**: Classic Era progression server
- **`copilot/update-upstream-without-breaking`**: **Blizzlike WoW 3.3.5a Era Progression Realm** (THIS BRANCH)
  - Custom fork of AzerothCore for Mortal Warcraft
  - Stock AzerothCore source code with selective upstream updates
  - Authentic blizzlike experience
  - Era progression focused (Vanilla → TBC → WotLK)
  - Includes critical upstream bug fixes
  - **See [BLIZZLIKE_BRANCH_README.md](BLIZZLIKE_BRANCH_README.md) for details**

See [BRANCH_STRATEGY.md](BRANCH_STRATEGY.md) for branch usage and switching between realms.

## Current Branch: Blizzlike Era Progression

**You are viewing the Mortal Warcraft custom fork for blizzlike era progression.**

This is a custom fork of [AzerothCore](https://github.com/azerothcore/azerothcore-wotlk) maintained specifically for Mortal Warcraft's blizzlike progression realm.

This branch contains:
- ✅ Complete AzerothCore source code
- ✅ Stock WoW 3.3.5a mechanics
- ✅ 5 critical gameplay fixes from upstream
- ✅ Era progression configuration
- ✅ Upstream sync documentation
- ✅ Custom fork maintained for Mortal Warcraft project

**For custom Mortal Warcraft overhaul**, switch to the `mortal-overhaul` branch.

## 🎮 Overview - Blizzlike Branch

**This is a custom fork of AzerothCore for Mortal Warcraft's blizzlike era progression realm.**

This branch provides an authentic World of Warcraft 3.3.5a experience using the complete AzerothCore source:

### Blizzlike Features
- ✅ **Stock AzerothCore** - Full unmodified source code
- ✅ **9 Classes** - All retail classes with authentic abilities
- ✅ **Retail Mechanics** - Blizzlike spell system, combat, and progression
- ✅ **Era Progression** - Configure for Vanilla → TBC → WotLK phases
- ✅ **Critical Fixes** - 5 important gameplay bugs fixed
- ✅ **Upstream Tracking** - Stays synced with AzerothCore development

### Key Differences from Custom Branches
- **No custom skill systems** - Uses retail class/talent system
- **No procedural crafting** - Standard profession system
- **No survival mechanics** - Authentic WoW gameplay
- **Goal**: Provide a stable, blizzlike 3.3.5a server experience

See [BLIZZLIKE_BRANCH_README.md](BLIZZLIKE_BRANCH_README.md) for complete documentation.

## 📋 Quick Start - Blizzlike Branch

### Prerequisites
- Ubuntu 20.04+ (or Docker)
- MySQL 8.0+ or MariaDB 10.5+
- CMake 3.16+
- GCC 11+ or Clang 12+
- 8GB+ RAM recommended

### Build & Run

```bash
# Clone this branch (Mortal Warcraft custom fork - blizzlike era progression)
git clone -b copilot/update-upstream-without-breaking https://github.com/kdsmith18542/MortalWarcraft.git
cd MortalWarcraft

# Create build directory
mkdir build && cd build

# Configure and build
cmake .. -DCMAKE_INSTALL_PREFIX=$HOME/azeroth-server
make -j$(nproc)
make install

# Setup databases (see BLIZZLIKE_BRANCH_README.md for details)
cp env/dist/etc/worldserver.conf.dist env/dist/etc/worldserver.conf
# Edit worldserver.conf with your database credentials

# Start servers
./env/dist/bin/authserver
./env/dist/bin/worldserver
```

### Docker Deployment

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f worldserver

# Stop services
docker-compose down
```

### GPU Server Deployment

For high-performance builds on GPU compute servers:

```bash
# Automated deployment
./deploy-to-gpu-server.sh

# Or manual setup
ssh root@<server-ip>
cd /opt/mortal-warcraft
bash gpu-server-setup.sh
mortal build
mortal start
```

## 📁 Project Structure

```
wowpack/
├── azerothcore/              # AzerothCore server
│   ├── modules/
│   │   └── mortal_overhaul/  # Custom module
│   ├── src/                  # Core server code
│   └── env/dist/             # Compiled binaries
├── webportal/                # Web dashboard
│   ├── backend/              # Go API server
│   └── frontend/             # React frontend
├── launcher/                 # Rust-based game launcher
├── gameclientfiles/          # Client patches and addons
├── sql/                      # Database migrations
├── config/                    # Server configuration
└── docs/                     # Documentation
```

## 🔧 Key Features

### Core Systems
- **Mortal Skills**: Custom skill-based progression system
- **Procedural Crafting**: Dynamic item creation with quality tiers
- **Faction System**: Reputation-based PvP and territory control
- **Siege System**: Large-scale PvP events
- **Warfronts**: Zone-based PvP battles
- **Anomaly Dungeons**: Procedural micro-dungeons

### Survival Mechanics
- Hunger and thirst systems
- Encumbrance and inventory management
- Environmental hazards
- Weather effects
- Disease and injury systems

### Custom UI
- MortalUI addon framework
- AIO Client integration
- Real-time stat overlays
- Faction standing displays
- Zone risk indicators

## 📚 Documentation

- [Docker Migration Guide](DOCKER_MIGRATION_GUIDE.md) - Deploy to new servers
- [GPU Server Deployment](GPU_SERVER_DEPLOYMENT.md) - High-performance builds
- [Module Documentation](docs/) - System specifications

## 🛠️ Development

### Building the Module

```bash
cd azerothcore
mkdir build && cd build
cmake .. -DCMAKE_INSTALL_PREFIX=../env/dist
make -j$(nproc)
```

### Running Tests

```bash
# Server tests
cd azerothcore/build
ctest

# Database migrations
mysql -u root -p < sql/migrations/001_initial.sql
```

### Code Style

- C++: Follow AzerothCore conventions
- Go: `gofmt` and `golint`
- JavaScript: ESLint with Prettier

## 🐳 Docker Services

- **mysql**: Database server
- **authserver**: Authentication server
- **worldserver**: Game world server
- **webportal-backend**: API server
- **webportal-frontend**: Web dashboard

## 📊 Server Management

### Local Commands

```bash
# Start servers
./scripts/start-servers.sh

# Stop servers
./scripts/stop-servers.sh

# View logs
tail -f azerothcore/env/dist/logs/worldserver.log
```

### Remote Commands (GPU Server)

```bash
# Status
./remote-monitor.sh status

# Logs
./remote-monitor.sh logs worldserver

# Build
./remote-build.sh
```

## 🔐 Security

- Change default passwords in `.env`
- Use SSH keys instead of passwords
- Enable firewall rules
- Use Docker secrets for production

## 📝 Contributing

1. Create feature branch
2. Make changes
3. Test thoroughly
4. Submit pull request

## 📄 License

This project inherits the **GNU AGPL v3.0** license from AzerothCore.

See [LICENSE](LICENSE) for full details.

**Note**: This is a custom fork maintained by Mortal Warcraft. The original AzerothCore project can be found at https://github.com/azerothcore/azerothcore-wotlk

## 🙏 Acknowledgments

**This project is a custom fork of AzerothCore.**

### Upstream Project
- **AzerothCore**: https://github.com/azerothcore/azerothcore-wotlk
- **License**: GNU AGPL v3.0
- **Documentation**: https://www.azerothcore.org/wiki/

### Credits
- AzerothCore team and contributors for the core emulator
- WoW 3.3.5a community
- Mortal Warcraft team for this custom fork
- All contributors to this repository

## 📞 Support

- Documentation: See `docs/` directory
- Issues: [GitHub Issues]
- Discord: [Your Discord]

---

**Status**: Active Development
**Version**: 1.0.0
**Last Updated**: 2024
