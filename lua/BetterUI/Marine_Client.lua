local oldGetHasArmsLab = MarineUI_GetHasArmsLab
function MarineUI_GetHasArmsLab()
    if PlayerUI_GetBetterUIEnabled() then
        return true
    end

    return oldGetHasArmsLab()
end
