local oldGetHasArmsLab = MarineUI_GetHasArmsLab
function MarineUI_GetHasArmsLab()
    if PlayerUI_GetBetterUIEnabled() then
        return true
    end

    return oldGetHasArmsLab()
end

local function UpdatePoisonedEffect(self)
    local hudScript = ClientUI.GetScript("Hud/Marine/GUIMarineHUD")
    if self.poisoned and self:GetIsAlive() and hudScript and not hudScript:GetIsAnimatingPoisonEffect() then
        hudScript:TriggerPoisonEffect()
    end
end

debug.setupvaluex(Marine.UpdateClientEffects, "UpdatePoisonedEffect", UpdatePoisonedEffect)
