MapController = {}

--// link the map graphics library //--
graphics = require("GameStates/Game/MapGraphics")
Queue = require("Mathematics/Queue")


----//// ############################################### ////----
----//// MAP VARIABLES AND CONSTANTS, IMAGES AND COLOURS ////----
----//// ############################################### ////----
MapController.VisibleTiles = Queue.New()
MapController.VisibleDetails = Queue.New()
MapController.UpdatedTiles = {}
MapController.CurrentMap = {}
MapController.CurrentMap.Tiles = {}
MapController.CurrentMap.TileCanvases = {}
MapController.CurrentMap.Details = {}
MapController.CurrentMap.Gameplay = {}
MapController.CurrentMap.MapSize = Vector.New(graphics.KILOMETRE * 2.5, graphics.KILOMETRE * 2.5)---initial size---

MapController.Textures = {}
MapController.Textures.Grass = love.image.newImageData("Assets/Images/MapTextures/GrassTexture.png")
MapController.Textures.Forest = love.image.newImageData("Assets/Images/MapTextures/ForestTexture.png")
MapController.Textures.BlueWater = love.image.newImageData("Assets/Images/MapTextures/BlueWaterTexture.png")
MapController.Textures.Sand = love.image.newImageData("Assets/Images/MapTextures/SandTexture.png")
MapController.Textures.Path = love.image.newImageData("Assets/Images/MapTextures/Path.png")
MapController.Textures.Road = love.image.newImageData("Assets/Images/MapTextures/Road.png")

MapController.Details = {}
MapController.Details.DetailIndex = 1
MapController.Details.List = {
"DeciduousTree1","DeciduousTree2","DeciduousTree3","DeciduousTree4","DeciduousTree5","DeciduousTree6",
"EvergreenTree1","EvergreenTree2",
"House1","House2","House3","House4","House5","House6",
}

MapController.Details.DeciduousTree1 = love.graphics.newImage("Assets/Images/MapDetails/OakTree1_Summer.png")
MapController.Details.DeciduousTree2 = love.graphics.newImage("Assets/Images/MapDetails/OakTree2_Summer.png")
MapController.Details.DeciduousTree3 = love.graphics.newImage("Assets/Images/MapDetails/AshTree1_Summer.png")
MapController.Details.DeciduousTree4 = love.graphics.newImage("Assets/Images/MapDetails/AshTree2_Summer.png")
MapController.Details.DeciduousTree5 = love.graphics.newImage("Assets/Images/MapDetails/BirchTree1_Summer.png")
MapController.Details.DeciduousTree6 = love.graphics.newImage("Assets/Images/MapDetails/BeechTree1_Summer.png")

MapController.Details.EvergreenTree1 = love.graphics.newImage("Assets/Images/MapDetails/FirTree1_Summer.png")
MapController.Details.EvergreenTree2 = love.graphics.newImage("Assets/Images/MapDetails/FirTree2_Summer.png")

MapController.Details.House1 = love.graphics.newImage("Assets/Images/MapDetails/ty1.png")
MapController.Details.House2 = love.graphics.newImage("Assets/Images/MapDetails/ty2.png")
MapController.Details.House3 = love.graphics.newImage("Assets/Images/MapDetails/ty3.png")
MapController.Details.House4 = love.graphics.newImage("Assets/Images/MapDetails/ty4.png")
MapController.Details.House5 = love.graphics.newImage("Assets/Images/MapDetails/ty5.png")
MapController.Details.House6 = love.graphics.newImage("Assets/Images/MapDetails/ty6.png")

MapController.Gameplay = {}
MapController.Gameplay.TeamABrigadeCount = 0
MapController.Gameplay.TeamBBrigadeCount = 0
MapController.Gameplay.ObjectiveCount = 0
MapController.Gameplay.GameIndex = 1
MapController.Gameplay.List = {
"TeamABrigade","TeamBBrigade","Objective"
}

