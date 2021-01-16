local function OnConsoleCustomHud()
    local screen = GetGUIManager():CreateGUIScript("GUIMenuCustomizeHudScreen")
end

Event.Hook("Console_customhud", OnConsoleCustomHud)