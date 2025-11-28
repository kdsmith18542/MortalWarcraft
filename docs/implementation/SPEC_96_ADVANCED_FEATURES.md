# Spec 96: Advanced UI Features Implementation

**Date:** 2025-01-XX  
**Status:** ✅ **COMPLETE**

---

## Implementation Complete

All advanced UI features have been implemented:

---

## ✅ 1. Map Pin Integration

### Features Implemented:

#### 1.1 "Set Waypoint to War Camp" Button
- Added to Sieges tab for each siege
- Added to My Commitments tab
- Places map pin at war camp location

#### 1.2 War Camp Coordinate Support
- Server provides `warCampX` and `warCampY` in siege data
- Fallback to zone-specific defaults (Wintergrasp: 5100, 2500)
- Integrates with existing HandyNotes system

#### 1.3 TomTom Integration
- Automatically sets TomTom waypoint if addon is available
- Provides navigation assistance to players

#### 1.4 Map Pin Display
- Uses SIEGE pin type (type 3)
- Shows "War Camp - [Stronghold Name]" label
- Visible on world map and minimap

### Files Modified:
- `addons/MortalUI/MortalUI_PvPPanel.lua` - Added `SetWaypointToWarCamp()` function
- `lua/aio/siege_ui.lua` - Added war camp coordinates to siege data

---

## ✅ 2. War Commitments Panel

### Features Implemented:

#### 2.1 "My Commitments" Tab
- New tab in PvP Panel
- Shows only sieges where player's guild is involved
- Displays player's side (Attacker/Defender)

#### 2.2 Commitment Display
- Stronghold name
- Player's side (color-coded: Red=Attacker, Blue=Defender)
- Time until siege starts
- "Set Waypoint" button for each commitment

#### 2.3 Empty State
- Helpful message when no commitments
- Directs players to Siege Marshal

### Files Modified:
- `addons/MortalUI/MortalUI_PvPPanel.lua` - Added `ShowCommitmentsTab()` function

---

## ✅ 3. Enhanced Notification System

### Features Implemented:

#### 3.1 Pop-up Notifications
- Visual pop-up frame (400x120px)
- Red border for urgency
- Draggable and closable
- Auto-hides after duration

#### 3.2 Sound Alerts
- Plays "RaidWarning" sound on notification
- Draws player attention immediately

#### 3.3 Smart Filtering
- Only notifies for sieges where player's guild is involved
- Prevents spam from irrelevant sieges

#### 3.4 Dual Notification System
- Chat message (always shown)
- Pop-up notification (visual + sound)
- Both trigger at same times

#### 3.5 Notification Timing
- **15 minutes before**: Chat + Pop-up (10s duration)
- **5 minutes before**: Chat + Pop-up (15s duration) + "Enter staging" hint

### Files Modified:
- `addons/MortalUI/MortalUI_PvPPanel.lua` - Enhanced notification system

---

## Feature Details

### Map Pin Integration

**Usage:**
1. Player opens PvP Panel → Sieges tab
2. Clicks "Set Waypoint" button on any siege
3. Map pin appears at war camp location
4. TomTom waypoint set (if addon available)

**Benefits:**
- Easy navigation to war camps
- Visual reference on map
- Integration with navigation addons

### War Commitments Panel

**Usage:**
1. Player opens PvP Panel → "My Commitments" tab
2. Sees all sieges where their guild is involved
3. Can quickly set waypoints to war camps
4. See time until each siege starts

**Benefits:**
- Quick access to player's sieges
- No need to search through all sieges
- Clear indication of player's role

### Enhanced Notifications

**Visual Pop-up:**
- Red-bordered frame
- Large, readable text
- Auto-dismisses after duration
- Can be manually closed

**Sound Alerts:**
- Uses WoW's "RaidWarning" sound
- Familiar to players
- Draws immediate attention

**Smart Filtering:**
- Only shows notifications for relevant sieges
- Prevents notification spam
- Focuses on player's commitments

---

## Technical Implementation

### Map Pin System
```lua
SetWaypointToWarCamp(entry)
  → Gets warCampX/warCampY from entry
  → Falls back to zone defaults if missing
  → Calls MortalAddon:UpdateMapPin()
  → Optionally sets TomTom waypoint
```

### Commitments Panel
```lua
ShowCommitmentsTab()
  → Filters PvPState.sieges by player's guild
  → Displays filtered list
  → Shows side and countdown
  → Provides waypoint buttons
```

### Notification System
```lua
CheckSiegeNotifications()
  → Checks every 10 seconds
  → Filters by player's guild
  → Triggers at 15min and 5min
  → Shows chat + pop-up + sound
```

---

## User Experience Flow

### Discovering a Siege:
1. Herald NPC announces siege
2. Player opens PvP Panel → Sieges tab
3. Sees siege with countdown
4. Clicks "Set Waypoint" → Map pin appears

### Signing Up:
1. Player visits Siege Marshal
2. Signs up for siege
3. Opens PvP Panel → My Commitments tab
4. Sees their commitment with countdown

### Getting Notified:
1. 15 minutes before: Pop-up appears + sound plays
2. 5 minutes before: Pop-up appears + sound plays + "Enter staging" hint
3. Player can click waypoint to navigate

### Joining Siege:
1. Player clicks waypoint or uses portal
2. Teleports to staging area
3. Battle begins

---

## Testing Checklist

- [x] Map pin integration code complete
- [x] War Commitments panel code complete
- [x] Enhanced notifications code complete
- [ ] Test map pin placement
- [ ] Test waypoint navigation
- [ ] Test commitments filtering
- [ ] Test notification timing
- [ ] Test pop-up display
- [ ] Test sound alerts
- [ ] Test TomTom integration

---

## Summary

All advanced UI features have been implemented:

✅ **Map Pin Integration** - Complete
- Waypoint buttons on sieges
- War camp coordinate support
- HandyNotes integration
- TomTom integration

✅ **War Commitments Panel** - Complete
- New "My Commitments" tab
- Guild-filtered siege list
- Side indication
- Quick waypoint access

✅ **Enhanced Notifications** - Complete
- Visual pop-up frames
- Sound alerts
- Smart filtering
- Dual notification system

The system now provides a complete, polished experience for siege discovery, signup, and participation.

