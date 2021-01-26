ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)

function notification(text)
	TriggerClientEvent('esx:showNotification', source, text)
end


RegisterServerEvent('esx_gym:checkChip')
AddEventHandler('esx_gym:checkChip', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local oneQuantity = xPlayer.getInventoryItem('gym_membership').count
	
	if Config.MemberShip.activated then
		if oneQuantity > 0 then
			TriggerClientEvent('esx_gym:trueMembership', source)
		else
			TriggerClientEvent('esx_gym:falseMembership', source)
		end
	else
		TriggerClientEvent('esx_gym:trueMembership', source)
	end
end)

function BuyABike(source, type, price, name)
	local xPlayer = ESX.GetPlayerFromId(source)

	if(xPlayer.getMoney() >= price) then
		xPlayer.removeMoney(price)
			
		notification(_U('yourent')..name)

		TriggerClientEvent("esx_gym:SpawnBike", source, type)
	else
		notification(_U('notenoughmoney'))
	end
end

RegisterServerEvent('esx_gym:BuyBike')
AddEventHandler('esx_gym:BuyBike', function(data)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	BuyABike(_source, data.value, data.price, data.name)
end)

function BuyItem(source, type, price, name)
	local xPlayer = ESX.GetPlayerFromId(source)

	if(xPlayer.getMoney() >= price) then
		xPlayer.removeMoney(price)
		
		xPlayer.addInventoryItem(type, 1)		
		notification(_U('youbought')..name)
	else
		notification(_U('notenoughmoney'))
	end
end

RegisterServerEvent('esx_gym:BuyItem')
AddEventHandler('esx_gym:BuyItem', function(data)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	BuyItem(_source, data.value, data.price, data.name)
end)

function UseItem(source, type, item, amount)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem(item, 1)

	if type == "drink" then
		TriggerClientEvent('esx_status:add', source, 'thirst', amount)
		TriggerClientEvent('esx_basicneeds:onDrink', source)
		TriggerClientEvent('esx:showNotification', source, _U('you_drink').._U('item_'..item))
	elseif type == "eat" then
		TriggerClientEvent('esx_status:add', source, 'hunger', amount)
		TriggerClientEvent('esx_basicneeds:onEat', source)
		TriggerClientEvent('esx:showNotification', source, _U('you_eat').._U('item_'..item))
	end
end

ESX.RegisterUsableItem('protein_shake', function(source)
	UseItem(source, 'drink', 'protein_shake', 350000)
end)

ESX.RegisterUsableItem('sportlunch', function(source)
	UseItem(source, 'eat', 'sportlunch', 350000)
end)

ESX.RegisterUsableItem('powerade', function(source)
	UseItem(source, 'drink', 'powerade', 700000)
end)

ESX.RegisterUsableItem('gym_membership', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	notification(_U('membercard'))
end)