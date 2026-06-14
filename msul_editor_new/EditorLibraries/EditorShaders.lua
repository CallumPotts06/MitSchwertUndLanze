
Shader = {}

---/// #################### ///---
---/// LOAD IN THE TEXTURES ///---
---/// #################### ///---
Textures = {}
Textures.Grass = love.graphics.newImage("MapTextures/GrassTexture.png")
Textures.Forest = love.graphics.newImage("MapTextures/ForestTexture.png")
Textures.Water = love.graphics.newImage("MapTextures/BlueWaterTexture.png")
Textures.Sand = love.graphics.newImage("MapTextures/SandTexture.png")
Textures.MudPath = love.graphics.newImage("MapTextures/Path.png")
Textures.StonePath = love.graphics.newImage("MapTextures/Path.png")
Textures.Road = love.graphics.newImage("MapTextures/Road.png")
Textures.Farmland = love.graphics.newImage("MapTextures/Farmland.png")

TextureKeys = { 
    "Grass", "Forest", "Farmland", "MudPath", "StonePath", "Road", "Water", "Sand"
}



---/// ####################### ///---
---/// SETUP THE TEXTURE ATLAS ///---
---/// ####################### ///---
TextureAtlas = love.graphics.newCanvas( #TextureKeys*300, 300 )
love.graphics.setCanvas( TextureAtlas )
for x=1,#TextureKeys do
    local currentImage = Textures[ TextureKeys[ x ] ]
    love.graphics.draw( currentImage, (x-1)*300, 0 )
end
love.graphics.setCanvas( )

-- make atlas nearest to avoid interpolation when sampling pixels
TextureAtlas:setFilter('nearest','nearest')

---/// ################# ///---
---/// CREATE THE SHADER ///---
---/// ################# ///---

local textureCode = [[
    extern Image atlas;
    extern vec2 textureSize;
    extern vec2 atlasSize;
    extern vec2 mapSize;
    extern float tilesX;
    extern float debugMode; // 0 = off, 1 = show idx debug

    vec4 effect(vec4 color, Image tex, vec2 uv, vec2 screenPos) 
    {
        float raw = Texel(tex, uv).r;

        // two common encodings:
        //  - normalized steps 0,1/tilesX,... => use idxNorm
        //  - byte 0..255 => use idxByte
        float idxNorm = floor(raw * tilesX + 0.0001);
        float idxByte = floor(raw * 255.0 + 0.5);

        // prefer byte decode if it looks valid for tilesX, otherwise use normalized decode
        float idx = idxNorm;
        if (idxByte >= 0.0 && idxByte < tilesX) {
            idx = idxByte;
        }

        // handle accidental full-white (=1.0) mapping to last tile explicitly
        if (raw > 0.9999) { idx = tilesX - 1.0; }

        idx = clamp(idx, 0.0, tilesX - 1.0);

        // debug: show index read as red ramp or raw value if enabled
        if (debugMode > 0.5) {
            return vec4((idx + 0.5) / tilesX, raw, 0.0, 1.0);
        }

        vec2 mapPixel = uv * mapSize;
        vec2 pixelInTile = mod(mapPixel, textureSize);
        vec2 atlasPixel = vec2(idx * textureSize.x + pixelInTile.x, pixelInTile.y);
        vec2 atlasUV = atlasPixel / atlasSize;

        return Texel(atlas, atlasUV) * color;
    }
]]
-- ...existing code...
TextureShader = love.graphics.newShader(textureCode)
TextureShader:send("atlas", TextureAtlas)
TextureShader:send("textureSize", {300,300})
TextureShader:send("atlasSize", {TextureAtlas:getWidth(), TextureAtlas:getHeight()})
TextureShader:send("tilesX", #TextureKeys )
TextureShader:send("debugMode", 0.0) -- set to 1.0 for visual debug
-- ...existing code...

---/// ############################################# ///---
---/// FUNCTION THAT DRAWS THE TILE USING THE SHADER ///---
---/// ############################################# ///---
function Shader.DrawTile(tile,x,y,sx,sy)
    -- ensure the index/map image is sampled with nearest filtering (prevents interpolation)
    if tile and tile.setFilter then
        tile:setFilter('nearest','nearest')
    end

    -- send the pixel size of the source index image so the shader can compute local pixel coords
    TextureShader:send("mapSize", { tile:getWidth(), tile:getHeight() })

    love.graphics.setShader( TextureShader )
    love.graphics.draw(tile, x,y, 0, sx,sy )
    love.graphics.setShader( )
end



 
return Shader