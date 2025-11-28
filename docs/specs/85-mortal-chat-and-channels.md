# Project Canvas: Mortal Warcraft Overhaul  
### File: 85-mortal-chat-and-channels.md  
### Topic: Chat System Overhaul (Global Chat, Zone Rules, C++-First)

---

## 1. Baseline: 3.3.5a & AzerothCore Chat

### 1.1 Vanilla / WotLK 3.3.5a Defaults

Retail 3.3.5a provides:

- **System / scope channels**
  - `/say`, `/yell`, `/emote`
  - `/whisper`
  - `/party`, `/raid`
  - `/guild`, `/officer`
  - `/bg` (battleground), `/instance`

- **Server (mask) channels** (auto-joined per zone or city)  
  Examples:
  - **General** (zone-local, auto-join)
  - **Trade** (city-local)
  - **LocalDefense**
  - **LookingForGroup**
  - **WorldDefense`** (server-wide defense channel)  

- **Player channels**
  - `/join <name>` to create or join custom channels (e.g. `/join world`).

There is **no official global OOC “World Chat”** in retail; servers commonly simulate it via custom channels.

### 1.2 AzerothCore Capabilities

AzerothCore:

- Recreates 3.3.5a chat behavior.
- Stores player-created channels in the `channels` table (`channelId`, `name`, `team`, `announce`, etc.).
- Provides core **ChatCommand** framework for slash commands and GM commands.

Global-chat behavior is typically provided via **modules**:

- **mod-world-chat**:  
  - Adds a **World Chat** module.  
  - Supports `/join World` channel name and `.chat` command to broadcast.
- **mod-global-chat** (and advanced forks):  
  - C++ module implementing a configurable, world-wide chat.  
  - Supports `.chat` command, GM visibility controls, cross-faction config, etc.

We will **build Mortal's global chat rules on top of these modules or a custom C++ module**, not via Lua.

---

## Related Specs

For full context on chat and communication systems, see:

- **`81-archon-and-staff-chat-tags-eluna-spec.md`** — Staff chat tags and title system that appear in chat channels
- **`14-admin-tools.md`** — Admin tools and moderation systems that monitor and manage chat
- **`03-risk-zones.md`** — Zone-based chat restrictions (e.g., no global chat in Red Zones)
- **`11-pvp-systems.md`** — PvP systems that may affect chat visibility and communication

---

## 2. Design Goals for Mortal Chat

1. **Keep the world harsh and local by default**, especially in Red Zones.
2. **Still provide a way to find groups, trade, and recruit** across the realm.
3. Make **/world optional, gated, and rate-limited**:
   - Opt-in / opt-out per player.
   - Progression requirement to speak.
   - No sending from Red Zones.
4. Implement **all enforcement in C++** (modules / core hooks), with MortalUI as a thin UX layer.

---

## 3. Channel Matrix (Final Design)

### 3.1 Core Channels (Unchanged Behavior)

These behave mostly like original 3.3.5a:

| Channel      | Scope               | Notes                                         |
|-------------|---------------------|----------------------------------------------|
| /say        | ~25–30 yards        | Local speech, fully allowed everywhere.      |
| /yell       | Larger radius       | Draws attention; allowed everywhere.         |
| /emote      | Local               | RP flavor, no gameplay restrictions.         |
| /whisper    | Player-to-player    | Always allowed; subject to ignore/mute.      |
| /party      | Across zone         | Party coordination, allowed everywhere.      |
| /raid       | Across zone         | Raid coordination, allowed everywhere.       |
| /guild      | Across world        | Guild coordination; no zone restrictions.    |
| /officer    | Across world        | Officer-only; no zone restrictions.          |
| /bg         | Battleground scope  | Only inside BGs.                             |
| /instance   | Dungeon/Raid scope  | Only inside instances.                       |

Mortal-specific twist: **no extra broadcasts or restrictions** here beyond standard spam/abuse rules.

### 3.2 System Channels (General / Trade / Defense / LFG)

| Channel          | Scope                        | Mortal Rule Set                                                  |
|------------------|------------------------------|------------------------------------------------------------------|
| General          | Zone-local                   | Vanilla behavior; used for local chatter.                        |
| Trade            | Capital-city-local           | Trade chatter, not global.                                      |
| LocalDefense     | Zone-local                   | Defense calls; useful for Stronghold & Shrine attacks.          |
| LookingForGroup  | Zone/city-local (or global)* | Can be left mostly vanilla; optional globalization via config.  |
| WorldDefense     | Server-wide system           | Used for system-style alerts only (optional).                   |

We can later re-theme **LFG** and **LocalDefense** messages to align with Mortal events (e.g. Stronghold attacks).

### 3.3 Custom Mortal Channels

#### 3.3.1 `/world` – Mortal Global Chat (Optional, Gated)

- **Scope:** Entire realm.
- **Type:** Player channel backed by **C++ module** (e.g. `mod-global-chat` or custom `mod-mortal-chat`).
- **Access:**
  - **Read**: Any player who **joins** the channel (via `/join World` or automatic join in safe zones).
  - **Speak**: Requires progression & zone checks (see §4).

Usage modes:

- Primary use:
  - LFG across zones,
  - Trade adverts,
  - Guild recruitment,
  - High-level warnings (“Horde zerg in STV road”, “Midnight Horde in Duskwood”).
- Secondary:
  - Social chat, memes, etc., within rate limits and moderation rules.

Players can:

- `/leave World` if they don’t want global noise.
- Use MortalUI checkbox **“Show World Chat”** that `/join`s or `/leave`s behind the scenes.

#### 3.3.2 `/trade` (unchanged) vs `/world`

- **/trade** remains **capital-local** for intense trade spam.
- **/world** becomes slower-paced, realm-wide, with stricter rules.

---

## 4. Global Chat Rules (C++-Backed)

We define a **server-side policy** enforced in C++ within the global chat module.

### 4.1 Progression Requirements to Speak in `/world`

To **send** a message in `/world`, a character must:

1. Have completed the **two-stage tutorial** (Shipwreck + Mainland Hub), or have the “Onboarded” flag:
   - `character_mortal_flags.onboarded = 1`
2. Have at least **X Skill Points**, e.g.:
   - `Total_Primary_Skill_Points >= 50`
3. Not be currently **muted** or under a chat punishment.

Implementation:

- Add a check in the global chat send handler (e.g. hooked into `.chat` command / channel packet):
  - If requirements not met, reject message and optionally send a feedback system message:
    - “You must complete the mainland tutorial before speaking in World Chat.”

### 4.2 Zone Rules: Red Zone Radio Silence

We enforce **radio silence from danger zones**:

- **Green & Yellow Zones**
  - Players can **send** and **receive** `/world` messages (if they’ve joined).

- **Red Zones**
  - Players **cannot send** messages to `/world`.  
  - Option A (recommended): They can still **read** `/world` if joined, simulating listening-only radio.
  - Option B: Hard-mode toggle in config: **no send and no receive** in Red.

Implementation:

- Check the player’s current zone/continent risk level (from Mortal zoning system) in the global chat send handler:
  - If `ZoneRisk == RED`, block outgoing `/world` messages.
  - Optionally, suppress receipt on the server side if we choose hard-mode.

### 4.3 Rate Limiting & Anti-Spam

Global chat uses a **simple rate limit**:

- **Default:** 1 message per 15 seconds per character.
- **Configurable** via a module config (`.conf`) file.
- **GM bypass**: GMs with gmlevel ≥ 2 ignore this limit.

Optionally:

- Add a **small gold cost per message**, e.g. 5–10 copper:
  - Light friction for bots, negligible for normal players.
  - Config toggle in module conf.

Implementation idea:

- Maintain a map of `PlayerGUID -> lastWorldChatTimestamp`.
- On send:
  - Compare current time vs last send.
  - If less than cooldown, reject with a message “You are talking too fast in World Chat.”
  - If cost is enabled, check & subtract required copper.

---

## 5. Per-Player Controls & MortalUI

### 5.1 Server Behavior

- On character login in **Green/Yellow Zones**:
  - Option A: **Auto-join** `/world` once they meet "Onboarded" criteria.
  - Option B: Do nothing; let players type `/join World` or toggle via UI.

- If a player explicitly `/leave World`, server does not force re-join unless they toggle it back via UI.

### 5.2 MortalUI Integration

MortalUI (client addon) provides:

- **Options Panel:**
  - `[ ] Show World Chat`  
    - Checked: client `/join World` (if not in).
    - Unchecked: client `/leave World`.
  - `[ ] Show Trade Chat`](optional):
    - Filters or leaves Trade if player wants zero spam.

- **Per-chat tab filters**:
  - Preconfigured “Combat”, “Local”, “World” tabs with channel filters.

No core changes needed for this; it’s all addon-side UX.

---

## 6. Moderation & Staff Tools

### 6.1 Roles & Tags (Recap)

We already defined:

- `[ARCHON]` – you (gmlevel 3, server owner).
- `[GM-SENTINEL]` – gmlevel 2.
- `[WARDEN]` – gmlevel 1.

In global and other channels:

- Staff chat messages are prefixed with their tag via Eluna/C++ hooks.
- Titles are assigned on login via C++ or Lua.

### 6.2 Chat Moderation Expectations

- **GMs** can:
  - Mute players (`.mute`, `.unmute`),
  - Kick/ban offenders,
  - Temporarily disable `/world` in case of spam waves (if added as a module flag).

- Optional C++ additions:
  - `MortalChat::ToggleWorldChat(bool enabled)` to globally enable/disable.
  - `MortalChat::SetChannelSlowMode(int seconds)` to alter cooldown without restart.

---

## 7. Implementation Plan (C++-First)

### 7.1 Choose Base Module

Option 1 (recommended): Fork **`azerothcore/mod-global-chat`** as **`mod-mortal-chat`** and:

- Add:
  - Zone checks (Green/Yellow/Red),
  - Progression checks (Onboarded, SkillPoints),
  - Rate limiting and optional gold cost.

Option 2: Use **`mod-world-chat`** and extend similarly.

Both are C++ modules maintained by the AzerothCore community and are safer than a pure Lua solution.

### 7.2 Core Tasks

1. **Module Fork & Config**
   - Clone existing global chat module.
   - Add `mortal-chat.conf` with:
     - `MortalChat.Enable = 1`
     - `MortalChat.RedZone.BlockSend = 1`
     - `MortalChat.RedZone.BlockReceive = 0`
     - `MortalChat.CooldownMs = 15000`
     - `MortalChat.CostPerMessageCopper = 0 or >0`
     - `MortalChat.RequireOnboarded = 1`
     - `MortalChat.RequireMinSkillPoints = 50`

2. **Progression Check Hook**
   - Integrate with Mortal progression tables:
     - Read `character_mortal_flags.onboarded`.
     - Compute `Total_Primary_Skill_Points`.

3. **Zone Risk Check**
   - Integrate with Mortal zoning system (C++):
     - `ZoneRisk = MortalZone::GetRiskForZone(player->GetZoneId())`.
     - Block sends in Red Zones if configured.

4. **Rate Limit & Cost**
   - Track last send timestamp per player.
   - Apply cooldown + optional cost.

5. **GM Bypass & Commands**
   - GM command: `.worldchat on/off` to toggle.
   - GM bypass for rate limit and cost.

6. **MortalUI Addon**
   - Add UI toggle that `/join`/`/leave` World.
   - Preconfigure chat tabs and filters.

---

## 8. Summary

- **Yes, we support global chat** – but:
  - It is **opt-in**, **gated**, and **rate-limited**.
  - It cannot be used to shout from Red Zones.
- We reuse and extend **AzerothCore’s global chat modules** in **C++**, not Lua.
- Local / guild / party channels remain the backbone for day-to-day interaction, preserving the **sandbox, hostile-world feel**.
- MortalUI provides gentle UX so casual players can join/leave `/world` without commands.

This spec should be used as the authoritative reference when implementing or modifying any chat-related behavior for Mortal Warcraft Overhaul.
