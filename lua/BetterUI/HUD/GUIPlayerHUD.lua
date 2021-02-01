Script.Load("lua/GUIAnimatedScript.lua")

class 'GUIPlayerHUD' (GUIAnimatedScript)

function GUIPlayerHUD:Initialize()
    GUIAnimatedScript.Initialize(self)

    -- Not sure what i want to do with this yet...
    self.cachedHudDetail = Client.GetHudDetail()
    
    self.hudElements = { }
    self.defaultElements = { }

    -- Initialize background
    self:CreateBackground()
end

function GUIPlayerHUD:Uninitialize()
    GUIAnimatedScript.Uninitialize(self)

    for name, element in pairs(self.hudElements) do
        element.Element:Uninitialize()
    end
end

function GUIPlayerHUD:Reset()
    self:UpdateBackgroundScale()
    
    for name, element in pairs(self.hudElements) do
        element.Element:Reset(self.scale)
    end
end

function GUIPlayerHUD:Update(deltaTime)
    for name, element in pairs(self.hudElements) do
        element.Element:Update(deltaTime)
    end

    GUIAnimatedScript.Update(self, deltaTime)
end

function GUIPlayerHUD:GetElements()
    return self.hudElements
end

function GUIPlayerHUD:GetElementsToMove()
    local toMove = { }

    for _, v in pairs(self.hudElements) do
        table.insert(toMove, {
            Name = v.Name,
            Element = v.Element:GetElementToMove()
        })
    end

    return toMove
end

function GUIPlayerHUD:AddElement(name, element)
    assert(not self.hudElements[name], string.format("Element with name %s already exists!", name))
    assert(element)

    self.hudElements[name] = {
        Name = name, 
        Element = element,
    }
end

function GUIPlayerHUD:GetElement(name)
    return self.hudElements[name]
end

function GUIPlayerHUD:RemoveElement(name)
    assert(self.hudElements[name], string.format("Cannot remove element with name %s; element does not exist", name))
    -- self.hudElements[name].Element:SetIsVisible(false)
    self.hudElements[name].Element:Uninitialize()
    self.hudElements[name] = nil
    -- self:Reset()
end

function GUIPlayerHUD:ClearElements()
    self.hudElements = {}
end

function GUIPlayerHUD:LoadHUD()
    -- Load the default one for now :)
    self:LoadDefaultHUD()
    self:Reset()
end

function GUIPlayerHUD:LoadDefaultHUD()
    self:ClearElements()
    for _,v in ipairs(self.defaultElements) do
        local ele = v.Class()
        ele:Initialize(self, self.background, v.Pos, v.Anchor)
        self:AddElement(v.Name, ele)
    end
end

function GUIPlayerHUD:ResetToDefault()
    self:Uninitialize()
    self:Initialize()
end

function GUIPlayerHUD:CreateBackground()
    self.background = self:CreateAnimatedGraphicItem()
    self.background:SetPosition( Vector( 0, 0, 0 ) )
    self.background:SetIsScaling(false)
    self.background:SetIsVisible(true)
    self.background:SetLayer(kGUILayerPlayerHUDBackground)
    self.background:SetColor( Color( 1, 1, 1, 0 ) )
end

function GUIPlayerHUD:UpdateBackgroundScale()
    self.background:SetSize( Vector( Client.GetScreenWidth(), Client.GetScreenHeight(), 0 ) )
end

function SafePlayerHUDRefreshVisibility()
    local hudScript = PlayerUI_GetHudScript()
    if hudScript then
        hudScript:UpdateVisibility()
    end
end

