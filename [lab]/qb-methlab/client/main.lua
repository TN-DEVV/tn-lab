local QBCore = exports['qb-core']:GetCoreObject()

local mLibs         = exports["meta_libs"]
local Scenes        = mLibs:SynchronisedScene()


local ClosestMethlab = 0
local loadIngredients = false

local NeededAttempts = 0
local SucceededAttempts = 0
local FailedAttemps = 0

local sceneObjects  = {}


CreateThread(function()
    exports['qb-target']:AddCircleZone("cokemeth", vector3(1005.67, -3200.35, -38.52), 1.5,{
        name = "cokemeth",
        debugPoly = false,
        useZ=true
},  {
        options = {
            {
                --event = "qb-cokelab:server:breakMeth",
                icon = "fas fa-cut", 
                label = "cokemeth",
                action = function()
                    --methcoke()
                    TriggerServerEvent("qb-methlab:server:CheckIngredients")
                end,
            },
        },
        distance = 1.5
    })

    exports['qb-target']:AddCircleZone(`packagemeth`, vector3(1012.08, -3194.95, -38.99), 1.5,{
        name = "packagemeth",
        debugPoly = false,
        useZ=true
},  {
        options = {
            {
                --event = "qb-cokelab:server:CheckIngredients",
                icon = "fas fa-cut", 
                label = "Pack Meth",
                action = function()
                    --packmeth()
                    TriggerServerEvent("qb-methlab:server:breakMeth")
                end,
            },
        },
        distance = 1.5
    })
    exports['qb-target']:AddCircleZone(`exitmethlab`, vector3(997.01, -3200.65, -36.4), 1.5,{
        name = "exitmethlab",
        debugPoly = false,
        useZ=true
},  {
        options = {
            {
                --event = "qb-cokelab:server:CheckIngredients",
                icon = "fas fa-cut", 
                label = "go out",
                action = function()
                    ExitMethlab()
                end,
            },
            {
                icon = "fas fa-cut", 
                label = "Change Passcode",
                action = function()
                    TriggerEvent("qb-methlab:client:changePasscode")
                end,
            },
        },
        distance = 1.5
    })

    exports['qb-target']:AddCircleZone(`entremethlab`, vector3(-1321.6, -1264.23, 4.59), 1.5,{ 
        name = "entremethlab", 
        debugPoly = false,
        useZ=true
},  {
        options = {
            {
                --event = "qb-cokelab:server:CheckIngredients",
                icon = "fas fa-cut", 
                label = "entre",
                action = function()
                    TriggerEvent("qb-methlab:client:interact")
                end,
            },
        },
        distance = 1.5
    })
end)



RegisterNetEvent("qb-methlab:client:interact")
AddEventHandler("qb-methlab:client:interact", function()
    exports['qb-menu']:openMenu({
        {
            header = "meth laboratoire",
            isMenuHeader = true
        },
        {
            header = "enter to lab",
            txt = "",
            params = {
                event = "qb-methlab:client:openLocker",
            }
        },
        {
            header = "Raid Lock",
            txt = "",
            params = {
                event = "qb-methlab:client:raidLocker",
            }
        },
        {
            header = "exit",
            params = {
                event = "qb-menu:closeMenu"
            }
        },
    })
end)


function methcoke()
    TriggerServerEvent("qb-methlab:server:CheckIngredients")
end

function packmeth()
    TriggerServerEvent("qb-methlab:server:breakMeth")
end

RegisterNetEvent('qb-methlab:client:breakMeth')
AddEventHandler('qb-methlab:client:breakMeth', function()
    BreakMinigame()
end)

RegisterNetEvent('qb-methlab:client:loadIngredients')
AddEventHandler('qb-methlab:client:loadIngredients', function()
    ProcessMinigame()
end)

RegisterNetEvent('qb-methlab:client:openLocker') --trigger event after nh-context open locker button. Opens the password UI for the locker
AddEventHandler('qb-methlab:client:openLocker', function()
    SendNUIMessage({
        type = "attempt",
        action = "openKeypad",
    })
    SetNuiFocus(true, true)
end)

RegisterNetEvent('qb-methlab:client:changePasscode')
AddEventHandler('qb-methlab:client:changePasscode', function()
    SendNUIMessage({
        type = "changePasscode",
        action = "openKeypad",
    })
    SetNuiFocus(true, true)
end)

RegisterNetEvent('qb-methlab:client:raidLocker')
AddEventHandler('qb-methlab:client:raidLocker', function(data)
    PlayerJob = QBCore.Functions.GetPlayerData().job
    if PlayerJob.name == "police" then
        QBCore.Functions.TriggerCallback('QBCore:HasItem', function(HasItem)
            if HasItem then
                EnterMethlab()
            else
                QBCore.Functions.Notify("You don't have a Stormram on you..", "error")
            end
        end, 'police_stormram' )
    else
        QBCore.Functions.Notify("You are not a police", "error")
    end
end)

