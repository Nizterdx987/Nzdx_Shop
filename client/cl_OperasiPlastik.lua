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

CreateThread(function()

	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

end)

for i=1, #Config.OperasiPlastik, 1 do
	Config.ZonesOperasiPlastik['OperasiPlastik_' .. i] = {
    Pos   = Config.OperasiPlastik[i],
    Size  = Config.UkuranMarker,
    Color = Config.WarnaMarker,
    Type  = Config.TypeMarker
}
end

--- EVENT UNTUK NON TARGET ---
function OpenMenuOplas()
	HasPayed = false
	TriggerEvent('esx_skin:openRestrictedMenu', function(data, menu)
		menu.close()
		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'shop_confirm',
			{
				title = _U('valid_this_purchase'),
				align = 'top-left',
				elements = {
					{label = _U('yes'), value = 'yes'},
					{label = _U('no'), value = 'no'},
				}
			},
			function(data, menu)

				menu.close()

				if data.current.value == 'yes' then

					ESX.TriggerServerCallback('esx_plasticsurgery:checkMoney', function(hasEnoughMoney)

						if hasEnoughMoney then

							TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_skin:save', skin)
							end)

							TriggerServerEvent('esx_plasticsurgery:pay')

							HasPayed = true
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
				CurrentActionMsg  = _U('press_access')
				CurrentActionData = {}

			end,
			function(data, menu)

				menu.close()

				CurrentAction     = 'shop_menu'
				CurrentActionMsg  = _U('press_access')
				CurrentActionData = {}

			end
		)

	end, function(data, menu)

			menu.close()

			CurrentAction     = 'shop_menu'
			CurrentActionMsg  = _U('press_access')
			CurrentActionData = {}

	end, {
		'sex',
		'face',
		'skin',
		'eye_color',
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
		'blemishes_1',
		'blemishes_2',
		'blush_1',
		'blush_2',
		'blush_3',
		'complexion_1',
		'complexion_2',
		'sun_1',
		'sun_2',
		'moles_1',
		'moles_2',
		'chest_1',
		'chest_2',
		'chest_3',
		'bodyb_1',
		'bodyb_2',
	})

end

AddEventHandler('esx_plasticsurgery:hasEnteredMarker', function(zone)
	CurrentAction     = 'shop_menu'
	CurrentActionMsg  = _U('press_access')
	CurrentActionData = {}
end)

AddEventHandler('esx_plasticsurgery:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil

	if not HasPayed then
		TriggerEvent('esx_skin:getLastSkin', function(skin)
			TriggerEvent('skinchanger:loadSkin', skin)
		end)
	end

end)
-- Tampilan Marker
if not Config.Target then
	CreateThread(function()
		while true do
			local sleep  = 1000
			local coords = GetEntityCoords(PlayerPedId())
			if Config.Marker  then
				for k,v in pairs(Config.ZonesOperasiPlastik) do
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
			local sleep 	  = 1000
			local coords      = GetEntityCoords(PlayerPedId())
			local isInMarker  = false
			local currentZone = nil

			for k,v in pairs(Config.ZonesOperasiPlastik) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					isInMarker  = true
					currentZone = k
				end
			end

			if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
				HasAlreadyEnteredMarker = true
				LastZone                = currentZone
				TriggerEvent('esx_plasticsurgery:hasEnteredMarker', currentZone)
				if Config.TextUi then
					exports['bcs_hud']:displayHelp('Tekan ~E~ Untuk Membuka Menu Operasi Plastik', 'center-right')
					RegisterCommand('aksesOperasiPlatik', function()
						ESX.TriggerServerCallback('Nzdx_OperasiPlastik:getItemAmount', function(quantity)
							if quantity > 0 then
								TriggerServerEvent('Nzdx_OperasiPlastik:hapustiket', tiket)
								OpenMenuOplas()
							else
								ESX.UI.Menu.CloseAll()
								error('Anda Tidak Memiliki Tiket Oplas')
							end          
						end, 'tiketoplas') 
					end)
				elseif not Config.TextUi then
					ESX.ShowHelpNotification("Tekan ~E~ Untuk Membuka Menu Operasi Plastik")
					RegisterCommand('aksesOperasiPlatik', function()
						exports['bcs_hud']:closeHelp()
						ESX.TriggerServerCallback('Nzdx_OperasiPlastik:getItemAmount', function(quantity)
							if quantity > 0 then
								TriggerServerEvent('Nzdx_OperasiPlastik:hapustiket', tiket)
								OpenMenuOplas()
								exports['bcs_hud']:closeHelp()
							else
								ESX.UI.Menu.CloseAll()
								error('Anda Tidak Memiliki Tiket Oplas')
							end          
						end, 'tiketoplas') 
					end)
				end
			end

			if not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_plasticsurgery:hasExitedMarker', LastZone)
				if Config.TextUi then
					exports['bcs_hud']:closeHelp()
				end
				RegisterCommand('aksesOperasiPlatik', function()
				end)
			end
			Wait(sleep)
			RegisterKeyMapping('aksesOperasiPlatik', 'Akses Operasi Plastik', 'keyboard', 'E')
		end
	end)
end


--- EVENT UNTUK MENGGUNAKAN TARGET ---
if Config.Target then
	AddEventHandler('Nzdx_OperasiPlastik:Oplas', function()
		ESX.TriggerServerCallback('Nzdx_OperasiPlastik:getItemAmount', function(quantity)
			if quantity > 0 then
				TriggerServerEvent('Nzdx_OperasiPlastik:hapustiket', tiket)
				OpenMenuOplas()
			else
				error('Anda Tidak Memiliki Tiket Oplas')
			end          
		end, 'tiketoplas')                        
	end)
end