
---/// IMPORT LIBRARIES ///---


-- Core Libraries --
graphics = require("EditorLibraries/EditorGraphics")
Mathematics = require("EditorLibraries/EditorMaths")
mouse = require("EditorLibraries/EditorMouse")
keyboard = require("EditorLibraries/EditorKeyboard")
Vector = require("EditorLibraries/Vector")
InputManager = require("EditorLibraries/InputManager")

-- UI Libraries --
Colours = require("EditorInterface/Colours")
Font = require("EditorInterface/Font")
--ImageBox = require("EditorInterface/ImageBox")
TextBox = require("EditorInterface/TextBox")
Screen = require("EditorInterface/Screen")
EditorScreen = require("InterfaceObjects/EditorScreen")

---/// EDITOR VARIABLES ///---
MAP_NAME = "Wissembourg"
LOAD_MODE = "emptymap"--options, emptymap, loads emptymap, loadmap loads a map given by map name

viewMode = "editor"
forestType = "Deciduous"
fkeydown = false
cycleDebounce = false
detail_game_debounce = false

mapCanvas = nil
currentMode = nil

CameraMoved = false
CameraZoom = 1
CameraPosition = Vector.New(0,0,0)

TimeOfDay = 1000

--MapScaleFactor = 4
--MapTileSize = 256


--BRUSH AND MAP SCALES--
BrushSize = 100
PreviousBrushSize = BrushSize
ROAD_WIDTH =  graphics.ROAD_WIDTH 
PPM = graphics.KILOMETRE / 1000


MapEditor = {}

MapEditor.UpdatedTiles = {}
MapEditor.CurrentMap = {}
MapEditor.CurrentMap.Tiles = {}
MapEditor.CurrentMap.TileCanvases = {}
MapEditor.CurrentMap.Details = {}
MapEditor.CurrentMap.Gameplay = {}
MapEditor.CurrentMap.MapSize = Vector.New(graphics.KILOMETRE * 5, graphics.KILOMETRE * 5)---initial size---

MapEditor.Textures = {}
MapEditor.Textures.Grass = love.image.newImageData("MapTextures/GrassTexture.png")
MapEditor.Textures.Forest = love.image.newImageData("MapTextures/ForestTexture.png")
MapEditor.Textures.BlueWater = love.image.newImageData("MapTextures/BlueWaterTexture.png")
MapEditor.Textures.Sand = love.image.newImageData("MapTextures/SandTexture.png")
MapEditor.Textures.Path = love.image.newImageData("MapTextures/Path.png")
MapEditor.Textures.Road = love.image.newImageData("MapTextures/Road.png")
MapEditor.Textures.Wheat = love.image.newImageData("MapTextures/Farmland.png")

MapEditor.Details = {}
MapEditor.Details.DetailIndex = 1
MapEditor.Details.List = {
--"DeciduousTree1","DeciduousTree2","DeciduousTree3","DeciduousTree4","DeciduousTree5","DeciduousTree6",
"DeciduousGrove1","DeciduousGrove2","DeciduousGrove3","DeciduousGrove4",
"EvergreenTree1","EvergreenTree2",

"House1","House2","House3","House4","House5","House6",
"House7","House8","House9","House10","House11","House12",
"House13","House14","House15","House16","House17",

"Restaurant1","Restaurant2",

"Church1",

"Track0","Track45","Track90","Track135",

"Wheat",
}
--[[
MapEditor.Details.DeciduousTree1 = love.graphics.newImage("MapDetails/OakTree1_Summer.png")
MapEditor.Details.DeciduousTree2 = love.graphics.newImage("MapDetails/OakTree2_Summer.png")
MapEditor.Details.DeciduousTree3 = love.graphics.newImage("MapDetails/AshTree1_Summer.png")
MapEditor.Details.DeciduousTree4 = love.graphics.newImage("MapDetails/AshTree2_Summer.png")
MapEditor.Details.DeciduousTree5 = love.graphics.newImage("MapDetails/BirchTree1_Summer.png")
MapEditor.Details.DeciduousTree6 = love.graphics.newImage("MapDetails/BeechTree1_Summer.png")]]

