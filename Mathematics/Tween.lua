
--// IMPORT LIBRARIES //--
Mathematics = require("Mathematics")

--// TWEEN CLASS //--
Tween = {}
Tween.__index =  Tween

--// CONSTRUCTOR //--
function Tween.New(startVector,endVector,stepSize)
    --create a new table for the object--
    local newTween = {}

    local 

    setmetatable(newTween,{__index=Tween})--map the new table onto the tween class--
    return newTween--return the new tween--
end

return Tween