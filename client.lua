local weapons =
{ -- Thanks to https://github.com/itzhapp/ShowWeapon
	['WEAPON_ADVANCEDRIFLE']      = {model = `w_ar_advancedrifle`,  onBack = true},
	['WEAPON_ASSAULTRIFLE_MK2']   = {model = `w_ar_assaultrifle`,   onBack = true},
	['WEAPON_ASSAULTRIFLE']       = {model = `w_ar_assaultrifle`,   onBack = false},
	['WEAPON_ASSAULTSHOTGUN']     = {model = `w_sg_assaultshotgun`, onBack = true},
	['WEAPON_ASSAULTSMG']         = {model = `w_sb_assaultsmg`,     onBack = true},
	['WEAPON_BULLPUPRIFLE_MK2']   = {model = `w_ar_bullpuprifle`,   onBack = true},
	['WEAPON_BULLPUPRIFLE']       = {model = `w_ar_bullpuprifle`,   onBack = true},
	['WEAPON_BULLPUPSHOTGUN']     = {model = `w_sg_bullpupshotgun`, onBack = true},
	['WEAPON_CARBINERIFLE_MK2']   = {model = `w_ar_carbinerifle`,   onBack = true},
	['WEAPON_CARBINERIFLE']       = {model = `w_ar_specialcarbine`, onBack = true},
	['WEAPON_COMBATPDW']          = {model = `w_sb_smg`,            onBack = true},
	['WEAPON_COMBATSHOTGUN']      = {model = `w_sg_pumpshotgun`,    onBack = true},
	['WEAPON_COMPACTRIFLE']       = {model = `w_ar_assaultrifle`,   onBack = true},
	['WEAPON_DBSHOTGUN']          = {model = `w_sg_sawnoff`,        onBack = true},
	['WEAPON_GUSENBERG']          = {model = `w_sb_gusenberg`,      onBack = true},
	['WEAPON_HEAVYSHOTGUN']       = {model = `w_sg_heavyshotgun`,   onBack = true},
	['WEAPON_HEAVYSNIPER_MK2']    = {model = `w_sr_heavysniper`,    onBack = true},
	['WEAPON_HEAVYSNIPER']        = {model = `w_sr_heavysniper`,    onBack = true},
	['WEAPON_MARKSMANRIFLE']      = {model = `w_sr_marksmanrifle`,  onBack = true},
	['WEAPON_MICROSMG']           = {model = `w_sb_microsmg`,       onBack = true},
	['WEAPON_PUMPSHOTGUN_MK2']    = {model = `w_sg_pumpshotgun`,    onBack = true},
	['WEAPON_PUMPSHOTGUN']        = {model = `w_sg_pumpshotgun`,    onBack = true},
	['WEAPON_SAWNOFFSHOTGUN']     = {model = `w_sg_sawnoff`,        onBack = true},
	['WEAPON_SMG_MK2']            = {model = `w_sb_smg`,            onBack = true},
	['WEAPON_SMG']                = {model = `w_sb_smg`,            onBack = true},
	['WEAPON_SNIPERRIFLE']        = {model = `w_sr_sniperrifle`,    onBack = true},
	['WEAPON_SPECIALCARBINE_MK2'] = {model = `w_ar_specialcarbine`, onBack = true},
	['WEAPON_SPECIALCARBINE']     = {model = `w_ar_specialcarbine`, onBack = true},
}

local weaponHolstered = {name = nil, object = nil}

CreateThread(function()
	while true do
		local playerPed = PlayerPedId()

		-- Player shouldn't be shuffling weapons if dead so just don't do anything
		if IsEntityDead(playerPed) or not ESX.IsPlayerLoaded() then goto continue end

		-- Nothing holstered so let's search our inventory for weapons
		if not weaponHolstered.object then
			-- Only check the inventory if we're not inside a vehicle or already armed
			if not IsPedInAnyVehicle(playerPed, false) and not IsPedArmed(playerPed, 4) then
				-- Loop trough all weapons to see if we have any in the inventory
				for weapon, weaponData in pairs(weapons) do
					-- We found a weapon so let's holster it correctly and not search for something else
					if exports.ox_inventory:Search('count', weapon) > 0 then
						-- Let's load the model first because we are nice like that
						while not HasModelLoaded(weaponData.model) do
							RequestModel(weaponData.model)
							Citizen.Wait(0)
						end

						weaponHolstered.name = weapon
						weaponHolstered.object = CreateObject(weaponData.model, 0, 0, 0, true, true, true)

						SetModelAsNoLongerNeeded(weaponData.model)

						AttachEntityToEntity(weaponHolstered.object, playerPed, GetPedBoneIndex(playerPed, 24816), weaponData.onBack and 0.3 or 0.2, weaponData.onBack and -0.15 or 0.20, weaponData.onBack and 0.05 or -0.1, weaponData.onBack and 0.0 or 180.0, weaponData.onBack and 0.0 or 220.0, 0.0, true, true, false, false, 1, true)
						break
					end
				end
			end
		else
			-- A weapon is holstered so delete the object of it's no longer in the inventory, we are using it or in a vehicle
			if exports.ox_inventory:Search('count', weaponHolstered.name) == 0 or IsPedArmed(playerPed, 4) or IsPedInAnyVehicle(playerPed, false) then
				DeleteObject(weaponHolstered.object)
				weaponHolstered.name = nil
				weaponHolstered.object = nil
			end
		end

		::continue::
		Wait(1000)
	end
end)