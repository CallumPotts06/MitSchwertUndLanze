
--// IMPORT LIBRARIES //--
Mathematics = require("Mathematics/Mathematics")

Colours = require("Interface/Colours")
Font = require("Interface/Font")

Images = require("MediaHandler/Images")
Sounds = require("MediaHandler/Sounds")
--// IMPORT CLASSES //--
Vector = require("Mathematics/Vector")

TextBox = require("Interface/TextBox")
ImageBox = require("Interface/ImageBox")
Screen = require("Interface/Screen")
--// END OF IMPORTS //--


HUD = {}

function HUD.Open()
    --get the screen size--
    local x,y = love.graphics.getDimensions()

    --create the title and version appearance and positional data--
    local timeTextPosA = Mathematics.ScreenScaleVector(0.8,0.1)
    local timeTextSize = Mathematics.ScreenScaleVector(0.175,0.075)
    local timeTextMaxSize = 40
    local timeTextText = "Time: "..tostring(TimeOfDay) 
    local timeTextFont = Font.Georgia

    --setup appearance data for all the text objects--
    local white = Colours.CreateColour(Colours.White)
    local black = Colours.CreateColour(Colours.Black)
    local textBackClr = Colours.CreateColour({0,0,0,0.1})

    local timeText = TextBox.New("TimeCounter",timeTextText,timeTextPosA,timeTextSize,timeTextMaxSize,0,5,timeTextFont,1,black,white,white,false,false)

    --create a new screen to return to the menu handler--
    local newScreen = Screen.New(1)
    newScreen.UiObjects = {timeText}

    return newScreen--returns a screen object to call location--
end

return HUD