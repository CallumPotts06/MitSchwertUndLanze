
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
function Effects.DrawShadow(drawable,pos)
    --equation works out the angle to draw the shadow--
    local shadowAngle = math.sin((TimeOfDay-1200)/600)

    --find the offset required to re-align shadow and the would be original image--
    local offsetX=0
    local offsetY=0

    local imgX = drawable:getWidth()
    local imgY = drawable:getHeight()

    if shadowAngle>0 then 
        offsetX = (imgX*math.tan(shadowAngle))
        offsetY = (1*math.cos(shadowAngle))
    else 
        offsetX = -(1*math.tan(shadowAngle)) 
        offsetY = (imgY*math.tan(shadowAngle))
    end

    --other variables--
    local shadowScale = Vector.New(1.0,1.1)
    local shadowPos = Vector.New(pos.X+offsetX,pos.Y-offsetY)

    --draw the shadow to screen--
    Colours.SetColour(Colours.CreateColour(Effects.SHADOW_COLOUR))
    love.graphics.draw(drawable,shadowPos.X,shadowPos.Y,shadowAngle,shadowScale.X,shadowScale.Y)
    Colours.ResetColour()
end

return Effects