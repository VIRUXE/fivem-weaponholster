local weaponData =
{ -- Thanks to https://github.com/itzhapp/ShowWeapon
    ['WEAPON_ADVANCEDRIFLE']      = {model = `w_ar_advancedrifle`,      onBack = true},
    ['WEAPON_ASSAULTRIFLE_MK2']   = {model = `w_ar_assaultrifle`,       onBack = true},
    ['WEAPON_ASSAULTRIFLE']       = {model = `w_ar_assaultrifle`,       onBack = true},
    ['WEAPON_ASSAULTSHOTGUN']     = {model = `w_sg_assaultshotgun`,     onBack = true},
    ['WEAPON_ASSAULTSMG']         = {model = `w_sb_assaultsmg`,         onBack = true},
    ['WEAPON_BULLPUPRIFLE_MK2']   = {model = `w_ar_bullpuprifle`,       onBack = true},
    ['WEAPON_BULLPUPRIFLE']       = {model = `w_ar_bullpuprifle`,       onBack = true},
    ['WEAPON_BULLPUPSHOTGUN']     = {model = `w_sg_bullpupshotgun`,     onBack = true},
    ['WEAPON_CARBINERIFLE_MK2']   = {model = `w_ar_carbinerifle`,       onBack = true},
    ['WEAPON_CARBINERIFLE']       = {model = `w_ar_specialcarbine`,     onBack = true},
    ['WEAPON_COMBATPDW']          = {model = `w_sb_smg`,                onBack = true},
    ['WEAPON_COMBATSHOTGUN']      = {model = `w_sg_pumpshotgun`,        onBack = true},
    ['WEAPON_COMPACTRIFLE']       = {model = `w_ar_assaultrifle`,       onBack = true},
    ['WEAPON_DBSHOTGUN']          = {model = `w_sg_sawnoff`,            onBack = true},
    ['WEAPON_FIREWORK']           = {model = `w_lr_firework`,           onBack = true},
    ['WEAPON_GUSENBERG']          = {model = `w_sb_gusenberg`,          onBack = true},
    ['WEAPON_HEAVYSHOTGUN']       = {model = `w_sg_heavyshotgun`,       onBack = true},
    ['WEAPON_HEAVYSNIPER_MK2']    = {model = `w_sr_heavysniper`,        onBack = true},
    ['WEAPON_HEAVYSNIPER']        = {model = `w_sr_heavysniper`,        onBack = true},
    ['WEAPON_MARKSMANRIFLE']      = {model = `w_sr_marksmanrifle`,      onBack = true},
    ['WEAPON_MARKSMANRIFLE_MK2']  = {model = `w_sr_marksmanriflemk2`,   onBack = true},
    ['WEAPON_MG']                 = {model = `w_mg_mg`,                 onBack = true},
    ['WEAPON_MILITARYRIFLE']      = {model = `w_sr_marksmanriflemk2`,   onBack = true},
    ['WEAPON_MUSKET']             = {model = `w_ar_musket`,             onBack = true},
    ['WEAPON_MICROSMG']           = {model = `w_sb_microsmg`,           onBack = true},
    ['WEAPON_PUMPSHOTGUN_MK2']    = {model = `w_sg_pumpshotgun`,        onBack = true},
    ['WEAPON_PUMPSHOTGUN']        = {model = `w_sg_pumpshotgun`,        onBack = true},
    ['WEAPON_SAWNOFFSHOTGUN']     = {model = `w_sg_sawnoff`,            onBack = true},
    ['WEAPON_SMG_MK2']            = {model = `w_sb_smg`,                onBack = true},
    ['WEAPON_SMG']                = {model = `w_sb_smg`,                onBack = true},
    ['WEAPON_SNIPERRIFLE']        = {model = `w_sr_sniperrifle`,        onBack = true},
    ['WEAPON_SPECIALCARBINE_MK2'] = {model = `w_ar_specialcarbine`,     onBack = true},
    ['WEAPON_SPECIALCARBINE']     = {model = `w_ar_specialcarbine`,     onBack = true},
    ['WEAPON_SWEEPERSHOTGUN']     = {model = `w_sg_sweeper`,            onBack = true},
}

local weaponHolstered = {name = nil, object = nil}
local weaponEquipped = {name = nil, object = nil}

AddEventHandler('playerDropped', function()
    --Haven't tested this, if it doesn't work might need to handle it on the server side with a netID
    DeleteObject(weaponholstered.object)
end)

AddEventHandler('ox_inventory:currentWeapon',function(currentWeapon)
    local playerPed = PlayerPedId()
    if not currentWeapon then 
        if weaponEquipped and weaponEquipped.name then 
            if weaponData[weaponEquipped and weaponEquipped.name] and weaponData[weaponEquipped.name].onBack == true then
                if weaponHolstered.object then DeleteObject(weaponHolstered.object) end
                    while not HasModelLoaded(weaponData[weaponEquipped.name].model) do
                        RequestModel(weaponData[weaponEquipped.name].model)
                        Wait(0)
                    end

                    weaponHolstered.name = weaponEquipped.name
                    weaponHolstered.object = CreateObject(weaponData[weaponEquipped.name].model, 0, 0, 0, true, true, true)

                    SetModelAsNoLongerNeeded(weaponData[weaponEquipped.name].model)
                    AttachEntityToEntity(weaponHolstered.object, playerPed, GetPedBoneIndex(playerPed, 24816), weaponData[weaponEquipped.name].onBack and 0.3 or 0.2, weaponData[weaponEquipped.name].onBack and -0.15 or 0.20, weaponData[weaponEquipped.name].onBack and 0.05 or -0.1, weaponData[weaponEquipped.name].onBack and 0.0 or 180.0, weaponData[weaponEquipped.name].onBack and 0.0 or 220.0, 0.0, true, true, false, false, 1, true)
                end
            end
        end
    elseif currentWeapon and currentWeapon.name == weaponHolstered.name then
	--Taking holstered weapon off back to use it
        weaponEquipped.name = currentWeapon.name
        DeleteObject(weaponHolstered.object)
        weaponHolstered.name = nil
        weaponHolstered.object = nil
    elseif weaponData[currentWeapon.name] and weaponData[currentWeapon.name].onBack == true then 
	--Leaves room for people to build additional logic for onback weapons like requiring them to be taken from a vehicle 
        weaponEquipped.name = currentWeapon.name
    else
	--Catch all for weapons not defined in the weaponData list. Just allow them to be equipped
        weaponEquipped.name = currentWeapon.name
    end
end)
