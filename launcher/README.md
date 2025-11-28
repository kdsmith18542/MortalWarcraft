# Mortal Warcraft Launcher

Cross-platform launcher for Mortal Warcraft Overhaul client.

## Features

- **Client Integrity Checks** - Verifies WoW client files
- **DBC Auto-Patching** - Automatically patches Item.dbc to remove level requirements
- **Addon Installation** - Installs MortalUI and required addons
- **Config Injection** - Sets up realmlist and client configuration
- **Manifest Sync** - Downloads and verifies client file manifest

## Requirements

- Rust 1.70+ and Cargo
- Node.js 18+ (for Tauri)
- WoW 3.3.5a client

## Building

```bash
cd launcher
cargo build --release
```

The executable will be in `target/release/mortal-launcher` (or `.exe` on Windows).

## Development

```bash
cargo tauri dev
```

## Usage

1. Run the launcher
2. Select or auto-detect WoW client path
3. Click "Patch Client" to apply DBC patches
4. Click "Install Addons" to install addon pack
5. Configure server IP/port
6. Launch game

## Configuration

The launcher will:
- Create `realmlist.wtf` with server IP
- Patch `Data/dbc/item.dbc` (removes level requirements)
- Install addons to `Interface/AddOns/`
- Verify client integrity

## Notes

- DBC patches create backups automatically (`.dbc.backup`)
- Addon pack must be in `addon-pack/` directory relative to launcher
- Client path can be set via `WOW_PATH` environment variable

## Troubleshooting

**Client not found:**
- Set `WOW_PATH` environment variable
- Or manually select client path in launcher

**DBC patching fails:**
- Ensure client is not running
- Check file permissions
- Verify DBC file structure (may need field index adjustment)

**Addons not installing:**
- Ensure `addon-pack/` directory exists
- Check that addon directories are present

