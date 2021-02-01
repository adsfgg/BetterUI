Event.Hook("Console_customhud", function()
    if PlayerUI_GetBetterUIEnabled() then
        print("HUD already being customized")
    end

    if PlayerUI_GetCanTeamCustomiseHud() then
        print("Attempting to customize hud")
        GetGUIManager():CreateGUIScript("GUICustomizeHUD") 
    else
        print("BetterUI is not supported on this team")
    end
end)