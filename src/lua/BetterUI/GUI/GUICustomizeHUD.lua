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

    -- Add alignment lines
    local screenWidth = Client.GetScreenWidth()
    local screenHeight = Client.GetScreenHeight()
    local alignmentLineColor = Color(0.8, 0.8, 0.8, 0.5)
    local topCenter = Vector(screenWidth / 2, 0, 0)
    local bottomCenter = Vector(screenWidth / 2, screenHeight, 0)
    local leftCenter = Vector(0, screenHeight / 2, 0)
    local rightCenter = Vector(screenWidth, screenHeight / 2, 0)

    local alignmentLines = GetGUIManager():CreateLinesItem()
    alignmentLines:SetScale(GetScaledVector())
    alignmentLines:SetIsVisible(true)
    alignmentLines:ClearLines()
    alignmentLines:AddLine(topCenter, bottomCenter, alignmentLineColor)
    alignmentLines:AddLine(leftCenter, rightCenter, alignmentLineColor)
    self.background:AddChild(alignmentLines)
    
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

function GUICustomizeHUD:ProcessMove(mouseX, mouseY)
    local ele = self.hoverElement
    local currPos = ele.Element:GetPosition()
    local deltaX = (mouseX - ele.LastMouseX) / self.scale
    local deltaY = (mouseY - ele.LastMouseY) / self.scale

    if self.lockAxis then
        -- If we haven't decided on an axis to lock, decide now
        if not self.lockAxisX and not self.lockAxisY then
            local absDeltaX = math.abs(deltaX)
            local absDeltaY = math.abs(deltaY)
            -- Lock the axis we move the least in
            if absDeltaX > absDeltaY then
                self.lockAxisY = true
            elseif absDeltaY > absDeltaX then
                self.lockAxisX = true
            end
        end

        -- Eliminate our deltas based on our locked axis
        if self.lockAxisX then
            deltaX = 0
        elseif self.lockAxisY then
            deltaY = 0
        end
    end

    local newPos = Vector(currPos.x + deltaX, currPos.y + deltaY, 0)
    ele.Element:SetPosition(newPos)

    if self.snap then
        self:SnapToNearest(ele.Element)
    end

    ele.LastMouseX = mouseX
    ele.LastMouseY = mouseY
end

