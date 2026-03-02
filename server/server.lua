local QBCore = exports['qb-core']:GetCoreObject()
local inventory = exports.ox_inventory

lib.callback.register("corry_badges:server:setMetadata", function(source, data, info, input, itemSlot)
    local image = nil
    local src = source
    local itemSlot = itemSlot
    for k,v in pairs(config.jobToImage) do
        if info.type == k then 
            image = v
        end
    end
    local metadata = {
        playerName = info.name,
        callsign = input.callsign,
        rank = info.rank,
        type = info.type,
        photo = input.photo,
        --image = image,
        slot = itemSlot
    }
    --print(metadata.photo)
    inventory:SetMetadata(source, itemSlot, metadata)
    local slot = inventory:GetSlot(source, itemSlot)
    return slot
end)

lib.callback.register("corry_badges:server:showBadge", function(source, data, players)
    print("Showing badge to nearby players")
    local src = source
    for i = 1, #players do
        local player = players[i]
        TriggerClientEvent("corry_badges:client:showBadge", player, data, src)
    end
    return true
end)