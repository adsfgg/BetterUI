Script.Load("lua/BetterUI/HUD/GUIPlayerHUDElement.lua")

class 'GUIMarineArmorLevelIcon' (GUIPlayerHUDElement)

GUIMarineArmorLevelIcon.kUpgradesTexture = "ui/buildmenu.dds"
GUIMarineArmorLevelIcon.kUpgradeSize = Vector(100, 100, 0)

local kArmorTechId = {
    kTechId.Armor1,
    kTechId.Armor2,
    kTechId.Armor3
}

function GUIMarineArmorLevelIcon:Initialize(parentScript, frame, pos, anchor)
    GUIPlayerHUDElement.Initialize(self, parentScript, frame, pos)

    self.armorLevel = self.parentScript:CreateAnimatedGraphicItem()
    self.armorLevel:SetTexture(GUIMarineArmorLevelIcon.kUpgradesTexture)
    if anchor then self.armorLevel:SetAnchor(anchor.x, anchor.y) end
    self.frame:AddChild(self.armorLevel)
    self:Reset(parentScript.scale)

    self.lastArmorLevel = 0
end

function GUIMarineArmorLevelIcon:Reset(scale)
    self.armorLevel:SetUniformScale(scale)
    self.armorLevel:SetPosition(self.position)
    self.armorLevel:SetSize(GUIMarineArmorLevelIcon.kUpgradeSize)
    self.armorLevel:SetIsVisible(false)
end

local function ShowNewArmorLevel(self, armorLevel)
    if armorLevel ~= 0 then
        local texCoords = GetTextureCoordinatesForIcon(kArmorTechId[armorLevel], true)
        self.armorLevel:SetTexturePixelCoordinates(GUIUnpackCoords(texCoords))
    end
end

function GUIMarineArmorLevelIcon:Update(deltaTime)
    local armorLevel = PlayerUI_GetArmorLevel()
    self.armorLevel:SetIsVisible(armorLevel ~= 0)

    if armorLevel ~= self.lastArmorLevel then
        ShowNewArmorLevel(self, armorLevel)
        self.lastArmorLevel = armorLevel
    end

    local color = kIconColors[kMarineTeamType]
    if not MarineUI_GetHasArmsLab() then
        color = Color(1, 0, 0, 1)
    end

    self.armorLevel:SetColor(color)
end

function GUIMarineArmorLevelIcon:GetElementToMove()
    return self.armorLevel
end