function GUICustomizeHUD:SnapToNearest(ele)
    local snapThreshold = 20 * self.scale

    local screenWidth = Client.GetScreenWidth()
    local screenHeight = Client.GetScreenHeight()
    local ourPos = ele:GetPosition()
    local ourScreenPos = ele:GetScreenPosition(screenWidth, screenHeight)
    local ourSize = ele:GetSize() * self.scale

    -- Try and snap to window edges
    if ourScreenPos.x < snapThreshold then
        ele:SetAnchor(GUIItem.Top, GUIItem.Left)
        ele:SetPosition(Vector(1, ourPos.y, 0))
        ourPos = ele:GetPosition()
        ourScreenPos = ele:GetScreenPosition(screenWidth, screenHeight)
    end

    if screenWidth - (ourScreenPos.x + ourSize.x) < snapThreshold then
        ele:SetAnchor(GUIItem.Top, GUIItem.Left)
        local newPos = ele.guiItem:GetParent():ScreenSpaceToLocalSpace(Vector(screenWidth - ourSize.x - 1, ourScreenPos.y, 0)) / self.scale
        ele:SetPosition(newPos)
        ourPos = ele:GetPosition()
        ourScreenPos = ele:GetScreenPosition(screenWidth, screenHeight)
    end

    if ourScreenPos.y < snapThreshold then
        ele:SetAnchor(GUIItem.Top, GUIItem.Left)
        ele:SetPosition(Vector(ourPos.x, 1, 0))
        ourPos = ele:GetPosition()
        ourScreenPos = ele:GetScreenPosition(screenWidth, screenHeight)
    end

    if screenHeight - (ourScreenPos.y + ourSize.y) < snapThreshold then
        ele:SetAnchor(GUIItem.Top, GUIItem.Left)
        local newPos = ele.guiItem:GetParent():ScreenSpaceToLocalSpace(Vector(ourScreenPos.x, screenHeight - ourSize.y - 1, 0)) / self.scale
        ele:SetPosition(newPos)
        ourPos = ele:GetPosition()
        ourScreenPos = ele:GetScreenPosition(screenWidth, screenHeight)
    end

    -- Try and snap to centre lines
    if math.abs(ourScreenPos.x - (screenWidth / 2)) < snapThreshold then
        ele:SetAnchor(GUIItem.Top, GUIItem.Left)
        local newPos = ele.guiItem:GetParent():ScreenSpaceToLocalSpace(Vector(screenWidth / 2, ourScreenPos.y, 0)) / self.scale
        ele:SetPosition(newPos)
        ourPos = ele:GetPosition()
        ourScreenPos = ele:GetScreenPosition(screenWidth, screenHeight)
    end

    if math.abs(ourScreenPos.x + ourSize.x - (screenWidth / 2)) < snapThreshold then
        ele:SetAnchor(GUIItem.Top, GUIItem.Left)
        local newPos = ele.guiItem:GetParent():ScreenSpaceToLocalSpace(Vector((screenWidth / 2) - ourSize.x, ourScreenPos.y, 0)) / self.scale
        ele:SetPosition(newPos)
        ourPos = ele:GetPosition()
        ourScreenPos = ele:GetScreenPosition(screenWidth, screenHeight)
    end

    if math.abs(ourScreenPos.y - (screenHeight / 2)) < snapThreshold then
        ele:SetAnchor(GUIItem.Top, GUIItem.Left)
        local newPos = ele.guiItem:GetParent():ScreenSpaceToLocalSpace(Vector(ourScreenPos.x, screenHeight / 2, 0)) / self.scale
        ele:SetPosition(newPos)
        ourPos = ele:GetPosition()
        ourScreenPos = ele:GetScreenPosition(screenWidth, screenHeight)
    end

    if math.abs(ourScreenPos.y + ourSize.y - (screenHeight / 2)) < snapThreshold then
        ele:SetAnchor(GUIItem.Top, GUIItem.Left)
        local newPos = ele.guiItem:GetParent():ScreenSpaceToLocalSpace(Vector(ourScreenPos.x, (screenHeight / 2) - ourSize.y, 0)) / self.scale
        ele:SetPosition(newPos)
        ourPos = ele:GetPosition()
        ourScreenPos = ele:GetScreenPosition(screenWidth, screenHeight)
    end

    -- Look for objects to snap to
    -- for i, target in ipairs(uiElementsToMove) do
    --     local targetPos = target:GetScreenPosition(screenWidth, screenHeight)
    --     local targetSize = target:GetSize() * self.scale
    -- end
end

function GUICustomizeHUD:Update(deltaTime)
    local mouseX, mouseY = Client.GetCursorPosScreen()
    local screenWidth = Client.GetScreenWidth()
    local screenHeight = Client.GetScreenHeight()
    local uiElementsToMove = self.hudScript:GetElementsToMove()

    -- Process clicks
    if self.mouseDown then
        if self.hoverElement and self.hoverElement.LastMouseX and self.hoverElement.LastMouseY then
            self:ProcessMove(mouseX, mouseY)
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
                self.hoverElement.LastMouseX, self.hoverElement.LastMouseY = Client.GetCursorPosScreen()
                self.lockAxisY = false
                self.lockAxisX = false
            else
                self.hoverElement.LastMouseX, self.hoverElement.LastMouseY = 0, 0
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

    -- Handle axis locking
    if key == InputKey.LeftShift or key == InputKey.RightShift then
        self.lockAxis = down
        self.lockAxisY = false
        self.lockAxisX = false
    end

    -- Handle snapping
    if key == InputKey.LeftAlt or key == InputKey.RightAlt then
        self.snap = down
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
