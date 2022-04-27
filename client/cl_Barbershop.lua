ESX = nil
local hasAlreadyEnteredMarker, lastZone, currentAction, currentActionMsg, hasPaid

CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

for i=1, #Config.PangkasRambut, 1 do
	Config.ZonesPangkasRambut['PangkasRambut_' .. i] = {
    Pos   = Config.PangkasRambut[i],
    Size  = Config.UkuranMarker,
    Color = Config.WarnaMarker,
    Type  = Config.TypeMarker
}
end

--- EVENT NON TARGET ---

function PangkasRambut()
	hasPaid = false

	TriggerEvent('esx_skin:openRestrictedMenu', function(data, menu)
		menu.close()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
			title = _U('valid_this_purchase'),
			align = 'top-left',
			elements = {
				{label = _U('no'),  value = 'no'},
				{label = _U('yes'), value = 'yes'}
		}}, function(data, menu)
			menu.close()

			if data.current.value == 'yes' then
				ESX.TriggerServerCallback('Nzdx_Barbershop:checkMoney', function(hasEnoughMoney)
					if hasEnoughMoney then
						TriggerEvent('skinchanger:getSkin', function(skin)
							TriggerServerEvent('esx_skin:save', skin)
						end)

						TriggerServerEvent('Nzdx_Barbershop:pay')
						hasPaid = true
					else
						ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
							TriggerEvent('skinchanger:loadSkin', skin) 
						end)
						error(_U('not_enough_money'))
					end
				end)
			elseif data.current.value == 'no' then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin) 
				end)
			end

			currentAction = 'shop_menu'
			currentActionMsg = _U('press_access')
		end, function(data, menu)
			menu.close()
			currentAction = 'shop_menu'
			currentActionMsg = _U('press_access')
		end)
	end, function(data, menu)
		menu.close()

		currentAction    = 'shop_menu'
		currentActionMsg  = _U('press_access')
	end, {
		'beard_1',
		'beard_2',
		'beard_3',
		'beard_4',
		'hair_1',
		'hair_2',
		'hair_color_1',
		'hair_color_2',
		'eyebrows_1',
		'eyebrows_2',
		'eyebrows_3',
		'eyebrows_4',
		'makeup_1',
		'makeup_2',
		'makeup_3',
		'makeup_4',
		'lipstick_1',
		'lipstick_2',
		'lipstick_3',
		'lipstick_4',
		'ears_1',
		'ears_2',
	})
end

AddEventHandler('Nzdx_Barbershop:hasEnteredMarker', function(zone)
	currentAction = 'shop_menu'
	currentActionMsg = _U('press_access')
end)

AddEventHandler('Nzdx_Barbershop:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	currentAction = nil

	if not hasPaid then
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
			TriggerEvent('skinchanger:loadSkin', skin)
		end)
	end
end)

-- Blips Pangkas Rambut
CreateThread(function()
	for i=1, #Config.PangkasRambut, 1 do
		local blip = AddBlipForCoord(Config.PangkasRambut[i].x, Config.PangkasRambut[i].y, Config.PangkasRambut[i].z)

		SetBlipSprite (blip, 71)
		SetBlipScale  (blip, 0.7)
		SetBlipColour (blip, 51)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(_U('barber_blip'))
		EndTextCommandSetBlipName(blip)
	end
end)

-- Tampilan Marker
if not Config.Target then
	CreateThread(function()
		while true do
			local sleep  = 1000
			local coords = GetEntityCoords(PlayerPedId())
			if Config.Marker  then
				for k,v in pairs(Config.ZonesPangkasRambut) do
					if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.Jangkauan) then
						sleep = 1
						DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
					end
				end
			end
			
			Wait(sleep)
		end
	end)

	CreateThread(function()
		while true do
			local lsleep	  = 1000
			local coords      = GetEntityCoords(PlayerPedId())
			local isInMarker  = false
			local currentZone = nil

			for k,v in pairs(Config.ZonesPangkasRambut) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					isInMarker  = true
					currentZone = k
				end
			end

			if (isInMarker and not hasAlreadyEnteredMarker) or (isInMarker and lastZone ~= currentZone) then
				hasAlreadyEnteredMarker, lastZone = true, currentZone
				TriggerEvent('Nzdx_Barbershop:hasEnteredMarker', currentZone)
				if Config.TextUi then
					exports['bcs_hud']:displayHelp('Tekan ~E~ Untuk Membuka Menu Barbershop', 'center-right')
					RegisterCommand('aksesPangkasRambut', function()
						PangkasRambut()
						exports['bcs_hud']:closeHelp()
					end)
				elseif not Config.TextUi then
					ESX.ShowHelpNotification("Tekan ~E~ Untuk Membuka Menu Barbershop")
					RegisterCommand('aksesPangkasRambut', function()
						PangkasRambut()
					end)
				end
			end

			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('Nzdx_Barbershop:hasExitedMarker', lastZone)
				if Config.TextUi then
					exports['bcs_hud']:closeHelp()
				end
				RegisterCommand('aksesPangkasRambut', function()
				end)
			end
			RegisterKeyMapping('aksesPangkasRambut', 'Akses Pangkas Rambut', 'keyboard', 'E')
			Wait(lsleep)
		end
	end)
end

--- EVENT TARGET ---
if Config.Target then
	AddEventHandler('Nzdx_Barbershop:PangkasRambut', function()
		hasPaid = false
		TriggerEvent('esx_skin:openRestrictedMenu', function(data, menu)
			menu.close()

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
				title = _U('valid_this_purchase'),
				align = 'top-left',
				elements = {
					{label = _U('no'),  value = 'no'},
					{label = _U('yes'), value = 'yes'}
			}}, function(data, menu)
				menu.close()

				if data.current.value == 'yes' then
					ESX.TriggerServerCallback('Nzdx_Barbershop:checkMoney', function(hasEnoughMoney)
						if hasEnoughMoney then
							TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_skin:save', skin)
							end)

							TriggerServerEvent('Nzdx_Barbershop:pay')
							hasPaid = true
						else
							ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
								TriggerEvent('skinchanger:loadSkin', skin) 
							end)
							error(_U('not_enough_money'))
						end
					end)
				elseif data.current.value == 'no' then
					ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
						TriggerEvent('skinchanger:loadSkin', skin) 
					end)
				end

				currentAction = 'shop_menu'
				currentActionMsg = _U('press_access')
			end, function(data, menu)
				menu.close()
				currentAction = 'shop_menu'
				currentActionMsg = _U('press_access')
			end)
		end, function(data, menu)
			menu.close()

			currentAction    = 'shop_menu'
			currentActionMsg  = _U('press_access')
		end, {
			'beard_1',
			'beard_2',
			'beard_3',
			'beard_4',
			'hair_1',
			'hair_2',
			'hair_color_1',
			'hair_color_2',
			'eyebrows_1',
			'eyebrows_2',
			'eyebrows_3',
			'eyebrows_4',
			'makeup_1',
			'makeup_2',
			'makeup_3',
			'makeup_4',
			'lipstick_1',
			'lipstick_2',
			'lipstick_3',
			'lipstick_4',
			'ears_1',
			'ears_2',
		})
	end)
end


