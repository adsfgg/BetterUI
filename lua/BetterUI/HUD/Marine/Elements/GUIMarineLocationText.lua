Script.Load("lua/BetterUI/HUD/GUIPlayerHUDElement.lua")

class 'GUIMarineLocationText' (GUIPlayerHUDElement)

GUIMarineLocationText.kFontName = Fonts.kAgencyFB_Small

function GUIMarineLocationText:Initialize(parentScript, frame, params)
    GUIPlayerHUDElement.Initialize(self, parentScript, frame, params)

    self.locationText = self.parentScript:CreateAnimatedTextItem()
    self.locationText:SetFontName(GUIMarineLocationText.kFontName)
    self.locationText:SetAnchor(self.anchor.x, self.anchor.y)
    self.locationText:SetLayer(kGUILayerPlayerHUDForeground2)
    self.locationText:SetColor(kBrightColor)
    self.locationText:SetFontIsBold(true)
    self.frame:AddChild(self.locationText)
    self:Reset(parentScript.scale)
    
    self.lastLocationText = ""
end

function GUIMarineLocationText:Reset(scale)
    self.locationText:SetUniformScale(scale * self.elementScale)
    self.locationText:SetScale(GetScaledVector() * self.elementScale)
    self.locationText:SetPosition(self.position)
    self.locationText:SetFontName(GUIMarineLocationText.kFontName)
    GUIMakeFontScale(self.locationText)
    self.locationText:SetIsVisible(true)
end

function GUIMarineLocationText:Update(deltaTime)
    local locationName = ConditionalValue(PlayerUI_GetLocationName(), string.upper(PlayerUI_GetLocationName()), "")

    if self.lastLocationText ~= locationName then
        self.locationText:SetText(locationName)
        self.lastLocationText = locationName
    end
end

function GUIMarineLocationText:GetElementToMove()
    return self.locationText
end

function GUIMarineLocationText:GetClassName()
    return "GUIMarineLocationText"
end
