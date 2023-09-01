local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback("qb-methlab:server:getData", function(source, cb)  --make this a fetch event for everything and then pass through what you wanna fetch
    MySQL.Async.fetchAll('SELECT * FROM lab WHERE labname = ?', {"methlab"}, function(result)
        local code = result[1].code
        cb(code)
    end)
end)

RegisterNetEvent("qb-methlab:server:changePasscode",function(code)
    MySQL.update('UPDATE lab SET code = ? WHERE labname = ?',{code, "methlab"})
end)

RegisterServerEvent('qb-methlab:server:CheckIngredients')
AddEventHandler('qb-methlab:server:CheckIngredients', function()
	local Player = QBCore.Functions.GetPlayer(tonumber(source))
    local hydrochloricacid = Player.Functions.GetItemByName('sadiumbenzaout')
    local ephedrine = Player.Functions.GetItemByName('glycole')
    local meth_package = Player.Functions.GetItemByName('meth_package')
	if Player.PlayerData.items ~= nil then 
        if (hydrochloricacid ~= nil and ephedrine ~= nil and meth_package ~= nil) then 
            if hydrochloricacid.amount >= Config.HydrochloricAcid and ephedrine.amount >= Config.Ephedrine and meth_package.amount >= Config.Meth_package then 
                TriggerClientEvent("qb-methlab:client:loadIngredients", source)
            else
                TriggerClientEvent('QBCore:Notify', source, "You do not have the correct items", 'error')
            end
        else
            TriggerClientEvent('QBCore:Notify', source, "You do not have the correct items", 'error')
        end
	else
		TriggerClientEvent('QBCore:Notify', source, "You have nothing...", "error")
	end
end)

RegisterServerEvent('qb-methlab:server:breakMeth')
AddEventHandler('qb-methlab:server:breakMeth', function()
	local Player = QBCore.Functions.GetPlayer(tonumber(source))
    local meth = Player.Functions.GetItemByName('methtray')
    if meth ~= nil then 
        TriggerClientEvent("qb-methlab:client:breakMeth", source)
    else
        TriggerClientEvent('QBCore:Notify', source, "You do not have the correct items", 'error')   
    end
end)

RegisterServerEvent('qb-methlab:server:getmethtray')
AddEventHandler('qb-methlab:server:getmethtray', function(amount)
    local Player = QBCore.Functions.GetPlayer(tonumber(source))   
    local methtray = Player.Functions.GetItemByName('methtray')
    if methtray ~= nil then 
        Player.Functions.AddItem("meth", amount, false)
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['meth'], "add")
        Player.Functions.RemoveItem("methtray", 1, false)
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['methtray'], "remove")
    else
        TriggerClientEvent('QBCore:Notify', source, "You do not have the correct items", 'error')   
    end
end)

RegisterServerEvent('qb-methlab:server:receivemethtray')
AddEventHandler('qb-methlab:server:receivemethtray', function()
    local Player = QBCore.Functions.GetPlayer(tonumber(source))
    Player.Functions.RemoveItem("sadiumbenzaout", Config.HydrochloricAcid, false)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['sadiumbenzaout'], "remove")
    Player.Functions.RemoveItem("glycole", Config.Ephedrine, false)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['glycole'], "remove")
    Player.Functions.RemoveItem("meth_package", Config.Meth_package, false)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['meth_package'], "remove")
    Player.Functions.AddItem("methtray", 3, false)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['methtray'], "add")
end)