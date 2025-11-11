
---/// LIBRARY ///---
--library is designed to bring all lighting and other visual effects under one umbrella as two save having--
--to rewrite code over and over again--
Effects = {}

--// IMPORT OTHER LIBRARIES //--
Vector = require("../Mathematics/Vector")
Mathematics = require("../Mathematics/Mathematics")
Colours = require("../Interface/Colours")

---/// CONSTANTS ///---
Effects.SHADOW_COLOUR = {0,0,0,0.5}


---/// METHODS & FUNCTIONS ///---

--draws a shadow which is cast at angle depending on the suns position--
function Effects.DrawShadow(img, pos)

    --[[print("\n\nSHADOW PIVOTS: LEFT=("..tostring(img.ShadowPivotLeft.X)..","..tostring(img.ShadowPivotLeft.Y)..")")
    print("SHADOW PIVOTS: RIGHT=("..tostring(img.ShadowPivotRight.X)..","..tostring(img.ShadowPivotRight.Y)..")")

    local shadowAngle = (TimeOfDay - 1200) / 600
    local shadowScale = Vector.New(
        (1 - (0.4 * math.sin(math.abs(shadowAngle)))), 
        (0.4 + (0.4 * math.sin(math.abs(shadowAngle))))
    )
    local offset = Vector.New(0, 0)

    local imgW = img.Drawable:getWidth()
    local imgH = img.Drawable:getHeight()

    -- choose origin based on angle
    local ox, oy
    if shadowAngle > 0 then
        -- anchor at bottom-right
        ox, oy = img.ShadowPivotRight.X, img.ShadowPivotRight.Y
        offset = Vector.New(imgW+(0.5*shadowScale.X), imgH)
    else
        -- anchor at bottom-left
        ox, oy = img.ShadowPivotLeft.X, img.ShadowPivotLeft.Y
        offset = Vector.New(0+(0.5*shadowScale.X), imgH)
    end]]

    local shadowAngle = (TimeOfDay - 1200) / 600
    local shadowScale = Vector.New(
        (1 - (0.4 * math.sin(math.abs(shadowAngle)))), 
        (1.04 + (0.25 * math.sin(math.abs(shadowAngle))))
    )
    local offset = Vector.New(0, 0)

    local imgW = img.Drawable:getWidth()
    local imgH = img.Drawable:getHeight()

    -- choose origin based on angle
    local ox, oy
    if shadowAngle > 0 then
        -- anchor at bottom-right
        ox, oy = imgW, imgH
        offset = Vector.New(imgW+(0.5*shadowScale.X), imgH)
    else
        -- anchor at bottom-left
        ox, oy = 0, imgH
        offset = Vector.New(0+(0.5*shadowScale.X), imgH)
    end

    -- draw shadow
    Colours.SetColour(Colours.CreateColour(Effects.SHADOW_COLOUR))
    love.graphics.draw(
        img.Drawable,
        pos.X + offset.X, pos.Y + offset.Y,
        shadowAngle,
        shadowScale.X, shadowScale.Y,
        ox, oy
    )
    Colours.ResetColour()
end




function Effects.LightingColour() end

return Effects