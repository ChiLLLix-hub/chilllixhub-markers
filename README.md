# ChilllixHub Markers

A FiveM script with QBCore framework for placing configurable markers in the world with full synchronization support across all players.

## Features

- ✅ Fully configurable markers (type, location, color, scale, rotation, etc.)
- ✅ Support for various marker types including:
  - MarkerTypeUpsideDownCone
  - MarkerTypeHorizontalCircleFat
  - MarkerTypeHorizontalCircleSkinny_Arrow
  - And many more (43 different marker types)
- ✅ Real-time synchronization between all players on the server
- ✅ QBCore framework integration
- ✅ Admin commands for managing markers
- ✅ Export functions for other resources
- ✅ Performance optimized with distance-based rendering
- ✅ Easy configuration through config.lua

## Installation

1. Download or clone this repository
2. Place the `chilllixhub-markers` folder in your FiveM server's `resources` directory
3. Add `ensure chilllixhub-markers` to your `server.cfg`
4. Configure your markers in `config.lua`
5. Restart your server

## Configuration

Edit the `config.lua` file to customize your markers:

```lua
Config.Markers = {
    {
        name = "Example Marker 1",
        type = 1, -- MarkerTypeUpsideDownCone
        coords = vector3(0.0, 0.0, 0.0),
        scale = vector3(1.5, 1.5, 1.0),
        color = {r = 255, g = 0, b = 0, a = 200}, -- Red color with transparency
        bobUpAndDown = false,
        faceCamera = false,
        rotate = true,
        drawOnEnts = false
    },
    -- Add more markers here
}
```

### Marker Type Reference

| Type | Name | Description |
|------|------|-------------|
| 0 | Cylinder | Standard cylinder marker |
| 1 | MarkerTypeUpsideDownCone | Upside down cone |
| 25 | MarkerTypeHorizontalCircleFat | Thick horizontal circle |
| 28 | MarkerTypeHorizontalCircleSkinny_Arrow | Thin horizontal circle with arrow |

See `config.lua` for a complete list of all 43 marker types.

### Configuration Options

- **Config.SyncEnabled**: Enable/disable marker synchronization (default: true)
- **Config.SyncInterval**: Sync interval in milliseconds (default: 1000ms)
- **Config.DrawDistance**: Distance at which markers are visible (default: 100.0)
- **Config.RefreshRate**: Refresh rate in milliseconds (default: 0 = every frame)

## Commands

### Player Commands

- `/markerinfo` - Display information about active markers
- `/addmarker [type] [r] [g] [b] [a]` - Add a marker at your current position
  - Example: `/addmarker 1 255 0 0 200` (adds a red upside-down cone)

### Admin Commands

- `/reloadmarkers` - Reload markers from config (Admin only)

## Exports

The script provides several exports that can be used by other resources:

```lua
-- Get all active markers
local markers = exports['chilllixhub-markers']:GetMarkers()

-- Add a new marker
exports['chilllixhub-markers']:AddMarker({
    name = "My Marker",
    type = 1,
    coords = vector3(0.0, 0.0, 0.0),
    scale = vector3(1.5, 1.5, 1.0),
    color = {r = 255, g = 0, b = 0, a = 200},
    bobUpAndDown = false,
    faceCamera = false,
    rotate = true,
    drawOnEnts = false
})

-- Remove a marker by ID
exports['chilllixhub-markers']:RemoveMarker(1)

-- Update a marker
exports['chilllixhub-markers']:UpdateMarker(1, markerData)
```

## Server Events

### Server -> Client

- `chilllixhub-markers:client:receiveMarkers` - Sync markers to client

### Client -> Server

- `chilllixhub-markers:server:requestMarkers` - Request markers from server
- `chilllixhub-markers:server:addMarker` - Add a new marker
- `chilllixhub-markers:server:removeMarker` - Remove a marker
- `chilllixhub-markers:server:updateMarker` - Update a marker

## Dependencies

- [qb-core](https://github.com/qbcore-framework/qb-core) - QBCore Framework

## Performance

The script is optimized for performance:
- Markers only render within the configured draw distance
- No unnecessary calculations when players are far from markers
- Efficient synchronization system
- Low resource usage

## Support

For issues, suggestions, or contributions, please visit the [GitHub repository](https://github.com/ChiLLLix-hub/chilllixhub-markers).

## License

See LICENSE file for details.

## Credits

Created by ChiLLLix-hub
