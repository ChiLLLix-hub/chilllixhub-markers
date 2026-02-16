local QBCore = exports['qb-core']:GetCoreObject()

-- Store active markers
local activeMarkers = {}
local nextMarkerId = 1

-- Helper function to get next available marker ID
local function GetNextMarkerId()
    local maxId = 0
    for id, _ in pairs(activeMarkers) do
        if id > maxId then
            maxId = id
        end
    end
    return maxId + 1
end

-- Helper function to filter markers based on player's job
local function FilterMarkersForJob(markers, jobName)
    local filteredMarkers = {}
    local count = 0
    
    for id, marker in pairs(markers) do
        if not marker.job or marker.job == false then
            -- Marker is visible to all players
            filteredMarkers[id] = marker
            count = count + 1
        elseif marker.job == true and marker.jobname and marker.jobname == jobName then
            -- Marker is visible only to specific job and player has that job
            filteredMarkers[id] = marker
            count = count + 1
        end
    end
    
    return filteredMarkers, count
end

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
                drawOnEnts = marker.drawOnEnts,
                job = marker.job or false,
                jobname = marker.jobname or nil
            }
        end
        
        -- Set next ID to be after config markers
        nextMarkerId = #Config.Markers + 1
    end
end)

-- Event to sync markers to a player when they request it
RegisterNetEvent('chilllixhub-markers:server:requestMarkers', function()
    local src = source
    if Config.SyncEnabled then
        local Player = QBCore.Functions.GetPlayer(src)
        if not Player then return end
        
        local playerJob = Player.PlayerData.job.name
        local filteredMarkers, count = FilterMarkersForJob(activeMarkers, playerJob)
        
        print('^2[ChilllixHub-Markers]^7 Syncing ' .. count .. ' markers to player ' .. src .. ' (job: ' .. playerJob .. ')')
        TriggerClientEvent('chilllixhub-markers:client:receiveMarkers', src, filteredMarkers)
    end
end)

-- Event to add a new marker (admin/authorized use)
RegisterNetEvent('chilllixhub-markers:server:addMarker', function(markerData)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Check if player has admin permission
    if not (QBCore.Functions.HasPermission(src, 'admin') or QBCore.Functions.HasPermission(src, 'god')) then
        TriggerClientEvent('QBCore:Notify', src, 'You do not have permission to add markers', 'error')
        return
    end
    
    if Config.SyncEnabled then
        local newId = GetNextMarkerId()
        markerData.id = newId
        markerData.job = markerData.job or false
        markerData.jobname = markerData.jobname or nil
        activeMarkers[newId] = markerData
        
        print('^2[ChilllixHub-Markers]^7 New marker added by player ' .. src)
        
        -- Sync to all clients (they will filter based on their job)
        local Players = QBCore.Functions.GetQBPlayers()
        for k, v in pairs(Players) do
            local playerJob = v.PlayerData.job.name
            local filteredMarkers = FilterMarkersForJob(activeMarkers, playerJob)
            TriggerClientEvent('chilllixhub-markers:client:receiveMarkers', v.PlayerData.source, filteredMarkers)
        end
    end
end)

-- Event to remove a marker (admin/authorized use)
RegisterNetEvent('chilllixhub-markers:server:removeMarker', function(markerId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Check if player has admin permission
    if not (QBCore.Functions.HasPermission(src, 'admin') or QBCore.Functions.HasPermission(src, 'god')) then
        TriggerClientEvent('QBCore:Notify', src, 'You do not have permission to remove markers', 'error')
        return
    end
    
    if Config.SyncEnabled and activeMarkers[markerId] then
        activeMarkers[markerId] = nil
        
        print('^2[ChilllixHub-Markers]^7 Marker removed by player ' .. src)
        
        -- Sync to all clients (they will filter based on their job)
        local Players = QBCore.Functions.GetQBPlayers()
        for k, v in pairs(Players) do
            local playerJob = v.PlayerData.job.name
            local filteredMarkers = FilterMarkersForJob(activeMarkers, playerJob)
            TriggerClientEvent('chilllixhub-markers:client:receiveMarkers', v.PlayerData.source, filteredMarkers)
        end
    end
end)

-- Event to update a marker (admin/authorized use)
RegisterNetEvent('chilllixhub-markers:server:updateMarker', function(markerId, markerData)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Check if player has admin permission
    if not (QBCore.Functions.HasPermission(src, 'admin') or QBCore.Functions.HasPermission(src, 'god')) then
        TriggerClientEvent('QBCore:Notify', src, 'You do not have permission to update markers', 'error')
        return
    end
    
    if Config.SyncEnabled and activeMarkers[markerId] then
        markerData.id = markerId
        markerData.job = markerData.job or false
        markerData.jobname = markerData.jobname or nil
        activeMarkers[markerId] = markerData
        
        print('^2[ChilllixHub-Markers]^7 Marker updated by player ' .. src)
        
        -- Sync to all clients (they will filter based on their job)
        local Players = QBCore.Functions.GetQBPlayers()
        for k, v in pairs(Players) do
            local playerJob = v.PlayerData.job.name
            local filteredMarkers = FilterMarkersForJob(activeMarkers, playerJob)
            TriggerClientEvent('chilllixhub-markers:client:receiveMarkers', v.PlayerData.source, filteredMarkers)
        end
    end
end)

-- Command to reload markers from config (admin only)
-- WARNING: This reloads markers from config and will remove any dynamically added markers
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
                drawOnEnts = marker.drawOnEnts,
                job = marker.job or false,
                jobname = marker.jobname or nil
            }
        end
        
        -- Reset next ID counter
        nextMarkerId = #Config.Markers + 1
        
        -- Sync to all clients (they will filter based on their job)
        local Players = QBCore.Functions.GetQBPlayers()
        for k, v in pairs(Players) do
            local playerJob = v.PlayerData.job.name
            local filteredMarkers = FilterMarkersForJob(activeMarkers, playerJob)
            TriggerClientEvent('chilllixhub-markers:client:receiveMarkers', v.PlayerData.source, filteredMarkers)
        end
        
        TriggerClientEvent('QBCore:Notify', src, 'Markers reloaded from config. Dynamic markers removed.', 'success')
        
        print('^2[ChilllixHub-Markers]^7 Markers reloaded by admin ' .. src)
    else
        TriggerClientEvent('QBCore:Notify', src, 'You do not have permission to use this command', 'error')
    end
end, 'admin')

-- Event to refresh markers when player's job changes
RegisterNetEvent('QBCore:Server:OnJobUpdate', function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player or not Config.SyncEnabled then return end
    
    local playerJob = Player.PlayerData.job.name
    local filteredMarkers = FilterMarkersForJob(activeMarkers, playerJob)
    
    print('^2[ChilllixHub-Markers]^7 Job changed for player ' .. src .. ', syncing markers for new job: ' .. playerJob)
    TriggerClientEvent('chilllixhub-markers:client:receiveMarkers', src, filteredMarkers)
end)
