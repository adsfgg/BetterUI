Script.Load("lua/BetterUI/GUI/GUIPlayerHUDElement.lua")

class 'GUIMarineLocationText' (GUIPlayerHUDElement)

GUIMarineLocationText.kFontName = Fonts.kAgencyFB_Small

function GUIMarineLocationText:Initialize(parentScript, frame, pos, anchor)
    GUIPlayerHUDElement.Initialize(self, parentScript, frame, pos)

    self.locationText = self.parentScript:CreateAnimatedTextItem()
    self.locationText:SetFontName(GUIMarineLocationText.kFontName)
    if anchor then self.locationText:SetAnchor(anchor.x, anchor.y) end
    self.locationText:SetLayer(kGUILayerPlayerHUDForeground2)
    self.locationText:SetColor(kBrightColor)
    self.locationText:SetFontIsBold(true)
    self.frame:AddChild(self.locationText)
    self:Reset(parentScript.scale)
    
    self.lastLocationText = ""
end

function GUIMarineLocationText:Reset(scale)
    self.locationText:SetUniformScale(scale)
    self.locationText:SetScale(GetScaledVector())
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

function GUIMarineLocationText:Uninitialize()
end

function GUIMarineLocationText:GetElementToMove()
    return self.locationText
end
