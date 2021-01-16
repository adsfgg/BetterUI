local oldGetPlayerMucousShieldState = PlayerUI_GetPlayerMucousShieldState
function PlayerUI_GetPlayerMucousShieldState()
    if PlayerUI_GetBetterUIEnabled() then
        return 2
    end

    return oldGetPlayerMucousShieldState()
end

local oldGetMucousShieldTimeRemaining = PlayerUI_GetMucousShieldTimeRemaining
function PlayerUI_GetMucousShieldTimeRemaining()
    if PlayerUI_GetBetterUIEnabled() then
        return PlayerUI_GetBetterUISpoofPercentage()
    end

    return oldGetMucousShieldTimeRemaining()
end

local oldGetIsOnFire = PlayerUI_GetIsOnFire
function PlayerUI_GetIsOnFire()
    if PlayerUI_GetBetterUIEnabled() then
        return true
    end

    return oldGetIsOnFire()
end

local oldGetIsElectrified = PlayerUI_GetIsElectrified
function PlayerUI_GetIsElectrified()
    if PlayerUI_GetBetterUIEnabled() then
        return true
    end

    return oldGetIsElectrified()
end

local oldGetIsWallWalking = PlayerUI_GetIsWallWalking
function PlayerUI_GetIsWallWalking()
    if PlayerUI_GetBetterUIEnabled() then
        return true
    end

    return oldGetIsWallWalking()
end

local oldGetPlayerEnergy = PlayerUI_GetPlayerEnergy
function PlayerUI_GetPlayerEnergy()
    if PlayerUI_GetBetterUIEnabled() then
        return PlayerUI_GetBetterUISpoofPercentage()
    end

    return oldGetPlayerEnergy()
end

local oldGetMucousShieldHP = PlayerUI_GetMucousShieldHP
function PlayerUI_GetMucousShieldHP()
    if betterUIEnabled then
        return 7, 10
    end

    return oldGetMucousShieldHP()
end

local oldGetHasMucousShield = PlayerUI_GetHasMucousShield
function PlayerUI_GetHasMucousShield()
    if betterUIEnabled then
        return true
    end

    return oldGetHasMucousShield()
end
