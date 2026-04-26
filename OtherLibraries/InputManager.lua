
--// IMPORT OTHER LIBRARIES //--
Keybinds = require("../Config/Keybinds")

---/// LIBRARY ///---
--role of the library is to create methods that control input--

InputControl = {}

function InputControl.CheckAction(action)
    local keyToCheck = " "

    --map action onto key--
    if action == "Move" then
        keyToCheck = KeyBinds.Move

    elseif action == "Wheel" then
        keyToCheck = KeyBinds.Wheel

    elseif action == "Charge" then
        keyToCheck = KeyBinds.Charge

    elseif action == "Target" then
        keyToCheck = KeyBinds.Target

    elseif action == "Double" then
        keyToCheck = KeyBinds.Double

    elseif action == "Unselect" then
        keyToCheck = KeyBinds.Unselect
    elseif action == "Up" then
        keyToCheck = KeyBinds.Up
    elseif action == "Down" then
        keyToCheck = KeyBinds.Down
    elseif action == "Left" then
        keyToCheck = KeyBinds.Left
    elseif action == "Right" then
        keyToCheck = KeyBinds.Right
    elseif action == "ZoomIn" then
        keyToCheck = KeyBinds.ZoomIn
    elseif action == "ZoomOut" then
        keyToCheck = KeyBinds.ZoomOut
    
    end 

    --check key with input detection from love 2d--
    local keyDown = love.keyboard.isDown(keyToCheck)

    return {keyDown, action}
end





function InputControl.MoveCamera(input)
    CameraMoved = true

    if input=="Up" then CameraPosition.Y = CameraPosition.Y + 15 
    elseif input=="Down" then CameraPosition.Y = CameraPosition.Y - 15 
    elseif input=="Left" then CameraPosition.X = CameraPosition.X + 15 
    elseif input=="Right" then CameraPosition.X = CameraPosition.X - 15 
    elseif input=="ZoomIn" then 
        local sw, sh = love.graphics.getWidth(), love.graphics.getHeight()
        local screenCenterX, screenCenterY = sw / 2, sh / 2
        
        -- World coordinate at screen center before zoom (screenPos = worldPos * zoom + camPos)
        local worldX = (screenCenterX - CameraPosition.X) / CameraZoom
        local worldY = (screenCenterY - CameraPosition.Y) / CameraZoom
        
        -- Apply zoom
        CameraZoom = CameraZoom * 1.02
        
        -- Adjust camera so world point stays at screen center
        CameraPosition.X = screenCenterX - (worldX * CameraZoom)
        CameraPosition.Y = screenCenterY - (worldY * CameraZoom)
    elseif input=="ZoomOut" then 
        local sw, sh = love.graphics.getWidth(), love.graphics.getHeight()
        local screenCenterX, screenCenterY = sw / 2, sh / 2
        
        -- World coordinate at screen center before zoom (screenPos = worldPos * zoom + camPos)
        local worldX = (screenCenterX - CameraPosition.X) / CameraZoom
        local worldY = (screenCenterY - CameraPosition.Y) / CameraZoom
        
        -- Apply zoom
        CameraZoom = CameraZoom / 1.01
        
        -- Adjust camera so world point stays at screen center
        CameraPosition.X = screenCenterX - (worldX * CameraZoom)
        CameraPosition.Y = screenCenterY - (worldY * CameraZoom)
    end
end





function InputControl.ChangeUnitControl(input)
    if input=="Unselect" then CurrentUnit = false CurrentUnitControl = "" CurrentUnitScreen = false love.mouse.setCursor()
    else 
        if input=="Move" then love.mouse.setCursor( Keybinds.MoveCursor )
        elseif input=="Double" then love.mouse.setCursor( Keybinds.DoubleCursor )
        elseif input=="Wheel" then love.mouse.setCursor( Keybinds.WheelCursor )
        elseif input=="Charge" then love.mouse.setCursor( Keybinds.ChargeCursor )
        elseif input=="Target" then love.mouse.setCursor( Keybinds.TargetCursor ) end 
        CurrentUnitControl = input 
    end
end





function InputControl.ApplyAllInputs()
    --loop through every possible action--
    for i = 1,#Keybinds.UnitActions,1 do
        local result = InputControl.CheckAction(Keybinds.UnitActions[i])
        if result[1] then InputControl.ChangeUnitControl(result[2]) end
    end


    for i = 1,#Keybinds.CameraActions,1 do
        local result = InputControl.CheckAction(Keybinds.CameraActions[i])
        if result[1] then InputControl.MoveCamera(result[2]) end
    end
end

function InputControl.ControlUnit(mousedata, unit)
    if not unit then return false end

    if unit.UnitClass == "Battalion" then unit = unit.Regiment end

    --if CurrentUnitScreen then CurrentUnitScreen:CheckForClicks(mousedata.Position,mousedata.LMBDown) end

    local movePos = mousedata.Position
    movePos:ToGamePosition()

    if mousedata.LMBDown then
        -- Move Unit To Mouse Position --
        if CurrentUnitControl == "Move" then
            print(movePos.X..","..movePos.Y)
            unit:MoveRegiment(movePos)
        end


    end
end

return InputControl