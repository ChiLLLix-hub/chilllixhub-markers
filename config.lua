Config = {}

-- Marker Types Reference (FiveM Native DrawMarker types)
-- 0 = Cylinder
-- 1 = MarkerTypeUpsideDownCone
-- 2 = MarkerTypeVerticalCylinder
-- 3 = MarkerTypeThickChevronUp
-- 4 = MarkerTypeThinChevronUp
-- 5 = MarkerTypeCheckeredFlagRect
-- 6 = MarkerTypeCheckeredFlagCircle
-- 7 = MarkerTypeCheckeredCylinder
-- 8 = MarkerTypeSingleArrow
-- 9 = MarkerTypeDoubleArrow
-- 10 = MarkerTypeTripleArrow
-- 11 = MarkerTypeRing
-- 12 = MarkerTypeMarker
-- 13 = MarkerTypeMarkerFlat
-- 14 = MarkerTypeMarkerFloat
-- 15 = MarkerTypeMarkerFloat2
-- 16 = MarkerTypeMarkerFloat3
-- 17 = MarkerTypeMarkerFloat4
-- 18 = MarkerTypeMarkerFloat5
-- 19 = MarkerTypeMarkerFloat6
-- 20 = MarkerTypeMarkerFloat7
-- 21 = MarkerTypeMarkerFloat8
-- 22 = MarkerTypeMarkerFloat9
-- 23 = MarkerTypeMarkerFloat10
-- 24 = MarkerTypeMarkerFloat11
-- 25 = MarkerTypeHorizontalCircleFat
-- 26 = MarkerTypeReplayIcon
-- 27 = MarkerTypeHorizontalCircleSkinny
-- 28 = MarkerTypeHorizontalCircleSkinny_Arrow
-- 29 = MarkerTypeHorizontalSplitArrowCircle
-- 30 = MarkerTypeDebugSphere
-- 31 = MarkerTypeVerticalCylinder2
-- 32 = MarkerTypeVerticalCylinder3
-- 33 = MarkerTypeVerticalCylinder4
-- 34 = MarkerTypeVerticalCylinder5
-- 35 = MarkerTypeVerticalCylinder6
-- 36 = MarkerTypeVerticalCylinder7
-- 37 = MarkerTypeVerticalCylinder8
-- 38 = MarkerTypeVerticalCylinder9
-- 39 = MarkerTypeVerticalCylinder10
-- 40 = MarkerTypeVerticalCylinder11
-- 41 = MarkerTypeVerticalCylinder12
-- 42 = MarkerTypeVerticalCylinder13
-- 43 = MarkerTypeVerticalCylinder14

-- Marker Configuration
Config.Markers = {
    {
        name = "Example Marker 1",
        type = 1, -- MarkerTypeUpsideDownCone
        coords = vector3(0.0, 0.0, 0.0), -- Replace with your desired coordinates
        scale = vector3(1.5, 1.5, 1.0),
        color = {r = 255, g = 0, b = 0, a = 200}, -- Red color with transparency
        bobUpAndDown = false,
        faceCamera = false,
        rotate = true,
        drawOnEnts = false
    },
    {
        name = "Example Marker 2",
        type = 25, -- MarkerTypeHorizontalCircleFat
        coords = vector3(10.0, 10.0, 30.0),
        scale = vector3(2.0, 2.0, 1.0),
        color = {r = 0, g = 255, b = 0, a = 200}, -- Green color with transparency
        bobUpAndDown = false,
        faceCamera = false,
        rotate = false,
        drawOnEnts = false
    },
    {
        name = "Example Marker 3",
        type = 28, -- MarkerTypeHorizontalCircleSkinny_Arrow
        coords = vector3(20.0, 20.0, 30.0),
        scale = vector3(1.0, 1.0, 1.0),
        color = {r = 0, g = 0, b = 255, a = 200}, -- Blue color with transparency
        bobUpAndDown = false,
        faceCamera = false,
        rotate = true,
        drawOnEnts = false
    },
    -- Add more markers as needed
}

-- Sync Settings
Config.SyncEnabled = true -- Enable/disable marker synchronization between players
Config.SyncInterval = 1000 -- Sync interval in milliseconds (1000ms = 1 second)

-- Draw Settings
Config.DrawDistance = 100.0 -- Distance at which markers are visible
Config.RefreshRate = 0 -- Refresh rate in milliseconds (0 = every frame)
