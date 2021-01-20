-- function GUIMarineHUD:GetElements()
--     local elements = { 
--         {Name = "statusDisplays", Element = self.statusDisplays.statusBackground},
--         {Name = "nanoshieldText", Element = self.nanoshieldText, NoScale = true},
--         {Name = "commanderName", Element = self.commanderName},
--         {Name = "locationText", Element = self.locationText},
--         {Name = "armorLevel", Element = self.armorLevel, NoScale = true},
--         {Name = "weaponLevel", Element = self.weaponLevel, NoScale = true},
--         {Name = "statusDisplay", Element = self.statusDisplay.statusbackground},
--         {Name = "gameTime", Element = self.gameTime},
--     }

--     for i,v in ipairs(self.inventoryDisplay.inventoryIcons) do
--         table.insert(elements, {Name = "inventoryIcons[" .. i .. "]", Element = v.Graphic})
--     end

--     return elements
-- end

Script.Load("lua/BetterUI/GUI/GUIPlayerHUD.lua")

-- GUI Elements
Script.Load("lua/BetterUI/GUI/Marine/GUIMarineCommanderName.lua")
Script.Load("lua/BetterUI/GUI/Marine/GUIMarineLocationText.lua")
Script.Load("lua/BetterUI/GUI/Marine/GUIMarinePowerIcon.lua")
Script.Load("lua/BetterUI/GUI/Marine/GUIMarineArmorLevelIcon.lua")
Script.Load("lua/BetterUI/GUI/Marine/GUIMarineWeaponLevelIcon.lua")
Script.Load("lua/BetterUI/GUI/Marine/GUIMarineGameTime.lua")

class 'GUIMarineHUD' (GUIPlayerHUD)

GUIMarineHUD.kFrameTexture = PrecacheAsset("ui/marine_HUD_frame.dds")
GUIMarineHUD.kFrameTopLeftCoords = { 0, 0, 680, 384 }
GUIMarineHUD.kFrameTopRightCoords = { 680, 0, 1360, 384 }
GUIMarineHUD.kFrameBottomLeftCoords = { 0, 384, 680, 768 }
GUIMarineHUD.kFrameBottomRightCoords = { 680, 384, 1360, 768 }
GUIMarineHUD.kFrameSize = Vector(1000, 600, 0)

function GUIMarineHUD:Initialize()
    GUIPlayerHUD.Initialize(self)

    -- Setup the default Marine HUD
    self.defaultElements = {
        { 
            Name = "powerIcon", 
            Class = GUIMarinePowerIcon, 
            Pos = Vector(25, 46, 0), 
            Anchor = { 
                x = GUIItem.Left, 
                y = GUIItem.Top 
            } 
        }, 
        { 
            Name = "commanderName", 
            Class = GUIMarineCommanderName, 
            Pos = Vector(30, 79, 0), 
            Anchor = { 
                x = GUIItem.Left, 
                y = GUIItem.Top 
            } 
        },
        { 
            Name = "locationText", 
            Class = GUIMarineLocationText, 
            Pos = Vector(75, 46, 0), 
            Anchor = { 
                x = GUIItem.Left, 
                y = GUIItem.Top 
            } 
        },
        { 
            Name = "armorLevelIcon", 
            Class = GUIMarineArmorLevelIcon, 
            Pos = Vector(-116, 40, 0), 
            Anchor = { 
                x = GUIItem.Right, 
                y = GUIItem.Center 
            } 
        },
        { 
            Name = "weaponLevelIcon", 
            Class = GUIMarineWeaponLevelIcon, 
            Pos = Vector(-116, 148, 0), 
            Anchor = { 
                x = GUIItem.Right, 
                y = GUIItem.Center 
            } 
        },
        { 
            Name = "gameTime", 
            Class = GUIMarineGameTime, 
            Pos = Vector(30, 109, 0), 
            Anchor = { 
                x = GUIItem.Left, 
                y = GUIItem.Top 
            } 
        },
    }

    -- Initialize Marine frame
    self:InitFrame()

    -- Load saved HUD
    self:LoadHUD()
end

function GUIMarineHUD:InitFrame()
    self.topLeftFrame = GetGUIManager():CreateGraphicItem()
    self.topLeftFrame:SetTexture(GUIMarineHUD.kFrameTexture)
    self.topLeftFrame:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.topLeftFrame:SetTexturePixelCoordinates(GUIUnpackCoords(GUIMarineHUD.kFrameTopLeftCoords))
    self.topLeftFrame:SetIsVisible(true)
    self.background:AddChild(self.topLeftFrame)
    
    self.topRightFrame = GetGUIManager():CreateGraphicItem()
    self.topRightFrame:SetTexture(GUIMarineHUD.kFrameTexture)
    self.topRightFrame:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.topRightFrame:SetTexturePixelCoordinates(GUIUnpackCoords(GUIMarineHUD.kFrameTopRightCoords))
    self.topRightFrame:SetIsVisible(true)
    self.background:AddChild(self.topRightFrame)
    
    self.bottomLeftFrame = GetGUIManager():CreateGraphicItem()
    self.bottomLeftFrame:SetTexture(GUIMarineHUD.kFrameTexture)
    self.bottomLeftFrame:SetAnchor(GUIItem.Left, GUIItem.Bottom)
    self.bottomLeftFrame:SetTexturePixelCoordinates(GUIUnpackCoords(GUIMarineHUD.kFrameBottomLeftCoords))
    self.bottomLeftFrame:SetIsVisible(true)
    self.background:AddChild(self.bottomLeftFrame)
    
    self.bottomRightFrame = GetGUIManager():CreateGraphicItem()
    self.bottomRightFrame:SetTexture(GUIMarineHUD.kFrameTexture)
    self.bottomRightFrame:SetAnchor(GUIItem.Right, GUIItem.Bottom)
    self.bottomRightFrame:SetTexturePixelCoordinates(GUIUnpackCoords(GUIMarineHUD.kFrameBottomRightCoords))
    self.bottomRightFrame:SetIsVisible(true)
    self.background:AddChild(self.bottomRightFrame)
end

function GUIMarineHUD:Reset()
    GUIPlayerHUD.Reset(self)

    self.topLeftFrame:SetSize(GUIMarineHUD.kFrameSize * self.scale)
    
    self.topRightFrame:SetSize(GUIMarineHUD.kFrameSize * self.scale)
    self.topRightFrame:SetPosition(Vector(-GUIMarineHUD.kFrameSize.x, 0, 0) * self.scale)
    
    self.bottomLeftFrame:SetSize(GUIMarineHUD.kFrameSize * self.scale)
    self.bottomLeftFrame:SetPosition(Vector(0, -GUIMarineHUD.kFrameSize.y, 0) * self.scale)
    
    self.bottomRightFrame:SetSize(GUIMarineHUD.kFrameSize * self.scale)
    self.bottomRightFrame:SetPosition(Vector(-GUIMarineHUD.kFrameSize.x, -GUIMarineHUD.kFrameSize.y, 0) * self.scale)
end
