local QBCore = exports['qb-core']:GetCoreObject()


QBCore.Functions.CreateCallback("qb-cokelab:server:getData", function(source, cb)  --make this a fetch event for everything and then pass through what you wanna fetch
    MySQL.Async.fetchAll('SELECT * FROM lab WHERE labname = ?', {"cokelab"}, function(result)
        local code = result[1].code
        cb(code)
    end)
end)

RegisterNetEvent("qb-cokelab:server:changePasscode",function(code)
    MySQL.update('UPDATE lab SET code = ? WHERE labname = ?',{code, "cokelab"})
end)

RegisterNetEvent('qb-cokelab:server:CheckIngredients', function()
	local Player = QBCore.Functions.GetPlayer(source)
    local ingr1 = Player.Functions.GetItemByName(Config.ingrediant1)
    local ingr2 = Player.Functions.GetItemByName(Config.ingrediant2)
    if (ingr1 ~= nil and ingr2 ~= nil) then    
        TriggerClientEvent("qb-cokelab:client:makecoke", source) 
    else
        TriggerClientEvent('QBCore:Notify', source, "You do not have the correct items", 'error')
    end
end)

RegisterNetEvent('qb-cokelab:server:breakMeth', function()
	local Player = QBCore.Functions.GetPlayer(source)
    local smallcoke = Player.Functions.GetItemByName('coke_small_brick')
    local ingr3 = Player.Functions.GetItemByName(Config.ingrediant3)
    if (smallcoke ~= nil and ingr3 ~= nil) then 
        TriggerClientEvent("qb-cokelab:client:breakMeth", source)
    else
        TriggerClientEvent('QBCore:Notify', source, "You do not have the correct items", 'error')   
    end
end)

RegisterNetEvent('qb-cokelab:server:getcoke_small_brick', function(amount)
    local Player = QBCore.Functions.GetPlayer(source)   
    local methtray = Player.Functions.GetItemByName('coke_small_brick')
    local ingr3 = Player.Functions.GetItemByName(Config.ingrediant3)
    if (methtray ~= nil and ingr3 ~= nil) then 
        if methtray.amount >= 1 then 
            Player.Functions.AddItem("cokebaggy", amount, false)
            TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['cokebaggy'], "add")
            Player.Functions.RemoveItem(Config.ingrediant3, 1, false)
            TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[Config.ingrediant3], "remove")
            Player.Functions.RemoveItem("coke_small_brick", 1, false)
            TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['coke_small_brick'], "remove")
        end
    else
        TriggerClientEvent('QBCore:Notify', source, "You do not have the correct items", 'error')   
    end
end)

RegisterNetEvent('qb-cokelab:server:receivecoke_small_brick', function()
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.RemoveItem(Config.ingrediant1, 1, false)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[Config.ingrediant1], "remove")
    Player.Functions.RemoveItem(Config.ingrediant2, 1, false)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[Config.ingrediant2], "remove")
    Player.Functions.AddItem("coke_small_brick", 2, false)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['coke_small_brick'], "add")
end)