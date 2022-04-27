ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('Nzdx_Barbershop:pay')
AddEventHandler('Nzdx_Barbershop:pay', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeMoney(Config.RegulasiPotong)
	suksess(_U('you_paid') .. Config.RegulasiPotong)
end)

ESX.RegisterServerCallback('Nzdx_Barbershop:checkMoney', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	cb(xPlayer.getMoney() >= Config.RegulasiPotong)
end)
