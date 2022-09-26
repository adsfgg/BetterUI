Script.Load("lua/BetterUI/HUD/GUIPlayerHUD.lua")

-- GUI Elements
Script.Load("lua/BetterUI/HUD/Marine/Elements/GUIMarineCommanderName.lua")
Script.Load("lua/BetterUI/HUD/Marine/Elements/GUIMarineLocationText.lua")
Script.Load("lua/BetterUI/HUD/Marine/Elements/GUIMarinePowerIcon.lua")
Script.Load("lua/BetterUI/HUD/Marine/Elements/GUIMarineArmorLevelIcon.lua")
Script.Load("lua/BetterUI/HUD/Marine/Elements/GUIMarineWeaponLevelIcon.lua")
Script.Load("lua/BetterUI/HUD/Marine/Elements/GUIMarineGameTime.lua")
Script.Load("lua/BetterUI/HUD/Marine/Elements/GUIMarineTeamResText.lua")
Script.Load("lua/BetterUI/HUD/Marine/Elements/GUIMarineMinimap.lua")
Script.Load("lua/BetterUI/HUD/Marine/Elements/GUIMarineAmmoCounter.lua")

class 'GUIMarineHUD' (GUIPlayerHUD)

-- Marine Frame
GUIMarineHUD.kFrameTexture = PrecacheAsset("ui/marine_HUD_frame.dds")
GUIMarineHUD.kFrameTopLeftCoords = { 0, 0, 680, 384 }
GUIMarineHUD.kFrameTopRightCoords = { 680, 0, 1360, 384 }
GUIMarineHUD.kFrameBottomLeftCoords = { 0, 384, 680, 768 }
GUIMarineHUD.kFrameBottomRightCoords = { 680, 384, 1360, 768 }
GUIMarineHUD.kFrameSize = Vector(1000, 600, 0)

-- Poisoned feedback
GUIMarineHUD.kBuyMenuTexture = "ui/alien_buymenu.dds"
GUIMarineHUD.kCornerTextureCoordinates = { TopLeft = { 605, 1, 765, 145 },  BottomLeft = { 605, 145, 765, 290 }, TopRight = { 765, 1, 910, 145 }, BottomRight = { 765, 145, 910, 290 } }
GUIMarineHUD.kCornerWidths = { }
GUIMarineHUD.kCornerHeights = { }
for location, texCoords in pairs(GUIMarineHUD.kCornerTextureCoordinates) do
    GUIMarineHUD.kCornerWidths[location] = GUIScale(texCoords[3] - texCoords[1]) * 2
    GUIMarineHUD.kCornerHeights[location] = GUIScale(texCoords[4] - texCoords[2]) * 2
end
GUIMarineHUD.kRegenVeinColor = Color(0.2, 0.6, 0, 0)
GUIMarineHUD.kRegenPulseDuration = 1

function GUIMarineHUD:Initialize()
    GUIPlayerHUD.Initialize(self)

    -- Setup the default Marine HUD
    self.defaultElements = {
        { Class = "GUIMarinePowerIcon", Params = { Position = { x = 25, y = 46 }, Anchor = { x = GUIItem.Left, y = GUIItem.Top } } },
        { Class = "GUIMarineCommanderName", Params = { Position = { x = 30, y = 332 }, Anchor = { x = GUIItem.Left, y = GUIItem.Top } } },
        { Class = "GUIMarineMinimap", Params = { Position = { x = 30, y = 80 }, Anchor = { x = GUIItem.Left, y = GUIItem.Top } } },
        { Class = "GUIMarineLocationText", Params = { Position = { x = 75, y = 46 }, Anchor = { x = GUIItem.Left, y = GUIItem.Top } } },
        { Class = "GUIMarineArmorLevelIcon", Params = { Position = { x = -116, y = 40 }, Anchor = { x = GUIItem.Right, y = GUIItem.Center } } },
        { Class = "GUIMarineWeaponLevelIcon", Params = { Position = { x = -116, y = 148 }, Anchor = { x = GUIItem.Right, y = GUIItem.Center } } },
        { Class = "GUIMarineGameTime", Params = { Position = { x = 30, y = 359 }, Anchor = { x = GUIItem.Left, y = GUIItem.Top } } },
        { Class = "GUIMarineAmmoCounter", Params = { Position = { x = -210, y = -115 }, Anchor = { x = GUIItem.Right, y = GUIItem.Bottom } } },
    }

    -- Initialize Marine frame
    self:InitFrame()
    -- Initialize Marine poison frame
    self:InitPoisonFrame()

    -- Load saved HUD
    self:LoadHUD()

    self:UpdateVisibility()
end

function GUIMarineHUD:Reset()
    GUIPlayerHUD.Reset(self)

    self:ResetFrame()
    self:ResetPoisonFrame()
end

