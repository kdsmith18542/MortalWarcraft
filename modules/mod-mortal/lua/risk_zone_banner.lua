-- Mortal Warcraft Overhaul - Risk Zone Banner
-- Spec ref: 03-risk-zones.md
-- Displays a colored banner when entering a green/yellow/red zone

local RiskZoneBanner = {}
local bannerFrame = nil

function RiskZoneBanner:Show(zoneName, riskTier)
    if not bannerFrame then
        bannerFrame = CreateFrame("Frame", "MortalRiskBanner", UIParent)
        bannerFrame:SetSize(400, 60)
        bannerFrame:SetPoint("TOP", 0, -100)
        bannerFrame:SetScript("OnUpdate", function(self, elapsed)
            self.elapsed = (self.elapsed or 0) + elapsed
            if self.elapsed > 4 then
                self:Hide()
                self.elapsed = 0
            end
        end)

        local texture = bannerFrame:CreateTexture(nil, "BACKGROUND")
        texture:SetAllPoints()
        bannerFrame.texture = texture

        local text = bannerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        text:SetPoint("CENTER")
        bannerFrame.text = text
    end

    local colors = {
        [0] = { r = 0, g = 1, b = 0, label = "SAFE ZONE" },
        [1] = { r = 1, g = 1, b = 0, label = "MEDIUM RISK" },
        [2] = { r = 1, g = 0, b = 0, label = "FULL LOOT ZONE" },
    }

    local color = colors[riskTier] or colors[0]

    bannerFrame.texture:SetColorTexture(color.r, color.g, color.b, 0.4)
    bannerFrame.text:SetText(("|cff%02x%02x%02x%s|r - %s"):format(color.r * 255, color.g * 255, color.b * 255, color.label, zoneName or "Unknown"))
    bannerFrame.elapsed = 0
    bannerFrame:Show()
end

-- Hook the zone change event
local orig_ZoneChange = ZoneChange
ZoneChange = function(...)
    if orig_ZoneChange then orig_ZoneChange(...) end
    local zoneName, _, _, _, _, _, zoneId = GetRealZoneText()
    if zoneName then
        -- Server will send risk tier via chat message
        -- This is a UI fallback
    end
end

print("|cff00ff00[Mortal Warcraft] Risk zone banner loaded|r")
