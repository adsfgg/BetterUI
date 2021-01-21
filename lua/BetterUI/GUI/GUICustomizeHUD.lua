Script.Load("lua/GUIAnimatedScript.lua")

class 'GUICustomizeHUD' (GUIAnimatedScript)

local hudScripts = {
    [kTeam1Index] = "Hud/Marine/GUIMarineHUD",
    [kTeam2Index] = "GUIAlienHUD"
}
local hudScript

function GUICustomizeHUD:Initialize()
    GUIAnimatedScript.Initialize(self)
    PlayerUI_SetBetterUIEnabled()
    MouseTracker_SetIsVisible(true, "ui/Cursor_MenuDefault.dds", true)

    local player = Client.GetLocalPlayer()
    if player and player.GetTeamNumber then
        hudScript = ClientUI.GetScript(hudScripts[player:GetTeamNumber()])
    end
    if not hudScript.commanderNameCount then
        hudScript.commanderNameCount = 0
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
    local uiElementsToMove = hudScript:GetElementsToMove()

    -- Process clicks
    if self.mouseDown then
        if self.hoverElement and self.hoverElement.StartPos then
            local scale = ConditionalValue(self.hoverElement.NoScale, 1, self.scale)
            ProcessMove(self.hoverElement, mouseX, mouseY, scale)
        end
    else
        -- Process hover
        self.hoverElement = nil
        for _, element in ipairs(uiElementsToMove) do
            local pos = element.Element:GetScreenPosition(screenWidth, screenHeight)
            local size = element.Element:GetSize()
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

    -- Handle right clicks not on element
    if key == InputKey.MouseButton1 then
        if self.rightMouseDown ~= down and down then
            local x, y = Client.GetCursorPosScreen()
            if self.hoverElement then
                hudScript:RemoveElement(self.hoverElement.Name)
            else
                local commName = GUIMarineCommanderName()
                commName:Initialize( hudScript, hudScript.background, Vector(x / self.scale, y / self.scale, 0) )
                hudScript:AddElement( "commanderName" .. hudScript.commanderNameCount, commName)
                hudScript.commanderNameCount = hudScript.commanderNameCount + 1
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
