class 'GUIPlayerHUDElement'

-- local anchorToGUIItem = {
--     ["Top"] = GUIItem.Top,
--     ["Center"] = GUIItem.Center,
--     ["Bottom"] = GUIItem.Bottom,
--     ["Left"] = GUIItem.Left,
--     ["Middle"] = GUIItem.Middle,
--     ["Right"] = GUIItem.Right,
-- }

-- local guiItemToAnchor = {
--     [GUIItem.Top] = "Top",
--     [GUIItem.Center] = "Center",
--     [GUIItem.Bottom] = "Bottom",
--     [GUIItem.Left] = "Left",
--     [GUIItem.Middle] = "Middle",
--     [GUIItem.Right] = "Right",
-- }

local function CreatePositionVector(tbl)
    if tbl then
        return Vector(tbl.x, tbl.y, 0)
    end

    return Vector(0, 0, 0)
end

local function CreateAnchorTable(tbl)
    if tbl then
        return {
            x = tbl.x,
            y = tbl.y
        }
    end

    return { x = GUIItem.Top, y = GUIItem.Left }
end

function GUIPlayerHUDElement:Initialize(parentScript, frame, params)
    self.parentScript = parentScript
    self.frame = frame

    -- parse generic params
    self.position = CreatePositionVector(params.Position)
    self.anchor = CreateAnchorTable(params.Anchor)
    self.elementScale = params.Scale or 1
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

function GUIPlayerHUDElement:GetElementToMove()
    assert(false)
end

function GUIPlayerHUDElement:ToJson()
    local element = self:GetElementToMove()
    local pos = element:GetPosition()
    return {
        Class = self:GetClassName(),
        Params = {
            Position = {
                x = pos.x,
                y = pos.y,
            },
            Anchor = self.anchor,
            Scale = self.elementScale
        }
    }
end

function GUIPlayerHUDElement:GetClassName()
    assert(false)
end

function AnimFadeIn(scriptHandle, itemHandle)
    itemHandle:FadeIn(1, nil, AnimateLinear, AnimFadeOut)
end

function AnimFadeOut(scriptHandle, itemHandle)
    itemHandle:FadeOut(1, nil, AnimateLinear, AnimFadeIn)
end