for i = 1, 16, 1 do MapController.Gameplay["TeamABrigade"..tostring(i)] = love.graphics.newImage("Assets/Images/MapGameplay/TeamA_Brigade"..tostring(i)..".png") end
for i = 1, 16, 1 do MapController.Gameplay["TeamBBrigade"..tostring(i)] = love.graphics.newImage("Assets/Images/MapGameplay/TeamB_Brigade"..tostring(i)..".png") end
for i = 1, 16, 1 do MapController.Gameplay["Objective"..tostring(i)] = love.graphics.newImage("Assets/Images/MapGameplay/Objective"..tostring(i)..".png") end


MapController.Colours = {}
MapController.Colours.Grass = Colours.CreateColour({0.3,0.7,0.3,1})
MapController.Colours.Forest = Colours.CreateColour({0.1,0.4,0.1,1})
MapController.Colours.BlueWater = Colours.CreateColour({0.2,0.3,0.6,1})
MapController.Colours.Sand = Colours.CreateColour({0.3,0.7,0.3,1})
MapController.Colours.Path = Colours.CreateColour({0.5,0.5,0.3,1})
MapController.Colours.Road = Colours.CreateColour({0.3,0.3,0.3,1})



----//// ##################### ////----
----//// MAP IMAGING FUNCTIONS ////----
----//// ##################### ////----

-- this method will return the tiles to be drawn in main.lua --
function MapController.ReturnTiles( )
    local tileZoom = CameraZoom * graphics.MapScaleFactor
    local newQ = Queue.New()

    -- loop through the map list --
    for y = 1, #MapController.CurrentMap.Tiles, 1 do
        for x = 1, #MapController.CurrentMap.Tiles[y], 1 do

            local indexTile = MapController.CurrentMap.Tiles[y][x]
            if graphics.CheckIfOnScreen( indexTile ) then 
                local pos = Vector.New( (x-1) * graphics.MapTileSize, (y-1) * graphics.MapTileSize)
                pos:ToScreenPosition()
                indexTile.DrawPos = pos
                newQ:EnQ( indexTile ) 
            end
        end
    end

    return newQ, tileZoom
end


-- the next method will return a queue of all the details, this is so it can be drawn in-sync with units to get them done in order --
function MapController.ReturnDetails( camMoved )
    local detailZoom = CameraZoom * graphics.DetailScaleFactor
    local newQ = Queue.New()

    -- loop through the details and enq the visible details --
    for i = 1, #MapController.CurrentMap.Details, 1 do
        local detail = MapController.CurrentMap.Details[i]
        if graphics.CheckIfDetailOnScreen( detail ) then 
            local pos = Vector.New(detail.Pos.X, detail.Pos.Y)
            pos:ToScreenPosition()
            detail.DrawPos = pos
            newQ:EnQ( detail ) 
        end
    end
    
    return newQ, detailZoom
end










