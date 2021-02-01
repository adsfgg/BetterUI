local betterui_marineLines
function Client.BetterUI_SetMarineLines(value)
    betterui_marineLines = value
end

function Client.BetterUI_GetMarineLines()
    if betterui_marineLines == nil then
        betterui_marineLines = Client.GetOptionBoolean("betterui_marineLines", true)
    end
    
    return betterui_marineLines
end

local betterui_marinePoison
function Client.BetterUI_SetMarinePoison(value)
    betterui_marinePoison = value
end

function Client.BetterUI_GetMarinePoison()
    if betterui_marinePoison == nil then
        betterui_marinePoison = Client.GetOptionBoolean("betterui_marinePoison", true)
    end

    return betterui_marinePoison
end
