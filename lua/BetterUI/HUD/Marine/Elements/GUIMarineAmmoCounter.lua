Script.Load("lua/BetterUI/HUD/GUIPlayerHUDElement.lua")

class 'GUIMarineAmmoCounter' (GUIPlayerHUDElement)

GUIMarineAmmoCounter.kFontName = Fonts.kAgencyFB_Large_Bold
GUIMarineAmmoCounter.kAmmoColor = Color(163/255, 210/255, 220/255, 0.8)

function GUIMarineAmmoCounter:Initialize(parentScript, frame, params)
    GUIPlayerHUDElement.Initialize(self, parentScript, frame, params)

    self.ammoText = self.parentScript:CreateAnimatedTextItem()
    self.ammoText:SetAnchor(self.anchor.x, self.anchor.y)
    self.ammoText:SetTextAlignmentX(GUIItem.Align_Min)
    self.ammoText:SetTextAlignmentY(GUIItem.Align_Center)
    self.ammoText:SetColor(GUIMarineAmmoCounter.kAmmoColor)
    self.ammoText:SetFontName(GUIMarineAmmoCounter.kFontName)
    self.ammoText:SetIsVisible(true)

    self:Reset(self.parentScript.scale)
end

function GUIMarineAmmoCounter:Reset(scale)
    self.ammoText:SetPosition(self.position)
    self.ammoText:SetFontName(GUIMarineAmmoCounter.kFontName)
    self.ammoText:SetUniformScale(scale * self.elementScale)
    self.ammoText:SetScale(GetScaledVector() * self.elementScale)
    GUIMakeFontScale(self.ammoText)
end

local pulsateTime = 0
local function Pulsate(_, item)
	item:SetColor(Color(1, 0, 0, 0.35), pulsateTime, "CLASSIC_AMMO_PULSATE", AnimateLinear,
		function(_, this)
			this:SetColor(Color(1, 0, 0, 1), pulsateTime, "CLASSIC_AMMO_PULSATE", AnimateLinear, Pulsate)
        end
    )
end

function GUIMarineAmmoCounter:Update(deltaTime)
    local player = Client.GetLocalPlayer()
    local activeWeapon = player:GetActiveWeapon()
    self.ammoText:SetIsVisible(activeWeapon and true or false)
	
	if activeWeapon then
		local ammo = GetWeaponAmmoString(activeWeapon)
		local reserveAmmo = GetWeaponReserveAmmoString(activeWeapon)
		local fraction = GetWeaponAmmoFraction(activeWeapon)
		local reserveFraction = GetWeaponReserveAmmoFraction(activeWeapon)
		local isReloading = activeWeapon:isa("ClipWeapon") and activeWeapon:GetIsReloading()
		local reloadIndicator = isReloading and " (R)" or ""
		
        -- self.ammoText:SetIsVisible(fraction ~= -1)
        if fraction ~= -1 then
            if reserveFraction ~= -1 then
                self.ammoText:SetText(string.format("%s / %s", ammo, reserveAmmo .. reloadIndicator))
            else
                self.ammoText:SetText(string.format("%s", ammo))
            end
        else
            self.ammoText:SetText("0 / 0")
        end
		
		if fraction < 0.25 then
			pulsateTime = 0.25
		elseif fraction <= 0.4 then
			pulsateTime = 0.5
		end

		if reserveFraction ~= -1 then
            if not self.ammoText:GetIsAnimating() and fraction <= 0.4 and fraction > 0 then
				self.ammoText:FadeIn(0.05, "CLASSIC_AMMO_PULSATE", AnimateLinear, Pulsate)
            elseif fraction > 0.4 then
				self.ammoText:SetColor(GUIMarineAmmoCounter.kAmmoColor)
            elseif fraction == 0 then
				self.ammoText:SetColor(kRed)
			end
        else
			self.ammoText:SetColor(GUIMarineAmmoCounter.kAmmoColor)
		end
	end
end

function GUIMarineAmmoCounter:GetElementToMove()
    return self.ammoText
end

function GUIMarineAmmoCounter:GetClassName()
    return "GUIMarineAmmoCounter"
end
