
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

TILE_DATA.Direction = {
    -- all polygon vertices going clockwise (x,y pairs) --
    NewTileData("ALL",   
        {{75,0}, {125,0}, {125,75}, {200,75}, {200,125}, {125,125}, {125,200}, {75,200}, {75,125}, {0,125}, {0,75}, {75,75}}   
    ),

    NewTileData("E",   {{0,75}, {200,75}, {200,125}, {0,125}}    ),
    NewTileData("S",   {{75,0}, {75,200}, {125,200}, {125,0}}    ),

    NewTileData("NE",   {{75,0}, {125,0}, {125,75}, {200,75}, {200,125}, {75,125}}    ),
    NewTileData("NW",   {{75,0}, {125,0}, {125,125}, {0,125}, {0,75}, {75,75}}    ),
    NewTileData("SE",   {{125,200}, {75,200}, {75,75}, {200,75}, {200,125}, {75,125}}    ),
    NewTileData("SW",   {{0,75}, {125,125}, {125,200}, {75,200}, {75,125}, {0,125}}    ),
}



LoadMap = {}

LoadMap.RegularTiles = {}
LoadMap.SnowyTiles = {}

local backgroundImage = love.graphics.newImage("Assets/Images/MapImages/MapTiles/"..TileWeather.."/Grass.png")

local TileTypes = {
    {"Grass",TILE_DATA.None,love.graphics.newImage("Assets/Images/MapImages/MapTiles/"..TileWeather.."/Grass.png")},
    {"Forest",TILE_DATA.Fill,love.graphics.newImage("Assets/Images/MapImages/MapTiles/"..TileWeather.."/Forest.png")},
    {"Road",TILE_DATA.Direction,love.graphics.newImage("Assets/Images/MapImages/MapTiles/"..TileWeather.."/Road.png")}
}


--// FUNCTIONS //--

local function CreateTile(tileName,data,tileImg,backImg)
    --create a new table for the tile data--
    local newTile = {}

    --setup canvas for drawing, as to create a new tile--
    local canvas = love.graphics.newCanvas( TILE_DATA.TileSize.X, TILE_DATA.TileSize.Y )
    love.graphics.setCanvas( {canvas, stencil = true} )
        -- draw background first
        love.graphics.draw(backgroundImage,0,0)

        -- build flat vertex list for love.graphics.polygon / triangulate
        local poly = {}
        for i=1,#data.Vertices do
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
            local newTile = CreateTile(TileTypes[i1][1],TileTypes[i1][2][i2],TileTypes[i1][3],backgroundImage)
            table.insert(LoadMap.AllTiles,newTile)
        end
    end
end 





return LoadMap