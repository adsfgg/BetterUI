class 'GUIPlayerHUDElement'

function GUIPlayerHUDElement:Initialize(parentScript, frame, pos)
    self.parentScript = parentScript
    self.frame = frame
    self.position = pos
end

function GUIPlayerHUDElement:GetElementToMove()
    assert(false)
end

function GUIPlayerHUDElement:Reset(scale)
    assert(false)
end

function GUIPlayerHUDElement:Update(deltaTime)
    assert(false)
end

function GUIPlayerHUDElement:Uninitialize()
    assert(false)
end

function GUIPlayerHUDElement:CreateBackground()
    self.background = self.parentScript:CreateAnimatedGraphicItem()
    self.background:AddAsChildTo(self.frame)
end

function AnimFadeIn(scriptHandle, itemHandle)
    itemHandle:FadeIn(1, nil, AnimateLinear, AnimFadeOut)
end

function AnimFadeOut(scriptHandle, itemHandle)
    itemHandle:FadeOut(1, nil, AnimateLinear, AnimFadeIn)
end
