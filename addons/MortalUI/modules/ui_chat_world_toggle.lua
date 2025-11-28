-- ==================================================
-- Mortal UI: World Chat Toggle
-- Spec: 85-mortal-chat-and-channels.md
-- ==================================================
-- Provides UI toggle for joining/leaving World Chat

local WorldChatToggle = {
    enabled = true,
    frame = nil
}

local function ToggleWorldChat(enabled)
    WorldChatToggle.enabled = enabled
    
    if enabled then
        -- Join World channel
        SendChatMessage("/join World", "GUILD")
    else
        -- Leave World channel
        SendChatMessage("/leave World", "GUILD")
    end
end

local function CreateWorldChatToggle()
    if WorldChatToggle.frame then
        return WorldChatToggle.frame
    end
    
    -- Create options frame (would integrate with MortalUI options panel)
    -- For now, this is a placeholder that can be expanded
    
    return nil
end

-- Initialize on login
local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("PLAYER_LOGIN")
initFrame:SetScript("OnEvent", function()
    -- Auto-join World Chat if player is onboarded and in Green/Yellow zone
    -- This would check server-side flags, but for now we'll let players manually join
    CreateWorldChatToggle()
end)