----//// ################# ////----
----//// LOAD MAP FUNCTION ////----
----//// ################# ////----
function MapController.LoadMap(filepath)
    local data = love.filesystem.read(filepath)
    if not data then
        print("Failed to load file: " .. filepath)
        return false
    end

    local decompressed = love.data.decompress("string", "deflate", data)
    if not decompressed then
        print("Failed to decompress data")
        return false
    end

    -- parse map size --
    local mapSizeStart = decompressed:find("%$MAPSIZE=")
    if mapSizeStart then
        local start = mapSizeStart + 9
        local endPos = decompressed:find("%$", start) or #decompressed + 1
        local str = decompressed:sub(start, endPos - 1)
        local chunk, err = load("return " .. str)
        if not chunk then
            print("Failed to parse map size:", err)
            return false
        end
        local ok, mapSize = pcall(chunk)
        if not ok then
            print("Failed to execute map size chunk:", mapSize)
            return false
        end
        MapController.CurrentMap.MapSize = Vector.New(mapSize[1], mapSize[2])
    end

    -- initialize map tiles --
    MapController.CurrentMap.Tiles = graphics.InitialiseMap(MapController.CurrentMap.MapSize)
    local tileList = graphics.ListTiles(MapController.CurrentMap.Tiles)
    for i = 1, #tileList do
        graphics.UpdateTileCanvas(tileList[i])
    end

    -- parse terrain --
    local terrainStart = decompressed:find("%$TERRAIN=")
    if terrainStart then
        local start = terrainStart + 9
        local endPos = decompressed:find("%$", start) or #decompressed + 1
        local str = decompressed:sub(start, endPos - 1)
        local chunk, err = load("return " .. str)
        if not chunk then
            print("Failed to parse terrain:", err)
            return false
        end
        local ok, terrain = pcall(chunk)
        if not ok then
            print("Failed to execute terrain chunk:", terrain)
            return false
        end
        for y = 1, #terrain do
            for x = 1, #terrain[y] do
                local tileData = terrain[y][x]
                local tile = MapController.CurrentMap.Tiles[y][x]
                local pxSize = #tile.Pixels
                local pySize = #tile.Pixels[1]
                local index = 1
                for px = 1, pxSize do
                    for py = 1, pySize do
                        tile.Pixels[px][py] = tileData[index]
                        index = index + 1
                    end
                end
                graphics.UpdateTileCanvas(tile)
            end
        end
    end

    -- parse details --
    local detailsStart = decompressed:find("%$DETAILS=")
    if detailsStart then
        local start = detailsStart + 9
        local endPos = decompressed:find("%$", start) or #decompressed + 1
        local str = decompressed:sub(start, endPos - 1)
        local chunk, err = load("return " .. str)
        if not chunk then
            print("Failed to parse details:", err)
            return false
        end
        local ok, details = pcall(chunk)
        if not ok then
            print("Failed to execute details chunk:", details)
            return false
        end
        print("Loaded " .. #details .. " details from save file")
        MapController.CurrentMap.Details = {}
        for i = 1, #details do
            local detail = details[i]
            if detail.Pos and detail.Type and MapController.Details[detail.Type] then
                detail.Pos = Vector.New(detail.Pos[1], detail.Pos[2])
                detail.Image = MapController.Details[detail.Type]
                table.insert(MapController.CurrentMap.Details, detail)
            else
                print("Warning: Invalid or missing detail at index " .. i .. " (Type=" .. tostring(detail.Type) .. "), skipping")
            end
        end
    end

    -- parse gameplay --
    local gameplayStart = decompressed:find("%$GAMEPLAY=")
    if gameplayStart then
        local start = gameplayStart + 10
        local endPos = decompressed:find("%$", start) or #decompressed + 1
        local str = decompressed:sub(start, endPos - 1)
        local chunk, err = load("return " .. str)
        if not chunk then
            print("Failed to parse gameplay:", err)
            return false
        end
        local ok, gameplay = pcall(chunk)
        if not ok then
            print("Failed to execute gameplay chunk:", gameplay)
            return false
        end
        print("Loaded " .. #gameplay .. " gameplay elements from save file")
        MapController.CurrentMap.Gameplay = {}
        for i = 1, #gameplay do
            local gameplayElement = gameplay[i]
            if gameplayElement.Pos and gameplayElement.Type and MapController.Gameplay[gameplayElement.Type] then
                gameplayElement.Pos = Vector.New(gameplayElement.Pos[1], gameplayElement.Pos[2])
                gameplayElement.Image = MapController.Gameplay[gameplayElement.Type]
                table.insert(MapController.CurrentMap.Gameplay, gameplayElement)
            else
                print("Warning: Invalid or missing gameplay element at index " .. i .. " (Type=" .. tostring(gameplayElement.Type) .. "), skipping")
            end
        end
    end

    MapController.ReturnTiles(true)
    MapController.ReturnDetails(true)

    print("Map loaded successfully from: " .. filepath)
    return true
end




return MapController