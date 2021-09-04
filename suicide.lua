local validWeapons = {
	-- Pistols
	'WEAPON_PISTOL',
	'WEAPON_COMBATPISTOL',
	'WEAPON_APPISTOL',
	'WEAPON_PISTOL50',
	'WEAPON_SNSPISTOL'
}

function KillYourself()
	Citizen.CreateThread(function()
		local playerPed = GetPlayerPed(-1)

		local canSuicide = false
		local foundWeapon = nil

		for i=1, #validWeapons do
			if HasPedGotWeapon(playerPed, GetHashKey(validWeapons[i]), false) then
				if GetAmmoInPedWeapon(playerPed, GetHashKey(validWeapons[i])) > 0 then
					canSuicide = true
					foundWeapon = GetHashKey(validWeapons[i])

					break
				end
			end
		end

		if canSuicide then
			if not HasAnimDictLoaded('mp_suicide') then
				RequestAnimDict('mp_suicide')
				
				while not HasAnimDictLoaded('mp_suicide') do
					Wait(2)
				end
			end

			SetCurrentPedWeapon(playerPed, foundWeapon, true)

			TaskPlayAnim(playerPed, "mp_suicide", "pistol", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )

			Wait(750)

			SetPedShootsAtCoord(playerPed, 0.0, 0.0, 0.0, 0)
			SetEntityHealth(playerPed, 0)
		end
	end)
end

RegisterCommand('suicide', function()
    Citizen.Wait(100)
	KillYourself()  
end, false)
