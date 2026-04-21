
--// IMPORT OTHER LIBRARIES AND CLASSES //--
Vector = require("../Mathematics/Vector")


----------////////////// !!!!!!!!!!!!!!!!! //////////////////-----------------
TileWeather = "Regular"

---/// LIBRARY ///---
--library that loads the map when required, and also loads all the tiles--

--local function for populating the following tile data tables--
local function NewTileData(name,vertices)
    local newTable = {}
    newTable.Name = name
    newTable.Vertices = vertices
    return newTable
end


--// TILE DATA //--
TILE_DATA = {}

TILE_DATA.TileSize = Vector.New(200,200)

TILE_DATA.None = {
    NewTileData("ALL",   {{0,0}, {200,0}, {200,200}, {0,200}}   )
}

TILE_DATA.Fill = {
    -- all polygon vertices going clockwise (x,y pairs) --
    NewTileData("ALL",   {{0,0}, {200,0}, {200,200}, {0,200}}   ),

    NewTileData("ANE",   {{0,0}, {125,0}, {200,75}, {200,200}, {0,200}}   ),
    NewTileData("ANW",   {{75,0}, {200,0}, {200,200}, {0,200}, {0,75}}   ),
    NewTileData("ASE",   {{0,0}, {200,0}, {200,125}, {125,200}, {0,200}}   ),
    NewTileData("ASW",   {{0,0}, {200,0}, {200,200}, {75,200}, {0,125}}   ),

    NewTileData("E",   {{0,0}, {125,0}, {125,200}, {0,200}}   ),
    NewTileData("N",   {{0,75}, {200,75}, {200,200}, {0,200}}   ),
    NewTileData("S",   {{0,0}, {200,0}, {200,125}, {0,125}}   ),
    NewTileData("W",   {{75,0}, {200,0}, {200,200}, {75,200}}   ),

    NewTileData("NE",   {{0,75}, {125,200}, {0,200}}   ),
    NewTileData("NW",   {{75,200}, {200,75}, {200,200}}   ),
    NewTileData("SE",   {{0,0}, {125,0}, {0,125}}   ),
    NewTileData("SW",   {{75,0}, {200,0}, {200,125}}   )
}

TILE_DATA.Roads = {
    -- all polygon vertices going clockwise (x,y pairs) --
    NewTileData("ALL",   
        {{75,0}, {125,0}, {125,75}, {200,75}, {200,125}, {125,125}, {125,200}, {75,200}, {75,125}, {0,125}, {0,75}, {75,75}}   
    ),

    NewTileData("E",   {{0,75}, {200,75}, {200,125}, {0,125}}    ),
    NewTileData("S",   {{75,0}, {75,200}, {125,200}, {125,0}}    ),

    NewTileData("NE",   {{75,0}, {125,0}, {125,75}, {200,75}, {200,125}, {75,125}}    ),
    NewTileData("NW",   {{75,0}, {125,0}, {125,125}, {0,125}, {0,75}, {75,75}}    ),
    NewTileData("SE",   {{75,75}, {200,75}, {200,125}, {125,125}, {125,200}, {75,200}}    ),
    NewTileData("SW",   {{0,75}, {125,75}, {125,200}, {75,200}, {75,125}, {0,125}}    ),

    NewTileData("AE",   {{125,0}, {125,200}, {75,200}, {75,125}, {0,125}, {0,75}, {75,75},{75,0}}    ),
    NewTileData("AN",   {{0,75}, {200,75}, {200,125}, {125,125}, {125,200}, {75,200}, {75,125}, {0,125}}    ),
    NewTileData("AS",   {{0,75}, {75,75}, {75,0}, {125,0}, {125,75}, {200,75}, {200,125}, {0,125}}    ),
    NewTileData("AW",   {{75,0}, {125,0}, {125,75}, {200,75}, {200,125}, {125,125}, {125,200}, {75,200}}    ),
}

TILE_DATA.Water = {
    -- all polygon vertices going clockwise (x,y pairs) --
    NewTileData("E",   {{0,60}, {200,60}, {200,140}, {0,140}}    ),
    NewTileData("S",   {{60,0}, {60,200}, {140,200}, {140,0 }}    ),

    NewTileData("NE",   {{60,0}, {140,0}, {143,19}, {153,38}, {175,55}, {200,60}, {200,140}, {129,121}, {86,82}, {65,38}}    ),
    NewTileData("NW",   {{60,0}, {140,0}, {136,33}, {112,84}, {55,129}, {0,140}, {0,60}, {24,55}, {45,39}, {56,20}}    ),
    NewTileData("SE",   {{140,200}, {60,200}, {69,151}, {108,104}, {152,69}, {200,60}, {200,140}, {178,145}, {157,158}, {144,180}}    ),
    NewTileData("SW",   {{60,200}, {140,200}, {130,157}, {99,101}, {52,70}, {0,60}, {0,140}, {24,145}, {45,161}, {56,180}}    ),
}
TILE_DATA.Beach = {
    -- all polygon vertices going clockwise (x,y pairs) --
    NewTileData("E",   {{0,55}, {200,55}, {200,145}, {0,145}}    ),
    NewTileData("S",   {{55,0}, {55,200}, {145,200}, {140,0 }}    ),

    NewTileData("NE",   {{55,0}, {145,0}, {148,19}, {159,38}, {182,55}, {200,55}, {200,145}, {136,121}, {92,82}, {75,38}}    ),
    NewTileData("NW",   {{55,0}, {145,0}, {136,33}, {112,84}, {55,129}, {0,145}, {0,55}, {24,55}, {45,39}, {56,20}}    ),
    NewTileData("SE",   {{145,200}, {55,200}, {69,151}, {108,104}, {152,69}, {200,55}, {200,145}, {178,145}, {157,158}, {144,180}}    ),
    NewTileData("SW",   {{55,200}, {145,200}, {130,157}, {99,101}, {52,70}, {0,55}, {0,145}, {24,145}, {45,161}, {56,180}}    ),
}



