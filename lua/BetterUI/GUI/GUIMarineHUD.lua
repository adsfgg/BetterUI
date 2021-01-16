function GUIMarineHUD:EnableBetterUIModification()
    self.betterUI = true
end

function GUIMarineHUD:DisableBetterUIModification()
    self.betterUI = false
end

local oldOnUpdate = GUIMarineHUD.Update
function GUIMarineHUD:Update(deltaTime)
    oldOnUpdate(self, deltaTime)
    if not self.betterUI then return end

    -- We want to spoof some values for the ui configuration

    -- Update health armour bar
    local statusUpdate = {
        50, -- health
        100, -- max health
        15, -- armor
        30, -- armor
        2, -- parasite state (2 = parad, 1 = not)
        0, -- regen health
        20, -- seconds para remaining
    }
    self.statusDisplay:Update(deltaTime, statusUpdate)

    -- Update player status icons
    local playerStatusIcons = {
        2, -- parasite state
        20, -- parasite time remaining
        2, -- nanoshield state ( 2 = enabled )
        3, -- seconds nanoshield remaining
        2, -- catpack state ( 2 = enabled )
        3, -- seconds catpack remaining
        true, -- corroded flag
    }

    self.statusDisplays:Update(deltaTime, playerStatusIcons, self.cachedHudDetail == kHUDMode.Full)
    self.statusDisplays:SetIsVisible(true)
    
    -- Update resource display
    local resourceUpdate = {
        150, -- tres
        20, -- pres
        3, -- rt count
    }

    self.resourceDisplay:Update(deltaTime, resourceUpdate)
end
