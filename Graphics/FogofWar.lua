-- FogofWar.lua

--[[
local Fog = {}

Fog.Tiles = nil

---------------------------------------------------------------------
-- SHADER
---------------------------------------------------------------------
Fog.shaderCode = [[
    extern Image fogMap;
    extern vec4 colorSeen;
    extern vec4 colorUnseen;

    vec4 effect(vec4 color, Image tex, vec2 uv, vec2 px)
    {
        float fog = Texel(fogMap, uv).r;

        vec4 base = Texel(tex, uv);

        if (fog < 0.33) {
            return mix(base, colorUnseen, 0.5);
        }
        else if (fog < 0.66) {
            return mix(base, colorSeen, 0.5);
        }

        return base;
    }
]]
--[[
---------------------------------------------------------------------
-- INITIALIZE
---------------------------------------------------------------------
function Fog.init(fogW, fogH, fogDiv)
    Fog.width  = fogW      -- number of fog tiles horizontally
    Fog.height = fogH      -- number of fog tiles vertically
    Fog.div    = fogDiv    -- world pixels per fog tile

    -- Fog canvas (tiny!)
    Fog.canvas = love.graphics.newCanvas(fogW, fogH, {format="r8"})
    --Fog.canvas = love.graphics.newCanvas(fogW, fogH)

    -- Shader
    Fog.shader = love.graphics.newShader(Fog.shaderCode)
    Fog.shader:send("colorSeen",   {1, 1, 1, 1})
    Fog.shader:send("colorUnseen", {0.2, 0.2, 0.2, 0.2})
    Fog.shader:send("fogMap", Fog.canvas)
end

---------------------------------------------------------------------
-- RENDER FOG CANVAS (low resolution)
---------------------------------------------------------------------
function Fog.renderFog()
    love.graphics.setCanvas(Fog.canvas)
    --love.graphics.clear(0, 0, 0, 1)

    for y = 1, #Fog.Tiles do
        for x = 1, #Fog.Tiles[1] do
            local vis = Fog.Tiles[y][x]

            if not vis then
                love.graphics.setColor(0.1, 0.1, 0.1, 0.1)
            else
                love.graphics.setColor(1, 1, 1, 1)
            end

            love.graphics.points(x - 1, y - 1)
        end
    end

    love.graphics.setCanvas()
    love.graphics.setColor(1, 1, 1)
end

---------------------------------------------------------------------
-- DRAW FOG OVER WORLD (scaled)
---------------------------------------------------------------------
function Fog.draw(worldW, worldH)
    love.graphics.setShader(Fog.shader)

    local sx = ( worldW / Fog.div ) * CameraZoom
    local sy = ( worldH / Fog.div ) * CameraZoom

    love.graphics.draw(Fog.canvas, CameraPosition.X, CameraPosition.Y, 0, sx, sy)

    love.graphics.setShader()
end

return Fog
]]




---//// NEW SOLUTION ////---
local Fog = {}

Fog.TILESIZE = 192

Fog.Size = nil
Fog.Tiles = nil

Fog.RevealMode = "all"
--all both teams reveal
--TEAM_NAME just the specified team reveals
--nofog the map is entirely revealed



function Fog.UpdateFog()
    --[[if Fog.UpdateFlag then

        Fog.Canvas = love.graphics.newCanvas( Fog.Size.X, Fog.Size.Y )

        love.graphics.setCanvas(Fog.Canvas)

        --loop through the tile map--
        for y = 1, Fog.Size.Y, 1 do
            for x = 1, Fog.Size.X, 1 do
                
                --update colour based on its visibilty--
                if Fog.Tiles[y][x] == "Unseen" then love.graphics.setColor(0,0,0,0.2)
                else love.graphics.setColor(0,0,0,0) end

                love.graphics.points( x, y )
            end
        end

        love.graphics.setCanvas()
    end]]
end



function Fog.DrawFog()
    local scale = Fog.TILESIZE * CameraZoom

    local startX = math.floor( CameraPosition.X / Fog.TILESIZE ) - 2
    local startY = math.floor( CameraPosition.Y / Fog.TILESIZE ) - 2
    local endX = ( ( ( ScreenX / CameraZoom ) - ( CameraPosition.X  / CameraZoom ) ) / Fog.TILESIZE ) + 2
    local endY = ( ( ( ScreenY / CameraZoom ) - ( CameraPosition.Y  / CameraZoom ) ) / Fog.TILESIZE ) + 2

    if startX<1 then startX = 1 end
    if startY<1 then startY = 1 end
    if endX>Fog.Size.X then endX = Fog.Size.X end
    if endY>Fog.Size.Y then endY = Fog.Size.Y end

    local tempPos = Vector.New(0,0)

    for y = startY, endY, 1 do
        for x = startX, endX, 1 do

            if Fog.Tiles[y][x] == "Unseen" then love.graphics.setColor(0,0,0,0.25)
            else love.graphics.setColor(0,0,0,0) end 

            tempPos.X = (x-1)*Fog.TILESIZE
            tempPos.Y = (y-1)*Fog.TILESIZE

            tempPos:ToScreenPosition()
            love.graphics.rectangle( "fill", tempPos.X, tempPos.Y, scale, scale )

        end
    end
end



function Fog.Scout(pos, unitType, team)

    --return function if scout is not required--
    if not ( ( Fog.RevealMode == "all" ) or ( Fog.RevealMode == team ) ) then return nil end

    --determine how much to reveal based on unit type--
    local visRange = 1
    if unitType == "Infantry" then visRange = 12
    elseif unitType == "Artillery" then visRange = 14
    elseif unitType == "Cavalry" then visRange = 22 end

    --find the unit's position on the tile map--
    local tilePos = Vector.New(  math.ceil(pos.X/Fog.TILESIZE),  math.ceil(pos.Y/Fog.TILESIZE)  )

    --loop through the surrounding tiles--
    for y = tilePos.Y-visRange, tilePos.Y+visRange, 1 do
        for x = tilePos.X-visRange, tilePos.X+visRange, 1 do

            local adj = x-tilePos.X
            local opp = y-tilePos.Y
            local magnitude = math.sqrt( (adj*adj) + (opp*opp) )

            --set boundaries--
            local skipFlag = false

            if y>=Fog.Size.Y then skipFlag = true
            elseif y<=0 then skipFlag = true
            elseif x>=Fog.Size.X then skipFlag = true
            elseif x<=0 then skipFlag = true end

            if magnitude > visRange then skipFlag = true end

            --update tiles where appropriate--
            if not skipFlag then
                if not ( Fog.Tiles[y][x] == "Seen" ) then
                    Fog.Tiles[y][x] = "Seen"
                    Fog.UpdateFlag = true
                end
            end

        end
    end

end


function Fog.init(mapWidth,mapHeight)

    --setup variables--
    local tilesX = math.ceil( mapWidth / Fog.TILESIZE ) + 1
    local tilesY = math.ceil( mapHeight / Fog.TILESIZE ) + 1

    print("FOG TILE SIZE:  "..tilesX..","..tilesY)

    Fog.Tiles = {}
    Fog.Size = Vector.New(tilesX, tilesY)


    --create the table for the fog map--
    for y = 1, tilesY, 1 do
        table.insert(Fog.Tiles, {})
        for x = 1, tilesX, 1 do
            table.insert(Fog.Tiles[y], "Unseen")
        end
    end

    Fog.UpdateFog()
end

return Fog