LoadMap = {}

LoadMap.RegularTiles = {}
LoadMap.SnowyTiles = {}

local backgroundImage = love.graphics.newImage("Assets/Images/MapImages/MapTiles/"..TileWeather.."/Grass.png")

local TileTypes = {
    --Grass / Default--
    {"Grass",TILE_DATA.None,love.graphics.newImage("Assets/Images/MapImages/MapTiles/"..TileWeather.."/Grass.png"),0},

    --Nature--
    {"BlueCreek",TILE_DATA.Water,love.graphics.newImage("Assets/Images/MapImages/MapTiles/"..TileWeather.."/BlueWater.png"),1},
    {"BrownCreek",TILE_DATA.Water,love.graphics.newImage("Assets/Images/MapImages/MapTiles/"..TileWeather.."/BrownWater.png"),1},
    {"Forest",TILE_DATA.Fill,love.graphics.newImage("Assets/Images/MapImages/MapTiles/"..TileWeather.."/Forest.png"),4},
  
    --Roads / Bridges--
    {"Path",TILE_DATA.Roads,love.graphics.newImage("Assets/Images/MapImages/MapTiles/"..TileWeather.."/Path.png"),2},
    {"Road",TILE_DATA.Roads,love.graphics.newImage("Assets/Images/MapImages/MapTiles/"..TileWeather.."/Road.png"),0},
}


--// FUNCTIONS //--

local function CreateTile(tileName,data,tileImg,backImg,offsetMulti)
    --create a new table for the tile data--
    local newTile = {}

    --setup canvas for drawing, as to create a new tile--
    local canvas = love.graphics.newCanvas( TILE_DATA.TileSize.X, TILE_DATA.TileSize.Y )
    love.graphics.setCanvas( {canvas, stencil = true} )
        -- draw background first
        love.graphics.draw(backgroundImage,0,0)

        -- build flat vertex list for love.graphics.polygon / triangulate
        local poly = {}
        for i=1,#data.Vertices,1 do
            if (i>1) then

                local prev = data.Vertices[i-1]
                local curr = data.Vertices[i]

                -- compute deltas as curr - prev (so prev + fraction*delta moves toward curr)
                local xDelta = curr[1] - prev[1]
                local yDelta = curr[2] - prev[2]

                -- insert a few evenly spaced points between prev and curr
                for i2 = 1, 2 do

                    if not ( (prev[1]==0)or(prev[1]==200) ) then 
                        table.insert(poly, prev[1] + ((xDelta/3) * i2) + (math.random(-5,5) * (offsetMulti/3)))
                    else table.insert(poly, prev[1] + ((xDelta/3) * i2)) end
                    if not ( (prev[2]==0)or(prev[2]==200) ) then 
                        table.insert(poly, prev[2] + ((yDelta/3) * i2) + (math.random(-5,5) * (offsetMulti/3)))
                    else table.insert(poly, prev[2] + ((yDelta/3) * i2)) end

                end
            end

            table.insert(poly, data.Vertices[i][1])
            table.insert(poly, data.Vertices[i][2])
        end

        -- try triangulation (works for concave but simple polygons)
        local tris = {}
        if love.math and love.math.triangulate then
            pcall(function() tris = love.math.triangulate(poly) end)
        end

        if tris and #tris > 0 then
            love.graphics.stencil(function()
                for _, tri in ipairs(tris) do
                    love.graphics.polygon("fill", tri)
                end
            end, "replace", 1)
        else
            -- fallback: try a single polygon (may fail for self-intersecting shapes)
            love.graphics.stencil(function()
                love.graphics.polygon("fill", poly)
            end, "replace", 1)
        end

        love.graphics.setStencilTest("greater", 0)
        love.graphics.draw(tileImg, 0, 0)
        love.graphics.setStencilTest()
    love.graphics.setCanvas( )

    newTile.Image = canvas
    newTile.Name = tileName..data.Name
    return newTile
end



LoadMap.AllTiles = {}

local testTile = {}
testTile.Image = backgroundImage
testTile.Name = "test"
table.insert(LoadMap.AllTiles,testTile)

--// METHODS //--
function LoadMap.LoadTiles()
    for i1 = 1,#TileTypes,1 do
        for i2 = 1,#TileTypes[i1][2],1 do
            local newTile = CreateTile(TileTypes[i1][1],TileTypes[i1][2][i2],TileTypes[i1][3],backgroundImage,TileTypes[i1][4])
            table.insert(LoadMap.AllTiles,newTile)
        end
    end
end 





return LoadMap