# Mortal Client Launcher (Tauri) – Cursor-Ready Spec
Version: 1.0  
Project: Mortal Warcraft Overhaul – Desktop Launcher  

---

## Related Specs

- `15-ui-client.md` - MortalUI addon pack that launcher installs and manages
- `24-webportal-mortal-atlas.md` - Web portal that launcher links to
- `20-aio-ui-basics.md` - AIO UI system that client integrates with
- `101-mortal-addon-policy.md` - Addon policy for MortalUI addon pack

---

## 1. Purpose & Role

The **Mortal Client Launcher** is a desktop app that:

- Boots the **3.3.5a client** into Mortal mode.
- Manages **patching & file integrity** (Patch-Z, MPQs, config).
- Installs and keeps in sync the **MortalUI addon pack**.
- Injects **config** (realmlist, WTF settings, addons enabled).
- Acts as a soft **anti-tamper / sanity check** (basic file checks, not full anti-cheat).
- Provides convenient access to:
  - News + links to **Mortal Atlas** web portal.
  - Supporter/shop links.
  - Log location & troubleshooting.

Target stack:

- **Tauri** (Rust backend + Web frontend).
- Frontend: React + TypeScript (or Svelte – spec assumes React but can be swapped).

---

## 2. Tech Stack

**Desktop Container**

- Tauri 2.x
- Rust 1.75+

**Rust Backend**

- `reqwest` (HTTP client) – for manifest download.
- `serde` / `serde_json` – config + manifest parsing.
- `tokio` – async tasks.
- `sha2` or `blake3` – file hashing.
- `anyhow` / `thiserror` – error handling.
- `directories` – OS-specific paths (config/logs).

**Frontend**

- React + TypeScript + Vite
- Tailwind CSS
- React Query (optional) – for launcher UI requests to Tauri commands.
- Zustand – simple local state.

---

## 3. Repo Layout

Root folder: `mortal-launcher/`

```bash
mortal-launcher/
├── src-tauri/
│   ├── tauri.conf.json
│   ├── Cargo.toml
│   └── src/
│       ├── main.rs
│       ├── config.rs
│       ├── manifest.rs
│       ├── patcher.rs
│       ├── wow_paths.rs
│       ├── addons.rs
│       ├── diagnostics.rs
│       └── commands.rs   # Tauri command registration
├── src/
│   ├── main.tsx
│   ├── App.tsx
│   ├── pages/
│   │   ├── Dashboard.tsx
│   │   ├── Settings.tsx
│   │   ├── Logs.tsx
│   │   └── About.tsx
│   ├── components/
│   │   ├── layout/
│   │   │   ├── Sidebar.tsx
│   │   │   └── Header.tsx
│   │   ├── StatusCard.tsx
│   │   ├── ProgressBar.tsx
│   │   ├── LogViewer.tsx
│   │   └── LaunchButton.tsx
│   ├── stores/
│   │   └── launcherStore.ts
│   ├── lib/
│   │   └── tauriClient.ts  # wrappers around Tauri commands
│   └── styles/
│       └── index.css
├── package.json
└── README.md
```

---

## 4. Core Features

1. **Game Path Discovery & Selection**
   - Auto-detect WoW 3.3.5a install if possible.
   - Allow manual selection of client folder.
   - Persist selected path in launcher config.

2. **Manifest-Based Patching**
   - Fetch remote **manifest.json** from Mortal CDN:
     - List of files (Patch-Z MPQs, configs, addons, etc.).
     - Hash + size + destination path.
   - Compare local files → download missing/changed ones.
   - Show progress and status to user.

3. **MortalUI Addon Pack Management**
   - Ensure `/Interface/AddOns` contains:
     - MortalUI core addon.
     - Immersion, DynamicCam (if enabled), Bagnon, Bartender, Mapster, HandyNotes, etc.
   - Overwrite/replace Mortal-managed addons if out of date.

