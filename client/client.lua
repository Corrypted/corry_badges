local QBCore = exports['qb-core']:GetCoreObject()
local inventory = exports.ox_inventory

local plate_net = nil
local platespawned = nil
local plateModel = "x99_policebadge_bcso"
local plateModel2 = "x99_policebadge_doa"
local plateModel3 = "x99_policebadge_lspd"
local plateModel4 = "x99_policebadge_park"
local plateModel5 = "x99_policebadge_sasp"
local animDict = "paper_1_rcm_alt1-9"
local animName = "player_one_dual-9"

PlayerLoaded = false

local function openBadge(data, slot)
    if not data.metadata.playerName or not data.metadata.callsign or not data.metadata.rank or not data.metadata.photo then
        local input = lib.inputDialog("Create Badge", {
            { type = "input", label = "Image URL", name = "photo", required = true, description = "Must end with .png or .jpg"},
            { type = "input", label = "Callsign", name = "callsign", required = true, description = "Your current callsign"},
        })
        if not input then return end
        local inputData = {
            photo = input[1],
            callsign = input[2]
        }
        local PlayerData = QBCore.Functions.GetPlayerData()
        if PlayerData.job.type ~= "leo" then 
            lib.notify({
                title = "Error",
                description = "You must be a law enforcement officer to create a badge.",
                type = "error"
            })
            return
        end
        local info = {}
        info.name = PlayerData.charinfo.firstname.. " " ..PlayerData.charinfo.lastname
        info.rank = PlayerData.job.grade.name
        info.type = PlayerData.job.name
        lib.callback("corry_badges:server:setMetadata", false, function(item)
            --print(json.encode(item))
            if item then
                lib.notify({
                    title = "Badge Created",
                    description = "Your badge has been created successfully!",
                    type = "success"
                })
            else
            end
        end, data, info, inputData, slot)
    else
        local coords = GetEntityCoords(cache.ped)
        local test = lib.getNearbyPlayers(coords, config.badgedDistance, true)
        local players = {}
        for i = 1, #test do
            table.insert(players, GetPlayerServerId(test[i].id))
        end
        lib.callback("corry_badges:server:showBadge", false, function(success)
            if not success then
                lib.notify({
                    title = "Error",
                    description = "There was an error showing your badge. Please try again.",
                    type = "error"
                })
            end
        end, data, players)
    end
end
exports('openBadge', openBadge)

RegisterNetEvent("corry_badges:client:showBadge", function(data, sourcePlayer)
    local playerId = GetPlayerServerId(PlayerId())
    if playerId == sourcePlayer then startAnim(cache.ped, data.metadata.type) end
    local officerName = data.metadata.rank.." "..data.metadata.playerName
    SendNUIMessage({
        action = "badgeOpen",
        name = officerName,
        callsign = data.metadata.callsign,
        photo = data.metadata.photo,
        type = data.metadata.type
    })
    badge = true
    while badge do
        Wait(1)
        if IsControlJustPressed(1, config.closeKey) then
            DeleteEntity(plate_net)
            DeleteEntity(NetToObj(plate_net))
            badge = false
            SendNUIMessage({
                action = "badgeClose"
            })
            ClearPedSecondaryTask(cache.ped)
            DeleteEntity(platespawned)
            DetachEntity(NetToObj(plate_net), 1, 1)
            DeleteEntity(NetToObj(plate_net))
            plate_net = nil 
            platespawned = nil
            RemoveAnimSet("paper_1_rcm_alt1-9")
            SetModelAsNoLongerNeeded(GetHashKey(getBadgeType(data.metadata.type)))
        end
    end
end)

function startAnim(playerPed, type)
    -- local playerPed = PlayerPedId()
    if not IsPedInAnyVehicle(playerPed, false) then
        local model = GetHashKey(getBadgeType(type))
        lib.requestModel(model, 10000)
        ClearPedSecondaryTask(playerPed)
        lib.requestAnimDict("paper_1_rcm_alt1-7", 10000)
        local plyCoords = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 0.0, -5.0)
        TaskPlayAnim(playerPed, "paper_1_rcm_alt1-7", "player_one_dual-7", 3.0, 3.0, -1, 62, 0, 0, 0, 0)
        Wait(1300)
        platespawned = CreateObject(model, plyCoords.x, plyCoords.y, plyCoords.z, 0, 0, 0)
        AttachEntityToEntity(platespawned, playerPed, GetPedBoneIndex(playerPed, 28422), 0.12, 0.088, 0.001, 270.0, 180.0, 300.0, 1, 1, 0, 1, 0, 1)
        local netid = ObjToNet(platespawned)
        plate_net = netid
        SetNetworkIdExistsOnAllMachines(netid, true)
        SetNetworkIdCanMigrate(netid, false)
    end
end

function getBadgeType(type)
    local model = "x99_policebadge_bcso"
    if type == "police" then
        model = "x99_policebadge_lspd"
    elseif type == "sheriff" then 
        model = "x99_policebadge_bcso"
    elseif type == "trooper" then 
        model = "x99_policebadge_sasp"
    elseif type == "ranger" then 
        model = "x99_policebadge_park"
    end
    return model

end

function tprint(t, s)
    for k, v in pairs(t) do
        local kfmt = '["' .. tostring(k) ..'"]'
        if type(k) ~= 'string' then
            kfmt = '[' .. k .. ']'
        end
        local vfmt = '"'.. tostring(v) ..'"'
        if type(v) == 'table' then
            tprint(v, (s or '')..kfmt)
        else
            if type(v) ~= 'string' then
                vfmt = tostring(v)
            end
            print(type(t)..(s or '')..kfmt..' = '..vfmt)
        end
    end
end