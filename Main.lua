
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
local currentMapPath = "Maps/Map1.map"

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



----//// ** LOVE LOAD FUNCTION ** ////----
function love.load()
    local success = love.window.setFullscreen(true)--set the screen to full screen--
    ScreenX, ScreenY = love.graphics.getDimensions()
    
    love.graphics.setDefaultFilter("nearest", "nearest")--removes anti aliasing--
    
    --MenuController.InitialiseMenu("TitleScreen")--open title screen on opening the game

    --load squads for gameplay--
    Squad.LoadAllSquads()


    --[[Regiment1 = Regiment.New(
        --"1. Regiment Zu Fuss",{},"Germany","Infantry","DeutscherGardeZuFuss","PreussischerGardeZuFuss",Vector.New(1200,2000),"Summer"
        "1. Regiment Zu Fuss",{},"Germany","Infantry","DeutscherGardeZuFuss","PreussischerGardeZuFuss",Vector.New(4000,4000),"Summer"
    )
    Regiment1:UpdateCurrentImages()
    Regiment1:CreateFlagMeshes()

    Regiment4 = Regiment.New(
        "4. Regiment Zu Fuss",{},"Germany","Infantry","DeutscherLineninfanterie","HessischLineninfanterie",Vector.New(1400,2000),"Summer"
    )
    Regiment4:UpdateCurrentImages()
    Regiment4:CreateFlagMeshes()

    Regiment8 = Regiment.New(
        "5. Regiment Zu Fuss",{},"Germany","Infantry","DeutscherLineninfanterie","SaechsischLineninfanterie",Vector.New(1600,2000),"Summer"
    )
    Regiment8:UpdateCurrentImages()
    Regiment8:CreateFlagMeshes()

    Regiment9 = Regiment.New(
        "5. Regiment Zu Fuss",{},"Germany","Infantry","DeutscherLineninfanterie","BadenLineninfanterie",Vector.New(1800,2000),"Summer"
    )
    Regiment9:UpdateCurrentImages()
    Regiment9:CreateFlagMeshes()


    Regiment5 = Regiment.New(
        "5. Regiment Zu Fuss",{},"Germany","Infantry","DeutscherLineninfanterie","WuerttemburgLineninfanterie",Vector.New(2000,2000),"Summer"
    )
    Regiment5:UpdateCurrentImages()
    Regiment5:CreateFlagMeshes()

    Regiment6 = Regiment.New(
        "6. Regiment Zu Fuss",{},"Germany","Infantry","BayerischerLineninfanterie","BayerischerLineninfanterie",Vector.New(2200,2000),"Summer"
    )
    Regiment6:UpdateCurrentImages()
    Regiment6:CreateFlagMeshes()


    Regiment2 = Regiment.New(
        "2. Regiment Uhlanen",{},"Germany","Cavalry","PreussischerUhlanen","PreussischerUhlanen",Vector.New(1600,3000),"Summer"
    )
    Regiment2:UpdateCurrentImages()
    Regiment2:CreateFlagMeshes()

    Regiment7 = Regiment.New(
        "7. Regiment Uhlanen",{},"Germany","Cavalry","PreussischerKuerassiere","PreussischerKuerassiere",Vector.New(1900,3000),"Summer"
    )
    Regiment7:UpdateCurrentImages()
    Regiment7:CreateFlagMeshes()

    --[[Regiment10 = Regiment.New(
        "10. Regiment Dragoner",{},"Germany","Cavalry","PreussischerDragoner","PreussischerDragoner",Vector.New(2200,3000),"Summer"
    )
    Regiment10:UpdateCurrentImages()
    Regiment10:CreateFlagMeshes()

    Regiment3 = Regiment.New(
        "3. Regiment Artillerie",{},"Germany","Artillery","DeutscherArtillerie","PreussischerArtillerie",Vector.New(1200,3200),"Summer"
    )
    Regiment3:UpdateCurrentImages()
    Regiment3:CreateFlagMeshes()

    Regiments = {Regiment1,Regiment2,Regiment3,Regiment4,Regiment5,Regiment6,Regiment7,Regiment8,Regiment9,Regiment10}]]

    local tempReg1 = {}
    tempReg1.Name = "1. Regiment Zu Fuss" tempReg1.UnitType = "DeutscherLineninfanterie" tempReg1.UnitTypeName = "PreussischerLineninfanterie"

    local tempReg2 = {}
    tempReg2.Name = "2. Regiment Zu Fuss" tempReg2.UnitType = "DeutscherLineninfanterie" tempReg2.UnitTypeName = "HessischLineninfanterie"

    local tempReg3 = {}
    tempReg3.Name = "3. Regiment Zu Fuss" tempReg3.UnitType = "DeutscherLineninfanterie" tempReg3.UnitTypeName = "SaechsischLineninfanterie"

    local tempReg4 = {}
    tempReg4.Name = "4. Regiment Zu Fuss" tempReg4.UnitType = "DeutscherLineninfanterie" tempReg4.UnitTypeName = "BadenLineninfanterie"

    RegimentsNamesAndTypes = { tempReg1, tempReg2, tempReg3, tempReg4 }

    Brigade1 = Brigade.New("1. Brigade",RegimentsNamesAndTypes,"Germany","Infantry",Vector.New(2000,2000),"Summer")



    --load map, testing --
    MapController.LoadMap( currentMapPath )
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

        Brigade1:UpdatePosition()
    end

    if unitAnimTimer>=0.125 then 
        unitAnimTimer=unitAnimTimer-0.125 FlagTick=FlagTick+flagIncrement TimeOfDay=TimeOfDay+0.5 AnimTick=AnimTick+1
        if FlagTick > 5 then flagIncrement = -1  end
        if FlagTick < -5 then flagIncrement = 1  end

        if AnimTick > 8 then AnimTick = 1  end

        Brigade1:UpdateAnimation()
    end
    
    local mouseData = Mouse.GetData(true,cumulativeTime)
    --MenuController.CheckForClicks(mouseData.Position,mouseData.LMBDown)
    if CurrentUnitScreen then CurrentUnitScreen:CheckForClicks(mouseData.Position,mouseData.LMBDown) end
    if mouseData.LMBDown then
        local ui = false

        if love.keyboard.isDown("lshift") then ui = Brigade1:CheckForClick(mouseData.Position,"Select") 
        else for i=1,#Brigade1.Regiments,1 do ui = Brigade1.Regiments[i]:CheckForClick(mouseData.Position,"Select") if ui then break end end end
        if ui then CurrentUnitScreen = ui end
    end

    InputControl.ApplyAllInputs()
    InputControl.ControlUnit(mouseData, CurrentUnit)

    --apply to armies when coded--
    if CameraMoved then Brigade1:Moved() Brigade1:UpdatePosition() end
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

    Brigade1:DrawBrigade()


     if CurrentUnitScreen and CurrentUnit then CurrentUnitScreen.Screen:DrawScreen() end
end