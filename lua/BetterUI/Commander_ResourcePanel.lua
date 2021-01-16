function CommanderUI_GetTeamHarvesterCount()
    PROFILE("CommanderUI_GetTeamHarvesterCount")
    
    local player = Client.GetLocalPlayer()
    if player ~= nil then
        if PlayerUI_GetBetterUIEnabled() then
            return 3
        end
    
        local teamInfo = GetEntitiesForTeam("TeamInfo", player:GetTeamNumber())
        if table.icount(teamInfo) > 0 then
            return teamInfo[1]:GetNumResourceTowers()
        end
    end
    
    return 0 
end