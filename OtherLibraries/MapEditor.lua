
--// IMPORTING OTHER LIBRARIES //--
Vector = require("../Mathematics/Vector")

---/// LIBRARY ///---
MapEditor = {}

--temp forest vertices--
local forest1 = { 25,25,  180,10,  230,80,  100,100,  30,90 }


MapEditor.CurrentMap = {}
MapEditor.CurrentMap.MapSize = Vector.New(10000,10000)---initial size---
MapEditor.CurrentMap.Forests = {forest1}
MapEditor.CurrentMap.Paths = {}
MapEditor.CurrentMap.Roads = {}
MapEditor.CurrentMap.Rivers = {}

MapEditor.Textures = {}
MapEditor.Textures.Grass = love.graphics.newImage("Assets/Images/MapTextures/GrassTexture.png")
MapEditor.Textures.Forest = love.graphics.newImage("Assets/Images/MapTextures/ForestTexture.png")
MapEditor.Textures.BlueWater = love.graphics.newImage("Assets/Images/MapTextures/BlueWaterTexture.png")
MapEditor.Textures.Sand = love.graphics.newImage("Assets/Images/MapTextures/SandTexture.png")
MapEditor.Textures.Path = love.graphics.newImage("Assets/Images/MapTextures/Path.png")
MapEditor.Textures.Road = love.graphics.newImage("Assets/Images/MapTextures/Road.png")


function MapEditor.UpdateMap()
    local mapSize = MapEditor.CurrentMap.MapSize
    

    --setup canvas for map background--
    local mapCanvas = love.graphics.newCanvas( mapSize.X, mapSize.Y, { msaa = AntiAliasAmount } )
    love.graphics.setCanvas({mapCanvas, stencil=true})


    --// DRAWING FOR GRASS //--
    --create background grass texture--
    GrassMesh = love.graphics.newMesh( {{0,0}, {mapSize.X,0}, {0,mapSize.Y}, {mapSize.X,mapSize.Y}}, "fan" )
    GrassMesh:setTexture( MapEditor.Textures.Grass )
    love.graphics.draw(GrassMesh)


    --// DRAWING FOR FORESTS //--
    --loop through forests and create polygons for them--
    -- 1. Create stencil mask from forest polygons
    love.graphics.stencil(function()
        for i = 1, #MapEditor.CurrentMap.Forests do
            local vertices  = MapEditor.CurrentMap.Forests[i]
            local triangles = love.math.triangulate(vertices)

            for _, triangle in ipairs(triangles) do
                love.graphics.polygon("fill", triangle)
            end
        end
    end, "replace", 1)

    -- 2. Only draw inside polygons
    love.graphics.setStencilTest("equal", 1)

    -- 3. Draw the forest texture inside the stencil
    local tex = MapEditor.Textures.Forest
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()

    for x = 0, w, tex:getWidth() do
        for y = 0, h, tex:getHeight() do
            love.graphics.draw(tex, x, y)
        end
    end

    -- 4. Reset
    love.graphics.setStencilTest()


    --// DRAWING FOR ROADS //--


    --reset drawing to the screen, return the finished canvas--
    love.graphics.setCanvas()
    return mapCanvas
end




return MapEditor