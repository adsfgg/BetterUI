Script.Load("lua/BetterUI/GUI/GUIPlayerHUDElement.lua")

class 'GUIMarinePowerIcon' (GUIPlayerHUDElement)

GUIMarinePowerIcon.kMinimapBorderTexture = PrecacheAsset("ui/marine_HUD_minimap.dds")
GUIMarinePowerIcon.kMinimapBackgroundTextureCoords = { 0, 0, 400, 256 }
GUIMarinePowerIcon.kPowerIconTextureCoords = { 0, GUIMarinePowerIcon.kMinimapBackgroundTextureCoords[4] * 4, 43, GUIMarinePowerIcon.kMinimapBackgroundTextureCoords[4] * 4 + 28 }
GUIMarinePowerIcon.kPowerIconSize = Vector(GUIMarinePowerIcon.kPowerIconTextureCoords[3] - GUIMarinePowerIcon.kPowerIconTextureCoords[1], GUIMarinePowerIcon.kPowerIconTextureCoords[4] - GUIMarinePowerIcon.kPowerIconTextureCoords[2], 0)

local POWER_OFF = 1
local POWER_ON = 2
local POWER_DESTROYED = 3
local POWER_DAMAGED = 4
local powerColours = {
    Color(1, 1, 1, 0), -- OFF
    Color(30/255, 150/255, 151/255, 0.8), -- ON
    Color(0.6, 0, 0, 0.5), -- DESTROYED
    Color(30/255, 150/255, 151/255, 0.8), -- DAMAGED
}

function GUIMarinePowerIcon:Initialize(parentScript, frame, pos, anchor)
    GUIPlayerHUDElement.Initialize(self, parentScript, frame, pos)

    self.powerIcon = self.parentScript:CreateAnimatedGraphicItem()
    self.powerIcon:SetTexture(GUIMarinePowerIcon.kMinimapBorderTexture)
    self.powerIcon:SetTexturePixelCoordinates(GUIUnpackCoords(GUIMarinePowerIcon.kPowerIconTextureCoords))
    self.powerIcon:SetLayer(kGUILayerPlayerHUDForeground2)
    self.powerIcon:SetColor( Color(1,1,1,0.5) )
    if anchor then self.powerIcon:SetAnchor(anchor.x, anchor.y) end
    self.powerIcon:SetBlendTechnique(GUIItem.Add)
    self.frame:AddChild(self.powerIcon)
    self:Reset(parentScript.scale)

    self.lastPowerCheck = 0
end

function GUIMarinePowerIcon:Reset(scale)
    self.powerIcon:SetUniformScale(scale)
    self.powerIcon:SetSize(GUIMarinePowerIcon.kPowerIconSize)
    self.powerIcon:SetPosition(self.position)
    self.powerIcon:SetIsVisible(true)
end

local function UpdatePowerIcon(self, powerState)
    local colour = powerColours[powerState]
    assert(colour)

    self.powerIcon:SetColor(colour)
end

function GUIMarinePowerIcon:Update(deltaTime)
    if self.lastPowerCheck + 0.3 < Client.GetTime() then
        self.lastPowerCheck = Client.GetTime()

        local currentPowerState = POWER_OFF
        local locationPower = PlayerUI_GetLocationPower()
        local isPowered, powerSource = locationPower[1], locationPower[2]

        if powerSource and powerSource:GetIsSocketed() then
            if isPowered then
                currentPowerState = ConditionalValue(powerSource:GetHealthScalar() < 1, POWER_DAMAGED, POWER_ON)
            else
                currentPowerState = ConditionalValue(powerSource:GetIsDisabled(), POWER_DESTROYED, POWER_DAMAGED)
            end
        else
            currentPowerState = POWER_OFF
        end

        if currentPowerState ~= self.lastPowerState then
            UpdatePowerIcon(self, currentPowerState)
            self.lastPowerState = currentPowerState
        end
    end
end

function GUIMarinePowerIcon:GetElementToMove()
    return self.powerIcon
end
