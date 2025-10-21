
--// IMPORT OTHER LIBRARIES / CLASSES //--
Vector = require("Mathematics/Vector")

Mathematics = {}

--// ATTRIBUTES / CONSTANTS //--
Mathematics.RADIAN = 180/(math.pi)


--// METHODS //--
function Mathematics.NumericalMagnitude(n)
    --finds the magnitude of a number (if its negative)--
    n = math.sqrt(n*n)
    return n--returns a numerical value--
end

function Mathematics.VectorFromSubtraction(Vector1,Vector2)
    --finds the difference between two vectors--
    local dx = Vector1.X-Vector2.X
    local dy = Vector1.Y-Vector2.Y
    local dVector = Vector.New(dx,dy,dth)

    return dVector--returns a vector object--
end 


function Mathematics.VectorFromAddition(Vector1,Vector2)
    --adds the two vectors together--
    local x = Vector1.X+Vector2.X
    local y = Vector1.Y+Vector2.Y
    local newVector = Vector.New(x,y,th)

    return newVector--returns a vector object--
end

function Mathematics.VectorFromMultiplication(Vector1,Magnitude)
    --multiplies the vector by a magnitude--
    local x = Vector1.X*Magnitude
    local y = Vector1.Y*Magnitude
    local newVector = Vector.New(x,y,th)

    return newVector--returns a vector object--
end 

function Mathematics.VectorFromDivision(Vector1,Magnitude)
    --Divides the vector by a magnitude--
    local x = Vector1.X/Magnitude
    local y = Vector1.Y/Magnitude
    local newVector = Vector.New(x,y,th)

    return newVector--returns a vector object--
end 


function Mathematics.VectorMagnitude(Vector1,Vector2)
    --finds the magnitude between two vectors as a pose to one vector--
    local dx = Vector1.X-Vector2.X
    local dy = Vector1.Y-Vector2.Y

    local mag = math.sqrt((dx*dx)+(dy*dy))

    return mag--returns a numerical value--
end


function Mathematics.VectorFromAngle(Magnitude,Bearing)
    --creates a vector from a magnitude and a angle (from north)--
    Bearing = Bearing % (2*math.pi)

    local x=0
    local y=0
    local theta=0

    --using the ASTC rule for trig--
    if Bearing<(math.pi/2) then--th < 90deg--
        theta = (math.pi/2)-Bearing
        x=Magnitude*math.cos(theta)
        y=-Magnitude*math.sin(theta)

    elseif Bearing<(math.pi) then--th < 180deg--
        theta = (math.pi)-Bearing
        x=Magnitude*math.sin(theta)
        y=Magnitude*math.cos(theta)

    elseif Bearing<((3*math.pi)/2) then--th < 270deg--
        theta = Bearing-(math.pi)
        x=-Magnitude*math.sin(theta)
        y=Magnitude*math.cos(theta)

    else--th < 360deg--
        theta = (2*math.pi)-Bearing
        x=-Magnitude*math.sin(theta)
        y=-Magnitude*math.cos(theta)

    end 

    local newVector = Vector.New(x,y,Bearing)
    return newVector--returns a vector object--
end


function Mathematics.ForwardVector(Vector,Magnitude)
    --creates a vector forwards in the direction of the vector provided by the arg for the magnitude given--
    local newVector = Mathematics.VectorFromAngle(Magnitude,Vector.Theta)
    return newVector--returns a vector object--
end


function Mathematics.RightVector(Vector,Magnitude)
    --creates a vector right in the direction of the vector provided by the arg for the magnitude given--
    local extraTheta = (math.pi/2)
    local newVector = Mathematics.VectorFromAngle(Magnitude,Vector.Theta+extraTheta)
    return newVector--returns a vector object--
end


function Mathematics.AngleFromVector(Vector1)
    --creates a number value of radians between two vectors in space--
    local dx = Vector1.X 
    local dy = Vector1.Y
    local theta = 0

    if (dx>=0) and (dy<=0) then --"north east"--
        dy=Mathematics.NumericalMagnitude(dy)
        theta = (math.atan(dx/dy))

    elseif (dx>=0) and (dy>=0) then --"south east"--
        theta = (math.atan(dy/dx) + (math.pi/2))

    elseif (dx<=0) and (dy>=0) then --"south west"--
        dx=Mathematics.NumericalMagnitude(dx)
        theta = ((math.pi*1.5) - math.atan(dy/dx))

    elseif (dx<=0) and (dy<=0) then --"north west"--
        dx=Mathematics.NumericalMagnitude(dx)
        dy=Mathematics.NumericalMagnitude(dy)
        theta = ((math.pi*2) - math.atan(dx/dy))

    end

    theta = Mathematics.NumericalMagnitude(theta)--make theta positive--

    return theta--return numerical value--
end


function Mathematics.ScreenScaleVector(x,y)
    --returns a vector in pixels from a ration given in x,y--
    local scrnX,scrnY = love.graphics.getDimensions()

    local newX = (x*scrnX)--scales x and y accordingly--
    local newY = (y*scrnY)

    local newVector = Vector.New(newX,newY)--creates a new vector with the x and y values--
    return newVector--returns a vector object--
end

return Mathematics