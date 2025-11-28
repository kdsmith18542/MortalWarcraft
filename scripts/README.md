# Mortal Warcraft Overhaul - Scripts

Utility scripts for setup, installation, and maintenance.

## Available Scripts

### Installation Scripts

- **`install_database.sh`** - Installs database tables
- **`setup_lua.sh`** - Copies Lua scripts to Eluna directory
- **`execute_phase3_sql.sh`** - Executes Phase 3 SQL scripts on databases

### Addon Scripts

- **`bundle_addon_pack.sh`** - Creates distributable addon pack ZIP
- **`setup_external_addons.sh`** - Helper for downloading external addons

## Usage

### Database Setup

```bash
# Install all database tables
./scripts/install_database.sh

# Execute Phase 3 SQL scripts
./scripts/execute_phase3_sql.sh
```

### Addon Pack Creation

```bash
# Setup external addons (download instructions)
./scripts/setup_external_addons.sh

# Create addon pack ZIP
./scripts/bundle_addon_pack.sh
```

### Lua Scripts

```bash
# Copy Lua scripts to Eluna directory
./scripts/setup_lua.sh
```

## Notes

- All scripts require appropriate permissions (chmod +x)
- Database scripts require MySQL credentials
- Addon pack requires external addons to be downloaded first

