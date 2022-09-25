local betterUIEnabled = false
local betterUIPercentSpoof = 0.65
local teamAllowed = {
    [kTeam1Index] = true,
    [kTeam2Index] = true
}
local hudScripts = {
    [kTeam1Index] = "Hud/Marine/GUIMarineHUD",
    [kTeam2Index] = "GUIAlienHUD"
}

local betterUIInventory = {
    [kTeam1Index] = {
        { TechId = kTechId.Rifle, HUDSlot = 1 },
        { TechId = kTechId.Pistol, HUDSlot = 2 },
        { TechId = kTechId.Axe, HUDSlot = 3 },
        { TechId = kTechId.LayMines, HUDSlot = 4 },
        { TechId = kTechId.ClusterGrenade, HUDSlot = 5 }
    },
    [kTeam2Index] = {
        { TechId = kTechId.Spray, HUDSlot = 1 },
        { TechId = kTechId.BuildAbility, HUDSlot = 2 },
        { TechId = kTechId.BileBomb, HUDSlot = 3 },
        { TechId = kTechId.BabblerAbility, HUDSlot = 4 },
        nil
    }
}
local betterUIActiveWeapon = {
    [kTeam1Index] = kTechId.Rifle,
    [kTeam2Index] = kTechId.Bite
}

function PlayerUI_SetBetterUIEnabled()
    betterUIEnabled = true
end

function PlayerUI_SetBetterUIDisabled()
    betterUIEnabled = false
end

function PlayerUI_GetBetterUIEnabled()
    return betterUIEnabled
end

function PlayerUI_GetBetterUISpoofPercentage()
    return betterUIPercentSpoof
end

function PlayerUI_ResetHUDToDefault()
    PlayerUI_GetHudScript():ResetToDefault()
end

function PlayerUI_GetHudScript()
    local player = Client.GetLocalPlayer()
    if player and player.GetTeamNumber then
        return ClientUI.GetScript(hudScripts[player:GetTeamNumber()])
    end

    return nil
end

function PlayerUI_GetCanTeamCustomiseHud()
    local player = Client.GetLocalPlayer()
    if player and player.GetTeamNumber then
        return teamAllowed[player:GetTeamNumber()] or false
    end

    return false
end

-- We want to spoof some values when BetterUI modification is enabled

function PlayerUI_GetPlayerHealth()
    local player = Client.GetLocalPlayer()
    if player then
        if betterUIEnabled then
            return player:GetMaxHealth() * betterUIPercentSpoof
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
        return betterUIEnabled and player:GetArmor() * betterUIPercentSpoof or player:GetArmor()
    end

    return 0
end

local oldGetPlayerParasiteState = PlayerUI_GetPlayerParasiteState
function PlayerUI_GetPlayerParasiteState()
    if betterUIEnabled then
        return 2
    end

    return oldGetPlayerParasiteState()
end

local oldGetPlayerParasiteTimeRemaining = PlayerUI_GetPlayerParasiteTimeRemaining
function PlayerUI_GetPlayerParasiteTimeRemaining()
    if betterUIEnabled then
        return betterUIPercentSpoof
    end

    return oldGetPlayerParasiteTimeRemaining()
end

local oldGetPlayerNanoshieldState = PlayerUI_GetPlayerNanoShieldState
function PlayerUI_GetPlayerNanoShieldState()
    if betterUIEnabled then
        return 2
    end

    return oldGetPlayerNanoshieldState()
end

local oldGetNanoShieldTimeRemaining = PlayerUI_GetNanoShieldTimeRemaining
function PlayerUI_GetNanoShieldTimeRemaining()
    if betterUIEnabled then
        return betterUIPercentSpoof
    end

    return oldGetNanoShieldTimeRemaining()
end

local oldGetPlayerCatPackState = PlayerUI_GetPlayerCatPackState
function PlayerUI_GetPlayerCatPackState()
    if betterUIEnabled then
        return 2
    end

    return oldGetPlayerCatPackState()
