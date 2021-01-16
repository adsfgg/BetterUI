local betterUIEnabled = false
local kBetterUIPercentSpoof = 0.65

function PlayerUI_SetBetterUIEnabled()
    betterUIEnabled = true
end

function PlayerUI_SetBetterUIDisabled()
    betterUIEnabled = false
end

function PlayerUI_GetBetterUIEnabled()
    return betterUIEnabled
end

-- We want to spoof some values when BetterUI modification is enabled

function PlayerUI_GetPlayerHealth()
    local player = Client.GetLocalPlayer()
    if player then
        if betterUIEnabled then
            return player:GetMaxHealth() * kBetterUIPercentSpoof
        end

        local health = math.ceil(player:GetHealth())
        -- When alive, enforce at least 1 health for display.
        if player:GetIsAlive() then
            health = math.max(1, health)
        end
        return health
    end

    return 0
end

function PlayerUI_GetPlayerArmor()
    local player = Client.GetLocalPlayer()
    if player then
        return betterUIEnabled and player:GetArmor() * kBetterUIPercentSpoof or player:GetArmor()
    end

    return 0
end

function PlayerUI_GetPlayerParasiteState()
    local playerParasiteState = 1
    if PlayerUI_GetPlayerIsParasited() then
        playerParasiteState = 2
    end

    if betterUIEnabled then
        playerParasiteState = 2
    end

    return playerParasiteState
end

function PlayerUI_GetPlayerParasiteTimeRemaining()
    local player = Client.GetLocalPlayer()
    if player and HasMixin(player, "ParasiteAble") then
        if betterUIEnabled then
            return kBetterUIPercentSpoof
        end

        return player:GetParasitePercentageRemaining()
    end

    return false
end

function PlayerUI_GetPlayerNanoShieldState()
    local playerNanoshieldState = 1
    if PlayerUI_GetIsNanoShielded() then
        playerNanoshieldState = 2
    end

    if betterUIEnabled then
        playerNanoshieldState = 2
    end

    return playerNanoshieldState
end

function PlayerUI_GetNanoShieldTimeRemaining()
    local player = Client.GetLocalPlayer()
    if player and HasMixin(player, "NanoShieldAble") then
        if betterUIEnabled then
            return kBetterUIPercentSpoof
        end

        return player:GetNanoShieldTimeRemaining()
    end

    return false
end

function PlayerUI_GetPlayerCatPackState()
    local playerCatPackState = 1
    if PlayerUI_GetIsCatPacked() then
        playerCatPackState = 2
    end

    if betterUIEnabled then
        playerCatPackState = 2
    end

    return playerCatPackState
end

function PlayerUI_GetCatPackTimeRemaining()
    local player = Client.GetLocalPlayer()
    if player and HasMixin(player, "CatPack") then
        if betterUIEnabled then
            return kBetterUIPercentSpoof
        end

        return player:GetCatPackTimeRemaining()
    end

    return false
end

function PlayerUI_GetIsCorroded()
    local player = Client.GetLocalPlayer()
    if player and HasMixin(player, "Corrode") then
        if betterUIEnabled then
            return true
        end

        return player:GetIsCorroded()
    end

    return false
end

function PlayerUI_GetTeamResources()
    PROFILE("PlayerUI_GetTeamResources")

    local player = Client.GetLocalPlayer()
    if player then
        if betterUIEnabled then
            return 45
        end

        return player:GetDisplayTeamResources()
    end

    return 0
end

function PlayerUI_GetPlayerResources()
    if betterUIEnabled then
        return 15
    end

    if GetWarmupActive() then
        return 100
    end

    local player = Client.GetLocalPlayer()
    if player then
        return player:GetDisplayResources()
    end

    return 0
end
