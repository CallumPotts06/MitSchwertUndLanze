
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
Effects.WEATHER_COLOURS.FOG = Colours.CreateColour({1,1,1,0.35})--Translucent White--
Effects.WEATHER_COLOURS.CLOUDS = Colours.CreateColour({0,0,0.12,0.4})--Translucent Black--

Effects.WEATHER_COLOURS.DAWN_DUSK_MULTIPLIERS = {}
Effects.WEATHER_COLOURS.DAWN_DUSK_MULTIPLIERS.R = 1
Effects.WEATHER_COLOURS.DAWN_DUSK_MULTIPLIERS.G = 0.6275
Effects.WEATHER_COLOURS.DAWN_DUSK_MULTIPLIERS.B = 0.15

---/// VARIABLES ///---
Effects.CurrentSeason = "Summer"
Effects.CurrentWeather = "Sunny"


---//// LOCALLY USED FUNCTIONS ///---
Effects.LightingEquations = {}
function Effects.LightingEquations.SummerFunc(x,currentClr)
    --set a multiplier based on which colour is being calculated--
    local m = 550000
    if currentClr == "R" then m = 250000
    elseif currentClr == "G" then m = 400000
    elseif currentClr == "B" then m = 750000 end

    --using quadratic equation to model colour changes over time--
    local y = ( -(x*x) + 2500*(x) - 840000 ) / m
    
    --ensure there is still light during night and it caps at 1 during midday--
    if currentClr == "R" then
        if y<0.1 then y = 0.1 end
        if y>1 then y = 1 end
    elseif currentClr == "G" then
        if y<0.1 then y = 0.1 end
        if y>1 then y = 1 end
    elseif currentClr == "B" then
        if y<0.175 then y = 0.175 end
        if y>1 then y = 1 end
    end

    return y
end

---/// METHODS & FUNCTIONS ///---

--draws a shadow which is cast at angle depending on the suns position--
function Effects.DrawShadow(img, pos, imgType)
    local imgW = 1
    local imgH = 1
    if imgType == "Mesh" then
        for i = 1, img:getVertexCount() do
            local vx, vy = img:getVertex(i)
            if vx > imgW then imgW = vx end
            if vy > imgH then imgH = vy end
        end
    else
        imgW = img:getWidth()
        imgH = img:getHeight()
    end

    --create an angle value from the time of day--
    local sunAngle = (TimeOfDay - 1200) / 600  -- ranges -1 to 1
    --creates the length of the shadow--
    local shadowLength = math.sqrt(math.abs(math.sin(sunAngle)))
    --use trignometry to find the direction to cast the shadow--
    local shadowDirection = math.sin(sunAngle)  -- inbetween -1, 0, and 1
    if sunAngle == 0 then shadowDirection = 0 end
    --set an origin for the shadow--
    local originX = (imgW / 2)
    local originY = (imgH)

    local newPos = Vector.New(pos.X, pos.Y)

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
    transform:translate(newPos.X, newPos.Y)
    transform:scale(CameraZoom, CameraZoom)
    transform:translate(originX, originY)
    --shearing horizontally will cast the shadow in a realistic manner--
    local shearAmount = -4 * shadowLength * shadowDirection
    transform:shear(shearAmount, 0)
    transform:scale(1, 0.6)
    transform:translate(-originX, -originY)

    --draw the shadow--
    love.graphics.draw(img, transform)
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

    local dawnBounds = {30,1000}
    local duskBounds = {1930,2650}

    local dayColour = {}
    local newColour = {}

    dayColour.R = Effects.LightingEquations.SummerFunc(TimeOfDay, "R")
    dayColour.G = Effects.LightingEquations.SummerFunc(TimeOfDay, "G")
    dayColour.B = Effects.LightingEquations.SummerFunc(TimeOfDay, "B")
    dayColour.A = 1

    if not background then
        dayColour.R = 2.5 * dayColour.R
        dayColour.G = 2.5 * dayColour.G
        dayColour.B = 2.5 * dayColour.B
    end

    if dayColour.R>1 then dayColour.R=1 end
    if dayColour.G>1 then dayColour.G=1 end
    if dayColour.B>1 then dayColour.B=1 end

    newColour.R = inputColour.R * dayColour.R
    newColour.G = inputColour.G * dayColour.G
    newColour.B = inputColour.B * dayColour.B
    newColour.A = inputColour.A

    table.insert(colourTable,dayColour)
    return newColour
end

