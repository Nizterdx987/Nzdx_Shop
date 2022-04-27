local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX                           = nil
local GUI                     = {}
GUI.Time                      = 0
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local HasPayed                = false
local HasLoadCloth			  = false


CreateThread(function()

	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

end)

for i=1, #Config.TokoBaju, 1 do
	Config.Zones['TokoBaju_' .. i] = {
    Pos   = Config.TokoBaju[i],
    Size  = Config.UkuranMarker,
    Color = Config.WarnaMarker,
    Type  = Config.TypeMarker
}
end

--- EVENT UNTUK NON TARGET ---

function TokoBaju()
	local elements = {}
	table.insert(elements, {label = _U('shop_clothes'),  value = 'shop_clothes'})
	table.insert(elements, {label = _U('player_clothes'), value = 'player_dressing'})
	table.insert(elements, {label = _U('suppr_cloth'), value = 'suppr_cloth'})
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'shop_main',
    {
		title    = _U('shop_main_menu'),
		align    = 'bottom-right',
		elements = elements,
    },
	function(data, menu)
		menu.close()
		if data.current.value == 'shop_clothes' then
			HasPayed = false
	TriggerEvent('esx_skin:openRestrictedMenu', function(data, menu)
		menu.close()
		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'shop_confirm',
			{
				title = _U('valid_this_purchase'),
				align = 'bottom-right',
				elements = {
					{label = _U('yes'), value = 'yes'},
					{label = _U('no'), value = 'no'},
				}
			},
			function(data, menu)
				menu.close()
				if data.current.value == 'yes' then
					ESX.TriggerServerCallback('Nzdx_Clotheshop:checkMoney', function(hasEnoughMoney)
						if hasEnoughMoney then
							TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_skin:save', skin)
							end)
							TriggerServerEvent('Nzdx_Clotheshop:pay')
							HasPayed = true
							ESX.TriggerServerCallback('Nzdx_Clotheshop:checkPropertyDataStore', function(foundStore)
								if foundStore then
									ESX.UI.Menu.Open(
										'default', GetCurrentResourceName(), 'save_dressing',
										{
											title = _U('save_in_dressing'),
											align = 'bottom-right',
											elements = {
												{label = _U('yes'), value = 'yes'},
												{label = _U('no'),  value = 'no'},
											}
										},
										function(data2, menu2)
											menu2.close()
											if data2.current.value == 'yes' then
												ESX.UI.Menu.Open(
													'dialog', GetCurrentResourceName(), 'outfit_name',
													{
														title = _U('name_outfit'),
													},
													function(data3, menu3)
														menu3.close()
														TriggerEvent('skinchanger:getSkin', function(skin)
															TriggerServerEvent('Nzdx_Clotheshop:saveOutfit', data3.value, skin)
														end)
														sukses(_U('saved_outfit'))
													end,
													function(data3, menu3)
														menu3.close()
													end
												)
											end
										end
									)
								end
							end)
						else
							TriggerEvent('esx_skin:getLastSkin', function(skin)
								TriggerEvent('skinchanger:loadSkin', skin)
							end)
							error(_U('not_enough_money'))
						end
					end)
				end
				if data.current.value == 'no' then
					TriggerEvent('esx_skin:getLastSkin', function(skin)
						TriggerEvent('skinchanger:loadSkin', skin)
					end)
				end
				CurrentAction     = 'shop_menu'
				CurrentActionMsg  = _U('press_menu')
				CurrentActionData = {}
			end,
			function(data, menu)
				menu.close()
				CurrentAction     = 'shop_menu'
				CurrentActionMsg  = _U('press_menu')
				CurrentActionData = {}
			end)
	end, function(data, menu)
			menu.close()
			CurrentAction     = 'shop_menu'
			CurrentActionMsg  = _U('press_menu')
			CurrentActionData = {}
	end, {
		'tshirt_1',
		'tshirt_2',
		'torso_1',
		'torso_2',
		'decals_1',
		'decals_2',
		'arms',
		'pants_1',
		'pants_2',
		'shoes_1',
		'shoes_2',
		'chain_1',
		'chain_2',
		'helmet_1',
		'helmet_2',
		'bproof_1',
		'bproof_2',
		'glasses_1',
		'glasses_2',
		'bags_1',
		'bags_2',
		'mask_1',
		'mask_2',})
