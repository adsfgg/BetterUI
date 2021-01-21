-- function GUIAlienHUD:GetElements()
--     local elements = { 
--         {Name = "resourceDisplay", Element = self.resourceDisplay.background},
--         {Name = "eventDisplay", Element = self.eventDisplay.notificationFrame},
--         {Name = "statusDisplays", Element = self.statusDisplays.statusBackground},
--         {Name = "gameTime", Element = self.gameTime},
--         {Name = "teamResText", Element = self.teamResText},
--         {Name = "healthBall", Element = self.healthBall:GetBackground(), NoScale = true},
--         {Name = "energyBall", Element = self.energyBall:GetBackground(), NoScale = true},
--     }

--     for i,v in ipairs(self.inventoryDisplay.inventoryIcons) do
--         table.insert(elements, {Name = "inventoryIcons[" .. i .. "]", Element = v.Graphic})
--     end

--     return elements
-- end

Script.Load("lua/BetterUI/GUI/GUIPlayerHUD.lua")

-- GUI Elements
-- Script.Load("lua/BetterUI/GUI/Marine/GUIMarineCommanderName.lua")

class 'GUIAlienHUD' (GUIPlayerHUD)

function GUIAlienHUD:Initialize()
    GUIPlayerHUD.Initialize(self)

    -- Setup the default Marine HUD
    self.defaultElements = {
    }

    -- Load saved HUD
    self:LoadHUD()
end

function GUIAlienHUD:Reset()
    GUIPlayerHUD.Reset(self)
end
