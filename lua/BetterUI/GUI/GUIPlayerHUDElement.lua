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
    if self:GetElementToMove() then
        self:GetElementToMove():Destroy()
    end
end

function GUIPlayerHUD:GetElementToMove()
    assert(false)
end

function AnimFadeIn(scriptHandle, itemHandle)
    itemHandle:FadeIn(1, nil, AnimateLinear, AnimFadeOut)
end

function AnimFadeOut(scriptHandle, itemHandle)
    itemHandle:FadeOut(1, nil, AnimateLinear, AnimFadeIn)
end