MapEditor.Details.DeciduousGrove1 = love.graphics.newImage("MapDetails/DeciduousGrove1.png")
MapEditor.Details.DeciduousGrove2 = love.graphics.newImage("MapDetails/DeciduousGrove2.png")
MapEditor.Details.DeciduousGrove3 = love.graphics.newImage("MapDetails/DeciduousGrove3.png")
MapEditor.Details.DeciduousGrove4 = love.graphics.newImage("MapDetails/DeciduousGrove4.png")

MapEditor.Details.EvergreenTree1 = love.graphics.newImage("MapDetails/FirTree1_Summer.png")
MapEditor.Details.EvergreenTree2 = love.graphics.newImage("MapDetails/FirTree2_Summer.png")

for i = 1,17, 1 do MapEditor.Details["House"..tostring(i)] = love.graphics.newImage("MapDetails/ty"..tostring(i)..".png") end

MapEditor.Details.Restaurant1 = love.graphics.newImage("MapDetails/Restaurant1.png")
MapEditor.Details.Restaurant2 = love.graphics.newImage("MapDetails/Restaurant2.png")

MapEditor.Details.Church1 = love.graphics.newImage("MapDetails/Church1.png")

MapEditor.Details.Track0 = love.graphics.newImage("MapDetails/Track0.png")
MapEditor.Details.Track45 = love.graphics.newImage("MapDetails/Track45.png")
MapEditor.Details.Track90 = love.graphics.newImage("MapDetails/Track90.png")
MapEditor.Details.Track135 = love.graphics.newImage("MapDetails/Track135.png")

MapEditor.Details.Wheat = love.graphics.newImage("MapDetails/Wheat.png")


MapEditor.Gameplay = {}
MapEditor.Gameplay.TeamABrigadeCount = 0
MapEditor.Gameplay.TeamBBrigadeCount = 0
MapEditor.Gameplay.ObjectiveCount = 0
MapEditor.Gameplay.GameIndex = 1
MapEditor.Gameplay.List = {
"TeamABrigade","TeamBBrigade","Objective"
}

for i = 1, 16, 1 do MapEditor.Gameplay["TeamABrigade"..tostring(i)] = love.graphics.newImage("MapGameplay/TeamA_Brigade"..tostring(i)..".png") end
for i = 1, 16, 1 do MapEditor.Gameplay["TeamBBrigade"..tostring(i)] = love.graphics.newImage("MapGameplay/TeamB_Brigade"..tostring(i)..".png") end
for i = 1, 16, 1 do MapEditor.Gameplay["Objective"..tostring(i)] = love.graphics.newImage("MapGameplay/Objective"..tostring(i)..".png") end

MapEditor.Colours = {}
MapEditor.Colours.Grass = Colours.CreateColour({0.3,0.7,0.3,1})
MapEditor.Colours.Forest = Colours.CreateColour({0.1,0.4,0.1,1})
MapEditor.Colours.BlueWater = Colours.CreateColour({0.2,0.3,0.6,1})
MapEditor.Colours.Sand = Colours.CreateColour({0.3,0.7,0.3,1})
MapEditor.Colours.Path = Colours.CreateColour({0.5,0.5,0.3,1})
MapEditor.Colours.Road = Colours.CreateColour({0.3,0.3,0.3,1})


TestBattalion = love.graphics.newImage("test3.png")



---/// ################################### ///---
---/// ################################### ///---
---/// LOVE FUNCTIONS, END OF DECLERATIONS ///---
---/// ################################### ///---
---/// ################################### ///---

function love.load()
    local success = love.window.setFullscreen(true)--set the screen to full screen--
    ScreenX, ScreenY = love.graphics.getDimensions()
    love.graphics.setDefaultFilter("nearest", "nearest")--removes anti aliasing--


    --setup map--
    if LOAD_MODE == "emptymap" then
        MapEditor.CurrentMap.Tiles = graphics.InitialiseMap(MapEditor.CurrentMap.MapSize)
        local tileList = graphics.ListTiles(MapEditor.CurrentMap.Tiles)
        for i=1,#tileList,1 do graphics.UpdateTileCanvas(tileList[i]) end
    else
        loadMap(MAP_NAME..".map")
    end
