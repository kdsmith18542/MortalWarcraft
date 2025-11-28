# Project Canvas: Mortal Warcraft Overhaul
### Version 26.1 — Hybrid Technical Design Document  
### File: 20-aio-ui-basics.md  
### Section: AIO (AzerothCore IO) Integration – Server/Client Structure & Example UIs

---

# 1. Purpose

This document explains **how Mortal Warcraft uses Rochet2’s AIO** to build:

- Server-driven UI panels (no client exe hacking)
- Custom windows for:
  - Courier Contracts
  - Market Stalls
  - Bounty Boards
  - Mentor / Tutorial panels
  - Admin tools

It defines:

- Folder layouts (server + client)
- Initialization flow
- Coding patterns (Lua AIO server ↔ client)
- A concrete example: **Courier Contract UI (v1)**

---

## Related Specs

For full context on AIO UI systems, see:

- **`15-ui-client.md`** — UI architecture and MortalUI system that uses AIO
- **`18-lfg-warfront-ui.md`** — LFG and warfront UI panels built with AIO
- **`13-caravans-contracts.md`** — Courier contract system that uses AIO UI
- **`14-admin-tools.md`** — Admin tools that use AIO for server-driven panels
- **`38-social-and-onboarding-systems.md`** — Social systems that use AIO UI

---

# 2. AIO Overview (In Mortal Context)

AIO is a **Lua-based client-server UI bridge**:

- **Server-side (Lua):**
  - Defines UI logic, RPC handlers, security checks.
  - Sends “create window / update data” messages to the client.

- **Client-side (WoW AddOn):**
  - Receives AIO messages.
  - Builds frames using normal WoW UI API (FrameXML).
  - Sends user actions back to server via AIO.

For Mortal, AIO is the backbone for:

- Diegetic UIs (bounty boards, tavern games)
- Complex systems without overburdening Gossip menus
- GM/Admin control panels

---

# 3. Folder Structure for Mortal + AIO

## 3.1 Server

Assuming ALE/Eluna loads from `lua_scripts/`:

```text
<acore-root>/
  lua_scripts/
    AIO_Server/          # From Rochet2/AIO
      AIO.lua
      AIO_Handlers.lua
      ...
    mortal/
      aio/
        init.lua
        contracts_ui.lua
        market_ui.lua
        bounty_ui.lua
        mentor_ui.lua
        admin_ui.lua
```

We keep **Mortal scripts in `lua_scripts/mortal/aio`** and require them from `init.lua`.

---

## 3.2 Client

WoW AddOn folder:

```text
<WoW>/Interface/AddOns/
  AIO/                  # From Rochet2/AIO (core client addon)
    AIO.lua
    AIO.xml
    ...
  MortalUI/
    MortalUI.toc
    MortalUI.lua
    aio/
      contracts_ui.lua
      market_ui.lua
      bounty_ui.lua
      mentor_ui.lua
      admin_ui.lua
```

Client-side Mortal UI code:

- Lives under `MortalUI/aio/`
- Registers AIO handlers & builds frames.

---

# 4. Initialization Flow

## 4.1 Server-Side Init (`init.lua`)

```lua
-- lua_scripts/mortal/aio/init.lua

local AIO = AIO or require("AIO")

if not AIO then
    print("[Mortal AIO] ERROR: AIO not found!")
    return
end

-- Create a Mortal namespace
MortalAIO = MortalAIO or {}

-- Load Mortal AIO modules
require("mortal/aio/contracts_ui")
require("mortal/aio/market_ui")
require("mortal/aio/bounty_ui")
require("mortal/aio/mentor_ui")
require("mortal/aio/admin_ui")

print("[Mortal AIO] Loaded Mortal AIO modules.")
```

You also need to ensure `init.lua` is loaded by ALE/Eluna (e.g. via `eluna.conf` or equivalent).

---

## 4.2 Client-Side Init (`MortalUI.lua`)

```lua
-- Interface/AddOns/MortalUI/MortalUI.lua

local AIO = AIO or nil
if not AIO then
    -- Fail gracefully if AIO is missing
    DEFAULT_CHAT_FRAME:AddMessage("|cffff0000[MortalUI]|r AIO not loaded!")
    return
end

MortalUI = MortalUI or {}
MortalUI.AIOHandlers = MortalUI.AIOHandlers or {}

-- Load AIO client modules
-- You can either do dofile-like equivalents or just place code in these files.
-- Example if you use simple includes in the TOC:
--   aio/contracts_ui.lua
--   aio/market_ui.lua
-- etc.
```

Your `MortalUI.toc` includes:

