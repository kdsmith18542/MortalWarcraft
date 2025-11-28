# Project Canvas: Mortal Warcraft Overhaul  
### Version 36.5 — Admin & Staff Presentation  
### File: 81-archon-and-staff-chat-tags-eluna-spec.md  
### Topic: Archon / GM / Warden Chat Tags & Title Enforcement

---

## 1. Goal

Implement **themed admin & staff roles** in-game:

- You (owner/admin) as **Mortal Archon** with `[ARCHON]` chat tag.
- GMs as **Sentinel of the Frontier** with `[GM-SENTINEL]` chat tag.
- Moderators as **Town Warden** with `[WARDEN]` chat tag.

While:

- Keeping regular players **untagged** in chat,
- Avoiding immersion-breaking `[GM]` spam,
- Still making it obvious who is staff.

This file gives you a **drop-in Eluna script** plus **SQL stubs**.

---

## Related Specs

For full context on staff and chat systems, see:

- **`85-mortal-chat-and-channels.md`** — Chat system architecture and channel rules where these tags appear
- **`14-admin-tools.md`** — GM roles, permissions, and admin tooling that define staff capabilities
- **`42-gm-tools-and-live-events.md`** — Extended GM tools and event management used by staff

---

## 2. Role Definitions

We map AzerothCore `gmlevel` (security) to themed roles:

- **gmlevel 3 – Archon (You)**
  - Title: `Mortal Archon`
  - Chat tag: `|cffffa500[ARCHON]|r` (gold/orange)

- **gmlevel 2 – GM Sentinel**
  - Title: `Sentinel of the Frontier`
  - Chat tag: `|cff00ff00[GM-SENTINEL]|r` (green)

- **gmlevel 1 – Town Warden**
  - Title: `Town Warden`
  - Chat tag: `|cff33aaff[WARDEN]|r` (blue)

- **gmlevel 0 – Player**
  - No special tag.
  - Titles only via systems/achievements.

---

## 3. SQL — Custom Titles

Create custom titles in `chr_titles` (if you haven’t already).

> Pick IDs that don’t collide; 300–310 are usually safe in custom spaces.

```sql
INSERT INTO chr_titles (ID, Condition_ID, NameMale, NameFemale)
VALUES
(300, 0, '%s, Mortal Archon', '%s, Mortal Archon'),
(301, 0, '%s, Sentinel of the Frontier', '%s, Sentinel of the Frontier'),
(302, 0, '%s, Town Warden', '%s, Town Warden');
```

- `ID = 300` → Mortal Archon title.
- `ID = 301` → Sentinel of the Frontier.
- `ID = 302` → Town Warden.

You can grant these via script so you don’t have to manually add them in DB per character.

---

## 4. Eluna Script — Chat Tags & Titles

Create a Lua file, e.g.:

`lua_scripts/mortal/core/mortal_staff_tags.lua`

### 4.1 Config Section

```lua
-- mortal_staff_tags.lua

-- CONFIG
local ARCHON_ACCOUNT_ID = 1        -- your account id here
local TITLE_ARCHON       = 300     -- Mortal Archon
local TITLE_SENTINEL     = 301     -- GM Sentinel
local TITLE_WARDEN       = 302     -- Town Warden

-- Colored tags
local TAG_ARCHON   = "|cffffa500[ARCHON]|r "       -- gold/orange
local TAG_SENTINEL = "|cff00ff00[GM-SENTINEL]|r " -- green
local TAG_WARDEN   = "|cff33aaff[WARDEN]|r "      -- blue

-- Helper to get security from Eluna (AzerothCore)
-- Usually GetGMRank() returns the security level (0-3)
local function GetSecurity(player)
    return player:GetGMRank()
end
```

> Update `ARCHON_ACCOUNT_ID` to your real account id (from `account` table).

---

### 4.2 Apply Titles on Login

We want:

- Your character(s) on your account → automatically know and use **Mortal Archon**.
- Staff GMs/Moderators → automatically know & use their titles if they don’t override it.

