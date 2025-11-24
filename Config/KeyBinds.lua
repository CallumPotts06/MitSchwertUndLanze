
KeyBinds = {}

--Default Values--
KeyBinds.Move = "q"
KeyBinds.Wheel = "e"
KeyBinds.Charge = "r"
KeyBinds.Target = "t"
KeyBinds.Double = "z"
KeyBinds.Unselect = "x"
KeyBinds.Up = "w"
KeyBinds.Down = "s"
KeyBinds.Left = "a"
KeyBinds.Right = "d"
KeyBinds.ZoomIn = "up"
KeyBinds.ZoomOut = "down"


KeyBinds.MoveCursor = love.mouse.newCursor("Assets/Images/Icons/MoveTo.png",20,20)
KeyBinds.DoubleCursor = love.mouse.newCursor("Assets/Images/Icons/DoubleQuick.png",20,20)
KeyBinds.WheelCursor = love.mouse.newCursor("Assets/Images/Icons/Wheel.png",20,20)
KeyBinds.ChargeCursor = love.mouse.newCursor("Assets/Images/Icons/Charge.png",20,20)
KeyBinds.TargetCursor = love.mouse.newCursor("Assets/Images/Icons/TargetedFire.png",20,20)


KeyBinds.UnitActions = {
    "Move",
    "Wheel",
    "Charge",
    "Target",
    "Double",
    "Unselect"
}


KeyBinds.CameraActions = {
    "Up",
    "Down",
    "Left",
    "Right",
    "ZoomIn",
    "ZoomOut"
}




return KeyBinds