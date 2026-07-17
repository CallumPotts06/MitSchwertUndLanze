
--// IMPORT LIBRARIES //--
Mathematics = require("Mathematics/Mathematics")

Colours = require("Interface/Colours")
Font = require("Interface/Font")

Images = require("MediaHandler/Images")
Sounds = require("MediaHandler/Sounds")

KeyBinds = require("Config/KeyBinds")
--// IMPORT CLASSES //--
Vector = require("Mathematics/Vector")

TextBox = require("Interface/TextBox")
ImageBox = require("Interface/ImageBox")
Screen = require("Interface/Screen")
--// END OF IMPORTS //--

--// CONSTANTS //--
MORALE_SCORES = {
    "Confident",
    "Confident",
    "Uneased",
    "Breaking Point",
    "Routed"
}
HEALTH_SCORES = {
    "Full Strength",
    "High Strength",
    "Half Strength",
    "Quarter Strength",
    "Destroyed",
}


UnitUI = {}

function UnitUI.CheckForUnitClicks( shift, Army, mouseData )
    if shift then
        for i = 1, #Army do
            ui = Army[i]:CheckForClick(mouseData.Position, "Select")
            if ui then return ui end
        end
    else
        for i = 1, #Army do
            for r = 1, #Army[i].Regiments do
                ui = Army[i].Regiments[r]:CheckForClick(mouseData.Position, "Select")
                if ui then return ui end
            end
        end
    end

    return false
end


