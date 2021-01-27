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

ESX = nil
local PlayerData = {}
local training = false
local resting = false
local membership = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
		PlayerData = ESX.GetPlayerData()
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

function hintToDisplay(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

Citizen.CreateThread(function()
	for _, info in pairs(Config.Blips) do
		info.blip = AddBlipForCoord(info.x, info.y, info.z)
		SetBlipSprite(info.blip, info.id)
		SetBlipDisplay(info.blip, 4)
		SetBlipScale(info.blip, 1.0)
		SetBlipColour(info.blip, info.colour)
		SetBlipAsShortRange(info.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(info.title)
		EndTextCommandSetBlipName(info.blip)
	end
end)

RegisterNetEvent('esx_gym:trueMembership')
AddEventHandler('esx_gym:trueMembership', function()
	membership = true
end)

RegisterNetEvent('esx_gym:falseMembership')
AddEventHandler('esx_gym:falseMembership', function()
	membership = false
end)

function shopMakers(plyCoords, pos)
	for k in pairs(pos) do
		local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)
		if dist <= 20 then
			DrawMarker(1, pos[k].x, pos[k].y, pos[k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.25, 1.25, 0.5, 0, 153, 255, 100, 0, 0, 0, 0)
		end
	end
end

function exersiceMakers(plyCoords, pos)
	for k in pairs(pos) do
		local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)
		if dist <= 20 then
			DrawMarker(21, pos[k].x, pos[k].y, pos[k].z, 0, 0, 0, 0, 0, 0, 0.30, 0.30, 0.30, 0, 255, 50, 200, 1, 0, 0, 1)
		end
	end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)

        local gym = Config.Pos.gym
		local rentbike = Config.Pos.rentbike
		local arms = Config.Pos.arms
		local pushup = Config.Pos.pushup
		local yoga = Config.Pos.yoga
		local situps = Config.Pos.situps
		local chins = Config.Pos.chins

		shopMakers(plyCoords, gym)
		shopMakers(plyCoords, rentbike)
		exersiceMakers(plyCoords, arms)
		exersiceMakers(plyCoords, pushup)
		exersiceMakers(plyCoords, yoga)
		exersiceMakers(plyCoords, situps)
		exersiceMakers(plyCoords, chins)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local gym = Config.Pos.gym
        local rentbike = Config.Pos.rentbike

        local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)

        for k in pairs(rentbike) do
		
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, rentbike[k].x, rentbike[k].y, rentbike[k].z)

            if dist <= 1.25 then
				hintToDisplay(_U('display_rent'))
				
				if IsControlJustPressed(0, Keys['E']) then
					if IsPedInAnyVehicle(GetPlayerPed(-1)) then
						ESX.ShowNotification(_U('havecar'))
					else
						OpenBikeMenu()
					end
				end			
            end
        end

        for k in pairs(gym) do
		
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, gym[k].x, gym[k].y, gym[k].z)

            if dist <= 1.25 then
				hintToDisplay(_U('display_gym'))
				
				if IsControlJustPressed(0, Keys['E']) then
					OpenGymMenu()
				end			
            end
        end
    end
end)

function CheckTraining()
	if resting == true then
		ESX.ShowNotification(_U('needrest'))
		
		Citizen.Wait(60000)
		training = false
		resting = false
	end
	
	if resting == false then
		ESX.ShowNotification(_U('doexersice'))
	end
end

function Exersices(pos, sport, anim)

	local hint = _U('display_sport')
	if sport == "yoga" then
		hint =_U('display_yoga')
	end

	for k in pairs(pos) do

		local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
		local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

		if dist <= 0.5 then
			hintToDisplay(hint.._U('exersice_'..sport))
			
			if IsControlJustPressed(0, Keys['E']) then
				if training == false then
					
					TriggerServerEvent('esx_gym:checkChip')
					ESX.ShowNotification(_U('preparation'))
					Citizen.Wait(1000)					
					
					if membership == true then
						local playerPed = GetPlayerPed(-1)
						TaskStartScenarioInPlace(playerPed, anim, 0, true)
						Citizen.Wait(30000)
						ClearPedTasksImmediately(playerPed)
						ESX.ShowNotification(_U('needtorest'))

						resting = true							
						training = true

						CheckTraining()
					elseif membership == false then
						ESX.ShowNotification(_U('bemember'))
					end
				elseif training == true then
					CheckTraining()
				end
			end			
		end
	end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local arms = Config.Pos.arms
        local chins = Config.Pos.chins
        local pushup = Config.Pos.pushup
        local yoga = Config.Pos.yoga
        local situps = Config.Pos.situps

        Exersices(arms, 'rowings', "world_human_muscle_free_weights")
        Exersices(chins, 'pullups', "prop_human_muscle_chin_ups")
        Exersices(pushup, 'pushups', "world_human_push_ups")
        Exersices(yoga, 'yoga', "world_human_yoga")
        Exersices(situps, 'situps', "world_human_sit_ups")
    end
