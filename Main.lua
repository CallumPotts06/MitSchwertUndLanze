
--// IMPORT LIBRARIES //--
Mathematics = require("Mathematics/Mathematics")

Colours = require("Interface/Colours")
Font = require("Interface/Font")

Images = require("MediaHandler/Images")
Sounds = require("MediaHandler/Sounds")

Mouse = require("OtherLibraries/Mouse")

Effects = require("Graphics/Effects")
Renderer = require("Graphics/Renderer")

InputControl = require("OtherLibraries/InputManager")

MapController = require("GameStates/Game/MapController")
MapGraphics = require("GameStates/Game/MapGraphics")

--// IMPORT CLASSES //--
Vector = require("Mathematics/Vector")
Queue = require("Mathematics/Queue")

TextBox = require("Interface/TextBox")
ImageBox = require("Interface/ImageBox")
Screen = require("Interface/Screen")

--// IMPORT MILITARY CLASSES //--
Squad = require("Army/Squad")
Battalion = require("Army/Battalion")
Regiment = require("Army/Regiment")
Brigade = require("Army/Brigade")

--// IMPORT MENUS //--
MenuController = require("GameStates/Menu/MenuController")
TitleScreen = require("GameStates/Menu/TitleScreen")
HUD = require("GameStates/Game/GameHUD")

--// END OF IMPORTS //--

---/// LOCAL VARIABLES ///---
local cumulativeTime = 0
local currentMapPath = "Maps/Wissembourg.map"

---/// GLOBALS ///---
FlagTick = -5
AnimTick = 1
TimeOfDay = 600

ScreenX, ScreenY = 1,1

CameraMoved = false
CameraZoom = 0.6
CameraPosition = Vector.New(0,0,0)

CurrentUnit = false
CurrentUnitControl = ""
CurrentUnitScreen = false

AntiAliasAmount = 4

TileQ = Queue.New()
DetailQ = Queue.New()

TileZoom = 1
DetailZoom = 1

unitUpdateTick = 1
unitUpdateTime = 0
UnitUpdateTickAllocator = 1



----//// ** LOVE LOAD FUNCTION ** ////----
function love.load()
    local success = love.window.setFullscreen(true)--set the screen to full screen--
    ScreenX, ScreenY = love.graphics.getDimensions()
    
    love.graphics.setDefaultFilter("nearest", "nearest")--removes anti aliasing--
    
    --MenuController.InitialiseMenu("TitleScreen")--open title screen on opening the game

    --load squads for gameplay--
    Squad.LoadAllSquads()

    --load map, testing --
    MapController.LoadMap( currentMapPath )
end

----//// ** LOVE UPDATE FUNCTION ** ////----
local unitAnimTimer = 0
local flagIncrement = -1

local fpsCounterTimer = 0
local frameCounter = 0
local cameraTimer = 0
local fps = 0

local map = nil

function love.update(dt)
    CameraMoved = false

    cameraTimer = cameraTimer + dt
    fpsCounterTimer = fpsCounterTimer + dt
    frameCounter = frameCounter + 1
    unitAnimTimer=unitAnimTimer+dt
    cumulativeTime = cumulativeTime + dt
    unitUpdateTime = unitUpdateTime + dt

    
    if fpsCounterTimer>=0.1 then 
        fpsCounterTimer=fpsCounterTimer-0.1
        fps = frameCounter / 0.1
        frameCounter = 0 
        unitUpdateTick = unitUpdateTick + 1

        
        for i=1,#GermanyArmy,1 do GermanyArmy[i]:UpdatePosition() end
        for i=1,#FrenchArmy,1 do FrenchArmy[i]:UpdatePosition() end
    end

    if unitUpdateTime >= 0.2 then
        unitUpdateTime = unitUpdateTime - 0.2
        unitUpdateTick = unitUpdateTick + 1
        if unitUpdateTick > 5 then unitUpdateTick = 0 end
    end


    if unitAnimTimer>=0.125 then 
        unitAnimTimer=unitAnimTimer-0.125 FlagTick=FlagTick+flagIncrement TimeOfDay=TimeOfDay+0.5 AnimTick=AnimTick+1
        if FlagTick > 5 then flagIncrement = -1  end
        if FlagTick < -5 then flagIncrement = 1  end

        if AnimTick > 8 then AnimTick = 1  end

        for i=1,#GermanyArmy,1 do GermanyArmy[i]:UpdateAnimation() end
        for i=1,#FrenchArmy,1 do FrenchArmy[i]:UpdateAnimation() end
    end
    
    local mouseData = Mouse.GetData(true,cumulativeTime)
    --MenuController.CheckForClicks(mouseData.Position,mouseData.LMBDown)
    if CurrentUnitScreen then CurrentUnitScreen:CheckForClicks(mouseData.Position,mouseData.LMBDown) end
    if mouseData.LMBDown then
        local ui = nil

        ui = UnitSelectUI.CheckForUnitClicks( love.keyboard.isDown("lshift"),  {FrenchArmy, GermanArmy}, mouseData )

        if ui then
            CurrentUnitScreen = ui
        end

    end

    InputControl.ApplyAllInputs()
    if CurrentUnit then InputControl.ControlUnit(mouseData, CurrentUnit) end

    --apply to armies when coded--
    if CameraMoved then for i=1,#GermanyArmy,1 do GermanyArmy[i]:Moved() end end
    if CameraMoved then for i=1,#FrenchArmy,1 do FrenchArmy[i]:Moved() end end
end




----//// ** LOVE DRAW FUNCTION ** ////----
function love.draw()
    Colours.SetColour(Colours.CreateColour(Colours.White))
    love.graphics.print("FPS="..tostring(fps), 10, 10)

    if TimeOfDay>1400 then Effects.CurrentWeather = "Sunny" end

    --MenuController.DrawMenu()

    
    --sets a "lighting" colour for the background--
    Effects.WeatherColour()

    if CameraMoved then
        TileQ, TileZoom  = MapController.ReturnTiles()
        DetailQ, DetailZoom = MapController.ReturnDetails()
    end

    for i=1,#TileQ.Data do
        local index = TileQ.Data[i]
        Renderer.DrawWithLighting( index.Canvas, index.DrawPos, TileZoom )
    end
    for i=1,#DetailQ.Data do
        local index = DetailQ.Data[i]
        Renderer.DrawWithLightingAndShadow( index.Image, index.DrawPos, DetailZoom )
    end

    for i=1,#GermanyArmy,1 do GermanyArmy[i]:DrawBrigade() end
    for i=1,#FrenchArmy,1 do FrenchArmy[i]:DrawBrigade() end


     if CurrentUnitScreen and CurrentUnit then CurrentUnitScreen.Screen:DrawScreen() end
end