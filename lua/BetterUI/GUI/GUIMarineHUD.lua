local startMouseX = 0
local startMouseY = 0
local startPos = nil

local uiElementsToMove

local oldInit = GUIMarineHUD.Initialize
function GUIMarineHUD:Initialize()
    oldInit(self)

    uiElementsToMove = {
        {Element = self.statusDisplays.statusBackground},
        {Element = self.nanoshieldText, NoScale = true},
        {Element = self.commanderName},
        {Element = self.locationText},
        {Element = self.armorLevel, NoScale = true},
        {Element = self.weaponLevel, NoScale = true},
        {Element = self.statusDisplay.statusbackground},
        {Element = self.gameTime},
    }
end

local function ProcessMove(self, mouseX, mouseY, scale)
    local pos = self.Element:GetPosition()
    local deltaX = (mouseX - self.StartMouseX) / scale
    local deltaY = (mouseY - self.StartMouseY) / scale
    local newPos = Vector(self.StartPos.x + deltaX, self.StartPos.y + deltaY, 0)
    self.Element:SetPosition(newPos)
end

local oldOnUpdate = GUIMarineHUD.Update
function GUIMarineHUD:Update(deltaTime)
    oldOnUpdate(self, deltaTime)

    if not PlayerUI_GetBetterUIEnabled() then
        return
    end

    local mouseX, mouseY = Client.GetCursorPosScreen()
    local screenWidth = Client.GetScreenWidth()
    local screenHeight = Client.GetScreenHeight()

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

            if mouseX >= pos.x and mouseX <= pos.x + size.x and mouseY >= pos.y and mouseY <= pos.y + size.y then
                self.hoverElement = element
                break
            end
        end
    end
end

function GUIMarineHUD:SendKeyEvent(key, down)
    if not PlayerUI_GetBetterUIEnabled() then return false end

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

    if key == InputKey.Escape and not down then
        PlayerUI_SetBetterUIDisabled()
        return false
    end

    return true
end
