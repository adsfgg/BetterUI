Script.Load("lua/GUIAnimatedScript.lua")

class 'GUICustomizeHUD' (GUIAnimatedScript)

function GUICustomizeHUD:Initialize()
    GUIAnimatedScript.Initialize(self)
    PlayerUI_SetBetterUIEnabled()
    MouseTracker_SetIsVisible(true, "ui/Cursor_MenuDefault.dds", true)

    self.hudScript = PlayerUI_GetHudScript()
end

function GUICustomizeHUD:Uninitialize()
    GUIAnimatedScript.Uninitialize(self)
    PlayerUI_SetBetterUIDisabled()
    MouseTracker_SetIsVisible(false)
end

local function ProcessMove(ele, mouseX, mouseY, scale)
    local pos = ele.Element:GetPosition()
    local deltaX = (mouseX - ele.StartMouseX) / scale
    local deltaY = (mouseY - ele.StartMouseY) / scale
    local newPos = Vector(ele.StartPos.x + deltaX, ele.StartPos.y + deltaY, 0)
    ele.Element:SetPosition(newPos)
end

function GUICustomizeHUD:Update(deltaTime)
    local mouseX, mouseY = Client.GetCursorPosScreen()
    local screenWidth = Client.GetScreenWidth()
    local screenHeight = Client.GetScreenHeight()
    local uiElementsToMove = self.hudScript:GetElementsToMove()

    -- Process clicks
    if self.mouseDown then
        if self.hoverElement and self.hoverElement.StartPos then
            ProcessMove(self.hoverElement, mouseX, mouseY, self.scale)
        end
    else
        -- Process hover
        self.hoverElement = nil
        for i, element in ipairs(uiElementsToMove) do
            local pos = element:GetScreenPosition(screenWidth, screenHeight)
            local size = element:GetSize() * self.scale

            if mouseX >= pos.x and mouseX <= pos.x + size.x and mouseY >= pos.y and mouseY <= pos.y + size.y then
                self.hoverElement = { idx = i, Element = element }
                break
            end
        end
    end
end

function GUICustomizeHUD:SendKeyEvent(key, down)
    -- Handle left clicks on an element
    if key == InputKey.MouseButton0 and self.hoverElement then
        if self.mouseDown ~= down then
            if down then
                self.hoverElement.StartMouseX, self.hoverElement.StartMouseY = Client.GetCursorPosScreen()
                self.hoverElement.StartPos = self.hoverElement.Element:GetPosition()
            else
                self.hoverElement.StartMouseX, self.hoverElement.StartMouseY, self.hoverElement.StartPos = 0, 0, nil
            end
        end
        self.mouseDown = down
    end

    -- Handle right clicks
    if key == InputKey.MouseButton1 then
        if self.rightMouseDown ~= down and down then
            local x, y = Client.GetCursorPosScreen()
            if self.hoverElement then
                self.hudScript:RemoveElement(self.hoverElement.idx)
            else
                local ele = GUIMarineTeamResText()
                ele:Initialize( self.hudScript, self.hudScript.background, { Position = { x = x / self.scale, y = y / self.scale } } )
                self.hudScript:AddElement(ele)
            end
        end
        self.rightMouseDown = down
    end

    if key == InputKey.Escape and not down then
        -- Save the HUD when we exit
        self.hudScript:SaveHUD()

        -- Destroy this GUI script
        GetGUIManager():DestroyGUIScript(self)
        
        return false
    end

    return true
end
