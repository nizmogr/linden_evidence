ESX = nil
local playerCoords, playerPed
local evidence = {}
local nearbyItems = {}
nearbyItems.bullet = {}
nearbyItems.casing = {}
nearbyItems.blood = {}
local weapon, itemCount
local synced = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
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

RegisterNetEvent('hsn-inventory:currentWeapon')
AddEventHandler('hsn-inventory:currentWeapon', function(item)
	weapon = item
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		playerPed = PlayerPedId()
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
end)

Citizen.CreateThread(function()
	if IsPedArmed(PlayerPedId(), 7) then
		SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'), true)
	end
	while true do
		canCollect = false		
		playerCoords = GetEntityCoords(PlayerPedId())
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
					}
					local item = items[v.weapon.name]
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
					}
					local item = items[v.weapon.name]
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
					Draw3DText(v.coords.x, v.coords.y, (v.coords.z - 0.5), 'Blood splatter')
					if distance < 1.0 then
						nearbyItems.blood[k] = v
						canCollect = true
					elseif nearbyItems.blood[k] then nearbyItems.blood[k] = nil end
				elseif nearbyItems.blood[k] then nearbyItems.blood[k] = nil end
			end
			if canCollect then
				if IsControlJustPressed(0, 51) then
					local items = nearbyItems
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
						TriggerServerEvent('linden_evidence:collectEvidence', items)
						nearbyItems = {}
						nearbyItems.bullet = {}
						nearbyItems.casing = {}
						nearbyItems.blood = {}
						synced = false
					end)
				end
			end
		end
		Citizen.Wait(0)
	end
end)