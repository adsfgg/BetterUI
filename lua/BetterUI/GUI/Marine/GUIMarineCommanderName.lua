Script.Load("lua/BetterUI/GUI/GUIPlayerHUDElement.lua")

class 'GUIMarineCommanderName' (GUIPlayerHUDElement)

GUIMarineCommanderName.kFontName = Fonts.kAgencyFB_Small
GUIMarineCommanderName.kActiveCommanderColor = Color( 246/255, 254/255, 37/255 )

function GUIMarineCommanderName:Initialize(parentScript, frame, pos, anchor)
    GUIPlayerHUDElement.Initialize(self, parentScript, frame, pos)

    self.commanderName = self.parentScript:CreateAnimatedTextItem()
    self.commanderName:SetFontName(GUIMarineCommanderName.kFontName)
    if anchor then self.commanderName:SetAnchor(anchor.x, anchor.y) end
    self.commanderName:SetLayer(kGUILayerPlayerHUDForeground1)
    self.commanderName:SetColor( Color( 1, 1, 1, 1 ) )
    self.commanderName:SetFontIsBold(true)
    self.frame:AddChild(self.commanderName)
    self:Reset(parentScript.scale)

    self.isAnimating = false
    self.lastCommanderName = ""
end

function GUIMarineCommanderName:Reset(scale)
    self.commanderName:SetUniformScale(scale)
    self.commanderName:SetPosition( self.position )
    GUIMakeFontScale(self.commanderName)
    self.commanderName:SetIsVisible(true)
end

function GUIMarineCommanderName:Update(deltaTime)
    local commanderName = PlayerUI_GetCommanderName()

    if commanderName == nil then
        commanderName = Locale.ResolveString("NO_COMMANDER")

        if not self.isAnimating then
            self.isAnimating = true
            self.commanderName:SetColor( Color( 1, 0, 0, 1) )
            self.commanderName:FadeOut(1, nil, AnimateLinear, AnimFadeIn)
        end
    else
        if self.isAnimating then
            self.isAnimating = false
            self.commanderName:DestroyAnimations()
        end

        commanderName = Locale.ResolveString("COMMANDER") .. commanderName
        self.commanderName:SetColor(GUIMarineCommanderName.kActiveCommanderColor)
    end

    if self.lastCommanderName ~= commanderName then
        self.lastCommanderName = commanderName

        commanderName = string.UTF8Upper(commanderName)
        self.commanderName:DestroyAnimation("COMM_TEXT_WRITE")
        self.commanderName:SetText("")
        self.commanderName:SetText(commanderName, 0.5, "COMM_TEXT_WRITE")
    end
end

function GUIMarineCommanderName:Uninitialize()
end

function GUIMarineCommanderName:GetElementToMove()
    return self.commanderName
end