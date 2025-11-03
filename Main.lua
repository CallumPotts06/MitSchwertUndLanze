
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

--// IMPORT MILITARY CLASSES //--
Squad = require("Army/Squad")
Battalion = require("Army/Battalion")
Regiment = require("Army/Regiment")

--// IMPORT MENUS //--
MenuController = require("GameStates/Menu/MenuController")
TitleScreen = require("GameStates/Menu/TitleScreen")

--// END OF IMPORTS //--

---/// LOCAL VARIABLES ///---
local cumulativeTime = 0


----//// ** LOVE LOAD FUNCTION ** ////----
function love.load()
    local success = love.window.setFullscreen(true)--set the screen to full screen--
    --MenuController.InitialiseMenu("TitleScreen")--open title screen on opening the game

    --load squads for gameplay--
    Squad.LoadAllSquads()
    local tempReg = {}
    battalion1 = Battalion.New("Battalion 1",tempReg,"Germany","Infantry","DeutscherLineninfanterie","PreussischerLineninfanterie",Vector.New(500,500,0),"Summer")
    battalion1:UpdateCurrentImage()
end

----//// ** LOVE UPDATE FUNCTION ** ////----
local soldierIndex = 1
local timer1 = 0

function love.update(dt)
    timer1=timer1+dt
    cumulativeTime = cumulativeTime + dt

    if timer1>=1 then timer1=timer1-1 soldierIndex=soldierIndex+1 end

    local mouseData = Mouse.GetData(true,cumulativeTime)
    --MenuController.CheckForClicks(mouseData.Position,mouseData.LMBDown)
end

----//// ** LOVE DRAW FUNCTION ** ////----
function love.draw()
    --MenuController.DrawMenu()
    love.graphics.setBackgroundColor(0.35, 0.6, 0.35)

    battalion1:DrawBattalion()
end