function GUIMarineHUD:UpdateVisibility()
    local frameState = Client.BetterUI_GetMarineLines()
    self.topLeftFrame:SetIsVisible(frameState)
    self.topRightFrame:SetIsVisible(frameState)
    self.bottomLeftFrame:SetIsVisible(frameState)
    self.bottomRightFrame:SetIsVisible(frameState)

    local poisonState = Client.BetterUI_GetMarinePoison()
    self.poisonBottomLeft:SetIsVisible(poisonState)
    self.poisonBottomRight:SetIsVisible(poisonState)
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

function GUIMarineHUD:InitPoisonFrame()
    self.poisonBottomLeft = self:CreateAnimatedGraphicItem()
    self.poisonBottomLeft:SetAnchor(GUIItem.Left, GUIItem.Bottom)
    self.poisonBottomLeft:SetTexture(GUIMarineHUD.kBuyMenuTexture)
    self.poisonBottomLeft:SetTexturePixelCoordinates(GUIUnpackCoords(GUIMarineHUD.kCornerTextureCoordinates.BottomLeft))
    self.poisonBottomLeft:SetLayer(kGUILayerPlayerHUDBackground)
    self.poisonBottomLeft:SetShader("shaders/GUIWavyNoMask.surface_shader")
    self.poisonBottomLeft:SetColor(GUIMarineHUD.kRegenVeinColor)
    self.background:AddChild(self.poisonBottomLeft)
    
    self.poisonBottomRight = self:CreateAnimatedGraphicItem()
    self.poisonBottomRight:SetAnchor(GUIItem.Right, GUIItem.Bottom)
    self.poisonBottomRight:SetTexture(GUIMarineHUD.kBuyMenuTexture)
    self.poisonBottomRight:SetTexturePixelCoordinates(GUIUnpackCoords(GUIMarineHUD.kCornerTextureCoordinates.BottomRight))
    self.poisonBottomRight:SetLayer(kGUILayerPlayerHUDBackground)
    self.poisonBottomRight:SetShader("shaders/GUIWavyNoMask.surface_shader")
    self.poisonBottomRight:SetColor(GUIMarineHUD.kRegenVeinColor)
    self.background:AddChild(self.poisonBottomRight)
end

function GUIMarineHUD:ResetFrame()
    self.topLeftFrame:SetSize(GUIMarineHUD.kFrameSize * self.scale)
    
    self.topRightFrame:SetSize(GUIMarineHUD.kFrameSize * self.scale)
    self.topRightFrame:SetPosition(Vector(-GUIMarineHUD.kFrameSize.x, 0, 0) * self.scale)
    
    self.bottomLeftFrame:SetSize(GUIMarineHUD.kFrameSize * self.scale)
    self.bottomLeftFrame:SetPosition(Vector(0, -GUIMarineHUD.kFrameSize.y, 0) * self.scale)
    
    self.bottomRightFrame:SetSize(GUIMarineHUD.kFrameSize * self.scale)
    self.bottomRightFrame:SetPosition(Vector(-GUIMarineHUD.kFrameSize.x, -GUIMarineHUD.kFrameSize.y, 0) * self.scale)
end

function GUIMarineHUD:ResetPoisonFrame()
    self.poisonBottomLeft:SetSize(Vector(GUIMarineHUD.kCornerWidths.BottomLeft, GUIMarineHUD.kCornerHeights.BottomLeft, 0) * self.scale)
    self.poisonBottomLeft:SetPosition(Vector(0, -GUIMarineHUD.kCornerHeights.BottomLeft, 0) * self.scale)

    self.poisonBottomRight:SetSize(Vector(GUIMarineHUD.kCornerWidths.BottomRight, GUIMarineHUD.kCornerHeights.BottomRight, 0) * self.scale)
    self.poisonBottomRight:SetPosition(Vector(-GUIMarineHUD.kCornerWidths.BottomRight, -GUIMarineHUD.kCornerHeights.BottomRight, 0) * self.scale)
end

function GUIMarineHUD:GetIsAnimatingPoisonEffect()
    return self.poisonBottomLeft:GetIsAnimating() and not (Client and Client.BetterUI_GetMarinePoison and Client.BetterUI_GetMarinePoison())
end

function GUIMarineHUD:TriggerPoisonEffect()
    local PulseOut = function (script, item)
        item:FadeOut(GUIMarineHUD.kRegenPulseDuration, "ANIM_REGEN_VEIN", AnimateSin)
    end

    self.poisonBottomLeft:FadeIn(GUIMarineHUD.kRegenPulseDuration, "ANIM_REGEN_VEIN", AnimateSin, PulseOut)
    self.poisonBottomRight:FadeIn(GUIMarineHUD.kRegenPulseDuration, "ANIM_REGEN_VEIN", AnimateSin, PulseOut)
end

function GUIMarineHUD:GetConfigFileLocation()
    return "config://BetterUI/marine.json"
end
