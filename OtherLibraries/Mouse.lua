
--// IMPORT LIBRARIES AND CLASSES //--
Vector = require("../Mathematics/Vector")


Mouse = {}

lmbdebounce = false
lmbreleased = false
local lastclicktime = 0

function Mouse.GetData(debounceOn,time)
    --creates an empty table for the new object--
    local mouseData = {}

    --gets the data from love functions--
    local x,y = love.mouse.getPosition()
    lmbDown = love.mouse.isDown(1)
    if not lmbDown then lmbdebounce = false lmbreleased = true end

    --applies the data to more meaningfull attributes--
    mouseData.Position = Vector.New(x,y)

    -- debounce for lmb --
    if debounceOn then
        if (time - lastclicktime) > 0.25 then
            lmbdebounce = false
        end

        if not lmbdebounce and lmbDown and lmbreleased then
            lmbreleased = false
            lmbdebounce = true
            lastclicktime = time
            mouseData.LMBDown = true
        else
            mouseData.LMBDown = false
        end
    else
        mouseData.LMBDown = lmbDown
    end

    --returns an object containing the necessary data--
    return mouseData
end

return Mouse