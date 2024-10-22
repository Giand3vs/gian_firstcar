local QB = exports["qb-core"]:GetCoreObject()

local function generatePlate()
    local plate = QB.Shared.RandomInt(1) .. QB.Shared.RandomStr(2) .. QB.Shared.RandomInt(3) .. QB.Shared.RandomStr(2)
    local result = MySQL.scalar.await('SELECT plate FROM player_vehicles WHERE plate = ?', { plate })
    if result then
        return generatePlate()
    else
        return plate:upper()
    end
end

QB.Functions.CreateCallback("gian_firstcar:server:checkNewPlayer",function(source,cb,args) 
    local Player = QB.Functions.GetPlayer(source)
    if Player then
        MySQL.query('SELECT `firsttime` FROM `players` WHERE `citizenid` = ?', {
            Player.PlayerData.citizenid
        }, function(response)
            if response then
                for k, v in pairs(response) do
                    if v.firsttime == 0 then
                        cb(true)
                        MySQL.update('UPDATE players SET firsttime = ? WHERE citizenid = ?', {1, Player.PlayerData.citizenid})
                    else
                        cb(false)
                    end
                end
            end
        end)
    end
end)

RegisterServerEvent("gian_firstcar:server:giveVehicle", function(model, name)
    local Player = QB.Functions.GetPlayer(source)
    local plate = generatePlate()
    MySQL.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state, garage) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
        Player.PlayerData.license,
        Player.PlayerData.citizenid,
        model,
        GetHashKey(model),
        '{}',
        plate,
        1,
        "garageinicio", 
    })
    TriggerClientEvent("QBCore:Notify", Player.PlayerData.source, "Congratulations!, u have a new car!."..name)
end)
