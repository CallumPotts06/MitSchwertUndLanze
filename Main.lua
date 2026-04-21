
--// IMPORT LIBRARIES //--
Mathematics = require("Mathematics/Mathematics")

Colours = require("Interface/Colours")
Font = require("Interface/Font")

Images = require("MediaHandler/Images")
Sounds = require("MediaHandler/Sounds")

Mouse = require("OtherLibraries/Mouse")

Effects = require("Graphics/Effects")

InputControl = require("OtherLibraries/InputManager")

LoadMap = require("GameStates/Game/LoadMap")
MapEditor = require("OtherLibraries/MapEditor")

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
TimeOfDay = 0

ScreenX, ScreenY = 1,1

CameraMoved = false
CameraZoom = 0.6
CameraPosition = Vector.New(0,0,0)

CurrentUnit = false
CurrentUnitControl = ""
CurrentUnitScreen = false

AntiAliasAmount = 4



----//// ** LOVE LOAD FUNCTION ** ////----
function love.load()
    local success = love.window.setFullscreen(true)--set the screen to full screen--
    ScreenX, ScreenY = love.graphics.getDimensions()
    
    love.graphics.setDefaultFilter("nearest", "nearest")--removes anti aliasing--
    
    --MenuController.InitialiseMenu("TitleScreen")--open title screen on opening the game

    --load squads for gameplay--
    
    --TEMPORARILY REMOVED FOR SPEED --Squad.LoadAllSquads()

    --battalion1 = Battalion.New("Battalion 1",{},"Germany","Artillery","DeutscherArtillerie","PreussischerArtillerie",Vector.New(500,200,math.rad(90)),"None",true)
    --battalion1 = Battalion.New("Battalion 1",{},"Germany","Cavalry","PreussischerUhlanen","PreussischerUhlanen",Vector.New(350,300,math.rad(290)),"None",true)
    --battalion1 = Battalion.New("Battalion 1",{},"Germany","Cavalry","PreussischerDragoner","PreussischerDragoner",Vector.New(500,400,math.rad(290)),"None",true)
    --battalion1 = Battalion.New("Battalion 1",{},"Germany","Infantry","BayerischerLineninfanterie","BayerischerLineninfanterie",Vector.New(500,200,math.rad(290)),"Summer",true)
    
    --[[battalion1 = Battalion.New("Battalion 1",{},"Germany","Infantry","DeutscherGardeZuFuss","PreussischerGardeZuFuss",Vector.New(500,300,math.rad(0)),"Summer",true)

    battalion1.Position.Theta=math.rad(120)
    battalion1.Formation = "BattleLine"
    battalion1.CurrentAction = "Aiming"
    battalion1:UpdateCurrentImage()
    battalion1:CreateFlagMeshes()]]
end

----//// ** LOVE UPDATE FUNCTION ** ////----
local unitAnimTimer = 0
local flagIncrement = -1

local fpsCounterTimer = 0
local frameCounter = 0
local fps = 0

local map = nil

function love.update(dt)
    CameraMoved = false

    fpsCounterTimer = fpsCounterTimer + dt
    frameCounter = frameCounter + 1
    unitAnimTimer=unitAnimTimer+dt
    cumulativeTime = cumulativeTime + dt


    if fpsCounterTimer>=0.1 then 
        fpsCounterTimer=fpsCounterTimer-0.1
        fps = frameCounter / 0.1
        frameCounter = 0
    end

    if unitAnimTimer>=0.125 then 
        unitAnimTimer=unitAnimTimer-0.125 FlagTick=FlagTick+flagIncrement TimeOfDay=TimeOfDay+4 AnimTick=AnimTick+1
        if FlagTick > 5 then flagIncrement = -1  end
        if FlagTick < -5 then flagIncrement = 1  end

        if AnimTick > 8 then AnimTick = 1  end

        --battalion1:UpdateAnimation()
    end
    
    local mouseData = Mouse.GetData(true,cumulativeTime)
    --MenuController.CheckForClicks(mouseData.Position,mouseData.LMBDown)
    if CurrentUnitScreen then CurrentUnitScreen:CheckForClicks(mouseData.Position,mouseData.LMBDown) end
    if mouseData.LMBDown then
        --local ui = battalion1:CheckForClick(mouseData.Position,"Select")
        --if ui then CurrentUnitScreen = ui end
    end

    map = MapEditor.UpdateMap()

    InputControl.ApplyAllInputs()

    --apply to armies when coded--
    --if CameraMoved then battalion1.Moved = true end
end

----//// ** LOVE DRAW FUNCTION ** ////----
function love.draw()
    Colours.SetColour(Colours.CreateColour(Colours.White))
    love.graphics.print("FPS="..tostring(fps), 10, 10)

    if TimeOfDay>1400 then Effects.CurrentWeather = "Sunny" end

    --MenuController.DrawMenu()

    if CurrentUnitScreen and CurrentUnit then CurrentUnitScreen.Screen:DrawScreen() end


    --[[
    --sets a "lighting" colour for the background--
    local newColour = Effects.LightingColour(Colours.CreateColour({0.35, 0.6, 0.35,1}),true)
    love.graphics.setBackgroundColor(newColour.R,newColour.G,newColour.B)

    battalion1:DrawBattalion()

    Effects.WeatherColour()]]

    love.graphics.draw(map)
end