function Effects.WeatherColour()
    local weatherClr = Colours.CreateColour({1,1,1,0})
    if Effects.CurrentWeather == "Foggy" then
        weatherClr = Effects.WEATHER_COLOURS.FOG
    elseif Effects.CurrentWeather == "Cloudy" then
        weatherClr = Effects.WEATHER_COLOURS.CLOUDS
    elseif Effects.CurrentWeather == "Rainy" then
        weatherClr = Effects.WEATHER_COLOURS.CLOUDS
    end

    Colours.SetColour(weatherClr)
    love.graphics.rectangle("fill",0,0,ScreenX,ScreenY)
    Colours.ResetColour()
end








----//// ####################################### ////----
----//// BATTLEFIELD EFFECT FUNCTIONS AND TABLES ////----
----//// ####################################### ////----

Effects.CurrentSmokeEffects = {}
Effects.CurrentMissEffects = {}

Effects.SmokeEffects = { 
    love.graphics.newImage("Assets/Images/Effects/Smoke1.png") 
}

Effects.MissEffects = { 
    love.graphics.newImage("Assets/Images/Effects/BulletHit1.png"),
    love.graphics.newImage("Assets/Images/Effects/BulletHit2.png"),
    love.graphics.newImage("Assets/Images/Effects/BulletHit3.png"),
}


---/// CREATE EFFECT FUNCTIONS ///---
function Effects.CreateNewSmoke(pos,size)
    local object = {}

    object.Position = pos
    object.Position:ToGamePosition()
    object.Position = Mathematics.VectorFromAddition( object.Position, Vector.New(15, 30) )
    object.Size = 1.8
    object.Age = 0
    object.End = 15
    object.SmokeImage = math.random(1,1)

    if size == "Artillery" then object.Size = 5 end

    table.insert(Effects.CurrentSmokeEffects, object)
end

function Effects.CreateNewMiss(pos)
    local object = {}

    object.Position = pos
    object.Position:ToGamePosition()
    local ranVector = Vector.New( math.random(-40,40), math.random(-40,40) )
    object.Position = Mathematics.VectorFromAddition( object.Position, ranVector )
    object.Size = 2.25
    object.Age = 0
    object.End = 2.5
    object.MissImage = math.random(1,3)

    table.insert(Effects.CurrentMissEffects, object)
end



---/// EFFECTS UPDATE AND DRAW FUNCRIONS ///---
function Effects.DrawEffects()

    for i = #Effects.CurrentSmokeEffects,1,-1 do
        local object = Effects.CurrentSmokeEffects[i]

        local scale = object.Size * CameraZoom
        scale = scale * ( ( (-1/18) * object.Age ) + 1 )

        local drawPos = Vector.New( object.Position.X, object.Position.Y )
        drawPos:ToScreenPosition()

        local transparency = ( (-0.2/15) * object.Age ) + 0.2
        love.graphics.setColor(1, 1, 1, transparency)

        love.graphics.draw(Effects.SmokeEffects[object.SmokeImage], drawPos.X, drawPos.Y, 0, scale, scale)
    end

    for i = #Effects.CurrentMissEffects,1,-1 do
        local object = Effects.CurrentMissEffects[i]

        local scale = object.Size * CameraZoom

        local drawPos = Vector.New( object.Position.X, object.Position.Y )
        drawPos:ToScreenPosition()

        local transparency = ( (-1/3) * object.Age ) + 1
        love.graphics.setColor(1, 1, 1, transparency)

        love.graphics.draw(Effects.MissEffects[object.MissImage], drawPos.X, drawPos.Y, 0, scale, scale)
    end

    love.graphics.setColor(1, 1, 1, 1)

end

function Effects.UpdateEffects()

    ---/// SMOKE EFFECTS ///---
    for i = #Effects.CurrentSmokeEffects,1,-1 do
        Effects.CurrentSmokeEffects[i].Age = Effects.CurrentSmokeEffects[i].Age + 0.2
        if Effects.CurrentSmokeEffects[i].Age >= Effects.CurrentSmokeEffects[i].End then
            table.remove(Effects.CurrentSmokeEffects, i)
        end
    end

    ---/// MISS EFFECTS ///---
    for i = #Effects.CurrentMissEffects,1,-1 do
        Effects.CurrentMissEffects[i].Age = Effects.CurrentMissEffects[i].Age + 0.2
        if Effects.CurrentMissEffects[i].Age >= Effects.CurrentMissEffects[i].End then
            table.remove(Effects.CurrentMissEffects, i)
        end
    end
end

return Effects