local QBCore = exports['qb-core']:GetCoreObject()

-- Store active markers
local activeMarkers = {}

-- Initialize markers from config
CreateThread(function()
    if Config.SyncEnabled then
        print('^2[ChilllixHub-Markers]^7 Server initialized with ' .. #Config.Markers .. ' markers')
        
        -- Load markers from config
        for i, marker in ipairs(Config.Markers) do
            activeMarkers[i] = {
                id = i,
                name = marker.name,
                type = marker.type,
                coords = marker.coords,
                scale = marker.scale,
                color = marker.color,
                bobUpAndDown = marker.bobUpAndDown,
                faceCamera = marker.faceCamera,
                rotate = marker.rotate,
                drawOnEnts = marker.drawOnEnts
            }
        end
    end
end)

-- Event to sync markers to a player when they request it
RegisterNetEvent('chilllixhub-markers:server:requestMarkers', function()
    local src = source
    if Config.SyncEnabled then
        print('^2[ChilllixHub-Markers]^7 Syncing markers to player ' .. src)
        TriggerClientEvent('chilllixhub-markers:client:receiveMarkers', src, activeMarkers)
    end
end)

-- Event to add a new marker (admin/authorized use)
RegisterNetEvent('chilllixhub-markers:server:addMarker', function(markerData)
    local src = source
    -- Add QBCore permission check if needed
    -- local Player = QBCore.Functions.GetPlayer(src)
    -- if not Player then return end
    
    if Config.SyncEnabled then
        local newId = #activeMarkers + 1
        markerData.id = newId
        activeMarkers[newId] = markerData
        
        print('^2[ChilllixHub-Markers]^7 New marker added by player ' .. src)
        
        -- Sync to all clients
        TriggerClientEvent('chilllixhub-markers:client:receiveMarkers', -1, activeMarkers)
    end
end)

-- Event to remove a marker (admin/authorized use)
RegisterNetEvent('chilllixhub-markers:server:removeMarker', function(markerId)
    local src = source
    -- Add QBCore permission check if needed
    -- local Player = QBCore.Functions.GetPlayer(src)
    -- if not Player then return end
    
    if Config.SyncEnabled and activeMarkers[markerId] then
        activeMarkers[markerId] = nil
        
        print('^2[ChilllixHub-Markers]^7 Marker removed by player ' .. src)
        
        -- Sync to all clients
        TriggerClientEvent('chilllixhub-markers:client:receiveMarkers', -1, activeMarkers)
    end
end)

-- Event to update a marker (admin/authorized use)
RegisterNetEvent('chilllixhub-markers:server:updateMarker', function(markerId, markerData)
    local src = source
    -- Add QBCore permission check if needed
    -- local Player = QBCore.Functions.GetPlayer(src)
    -- if not Player then return end
    
    if Config.SyncEnabled and activeMarkers[markerId] then
        markerData.id = markerId
        activeMarkers[markerId] = markerData
        
        print('^2[ChilllixHub-Markers]^7 Marker updated by player ' .. src)
        
        -- Sync to all clients
        TriggerClientEvent('chilllixhub-markers:client:receiveMarkers', -1, activeMarkers)
    end
end)

-- Command to reload markers from config (admin only)
QBCore.Commands.Add('reloadmarkers', 'Reload markers from config (Admin Only)', {}, false, function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Check if player has admin permission
    if QBCore.Functions.HasPermission(src, 'admin') or QBCore.Functions.HasPermission(src, 'god') then
        activeMarkers = {}
        
        -- Reload markers from config
        for i, marker in ipairs(Config.Markers) do
            activeMarkers[i] = {
                id = i,
                name = marker.name,
                type = marker.type,
                coords = marker.coords,
                scale = marker.scale,
                color = marker.color,
                bobUpAndDown = marker.bobUpAndDown,
                faceCamera = marker.faceCamera,
                rotate = marker.rotate,
                drawOnEnts = marker.drawOnEnts
            }
        end
        
        -- Sync to all clients
        TriggerClientEvent('chilllixhub-markers:client:receiveMarkers', -1, activeMarkers)
        TriggerClientEvent('QBCore:Notify', src, 'Markers reloaded successfully!', 'success')
        
        print('^2[ChilllixHub-Markers]^7 Markers reloaded by admin ' .. src)
    else
        TriggerClientEvent('QBCore:Notify', src, 'You do not have permission to use this command', 'error')
    end
end, 'admin')
