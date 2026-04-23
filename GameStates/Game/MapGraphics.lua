
graphics = {}

Colours = require("../../Interface/Colours")
Vector = require("../../Mathematics/Vector")

--// ############################## //--
--// CONSTANT VALUES FOR THE MODULE //--
--// ############################## //--

graphics.DetailScaleFactor = 1.6
graphics.MapScaleFactor = 4
graphics.MapTileSize = 1024

--battalion frontage = 315px, say its equal to 250m, let kilometre = 315 * 4 ~ 3300 (rounded up to 4000), where 1000/250 = 4
graphics.KILOMETRE = 4000
graphics.ROAD_WIDTH =  650

drawGridLines = true

MapColours = {}
MapColours.Grass = Colours.CreateColour({0.3,0.7,0.3,1})
MapColours.Forest = Colours.CreateColour({0.1,0.4,0.1,1})

MapColours.Wheat = Colours.CreateColour({0.8,0.8,0.1,1})
MapColours.Potato = Colours.CreateColour({0.2,0.6,0.0,1})

MapColours.Path = Colours.CreateColour({0.5,0.5,0.3,1})
MapColours.Road = Colours.CreateColour({0.3,0.3,0.3,1})

MapColours.BlueWater = Colours.CreateColour({0.2,0.3,0.6,1})
MapColours.Sand = Colours.CreateColour({0.5,0.5,0.2,1})


--// ########################## //--
--// LOCAL VARIABLES DEFINITION //--
--// ########################## //--

local currentVisibleTiles = {}
local visibleTileDebounce = false



--// ############################### //--
--// LOCAL FUNCTIONS FOR THIS MODULE //--
--// ############################### //--

--updates the colour from argument--
local function updateColour(terrain)
    local currentColour = MapColours.Grass

    if terrain=="Forest" then currentColour = MapColours.Forest
    elseif terrain=="Grass" then currentColour = MapColours.Grass

    elseif terrain=="Wheat" then currentColour = MapColours.Wheat
    elseif terrain=="Potato" then currentColour = MapColours.Potato

    elseif terrain=="Path" then currentColour = MapColours.Path
    elseif terrain=="Road" then currentColour = MapColours.Road

    elseif terrain=="Stream" then currentColour = MapColours.BlueWater
    elseif terrain=="Sand" then currentColour = MapColours.Sand end

    return currentColour
end 

local function getTerrainTexture(terrain)
    local textureKey = terrain
    if terrain == "Stream" then textureKey = "BlueWater" end
    return MapController.Textures[textureKey]
end

local function getTexturePixel(texture,pos)
    local texW, texH = 300, 300

    local x = pos.X % texW
    local y = pos.Y % texH

    local r,g,b = texture:getPixel( x, y )
    local newColour = {r,g,b,1}
    newColour = Colours.CreateColour(newColour)

    return newColour
end

--creates a blank tile--
local function createTile(tileIndexX,tileIndexY)
    --create new tile object--
    local newTile = {}
    newTile.IndexPosition = Vector.New(tileIndexX,tileIndexY)
    newTile.Pixels = {}
    newTile.Canvas = nil
    newTile.Visible = true

    --populate the table with default "grass" values--
    for y=1,(graphics.MapTileSize / graphics.MapScaleFactor)+1,1 do
        table.insert(newTile.Pixels,{})
        for x=1,(graphics.MapTileSize / graphics.MapScaleFactor)+1,1 do
            table.insert(newTile.Pixels[y],"Grass")
        end 
    end 

    return newTile
end

function graphics.CheckIfOnScreen(tile)
    local tileMin = Vector.New(tile.IndexPosition.X,tile.IndexPosition.Y)
    local tileMax = Vector.New(0,0)

    tileMin.X = ( tileMin.X - 1 ) * graphics.MapTileSize
    tileMin.Y = ( tileMin.Y - 1 ) * graphics.MapTileSize

    tileMax.X = ( tileMin.X ) + graphics.MapTileSize
    tileMax.Y = ( tileMin.Y ) + graphics.MapTileSize

    tileMin:ToScreenPosition()
    tileMax:ToScreenPosition()

    local checks =
            ( tileMin.X < ScreenX ) and
            ( tileMax.X > 0 ) and
            ( tileMin.Y < ScreenY ) and
            ( tileMax.Y > 0 )

    return checks
