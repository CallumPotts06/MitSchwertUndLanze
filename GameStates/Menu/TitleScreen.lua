
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


TitleScreen = {}

function TitleScreen.Open()
    --get the screen size--
    local x,y = love.graphics.getDimensions()

    --setup data for the background image--
    local transparent = Colours.CreateColour(Colours.Transparent)
    local imgPos = Vector.New(0,0)
    local imgSize = Vector.New(x,y)
    local img = Images.Title1Blurred
    --create the background image ui--
    BackgroundImage = ImageBox.New("BackgroundImage",img,imgPos,imgSize,0,0,transparent,transparent,false,false)


    --setup data for the title text--
    local titleText = "- mit schwert und lanze -"
    local titleFont = Font.Gothic2 
    local titleBackClr = Colours.CreateColour({0,0,0,0.1})
    local white = Colours.CreateColour(Colours.White)
    local title1Pos = Mathematics.ScreenScaleVector(0.135,0.1)
    local titleSize = Mathematics.ScreenScaleVector(0.73,0.24)
    local titleTextScale = 1.84
    --create the title text ui--
    Title1 = TextBox.New("Title1",titleText,title1Pos,titleSize,0,25,titleFont,titleTextScale,white,titleBackClr,transparent,false,false)
    --setup data for the title shadow text--
    local black = Colours.CreateColour(Colours.Black)
    local title2Pos = Mathematics.ScreenScaleVector(0.137,0.102)
    --create the title text shadow ui--
    Title2 = TextBox.New("Title2",titleText,title2Pos,titleSize,0,25,titleFont,titleTextScale,black,transparent,transparent,false,false)


    --setup data for the start button--
    local buttonText = "START GAME"
    local buttonFont = Font.Georgia
    local black = Colours.CreateColour(Colours.Black)
    local lGray = Colours.CreateColour(Colours.LightGray)
    local buttonPos = Mathematics.ScreenScaleVector(0.35,0.8)
    local buttonSize = Mathematics.ScreenScaleVector(0.3,0.1175)
    --create the start button ui--
    Button = TextBox.New("StartButton",buttonText,buttonPos,buttonSize,5,25,buttonFont,1.025,black,white,lGray,true,true)


    --create a new screen to return to the menu handler--
    local newScreen = Screen.New(1)
    newScreen.UiObjects = {BackgroundImage,Title2,Title1,Button}

    return newScreen--returns a screen object to call location--
end

return TitleScreen