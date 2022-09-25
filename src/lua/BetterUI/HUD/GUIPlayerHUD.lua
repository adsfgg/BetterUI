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

    for _,element in ipairs(self.hudElements) do
        element:Uninitialize()
    end
end

function GUIPlayerHUD:Reset()
    self:UpdateBackgroundScale()
    
    for _,element in ipairs(self.hudElements) do
        element:Reset(self.scale)
    end
end

function GUIPlayerHUD:Update(deltaTime)
    GUIAnimatedScript.Update(self, deltaTime)
    
    for _,element in ipairs(self.hudElements) do
        element:Update(deltaTime)
    end
end

function GUIPlayerHUD:GetElements()
    return self.hudElements
end

function GUIPlayerHUD:GetElementsToMove()
    local toMove = { }

    for _,v in ipairs(self.hudElements) do
        table.insert(toMove, v:GetElementToMove())
    end

    return toMove
end

function GUIPlayerHUD:AddElement(element)
    assert(element)
    table.insert(self.hudElements, element)

    return #self.hudElements
end

function GUIPlayerHUD:GetElement(idx)
    return self.hudElements[idx]
end

function GUIPlayerHUD:GetNextIdx()
    return #self.hudElements + 1
end

function GUIPlayerHUD:RemoveElement(idx)
    local ele = self:GetElement(idx)
    assert(ele, string.format("Cannot remove element with idx %s; element does not exist", idx))
    ele:Uninitialize()
    table.remove(self.hudElements, idx)
end

function GUIPlayerHUD:ClearElements()
    for _,v in ipairs(self.hudElements) do
        v:Uninitialize()
    end

    self.hudElements = { }
end

function GUIPlayerHUD:LoadHUD()
    local fileLoc = self:GetConfigFileLocation()
    if GetFileExists(fileLoc) then
        local configFile = io.open(fileLoc, "r")
        if configFile then
            local fileData = json.decode(configFile:read("*all"))
            io.close(configFile)

            for _,data in ipairs(fileData) do
                self:CreateElementFromConfig(data.Class, data.Params)
            end
        end
    else
        self:LoadDefaultHUD()
        self:SaveHUD()
    end

    self:Reset()
end

function GUIPlayerHUD:LoadDefaultHUD()
    self:ClearElements()
    for _,v in ipairs(self.defaultElements) do
        self:CreateElementFromConfig(v.Class, v.Params)
    end
end

function GUIPlayerHUD:CreateElementFromConfig(class, params)
    local ele = _G[class]() -- uuhhhhhhhhh
    ele:Initialize(self, self.background, params)
    self:AddElement(ele)
end

function GUIPlayerHUD:ResetToDefault()
    self:LoadDefaultHUD()
    self:SaveHUD()
    self:Reset()
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

function GUIPlayerHUD:SaveHUD()
    local jsonData = { }

    for _,v in ipairs(self.hudElements) do
        table.insert(jsonData, v:ToJson())
    end

    -- Save the json struct
    local configFile = io.open(self:GetConfigFileLocation(), "w+")
    if configFile then
        configFile:write(json.encode(jsonData, { indent = true }))
        io.close(configFile)
    else
        print("Warn: BetterUI failed to open config file for writing!")
    end
end

function GUIPlayerHUD:GetConfigFileLocation()
    assert(false)
end

function SafePlayerHUDRefreshVisibility()
    local hudScript = PlayerUI_GetHudScript()
    if hudScript then
        hudScript:UpdateVisibility()
    end
end

function SafePlayerHUDSaveHUD()
    local hudScript = PlayerUI_GetHudScript()
    if hudScript then
        hudScript:SaveHUD()
    end
end
