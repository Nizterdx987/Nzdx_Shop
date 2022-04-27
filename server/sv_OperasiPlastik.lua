ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_plasticsurgery:pay')
AddEventHandler('esx_plasticsurgery:pay', function()

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeMoney(Config.RegulasiOplas)
	suksess(_U('you_paid') .. Config.RegulasiOplas)

end)

ESX.RegisterServerCallback('esx_plasticsurgery:checkMoney', function(source, cb)

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.get('money') >= Config.RegulasiOplas then
		cb(true)
	else
		cb(false)
	end

end)

RegisterServerEvent('Nzdx_OperasiPlastik:hapustiket')
AddEventHandler('Nzdx_OperasiPlastik:hapustiket', function(tiket)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local drill = xPlayer.getInventoryItem('tiketoplas')
	local xPlayers = ESX.GetPlayers()
	if xPlayer.getInventoryItem('tiketoplas').count >= 1 then
		xPlayer.removeInventoryItem('tiketoplas', 1)
	else
	end
end)

ESX.RegisterServerCallback('Nzdx_OperasiPlastik:getItemAmount', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local quantity = xPlayer.getInventoryItem(item).count

	cb(quantity)
end)