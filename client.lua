ESX = nil
local playerCoords, playerPed
local evidence = {}
local nearbyItems = {}
nearbyItems.bullet = {}
nearbyItems.casing = {}
nearbyItems.blood = {}
local weapon, itemCount
local synced = false

CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Wait(10)
	end
	ESX.PlayerData = ESX.GetPlayerData()

	ESX.TriggerServerCallback('linden_evidence:getEvidence', function(data)
		evidence = data
		synced = true
	end)
end)

RegisterNetEvent('linden_evidence:updateEvidence')
AddEventHandler('linden_evidence:updateEvidence', function(data)
	evidence = data
	synced = true
end)

function Draw3DText(x, y, z, text)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
	if onScreen then
		SetTextScale(0.35, 0.35)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextDropShadow(0, 0, 0, 55)
		SetTextEdge(0, 0, 0, 150)
		SetTextDropShadow()
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x,_y)
	end
end

local lastTriggered = GetGameTimer()
AddEventHandler('gameEventTriggered', function (name, args)
	if name == 'CEventNetworkEntityDamage' then
		local timer = GetGameTimer()
		if timer - lastTriggered > 500 then
			local victim = args[1]
			local attacker = args[2]
			local isFatal = args[4]
			local weaponHash = args[5]
			local isMelee = args[10]

			if not playerPed then playerPed = PlayerPedId() end
			if victim == playerPed then
				coords = GetEntityCoords(playerPed)
				local ground, impactZ
				repeat
					ground, impactZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z, 1)
				until ground
				coords = vector3(coords.x, coords.y, (impactZ + 1.0))
				TriggerServerEvent('linden_evidence:addEvidence', false, false, false, coords)
				lastTriggered = GetGameTimer()
			end
		end
	end
end)

RegisterNetEvent('ox_inventory:currentWeapon')
AddEventHandler('ox_inventory:currentWeapon', function(item)
	weapon = item
end)

CreateThread(function()
	local shoothread = 250
	while true do
		playerPed = PlayerPedId()
		if IsPlayerFreeAiming(PlayerId()) then
			shoothread = 0
			if IsPedShooting(playerPed) and synced and not (weapon.name == 'WEAPON_STUNGUN') then
				local source, bullet, casing = {}, {}, {}, {}
				local hitEntity, entity = GetEntityPlayerIsFreeAimingAt(PlayerId())
				local impacted, impactCoords = GetPedLastWeaponImpactCoord(playerPed)
				if impacted then
					local curWeapon = GetSelectedPedWeapon(playerPed)
					source = PlayerPedId()
					coords = GetEntityCoords(source)
					impactCoords = vector3(impactCoords.x, impactCoords.y, (impactCoords.z + 0.5))
					coords = vector3(coords.x, coords.y, (coords.z + 0.5))

					local ground, impactZ
					repeat
						ground, impactZ = GetGroundZFor_3dCoord(impactCoords.x, impactCoords.y, impactCoords.z, 1)
					until ground
					impactCoords = vector3(impactCoords.x, impactCoords.y, (impactZ + 0.5))

					local ground, coordZ
					repeat
						ground, coordZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z, 1)
					until ground
					casingCoords = vector3(coords.x, coords.y, (coordZ + 0.9))

					bullet.coords = impactCoords
					casing.coords = casingCoords
					weapondata = weapon
					TriggerServerEvent('linden_evidence:addEvidence', weapondata, bullet, casing)
				end
			end
		end
		Wait(shoothread)
	end
end)

