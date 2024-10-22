local QB = exports["qb-core"]:GetCoreObject()
local PlayerData = {}
local carLists = {}

-- #(Start)

CreateThread(function()
    if QB.Functions.GetPlayerData() == nil then
        Wait(1000)
    end

    PlayerData = QB.Functions.GetPlayerData()
    for k, v in pairs(Config.Coords) do
        addNPC(v.coords.x, v.coords.y, v.coords.z -1, v.coords.h, "u_m_y_mani", "Business Man", "mini@strip_club@idles@bouncer@base")
        CreateThread(function()
            while true do
                local s = 1000
                local dist = #(vec3(v.coords.x, v.coords.y, v.coords.z) - GetEntityCoords(PlayerPedId()))
                if dist < 1 then
                    s = 0
                    ShowFloatingHelpNotification("Press ~p~[E]~w~ to talk with Gian", vec3(v.coords.x, v.coords.y, v.coords.z+1))
                    if IsControlPressed(0, 38) then
                        _main()
                    end
                end
                Wait(s)
            end
        end)
    end
end)

-- #(Main)

_main = function()
    QB.Functions.TriggerCallback("gian_firstcar:server:checkNewPlayer",function(status)
        if status then
            SendNUIMessage({
                type = "showCarSelection",
            })
            SetNuiFocus(true, true)
        else
            QB.Functions.Notify("U can't recive two times the car..")
        end
    end, 'nil')
end

-- #(Events)

RegisterNUICallback('close', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback('giveVehicle', function(data)
    SendNUIMessage({
        type = "closeUI",
    })
    TriggerServerEvent("gian_firstcar:server:giveVehicle", data, data)
end)

-- #(Functions)

function addNPC(x, y, z, heading, model, headingText, animation)
    RequestModel(GetHashKey(model))
    while not HasModelLoaded(GetHashKey(model)) do
        Wait(15)
    end
    RequestAnimDict(animation)
    while not HasAnimDictLoaded(animation) do
        Wait(15)
    end
    ped = CreatePed(4, GetHashKey(model), x, y, z, 3374176, false, true)
    SetEntityHeading(ped, heading)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    TaskPlayAnim(ped, animation, "base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
end

ShowFloatingHelpNotification = function(msg, coords) 
    AddTextEntry('qbcoreFloatingHelpNotification', msg) 
    SetFloatingHelpTextWorldPosition(1, coords) 
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0) 
    BeginTextCommandDisplayHelp('qbcoreFloatingHelpNotification') 
    EndTextCommandDisplayHelp(2, false, false, -1) 
end