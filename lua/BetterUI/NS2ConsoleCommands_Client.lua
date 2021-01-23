Event.Hook("Console_customhud", function()
    if PlayerUI_GetBetterUIEnabled() then
        print("HUD already being customized")
    end

    local player = Client.GetLocalPlayer()
    if player and player.GetTeamNumber and (player:GetTeamNumber() == kTeam1Index or player:GetTeamNumber() == kTeam2Index) then
        print("Attempting to customize hud")
        GetGUIManager():CreateGUIScript("GUICustomizeHUD") 
    else
        print("BetterUI is not supported on this team")
    end
end)