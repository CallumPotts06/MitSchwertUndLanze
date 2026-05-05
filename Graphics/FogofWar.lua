-- FogofWar.lua
local Fog = {}

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

---------------------------------------------------------------------
-- INITIALIZE
---------------------------------------------------------------------
function Fog.init(fogW, fogH, fogDiv)
    Fog.width  = fogW      -- number of fog tiles horizontally
    Fog.height = fogH      -- number of fog tiles vertically
    Fog.div    = fogDiv    -- world pixels per fog tile

    -- Fog canvas (tiny!)
    --Fog.canvas = love.graphics.newCanvas(fogW, fogH, {format="r8"})
    Fog.canvas = love.graphics.newCanvas(fogW, fogH)

    -- Shader
    Fog.shader = love.graphics.newShader(Fog.shaderCode)
    Fog.shader:send("colorSeen",   {0.2, 0.2, 0.2, 0.5})
    Fog.shader:send("colorUnseen", {0.2, 0.2, 0.2, 0.5})
    Fog.shader:send("fogMap", Fog.canvas)
end

---------------------------------------------------------------------
-- RENDER FOG CANVAS (low resolution)
---------------------------------------------------------------------
function Fog.renderFog()
    love.graphics.setCanvas(Fog.canvas)
    love.graphics.clear(0, 0, 0, 1)

    for y = 1, #FogTiles do
        for x = 1, #FogTiles[1] do
            local vis = FogTiles[y][x]

            if not vis then
                love.graphics.setColor(0.2, 0.2, 0.2, 0.8)
            else
                --print("VISIBLE! ")
                love.graphics.setColor(1, 1, 1, 0)
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