end

local oldGetCatPackTimeRemaining = PlayerUI_GetCatPackTimeRemaining
function PlayerUI_GetCatPackTimeRemaining()
    if betterUIEnabled then
        return betterUIPercentSpoof
    end

    return oldGetCatPackTimeRemaining()
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

function PlayerUI_GetInventoryTechIds()
    PROFILE("PlayerUI_GetInventoryTechIds")

    local player = Client.GetLocalPlayer()
    if player and HasMixin(player, "WeaponOwner") then
        if betterUIEnabled then
            return betterUIInventory[player:GetTeamNumber()]
        end

        local inventoryTechIds = table.array(5)
        local weaponList = player:GetHUDOrderedWeaponList()

        for w = 1, #weaponList do
            local weapon = weaponList[w]
            table.insert(inventoryTechIds, { TechId = weapon:GetTechId(), HUDSlot = weapon:GetHUDSlot() })
        end

        return inventoryTechIds
    end
    return { }
end

function PlayerUI_GetActiveWeaponTechId()
    PROFILE("PlayerUI_GetActiveWeaponTechId")

    local player = Client.GetLocalPlayer()
    if player then
        if betterUIEnabled then
            return betterUIActiveWeapon[player:GetTeamNumber()]
        end

        local activeWeapon = player:GetActiveWeapon()
        if activeWeapon then
            return activeWeapon:GetTechId()
        end
    end
end

local oldGetCommanderName = PlayerUI_GetCommanderName
function PlayerUI_GetCommanderName()
    if betterUIEnabled then
        return "asdfg"
    end
    
    return oldGetCommanderName()
end

local oldGetArmorLevel = PlayerUI_GetArmorLevel
function PlayerUI_GetArmorLevel(researched)
    if betterUIEnabled then
        return 3
    end

    return oldGetArmorLevel(researched)
end

local oldGetWeaponLevel = PlayerUI_GetWeaponLevel
function PlayerUI_GetWeaponLevel(researched)
    if betterUIEnabled then
        return 3
    end

    return oldGetWeaponLevel(researched)
end

local oldGetIsNanoShielded = PlayerUI_GetIsNanoShielded
function PlayerUI_GetIsNanoShielded()
    if betterUIEnabled then
        return true
    end

    return oldGetIsNanoShielded()
end

local oldGetIsDetected = PlayerUI_GetIsDetected
function PlayerUI_GetIsDetected()
    if betterUIEnabled then
        return true
    end

    return oldGetIsDetected()
end

local oldGetIsEnzymed = PlayerUI_GetIsEnzymed
function PlayerUI_GetIsEnzymed()
    if betterUIEnabled then
        return true
    end

    return oldGetIsEnzymed()
end

local oldGetIsCloaked = PlayerUI_GetIsCloaked
function PlayerUI_GetIsCloaked()
    if betterUIEnabled then
        return true
    end

    return oldGetIsCloaked()
end

local oldGetHasUmbra = PlayerUI_GetHasUmbra
function PlayerUI_GetHasUmbra()
    if betterUIEnabled then
        return true
    end

    return oldGetHasUmbra()
end

local oldGetEnergizeLevel = PlayerUI_GetEnergizeLevel
function PlayerUI_GetEnergizeLevel()
    if betterUIEnabled then
        return true
    end

    return oldGetEnergizeLevel()
end

local oldWithinCragRange = PlayerUI_WithinCragRange
function PlayerUI_WithinCragRange()
    if betterUIEnabled then
        return true
    end

    return oldWithinCragRange()
end

local oldGetNumClingedBabblers = PlayerUI_GetNumClingedBabblers
function PlayerUI_GetNumClingedBabblers()
    if betterUIEnabled then
        return 3
    end

    return oldGetNumClingedBabblers()
end

local oldGetNumBabblers = PlayerUI_GetNumBabblers
function PlayerUI_GetNumBabblers()
    if betterUIEnabled then
        return 5
    end

    return oldGetNumBabblers()
end
