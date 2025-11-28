# Realm 2 – Legacy Journey
## UI, Addon Pack & Chat / Announcer Design

**Realm:** Mortal Warcraft: Legacy Journey (Expansion-Progressive WotLK)  
**Goal:** Provide a polished, familiar WotLK experience with a curated addon pack and clear chat/announcement rules that help players find groups, trade, and stay informed without spam.

---

## 1. UI & Addon Philosophy

- This realm is the **“comfort” experience**: polished, readable, close to WotLK retail feel.
- Addons are:
  - Focused on **clarity and accessibility**, not automation or cheese.
  - Shipped via the **launcher** as an optional but recommended profile:
    - `LegacyUI` profile → pre-packaged `Interface/AddOns` set.
- Players can still use their own addons; we just:
  - Provide a **known-good baseline**.
  - Officially support / test against a defined pack.

---

## 2. LegacyUI Addon Pack

### 2.1 Core UI Addons

**Required in pack (enabled by default on profile):**

- **Bartender4**
  - Action bar replacement; flexible layouts and keybinding management.
- **Bagnon**
  - Unified bag view; easier inventory management.
- **tullaRange (or equivalent)**  
  - Out-of-range coloring on buttons.
- **OmniCC**
  - Numeric cooldown timers on action buttons.

- **TidyPlates / Threat Plates**
  - Modern, configurable nameplates for dungeons/raids and PvP.

- **Mapster**
  - Enhanced world map (coords, zoom, optional fog-of-war adjustments).

- **HandyNotes**
  - Points-of-interest overlays (flight paths, vendors, etc.).  
  - Realm 2 usage: primarily QoL – no crazy node spoilers by default.

- **Details! (or Recount if preferred)**
  - Damage/heal meter for group content.

### 2.2 PvE Helper Addons

**Bundled but not necessarily enabled by default:**

- **DBM (Deadly Boss Mods) or BigWigs**
  - Raid/dungeon encounter timers and alerts.
  - We recommend them, but players can disable if they want a purer experience.

- **AtlasLoot Enhanced**
  - Browse dungeon/raid drops by instance.
  - Helps players plan gear during era progression.

- **Quest Helper (Questie-style or light variant)**
  - Optional; assists with quest objectives and map markers.
  - Can be off by default if you want a more classic feeling:
    - Launcher can ship it disabled, with a checkbox to “Enable Quest Helper”.

### 2.3 Economy Helpers

- **Auctionator (or Aux add-on)**
  - Simplified AH buy/sell tabs and pricing history.
  - Plays nicely with `mod_auction_policy_legacy`:
    - Encourages posting larger stacks,
    - Helps players see true pricing instead of flooded junk.

- **Postal**
  - Better mailbox UI, mass opening/collecting.

### 2.4 Cosmetic / Immersion Addons (Optional)

- Small cosmetic/immersion touches may be included but disabled by default:
  - **TipTac** – improved tooltips.
  - **kgPanels / basic art** – for players who like a slightly fancier frame layout.

---

## 3. Launcher Integration

The Rust/Tauri launcher should:

- Offer a **Realm 2 profile**, e.g.:
  - Profile name: `Legacy Journey`
  - Description: “Comfort WotLK – curated UI & QoL addons.”
- On selecting the profile for the first time:
  - Copy pre-packaged `Interface/LegacyAddOns/*` into `Interface/AddOns`.
  - Allow the player to:
    - Opt out (skip addon install),
    - Or re-apply the pack later if they break their UI.

Optional:
- Provide a simple **checkbox list** in launcher:
  - “Install Raid Helper (DBM/BigWigs)”
  - “Install Quest Helper”
  - “Install Economy Helper (Auctionator)”

---

## 4. Chat System Design

### 4.1 Channels & Defaults

- **/say, /party, /raid, /guild, /officer** – as normal.
- **/whisper** – as normal.
- **/world** – **enabled globally**, primary social/LFG channel.
  - This is crucial for:
    - Group finding in all eras.
    - Server culture and new player onboarding.

