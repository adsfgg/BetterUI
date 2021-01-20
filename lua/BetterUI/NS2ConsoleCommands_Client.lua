Event.Hook("Console_customhud", function() 
    local player = Client.GetLocalPlayer()
    if player and player.GetTeamNumber and (player:GetTeamNumber() == kTeam1Index or player:GetTeamNumber() == kTeam2Index) then
        GetGUIManager():CreateGUIScript("GUICustomizeHUD") 
    else
        print("BetterUI is not supported on this team")
    end
end)