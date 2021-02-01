Script.Load("lua/GUIAnimatedScript.lua")

class 'GUICustomizeHUD' (GUIAnimatedScript)

function GUICustomizeHUD:Initialize()
    GUIAnimatedScript.Initialize(self)
    PlayerUI_SetBetterUIEnabled()
    MouseTracker_SetIsVisible(true, "ui/Cursor_MenuDefault.dds", true)

    self.hudScript = PlayerUI_GetHudScript()
    if not self.hudScript.addEleCount then
        self.hudScript.addEleCount = 0
    end
end

function GUICustomizeHUD:Uninitialize()
    GUIAnimatedScript.Uninitialize(self)
    PlayerUI_SetBetterUIDisabled()
    MouseTracker_SetIsVisible(false)
end

local function ProcessMove(self, mouseX, mouseY, scale)
    local pos = self.Element:GetPosition()
    local deltaX = (mouseX - self.StartMouseX) / scale
    local deltaY = (mouseY - self.StartMouseY) / scale
    local newPos = Vector(self.StartPos.x + deltaX, self.StartPos.y + deltaY, 0)
    self.Element:SetPosition(newPos)
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
        for _, element in ipairs(uiElementsToMove) do
            local pos = element.Element:GetScreenPosition(screenWidth, screenHeight)
            local size = element.Element:GetSize() * self.scale
            if size.x == 1 and size.y == 1 then
                print("WARNING: GetSize() == (1,1) for " .. element.Name)
            end

            if mouseX >= pos.x and mouseX <= pos.x + size.x and mouseY >= pos.y and mouseY <= pos.y + size.y then
                self.hoverElement = element
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
                self.hudScript:RemoveElement(self.hoverElement.Name)
            else
                local ele = GUIMarineTeamResText()
                ele:Initialize( self.hudScript, self.hudScript.background, Vector(x / self.scale, y / self.scale, 0) )
                self.hudScript:AddElement( "element" .. self.hudScript.addEleCount, ele)
                self.hudScript.addEleCount = self.hudScript.addEleCount + 1
            end
        end
        self.rightMouseDown = down
    end

    if key == InputKey.Escape and not down then
        GetGUIManager():DestroyGUIScript(self)
        return false
    end

    return true
end
