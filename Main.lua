
--// IMPORT LIBRARIES //--
Mathematics = require("Mathematics/Mathematics")

Colours = require("Interface/Colours")
Font = require("Interface/Font")

Images = require("MediaHandler/Images")
Sounds = require("MediaHandler/Sounds")

Mouse = require("OtherLibraries/Mouse")

Effects = require("Graphics/Effects")
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
HUD = require("GameStates/Game/GameHUD")

--// END OF IMPORTS //--

---/// LOCAL VARIABLES ///---
local cumulativeTime = 0

---/// GLOBALS ///---
FlagTick = -5
AnimTick = 1
CameraZoom = 0.6
TimeOfDay = 0
ScreenX, ScreenY = 1,1
CameraPosition = Vector.New(0,0,0)

-----!!!!!!!!!!!!!!!!!----
local unitSelectUIScreen = false

----//// ** LOVE LOAD FUNCTION ** ////----
function love.load()
    local success = love.window.setFullscreen(true)--set the screen to full screen--
    ScreenX, ScreenY = love.graphics.getDimensions()

    local w, h, flags = love.window.getMode()
    flags.vsync = not flags.vsync
    love.window.setMode(w, h, flags)

    love.graphics.setDefaultFilter("nearest", "nearest")--removes anti aliasing--
    
    MenuController.InitialiseMenu("TitleScreen")--open title screen on opening the game
    hudScreen = HUD.Open()

    --load squads for gameplay--
    Squad.LoadAllSquads()

    --battalion1 = Battalion.New("Battalion 1",{},"Germany","Artillery","DeutscherArtillerie","PreussischerArtillerie",Vector.New(500,200,math.rad(90)),"None",true)
    --battalion1 = Battalion.New("Battalion 1",{},"Germany","Cavalry","PreussischerUhlanen","PreussischerUhlanen",Vector.New(350,300,math.rad(290)),"None",true)
    --battalion1 = Battalion.New("Battalion 1",{},"Germany","Cavalry","PreussischerDragoner","PreussischerDragoner",Vector.New(500,400,math.rad(290)),"None",true)
    --battalion1 = Battalion.New("Battalion 1",{},"Germany","Infantry","BayerischerLineninfanterie","BayerischerLineninfanterie",Vector.New(500,200,math.rad(290)),"Summer",true)
    --battalion1 = Battalion.New("Battalion 1",{},"Germany","Infantry","DeutscherGardeZuFuss","PreussischerGardeZuFuss",Vector.New(500,300,math.rad(0)),"Summer",true)

    battalion1.Position.Theta=math.rad(120)
    battalion1.Formation = "Dismounted"
    battalion1.CurrentAction = "Guard"
    battalion1:UpdateCurrentImage()
    battalion1:CreateFlagMeshes()

    unitSelectUIScreen = battalion1:SelectUnit()
end

----//// ** LOVE UPDATE FUNCTION ** ////----
local unitAnimTimer = 0
local flagIncrement = -1

local fpsCounterTimer = 0
local frameCounter = 0
local fps = 0

function love.update(dt)
    fpsCounterTimer = fpsCounterTimer + dt
    frameCounter = frameCounter + 1
    unitAnimTimer=unitAnimTimer+dt
    cumulativeTime = cumulativeTime + dt

    if fpsCounterTimer>=1 then 
        fpsCounterTimer=fpsCounterTimer-1 
        fps = frameCounter / 1 
        frameCounter = 0
    end

    if unitAnimTimer>=0.125 then 
        unitAnimTimer=unitAnimTimer-0.125 FlagTick=FlagTick+flagIncrement TimeOfDay=TimeOfDay+4 AnimTick=AnimTick+1
        if FlagTick > 5 then flagIncrement = -1  end
        if FlagTick < -5 then flagIncrement = 1  end

        if AnimTick > 8 then AnimTick = 1  end

        battalion1:UpdateAnimation()
    end
    

    local mouseData = Mouse.GetData(true,cumulativeTime)
    MenuController.CheckForClicks(mouseData.Position,mouseData.LMBDown)
    hudScreen.UiObjects[1].Text = "Time: "..tostring(TimeOfDay)
    hudScreen.UiObjects[1].TextData = love.graphics.newText(hudScreen.UiObjects[1].Font, "Time: "..tostring(TimeOfDay))
    hudScreen.UiObjects[1].Canvas = hudScreen.UiObjects[1]:CreateCanvas()


    --TEMPORARY CAMERA ZOOM CONTROLS--
    if love.keyboard.isDown("up") then CameraZoom = CameraZoom * 1.01 battalion1.Moved = true
    elseif love.keyboard.isDown("down") then CameraZoom = CameraZoom / 1.01 battalion1.Moved = true end

    --TEMPORARY CAMERA MOVEMENT CONTROLS--
    if love.keyboard.isDown("w") then CameraPosition.Y = CameraPosition.Y + 2 battalion1.Moved = true end
    if love.keyboard.isDown("a") then CameraPosition.X = CameraPosition.X + 2 battalion1.Moved = true end
    if love.keyboard.isDown("s") then CameraPosition.Y = CameraPosition.Y - 2 battalion1.Moved = true end
    if love.keyboard.isDown("d") then CameraPosition.X = CameraPosition.X - 2 battalion1.Moved = true end
end

----//// ** LOVE DRAW FUNCTION ** ////----
function love.draw()
    Colours.SetColour(Colours.CreateColour(Colours.White))
    love.graphics.print("FPS="..tostring(love.timer.getFPS()), 10, 10)

    if TimeOfDay>1400 then Effects.CurrentWeather = "Sunny" end

    MenuController.DrawMenu()
    hudScreen:DrawScreen()
    unitSelectUIScreen:DrawScreen()

    --sets a "lighting" colour for the background--
    local newColour = Effects.LightingColour(Colours.CreateColour({0.35, 0.6, 0.35,1}),true)
    love.graphics.setBackgroundColor(newColour.R,newColour.G,newColour.B)

    --battalion1:DrawBattalion()

    Effects.WeatherColour()
end