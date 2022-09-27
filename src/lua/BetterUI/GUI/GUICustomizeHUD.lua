Script.Load("lua/GUIAnimatedScript.lua")

class 'GUICustomizeHUD' (GUIAnimatedScript)

local function CreateOutlineBox()
    local box = GetGUIManager():CreateLinesItem()
    box:SetScale(GetScaledVector())
    box:SetIsVisible(false)

    return box
end

function GUICustomizeHUD:Initialize()
    GUIAnimatedScript.Initialize(self)
    PlayerUI_SetBetterUIEnabled()
    MouseTracker_SetIsVisible(true, "ui/Cursor_MenuDefault.dds", true)

    -- Tell the Player_Client that we're customising (displays blur)
    local player = Client.GetLocalPlayer()
    assert(player)
    player.customisingHud = true

    self.hudScript = PlayerUI_GetHudScript()

    self.background = self:CreateAnimatedGraphicItem()
    self.background:SetPosition( Vector( 0, 0, 0 ) )
    self.background:SetIsScaling(false)
    self.background:SetIsVisible(true)
    self.background:SetLayer(kGUILayerPlayerHUDBackground)
    self.background:SetColor( Color( 1, 1, 1, 0 ) )
    
    self.outlineBoxes = {}
    for i = 1,#self.hudScript:GetElementsToMove() do
        self.outlineBoxes[i] = CreateOutlineBox()
        self.background:AddChild(self.outlineBoxes[i])
    end
end

function GUICustomizeHUD:AddOutlineBox()
    local i = #self.outlineBoxes + 1
    self.outlineBoxes[i] = CreateOutlineBox()
    self.background:AddChild(self.outlineBoxes[i])
end

function GUICustomizeHUD:Uninitialize()
    GUIAnimatedScript.Uninitialize(self)
    PlayerUI_SetBetterUIDisabled()
    MouseTracker_SetIsVisible(false)

    -- Tell the Player_Client that we're no longer customising (hides blur)
    local player = Client.GetLocalPlayer()
    assert(player)
    player.customisingHud = false
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

    -- Outlines
    for _,box in ipairs(self.outlineBoxes) do
        box:SetIsVisible(false)
    end

    local outlineColor = Color(1, 0, 0, 1)
    local screenWidth = Client.GetScreenWidth()
    local screenHeight = Client.GetScreenHeight()

    for i, ele in ipairs(uiElementsToMove) do
        local pos = ele:GetScreenPosition(screenWidth, screenHeight)
        local size = ele:GetSize() * self.scale
    
        local topLeft = Vector(pos.x, pos.y, 0)
        local topRight = Vector(pos.x + size.x, pos.y, 0)
        local bottomLeft = Vector(pos.x, pos.y + size.y, 0)
        local bottomRight = Vector(pos.x + size.x, pos.y + size.y, 0)
    
        self.outlineBoxes[i]:SetIsVisible(true)
        self.outlineBoxes[i]:ClearLines()
        self.outlineBoxes[i]:AddLine(topLeft, topRight, outlineColor)
        self.outlineBoxes[i]:AddLine(bottomLeft, bottomRight, outlineColor)
        self.outlineBoxes[i]:AddLine(topLeft, bottomLeft, outlineColor)
        self.outlineBoxes[i]:AddLine(topRight, bottomRight, outlineColor)
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
                self:AddOutlineBox()
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