end
	if data.current.value == 'player_dressing' then
		
        ESX.TriggerServerCallback('Nzdx_Clotheshop:getPlayerDressing', function(dressing)
			local elements = {}
			for i=1, #dressing, 1 do
				table.insert(elements, {label = dressing[i], value = i})
		end
		ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'player_dressing',
            {
				title    = _U('player_clothes'),
				align    = 'bottom-right',
				elements = elements,
            },
            function(data, menu)
				TriggerEvent('skinchanger:getSkin', function(skin)
					ESX.TriggerServerCallback('Nzdx_Clotheshop:getPlayerOutfit', function(clothes)
						TriggerEvent('skinchanger:loadClothes', skin, clothes)
						TriggerEvent('esx_skin:setLastSkin', skin)
						TriggerEvent('skinchanger:getSkin', function(skin)
						TriggerServerEvent('esx_skin:save', skin)
					end)
						TaskPlayAnim(PlayerPedId(), 'clothingtie', 'try_tie_negative_a', 1.0, -1.0, 3000, 49, 1, false, false, false)
						Wait(3000)
						sukses(_U('loaded_outfit'))
						HasLoadCloth = true
					end, data.current.value)
				end)
            end,
            function(data, menu)
				menu.close()
				CurrentAction     = 'shop_menu'
				CurrentActionMsg  = _U('press_menu')
				CurrentActionData = {}
            end)
		end)
	end

	if data.current.value == 'suppr_cloth' then
		ESX.TriggerServerCallback('Nzdx_Clotheshop:getPlayerDressing', function(dressing)
			local elements = {}

			for i=1, #dressing, 1 do
				table.insert(elements, {label = dressing[i], value = i})
			end
			
			ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'supprime_cloth',
            {
				title    = _U('suppr_cloth'),
				align    = 'bottom-right',
				elements = elements,
            },
            function(data, menu)
			menu.close()
				TriggerServerEvent('Nzdx_Clotheshop:deleteOutfit', data.current.value)
				sukses(_U('supprimed_cloth'))
            end,
            function(data, menu)
				menu.close()
				CurrentAction     = 'shop_menu'
				CurrentActionMsg  = _U('press_menu')
				CurrentActionData = {}
            end)
		end)
	end

    end,
    function(data, menu)
		menu.close()
		CurrentAction     = 'room_menu'
		CurrentActionMsg  = _U('press_menu')
		CurrentActionData = {}
    end)
end

AddEventHandler('Nzdx_Clotheshop:hasEnteredMarker', function(zone)
	CurrentAction     = 'shop_menu'
	CurrentActionMsg  = _U('press_menu')
	CurrentActionData = {}
end)

AddEventHandler('Nzdx_Clotheshop:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
	if not HasPayed then
		if not HasLoadCloth then 
			TriggerEvent('esx_skin:getLastSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		end
	end
end)

-- Blips Toko Baju
CreateThread(function()
	for i=1, #Config.TokoBaju, 1 do
		local blip = AddBlipForCoord(Config.TokoBaju[i].x, Config.TokoBaju[i].y, Config.TokoBaju[i].z)
		SetBlipSprite (blip, 73)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.8)
		SetBlipColour (blip, 47)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('clothes'))
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
				for k,v in pairs(Config.Zones) do
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

			for k,v in pairs(Config.Zones) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					isInMarker  = true
					currentZone = k
				end
			end

			if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
				HasAlreadyEnteredMarker = true
				LastZone                = currentZone
				TriggerEvent('Nzdx_Clotheshop:hasEnteredMarker', currentZone)
				if Config.TextUi then
					exports['bcs_hud']:displayHelp('Tekan ~E~ Untuk Membuka Menu Clotheshop', 'center-right')
					RegisterCommand('aksesTokoBaju', function()
						TokoBaju()
						exports['bcs_hud']:closeHelp()
					end)
				elseif not Config.TextUi then
					ESX.ShowHelpNotification("Tekan ~E~ Untuk Membuka Menu Clotheshop")
					RegisterCommand('aksesTokoBaju', function()
						TokoBaju()
					end)
				end
			end

			if not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('Nzdx_Clotheshop:hasExitedMarker', LastZone)
				if Config.TextUi then
					exports['bcs_hud']:closeHelp()
				end
				RegisterCommand('aksesTokoBaju', function()
				end)
			end
			RegisterKeyMapping('aksesTokoBaju', 'Akses Toko Baju', 'keyboard', 'E')
			Wait(lsleep)
		end
	end)
end

