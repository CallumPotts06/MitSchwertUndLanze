
--// IMPORT LIBRARIES //--
Mathematics = require("Mathematics/Mathematics")

Colours = require("Interface/Colours")
Font = require("Interface/Font")

Images = require("MediaHandler/Images")
Sounds = require("MediaHandler/Sounds")

Mouse = require("OtherLibraries/Mouse")
--// IMPORT CLASSES //--
Vector = require("Mathematics/Vector")

TextBox = require("Interface/TextBox")
ImageBox = require("Interface/ImageBox")
Screen = require("Interface/Screen")
--change--
--// IMPORT MENUS //--
MenuController = require("GameStates/Menu/MenuController")
TitleScreen = require("GameStates/Menu/TitleScreen")

--// END OF IMPORTS //--

---/// LOCAL VARIABLES ///---
local cumulativeTime = 0


----//// ** LOVE LOAD FUNCTION ** ////----
function love.load()
    local success = love.window.setFullscreen(true)--set the screen to full screen--
    MenuController.InitialiseMenu("TitleScreen")--open title screen on opening the game
end

----//// ** LOVE UPDATE FUNCTION ** ////----
function love.update(dt)
    cumulativeTime = cumulativeTime + dt

    local mouseData = Mouse.GetData(true,cumulativeTime)
    MenuController.CheckForClicks(mouseData.Position,mouseData.LMBDown)
end

----//// ** LOVE DRAW FUNCTION ** ////----
function love.draw()
    MenuController.DrawMenu()
end