end 


function love.draw()
    graphics.DrawMap(MapEditor.CurrentMap.Tiles,CameraMoved)
 
    EditorScreen.Screen:DrawScreen()
    graphics.DrawScale()

    love.graphics.draw(TestBattalion)
end

local mouseDebounce = false

function love.update(dt)
    CameraMoved = false

    local mouseDown, mouseX, mouseY = mouse.Button1Down()
    local mouseDownUI = mouseDown
    local mousePos = Vector.New(mouseX,mouseY)
    interactions = EditorScreen.Screen:CheckForMouse(mousePos,mouseDownUI)
    returnDown = love.keyboard.isDown( "return" )

    --mouse debounce--
    if mouseDown then
        if not mouseDebounce then mouseDebounce = true
        else mouseDownUI = false end
    else
        cycleDebounce = false
        mouseDebounce = false
        detail_game_debounce = false
    end


    --loop through the interactions, there should only be one at a time though--
    for i = 1,#interactions,1 do

        --change mode to whatever button was clicked--
        if interactions[i].Name=="newForest" then
            currentMode = "Forest" EditorScreen.Screen.Visible = false  break
        elseif interactions[i].Name=="newGrass" then
            currentMode = "Grass" EditorScreen.Screen.Visible = false break

        elseif interactions[i].Name=="newWheat" then
            currentMode = "Wheat" EditorScreen.Screen.Visible = false break
        elseif interactions[i].Name=="newPotato" then
            currentMode = "Potato" EditorScreen.Screen.Visible = false break


        elseif interactions[i].Name=="newPath" then
            currentMode = "Path" EditorScreen.Screen.Visible = false break
        elseif interactions[i].Name=="newRoad" then
            currentMode = "Road" EditorScreen.Screen.Visible = false break

        elseif interactions[i].Name=="newStream" then
            currentMode = "Stream" EditorScreen.Screen.Visible = false break
        elseif interactions[i].Name=="newSand" then
            currentMode = "Sand" EditorScreen.Screen.Visible = false break


        elseif interactions[i].Name=="layerTerrain" then
            EditorScreen.ChangeLayer("Terrain")
            cycleDebounce = true
        elseif interactions[i].Name=="layerDetails" then
            EditorScreen.ChangeLayer("Details")
            currentMode = "AddDetail"
            cycleDebounce = true
        elseif interactions[i].Name=="layerGameplay" then
            EditorScreen.ChangeLayer("Gameplay")
            currentMode = "AddGameplay"
            cycleDebounce = true


        elseif interactions[i].Name == "cycleDetail" then
            if not cycleDebounce then
                cycleDebounce = true

                MapEditor.Details.DetailIndex = MapEditor.Details.DetailIndex + 1
                if MapEditor.Details.DetailIndex > #MapEditor.Details.List then MapEditor.Details.DetailIndex = 1 end
                
                for i = 1, #EditorScreen.Screen.UiObjects, 1 do
                    if EditorScreen.Screen.UiObjects[i].Name == "detailIcon" then
                        EditorScreen.Screen.UiObjects[i].Image = MapEditor.Details[MapEditor.Details.List[MapEditor.Details.DetailIndex]]
                        EditorScreen.Screen.UiObjects[i]:CreateCanvas()
                    end
                end
            end

        elseif interactions[i].Name == "cycleGameplay" then
            if not cycleDebounce then
                cycleDebounce = true

                MapEditor.Gameplay.GameIndex = MapEditor.Gameplay.GameIndex + 1
                if MapEditor.Gameplay.GameIndex > #MapEditor.Gameplay.List then MapEditor.Gameplay.GameIndex = 1 end
                
                for i = 1, #EditorScreen.Screen.UiObjects, 1 do
                    if EditorScreen.Screen.UiObjects[i].Name == "gameIcon" then
                        EditorScreen.Screen.UiObjects[i].Text = MapEditor.Gameplay[MapEditor.Gameplay.List[MapEditor.Gameplay.GameIndex]]
                        EditorScreen.Screen.UiObjects[i]:CreateCanvas()
                    end
                end
            end


        elseif interactions[i].Name == "undoDetail" then
            if not cycleDebounce then
                cycleDebounce = true
                table.remove(MapEditor.CurrentMap.Details,#MapEditor.CurrentMap.Details)
            end

        elseif interactions[i].Name == "undoGameplay" then
            if not cycleDebounce then
                cycleDebounce = true
                if MapEditor.CurrentMap.Gameplay[#MapEditor.CurrentMap.Gameplay].Type:sub(1,6) == "TeamABr" then
                    MapEditor.Gameplay.TeamABrigadeCount=MapEditor.Gameplay.TeamABrigadeCount-2
                elseif MapEditor.CurrentMap.Gameplay[#MapEditor.CurrentMap.Gameplay].Type:sub(1,6) == "TeamBBr" then
                    MapEditor.Gameplay.TeamBBrigadeCount=MapEditor.Gameplay.TeamBBrigadeCount-2
                end
                table.remove(MapEditor.CurrentMap.Gameplay,#MapEditor.CurrentMap.Gameplay)
            end



        elseif interactions[i].Name=="saveMap" then
            saveMap()
        end

    end


    ---/// ########################################## ///---
    ---/// ADD PIXEL FROM MOUSE POSITION TO MAP TILES ///---
    ---/// ########################################## ///---
    if (mouseDown) and (not EditorScreen.Screen.Visible) and (#interactions == 0) and (currentMode ~= "AddDetail") and (currentMode ~= "AddGameplay") then
        local posTable = getBrushIndexes(mousePos)

        for i=1,#posTable,1 do
            local changed = graphics.ChangeTilePixel(MapEditor.CurrentMap.Tiles,posTable[i],currentMode)
            if changed then
                --only insert a copy of the changed tile if its not already in the changed table--
                local found = false
                for i=1,#MapEditor.UpdatedTiles,1 do
                    if MapEditor.UpdatedTiles[i].IndexPosition==changed.IndexPosition then 
                        found = true 
                        MapEditor.UpdatedTiles[i].Pixels = changed.Pixels
                        break 
                    end
                end 
                if not found then table.insert(MapEditor.UpdatedTiles,changed) end

                --if the brush type is forest, add tree details randomly--
                --[[if ( currentMode == "Forest" ) and ( math.random(1, (15000*(CameraZoom*6)) ) == 1 ) then
                    if forestType == "Evergreen" then
                        local treeran = math.random(1,2)
                        graphics.CreateDetail(posTable[i],"EvergreenTree"..tostring(treeran))
                    else
                        local treeran = math.random(1,6)
                        graphics.CreateDetail(posTable[i],"DeciduousTree"..tostring(treeran))
                    end
                end]]

            end
        end 
    end



    ---/// ####################################### ///---
    ---/// ADD DETAILS AND GAMEPLAY MY MOUSE CLICK ///---
    ---/// ####################################### ///---
    if ( mouseDown ) and ( ( currentMode == "AddDetail" ) or ( currentMode == "AddGameplay" ) ) and ( not cycleDebounce ) then
        if not detail_game_debounce then
            detail_game_debounce = true

            if currentMode == "AddDetail" then
                local newPos = mousePos
                newPos:ToGamePosition()
                graphics.CreateDetail(newPos, MapEditor.Details.List[ MapEditor.Details.DetailIndex ])
            end

            if currentMode == "AddGameplay" then
                local listItem = MapEditor.Gameplay.List[ MapEditor.Gameplay.GameIndex ]

                if ( listItem == "TeamABrigade" ) then
                    MapEditor.Gameplay.TeamABrigadeCount=MapEditor.Gameplay.TeamABrigadeCount+1
                    listItem = listItem..tostring(MapEditor.Gameplay.TeamABrigadeCount)
                end
                if ( listItem == "TeamBBrigade" ) then
                    MapEditor.Gameplay.TeamBBrigadeCount=MapEditor.Gameplay.TeamBBrigadeCount+1
                    listItem = listItem..tostring(MapEditor.Gameplay.TeamBBrigadeCount)
                end
                if ( listItem == "Objective" ) then
                    MapEditor.Gameplay.ObjectiveCount=MapEditor.Gameplay.ObjectiveCount+1
                    listItem = listItem..tostring(MapEditor.Gameplay.ObjectiveCount)
                end

                local newPos = mousePos
                newPos:ToGamePosition()
                graphics.CreateGameplay(newPos, listItem)
            end

        end 
    end 



    --update the canvases for the tiles that have been changed--
    if ( not mouseDown ) and ( #MapEditor.UpdatedTiles > 0 ) then
        for i = 1,#MapEditor.UpdatedTiles,1 do
            graphics.UpdateTileCanvas(MapEditor.UpdatedTiles[i]) 
        end 

        MapEditor.CurrentMap.Details = graphics.OrderDetails( MapEditor.CurrentMap.Details )
        MapEditor.UpdatedTiles = {}
    end 

    InputControl.ApplyAllInputs()

    --Enter key resets Current Mode and restores the menu--
    if love.keyboard.isDown("return") then
        currentMode = nil
        EditorScreen.Screen.Visible = true
    end

    --F Key changes the type of forest spawned--

    if ( love.keyboard.isDown("f") ) then
        if not fkeydown then
            fkeydown = true
            if forestType == "Evergreen" then
                forestType = "Deciduous"
            else 
                forestType = "Evergreen"
            end
            print(forestType)
        end
    else
        fkeydown = false
    end


end




--wheel moved (mouse wheel) for changing the brush size--
function love.wheelmoved( dx, dy )
    BrushSize = BrushSize + ( dy * 8 )
    PreviousBrushSize = BrushSize
end


function getBrushIndexes(mousePos)
    local centre = mousePos
    local positions = {centre}
    local currentBrushSize = BrushSize
    local fillMode = "Circle"

    if ( currentMode == "Road" ) or ( currentMode == "Path" ) then
        currentBrushSize = ROAD_WIDTH
        fillMode = "Square"
    else
        currentBrushSize = PreviousBrushSize
    end 


    --get all posible positions from the brush--

    local newPositions = {}
    if fillMode == "Circle" then
        local screenBrushSize = ( currentBrushSize * CameraZoom ) / graphics.MapScaleFactor
        for theta = 0,math.pi*2,0.1 do
            for magnitude = 0,screenBrushSize,0.8 do
                local newPos = mousePos
                hyp = Mathematics.VectorFromAngle(magnitude, theta)
                newPos = Mathematics.VectorFromAddition(newPos,hyp)
                newPos.X = math.floor(newPos.X)
                newPos.Y = math.floor(newPos.Y)
                table.insert(positions, newPos)
            end 
        end 

        --remove duplicates--
        for i1=1,#positions,1 do
            local found = false
            for i2=1,#newPositions,1 do
                if positions[i1]==newPositions[i2] then found = true  end
            end 
            if not found then table.insert(newPositions, positions[i1]) end
        end 
    else
        local centreY = mousePos.Y
        local centreX = mousePos.X

        local screenBrushSize = math.ceil((currentBrushSize * CameraZoom) / 2) / graphics.MapScaleFactor

        for y=centreY-screenBrushSize,centreY+screenBrushSize,1 do
            for x=centreX-screenBrushSize,centreX+screenBrushSize,1 do
                local newPos = Vector.New(x,y)
                table.insert(newPositions,newPos)
            end 
        end
    end


    return newPositions
end



-- function that saves that map by compiling all its data into a formatted string, saved to a file location --
function saveMap()
    local mapDataParts = {}

    -- add map size --
    table.insert(mapDataParts, "$MAPSIZE={" .. tostring(MapEditor.CurrentMap.MapSize.X) .. "," .. tostring(MapEditor.CurrentMap.MapSize.Y) .. "}")

    -- add terrain information --
    local terrainTable = {}
    for y = 1, #MapEditor.CurrentMap.Tiles do
        local rowTable = {}
        for x = 1, #MapEditor.CurrentMap.Tiles[y] do
            local tileTable = {}
            local tile = MapEditor.CurrentMap.Tiles[y][x]
            for px = 1, #tile.Pixels do
                for py = 1, #tile.Pixels[px] do
                    table.insert(tileTable, string.format("%q", tile.Pixels[px][py]))
                end
            end
            table.insert(rowTable, "{" .. table.concat(tileTable, ",") .. "}")
        end
        table.insert(terrainTable, "{" .. table.concat(rowTable, ",") .. "}")
    end
    table.insert(mapDataParts, "$TERRAIN={" .. table.concat(terrainTable, ",") .. "}")

    -- add details information --
    local detailsTable = {}
    for i = 1, #MapEditor.CurrentMap.Details do
        local detail = MapEditor.CurrentMap.Details[i]
        print("Saving detail " .. i .. ": Type=" .. tostring(detail.Type) .. ", Pos={" .. tostring(detail.Pos.X) .. "," .. tostring(detail.Pos.Y) .. "}")
        local detailEntry = "{Type=" .. string.format("%q", detail.Type) .. ",Pos={" .. tostring(detail.Pos.X) .. "," .. tostring(detail.Pos.Y) .. "}}"
        table.insert(detailsTable, detailEntry)
    end
    table.insert(mapDataParts, "$DETAILS={" .. table.concat(detailsTable, ",") .. "}")

    -- add gameplay information --
    local gameplayTable = {}
    for i = 1, #MapEditor.CurrentMap.Gameplay do
        local gameplay = MapEditor.CurrentMap.Gameplay[i]
        print("Saving gameplay " .. i .. ": Type=" .. tostring(gameplay.Type) .. ", Pos={" .. tostring(gameplay.Pos.X) .. "," .. tostring(gameplay.Pos.Y) .. "}")
        local gameplayEntry = "{Type=" .. string.format("%q", gameplay.Type) .. ",Pos={" .. tostring(gameplay.Pos.X) .. "," .. tostring(gameplay.Pos.Y) .. "}}"
        table.insert(gameplayTable, gameplayEntry)
    end
    table.insert(mapDataParts, "$GAMEPLAY={" .. table.concat(gameplayTable, ",") .. "}")

    -- combine all parts --
    local mapData = table.concat(mapDataParts, "")

    -- compress the data --
    local compressedData = love.data.compress("string", "deflate", mapData)

    -- save to file --
    local rules = "maprules = {}\nreturn maprules"
    love.filesystem.write(MAP_NAME..".map", compressedData)
    love.filesystem.write(MAP_NAME.."_rules.lua", rules)

    print("Map saved successfully!")
end






-- function that loads a map from a specified filepath --
function loadMap(filepath)
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
        MapEditor.CurrentMap.MapSize = Vector.New(mapSize[1], mapSize[2])
    end

    -- initialize map tiles --
    MapEditor.CurrentMap.Tiles = graphics.InitialiseMap(MapEditor.CurrentMap.MapSize)
    local tileList = graphics.ListTiles(MapEditor.CurrentMap.Tiles)
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
                local tile = MapEditor.CurrentMap.Tiles[y][x]
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
        MapEditor.CurrentMap.Details = {}
        for i = 1, #details do
            local detail = details[i]
            if detail.Pos and detail.Type and MapEditor.Details[detail.Type] then
                detail.Pos = Vector.New(detail.Pos[1], detail.Pos[2])
                detail.Image = MapEditor.Details[detail.Type]
                table.insert(MapEditor.CurrentMap.Details, detail)
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
        MapEditor.CurrentMap.Gameplay = {}
        for i = 1, #gameplay do
            local gameplayElement = gameplay[i]
            if gameplayElement.Pos and gameplayElement.Type and MapEditor.Gameplay[gameplayElement.Type] then
                gameplayElement.Pos = Vector.New(gameplayElement.Pos[1], gameplayElement.Pos[2])
                gameplayElement.Image = MapEditor.Gameplay[gameplayElement.Type]
                table.insert(MapEditor.CurrentMap.Gameplay, gameplayElement)
            else
                print("Warning: Invalid or missing gameplay element at index " .. i .. " (Type=" .. tostring(gameplayElement.Type) .. "), skipping")
            end
        end
    end

    print("Map loaded successfully from: " .. filepath)
    return true
end