
Colours = {}

--// CONSTANTS //--
Colours.White = {1,1,1,1}
Colours.Black = {0,0,0,1}
Colours.FullRed = {1,0,0,1}
Colours.FullGreen = {0,1,0,1}
Colours.FullBlue = {0,0,1,1}

Colours.LightGray = {0.8,0.8,0.8,1}
Colours.DarkGray = {0.1,0.1,0.1,1}
Colours.Red = {0.75,0.1,0.1,1}
Colours.Green = {0.1,0.75,0.1,1}
Colours.Blue = {0.1,0.1,0.75,1}

Colours.MediumGray = {0.5,0.5,0.5,1}
Colours.MediumRed = {0.6,0.1,0.1,1}
Colours.MediumGreen = {0.1,0.6,0.1,1}
Colours.MediumBlue = {0.1,0.1,0.6,1}

Colours.Transparent = {1,1,1,0}

--// CONVERSIONS //--
function Colours.CreateColour(table)
    newSet = {}
    newSet.R = table[1]
    newSet.G = table[2]
    newSet.B = table[3]
    newSet.A = table[4]
    return newSet
end

function Colours.ConvertTo255(set)
    local r = set.R*255
    local g = set.G*255
    local b = set.B*255
    local a = set.A*255
    local newSet = {}
    newSet.R = r
    newSet.G = g
    newSet.B = b
    newSet.A = a
    return newSet
end


function Colours.ConvertTo1(set)
    local r = set.R/255
    local g = set.G/255
    local b = set.B/255
    local a = set.A/255
    local newSet = {}
    newSet.R = r
    newSet.G = g
    newSet.B = b
    newSet.A = a
    return newSet
end

function Colours.AddColours(colour1,colour2)
    local newSet = {}
    newSet.R = colour1.R + colour2.R
    newSet.G = colour1.G + colour2.G
    newSet.B = colour1.B + colour2.B

    if newSet.R>1 then newSet.R=1 end
    if newSet.G>1 then newSet.G=1 end
    if newSet.B>1 then newSet.B=1 end
    return newSet
end

function Colours.AverageColours(colourList)
    local newSet = {}
    newSet.R = colourList[1].R
    newSet.G = colourList[1].G
    newSet.B = colourList[1].B

    for i=2,#colourList,1 do
        newSet.R = (newSet.R+colourList[i].R)/2
        newSet.G = (newSet.G+colourList[i].G)/2
        newSet.B = (newSet.B+colourList[i].B)/2
    end

    return newSet
end


function Colours.SetColour(colour)
    if (colour.R>1)or(colour.G>1)or(colour.B>1) then
        colour = Colours.ConvertTo1(colour)
    end
    love.graphics.setColor(colour.R,colour.G,colour.B,colour.A)
end


function Colours.ResetColour()
    love.graphics.setColor(1,1,1,1)
end

return Colours