4. **Config Injection**
   - Ensure:
     - `realmlist.wtf` points to Mortal server.
     - Key WTF config flags set:
       - Addon enable states.
       - Recommended graphics/network tweaks (optional).
   - Never touch personal keybindings unless explicitly allowed.

5. **Launch Game**
   - Run WoW client executable with appropriate working directory.
   - Optional: CLI argument to load a specific config.

6. **Diagnostics**
   - Run basic health checks:
     - Can reach patch server / Atlas.
     - Free disk space.
     - Missing or corrupted files.
   - Show guidance messages.

---

## 5. Config & Manifest

### 5.1 Launcher Config

`src-tauri/src/config.rs`:

```rust
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize, Default)]
pub struct LauncherConfig {
    pub wow_path: Option<String>,
    pub manifest_url: String,
    pub patch_channel: String, // "stable", "experimental"
    pub last_checked: Option<String>,
}
```

- Stored as JSON in OS config dir:
  - `%APPDATA%/MortalLauncher/config.json` (Windows)
  - `~/.config/mortal-launcher/config.json` (Linux)

### 5.2 Manifest Format (Remote)

Example `manifest.json` served from CDN:

```json
{
  "version": "26.0.0",
  "files": [
    {
      "path": "Data/patch-Mortal.MPQ",
      "hash": "abc123...",
      "size": 12345678
    },
    {
      "path": "Interface/AddOns/MortalUI/core.lua",
      "hash": "def456...",
      "size": 34567
    },
    {
      "path": "WTF/Config-Mortal.wtf",
      "hash": "ghi789...",
      "size": 1024
    }
  ]
}
```

`src-tauri/src/manifest.rs`:

```rust
#[derive(Debug, Serialize, Deserialize)]
pub struct ManifestFile {
    pub path: String,
    pub hash: String,
    pub size: u64,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct Manifest {
    pub version: String,
    pub files: Vec<ManifestFile>,
}
```

---

## 6. Rust Backend Modules

### 6.1 wow_paths.rs

- Responsibilities:
  - Discover WoW installation paths (if possible).
  - Validate user-provided path (check for `Wow.exe` or `Wow-64.exe`, `Data/`, etc.).

Key functions:

```rust
pub fn auto_detect_wow_path() -> Option<PathBuf> { /* ... */ }
pub fn validate_wow_path(path: &Path) -> bool { /* ... */ }
```

### 6.2 patcher.rs

- Responsibilities:
  - Fetch remote manifest.
  - Scan local files, compute hashes.
  - Queue and download required files.
  - Write to correct locations under WoW path.

Key functions:

```rust
pub async fn fetch_manifest(config: &LauncherConfig) -> Result<Manifest> { /* ... */ }

pub async fn check_missing_or_outdated(
    wow_path: &Path,
    manifest: &Manifest,
) -> Result<Vec<ManifestFile>> { /* ... */ }

pub async fn apply_patches(
    wow_path: &Path,
    files: &[ManifestFile],
    on_progress: impl Fn(u64, u64),
) -> Result<()> { /* ... */ }
```

Use `reqwest` for downloads, `blake3` or `sha2` for hashing.

### 6.3 addons.rs

- Responsibilities:
  - Ensure MortalUI addon pack is installed.
  - Remove or overwrite outdated Mortal-specific files.
  - Optionally leave non-Mortal addons untouched.

### 6.4 diagnostics.rs

- Responsibilities:
  - Check network connectivity to manifest server.
  - Check disk space in WoW folder drive.
  - Verify core files exist.

Result DTO:

```rust
#[derive(Serialize)]
pub struct DiagnosticReport {
    pub can_reach_manifest: bool,
    pub has_enough_disk_space: bool,
    pub wow_path_valid: bool,
    pub missing_files: Vec<String>,
}
```

### 6.5 commands.rs (Tauri Commands)

Example commands to expose to frontend:

