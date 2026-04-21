
--// IMPORT OTHER LIBRARIES //--
Keybinds = require("../EditorLibraries/Keybinds")

---/// LIBRARY ///---
--role of the library is to create methods that control input--

InputControl = {}

function InputControl.CheckAction(action)
    local keyToCheck = " "

    --map action onto key--
    if action == "Up" then
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

    if input=="Up" then CameraPosition.Y = CameraPosition.Y + 10 
    elseif input=="Down" then CameraPosition.Y = CameraPosition.Y - 10 
    elseif input=="Left" then CameraPosition.X = CameraPosition.X + 10 
    elseif input=="Right" then CameraPosition.X = CameraPosition.X - 10 
    elseif input=="ZoomIn" then CameraZoom = CameraZoom * 1.01
    elseif input=="ZoomOut" then CameraZoom = CameraZoom / 1.01 end
end


function InputControl.ApplyAllInputs()
    --loop through every possible action--
    for i = 1,#Keybinds.CameraActions,1 do
        local result = InputControl.CheckAction(Keybinds.CameraActions[i])
        if result[1] then InputControl.MoveCamera(result[2]) end
    end
end

return InputControl