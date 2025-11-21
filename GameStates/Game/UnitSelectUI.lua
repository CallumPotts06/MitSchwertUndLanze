
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


UnitUI = {}

function UnitUI.Open(unit)
    local actionToKey = {
        {"Move", KeyBinds.Move},
        {"Double", KeyBinds.Double},
        {"Charge", KeyBinds.Charge},
        {"Wheel", KeyBinds.Wheel},
        {"Target", KeyBinds.Target},
    }


    --setup appearance data for the UI--

    --text colours--
    local offwhite = Colours.CreateColour({0.9,0.9,0.7,1})
    local white = Colours.CreateColour(Colours.White)
    local black = Colours.CreateColour(Colours.Black)

    --team colours--
    local prussianBlue = Colours.CreateColour({0,0.188,0.564,1})

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
    local innerbox_x = (1-(4*boxPadding))/3
    local innerbox_y = 0.25 - (2*boxPadding)
    local innerbox_pad = 0.005
    local statsPos = Mathematics.ScreenScaleVector(boxPadding,0.75+boxPadding)
    local statsSize = Mathematics.ScreenScaleVector(innerbox_x,innerbox_y)

    local formationsPos = Mathematics.ScreenScaleVector( (2*boxPadding) + innerbox_x ,0.75+boxPadding)
    local formationsSize = Mathematics.ScreenScaleVector(innerbox_x,innerbox_y)

    local buttonsPos = Mathematics.ScreenScaleVector( (3 *boxPadding) + (2*innerbox_x) ,0.75+boxPadding)
    local buttonsSize = Mathematics.ScreenScaleVector(innerbox_x,innerbox_y)

    --action positions--
    local actionSize = Mathematics.ScreenScaleVector(innerbox_x-(2*innerbox_pad),((innerbox_y/2)-(innerbox_pad*3)))
    print("action size = "..tostring(actionSize.X)..","..tostring(actionSize.Y))
    local actionPositions = {}
    for i=1,#unit.Actions do
        local actionPosX = buttonsPos.X + innerbox_pad
        local actionPosY = buttonsPos.Y + innerbox_pad + ((i-1) * (actionSize.Y + innerbox_pad))
        table.insert(actionPositions, Mathematics.ScreenScaleVector(actionPosX,actionPosY))
    end

    --formation positions--
    local formationSize = Mathematics.ScreenScaleVector(innerbox_x-(2*innerbox_pad),(innerbox_y/3-(innerbox_pad*4)))
    local formationPositions = {}
    for i=1,#unit.Formations do
        local formPosX = formationsPos.X + innerbox_pad
        local formPosY = formationsPos.Y + innerbox_pad + ((i-1) * (formationSize.Y + innerbox_pad))
        table.insert(formationPositions, Mathematics.ScreenScaleVector(formPosX,formPosY))
    end

    --text appearance data--
    local nameFont = Font.Gothic2
    local mainFont = Font.Georgia

    --create main box--
    local unitUIBox=TextBox.New("Back"," ",boxPos,boxSize,1,4,1,mainFont,1,black,teamColour,black,false,false)
    
    --create inner boxes--
    local statsBox=TextBox.New("Inner1"," ",statsPos,statsSize,1,3,1,mainFont,1,black,offwhite,black,false,false)
    local formationsBox=TextBox.New("Inner2"," ",formationsPos,formationsSize,1,3,1,mainFont,1,black,offwhite,black,false,false)
    local actionsBox=TextBox.New("Inner3"," ",buttonsPos,buttonsSize,1,3,1,mainFont,1,black,offwhite,black,false,false)

    --create action buttons--
    local actionBtns = {}
    for i=1,#unit.Actions,1 do
        local text = ""
        for i2=1,#actionToKey do if unit.Actions[i]==actionToKey[i2][1]then text=actionToKey[i2][2].." : "..unit.Actions[i]end end
        local actionBtn=TextBox.New("Action"..tostring(i),text,actionPositions[i],actionSize,10,0,0,mainFont,1,black,white,black,false,false)
        table.insert(actionBtns, actionBtn)
    end


    --create a new screen to return--
    local newScreen = Screen.New(1)
    --newScreen.UiObjects = {unitUIBox,statsBox,formationsBox,actionsBox}
    --for i=1,#actionBtns do table.insert(newScreen.UiObjects,  actionBtns[i]) end

    return newScreen--returns a screen object to call location--
end

return UnitUI