
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

    local tempReg1 = {} local tempReg2 = {} local tempReg3 = {} local tempReg4 = {}
    tempReg1.Name = "1. Regiment Zu Fuss" tempReg1.UnitType = "DeutscherLineninfanterie" tempReg1.UnitTypeName = "PreussischerLineninfanterie"
    tempReg2.Name = "2. Regiment Zu Fuss" tempReg2.UnitType = "DeutscherLineninfanterie" tempReg2.UnitTypeName = "HessischLineninfanterie"
    tempReg3.Name = "3. Regiment Zu Fuss" tempReg3.UnitType = "DeutscherLineninfanterie" tempReg3.UnitTypeName = "SaechsischLineninfanterie"
    tempReg4.Name = "4. Regiment Zu Fuss" tempReg4.UnitType = "DeutscherLineninfanterie" tempReg4.UnitTypeName = "BadenLineninfanterie"
    brigade1Names = { tempReg1, tempReg2, tempReg3, tempReg4 }
    Brigade1 = Brigade.New("1. Brigade",brigade1Names,"Germany","Infantry",Vector.New(3000,3000),"Summer")

    local tempReg5 = {} local tempReg6 = {} local tempReg7 = {} local tempReg8 = {}
    tempReg5.Name = "5. Regiment Artillerie" tempReg5.UnitType = "DeutscherArtillerie" tempReg5.UnitTypeName = "PreussischerArtillerie"
    tempReg6.Name = "6. Regiment Artillerie" tempReg6.UnitType = "DeutscherArtillerie" tempReg6.UnitTypeName = "PreussischerArtillerie"
    tempReg7.Name = "7. Regiment Artillerie" tempReg7.UnitType = "DeutscherArtillerie" tempReg7.UnitTypeName = "PreussischerArtillerie"
    tempReg8.Name = "8. Regiment Artillerie" tempReg8.UnitType = "DeutscherArtillerie" tempReg8.UnitTypeName = "PreussischerArtillerie"
    brigade2Names = { tempReg5, tempReg6, tempReg7, tempReg8 }
    Brigade2 = Brigade.New("2. Brigade",brigade2Names,"Germany","Artillery",Vector.New(500,3000),"Summer")

    local tempReg9 = {} local tempReg10 = {} local tempReg11 = {} local tempReg12 = {}
    tempReg9.Name = "9. Regiment Uhlanen" tempReg9.UnitType = "PreussischerUhlanen" tempReg9.UnitTypeName = "PreussischerUhlanen"
    tempReg10.Name = "10. Regiment Uhlanen" tempReg10.UnitType = "PreussischerUhlanen" tempReg10.UnitTypeName = "PreussischerUhlanen"
    tempReg11.Name = "11. Regiment Husaren" tempReg11.UnitType = "PreussischerHusaren" tempReg11.UnitTypeName = "PreussischerHusaren"
    tempReg12.Name = "12. Regiment Kuerassiere" tempReg12.UnitType = "PreussischerKuerassiere" tempReg12.UnitTypeName = "PreussischerKuerassiere"
    brigade3Names = { tempReg9, tempReg10, tempReg11, tempReg12 }
    Brigade3 = Brigade.New("3. Brigade",brigade3Names,"Germany","Cavalry",Vector.New(1500,3000),"Summer")

    local tempReg13 = {} local tempReg14 = {} local tempReg15 = {} local tempReg16 = {}
    tempReg13.Name = "13. Regiment Jaegers" tempReg13.UnitType = "DeutscherJaegers" tempReg13.UnitTypeName = "PreussischerJaegers"
    tempReg14.Name = "14. Regiment Jaegers" tempReg14.UnitType = "DeutscherJaegers" tempReg14.UnitTypeName = "PreussischerJaegers"
    tempReg15.Name = "15. Regiment Zu Fuss" tempReg15.UnitType = "DeutscherLandwehr" tempReg15.UnitTypeName = "PreussischerLandwehr"
    tempReg16.Name = "16. Regiment Zu Fuss" tempReg16.UnitType = "DeutscherLandwehr" tempReg16.UnitTypeName = "PreussischerLandwehr"
    brigade4Names = { tempReg13, tempReg14, tempReg15, tempReg16 }
    Brigade4 = Brigade.New("4. Brigade",brigade4Names,"Germany","Infantry",Vector.New(3750,3000),"Summer")
    
    GermanyArmy = { Brigade1, Brigade2, Brigade3, Brigade4 }



    local tempReg1 = {} local tempReg2 = {} local tempReg3 = {} local tempReg4 = {}
    tempReg1.Name = "1er Regiment De Ligne" tempReg1.UnitType = "FrenchLineInfantry" tempReg1.UnitTypeName = "FrenchLineInfantry"
    tempReg2.Name = "2er Regiment De Ligne" tempReg2.UnitType = "FrenchLineInfantry" tempReg2.UnitTypeName = "FrenchLineInfantry"
    tempReg3.Name = "3er Regiment De Ligne" tempReg3.UnitType = "FrenchLineInfantry" tempReg3.UnitTypeName = "FrenchLineInfantry"
    tempReg4.Name = "4er Regiment De Ligne" tempReg4.UnitType = "FrenchLineInfantry" tempReg4.UnitTypeName = "FrenchLineInfantry"
    brigade5Names = { tempReg1, tempReg2, tempReg3, tempReg4 }
    Brigade5 = Brigade.New("1er Brigade",brigade5Names,"France","Infantry",Vector.New(5000,1000),"Summer")
    Brigade6 = Brigade.New("2er Brigade",brigade5Names,"France","Infantry",Vector.New(5600,1000),"Summer")
    Brigade7 = Brigade.New("3er Brigade",brigade5Names,"France","Infantry",Vector.New(6200,1000),"Summer")
    Brigade8 = Brigade.New("4er Brigade",brigade5Names,"France","Infantry",Vector.New(6800,1000),"Summer")

    FrenchArmy = { Brigade5, Brigade6, Brigade7, Brigade8 }

    



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

        if unitUpdateTick > 5 then unitUpdateTick = 0 end

        for i=1,#GermanyArmy,1 do GermanyArmy[i]:UpdatePosition() end
        for i=1,#FrenchArmy,1 do FrenchArmy[i]:UpdatePosition() end
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