- **Trade channel**:
  - Available in major cities (Stormwind, Orgrimmar, capital hubs).
  - Focus on buy/sell spam here to keep `/world` more readable.

### 4.2 /world Chat Rules

To avoid chaos:

- **Minimum level to speak in /world:** e.g. level 10 or 15.
  - This cuts down pure spam/fresh bots.
- **Cooldown on /world messages:** e.g. 5–10 seconds per message.
  - Implement via chat filter module or core hook.

- Basic anti-spam filter:
  - Reject repeated identical messages in a short time.
  - Optionally auto-mute obvious gold-selling patterns.

Moderation tooling:

- GM commands to:
  - Mute player from /world for X minutes/hours.
  - Broadcast system messages (see Announcer section).

### 4.3 LFG & Progression Synergy

- Encourage players to:
  - Use `/world` for ad hoc LFG (“LFM SFK”, “LFG Kara attune run”).
  - Use the in-game LFG tool / RDF according to era rules.
- Website/Discord should reflect:
  - “Use /world to find groups and ask questions; it’s the main social channel.”

---

## 5. Announcer / Broadcaster Behavior

We assume either:

- A small custom module: `mod_legacy_announcer`, or  
- Configuration of an existing announcer module with realm-specific rules.

### 5.1 What We Announce

Limit to **important, non-spammy** events:

- **Era & Tier Changes**
  - When the realm moves from Era I → II → III.
  - When new raid tiers open (Kara, BT, Sunwell, Naxx, Ulduar, ICC, etc.).
- **World Events**
  - Holiday events (Midsummer, Brewfest, Hallow’s End, etc.) starting/ending.
  - Custom events (XP weekends, “server anniversary”).
- **World Bosses**
  - Spawn/despawn messages for classic/TBC/WotLK world bosses.
- **Server Health / Maintenance**
  - Upcoming restarts.
  - Patch notes highlights.

Optional:
- **Community events**:
  - GM-triggered announcements for community-run tournaments or social events.

### 5.2 What We Do *Not* Announce

To avoid noise and “cheap” feel:

- No periodic “Visit the website / donate / vote!” spam.
- No random killfeed spam in the main chat.
- No constant “XP rate” or config reminders.

If needed, a **separate info command**:

- `/realm` → prints:
  - Current era & level cap.
  - XP/rates.
  - Links to wiki/Discord.

---

## 6. Module Notes (High-Level)

If implemented as a small set of modules:

1. **`mod_legacy_chat`**
   - Enforces:
     - /world level requirement,
     - Per-message cooldown,
     - Simple anti-spam repetition checks.

2. **`mod_legacy_announcer`**
   - Provides:
     - Hook-based announcements (era changes, world events, bosses).
     - GM commands:
       - `.announceevent <text>`
       - `.announceera <era_name>`
   - Outputs to:
     - In-game system message.
     - Optional: sends payload to the Atlas/Discord relay if connected.

3. **No restrictions** on chat in dungeons/raids/BGs beyond standard ones; Realm 2 is not trying to simulate radio blackout or hardcore isolation.

---

## 7. Player-Facing Summary (for Wiki / Website)

> **UI & Addons**
> - Realm 2 ships with an optional **LegacyUI pack**: modern bars, bags, nameplates, map, and optional raid/quest helpers.  
> - You can enable it with one click in the launcher, or use your own addons.
>
> **Chat & Social**
> - `/world` is the main social & LFG channel, available from level 10+.  
> - Trade chat lives in capital cities.  
> - Basic anti-spam rules keep the channels readable.
>
> **Announcements**
> - System announcements are reserved for important events: era progression, raid unlocks, holidays, and world bosses.  
> - No constant ad spam or donation reminders.

This keeps Realm 2 feeling like a **polished, social WotLK server** with just enough guardrails to avoid the usual private server chaos.
