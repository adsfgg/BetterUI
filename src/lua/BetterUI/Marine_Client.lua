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


function Marine:UpdateClientEffects(deltaTime, isLocal)
    
    Player.UpdateClientEffects(self, deltaTime, isLocal)
    
    if isLocal then
    
        Client.SetMouseSensitivityScalar(ConditionalValue(self:GetIsStunned(), 0, 1))
        
        self:UpdateGhostModel()
        
        UpdatePoisonedEffect(self)
        
        if self.lastAliveClient ~= self:GetIsAlive() then
            ClientUI.SetScriptVisibility("Hud/Marine/GUIMarineHUD", "Alive", self:GetIsAlive())
            self.lastAliveClient = self:GetIsAlive()
        end
        
        if self.buyMenu then
        
            if not self:GetIsAlive() or not GetIsCloseToMenuStructure(self) or self:GetIsStunned() then
                self:CloseMenu()
            end
            
        end    
        
        if Player.screenEffects.disorient then
            Player.screenEffects.disorient:SetParameter("time", Client.GetTime())
        end
        
        local stunned = HasMixin(self, "Stun") and self:GetIsStunned()
        local blurEnabled = self.buyMenu ~= nil or stunned or (self.viewingHelpScreen == true) or (self.customizingHud == true)
        self:SetBlurEnabled(blurEnabled)
        
        -- update spit hit effect
        if not Shared.GetIsRunningPrediction() then
        
            if self.timeLastSpitHit ~= self.timeLastSpitHitEffect then
            
                local viewAngle = self:GetViewAngles()
                local angleDirection = Angles(GetPitchFromVector(self.lastSpitDirection), GetYawFromVector(self.lastSpitDirection), 0)
                angleDirection.yaw = GetAnglesDifference(viewAngle.yaw, angleDirection.yaw)
                angleDirection.pitch = GetAnglesDifference(viewAngle.pitch, angleDirection.pitch)
                
                TriggerSpitHitEffect(angleDirection:GetCoords())
                
                local intensity = self.lastSpitDirection:DotProduct(self:GetViewCoords().zAxis)
                self.spitEffectIntensity = intensity
                self.timeLastSpitHitEffect = self.timeLastSpitHit
                
            end
            
        end
        
        local spitHitDuration = Shared.GetTime() - self.timeLastSpitHitEffect
        
        if Player.screenEffects.disorient and self.timeLastSpitHitEffect ~= 0 and spitHitDuration <= Marine.kSpitHitEffectDuration then
        
            Player.screenEffects.disorient:SetActive(true)
            local amount = (1 - ( spitHitDuration/Marine.kSpitHitEffectDuration) ) * 3.5 * self.spitEffectIntensity
            Player.screenEffects.disorient:SetParameter("amount", amount)
            
        end
        
    end
    
    if self._renderModel then

        if self.ruptured and not self.ruptureMaterial then

            local material = Client.CreateRenderMaterial()
            material:SetMaterial(kRuptureMaterial)

            local viewMaterial = Client.CreateRenderMaterial()
            viewMaterial:SetMaterial(kRuptureMaterial)
            
            self.ruptureEntities = {}
            self.ruptureMaterial = material
            self.ruptureMaterialViewMaterial = viewMaterial
            AddMaterialEffect(self, material, viewMaterial, self.ruptureEntities)
        
        elseif not self.ruptured and self.ruptureMaterial then

            RemoveMaterialEffect(self.ruptureEntities, self.ruptureMaterial, self.ruptureMaterialViewMaterial)
            Client.DestroyRenderMaterial(self.ruptureMaterial)
            Client.DestroyRenderMaterial(self.ruptureMaterialViewMaterial)
            self.ruptureMaterial = nil
            self.ruptureMaterialViewMaterial = nil
            self.ruptureEntities = nil
            
        end
        
    end
    
    
end
