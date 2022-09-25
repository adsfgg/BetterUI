Script.Load("lua/BetterUI/HUD/GUIPlayerHUDElement.lua")

class 'GUIMarineTeamResText' (GUIPlayerHUDElement)

GUIMarineTeamResText.kFontName = Fonts.kAgencyFB_Small

function GUIMarineTeamResText:Initialize(parentScript, frame, params)
    GUIPlayerHUDElement.Initialize(self, parentScript, frame, params)

    self.teamResText = self.parentScript:CreateAnimatedTextItem()
    self.teamResText:SetFontName(GUIMarineTeamResText.kFontName)
    self.teamResText:SetAnchor(self.anchor.x, self.anchor.y)
    self.teamResText:SetLayer(kGUILayerPlayerHUDForeground2)
    self.teamResText:SetColor(kBrightColor)
    self.teamResText:SetFontIsBold(true)
    self.teamResText:SetBlendTechnique(GUIItem.Add)
    self.frame:AddChild(self.teamResText)
    self:Reset(parentScript.scale)
end

function GUIMarineTeamResText:Reset(scale)
    self.teamResText:SetUniformScale(scale * self.elementScale)
    self.teamResText:SetScale(GetScaledVector() * self.elementScale)
    self.teamResText:SetPosition(self.position)
    self.teamResText:SetFontName(GUIMarineTeamResText.kFontName)
    GUIMakeFontScale(self.teamResText)
    self.teamResText:SetIsVisible(true)
end

function GUIMarineTeamResText:Update(deltaTime)
    self.teamResText:SetText(string.format(Locale.ResolveString("TEAM_RES"), math.floor(ScoreboardUI_GetTeamResources(kTeam1Index))))
end

function GUIMarineTeamResText:GetElementToMove()
    return self.teamResText
end

function GUIMarineTeamResText:GetClassName()
    return "GUIMarineTeamResText"
end
