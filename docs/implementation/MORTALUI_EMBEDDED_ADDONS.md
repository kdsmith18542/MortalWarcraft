# MortalUI: Embedded Addons & Dependencies

**Date:** 2025-01-XX  
**Purpose:** Document all embedded addons and external dependencies used by MortalUI

---

## Embedded Addons (Included in MortalUI)

### 1. AIO (Addon Input/Output) ✅ Embedded

**Location:** `addons/MortalUI/Embedded/AIO_Client/`

**Purpose:**
- Enables client-server communication
- Allows server to send addon code to clients
- Handles addon message passing
- Used for all server-side data requests (sieges, warfronts, etc.)

**Components:**
- `AIO.lua` - Core AIO functionality
- `queue.lua` - Message queue system
- `Dep_LibWindow-1.1/` - Window positioning library (dependency)
- `Dep_Smallfolk/` - Serialization library (dependency)
- `lualzw-zeros/` - Compression library (dependency)

**Usage in MortalUI:**
- `MortalUI_PvPPanel.lua` - Uses `AIO.Handle()` for requests
- `lua/aio/siege_ui.lua` - Server-side handler using AIO

**Version:** Embedded version (Rochet2's AIO)

---

### 2. Ace3 Libraries ✅ Embedded

**Location:** `addons/MortalUI/Libs/Ace3/`

**Components:**

#### 2.1 AceAddon-3.0
- Addon framework
- Module system
- Used by: `MortalUI_Core.lua`, `MortalUI_PvPPanel.lua`

#### 2.2 AceConsole-3.0
- Slash command system
- Used by: `MortalUI_Core.lua` for `/mortalui` commands

#### 2.3 AceDB-3.0
- Database/settings management
- SavedVariables handling
- Used by: `MortalUI_Core.lua` for configuration

#### 2.4 AceEvent-3.0
- Event system
- Used by: All MortalUI modules for event handling

**Usage:**
```lua
MortalUI = LibStub("AceAddon-3.0"):NewAddon("MortalUI", "AceConsole-3.0", "AceEvent-3.0")
```

---

### 3. LibStub ✅ Embedded

**Location:** `addons/MortalUI/Libs/LibStub/`

**Purpose:**
- Library loader and version management
- Required by Ace3 and other libraries
- Ensures single instance of libraries

**Usage:**
```lua
local MortalAddon = LibStub("AceAddon-3.0"):GetAddon("MortalUI", true)
```

---

### 4. LibWindow-1.1 ✅ Embedded (via AIO)

**Location:** `addons/MortalUI/Embedded/AIO_Client/Dep_LibWindow-1.1/`

**Purpose:**
- Window positioning and saving
- Used by AIO for frame management
- Handles window drag/drop and position persistence

---

### 5. Smallfolk ✅ Embedded (via AIO)

**Location:** `addons/MortalUI/Embedded/AIO_Client/Dep_Smallfolk/`

**Purpose:**
- Lua table serialization
- Used by AIO for data transmission
- Converts Lua tables to strings for network transfer

---

### 6. lualzw-zeros ✅ Embedded (via AIO)

**Location:** `addons/MortalUI/Embedded/AIO_Client/lualzw-zeros/`

**Purpose:**
- LZW compression algorithm
- Used by AIO to compress addon messages
- Reduces network traffic for large data transfers

---

## Embedded Addons (Recently Added)

### 7. HandyNotes ✅ Embedded

**Location:** `addons/MortalUI/Embedded/HandyNotes/`

**Purpose:**
- Map pin display system
- Shows custom icons on world map and minimap
- Used by: `MortalUI_MapPins.lua`

**Status:** ✅ **NOW EMBEDDED** (as of 2025-01-XX)

**Features:**
- Minimal HandyNotes implementation
- Provides core API needed for map pins
- Prefers external HandyNotes if player has it installed
- Falls back to embedded version automatically

**Usage:**
```lua
-- HandyNotes is now always available (embedded)
local HandyNotes = _G.HandyNotes
if HandyNotes then
    HandyNotes:RegisterPluginDB("MortalPins", plugin, options)
end
```

**Impact:**
- ✅ Map pins work out of the box
- ✅ No external installation required
- ✅ Compatible with external HandyNotes (if installed)

**Where Used:**
- Siege waypoint system
- War camp map pins
- Stronghold markers

**Note:** See `docs/implementation/HANDYNOTES_EMBEDDED.md` for full details.

---

## External Dependencies (NOT Embedded)

### 1. HandyNotes ⚠️ Optional (Player Can Install)

**Status:** External dependency, OPTIONAL (embedded version available)

**Purpose:**
- Full-featured HandyNotes addon
- Provides advanced features and UI

**Impact:**
- Embedded version is used if external not installed
- External version is preferred if installed
- No impact on functionality - embedded version works fine

**Where Used:**
- Same as embedded version (siege waypoints, war camps, etc.)

---

### 2. TomTom ⚠️ Optional (Player Can Install)

**Status:** External dependency, NOT embedded (optional)

**Purpose:**
- Waypoint navigation system
- Provides arrow/compass for navigation
- Used by: `MortalUI_PvPPanel.lua` for siege waypoints

**Usage:**
```lua
if TomTom then
    TomTom:AddWaypoint(mapId, x/100, y/100, {
        title = label,
        persistent = false,
        minimap = true,
        world = true
    })
end
```

**Impact:**
- Waypoint navigation won't work without it
- Gracefully degrades (no error, just skips TomTom integration)
- HandyNotes pins still work without TomTom

**Where Used:**
- "Set Waypoint" button in Sieges tab
- War camp navigation

---

## Dependency Tree

```
MortalUI
├── Embedded (Always Available):
│   ├── AIO_Client
│   │   ├── LibWindow-1.1
│   │   ├── Smallfolk
│   │   └── lualzw-zeros
│   ├── Ace3
│   │   ├── AceAddon-3.0
│   │   ├── AceConsole-3.0
│   │   ├── AceDB-3.0
│   │   └── AceEvent-3.0
│   └── LibStub
│
└── External (Player Must Install):
    ├── HandyNotes (Required for map pins)
    └── TomTom (Optional for waypoint navigation)
```

---

## Feature Dependencies

### Siege System Features:

| Feature | Embedded | External | Notes |
|---------|----------|----------|-------|
| **Sieges Tab Display** | ✅ AIO, Ace3 | ❌ None | Works without external addons |
| **Server Communication** | ✅ AIO | ❌ None | Core functionality |
| **Notifications** | ✅ Ace3 | ❌ None | Pop-ups work standalone |
| **Map Pins** | ✅ AIO, Ace3 | ⚠️ HandyNotes | Requires HandyNotes |
| **Waypoint Navigation** | ✅ AIO, Ace3 | ⚠️ TomTom | Optional enhancement |
| **War Commitments Panel** | ✅ AIO, Ace3 | ❌ None | Works standalone |

---

## Installation Requirements

### For Players:

**Required:**
- MortalUI addon (includes all embedded libraries)
- HandyNotes (for map pin functionality)

**Optional:**
- TomTom (for waypoint navigation arrows)

**Installation:**
1. Install MortalUI to `Interface/AddOns/MortalUI/`
2. Install HandyNotes to `Interface/AddOns/HandyNotes/`
3. (Optional) Install TomTom to `Interface/AddOns/TomTom/`

---

## Code Integration Points

### AIO Usage:
```lua
-- Client-side request
AIO.Handle("MortalPvP", "RequestSieges")

-- Server-side handler
AIO.AddHandlers("MortalPvP", {
    RequestSieges = HandleRequestSieges
})
```

### Ace3 Usage:
```lua
-- Addon creation
MortalUI = LibStub("AceAddon-3.0"):NewAddon("MortalUI", "AceConsole-3.0", "AceEvent-3.0")

-- Event registration
self:RegisterEvent("CHAT_MSG_ADDON")

-- Slash commands
self:RegisterChatCommand("mortalui", "SlashCommand")
```

### HandyNotes Usage:
```lua
-- Check availability
if not HandyNotes then
    return -- Graceful degradation
end

-- Register plugin
HN:RegisterPluginDB("MortalPins", self, {
    GetNodes = function(mapFile, minimap, level)
        return self:GetNodes(mapFile, minimap, level)
    end
})
```

### TomTom Usage:
```lua
-- Optional integration
if TomTom then
    TomTom:AddWaypoint(mapId, x/100, y/100, {
        title = label,
        persistent = false
    })
end
```

---

## Summary

### Embedded (Always Available):
1. ✅ **AIO** - Client-server communication
2. ✅ **Ace3** - Addon framework (4 modules)
3. ✅ **LibStub** - Library loader
4. ✅ **LibWindow-1.1** - Window positioning
5. ✅ **Smallfolk** - Serialization
6. ✅ **lualzw-zeros** - Compression
7. ✅ **HandyNotes** - Map pin system (embedded)

### External (Player Can Install):
1. ⚠️ **HandyNotes** - Optional (full-featured version, embedded is used if not installed)
2. ⚠️ **TomTom** - Optional for waypoint navigation arrows

### Core Features Work Without External Addons:
- ✅ Sieges tab display
- ✅ Server communication
- ✅ Notifications (pop-ups + sound)
- ✅ War Commitments panel
- ✅ All data display
- ✅ **Map pins (HandyNotes embedded)**

### Features Requiring External Addons:
- ⚠️ Waypoint navigation arrows (requires TomTom - optional)

---

## Recommendations

### For Players:
1. **No installation needed** - HandyNotes is embedded, map pins work automatically
2. **Install TomTom** (optional) - Enhanced waypoint navigation arrows
3. **Install external HandyNotes** (optional) - Full-featured version (embedded is used if not installed)

### For Developers:
- All embedded libraries are self-contained
- No external dependencies for core functionality
- Graceful degradation when external addons missing
- Clear error messages guide players to install HandyNotes