```lua
local function OnPlayerLogin(event, player)
    local sec = GetSecurity(player)

    -- Archon (owner/admin)
    if player:GetAccountId() == ARCHON_ACCOUNT_ID then
        player:SetKnownTitle(TITLE_ARCHON)
        player:SetTitle(TITLE_ARCHON)
        return
    end

    -- Sentinel GM (gmlevel 2)
    if sec == 2 then
        player:SetKnownTitle(TITLE_SENTINEL)
        -- Only override if they don't have a more "prestige" title set, optional
        if player:GetTitle() == 0 then
            player:SetTitle(TITLE_SENTINEL)
        end
        return
    end

    -- Town Warden (gmlevel 1)
    if sec == 1 then
        player:SetKnownTitle(TITLE_WARDEN)
        if player:GetTitle() == 0 then
            player:SetTitle(TITLE_WARDEN)
        end
        return
    end
end

-- EVENT_PLAYER_LOGIN is 3 in Eluna for AzerothCore
RegisterPlayerEvent(3, OnPlayerLogin)
```

> If `GetTitle` doesn’t exist in your Eluna version, you can skip the “if 0 then override” guarding logic and just always set the staff title.

---

### 4.3 Chat Hook — Inject Tags

We intercept chat and prepend tags only for staff. Regular players are untouched.

In AzerothCore Eluna, `EVENT_PLAYER_CHAT` is typically event `18`. If your core differs, adjust.

```lua
local EVENT_PLAYER_CHAT = 18

local function OnPlayerChat(event, player, msg, Type, lang)
    local sec = GetSecurity(player)
    local name = player:GetName()

    local tag = nil

    if player:GetAccountId() == ARCHON_ACCOUNT_ID then
        tag = TAG_ARCHON
    elseif sec == 2 then
        tag = TAG_SENTINEL
    elseif sec == 1 then
        tag = TAG_WARDEN
    end

    -- Non-staff: do nothing, let core handle normal chat
    if not tag then
        return
    end

    -- Format: [TAG] Name: message
    local full = string.format("%s%s: %s", tag, name, msg)

    -- Send to same channel type; we re-broadcast and block default
    -- Type = chat type, lang = language
    SendChatMessage(full, Type, lang, player:GetGUID())

    -- return false to prevent default.
    return false
end

RegisterPlayerEvent(EVENT_PLAYER_CHAT, OnPlayerChat)
```

Notes:

- This hits **all chat types** (say, party, guild, etc).  
  - If you want to limit tags to specific chat types, add checks on `Type`.
- Players still see everything in the usual channels; your message just has the prefix.

---

## 5. Optional: Nameplate / UI Integration (MortalUI)

If you want the tags to also appear in custom UI elements (unit frames, nameplates), you can:

- Add a `GetStaffTag(player)` helper in Lua:
  - Expose it via AIO / custom RPC to your MortalUI addon.
- Or simply color your name differently in nameplates based on gmlevel.

Example snippet (server-side pseudo):

```lua
function Mortal_GetStaffTag(player)
    local sec = GetSecurity(player)

    if player:GetAccountId() == ARCHON_ACCOUNT_ID then
        return "ARCHON"
    elseif sec == 2 then
        return "GM-SENTINEL"
    elseif sec == 1 then
        return "WARDEN"
    end
    return ""
end
```

Your MortalUI addon could call this via AIO and render a small badge next to the name.

---

## 6. Quick Setup Checklist

1. **SQL**
   - Insert titles into `chr_titles`.
   - Make sure your account id is known (`SELECT id, username FROM account;`).

2. **Lua**
   - Drop `mortal_staff_tags.lua` into `lua_scripts/mortal/core`.
   - Set `ARCHON_ACCOUNT_ID` to your actual account id.
   - Adjust event ids if needed (login/chat).

3. **Restart Worldserver**
   - Ensure Eluna boots without errors.
   - Log in on your admin account:
     - Confirm your suffix is `Name, Mortal Archon`.
     - Say something in `/say` or `/world`:
       - It should appear as: `[ARCHON] Name: message`.

4. **Test Staff Levels**
   - Create a test GM (gmlevel 2), another as Moderator (gmlevel 1).
   - Verify:
     - They receive Sentinel/Warden titles,
     - Their chat messages are tagged `[GM-SENTINEL]` / `[WARDEN]`.

---

This keeps your presence very clear and on-theme:

- You: **Mortal Archon** in world, `[ARCHON]` in chat.
- GMs: **Sentinels of the Frontier**, easily recognized.
- Mods: **Town Wardens**, more grounded/local.

And it all lives in one small Lua + SQL bundle Cursor can extend or refactor as your staff tools evolve.  