```text
## Interface: 30300
## Title: MortalUI
## Notes: Mortal Warcraft UI & AIO integration
## RequiredDeps: AIO

MortalUI.lua
aio/contracts_ui.lua
aio/market_ui.lua
aio/bounty_ui.lua
aio/mentor_ui.lua
aio/admin_ui.lua
```

---

# 5. AIO Messaging Basics (Pattern)

AIO uses **channels** + **handlers**.

- Server: `AIO.AddHandlers("MORTAL_CONTRACTS", {...})`
- Client: `AIO.RegisterEventListener("MORTAL_CONTRACTS", function(...) ... end)`

Typical flow:

1. Client clicks “Open Courier Contracts” on an NPC / button.
2. Server RPC runs, fetches DB rows, sends them to client via AIO.
3. Client builds/updates the window.
4. Client button (e.g. “Accept”) calls AIO back to server with contract ID.
5. Server validates → updates DB → sends confirmation.

---

# 6. Example: Courier Contract UI (v1)

We’ll build a **simple version**:

- Shows a list of **open contracts** for the player’s current region.
- Allows clicking **“View Details”** and “Accept”.

## 6.1 Server-Side: `contracts_ui.lua`

```lua
-- lua_scripts/mortal/aio/contracts_ui.lua

local AIO = AIO or require("AIO")
if not AIO then
    return
end

MortalAIO = MortalAIO or {}
MortalAIO.Contracts = MortalAIO.Contracts or {}

-- Channel name for contracts UI
local CONTRACTS_CHANNEL = "MORTAL_CONTRACTS"

-- Server -> Client handlers (none here, we only send)
-- Client -> Server handlers:
MortalAIO.Contracts.Handlers = AIO.AddHandlers(CONTRACTS_CHANNEL, {
    -- Client requests contract list
    RequestContractList = function(player)
        if not player then return end

        local guid = player:GetGUIDLow()

        -- TODO: replace with real DB query based on player's region
        -- Example placeholder contracts:
        local contracts = {
            {
                id = 101,
                title = "Elwynn -> Stormwind Ore Run",
                reward = 500,
                collateral = 2000,
                destination = "Stormwind City"
            },
            {
                id = 102,
                title = "Redridge Timber Delivery",
                reward = 800,
                collateral = 3000,
                destination = "Lakeshire"
            },
        }

        -- Send to client
        AIO.Msg():Add(CONTRACTS_CHANNEL, "ReceiveContractList", contracts):Send(player)
    end,

    -- Client attempts to accept a contract
    AcceptContract = function(player, contractId)
        if not player or not contractId then return end

        local guid = player:GetGUIDLow()

        -- TODO: DB validation:
        -- 1) Check contract exists and is open
        -- 2) Check player has enough gold for collateral
        -- 3) Reserve contract for this player

        local ok = true  -- placeholder result
        local errorMsg = nil

        if ok then
            -- Deduct collateral, mark contract accepted, etc.
            -- TODO: implement actual DB logic
            AIO.Msg():Add(CONTRACTS_CHANNEL, "ContractAccepted", contractId):Send(player)
        else
            AIO.Msg():Add(CONTRACTS_CHANNEL, "ContractError", errorMsg or "Could not accept contract."):Send(player)
        end
    end,
})

-- Helper function for NPC gossip or commands
function MortalAIO.Contracts.OpenUI(player)
    if not player then return end
    AIO.Msg():Add(CONTRACTS_CHANNEL, "OpenWindow"):Send(player)
end

print("[Mortal AIO] contracts_ui.lua loaded")
```

This gives you:

- Two client-callable RPCs:
  - `RequestContractList`
  - `AcceptContract`
- Three server -> client events:
  - `OpenWindow`
  - `ReceiveContractList`
  - `ContractAccepted` / `ContractError`

---

## 6.2 Client-Side: `aio/contracts_ui.lua`

