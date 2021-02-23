ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local evidence = {}
evidence.bullet = {}
evidence.casing = {}
evidence.blood = {}
local bulletCount, casingCount, bloodCount = 0, 0, 0

ESX.RegisterServerCallback('linden_evidence:getEvidence', function(source, cb)
	cb(evidence)
end)

RegisterServerEvent('linden_evidence:collectEvidence')
AddEventHandler('linden_evidence:collectEvidence',function(items)
	src = source
	for k, v in pairs(items.bullet) do
		if evidence.bullet[v.id].coords == v.coords then
			local items = {
				['WEAPON_ASSAULTSHOTGUN']='Pellets',
				['WEAPON_AUTOSHOTGUN']='Pellets',
				['WEAPON_BULLPUPSHOTGUN']='Pellets',
				['WEAPON_DBSHOTGUN']='Pellets',
				['WEAPON_SAWNOFFSHOTGUN']='Pellets',
				['WEAPON_PUMPSHOTGUN']='Pellets',
				['WEAPON_PUMPSHOTGUN_MK2']='Pellets',
				['WEAPON_HEAVYSHOTGUN']='Pellets',
			}
			local item = items[v.weapon.name]
			if not item then item = 'Bullet' end
			local mdata = { description = ('%s %s [%s]'):format(v.weapon.label, item, v.weapon.metadata.weaponlicense) }
			exports['hsn-inventory']:addItem(src, 'evidence_bullet', 1, mdata)
			evidence.bullet[v.id] = nil
			Citizen.Wait(25)
		end
	end
	for k, v in pairs(items.casing) do
		if evidence.casing[v.id].coords == v.coords then
			local items = {
				['WEAPON_ASSAULTSHOTGUN']='Shell',
				['WEAPON_AUTOSHOTGUN']='Shell',
				['WEAPON_BULLPUPSHOTGUN']='Shell',
				['WEAPON_DBSHOTGUN']='Shell',
				['WEAPON_SAWNOFFSHOTGUN']='Shell',
				['WEAPON_PUMPSHOTGUN']='Shell',
				['WEAPON_PUMPSHOTGUN_MK2']='Shell',
				['WEAPON_HEAVYSHOTGUN']='Shell',
			}
			local item = items[v.weapon.name]
			if not item then item = 'Bullet Casing' end
			local mdata = { description = ('%s %s [%s]'):format(v.weapon.label, item, v.weapon.metadata.weaponlicense) }
			exports['hsn-inventory']:addItem(src, 'evidence_casing', 1, mdata)
			evidence.casing[v.id] = nil
			Citizen.Wait(25)
		end
	end
	for k, v in pairs(items.blood) do
		if evidence.blood[v.id].coords == v.coords then
			local mdata = { description = ("%s's blood"):format(v.name) }
			exports['hsn-inventory']:addItem(src, 'evidence_blood', 1, mdata)
			evidence.blood[v.id] = nil
			Citizen.Wait(25)
		end
	end
	TriggerClientEvent('linden_evidence:updateEvidence', -1, evidence)
end)

RegisterServerEvent('linden_evidence:addEvidence')
AddEventHandler('linden_evidence:addEvidence',function(weapon, bullet, casing, blood)
	if bullet then
		bulletCount = #evidence.bullet
		bullet.id = (bulletCount + 1)
		bullet.weapon = weapon
		evidence.bullet[bullet.id] = bullet
	end
	if casing then
		casingCount = #evidence.casing
		casing.id = (casingCount + 1)
		casing.weapon = weapon
		evidence.casing[casing.id] = casing
	end
	if blood then
		bloodCount = #evidence.blood
		data = {}
		xPlayer = ESX.GetPlayerFromId(source)
		data.name = xPlayer.getName()
		data.coords = blood
		data.id = (bloodCount + 1)
		evidence.blood[data.id] = data
	end
	TriggerClientEvent('linden_evidence:updateEvidence', -1, evidence)
end)
