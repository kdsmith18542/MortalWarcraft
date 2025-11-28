# Mortal Warcraft - AzerothCore Custom Server

A comprehensive custom World of Warcraft 3.3.5a server built on AzerothCore with extensive modifications for survival gameplay.

## 🌿 Branches

This repository contains two separate server realms:

- **`mortal-overhaul`** (default): Mortal Warcraft custom server with survival mechanics
- **`realm2-era-progression`**: Classic Era progression server

See [BRANCH_STRATEGY.md](BRANCH_STRATEGY.md) for branch usage and switching between realms.

## 🎮 Overview

Mortal Warcraft transforms the classic WoW experience into a hardcore survival MMO with:
- Custom skill system replacing class abilities
- Procedural crafting and quality system
- Faction-based PvP and territory control
- Dynamic events (sieges, warfronts, anomalies)
- Survival mechanics (hunger, encumbrance, environmental hazards)
- Custom UI and addon framework

## 📋 Quick Start

### Prerequisites
- Ubuntu 22.04+ (or Docker)
- MySQL 8.0+
- CMake 3.20+
- GCC 11+
- 8GB+ RAM recommended

### Local Development

```bash
# Clone repository
git clone <repository-url>
cd wowpack

# Setup databases
mysql -u root -p < sql/create_databases.sql

# Build AzerothCore
cd azerothcore
mkdir build && cd build
cmake .. -DCMAKE_INSTALL_PREFIX=../env/dist
make -j$(nproc)
make install

# Configure
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

[Your License Here]

## 🙏 Acknowledgments

- AzerothCore team
- WoW 3.3.5a community
- All contributors

## 📞 Support

- Documentation: See `docs/` directory
- Issues: [GitHub Issues]
- Discord: [Your Discord]

---

**Status**: Active Development
**Version**: 1.0.0
**Last Updated**: 2024