```rust
#[tauri::command]
pub async fn get_config() -> Result<LauncherConfig, String> { /* ... */ }

#[tauri::command]
pub async fn save_config(config: LauncherConfig) -> Result<(), String> { /* ... */ }

#[tauri::command]
pub async fn run_diagnostics() -> Result<DiagnosticReport, String> { /* ... */ }

#[tauri::command]
pub async fn check_for_updates() -> Result<UpdateCheckResult, String> { /* ... */ }

#[tauri::command]
pub async fn apply_updates() -> Result<(), String> { /* ... */ }

#[tauri::command]
pub async fn launch_game() -> Result<(), String> { /* ... */ }
```

All commands should return serializable types and simple error strings for the front-end.

---

## 7. Frontend Design

### 7.1 Pages

#### Dashboard.tsx

- Shows:
  - Detected WoW path.
  - Current Mortal build (from manifest version).
  - Status pills:
    - “Up to date” / “Update available”.
    - “Ready to launch” / “Issues found”.
- Buttons:
  - **Check for updates**
  - **Apply updates**
  - **Launch Mortal**

#### Settings.tsx

- WoW path selector:
  - Text field + “Browse” button (calls Tauri `open` dialog).
  - “Validate path” button.
- Patch channel dropdown:
  - `stable`, `experimental`.
- Option toggles:
  - “Force re-check all files”
  - “Auto-check for updates on launch”

#### Logs.tsx

- Tail view of launcher log file (via Tauri command).
- Simple filter/search.

#### About.tsx

- Mortal branding, links:
  - Atlas web portal.
  - Discord.
  - Support page.
- Launcher version.

---

### 7.2 State Management

`launcherStore.ts` (Zustand):

- Holds:
  - `wowPath`
  - `manifestVersion`
  - `status` (`idle | checking | updating | ready | error`)
  - `diagnostics` (DiagnosticReport)
- Methods call Tauri commands via `tauriClient.ts`.

---

## 8. Integration Points

### 8.1 With Mortal Atlas

- Dashboard can show link to:
  - Atlas killboard.
  - Atlas map.
- Optional: call an Atlas endpoint for:
  - Server status (online, player count).
  - News banner.

### 8.2 With MortalUI Spec

Launcher is the **enforcer** for:

- Which addons ship with Mortal.
- Where to place:
  - `MortalUI/` core.
  - Bundled third-party addons with preconfigured settings.

It should not attempt to manage **every** user addon, only the Mortal-curated pack.

---

## 9. Environment & Build

### Dev

```bash
# Install deps
npm install
# Run Tauri dev (starts frontend + Tauri)
npm run tauri dev
```

### Build

```bash
npm run tauri build
```

Artifacts:

- Windows: `.msi` or `.exe` installer.
- Linux: `.AppImage` / `.deb` depending on config.

---

## 10. Cursor Tasks (Suggested)

1. **Initialize Tauri project** with React + TS:
   - `npm create tauri-app` or equivalent Vite + Tauri template.
2. Implement `LauncherConfig` in `config.rs` and load/save logic.
3. Implement `wow_paths.rs` and expose Tauri commands to:
   - Get current config.
   - Set WoW path.
   - Validate WoW path.
4. Implement `manifest.rs` + `patcher.rs`:
   - Hardcode a test `manifest_url` initially.
   - Implement `check_for_updates` and `apply_updates` commands.
5. Implement `diagnostics.rs` and wire `run_diagnostics` command.
6. Frontend:
   - Build `Dashboard`, `Settings`, basic layout.
   - Wire buttons to Tauri commands via `tauriClient.ts`.
   - Display progress bar during `apply_updates`.

---

## 11. Status

This file is the **Cursor-ready technical blueprint** for the Mortal Launcher:

- Tauri + Rust backend.
- React + TS front-end.
- Manifest-driven patcher.
- WoW path management.
- MortalUI addon deployment.
- Basic diagnostics + game launch.

It should be saved as:

`docs/25-launcher-mortal-client.md`

inside your main Mortal project or a separate `mortal-launcher` repo.
