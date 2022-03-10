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
			if not item then item = 'Bullet' end
			local mdata = { description = ('%s %s [%s]'):format(v.weapon.label, item, v.weapon.metadata.serial) }
			exports.ox_inventory:AddItem(src, 'evidence_bullet', 1, mdata)
			evidence.bullet[v.id] = nil
			Wait(25)
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
			if not item then item = 'Bullet Casing' end
			local mdata = { description = ('%s %s [%s]'):format(v.weapon.label, item, v.weapon.metadata.serial) }
			exports.ox_inventory:AddItem(src, 'evidence_casing', 1, mdata)
			evidence.casing[v.id] = nil
			Citizen.Wait(25)
		end
	end
	for k, v in pairs(items.blood) do
		if evidence.blood[v.id].coords == v.coords then
			local mdata = { description = ("%s's blood"):format(v.name) }
			exports.ox_inventory:AddItem(src, 'evidence_blood', 1, mdata)
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
