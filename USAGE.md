# Usage Examples

## Basic Usage

### Adding Markers in Config

Edit `config.lua` and add your markers:

```lua
Config.Markers = {
    {
        name = "Police Station",
        type = 1, -- MarkerTypeUpsideDownCone
        coords = vector3(425.1, -979.5, 30.7), -- Mission Row PD
        scale = vector3(2.0, 2.0, 1.5),
        color = {r = 0, g = 100, b = 255, a = 200}, -- Blue
        bobUpAndDown = false,
        faceCamera = false,
        rotate = true,
        drawOnEnts = false
    },
    {
        name = "Hospital",
        type = 25, -- MarkerTypeHorizontalCircleFat
        coords = vector3(295.8, -584.9, 43.2), -- Pillbox Hospital
        scale = vector3(3.0, 3.0, 1.0),
        color = {r = 255, g = 0, b = 0, a = 200}, -- Red
        bobUpAndDown = false,
        faceCamera = false,
        rotate = false,
        drawOnEnts = false
    },
    {
        name = "Gas Station",
        type = 28, -- MarkerTypeHorizontalCircleSkinny_Arrow
        coords = vector3(49.4, 2778.7, 58.0), -- Sandy Shores Gas Station
        scale = vector3(1.5, 1.5, 1.0),
        color = {r = 0, g = 255, b = 0, a = 200}, -- Green
        bobUpAndDown = false,
        faceCamera = false,
        rotate = true,
        drawOnEnts = false
    }
}
```

### Adding Markers via Command (In-Game)

1. Go to the location where you want to place a marker
2. Use the command: `/addmarker [type] [r] [g] [b] [a]`

Examples:
```
/addmarker 1 255 0 0 200          # Red upside-down cone
/addmarker 25 0 255 0 200         # Green horizontal circle (fat)
/addmarker 28 0 0 255 200         # Blue horizontal circle with arrow
```

### Adding Markers via Export (From Another Script)

```lua
-- In your other resource's client-side script
exports['chilllixhub-markers']:AddMarker({
    name = "Custom Location",
    type = 1,
    coords = vector3(0.0, 0.0, 0.0),
    scale = vector3(1.5, 1.5, 1.0),
    color = {r = 255, g = 255, b = 0, a = 200}, -- Yellow
    bobUpAndDown = false,
    faceCamera = false,
    rotate = true,
    drawOnEnts = false
})
```

## Advanced Usage

### Getting All Markers

```lua
local markers = exports['chilllixhub-markers']:GetMarkers()
for id, marker in pairs(markers) do
    print("Marker " .. id .. ": " .. marker.name)
end
```

### Removing a Marker

```lua
-- Remove marker with ID 1
exports['chilllixhub-markers']:RemoveMarker(1)
```

### Updating a Marker

```lua
-- Update marker with ID 1
exports['chilllixhub-markers']:UpdateMarker(1, {
    name = "Updated Marker",
    type = 25,
    coords = vector3(100.0, 100.0, 30.0),
    scale = vector3(2.0, 2.0, 1.0),
    color = {r = 255, g = 0, b = 255, a = 200}, -- Purple
    bobUpAndDown = true,
    faceCamera = false,
    rotate = true,
    drawOnEnts = false
})
```

## Common Marker Types

| Type | Visual Description | Best Use Case |
|------|-------------------|---------------|
| 1 | Upside-down cone | Entry/exit points |
| 25 | Thick horizontal circle | Large areas, zones |
| 28 | Thin circle with arrow | Directional markers |
| 0 | Cylinder | General markers |
| 27 | Thin horizontal circle | Small zones |

## Color Examples

```lua
-- Red
color = {r = 255, g = 0, b = 0, a = 200}

-- Green
color = {r = 0, g = 255, b = 0, a = 200}

-- Blue
color = {r = 0, g = 0, b = 255, a = 200}

-- Yellow
color = {r = 255, g = 255, b = 0, a = 200}

-- Purple
color = {r = 255, g = 0, b = 255, a = 200}

-- Cyan
color = {r = 0, g = 255, b = 255, a = 200}

-- White
color = {r = 255, g = 255, b = 255, a = 200}

-- Orange
color = {r = 255, g = 165, b = 0, a = 200}
```

## Performance Tips

1. **Draw Distance**: Reduce `Config.DrawDistance` if you have many markers
2. **Refresh Rate**: Increase `Config.RefreshRate` if you don't need smooth animations
3. **Marker Count**: Keep the number of markers reasonable for best performance
4. **Sync Interval**: Increase `Config.SyncInterval` if real-time sync isn't critical

## Troubleshooting

### Markers not showing up

1. Check if the resource is started: `ensure chilllixhub-markers` in server.cfg
2. Verify coordinates are correct
3. Check if you're within draw distance
4. Use `/markerinfo` to see if markers are loaded

### Markers not syncing

1. Verify `Config.SyncEnabled = true` in config.lua
2. Check server console for errors
3. Ensure QBCore is properly installed

### Permission errors

1. Make sure QBCore permissions are set up correctly
2. Admin commands require 'admin' or 'god' permission in QBCore

## Integration Examples

### Job-Based Markers

```lua
-- Show markers only for specific jobs
CreateThread(function()
    while true do
        local PlayerData = QBCore.Functions.GetPlayerData()
        
        if PlayerData.job.name == "police" then
            exports['chilllixhub-markers']:AddMarker({
                name = "Police Evidence",
                type = 1,
                coords = vector3(x, y, z),
                scale = vector3(1.0, 1.0, 1.0),
                color = {r = 0, g = 100, b = 255, a = 200},
                bobUpAndDown = false,
                faceCamera = false,
                rotate = true,
                drawOnEnts = false
            })
        end
        
        Wait(60000) -- Check every minute
    end
end)
```

### Temporary Markers

```lua
-- Add a marker that disappears after 30 seconds
local markerId = nil

-- Add marker
exports['chilllixhub-markers']:AddMarker({
    name = "Temporary Marker",
    type = 1,
    coords = vector3(x, y, z),
    scale = vector3(1.0, 1.0, 1.0),
    color = {r = 255, g = 0, b = 0, a = 200},
    bobUpAndDown = true,
    faceCamera = false,
    rotate = false,
    drawOnEnts = false
})

-- Remove after 30 seconds
SetTimeout(30000, function()
    if markerId then
        exports['chilllixhub-markers']:RemoveMarker(markerId)
    end
end)
```
