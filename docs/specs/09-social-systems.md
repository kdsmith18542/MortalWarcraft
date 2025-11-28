# Project Canvas: Mortal Warcraft Overhaul
### Version 26.1 — Hybrid Technical Design Document  
### File: 09-social-systems.md  
### Section: Social Systems, Retention Loops, Mini-Games, Housing & Roleplay Tools

---

# 1. Overview

Social systems are critical for long-term MMO retention.  
This document outlines all **non-combat**, **non-economy** systems focused on:

- Social hubs  
- Tavern games  
- Mini-games  
- Player titles  
- Cosmetic progression  
- Housing (future expansion hooks)  
- Roleplay tools  
- Seasonal prestige  
- “Third place” community design  

These systems emphasize:
- Community health  
- Player expression  
- Non-PvP engagement  
- Endgame longevity  

---

## Related Specs

For full context on social systems, see:

- **`38-social-and-onboarding-systems.md`** — Extended social and onboarding systems
- **`36-mortal-achievements-and-titles-core.md`** — Achievement and title system for social progression
- **`52-season-of-the-frontier.md`** — Seasonal system that provides social prestige rewards
- **`85-mortal-chat-and-channels.md`** — Chat system used in social hubs
- **`08-guilds-sovereignty.md`** — Guild system that provides social structure
- **`03-risk-zones.md`** — Risk zones where social hubs are located

---

# 2. Tavern Social Hubs

## 2.1 Purpose
Taverns serve as:
- Social meeting points  
- Mini-game halls  
- Recruitment centers  
- Safe hangout areas  

## 2.2 Features
- Dice games  
- Card games  
- Drinking contests  
- Bard NPCs  
- Rumors (dynamic world info)  
- Bulletin boards  
- Gambling pits (designated tables)  

## 2.3 Implementation
Lua:
- `tavern_games.lua`
- `gambling_pit_logic.lua`

SQL:
- `tavern_minigame_tables.sql`

---

# 3. Mini-Games

### 3.1 Dice (1v1)
- Simple /roll improvements  
- Optional wager system  
- Anti-exploit cooldown  

### 3.2 Dragon Deck (Card Game)
A simplified, server-side card-dueling game.

### 3.3 Drinking Contest
Players drink until:
- Vision blur triggers  
- Controls wobble  
- Last standing wins  

### 3.4 Knife Toss
Target mini-game:
- Accuracy determines score  
- Daily leaderboards  

---

# 4. Wager System

## 4.1 Overview
Players can wager gold on:
- Duels  
- Tavern games  
- Arena matches  
- Special events  

## 4.2 Rules
- Wager locked in escrow  
- Winner auto-paid via Lua script  
- Small system fee (gold sink)  

Lua:
- `wager_system.lua`

---

# 5. Titles & Social Progression

## 5.1 Earned Titles
Players earn social titles through:
- PvP achievements  
- Economy milestones  
- Mini-game wins  
- Seasonal ranks  
- Guild influence  
- Exploration  

## 5.2 Cosmetic Badges
Displayed next to player name; includes:
- Regional trader  
- Arena champion  
- Siege veteran  
- Legendary crafter  
- Treasure hunter  
- Bounty hunter  

SQL:
- `titles_table.sql`

---

# 6. Housing (Future Expansion Hook)

Housing is NOT fully implemented in v26.1.  
However, the design includes hooks for future development.

## 6.1 Housing Options
- Personal instanced houses  
- Apartments in capitals  
- Wilderness cabins  
- Houseboats (for coastal RP)  

## 6.2 House Features
- Decoration placement  
- Storage  
- Crafting spaces  
- Cosmetic trophies  
- Social visitor access  

## 6.3 Implementation Layer
Lua:
- `housing_stub.lua` (for expansion)

SQL:
- `housing_layouts.sql`

Note: Housing depends on server performance testing.

---

# 7. Roleplay Tools

## 7.1 Emote Enhancements
- /sitchair  
- /sleepground  
- /leanwall  
- /drinkbusy  

## 7.2 Character Bio Window
Players may write:
- Biography  
- RP tags  
- Preferred playstyle  

Stored in DB:
- `character_bio.sql`

## 7.3 Inspect Additions
Inspection shows:
- Titles  
- Badges  
- PvP season score  
- Guild influence  

---

# 8. Outlaw Social Ecosystem

Outlaws need their own social loops.

## 8.1 Outlaw Hideouts
Found in:
- Stranglethorn  
- Eastern Plaguelands  
- Badlands  

Features:
- Fence vendors  
- Outlaw dueling pits  
- Hidden quest chains  
- Black Market crafting bench  

## 8.2 Criminal Contracts
Players can:
- Accept assassination contracts  
- Deliver illegal goods  
- Steal items from caravans  

Lua:
- `criminal_contracts.lua`

---

# 9. Events & Scheduled Social Content

## 9.1 Weekly Events
- Tavern Brawl Nights  
- Dice Tournament  
- Treasure Hunt events  
- Fishing Derby  

## 9.2 Monthly Events
- Guild Festivals  
- Market Day  
- Outlaw Carnival  
- Arena Season Openers  

## 9.3 Seasonal Events
Tie directly to:
- PvE seasons  
- Resource seasons  
- Sovereignty resets  

