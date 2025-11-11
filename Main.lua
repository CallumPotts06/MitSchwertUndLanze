
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
HUD = require("GameStates/Menu/GameHUD")

--// END OF IMPORTS //--

---/// LOCAL VARIABLES ///---
local cumulativeTime = 0


----//// ** LOVE LOAD FUNCTION ** ////----
function love.load()
    local success = love.window.setFullscreen(true)--set the screen to full screen--
    
    love.graphics.setDefaultFilter("nearest", "nearest")--removes anti aliasing--
    
    --MenuController.InitialiseMenu("TitleScreen")--open title screen on opening the game
    hudScreen = HUD.Open()

    --load squads for gameplay--
    Squad.LoadAllSquads()

    --battalion1 = Battalion.New("Battalion 1",{},"Germany","Artillery","DeutscherArtillerie","PreussischerArtillerie",Vector.New(500,200,math.rad(290)),"None",true)
    battalion1 = Battalion.New("Battalion 1",{},"Germany","Cavalry","PreussischerUhlanen","PreussischerUhlanen",Vector.New(500,200,math.rad(290)),"None",true)
    --battalion1 = Battalion.New("Battalion 1",{},"Germany","Cavalry","PreussischerDragoner","PreussischerDragoner",Vector.New(500,200,math.rad(290)),"None",true)
    --battalion1 = Battalion.New("Battalion 1",{},"Germany","Infantry","BayerischerLineninfanterie","BayerischerLineninfanterie",Vector.New(500,200,math.rad(290)),"Summer",true)
    --battalion1 = Battalion.New("Battalion 1",{},"Germany","Infantry","DeutscherGardeZuFuss","PreussischerGardeZuFuss",Vector.New(100,300,math.rad(180)),"Summer",true)

    battalion1:UpdateCurrentImage()
    battalion1:CreateFlagMeshes()
end

----//// ** LOVE UPDATE FUNCTION ** ////----
local unitAnimTimer = 0
local flagIncrement = -1
--/ GLOBALS /--
FlagTick = -5
CameraZoom = 0.5
TimeOfDay = 0600


function love.update(dt)
    unitAnimTimer=unitAnimTimer+dt
    cumulativeTime = cumulativeTime + dt

    if unitAnimTimer>=0.125 then unitAnimTimer=unitAnimTimer-0.125 FlagTick=FlagTick+flagIncrement TimeOfDay=TimeOfDay+1 end
    if FlagTick > 5 then flagIncrement = -1  end
    if FlagTick < -5 then flagIncrement = 1  end

    local mouseData = Mouse.GetData(true,cumulativeTime)
    --MenuController.CheckForClicks(mouseData.Position,mouseData.LMBDown)
    hudScreen.UiObjects[1].Text = "Time: "..tostring(TimeOfDay)
    hudScreen.UiObjects[1].TextData = love.graphics.newText(hudScreen.UiObjects[1].Font, "Time: "..tostring(TimeOfDay))
    hudScreen.UiObjects[1].Canvas = hudScreen.UiObjects[1]:CreateCanvas()
end

----//// ** LOVE DRAW FUNCTION ** ////----
function love.draw()
    --MenuController.DrawMenu()
    hudScreen:DrawScreen()

    love.graphics.setBackgroundColor(0.35, 0.6, 0.35)

    battalion1:DrawBattalion()
end