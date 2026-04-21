
mouse = {}

function mouse.Button1Down()
    local x,y = love.mouse.getPosition()
    local down = love.mouse.isDown(1)
    return down, x, y
end

return mouse