local oldOnUpdate = GUIAlienHUD.Update
function GUIAlienHUD:Update(deltaTime)
    oldOnUpdate(self, deltaTime)
end

function GUIAlienHUD:SendKeyEvent(key, down)
    if not PlayerUI_GetBetterUIEnabled() then return false end

    if key == InputKey.MouseButton0 and self.mousePressed ~= down then
        self.mousePressed = down
    end

    if key == InputKey.Escape and not down then
        PlayerUI_SetBetterUIDisabled()
        return false
    end

    return true
end
