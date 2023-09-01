local QBCore = exports['qb-core']:GetCoreObject()

local mLibs         = exports["meta_libs"]
local Scenes        = mLibs:SynchronisedScene()


local NeededAttempts = 0
local SucceededAttempts = 0
local FailedAttemps = 0

local sceneObjects  = {}


CreateThread(function()
    exports['qb-target']:AddCircleZone(`breakcoke`, Config.brakecoke, 1.5,{
        name = "breakcoke",
        debugPoly = false,
        useZ=true
},  {
        options = {
            {
                --event = "qb-cokelab:server:breakMeth",
                icon = "fas fa-cut", 
                label = "Break coke",
                action = function()
                    TriggerServerEvent("qb-cokelab:server:breakMeth")
                end,
            },
        },
        distance = 1.5
    })

    exports['qb-target']:AddCircleZone(`packagecoke`, Config.packagecoke, 1.5,{
        name = "packagecoke",
        debugPoly = false,
        useZ=true
},  {
        options = {
            {
                --event = "qb-cokelab:server:CheckIngredients",
                icon = "fas fa-cut", 
                label = "Pack coke",
                action = function()
                    --packcoke()
                    TriggerServerEvent("qb-cokelab:server:CheckIngredients")
                end,
            },
        },
        distance = 1.5
    })

    exports['qb-target']:AddCircleZone(`exitcokelab`, Config.exitcoke, 1.5,{
        name = "exitcokelab",
        debugPoly = false,
        useZ=true
},  {
        options = {
            {
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
                    TriggerEvent("qb-cokelab:client:changePasscode")
                end,
            },
        },
        distance = 1.5
    })
    exports['qb-target']:AddCircleZone(`entrecokelab`, Config.entercoke, 1.5,{ 
        name = "entrecokelab", 
        debugPoly = false,
        useZ=true
},  {
        options = {
            {
                icon = "fas fa-cut", 
                label = "entre",
                action = function()
                    TriggerEvent("qb-cokelab:client:interact")
                end,
            },
        },
        distance = 1.5
    })
end)


RegisterNetEvent("qb-cokelab:client:interact", function(k, v)
    exports['qb-menu']:openMenu({
        {
            header = "coke laboratoire",
            isMenuHeader = true
        },
        {
            header = "enter to lab",
            txt = "",
            params = {
                event = "qb-cokelab:client:openLocker",
            }
        },
        {
            header = "Raid Lock",
            txt = "",
            params = {
                event = "qb-cokelab:client:raidLocker",
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


RegisterNetEvent('qb-cokelab:client:breakMeth', function()
    BreakMinigame()
end)


RegisterNetEvent('qb-cokelab:client:makecoke', function()
    ProcessMinigame()
end)


RegisterNetEvent('qb-cokelab:client:openLocker', function()
    SendNUIMessage({
        type = "attempt",
        action = "openKeypad",
    })
    SetNuiFocus(true, true)
end)


RegisterNetEvent('qb-cokelab:client:changePasscode', function()
    SendNUIMessage({
        type = "changePasscode",
        action = "openKeypad",
    })
    SetNuiFocus(true, true)
end)


RegisterNetEvent('qb-cokelab:client:raidLocker', function(data)
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
--[[    local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
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
    end)]]
    exports['ps-ui']:Circle(function(success)
        if success then
            local random = math.random(8, 12)
            breakingMeth(random)
        else
            QBCore.Functions.Notify("Failed", "error")
            ClearPedTasks(PlayerPedId())
        end
    end, 2, 20) -- NumberOfCircles, MS
end

function breakingMeth(amount)
    PrepareAnim()
    TriggerServerEvent("qb-cokelab:server:getcoke_small_brick", amount)
end

function packcoke()
    TriggerServerEvent("qb-cokelab:server:CheckIngredients")
end

function makecoke()
    startAnim()
    TriggerServerEvent("qb-cokelab:server:receivecoke_small_brick")
end

function startAnim()
    local plyPed = GetPlayerPed(-1)
    local location    = vector3(1101.245,-3198.82,-39.60)
    local offset      = vector3(7.663,-2.222,0.395)

    local sceneType = "Cocaine"
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
      Wait(55000)

    for i=1,#scenes,1 do
      Scenes.Stop(scenes[i])
    end

    RemoveAnimDict(animDict)
    for k,v in pairs(sceneObjects) do NetworkFadeOutEntity(v,false,false); end
end

function PrepareAnim()
    --local ped = PlayerPedId()
    --LoadAnim('anim@amb@business@coc@coc_unpack_cut_left@')
    --TaskPlayAnim(ped, 'anim@amb@business@coc@coc_unpack_cut_left@', 'coke_cut_v5_coccutter', 6.0, -6.0, -1, 47, 0, 0, 0, 0)
    local plyPed = GetPlayerPed(-1)
    local location    = vector3(1093.18,-3194.925,-39.60)
    local offset      = vector3(1.911,0.31,0.0)

    local sceneType = "Cocaine"
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
    
    local hashh = GetHashKey('bkr_prop_coke_tablepowder')
    while not HasModelLoaded(hashh) do RequestModel(hashh); Wait(0); end
    obj = CreateObject(hashh,vector3(1092.83, -3195.61, -39.19),true)
    SetModelAsNoLongerNeeded(hashh)
    
    while not DoesEntityExist(obj) do Wait(0); end
    SetEntityCollision(obj,false,false)


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
--[[    local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
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
            makecoke()

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
    end)]]
    exports['ps-ui']:Circle(function(success)
        if success then
            makecoke()
        else
            QBCore.Functions.Notify("Failed", "error")
        end
    end, 2, 20) -- NumberOfCircles, MS
end


function EnterMethlab()
    local ped = PlayerPedId()
    OpenDoorAnimation()
    --InsideMethlab = true
    Citizen.Wait(500)
    DoScreenFadeOut(250)
    Citizen.Wait(250)
    SetEntityCoords(ped, Config.insidelab.x, Config.insidelab.y, Config.insidelab.z - 0.98)
    SetEntityHeading(ped, Config.insidelab.w)
    Citizen.Wait(1000)
    DoScreenFadeIn(250)
end

function ExitMethlab()
    local ped = PlayerPedId()
    local dict = "mp_heists@keypad@"
    local anim = "idle_a"
    local flag = 0
    local keypad = {coords = {x = 1088.09, y = -3187.88, z = -38.99, h = 4.26, r = 2.06}}
    SetEntityCoords(ped, keypad.coords.x, keypad.coords.y, keypad.coords.z - 0.98)
    SetEntityHeading(ped, keypad.coords.h)
    LoadAnimationDict(dict) 
    TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, flag, 0, false, false, false)
    Citizen.Wait(2500)
    TaskPlayAnim(ped, dict, "exit", 2.0, 2.0, -1, flag, 0, false, false, false)
    Citizen.Wait(1000)
    DoScreenFadeOut(250)
    Citizen.Wait(250)
    SetEntityCoords(ped, Config.outlab.x, Config.outlab.y, Config.outlab.z - 0.98)
    SetEntityHeading(ped, Config.outlab.w)
    --InsideMethlab = false
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
        QBCore.Functions.TriggerCallback('qb-cokelab:server:getData', function(combination)
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
            TriggerServerEvent("qb-cokelab:server:changePasscode", data.combination)
            QBCore.Functions.Notify("your password has been change to "..data.combination, 'success')
        end
    end
end)