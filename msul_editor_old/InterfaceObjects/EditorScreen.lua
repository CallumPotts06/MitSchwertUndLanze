
---/// IMPORT UI LIBRARIES ///---
Colours = require("../EditorInterface/Colours")
Font = require("../EditorInterface/Font")
--ImageBox = require("../EditorInterface/ImageBox")
TextBox = require("../EditorInterface/TextBox")
ImageBox = require("../EditorInterface/ImageBox")
Screen = require("../EditorInterface/Screen")
---/// IMPORT CORE LIBRARIES ///---
Mathematics = require("../EditorLibraries/Mathematics")
Vector = require("../EditorLibraries/Vector")

---/// INTERFACE OBJECT: EDITOR SCREEN ///---
interface = {}

--setup font and colour values for buttons--
font = Font.Georgia
blk = Colours.CreateColour(Colours.Black)
wht = Colours.CreateColour(Colours.White)

-- setup positional values for buttons --
btnSize = Mathematics.ScreenScaleVector(0.2, 0.08)

grassPos = Mathematics.ScreenScaleVector(0.04, 0.1)
forestPos = Mathematics.ScreenScaleVector(0.04, 0.2)
wheatPos = Mathematics.ScreenScaleVector(0.28,0.1)
potatoPos = Mathematics.ScreenScaleVector(0.28,0.2)
pathPos = Mathematics.ScreenScaleVector(0.52, 0.1)
roadPos = Mathematics.ScreenScaleVector(0.52, 0.2)
streamPos = Mathematics.ScreenScaleVector(0.76, 0.1)
sandPos = Mathematics.ScreenScaleVector(0.76, 0.2)


cyclePos = Mathematics.ScreenScaleVector(0.04, 0.1)
namePos = Mathematics.ScreenScaleVector(0.28, 0.1)
undoPos = Mathematics.ScreenScaleVector(0.52,0.1)


terrainPos = Mathematics.ScreenScaleVector(0.04, 0.3)
detailsPos = Mathematics.ScreenScaleVector(0.28, 0.3)
gameplayPos = Mathematics.ScreenScaleVector(0.52, 0.3)

savePos = Mathematics.ScreenScaleVector(0.76, 0.82)

-- create buttons for screen --

---/// ############### ///---
---/// TERRAIN BUTTONS ///---
---/// ############### ///---

local Btn_NewGrass = TextBox.New(
"newGrass", "New Grass", grassPos, btnSize, 15, 0, 5, font, 1, wht, blk, blk, true, true
)
local Btn_NewForest = TextBox.New(
"newForest", "New Forest", forestPos, btnSize, 15, 0, 5, font, 1, wht, blk, blk, true, true
)


local Btn_NewWheat = TextBox.New(
"newWheat", "New Wheat", wheatPos, btnSize, 15, 0, 5, font, 1, wht, blk, blk, true, true
)
local Btn_NewPotato = TextBox.New(
"newPotato", "New Potato", potatoPos, btnSize, 15, 0, 5, font, 1, wht, blk, blk, true, true
)


local Btn_NewPath = TextBox.New(
"newPath", "New Path", pathPos, btnSize, 15, 0, 5, font, 1, wht, blk, blk, true, true
)
local Btn_NewRoad = TextBox.New(
"newRoad", "New Road", roadPos, btnSize, 15, 0, 5, font, 1, wht, blk, blk, true, true
)


local Btn_NewStream = TextBox.New(
"newStream", "New Stream", streamPos, btnSize, 15, 0, 5, font, 1, wht, blk, blk, true, true
)
local Btn_NewSand = TextBox.New(
"newSand", "New Sand", sandPos, btnSize, 15, 0, 5, font, 1, wht, blk, blk, true, true
)

---/// ############### ///---
---/// DETAILS BUTTONS ///---
---/// ############### ///---

local Btn_CycleDetail = TextBox.New(
"cycleDetail", "Cycle Detail", cyclePos, btnSize, 15, 0, 5, font, 1, wht, blk, blk, true, true
)
local Btn_DetailName = ImageBox.New(
"detailIcon", love.graphics.newImage("MapDetails/OakTree1_Summer.png"), namePos, btnSize, 15, 0, blk, blk, false, false
)
local Btn_UndoDetail = TextBox.New(
"undoDetail", "Undo Detail", undoPos, btnSize, 15, 0, 5, font, 1, wht, blk, blk, true, true
)

---/// ################ ///---
---/// GAMEPLAY BUTTONS ///---
---/// ################ ///---

local Btn_CycleGameplay = TextBox.New(
"cycleGameplay", "Cycle Gameplay", cyclePos, btnSize, 15, 0, 5, font, 1, wht, blk, blk, true, true
)
local Btn_GameplayName = TextBox.New(
"gameIcon", "TeamABrigade", namePos, btnSize, 15, 0, 5, font, 1, wht, blk, blk, false, false
)
local Btn_UndoGameplay = TextBox.New(
"undoGameplay", "Undo Gameplay", undoPos, btnSize, 15, 0, 5, font, 1, wht, blk, blk, true, true
)


---/// ############# ///---
---/// LAYER BUTTONS ///---
---/// ############# ///---

local Btn_Terrain = TextBox.New(
"layerTerrain", "Terrain", terrainPos, btnSize, 15, 0, 5, font, 1, wht, blk, blk, true, true
)
local Btn_Details = TextBox.New(
"layerDetails", "Details", detailsPos, btnSize, 15, 0, 5, font, 1, wht, blk, blk, true, true
)
local Btn_Gameplay = TextBox.New(
"layerGameplay", "Gameplay", gameplayPos, btnSize, 15, 0, 5, font, 1, wht, blk, blk, true, true
)


local Btn_SaveMap = TextBox.New(
"saveMap", "Save Map", savePos, btnSize, 15, 0, 5, font, 1, wht, blk, blk, true, true
)

function interface.ChangeLayer(changeTo)
    if changeTo == "Terrain" then
        interface.Screen.UiObjects = {
            Btn_NewGrass,
            Btn_NewForest,
            Btn_NewWheat,
            Btn_NewPotato,
            Btn_NewPath,
            Btn_NewRoad,
            Btn_NewStream,
            Btn_NewSand,
            Btn_Terrain,
            Btn_Details,
            Btn_Gameplay,
            Btn_SaveMap
        }
    elseif changeTo == "Details" then
        interface.Screen.UiObjects = {
            Btn_CycleDetail,
            Btn_DetailName,
            Btn_UndoDetail,
            Btn_Terrain,
            Btn_Details,
            Btn_Gameplay,
            Btn_SaveMap
        }
    elseif changeTo == "Gameplay" then
        interface.Screen.UiObjects = {
            Btn_CycleGameplay,
            Btn_GameplayName,
            Btn_UndoGameplay,
            Btn_Terrain,
            Btn_Details,
            Btn_Gameplay,
            Btn_SaveMap
        }
    end 
end


-- setup the screen object --
interface.Screen = Screen.New(1)
interface.Screen.UiObjects = {
    Btn_NewGrass,
    Btn_NewForest,
    Btn_NewWheat,
    Btn_NewPotato,
    Btn_NewPath,
    Btn_NewRoad,
    Btn_NewStream,
    Btn_NewSand,
    Btn_Terrain,
    Btn_Details,
    Btn_Gameplay,
    Btn_SaveMap
}


return interface