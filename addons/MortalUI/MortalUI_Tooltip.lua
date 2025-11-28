-- ==================================================
-- Mortal UI: Tooltip Injector
-- Description: Adds Weight, Material, and Skill Reqs to item tooltips.
-- Version: 21.1
-- ==================================================

local MortalUI = LibStub("AceAddon-3.0"):GetAddon("MortalUI")

-- Item database (populated by server via addon messages)
MortalUI_ItemDB = MortalUI_ItemDB or {}

-- Local player skill cache (updated by server)
local PlayerSkills = {}

-- Function: OnTooltipSetItem
local function OnTooltipSetItem(tooltip)
    local name, link = tooltip:GetItem()
    if not link then return end
    
    local itemID = tonumber(string.match(link, "item:(%d+)"))
    if not itemID then return end
    
    -- Note: In a real environment, you'd query a local data table populated by the server
    local itemData = MortalUI_ItemDB[itemID]
    
    if itemData then
        -- Add Weight
        if itemData.weight then
            -- Using "lbs" instead of "kg" to match encumbrance system
            tooltip:AddLine("Weight: " .. itemData.weight .. " lbs", 1, 1, 1)
        end
        
        -- Add Material/Tier
        if itemData.material then
            tooltip:AddLine("Material: " .. itemData.material, 0.7, 0.7, 0.7)
        end
        
        -- Add Skill Requirement
        if itemData.skillReq then
            local color = {r=1, g=0, b=0} -- Red (Default fail)
            -- You would check player skill here to turn it Green
            tooltip:AddLine("Requires: " .. itemData.skillName .. " (" .. itemData.skillReq .. ")", color.r, color.g, color.b)
        end
        
        tooltip:Show()
    end
end

-- Function: Update item data from server
local function UpdateItemData(itemID, weight, material, skillId, skillName, skillReq)
    if not MortalUI_ItemDB[itemID] then
        MortalUI_ItemDB[itemID] = {}
    end
    
    if weight then
        MortalUI_ItemDB[itemID].weight = weight
    end
    if material then
        MortalUI_ItemDB[itemID].material = material
    end
    if skillId then
        MortalUI_ItemDB[itemID].skillId = skillId
        MortalUI_ItemDB[itemID].skillName = skillName
        MortalUI_ItemDB[itemID].skillReq = skillReq
    end
end

-- Function: Update player skills from server
local function UpdatePlayerSkills(skillId, skillValue)
    PlayerSkills[skillId] = skillValue
end

-- Function: Handle addon messages from server
local function OnAddonMessage(event, prefix, message, channel, sender)
    if prefix ~= "MORTAL_ITEM" then
        return
    end
    
    -- Parse message format: ITEM:ID:WEIGHT:MATERIAL:SKILLID:SKILLNAME:SKILLREQ
    -- Or: SKILL:ID:VALUE (for player skill updates)
    
    if message:find("^ITEM:") then
        local itemID, weight, material, skillId, skillName, skillReq = message:match("^ITEM:(%d+):([^:]*):([^:]*):([^:]*):([^:]*):([^:]*)$")
        
        if itemID then
            UpdateItemData(
                tonumber(itemID),
                weight ~= "" and tonumber(weight) or nil,
                material ~= "" and material or nil,
                skillId ~= "" and tonumber(skillId) or nil,
                skillName ~= "" and skillName or nil,
                skillReq ~= "" and tonumber(skillReq) or nil
            )
        end
    elseif message:find("^SKILL:") then
        local skillId, skillValue = message:match("^SKILL:(%d+):(%d+)$")
        
        if skillId and skillValue then
            UpdatePlayerSkills(tonumber(skillId), tonumber(skillValue))
        end
    end
end

-- Initialize tooltip hooks
local function InitializeTooltips()
    -- Hook standard GameTooltip
    GameTooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem)
    
    -- Hook ItemRefTooltip (Chat links)
    ItemRefTooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem)
    
    -- Hook TipTac if loaded (It sometimes overrides hooks)
    if TipTac then
        -- TipTac has its own hook system, but hooking GameTooltip usually works
        -- if TipTac is configured to use it
    end
    
    -- Register for addon messages
    MortalUI:RegisterEvent("CHAT_MSG_ADDON", OnAddonMessage)
    
    print("|cff00FF00[MortalUI]: Tooltip injector loaded.|r")
end

-- Initialize on addon load
MortalUI:RegisterEvent("ADDON_LOADED", function(event, addonName)
    if addonName == "MortalUI" then
        InitializeTooltips()
    end
end)

-- Export functions for external use
MortalUI.UpdateItemData = UpdateItemData
MortalUI.UpdatePlayerSkills = UpdatePlayerSkills

