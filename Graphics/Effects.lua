
---/// LIBRARY ///---
--library is designed to bring all lighting and other visual effects under one umbrella as two save having--
--to rewrite code over and over again--
Effects = {}

--// IMPORT OTHER LIBRARIES //--
Vector = require("../Mathematics/Vector")
Mathematics = require("../Mathematics/Mathematics")
Colours = require("../Interface/Colours")
Shaders = require("../Graphics/Shaders")

---/// CONSTANTS ///---
Effects.SHADOW_COLOUR = {0,0,0,0.5}
Effects.WEATHER_COLOURS = {}
Effects.WEATHER_COLOURS.FOG = Colours.CreateColour({1,1,1,0.2})--Translucent White--
Effects.WEATHER_COLOURS.CLOUDS = Colours.CreateColour({0.3,0.3,0.3,0.2})--Translucent Black--
Effects.WEATHER_COLOURS.SUNNY = Colours.CreateColour({0.2,0.2,1,0.2})--Translucent Blue--

Effects.WEATHER_COLOURS.DAWN_DUSK_MULTIPLIERS = {}
Effects.WEATHER_COLOURS.DAWN_DUSK_MULTIPLIERS.R = 1
Effects.WEATHER_COLOURS.DAWN_DUSK_MULTIPLIERS.G = 0.6275
Effects.WEATHER_COLOURS.DAWN_DUSK_MULTIPLIERS.B = 0


---/// VARIABLES ///---
Effects.CurrentSeason = "Winter"
Effects.CurrentWeather = "Sunny"

---/// METHODS & FUNCTIONS ///---

--draws a shadow which is cast at angle depending on the suns position--
function Effects.DrawShadow(img, pos)
    local imgW = img.Drawable:getWidth()
    local imgH = img.Drawable:getHeight()
    

    --create an angle value from the time of day--
    local sunAngle = (TimeOfDay - 1200) / 600  -- ranges -1 to 1
    --creates the length of the shadow--
    local shadowLength = math.sqrt(math.abs(math.sin(sunAngle)))
    --use trignometry to find the direction to cast the shadow--
    local shadowDirection = math.sin(sunAngle)  -- inbetween -1, 0, and 1
    if sunAngle == 0 then shadowDirection = 0 end
    --set an origin for the shadow--
    local originX = imgW / 2
    local originY = imgH


    --set the parameters for the blur shader--
    Shaders.Blur:send("radius", 0.5 + (1.5 * shadowLength))
    Shaders.Blur:send("texSize", {imgW, imgH})
    love.graphics.setShader(Shaders.Blur)
    --create the shadow colour--
    local shadowAlpha = 0.6*((math.abs(sunAngle)/2)+0.5)
    local shadowColour = Colours.CreateColour({0, 0, 0, shadowAlpha})
    Colours.SetColour(shadowColour)

    
    --create a transform object to manipulate the shadow--
    local transform = love.math.newTransform()
    transform:translate(pos.X, pos.Y)
    transform:translate(originX, originY)
    --shearing horizontally will cast the shadow in a realistic manner--
    local shearAmount = -4 * shadowLength * shadowDirection
    transform:shear(shearAmount, 0)
    transform:scale(1, 0.6)
    transform:translate(-originX, -originY)

    --draw the shadow--
    love.graphics.draw(img.Drawable, transform)
    love.graphics.setShader()
    Colours.ResetColour()
end



--function sets the current colour as to light the screen according to the time and weather--
function Effects.LightingColour(inputColour,background)
    local dawnClr = Effects.WEATHER_COLOURS.DAWN_DUSK_MULTIPLIERS
    
    --setup variables--
    local colourTable = {inputColour}
    local dawnMultiplier = math.cos( ( TimeOfDay - 500 ) / 200 )
    local duskMultiplier = math.cos( ( TimeOfDay + 200 ) / 200 )

    local dawnBounds = {200,800}
    local duskBounds = {2000,2600}

    local dayMultiplier = 1
    if (Effects.CurrentSeason=="Summer")or(Effects.CurrentSeason=="Spring") then
        dayMultiplier = math.abs( math.cos ( (TimeOfDay-1200) / 900 ) )
    else
        dayMultiplier = math.abs( math.cos ( (TimeOfDay-1200) / 700 ) )
        dawnMultiplier = math.cos( ( TimeOfDay - 700 ) / 200 )
        duskMultiplier = math.cos( ( TimeOfDay + 600 ) / 200 )
        dawnBounds = {400,1000}
        duskBounds = {1600,2200}
    end

    if dayMultiplier>1 then dayMultiplier=1 end

    --DAYTIME EFFECT--
    --daytime effect brightens the colour depending on time of day--
    local dayColour = inputColour
    if background then
        dayColour.R = inputColour.R * (dayMultiplier)
        dayColour.G = inputColour.G * (dayMultiplier)
        dayColour.B = inputColour.B * (dayMultiplier)
    else
        dayColour.R = 1.03 * inputColour.R * (dayMultiplier)
        dayColour.G = 1.04 * inputColour.G * (dayMultiplier)
        dayColour.B = 1.11 * inputColour.B * (dayMultiplier)
    end

    if dayColour.R>1 then dayColour.R=1 end
    if dayColour.G>1 then dayColour.G=1 end
    if dayColour.B>1 then dayColour.B=1 end

    --DAWN EFFECT--
    --dawn colour accounts for dawn orange colour--
    local dawnColour = Colours.CreateColour({1,1,1,1})
    if (TimeOfDay>dawnBounds[1])and(TimeOfDay<dawnBounds[2]) then--only apply dawn effect if its multiplier is > 0--
        dawnColour.R = dawnClr.R * (dawnMultiplier)
        dawnColour.G = dawnClr.G * (dawnMultiplier)
        dawnColour.B = dawnClr.B * (dawnMultiplier)
        --dayColour = Colours.AddColours(dayColour,dawnColour)
        dayColour = Colours.AverageColours({dayColour,dawnColour})
    end


    --DUSK EFFECT--
    --dusk colour accounts for dusk orange colour--
    local duskColour = Colours.CreateColour({1,1,1,1})
    if (TimeOfDay>duskBounds[1])and(TimeOfDay<duskBounds[2]) then--only apply dusk effect if its multiplier is > 0--
        duskColour.R = dawnClr.R * (duskMultiplier)
        duskColour.G = dawnClr.G * (duskMultiplier)
        duskColour.B = dawnClr.B * (duskMultiplier)
        --dayColour = Colours.AddColours(dayColour,duskColour)
        dayColour = Colours.AverageColours({dayColour,duskColour})
    end

    table.insert(colourTable,dayColour)
    


    print("Day Multiplier = "..tostring(dayMultiplier))

    local newColour = Colours.AverageColours(colourTable)
    return newColour
end

return Effects