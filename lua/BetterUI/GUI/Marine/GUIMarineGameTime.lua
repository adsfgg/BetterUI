Script.Load("lua/BetterUI/GUI/GUIPlayerHUDElement.lua")

class 'GUIMarineGameTime' (GUIPlayerHUDElement)

GUIMarineGameTime.kFontName = Fonts.kAgencyFB_Small

function GUIMarineGameTime:Initialize(parentScript, frame, pos, anchor)
    GUIPlayerHUDElement.Initialize(self, parentScript, frame, pos)

    self.gameTime = self.parentScript:CreateAnimatedTextItem()
    self.gameTime:SetFontName(GUIMarineGameTime.kFontName)
    self.gameTime:SetFontIsBold(true)
    if anchor then self.gameTime:SetAnchor(anchor.x, anchor.y) end
    self.gameTime:SetLayer(kGUILayerPlayerHUDForeground2)
    self.gameTime:SetColor(kBrightColor)
    self.frame:AddChild(self.gameTime)
    self:Reset(parentScript.scale)
end

function GUIMarineGameTime:Reset(scale)
    self.gameTime:SetUniformScale(scale)
    self.gameTime:SetScale(GetScaledVector())
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