function BreakMinigame()
    local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
    if NeededAttempts == 0 then
        NeededAttempts = math.random(3, 5)
        -- NeededAttempts = 1
    end

    local maxwidth = 10
    local maxduration = 3500

    Skillbar.Start({
        duration = math.random(700, 800),
        pos = math.random(10, 30),
        width = math.random(8, 12),
    }, function()

        if SucceededAttempts + 1 >= NeededAttempts then

            FailedAttemps = 0
            SucceededAttempts = 0
            NeededAttempts = 0

            local random = math.random(8, 12)
            breakingMeth(random)
        else    
            SucceededAttempts = SucceededAttempts + 1
            Skillbar.Repeat({
                duration = math.random(700, 800),
                pos = math.random(10, 30),
                width = math.random(8, 12),
            })
        end  
        
	end, function()
            QBCore.Functions.Notify("Failed", "error")
            ClearPedTasks(PlayerPedId())
    end)
end
function startAnim()
    local plyPed = GetPlayerPed(-1)
    local location    = vector3(1005.80,-3200.40,-38.90)
    local offset      = vector3(-4.88,-1.95,0.0)

    local sceneType = "Meth"
    local doScene = 1
    local actPos = location - offset
    local actRot = vector3(0.0, 0.0, 0.0)

    local animDict = SceneDicts[sceneType][doScene]
    local actItems = SceneItems[sceneType][doScene]
    local actAnims = SceneAnims[sceneType][doScene]
    local plyAnim = PlayerAnims[sceneType][doScene]

    while not HasAnimDictLoaded(animDict) do RequestAnimDict(animDict); Wait(0); end

    local count = 1
    local objectCount = 0
    for k,v in pairs(actItems) do
      local hash = GetHashKey(v)
      while not HasModelLoaded(hash) do RequestModel(hash); Wait(0); end
      sceneObjects[k] = CreateObject(hash,actPos,true)
      SetModelAsNoLongerNeeded(hash)
      objectCount = objectCount + 1
      while not DoesEntityExist(sceneObjects[k]) do Wait(0); end
      SetEntityCollision(sceneObjects[k],false,false)
    end



    local scenes = {}
    local sceneConfig = Scenes.SceneConfig(actPos,actRot,2,false,false,1.0,0,1.0)

    for i=1,math.max(1,math.ceil(objectCount/3)),1 do
      scenes[i] = Scenes.Create(sceneConfig)
    end

    local pedConfig = Scenes.PedConfig(plyPed,scenes[1],animDict,plyAnim)
    Scenes.AddPed(pedConfig)

    for k,animation in pairs(actAnims) do      
      local targetScene = scenes[math.ceil(count/3)]
      local entConfig = Scenes.EntityConfig(sceneObjects[k],targetScene,animDict,animation)
      Scenes.AddEntity(entConfig)
      count = count + 1
    end

    for i=1,#scenes,1 do
        Scenes.Start(scenes[i])
      end
      Wait(73000)

    for i=1,#scenes,1 do
      Scenes.Stop(scenes[i])
    end

    RemoveAnimDict(animDict)
    for k,v in pairs(sceneObjects) do NetworkFadeOutEntity(v,false,false); end
end
function breakingMeth(amount)
    PrepareAnim()
    TriggerServerEvent("qb-methlab:server:getmethtray", amount)
end

function cokemeth()
    startAnim()
    TriggerServerEvent("qb-methlab:server:receivemethtray")
end

function PrepareAnim()
    local plyPed = GetPlayerPed(-1)
    local location    = vector3(1011.80,-3194.90,-38.99)
    local offset      = vector3(4.48,1.7,1.0)

    local sceneType = "Meth"
    local doScene = 2
    local actPos = location - offset
    local actRot = vector3(0.0, 0.0, 0.0)

    local animDict = SceneDicts[sceneType][doScene]
    local actItems = SceneItems[sceneType][doScene]
    local actAnims = SceneAnims[sceneType][doScene]
    local plyAnim = PlayerAnims[sceneType][doScene]

    while not HasAnimDictLoaded(animDict) do RequestAnimDict(animDict); Wait(0); end

    local count = 1
    local objectCount = 0
    for k,v in pairs(actItems) do
      local hash = GetHashKey(v)
      while not HasModelLoaded(hash) do RequestModel(hash); Wait(0); end
      sceneObjects[k] = CreateObject(hash,actPos,true)
      SetModelAsNoLongerNeeded(hash)
      objectCount = objectCount + 1
      while not DoesEntityExist(sceneObjects[k]) do Wait(0); end
      SetEntityCollision(sceneObjects[k],false,false)
    end



    local scenes = {}
    local sceneConfig = Scenes.SceneConfig(actPos,actRot,2,false,false,1.0,0,1.0)

    for i=1,math.max(1,math.ceil(objectCount/3)),1 do
      scenes[i] = Scenes.Create(sceneConfig)
    end

    local pedConfig = Scenes.PedConfig(plyPed,scenes[1],animDict,plyAnim)
    Scenes.AddPed(pedConfig)

    for k,animation in pairs(actAnims) do      
      local targetScene = scenes[math.ceil(count/3)]
      local entConfig = Scenes.EntityConfig(sceneObjects[k],targetScene,animDict,animation)
      Scenes.AddEntity(entConfig)
      count = count + 1
    end

    for i=1,#scenes,1 do
        Scenes.Start(scenes[i])
      end
      Wait(Config.BreakMethTimer)

    for i=1,#scenes,1 do
      Scenes.Stop(scenes[i])
    end

    RemoveAnimDict(animDict)
    for k,v in pairs(sceneObjects) do NetworkFadeOutEntity(v,false,false); end