---

# 10. Friend & Ignore System

## 10.0 Real ID System Removal

**Decision: Remove Real ID System Entirely**

**Rationale:**
- Not aligned with sandbox MMO vision
- Adds unnecessary complexity
- Mortal should have its own social systems
- Supports "Emergent Gameplay" (in-game social tools)

**Implementation:**
- **Remove**: Real ID system completely
- **Replace**: In-game friend/ignore system (see sections 10.1 and 10.2)
- **Reasoning**: 
  - Mortal has its own social systems
  - In-game tools are sufficient
  - Keeps focus on game world
  - Aligns with sandbox philosophy

**Status**: Real ID system removed - use in-game friend/ignore system instead

---

## 10.1 Friend List System

**Functionality:**
- Standard friend list (similar to WoW 3.3.5a)
- Add/remove friends
- See friend online status
- See friend location (zone only, not exact coordinates)
- Send whispers to friends
- Friend notes (custom notes per friend)

**Mortal Enhancements:**
- **Friend Status Indicators:**
  - Online/Offline
  - Zone location (if online)
  - Derived Level (if visible)
  - Guild affiliation (if visible)
  - Criminal/Outlaw status (if visible)

- **Friend Grouping:**
  - Custom friend groups (Guild, Trading Partners, PvP Partners, etc.)
  - Quick-filter by group
  - Group-based chat channels (optional)

- **Friend Activity Tracking:**
  - Last seen timestamp
  - Recent activity (recently completed tasks, etc.)
  - Shared achievements (if both players have them)

**Implementation:**
- Uses standard WoW friend list system
- Enhanced with Mortal-specific data
- Lua: `friend_system_enhancements.lua`
- SQL: `character_social` (standard AzerothCore table)

## 10.2 Ignore List System

**Functionality:**
- Standard ignore list (similar to WoW 3.3.5a)
- Block whispers from ignored players
- Block party/raid invites from ignored players
- Block guild invites from ignored players
- Hide ignored players in chat

**Mortal Enhancements:**
- **Ignore Types:**
  - **Full Ignore:** Blocks all communication (whispers, invites, chat)
  - **Whisper Only:** Blocks whispers but allows other interactions
  - **Temporary Ignore:** Auto-removes after 24 hours

- **Ignore Reasons (Optional):**
  - Players can optionally tag why they ignored someone
  - Used for moderation (repeated ignores = potential harassment)
  - Not visible to ignored player

- **Ignore Limits:**
  - Maximum 50 ignored players (prevents abuse)
  - Outlaws cannot ignore players (must deal with consequences)

**Implementation:**
- Uses standard WoW ignore list system
- Enhanced with Mortal-specific features
- Lua: `ignore_system_enhancements.lua`
- SQL: `character_social` (standard AzerothCore table)

## 10.3 Friend/Ignore Integration with Mortal Systems

**Criminal/Outlaw Status:**
- Friends can see if you're criminal/outlaw
- Ignored players cannot see your status (if you ignore them)
- Outlaws cannot use friend list (social restriction)

**Guild Integration:**
- Guild members automatically in "Guild Friends" group
- Guild officers can see all guild member statuses
- Ignored guild members still visible in guild chat (guild override)

**PvP Integration:**
- Friends cannot attack each other in Yellow zones (unless both consent)
- Ignored players can still attack you (ignore doesn't prevent PvP)
- Friend status visible on nameplates (optional)

**Zone Restrictions:**
- Red zones: Friend list still works (can see online status)
- Red zones: Ignore list still works (blocks whispers)
- Red zones: Cannot see friend location (privacy protection)

## 10.4 Privacy Settings

**Visibility Options:**
- **Public:** Everyone can see your online status
- **Friends Only:** Only friends can see your online status
- **Guild Only:** Only guild members can see your online status
- **Private:** No one can see your online status

**Location Sharing:**
- **Always:** Friends can always see your zone
- **Friends Only:** Only friends can see your zone
- **Never:** No one can see your zone (privacy mode)

**Implementation:**
- Lua: `privacy_settings.lua`
- SQL: `character_privacy_settings.sql`

---

# 11. Global Chat & Communication

## 11.1 Radio Silence Zones
Red zones disable:
- World chat  
- Global channels  

Creates fear and isolation intentionally.

## 11.2 Cross-Chat Integration
Discord integration:
- #global-chat  
- #killfeed  
- #territory-alerts  

Lua:
- `discord_integration.lua`

---

# 11. Social Progression Rewards

Players earn:
- Cosmetics  
- Emotes  
- Titles  
- Profile frames  
- Tavern furniture (event-only)  

High-retention cosmetic loop.

---

# 12. Implementation Summary

## 12.1 C++ Files
- `SocialHooks.cpp`
- `InspectExtensions.cpp`

## 12.2 Lua Files
- `tavern_games.lua`
- `wager_system.lua`
- `criminal_contracts.lua`
- `discord_integration.lua`
- `housing_stub.lua`

## 12.3 SQL Files
- `titles_table.sql`
- `character_bio.sql`
- `tavern_minigame_tables.sql`

---

# 13. Status
This subsystem is **Core for retention**, and future expansions will greatly expand housing and RP features.

