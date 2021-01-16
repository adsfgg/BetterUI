Script.Load("lua/GUIAnimatedScript.lua")

class 'GUIMenuCustomizeHudScreen' (GUIAnimatedScript)

local guiScriptsToModify = {
    [kTeam1Index] = {
        "Hud/Marine/GUIMarineHUD"
    },

    [kTeam2Index] = {
        "GUIAlienHUD"
    },
}

local function CreateGUIScriptList()
    local player = Client.GetLocalPlayer()
    if player and player.GetTeamNumber then
        local teamNumber = player:GetTeamNumber()
        return guiScriptsToModify[teamNumber] or { }
    end

    return { }
end

function GUIMenuCustomizeHudScreen:Initialize()
    GUIAnimatedScript.Initialize(self)
    print("GUIMenuCustomizeHudScreen()")

    -- Create list of gui scripts that are allowed to be modified
    local fullGuiScriptList = CreateGUIScriptList()
    self.guiScripts = {}

    -- Enable better ui modification on the scripts
    for _,scriptName in ipairs(fullGuiScriptList) do
        local scriptObj = ClientUI.GetScript(scriptName)
        if scriptObj then
            if scriptObj.EnableBetterUIModification then
                scriptObj:EnableBetterUIModification()
                table.insert(self.guiScripts, scriptName)
            else
                print("WARNING: " .. scriptName .. " does not support BetterUI")
            end
        else
            print("WARNING: Failed to get script of name " .. scriptName)
        end
    end

    PlayerUI_SetBetterUIEnabled()

    MouseTracker_SetIsVisible(true, "ui/Cursor_MenuDefault.dds", true)
end

function GUIMenuCustomizeHudScreen:Uninitialize()
    GUIAnimatedScript.Uninitialize(self)
    print("~GUIMenuCustomizeHudScreen()")

    PlayerUI_SetBetterUIDisabled()

    MouseTracker_SetIsVisible(false)
end

function GUIMenuCustomizeHudScreen:SendKeyEvent(key, down)
    if key == InputKey.MouseButton0 and self.mousePressed ~= down then
        self.mousePressed = down
        
        
    end

    if key == InputKey.Escape and not down then
        GetGUIManager():DestroyGUIScript(self)
    end

    return true
end
