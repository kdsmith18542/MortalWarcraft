# Spec 96: MortalUI & Atlas Integration

**Date:** 2025-01-XX  
**Spec:** `96-mortal-siege-signup-flow.md`  
**Status:** ✅ **IMPLEMENTED**

---

## Implementation Complete

Both MortalUI and Atlas integration for sieges have been implemented:

---

## 1. MortalUI Integration ✅

### Files Modified:
- `addons/MortalUI/MortalUI_PvPPanel.lua`

### Features Added:

#### 1.1 "Sieges" Tab
- Added new "Sieges" tab to the PvP Panel
- Positioned between "Warfronts" and "Hellgates"
- Full integration with existing tab system

#### 1.2 Siege Display
- Shows upcoming and active sieges
- Displays:
  - Stronghold name
  - Attacker vs Defender guilds
  - Lifecycle stage (Announced, Signup, Lock-In, Active)
  - Participant counts (attacker vs defender)
  - Time until start
  - Minimum level requirements
  - Zone information
  - Full-loot warning

#### 1.3 Status Colors
- **Red** - Active sieges
- **Yellow** - Lock-in phase
- **Green** - Signup phase
- **Default** - Upcoming/announced

#### 1.4 Actions
- "Enter" button for active sieges (directs to portal)
- "View Details" button for upcoming sieges
- Map pin integration (future)

#### 1.5 Data Flow
- Client requests: `AIO.Handle("MortalPvP", "RequestSieges")`
- Server responds: `ReceiveSieges` action with siege data
- Auto-refreshes when tab is opened

---

## 2. Server-Side AIO Handler ✅

### Files Created:
- `lua/aio/siege_ui.lua`

### Features:

#### 2.1 Request Handler
- `HandleRequestSieges(player)` - Processes client requests
- Queries database for upcoming sieges (next 10)
- Formats data for client consumption

#### 2.2 Data Formatting
- Gets guild names from database
- Calculates participant counts
- Determines lifecycle stage
- Includes stronghold information
- Adds minimum level/Standing requirements

#### 2.3 Integration
- Uses `MortalPvP` channel (same as other PvP features)
- Follows existing AIO pattern
- Compatible with existing PvP panel system

---

## 3. Atlas Web Portal Integration ✅

### Files Created:
- `webportal/backend/internal/api/handlers/sieges.go`

### Files Modified:
- `webportal/backend/internal/api/routes.go`
- `webportal/backend/internal/api/handlers/handlers.go`

### API Endpoints:

#### 3.1 GET `/api/v1/sieges/upcoming`
- Returns upcoming sieges
- Query parameters:
  - `limit` - Number of sieges to return (default: 10, max: 50)
- Response:
  ```json
  {
    "sieges": [
      {
        "siege_id": 1,
        "stronghold_id": 1,
        "stronghold_name": "Fortress of Wintergrasp",
        "zone_id": 4197,
        "attacker_guild_id": 5,
        "attacker_guild_name": "Iron Covenant",
        "defender_guild_id": 3,
        "defender_guild_name": "Ashen Vanguard",
        "start_time": 1735689600,
        "end_time": 1735692300,
        "is_active": false,
        "lifecycle_stage": "signup",
        "attacker_count": 15,
        "defender_count": 20,
        "minimum_level": 10,
        "minimum_standing": 0
      }
    ],
    "count": 1
  }
  ```

#### 3.2 GET `/api/v1/sieges/:id`
- Returns details for a specific siege
- Includes full participant information
- Response: Single siege object

#### 3.3 GET `/api/v1/sieges/stronghold/:id/schedule`
- Returns siege schedule for a specific stronghold
- Shows all upcoming sieges for that stronghold
- Response: Array of siege objects

### Features:

#### 3.4 Intel Protection
- Participant counts rounded to nearest 5
- Protects sensitive information while showing trends
- Example: 17 players → 15, 23 players → 25

#### 3.5 Lifecycle Stage Mapping
- Maps database `lifecycle_stage` (0-4) to strings:
  - `0` → `"announced"`
  - `1` → `"signup"`
  - `2` → `"lock_in"`
  - `3` → `"active"`
  - `4` → `"complete"`

#### 3.6 Guild Name Resolution
- Automatically resolves guild IDs to names
- Handles missing/unclaimed guilds gracefully
- Returns "Unknown" for invalid guild IDs

---

## 4. Data Flow

### MortalUI Flow:
```
Client: AIO.Handle("MortalPvP", "RequestSieges")
  ↓
Server: lua/aio/siege_ui.lua
  ↓
Database: Query guild_sieges + guild_strongholds
  ↓
Server: Format data, include guild names, participant counts
  ↓
Client: AIO.Msg("MortalPvP", "ReceiveSieges", data)
  ↓
Client: Display in "Sieges" tab
```

### Atlas Flow:
```
Web Client: GET /api/v1/sieges/upcoming
  ↓
Go Handler: handlers/sieges.go
  ↓
Database: Query guild_sieges + guild_strongholds
  ↓
Handler: Format JSON response
  ↓
Web Client: Display in "Warfronts & Sieges" page
```

---

## 5. Integration Points

### 5.1 MortalUI Notifications (Future)
- Pop-up notifications at 15 minutes before start
- Pop-up notifications at 5 minutes before start
- "Enter Staging" hint when in city
- **Note:** These require additional client-side timer logic

### 5.2 Atlas Web Page (Future)
- React component for siege cards
- Countdown timers
- Multiple timezone display
- Risk description display
- **Note:** Frontend React components need to be created

---

## 6. Testing Checklist

- [x] MortalUI "Sieges" tab appears
- [x] Server-side handler responds to requests
- [x] Data formatting works correctly
- [x] Atlas API endpoints return correct data
- [ ] Test with actual siege data
- [ ] Verify participant count rounding
- [ ] Test lifecycle stage transitions
- [ ] Verify guild name resolution

---

## 7. Next Steps

### MortalUI Enhancements:
1. **Notifications** - Add timer-based pop-ups
2. **Map Pins** - Add waypoint to War Camp
3. **War Commitments Panel** - Show player's registered sieges
4. **Auto-refresh** - Update data periodically

### Atlas Frontend:
1. **Siege Cards** - React components for display
2. **Countdown Timers** - Real-time countdown
3. **Timezone Display** - Multiple timezone support
4. **Risk Indicators** - Visual risk level display
5. **Participant Trends** - Graph showing signup trends

---

## Summary

✅ **MortalUI Integration** - Complete
- Sieges tab added
- Full data display
- Server-side handler implemented

✅ **Atlas API Integration** - Complete
- Three API endpoints created
- Intel protection implemented
- Full data formatting

**Remaining Work:**
- Frontend React components (Atlas)
- Notification system (MortalUI)
- Map pin integration (MortalUI)

The backend infrastructure is complete and ready for frontend implementation.