--- EVENT UNTUK TARGET ---
if Config.Target then
	AddEventHandler('Nzdx_Clotheshop:BeliBaju', function()
		TriggerEvent('esx_skin:openRestrictedMenu', function(data, menu)
			menu.close()
			ESX.UI.Menu.Open(
				'default', GetCurrentResourceName(), 'shop_confirm',
				{
					title = _U('valid_this_purchase'),
					align = 'bottom-right',
					elements = {
						{label = _U('yes'), value = 'yes'},
						{label = _U('no'), value = 'no'},
					}
				},
				function(data, menu)
					menu.close()
					if data.current.value == 'yes' then
						ESX.TriggerServerCallback('Nzdx_Clotheshop:checkMoney', function(hasEnoughMoney)
							if hasEnoughMoney then
								TriggerEvent('skinchanger:getSkin', function(skin)
									TriggerServerEvent('esx_skin:save', skin)
								end)
								TriggerServerEvent('Nzdx_Clotheshop:pay')
								HasPayed = true
								ESX.TriggerServerCallback('Nzdx_Clotheshop:checkPropertyDataStore', function(foundStore)
									if foundStore then
										ESX.UI.Menu.Open(
											'default', GetCurrentResourceName(), 'save_dressing',
											{
												title = _U('save_in_dressing'),
												align = 'bottom-right',
												elements = {
													{label = _U('yes'), value = 'yes'},
													{label = _U('no'),  value = 'no'},
												}
											},
											function(data2, menu2)
												menu2.close()
												if data2.current.value == 'yes' then
													ESX.UI.Menu.Open(
														'dialog', GetCurrentResourceName(), 'outfit_name',
														{
															title = _U('name_outfit'),
														},
														function(data3, menu3)
															menu3.close()
															TriggerEvent('skinchanger:getSkin', function(skin)
																TriggerServerEvent('Nzdx_Clotheshop:saveOutfit', data3.value, skin)
															end)
															sukses(_U('saved_outfit'))
														end,
														function(data3, menu3)
															menu3.close()
														end
													)
												end
											end
										)
									end
								end)
							else
								TriggerEvent('esx_skin:getLastSkin', function(skin)
									TriggerEvent('skinchanger:loadSkin', skin)
								end)
								error(_U('not_enough_money'))
							end
						end)
					end
					if data.current.value == 'no' then
						TriggerEvent('esx_skin:getLastSkin', function(skin)
							TriggerEvent('skinchanger:loadSkin', skin)
						end)
					end
					CurrentAction     = 'shop_menu'
					CurrentActionMsg  = _U('press_menu')
					CurrentActionData = {}
				end,
				function(data, menu)
					menu.close()
					CurrentAction     = 'shop_menu'
					CurrentActionMsg  = _U('press_menu')
					CurrentActionData = {}
				end)
		end, function(data, menu)
				menu.close()
				CurrentAction     = 'shop_menu'
				CurrentActionMsg  = _U('press_menu')
				CurrentActionData = {}
		end, {
			'tshirt_1',
			'tshirt_2',
			'torso_1',
			'torso_2',
			'decals_1',
			'decals_2',
			'arms',
			'pants_1',
			'pants_2',
			'shoes_1',
			'shoes_2',
			'chain_1',
			'chain_2',
			'helmet_1',
			'helmet_2',
			'bproof_1',
			'bproof_2',
			'glasses_1',
			'glasses_2',
			'bags_1',
			'bags_2',
			'mask_1',
			'mask_2',
		})
	end)

	AddEventHandler('Nzdx_Clotheshop:GantiBaju', function()
		ESX.TriggerServerCallback('Nzdx_Clotheshop:getPlayerDressing', function(dressing)
			local elements = {}
			for i=1, #dressing, 1 do
				table.insert(elements, {label = dressing[i], value = i})
		end
		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'player_dressing',
			{
				title    = _U('player_clothes'),
				align    = 'bottom-right',
				elements = elements,
			},
			function(data, menu)
				TriggerEvent('skinchanger:getSkin', function(skin)
					ESX.TriggerServerCallback('Nzdx_Clotheshop:getPlayerOutfit', function(clothes)
						TriggerEvent('skinchanger:loadClothes', skin, clothes)
						TriggerEvent('esx_skin:setLastSkin', skin)
						TriggerEvent('skinchanger:getSkin', function(skin)
						TriggerServerEvent('esx_skin:save', skin)
					end)
						TaskPlayAnim(PlayerPedId(), 'clothingtie', 'try_tie_negative_a', 1.0, -1.0, 3000, 49, 1, false, false, false)
						Wait(3000)
						sukses(_U('loaded_outfit'))
						HasLoadCloth = true
					end, data.current.value)
				end)
			end,
			function(data, menu)
				menu.close()
				CurrentAction     = 'shop_menu'
				CurrentActionMsg  = _U('press_menu')
				CurrentActionData = {}
			end)
		end)
	end)

	AddEventHandler('Nzdx_Clotheshop:HapusBaju', function()
		ESX.TriggerServerCallback('Nzdx_Clotheshop:getPlayerDressing', function(dressing)
			local elements = {}
			for i=1, #dressing, 1 do
				table.insert(elements, {label = dressing[i], value = i})
			end
			ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'supprime_cloth',
			{
				title    = _U('suppr_cloth'),
				align    = 'bottom-right',
				elements = elements,
			},
			function(data, menu)
			menu.close()
				TriggerServerEvent('Nzdx_Clotheshop:deleteOutfit', data.current.value)
				sukses(_U('supprimed_cloth'))
			end,
			function(data, menu)
				menu.close()
				CurrentAction     = 'shop_menu'
				CurrentActionMsg  = _U('press_menu')
				CurrentActionData = {}
			end)
		end)
	end)
end