CreateThread(function()
	if IsPedArmed(PlayerPedId(), 7) then
		SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'), true)
	end
	while true do
		canCollect = false		
		playerCoords = GetEntityCoords(PlayerPedId())
		if GetSelectedPedWeapon(PlayerPedId()) == `WEAPON_FLASHLIGHT` and IsPlayerFreeAiming(PlayerId()) then
			if nearbyItems ~= nil and synced then
				for k, v in pairs(evidence.bullet) do
					local distance = #(playerCoords - v.coords)
					if distance < 2.0 then
						local items = {
							['WEAPON_ASSAULTSHOTGUN']='Shotgun Pellets',
							['WEAPON_AUTOSHOTGUN']='Shotgun Pellets',
							['WEAPON_BULLPUPSHOTGUN']='Shotgun Pellets',
							['WEAPON_DBSHOTGUN']='Shotgun Pellets',
							['WEAPON_SAWNOFFSHOTGUN']='Shotgun Pellets',
							['WEAPON_PUMPSHOTGUN']='Shotgun Pellets',
							['WEAPON_PUMPSHOTGUN_MK2']='Shotgun Pellets',
							['WEAPON_HEAVYSHOTGUN']='Shotgun Pellets',
							['WEAPON_PISTOL']='9mm bullet',
							['WEAPON_COMBATPISTOL']='.45 bullet',
							['WEAPON_APPISTOL']='.45 bullet',
							['WEAPON_PISTOL50']='.50 bullet',
							['WEAPON_PISTOL_MK2']='.45 bullet',
							['WEAPON_REVOLVER_MK2']='.44 bullet',
							['WEAPON_SNSPISTOL']='.45 bullet',
							['WEAPON_SNSPISTOL_MK2']='.45 bullet',
							['WEAPON_HEAVYPISTOL']='.45 bullet',
							['WEAPON_MARKSMANPISTOL']='.22 bullet',
							['WEAPON_REVOLVER']='.38 bullet',
							['WEAPON_VINTAGEPISTOL']='9mm bullet',
							['WEAPON_MACHINEPISTOL']='9mm bullet',
							['WEAPON_MINISMG']='9mm bullet',
							['WEAPON_MICROSMG']='9mm bullet',
							['WEAPON_COMBATPDW']='9mm bullet',
							['WEAPON_SMG']='9mm bullet',
							['WEAPON_SMG_MK2']='9mm bullet',
							['WEAPON_ASSAULTSMG']='9mm bullet',
							['WEAPON_ASSAULTRIFLE']='7.62 bullet',
							['WEAPON_ASSAULTRIFLE_MK2']='7.62 bullet',
							['WEAPON_CARBINERIFLE']='5.56 bullet',
							['WEAPON_CARBINERIFLE_MK2']='5.56 bullet',
							['WEAPON_COMPACTRIFLE']='7.62 bullet',
							['WEAPON_COMBATRIFLE']='5.56 bullet',
							['WEAPON_ADVANCEDRIFLE']='7.62 bullet',
							['WEAPON_SPECIALCARBINE']='7.62 bullet',
							['WEAPON_SPECIALCARBINE_MK2']='7.62 bullet',
							['WEAPON_TACTICALRIFLE']='7.62 bullet',
							['WEAPON_BULLPUPRIFLE']='5.56 bullet',
							['WEAPON_BULLPUPRIFLE_MK2']='5.56 bullet',
						}
						local item = items[v.weapon.name]
						local mCoords = "Found near" .. GetStreetNameFromHashKey(GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z))
						if not item then item = 'Bullet' end
						Draw3DText(v.coords.x, v.coords.y, v.coords.z, item)
						if distance < 1.0 then
							nearbyItems.bullet[k] = v
							canCollect = true
						elseif nearbyItems.bullet[k] then nearbyItems.bullet[k] = nil end
					elseif nearbyItems.bullet[k] then nearbyItems.bullet[k] = nil end
				end
				
				for k, v in pairs(evidence.casing) do
					local distance = #(playerCoords - v.coords)
					if distance < 2.0 then
						local items = {
							['WEAPON_ASSAULTSHOTGUN']='Shotgun Shell',
							['WEAPON_AUTOSHOTGUN']='Shotgun Shell',
							['WEAPON_BULLPUPSHOTGUN']='Shotgun Shell',
							['WEAPON_DBSHOTGUN']='Shotgun Shell',
							['WEAPON_SAWNOFFSHOTGUN']='Shotgun Shell',
							['WEAPON_PUMPSHOTGUN']='Shotgun Shell',
							['WEAPON_PUMPSHOTGUN_MK2']='Shotgun Shell',
							['WEAPON_HEAVYSHOTGUN']='Shotgun Shell',
							['WEAPON_PISTOL']='9mm casing',
							['WEAPON_COMBATPISTOL']='.45 casing',
							['WEAPON_APPISTOL']='.45 casing',
							['WEAPON_PISTOL50']='.50 casing',
							['WEAPON_PISTOL_MK2']='.45 casing',
							['WEAPON_REVOLVER_MK2']='.44 casing',
							['WEAPON_SNSPISTOL']='.45 casing',
							['WEAPON_SNSPISTOL_MK2']='.45 casing',
							['WEAPON_HEAVYPISTOL']='.45 casing',
							['WEAPON_MARKSMANPISTOL']='.22 casing',
							['WEAPON_REVOLVER']='.38 casing',
							['WEAPON_VINTAGEPISTOL']='9mm casing',
							['WEAPON_MACHINEPISTOL']='9mm casing',
							['WEAPON_MINISMG']='9mm casing',
							['WEAPON_MICROSMG']='9mm casing',
							['WEAPON_COMBATPDW']='9mm casing',
							['WEAPON_SMG']='9mm casing',
							['WEAPON_SMG_MK2']='9mm casing',
							['WEAPON_ASSAULTSMG']='9mm casing',
							['WEAPON_ASSAULTRIFLE']='7.62 casing',
							['WEAPON_ASSAULTRIFLE_MK2']='7.62 casing',
							['WEAPON_CARBINERIFLE']='5.56 casing',
							['WEAPON_CARBINERIFLE_MK2']='5.56 casing',
							['WEAPON_COMPACTRIFLE']='7.62 casing',
							['WEAPON_COMBATRIFLE']='5.56 casing',
							['WEAPON_ADVANCEDRIFLE']='7.62 casing',
							['WEAPON_SPECIALCARBINE']='7.62 casing',
							['WEAPON_SPECIALCARBINE_MK2']='7.62 casing',
							['WEAPON_TACTICALRIFLE']='7.62 casing',
							['WEAPON_BULLPUPRIFLE']='5.56 casing',
							['WEAPON_BULLPUPRIFLE_MK2']='5.56 casing',
						}
						local item = items[v.weapon.name]
						local mCoords = GetStreetNameFromHashKey(GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z))
						if not item then item = 'Bullet Casing' end
						Draw3DText(v.coords.x, v.coords.y, v.coords.z, item)
						if distance < 1.0 then
							nearbyItems.casing[k] = v
							canCollect = true
						elseif nearbyItems.casing[k] then nearbyItems.casing[k] = nil end
					elseif nearbyItems.casing[k] then nearbyItems.casing[k] = nil end
				end

				for k, v in pairs(evidence.blood) do
					local distance = #(playerCoords - v.coords)
					if distance < 2.0 then
						Draw3DText(v.coords.x, v.coords.y, (v.coords.z - 0.5), 'DNA evidence')
						if distance < 1.0 then
							nearbyItems.blood[k] = v
							canCollect = true
						elseif nearbyItems.blood[k] then nearbyItems.blood[k] = nil end
					elseif nearbyItems.blood[k] then nearbyItems.blood[k] = nil end
				end
				if canCollect then
					if IsControlJustPressed(0, 51) then
						local items = nearbyItems
						local mCoords = mCoords
						nearbyItems = nil
						exports['mythic_progbar']:Progress({
							name = "useitem",
							duration = 2000,
							label = "Collecting evidence",
							useWhileDead = false,
							canCancel = false,
							controlDisables = { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true },
							animation = { animDict = 'pickup_object', anim = 'putdown_low', flags = 48 }
						}, function()
							local mCoords = "Found near : " .. GetStreetNameFromHashKey(GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z))
							TriggerServerEvent('linden_evidence:collectEvidence', items, mCoords)
							nearbyItems = {}
							nearbyItems.bullet = {}
							nearbyItems.casing = {}
							nearbyItems.blood = {}
							synced = false
						end)
					end
				end
			end
		end
		Wait(0)
	end
end)