function UnitUI.Open(unit)
    local newUnitUI = {}

    local actionToKey = {
        {"Move", KeyBinds.Move},
        {"Double", KeyBinds.Double},
        {"Charge", KeyBinds.Charge},
        {"Wheel", KeyBinds.Wheel},
        {"Target", KeyBinds.Target},
    }


    --setup appearance data for the UI--

    --text colours--
    local offwhite = Colours.CreateColour({0.6,0.6,0.45,1})
    local white = Colours.CreateColour(Colours.White)
    local black = Colours.CreateColour(Colours.Black)
    local transparent = Colours.CreateColour({1,1,1,0})

    --team colours--
    local prussianBlue = Colours.CreateColour({0,0.1,0.3,1})

    local teamColour = prussianBlue
    if unit.Team == "Prussian" then teamColour = prussianBlue end
    --etc.--


    --ui box position--
    local boxPadding = 0.04
    local boxPos = Mathematics.ScreenScaleVector(0,0.75)
    local boxSize = Mathematics.ScreenScaleVector(1,0.25)
    boxSize.Y = boxSize.Y - 4 --subtract border size--
    boxSize.X = boxSize.X - 8 --subtract border size x2--

    --inner box positions--
    local innerbox_x = (1-(4*boxPadding))/4
    local innerbox_y = 0.25 - (2*boxPadding)
    local innerbox_pad = 0.005
    local statsPos = Mathematics.ScreenScaleVector( (2*boxPadding) + innerbox_x ,0.75+boxPadding)
    local statsSize = Mathematics.ScreenScaleVector(innerbox_x*2,innerbox_y)

    local formationsPos = Mathematics.ScreenScaleVector( boxPadding ,0.75+boxPadding)
    local formationsSize = Mathematics.ScreenScaleVector(innerbox_x,innerbox_y)

    local buttonsPos = Mathematics.ScreenScaleVector( (3 * boxPadding) + (3*innerbox_x) ,0.75+boxPadding)
    local buttonsSize = Mathematics.ScreenScaleVector(innerbox_x,innerbox_y)

    local statSize = Mathematics.ScreenScaleVector((innerbox_x*2)/3,(innerbox_y))
    statSize.X = statSize.X - 20 statSize.Y = statSize.Y - 5
    local stat1Pos = Mathematics.ScreenScaleVector( (2*boxPadding) + innerbox_x ,0.75+boxPadding)
    stat1Pos.X = stat1Pos.X + 15 stat1Pos.Y = stat1Pos.Y + 20

    local stat2Pos = Mathematics.ScreenScaleVector( (2*boxPadding) + innerbox_x ,0.75+boxPadding)
    stat2Pos.X = stat2Pos.X + 30 + statSize.X stat2Pos.Y = stat2Pos.Y + 20

    local stat3Pos = Mathematics.ScreenScaleVector( (2*boxPadding) + innerbox_x ,0.75+boxPadding)
    stat3Pos.X = stat3Pos.X + 45 + (statSize.X*2) stat3Pos.Y = stat3Pos.Y + 20
    

    --action positions--
    local actionSize = Mathematics.ScreenScaleVector(innerbox_x-(2*innerbox_pad),((innerbox_y/4)-(innerbox_pad*2)))
    local actionPositions = {}
    for i=1,#unit.Actions do
        local actionPosX = buttonsPos.X + innerbox_pad
        local actionPosY = buttonsPos.Y + innerbox_pad + ((i-1) * (actionSize.Y + innerbox_pad))
        table.insert(actionPositions, Vector.New(actionPosX+15,actionPosY+7))
    end

    --formation positions--
    local formationSize = Mathematics.ScreenScaleVector(innerbox_x-(2*innerbox_pad),(innerbox_y/4-(innerbox_pad*3)))
    formationSize.X = formationSize.X - 20
    local formationPositions = {}
    for i=1,#unit.Formations do
        local formPosX = formationsPos.X + innerbox_pad + 10
        local formPosY = formationsPos.Y + innerbox_pad + ((i-1) * (formationSize.Y + innerbox_pad)) + (10*i)
        table.insert(formationPositions, Vector.New(formPosX+8,formPosY+8))
    end

    --text appearance data--
    local nameFont = Font.Gothic2
    local mainFont = Font.Georgia

    --initialise some variables (that are only necessary for regiment--
    local healthIndex local healthScore local moraleIndex local moraleScore
    local health local morale local currentActionTxt local currentAction 

    if unit.UnitClass ~= "Brigade" then
        healthIndex = 1--math.floor((unit.Health / unit.MaxHealth) / (#HEALTH_SCORES - 1)) + 1
        healthScore = "Health:\n\n" .. tostring( unit.Health ) --HEALTH_SCORES[healthIndex]

        moraleIndex = 1--math.floor((unit.Morale / 100) / (#MORALE_SCORES - 1)) + 1
        moraleScore = "Morale:\n\n" .. tostring( unit.Morale ) --MORALE_SCORES[moraleIndex]
        currentAction = "Currently:\n\n"..unit.CurrentAction
    end

    --create main box--
    local unitUIBox=TextBox.New("Back"," ",boxPos,boxSize,1,4,1,mainFont,1,black,teamColour,black,false,false)
    
    --create inner boxes--
    local statsBox=TextBox.New("Inner1"," ",statsPos,statsSize,1,3,1,mainFont,1,black,offwhite,black,false,false)
    local formationsBox=TextBox.New("Inner2"," ",formationsPos,formationsSize,1,3,1,mainFont,1,black,offwhite,black,false,false)
    local actionsBox=TextBox.New("Inner3"," ",buttonsPos,buttonsSize,1,3,1,mainFont,1,black,offwhite,black,false,false)

    if unit.UnitClass ~= "Brigade" then
        health=TextBox.New("HpTitle",healthScore,stat1Pos,statSize,30,0,0,mainFont,1,white,transparent,transparent,false,false)
        morale=TextBox.New("HpTitle",moraleScore,stat2Pos,statSize,30,0,0,mainFont,1,white,transparent,transparent,false,false)
        currentActionTxt=TextBox.New("HpTitle",currentAction,stat3Pos,statSize,30,0,0,mainFont,1,white,transparent,transparent,false,false)
    end

    --create action buttons--
    local actionBtns = {}
    for i=1,#unit.Actions,1 do
        local text = ""
        for i2=1,#actionToKey do if unit.Actions[i]==actionToKey[i2][1]then text=actionToKey[i2][2].." : "..unit.Actions[i]end end
        local shadowPos = Vector.New(actionPositions[i].X+2,actionPositions[i].Y+2)
        local actionBtnShadow=TextBox.New("Action"..tostring(i),text,shadowPos,actionSize,25,0,0,mainFont,1,black,transparent,transparent,false,false)
        local actionBtn=TextBox.New("Action"..tostring(i),text,actionPositions[i],actionSize,25,0,0,mainFont,1,white,transparent,transparent,false,false)
        table.insert(actionBtns, actionBtnShadow)
        table.insert(actionBtns, actionBtn)
    end
    --create formation buttons--
    local formationBtns = {}
    for i=1,#unit.Formations,1 do
        local text = unit.Formations[i]
        local formBtn=TextBox.New(text,text,formationPositions[i],formationSize,25,3,5,mainFont,1,white,teamColour,black,true,true)
        table.insert(formationBtns, formBtn)
    end


    --create a new screen to return--
    local newScreen = Screen.New(1)
    if unit.UnitClass ~= "Brigade" then
        newScreen.UiObjects = {unitUIBox,statsBox,formationsBox,actionsBox,health,morale,currentActionTxt}
    else
        newScreen.UiObjects = {unitUIBox,statsBox,formationsBox,actionsBox}
    end
    for i=1,#actionBtns do table.insert(newScreen.UiObjects, actionBtns[i]) end
    for i=1,#formationBtns do table.insert(newScreen.UiObjects, formationBtns[i]) end

    newUnitUI.Screen = newScreen

    setmetatable(newUnitUI,{__index=UnitUI})--map the new table onto the Battalion class--
    return newUnitUI--return the new object--
end

function UnitUI:CheckForClicks(mousePos,mouseClick)
    --creates an table of all clicked ui elements--
    clickedObjects = self.Screen:CheckForMouse(mousePos,mouseClick)

    local tempUnit = CurrentUnit
    if CurrentUnit.UnitClass == "Battalion" then tempUnit=CurrentUnit.Regiment end

    local updatedFormation = false
    for i=1,#clickedObjects,1 do 

        -- REGULAR FORMATIONS --
        if clickedObjects[i].Name=="BattleLine" then 
            tempUnit:ChangeFormation("BattleLine")
            updatedFormation = true
        
        elseif clickedObjects[i].Name=="MarchingColumn" then 
            tempUnit:ChangeFormation("MarchingColumn")
            updatedFormation = true

        elseif clickedObjects[i].Name=="SkirmishOrder" then 
            tempUnit:ChangeFormation("SkirmishOrder")
            updatedFormation = true

        elseif clickedObjects[i].Name=="FiringLine" then 
            tempUnit:ChangeFormation("FiringLine")
            updatedFormation = true

        elseif clickedObjects[i].Name=="Dismounted" then 
            tempUnit:ChangeFormation("Dismounted")
            updatedFormation = true

        elseif clickedObjects[i].Name=="Mounted" then 
            tempUnit:ChangeFormation("Mounted")
            updatedFormation = true

        -- BRIGADE FORMATIONS --
        elseif clickedObjects[i].Name=="FullBattleLine" then 
            tempUnit:ChangeFormation("FullBattleLine")
            updatedFormation = true

        end

        if updatedFormation then
            tempUnit:UpdateAnimation()
            break
        end
    end
end


return UnitUI