end)

function OpenGymMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'gym_menu',
        {
            title    = _U('gymclub'),
            align = 'top-left',
            elements = {
				{label = _U('hours'), value = 'hours'},
				{label = _U('membership'), value = 'ship'},
				{label = _U('shop'), value = 'shop'},
            }
        },
        function(data, menu)
            if data.current.value == 'shop' then
				OpenGymShopMenu()
            elseif data.current.value == 'hours' then
				ESX.UI.Menu.CloseAll()
				
				ESX.ShowNotification(_U('hours_notice'))
            elseif data.current.value == 'ship' then
				OpenGymShipMenu()
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end

function OpenGymShopMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'gym_shop_menu',
        {
            title    = _U('shop'),
            align = 'top-left',
            elements = {
				{label = _U('item_protein_shake')..' ($'..Config.Shop.protein_shake..')', value = 'protein_shake', name = _U('item_protein_shake'), price = Config.Shop.protein_shake},
				{label = _U('item_water')..' ($'..Config.Shop.water..')', value = 'water', name = _U('item_water'), price = Config.Shop.water},
				{label = _U('item_sportlunch')..' ($'..Config.Shop.sportlunch..')', value = 'sportlunch', name = _U('item_sportlunch'), price = Config.Shop.sportlunch},
				{label = _U('item_powerade')..' ($'..Config.Shop.powerade..')', value = 'powerade', name = _U('item_powerade'), price = Config.Shop.powerade},
				{label = _U('item_bandage')..' ($'..Config.Shop.bandage..')', value = 'bandage', name = _U('item_bandage'), price = Config.Shop.bandage},
            }
        },
        function(data, menu)
            TriggerServerEvent('esx_gym:BuyItem', data.current)
				
			ESX.UI.Menu.CloseAll()
        end,
        function(data, menu)
            menu.close()
        end
    )
end

function OpenGymShipMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'gym_ship_menu',
        {
            title    = _U('membership'),
            align = 'top-left',
            elements = {
				{label = _U('accept')..' ($'..Config.MemberShip.price..')', value = 'membership', name = _U('item_membership'), price = Config.MemberShip.price},
				{label = _U('cancel'), value = 'cancel'},
            }
        },
        function(data, menu)
            if data.current.value == 'membership' then
				TriggerServerEvent('esx_gym:BuyItem', data.current)
				
				ESX.UI.Menu.CloseAll()
            elseif data.current.value == 'cancel' then				
				ESX.UI.Menu.CloseAll()
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end

function OpenBikeMenu(source)
	local xPlayer = source

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'bike_menu',
        {
            title    = _U('bikerental'),
            align = 'top-left',
            elements = {
				{label = 'BMX ($'..Config.Bikes.bmx..')', value = 'bmx', name = 'BMX', price = Config.Bikes.bmx},
				{label = 'Cruiser ($'..Config.Bikes.cruiser..')', value = 'cruiser', name = 'Cruiser', price = Config.Bikes.cruiser},
				{label = 'Fixter ($'..Config.Bikes.fixter..')', value = 'fixter', name = 'Fixter', price = Config.Bikes.fixter},
				{label = 'Scorcher ($'..Config.Bikes.scorcher..')', value = 'scorcher', name = 'Scorcher', price = Config.Bikes.scorcher},
            }
        },
        function(data, menu)
            TriggerServerEvent('esx_gym:BuyBike', data.current)
				
			ESX.UI.Menu.CloseAll()
        end,
        function(data, menu)
            menu.close()
        end
    )
end

RegisterNetEvent('esx_gym:SpawnBike')
AddEventHandler('esx_gym:SpawnBike', function(type)
	TriggerEvent('esx:spawnVehicle', type)
end)