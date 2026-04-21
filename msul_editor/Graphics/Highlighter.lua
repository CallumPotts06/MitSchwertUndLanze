
---/// LIBRARY ///---
--the purpose of this library is to create functions that draw the highlights of (usualy) unit control--
--and selection. For example, highlight unit will create a box aroung the unit to highlight it--
Highlighter = {}

--// IMPORT OTHER LIBRARIES //--
Vector = require("../Mathematics/Vector")
Mathematics = require("../Mathematics/Mathematics")
Colours = require("../Interface/Colours")

---/// METHODS & FUNCTIONS ///---

--creates a box around an area given by two vectors--
function Highlighter.Box(position,size,colour)
    --set colour
    Colours.SetColour(colour)
    --render box
    love.graphics.rectangle("line",position.X,position.Y,size.X,size.Y)
end

return Highlighter