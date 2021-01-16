local startMouseX = 0
local startMouseY = 0
local startPos = nil

local oldOnUpdate = GUIMarineHUD.Update
function GUIMarineHUD:Update(deltaTime)
    oldOnUpdate(self, deltaTime)

    if not PlayerUI_GetBetterUIEnabled() then
        return
    end

    local mouseX, mouseY = Client.GetCursorPosScreen()

    -- Process mouse hover
    if not self.mouseDown then
        local statusDisplaysPosition = self.statusDisplays.statusBackground:GetScreenPosition(Client.GetScreenWidth(), Client.GetScreenHeight())
        local statusDisplaysX = statusDisplaysPosition.x
        local statusDisplaysY = statusDisplaysPosition.y
        local width = self.statusDisplays.statusBackground.guiItem:GetTextureWidth()
        local height = self.statusDisplays.statusBackground.guiItem:GetTextureHeight()
    
        if mouseX >= statusDisplaysX and mouseX <= statusDisplaysX + width and mouseY >= statusDisplaysY and mouseY <= statusDisplaysY + height then
            self.hoverElement = self.statusDisplays
        else
            self.hoverElement = nil
        end
    else
        -- Process click n drag
        if self.hoverElement and startPos then
            local pos = self.statusDisplays.statusBackground:GetPosition()
            local newPos = Vector(startPos.x + ((mouseX - startMouseX) / self.scale), startPos.y + ((mouseY - startMouseY) / self.scale), 0)
            self.statusDisplays.statusBackground:SetPosition(newPos)
        end
    end
end

function GUIMarineHUD:SendKeyEvent(key, down)
    if not PlayerUI_GetBetterUIEnabled() then return false end

    if key == InputKey.MouseButton0 then
        if self.mouseDown ~= down then
            if down then
                startMouseX, startMouseY = Client.GetCursorPosScreen()
                startPos = self.statusDisplays.statusBackground:GetPosition()
            else
                startMouseX, startMouseY, startPos = 0, 0, nil
            end
        end
        self.mouseDown = down
        -- if self.hoverElement then
        --     local mouseX, mouseY = Client.GetCursorPosScreen()
        --     local pos = self.statusDisplays.statusBackground:GetPosition()
        --     if self.mouseDown ~= down then
        --         startMouseX = mouseX
        --         startMouseY = mouseY
        --         startPos = pos
        --     end

        --     self.mouseDown = down
        --     print("CLICKED ON STATUS DISPLAYS")
        --     local newPos = Vector(startPos.x + mouseX - startMouseX, startPos.y + mouseY - startMouseY, 0)
        --     self.statusDisplays.statusBackground:SetPosition(newPos)
        -- end
    end

    if key == InputKey.Escape and not down then
        PlayerUI_SetBetterUIDisabled()
        return false
    end

    return true
end
