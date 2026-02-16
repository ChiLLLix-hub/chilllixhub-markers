local QBCore = exports['qb-core']:GetCoreObject()

-- Store synced markers
local syncedMarkers = {}
local markersLoaded = false

-- Helper function to get next available marker ID (for local mode)
local function GetNextMarkerId()
    local maxId = 0
    for id, _ in pairs(syncedMarkers) do
        if id > maxId then
            maxId = id
        end
    end
    return maxId + 1
end

-- Initialize markers on resource start
CreateThread(function()
    -- Wait for player to be loaded
    while not LocalPlayer.state.isLoggedIn do
        Wait(1000)
    end
    
    Wait(2000) -- Additional wait for stability
    
    -- Request markers from server
    if Config.SyncEnabled then
        print('^2[ChilllixHub-Markers]^7 Requesting markers from server')
        TriggerServerEvent('chilllixhub-markers:server:requestMarkers')
    else
        -- Load markers from config if sync is disabled
        for i, marker in ipairs(Config.Markers) do
            syncedMarkers[i] = marker
        end
        markersLoaded = true
        print('^2[ChilllixHub-Markers]^7 Loaded ' .. #syncedMarkers .. ' markers from config')
    end
end)

-- Receive markers from server
RegisterNetEvent('chilllixhub-markers:client:receiveMarkers', function(markers)
    syncedMarkers = markers
    markersLoaded = true
    local count = 0
    for _ in pairs(markers) do
        count = count + 1
    end
    print('^2[ChilllixHub-Markers]^7 Received ' .. count .. ' markers from server')
end)

-- Main thread to draw markers
CreateThread(function()
    while true do
        local sleep = Config.RefreshRate
        
        if markersLoaded then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local isDrawing = false
            
            for _, marker in pairs(syncedMarkers) do
                if marker and marker.coords then
                    local distance = #(playerCoords - marker.coords)
                    
                    -- Only draw markers within draw distance
                    if distance <= Config.DrawDistance then
                        isDrawing = true
                        
                        -- Draw marker
                        DrawMarker(
                            marker.type,
                            marker.coords.x, marker.coords.y, marker.coords.z,
                            0.0, 0.0, 0.0, -- Direction
                            0.0, 0.0, 0.0, -- Rotation
                            marker.scale.x, marker.scale.y, marker.scale.z, -- Scale
                            marker.color.r, marker.color.g, marker.color.b, marker.color.a, -- Color
                            marker.bobUpAndDown or false,
                            marker.faceCamera or false,
                            2,
                            marker.rotate or false,
                            nil,
                            nil,
                            marker.drawOnEnts or false
                        )
                    end
                end
            end
            
            -- If we're drawing markers, don't sleep to maintain smooth rendering
            if isDrawing then
                sleep = 0
            end
        else
            sleep = 1000 -- Wait longer if markers aren't loaded yet
        end
        
        Wait(sleep)
    end
end)

-- Debug command to show marker info
RegisterCommand('markerinfo', function()
    if markersLoaded then
        local count = 0
        for _ in pairs(syncedMarkers) do
            count = count + 1
        end
        QBCore.Functions.Notify('Active markers: ' .. count, 'primary', 5000)
        
        for id, marker in pairs(syncedMarkers) do
            print('^2Marker ID:^7 ' .. id .. ' | ^2Name:^7 ' .. (marker.name or 'Unknown') .. ' | ^2Type:^7 ' .. marker.type .. ' | ^2Coords:^7 ' .. marker.coords)
        end
    else
        QBCore.Functions.Notify('Markers not loaded yet', 'error', 5000)
    end
end, false)

-- Debug command to add a marker at current position (admin only)
RegisterCommand('addmarker', function(source, args)
    local markerType = tonumber(args[1]) or 1
    local r = tonumber(args[2]) or 255
    local g = tonumber(args[3]) or 0
    local b = tonumber(args[4]) or 0
    local a = tonumber(args[5]) or 200
    local jobRestricted = args[6] and args[6] == "true" or false
    local jobName = args[7] or nil
    
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    
    local newMarker = {
        name = "Custom Marker",
        type = markerType,
        coords = vector3(coords.x, coords.y, coords.z - 1.0),
        scale = vector3(1.5, 1.5, 1.0),
        color = {r = r, g = g, b = b, a = a},
        bobUpAndDown = false,
        faceCamera = false,
        rotate = false,
        drawOnEnts = false,
        job = jobRestricted,
        jobname = jobName
    }
    
    if Config.SyncEnabled then
        TriggerServerEvent('chilllixhub-markers:server:addMarker', newMarker)
        if jobRestricted and jobName then
            QBCore.Functions.Notify('Marker added for job: ' .. jobName, 'success', 5000)
        else
            QBCore.Functions.Notify('Marker added at your location', 'success', 5000)
        end
    else
        local newId = GetNextMarkerId()
        newMarker.id = newId
        syncedMarkers[newId] = newMarker
        QBCore.Functions.Notify('Marker added locally (sync disabled)', 'primary', 5000)
    end
    
    print('^2[ChilllixHub-Markers]^7 Added marker at: ' .. coords)
end, false)

-- Export functions for other resources to use
exports('GetMarkers', function()
    return syncedMarkers
end)

exports('AddMarker', function(markerData)
    if Config.SyncEnabled then
        TriggerServerEvent('chilllixhub-markers:server:addMarker', markerData)
    else
        local newId = GetNextMarkerId()
        markerData.id = newId
        syncedMarkers[newId] = markerData
    end
end)

exports('RemoveMarker', function(markerId)
    if Config.SyncEnabled then
        TriggerServerEvent('chilllixhub-markers:server:removeMarker', markerId)
    else
        syncedMarkers[markerId] = nil
    end
end)

exports('UpdateMarker', function(markerId, markerData)
    if Config.SyncEnabled then
        TriggerServerEvent('chilllixhub-markers:server:updateMarker', markerId, markerData)
    else
        syncedMarkers[markerId] = markerData
    end
end)