end

function LoadAnim(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(1)
    end
end

function ProcessMinigame()
    local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
    if NeededAttempts == 0 then
        NeededAttempts = math.random(3, 4)
        -- NeededAttempts = 1
    end
    local maxwidth = 10
    local maxduration = 3500
    Skillbar.Start({
        duration = math.random(700, 800),
        pos = math.random(10, 30),
        width = math.random(8, 12),
    }, function()
        if SucceededAttempts + 1 >= NeededAttempts then

            FailedAttemps = 0
            SucceededAttempts = 0
            NeededAttempts = 0

            cokemeth()
        else    
            SucceededAttempts = SucceededAttempts + 1
            Skillbar.Repeat({
                duration = math.random(700, 800),
                pos = math.random(10, 30),
                width = math.random(8, 12),
            })
        end
	end, function()
            QBCore.Functions.Notify("Failed", "error")
    end)
end

function StartMachine()
    Citizen.CreateThread(function()
        machineStarted = true
        while machinetimer > 0 do
            machinetimer = machinetimer - 1
            Citizen.Wait(1000)
        end
        machineStarted = false
        finishedMachine = true
    end)
end



function EnterMethlab()
    local ped = PlayerPedId()
    OpenDoorAnimation()
    Citizen.Wait(500)
    DoScreenFadeOut(250)
    Citizen.Wait(250)
    SetEntityCoords(ped, Config.Locations["exit"].coords.x, Config.Locations["exit"].coords.y, Config.Locations["exit"].coords.z - 0.98)
    SetEntityHeading(ped, Config.Locations["exit"].coords.w)
    Citizen.Wait(1000)
    DoScreenFadeIn(250)
end

function ExitMethlab()
    local ped = PlayerPedId()
    local dict = "mp_heists@keypad@"
    local anim = "idle_a"
    local flag = 0
    local keypad = {coords = {x = 996.92, y = -3199.85, z = -36.4, h = 94.5, r = 1.0}}
    SetEntityCoords(ped, keypad.coords.x, keypad.coords.y, keypad.coords.z - 0.98)
    SetEntityHeading(ped, keypad.coords.h)
    LoadAnimationDict(dict) 
    TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, flag, 0, false, false, false)
    Citizen.Wait(2500)
    TaskPlayAnim(ped, dict, "exit", 2.0, 2.0, -1, flag, 0, false, false, false)
    Citizen.Wait(1000)
    DoScreenFadeOut(250)
    Citizen.Wait(250)
    SetEntityCoords(ped, Config.Locations["laboratories"][1].coords.x, Config.Locations["laboratories"][1].coords.y, Config.Locations["laboratories"][1].coords.z - 0.98)
    SetEntityHeading(ped, Config.Locations["laboratories"][1].coords.w)
    Citizen.Wait(1000)
    DoScreenFadeIn(250)
end

function LoadAnimationDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(1)
    end
end

function OpenDoorAnimation()
    local ped = PlayerPedId()
    LoadAnimationDict("anim@heists@keycard@") 
    TaskPlayAnim(ped, "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0)
    Citizen.Wait(400)
    ClearPedTasks(ped)
end

RegisterNUICallback('PadLockClose', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback("CombinationSound", function(data, cb)
    PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
end)

RegisterNUICallback('UseCombination', function(data, cb)
    if data.type == 'attempt' then
        QBCore.Functions.TriggerCallback('qb-methlab:server:getData', function(combination)
            if tonumber(data.combination) ~= nil then
                if tonumber(data.combination) == tonumber(combination) then
                    SetNuiFocus(false, false)
                    SendNUIMessage({
                        action = "closeKeypad",
                        error = false,
                    })
                    EnterMethlab()
                else
                    QBCore.Functions.Notify("Incorrect Password", 'error')
                    SetNuiFocus(false, false)
                    SendNUIMessage({
                        action = "closeKeypad",
                        error = true,
                    })
                end  
            end    
        end) 
    elseif data.type == 'changePasscode' then
        SendNUIMessage({
            action = "closeKeypad",
            error = false,
        })
        if data.combination ~= nil then
            TriggerServerEvent("qb-methlab:server:changePasscode", data.combination)
            QBCore.Functions.Notify("your password has been change to "..data.combination, 'success')
        end
    end
end)