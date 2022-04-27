ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('Nzdx_Clotheshop:pay')
AddEventHandler('Nzdx_Clotheshop:pay', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeMoney(Config.RegulasiBaju)
	suksess(_U('you_paid') .. Config.RegulasiBaju)
end)

RegisterServerEvent('Nzdx_Clotheshop:saveOutfit')
AddEventHandler('Nzdx_Clotheshop:saveOutfit', function(label, skin)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local dressing = store.get('dressing')

		if dressing == nil then
			dressing = {}
		end

		table.insert(dressing, {
			label = label,
			skin  = skin
		})

		store.set('dressing', dressing)
	end)
end)

RegisterServerEvent('Nzdx_Clotheshop:deleteOutfit')
AddEventHandler('Nzdx_Clotheshop:deleteOutfit', function(label)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local dressing = store.get('dressing')

		if dressing == nil then
			dressing = {}
		end

		label = label
		
		table.remove(dressing, label)

		store.set('dressing', dressing)
	end)
end)

ESX.RegisterServerCallback('Nzdx_Clotheshop:checkMoney', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.get('money') >= Config.RegulasiBaju then
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('Nzdx_Clotheshop:checkPropertyDataStore', function(source, cb)
	local xPlayer    = ESX.GetPlayerFromId(source)
	local foundStore = false

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		foundStore = true
	end)

	cb(foundStore)
end)

ESX.RegisterServerCallback('Nzdx_Clotheshop:getPlayerDressing', function(source, cb)
	local xPlayer  = ESX.GetPlayerFromId(source)
	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local count    = store.count('dressing')
		local labels   = {}

		for i=1, count, 1 do
			local entry = store.get('dressing', i)
			table.insert(labels, entry.label)
		end
		cb(labels)
	end)
end)

ESX.RegisterServerCallback('Nzdx_Clotheshop:getPlayerOutfit', function(source, cb, num)
	local xPlayer  = ESX.GetPlayerFromId(source)
	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local outfit = store.get('dressing', num)
		cb(outfit.skin)
	end)
end)
