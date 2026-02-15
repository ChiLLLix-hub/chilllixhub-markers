# Changelog

All notable changes to this project will be documented in this file.

## [1.0.0] - 2026-02-15

### Added
- Initial release of ChilllixHub Markers
- Full QBCore framework integration
- Support for 43 different marker types including:
  - MarkerTypeUpsideDownCone (type 1)
  - MarkerTypeHorizontalCircleFat (type 25)
  - MarkerTypeHorizontalCircleSkinny_Arrow (type 28)
- Configurable marker attributes:
  - Position/coordinates
  - Color (RGBA)
  - Scale
  - Rotation
  - Bob up and down animation
  - Face camera option
  - Draw on entities option
- Real-time synchronization between all players on the server
- Server-side marker management with events:
  - Add markers
  - Remove markers
  - Update markers
  - Request markers
- Client-side rendering with distance-based optimization
- Admin commands:
  - `/reloadmarkers` - Reload markers from config
- Player commands:
  - `/markerinfo` - View active markers information
  - `/addmarker` - Add markers at current position
- Export functions for integration with other resources:
  - `GetMarkers()` - Get all active markers
  - `AddMarker()` - Add a new marker
  - `RemoveMarker()` - Remove a marker
  - `UpdateMarker()` - Update marker properties
- Performance optimizations:
  - Configurable draw distance
  - Configurable refresh rate
  - Distance-based rendering
- Comprehensive documentation:
  - README.md with full feature list
  - USAGE.md with examples and integration guides
  - In-line code documentation
- QBCore permission system integration for admin commands

### Features
- Easy configuration through config.lua
- Full multiplayer synchronization support
- Low resource usage
- Clean and maintainable code structure
- Separation of client and server logic

### Technical Details
- Built for FiveM using Lua 5.4
- Uses native GTA V DrawMarker function
- Thread-based rendering system
- Event-driven synchronization
- QBCore exports integration
