Script.Load("lua/BetterUI/HUD/GUIPlayerHUDElement.lua")

class 'GUIMarineGameTime' (GUIPlayerHUDElement)

GUIMarineGameTime.kFontName = Fonts.kAgencyFB_Small

function GUIMarineGameTime:Initialize(parentScript, frame, params)
    GUIPlayerHUDElement.Initialize(self, parentScript, frame, params)

    self.gameTime = self.parentScript:CreateAnimatedTextItem()
    self.gameTime:SetFontName(GUIMarineGameTime.kFontName)
    self.gameTime:SetFontIsBold(true)
    self.gameTime:SetAnchor(self.anchor.x, self.anchor.y)
    self.gameTime:SetLayer(kGUILayerPlayerHUDForeground2)
    self.gameTime:SetColor(kBrightColor)
    self.frame:AddChild(self.gameTime)
    self:Reset(parentScript.scale)
end

function GUIMarineGameTime:Reset(scale)
    self.gameTime:SetUniformScale(scale * self.elementScale)
    self.gameTime:SetScale(GetScaledVector() * self.elementScale)
    self.gameTime:SetPosition(self.position)
    self.gameTime:SetFontName(GUIMarineGameTime.kFontName)
    GUIMakeFontScale(self.gameTime)
    self.gameTime:SetIsVisible(true)
end

function GUIMarineGameTime:Update(deltaTime)
    self.gameTime:SetText(PlayerUI_GetGameTimeString())
end

function GUIMarineGameTime:GetElementToMove()
    return self.gameTime
end

function GUIMarineGameTime:GetClassName()
    return "GUIMarineGameTime"
end