```lua
-- Interface/AddOns/MortalUI/aio/contracts_ui.lua

local AIO = AIO or nil
if not AIO then return end

local CONTRACTS_CHANNEL = "MORTAL_CONTRACTS"

MortalUI = MortalUI or {}
MortalUI.Contracts = MortalUI.Contracts or {}

local ContractsUI = MortalUI.Contracts

-- Simple frame builder
local function CreateContractsFrame()
    if ContractsUI.Frame then
        return ContractsUI.Frame
    end

    local f = CreateFrame("Frame", "MortalContractsFrame", UIParent, "BasicFrameTemplateWithInset")
    f:SetSize(400, 300)
    f:SetPoint("CENTER")
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)
    f:Hide()

    f.title = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    f.title:SetPoint("LEFT", f.TitleBg, "LEFT", 5, 0)
    f.title:SetText("Courier Contracts")

    -- ScrollFrame + buttons
    local scrollFrame = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 10, -30)
    scrollFrame:SetPoint("BOTTOMRIGHT", -30, 10)

    local content = CreateFrame("Frame", nil, scrollFrame)
    content:SetSize(360, 260)
    scrollFrame:SetScrollChild(content)

    ContractsUI.Frame = f
    ContractsUI.ScrollContent = content
    ContractsUI.Buttons = {}

    return f
end

-- Helper to refresh list
local function RefreshContractsList(contracts)
    local content = ContractsUI.ScrollContent
    if not content then return end

    -- Clear old buttons
    for _, btn in ipairs(ContractsUI.Buttons) do
        btn:Hide()
    end
    wipe(ContractsUI.Buttons)

    local y = -5
    for i, c in ipairs(contracts) do
        local btn = CreateFrame("Button", nil, content, "UIPanelButtonTemplate")
        btn:SetSize(320, 24)
        btn:SetPoint("TOPLEFT", 10, y)
        btn:SetText(string.format("%s (Reward: %d, Collateral: %d)", c.title, c.reward, c.collateral))
        btn.contractId = c.id

        btn:SetScript("OnClick", function()
            -- Accept contract
            AIO.Msg():Add(CONTRACTS_CHANNEL, "AcceptContract", btn.contractId):Send()
        end)

        table.insert(ContractsUI.Buttons, btn)
        y = y - 26
    end
end

-- AIO event listeners

AIO.RegisterEventListener(CONTRACTS_CHANNEL, "OpenWindow", function()
    local f = CreateContractsFrame()
    f:Show()
    -- Request contract list from server
    AIO.Msg():Add(CONTRACTS_CHANNEL, "RequestContractList"):Send()
end)

AIO.RegisterEventListener(CONTRACTS_CHANNEL, "ReceiveContractList", function(contracts)
    CreateContractsFrame():Show()
    RefreshContractsList(contracts or {})
end)

AIO.RegisterEventListener(CONTRACTS_CHANNEL, "ContractAccepted", function(contractId)
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[Mortal]|r Contract accepted: "..tostring(contractId))
    -- Refresh list to remove it / update status
    AIO.Msg():Add(CONTRACTS_CHANNEL, "RequestContractList"):Send()
end)

AIO.RegisterEventListener(CONTRACTS_CHANNEL, "ContractError", function(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cffff0000[Mortal]|r "..(msg or "Contract error."))
end)
```

This is fully **drop-in** once AIO is working.

---

# 7. Hooking UI into NPCs & Panels

## 7.1 NPC Gossip Example (Server Lua)

```lua
-- lua_scripts/mortal/aio/contracts_npc.lua

local CONTRACTS_NPC_ENTRY = 123456 -- TODO: your NPC entry id

local function ContractsNPC_OnGossipHello(event, player, creature)
    player:GossipClearMenu()
    player:GossipMenuAddItem(0, "Browse Courier Contracts", 0, 1)
    player:GossipSendMenu(1, creature)
end

local function ContractsNPC_OnGossipSelect(event, player, creature, sender, intid, code)
    if intid == 1 then
        MortalAIO.Contracts.OpenUI(player)
        player:GossipComplete()
    end
end

RegisterCreatureGossipEvent(CONTRACTS_NPC_ENTRY, 1, ContractsNPC_OnGossipHello)
RegisterCreatureGossipEvent(CONTRACTS_NPC_ENTRY, 2, ContractsNPC_OnGossipSelect)
```

Now you have:

- **Physical NPC** (e.g., Trade Office) that opens the contracts window.

---

# 8. Security & Validation Considerations

When you flesh this out:

- Validate everything server-side:
  - Contract still active
  - Player has gold for collateral
  - Player meets any reputation/skill requirements
- Never trust client data:
  - The contract list is just a **view**.
  - Contract IDs are always verified against DB.

Add rate limiting to:

- Contract requests
- Accept attempts

(You can build a small anti-spam check in Lua or C++.)

---

# 9. How This Pattern Repeats

You can reuse this exact AIO pattern for:

- **Market Stalls**
  - Browsing stall inventory
  - Buying items
  - Managing your stall listings

- **Bounty Board**
  - Listing bounties
  - Posting new bounties
  - Claiming rewards

- **Mentor Panel**
  - Showing attribute cap info
  - Suggesting builds
  - Offering free respecs pre-200 skill points

- **Admin Tools**
  - Mortal Control Panel
  - Logs & analytics windows

Each is just:

1. New channel name (e.g., `MORTAL_MARKET`, `MORTAL_BOUNTY`)
2. Server handlers with DB logic
3. Client UI building frames

---

# 10. Status

This file is the **authoritative AIO integration baseline** for Mortal:

- It defines where to place server/client code.
- Shows the canonical AIO usage pattern.
- Provides a working example (`Courier Contracts UI v1`) that can be pasted into Cursor and iterated into production.