end

function graphics.CheckIfDetailOnScreen(detail)
    local posMin = Vector.New( detail.Pos.X, detail.Pos.Y )
    local posMax = Vector.New( detail.Pos.X + ( detail.Image:getWidth() * graphics.DetailScaleFactor ) , detail.Pos.Y + ( detail.Image:getHeight() * graphics.DetailScaleFactor ) )

    posMin:ToScreenPosition()
    posMax:ToScreenPosition()

    local checks =
            ( posMin.X < ScreenX ) and
            ( posMax.X > 0 ) and
            ( posMin.Y < ScreenY ) and
            ( posMax.Y > 0 )

    return checks
end






--// ####################################################### //--
--// GLOBALLY ACCESSIBLE FUNCTIONS (METHODS) THROUGH LIBRARY //--
--// ####################################################### //--

--function that creates a blank map for editing--
function graphics.InitialiseMap(mapSize)

    --setup some objects and variables for map--
    local tileMap = {}
    local tileMapWidth = math.ceil( mapSize.X / graphics.MapTileSize )
    local tileMapHeight = math.ceil( mapSize.Y / graphics.MapTileSize )

    --populate the tile map with the createTile() function--
    for y=1,tileMapHeight,1 do
        table.insert(tileMap,{})
        for x=1,tileMapWidth,1 do
            table.insert(tileMap[y],createTile(x,y))
            graphics.UpdateTileCanvas(tileMap[y][x])
        end 
    end

    --output the length of the tile map for testing efficiency--
    print("MAP SIZE (TOTAL X * Y):  "..tostring(#tileMap*#tileMap[1]))
    print("MAP WIDTH = "..tostring(#tileMap[1]))
    print("MAP HEIGHT = "..tostring(#tileMap))

    --return the new map--
    return tileMap
end





--function that creates or updates the canvas of an individual tile--
function graphics.UpdateTileCanvas(tile)
    local pixels = tile.Pixels
    local newCanvas = love.graphics.newCanvas( #pixels, #pixels )
    love.graphics.setCanvas( newCanvas )

    --loop through the tiles pixel table--
    for y=1,#pixels,1 do
        for x=1,#pixels[y],1 do

            local indexed = pixels[y][x]
            local texture = getTerrainTexture(indexed)

            if texture then
                local textureColour = getTexturePixel(texture,Vector.New(x,y))
                Colours.SetColour(textureColour)
                love.graphics.points(x,y)
            else
                local colour = updateColour(indexed)
                Colours.SetColour(colour)
                love.graphics.points(x,y)
            end
        end 
    end 
        
    --reset canvas to screen (default)--
    love.graphics.setCanvas( )
    --reset colour--
    Colours.ResetColour( )

    --update the tiles' canvas property--
    tile.Canvas = newCanvas
end 
    



--function that draws all the visible tiles onto the screen--
function graphics.DrawMap(map,camMoved)
    local tileZoom = CameraZoom * graphics.MapScaleFactor
    local detailZoom = CameraZoom * graphics.DetailScaleFactor

    --DRAWING TILES--
    if ( camMoved )  then
        currentVisibleTiles = {}
        currentVisibleDetails = {}

        for y=1,#map,1 do
            for x=1,#map[y],1 do

                local indexTile = map[y][x]
                local pos = Vector.New( (x-1) * graphics.MapTileSize, (y-1) * graphics.MapTileSize)
                pos:ToScreenPosition()

                --code for effects / lighting --
                -- ... ... --
                -- end  of code for lighting --

                if checkIfOnScreen(indexTile) then
                    table.insert(currentVisibleTiles,indexTile)
                    love.graphics.draw(indexTile.Canvas, pos.X, pos.Y, 0, tileZoom, tileZoom)
                end
            end
        end

        local detailList = MapController.CurrentMap.Details
        for i=1,#detailList,1 do
            local detail = detailList[i]
            if checkIfDetailOnScreen(detail) then
                table.insert(currentVisibleDetails, detail)
                local pos = Vector.New(detail.Pos.X, detail.Pos.Y)
                pos:ToScreenPosition()
                love.graphics.draw(detail.Image, pos.X, pos.Y, 0, detailZoom, detailZoom)
            end 
        end

    elseif ( #currentVisibleTiles > 0 ) then

        for i=1,#currentVisibleTiles,1 do
            local pos = Vector.New( (currentVisibleTiles[i].IndexPosition.X-1) * graphics.MapTileSize, (currentVisibleTiles[i].IndexPosition.Y-1) * graphics.MapTileSize)
            pos:ToScreenPosition()
            love.graphics.draw(currentVisibleTiles[i].Canvas, pos.X, pos.Y, 0, tileZoom, tileZoom)
        end 


        for i=1,#currentVisibleDetails,1 do
            local pos = Vector.New(currentVisibleDetails[i].Pos.X, currentVisibleDetails[i].Pos.Y)
            pos:ToScreenPosition()
            love.graphics.draw(currentVisibleDetails[i].Image, pos.X, pos.Y, 0, detailZoom, detailZoom)
        end 

    end 

    for i=1,#MapController.CurrentMap.Gameplay,1 do
        local pos = Vector.New(MapController.CurrentMap.Gameplay[i].Pos.X, MapController.CurrentMap.Gameplay[i].Pos.Y)
        pos:ToScreenPosition()
        love.graphics.draw(MapController.CurrentMap.Gameplay[i].Image,pos.X,pos.Y,0,cameraZoom,cameraZoom)
    end



    --DRAWING 1km GRID LINES--
    if drawGridLines then
        local black = Colours.CreateColour( Colours.White )
        love.graphics.setLineWidth( 5 )
        
        --draw vertical grid lines--
        for x=0,#map[1]*graphics.MapTileSize,graphics.KILOMETRE do
            local gridStartPos = Vector.New(x,0)
            gridStartPos:ToScreenPosition()
            local newGridLine = Vector.New(0,#map*graphics.MapTileSize)
            newGridLine:DrawVector(gridStartPos,black)
        end 

        --draw horizontal grid lines--
        for y=0,#map*graphics.MapTileSize,graphics.KILOMETRE do
            local gridStartPos = Vector.New(0,y)
            gridStartPos:ToScreenPosition()
            local newGridLine = Vector.New(#map*graphics.MapTileSize,0)
            newGridLine:DrawVector(gridStartPos,black)
        end

        love.graphics.setLineWidth( 1 )
    end 

end 

function graphics.CreateDetail(pos,detail)
    local newDetail = {}
    newDetail.Type = detail
    newDetail.Image = MapController.Details[detail]
    newDetail.Pos = Vector.New( pos.X - ( ( newDetail.Image:getWidth() * graphics.DetailScaleFactor ) / 2 ), pos.Y - ( ( newDetail.Image:getHeight() * graphics.DetailScaleFactor ) / 1.5 )  )
    table.insert(MapController.CurrentMap.Details,newDetail)
end

function graphics.CreateGameplay(pos,game)
    local newGame = {}
    newGame.Type = game
    newGame.Image = MapController.Gameplay[game]
    newGame.Pos = Vector.New( pos.X - newGame.Image:getWidth(), pos.Y -  newGame.Image:getHeight() )
    table.insert(MapController.CurrentMap.Gameplay,newGame)
end

function graphics.RemoveDetail(pos,detailList)
    local newList = {}

    for i = 1, #detailList, 1 do
        local detail = detailList[i]

        local posMin = Vector.New( detail.Pos.X, detail.Pos.Y )
        local posMax = Vector.New( detail.Pos.X + ( detail.Image:getWidth() * graphics.DetailScaleFactor ) , detail.Pos.Y + ( detail.Image:getHeight() * graphics.DetailScaleFactor ) )

        local checks =
                ( posMin.X > pos.X ) and
                ( posMax.X < pos.X ) and
                ( posMin.Y > pos.Y ) and
                ( posMax.Y < pos.Y)

        if not checks then table.insert(newList, detailList) end
    end

    return newList
end

--a function that draws a scale for the map in the bottom corner--
function graphics.DrawScale()
    
    local scale = 0

    -- find appropriate scale to use --
    local scaleIncrements = { 0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 5, 10, 50 }
    for i = #scaleIncrements, 1, -1 do
        if ( ( ( ScreenX / CameraZoom ) / 4 ) >= ( scaleIncrements[i] * graphics.KILOMETRE ) ) then
            scale = scaleIncrements[i]
            break  -- Exit once we find the largest fitting scale
        end 
    end

    local scalePos = Vector.New( 25, ScreenY - 25 )
    local scaleLineWidth = ( scale  * CameraZoom * graphics.KILOMETRE)
    local scaleVector = Vector.New( scaleLineWidth, 0 )
    if scale < 1 then
        scaleTxt = love.graphics.newText(Font.CreateFont("Scale: "..scale.."metres", Font.Georgia, Vector.New( 300, 50 ), 0, 25), "Scale: "..tostring(scale*1000).."m")
    else
        scaleTxt = love.graphics.newText(Font.CreateFont("Scale: "..scale.."metres", Font.Georgia, Vector.New( 300, 50 ), 0, 25), "Scale: "..tostring(scale).."km")
    end 
        love.graphics.draw( scaleTxt, 25, ScreenY - 60 )
    scaleVector:DrawVector( scalePos,  Colours.CreateColour(Colours.White) )
end



--function that updates a pixel on a tile--
function graphics.ChangeTilePixel(map,mousePos,newColour)
    --convert mouse position on screen to position of tile and position of pixel on tile--
    mousePos:ToGamePosition()
    local indexPos = Vector.New( math.ceil( mousePos.X  / graphics.MapTileSize ), math.ceil( mousePos.Y / graphics.MapTileSize ) )
    local pixelPos = Vector.New( math.ceil( ( mousePos.X  % graphics.MapTileSize ) / graphics.MapScaleFactor ), math.ceil( ( mousePos.Y % graphics.MapTileSize ) / graphics.MapScaleFactor ) )
    

    --data validation--
    if ( indexPos.X < 1 ) or ( indexPos.X > #map[1] ) then return false end
    if ( indexPos.Y < 1 ) or ( indexPos.Y > #map ) then return false end
    
    local tile = map[indexPos.Y][indexPos.X]

    --more data validation--
    if ( pixelPos.X < 1 ) or ( pixelPos.X > #tile.Pixels[1] ) then return false end
    if ( pixelPos.Y < 1 ) or ( pixelPos.Y > #tile.Pixels ) then return false end

    --update pixel colour and update canvas at the same time--
    tile.Pixels[pixelPos.Y][pixelPos.X] = newColour

    --returns the tile that has been changed--
    return tile
end




--function that creates a 1D list with all tiles in it--
function graphics.ListTiles(map)
    local newList = {}
    for y=1,#map,1 do
        for x=1,#map[y],1 do
            table.insert(newList,map[y][x])
        end 
    end 

    return newList
end

--function that orders the details based on their y position--
function graphics.OrderDetails(detailList)

    local newList = {detailList[1]}

    -- INSERTION SORT --
    for i1 = 2,#detailList,1 do

        local inserted = false
        for i2 = #newList,1,-1 do
            if detailList[i1].Pos.Y > newList[i2].Pos.Y then 
                table.insert(newList, i2 + 1, detailList[i1]) 
                inserted = true
                break 
            end
        end
        
        -- if not inserted, it goes at the beginning --
        if not inserted then
            table.insert(newList, 1, detailList[i1])
        end

    end

    return newList

end


-- Returns a list of tiles currently visible on screen
function graphics.GetVisibleTiles()
    local visibleTiles = {}

    -- Convert camera pixel position to tile indices
    local camMinX = math.floor(CameraPosition.X / graphics.MapTileSize)
    local camMinY = math.floor(CameraPosition.Y / graphics.MapTileSize)

    -- How many tiles fit on screen
    local tilesAcross = math.ceil(ScreenX / graphics.MapTileSize)
    local tilesDown   = math.ceil(ScreenY / graphics.MapTileSize)

    -- Add a small buffer so tiles at edges don’t pop in/out
    local minX = camMinX - 1
    local maxX = camMinX + tilesAcross + 1
    local minY = camMinY - 1
    local maxY = camMinY + tilesDown + 1

    -- Loop only through tiles that *might* be visible
    for x = minX, maxX do
        for y = minY, maxY do
            local tile = Map[x] and Map[x][y]
            if tile then
                table.insert(visibleTiles, tile)
            end
        end
    end

    return visibleTiles
end



return graphics