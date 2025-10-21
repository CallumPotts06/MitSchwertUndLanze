
--// IMPORT LIBRARIES //--
Colours = require("../Interface/Colours")


--// VECTOR CLASS //--
Vector = {}
Vector.__index =  Vector

--// CONSTRUCTOR //--
function Vector.New(x,y,th)
    local newVector = {} --create a new table--

    if th==nil then th=0 end--sets theta to a default of 0rad so that no errors occur if th is not given on call--

    newVector.X = x --assign values--
    newVector.Y = y
    newVector.Theta = th

    setmetatable(newVector,{__index=Vector})--map the new table onto the Vector class--

    return newVector--return the new object--
end

--// OTHER METHODS //--
function Vector:Magnitude()
    local mag = math.sqrt((self.X*self.X)+(self.Y*self.Y))--pythagoras--
    return mag
end

function Vector:DrawVector(StartPoint,colour)
    --map out the positions--
    local x1 = StartPoint.X
    local x2 = StartPoint.X+self.X
    local y1 = StartPoint.Y
    local y2 = StartPoint.Y+self.Y

    --set colour and draw--
    Colours.SetColour(colour)
    love.graphics.line(x1,y1, x2,y2)--draws a line from a starting point to the end of the vector--
end

function Vector:DrawPosition(radius,shape,colour)
    --map out the positions
    local x = self.X
    local y = self.Y

    --set colour and draw--
    Colours.SetColour(colour)

    if shape == "Circle" then
        love.graphics.ellipse("fill", x, y, radius, radius, 50)
    elseif shape == "Square" then
        love.graphics.rectangle("fill", x, y, radius, radius)
    end
end

return Vector