Script.Load("lua/BetterUI/HUD/GUIPlayerHUDElement.lua")

class 'GUIMarineWeaponLevelIcon' (GUIPlayerHUDElement)

GUIMarineWeaponLevelIcon.kUpgradesTexture = "ui/buildmenu.dds"
GUIMarineWeaponLevelIcon.kUpgradeSize = Vector(100, 100, 0)

local kWeaponTechId = {
    kTechId.Weapons1,
    kTechId.Weapons2,
    kTechId.Weapons3
}

function GUIMarineWeaponLevelIcon:Initialize(parentScript, frame, params)
    GUIPlayerHUDElement.Initialize(self, parentScript, frame, params)

    self.weaponLevel = self.parentScript:CreateAnimatedGraphicItem()
    self.weaponLevel:SetTexture(GUIMarineWeaponLevelIcon.kUpgradesTexture)
    self.weaponLevel:SetAnchor(self.anchor.x, self.anchor.y)
    self.frame:AddChild(self.weaponLevel)
    self:Reset(parentScript.scale)

    self.lastWeaponLevel = 0
end

function GUIMarineWeaponLevelIcon:Reset(scale)
    self.weaponLevel:SetUniformScale(scale * self.elementScale)
    self.weaponLevel:SetPosition(self.position)
    self.weaponLevel:SetSize(GUIMarineWeaponLevelIcon.kUpgradeSize)
    self.weaponLevel:SetIsVisible(false)
end

local function ShowNewWeaponLevel(self, weaponLevel)
    if weaponLevel ~= 0 then
        local texCoords = GetTextureCoordinatesForIcon(kWeaponTechId[weaponLevel], true)
        self.weaponLevel:SetTexturePixelCoordinates(GUIUnpackCoords(texCoords))
    end
end

function GUIMarineWeaponLevelIcon:Update(deltaTime)
    local weaponLevel = PlayerUI_GetWeaponLevel()
    self.weaponLevel:SetIsVisible(weaponLevel ~= 0)

    if weaponLevel ~= self.lastWeaponLevel then
        ShowNewWeaponLevel(self, weaponLevel)
        self.lastWeaponLevel = weaponLevel
    end

    local color = kIconColors[kMarineTeamType]
    if not MarineUI_GetHasArmsLab() then
        color = Color(1, 0, 0, 1)
    end

    self.weaponLevel:SetColor(color)
end

function GUIMarineWeaponLevelIcon:GetElementToMove()
    return self.weaponLevel
end

function GUIMarineWeaponLevelIcon:GetClassName()
    return "GUIMarineWeaponLevelIcon"
end
