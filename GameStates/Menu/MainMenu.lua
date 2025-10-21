

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


MainMenu = {}

function MainMenu.Open()
    --get the screen size--
    local x,y = love.graphics.getDimensions()

    --setup data for the background image--
    local transparent = Colours.CreateColour(Colours.Transparent)
    local imgPos = Vector.New(0,0)
    local imgSize = Vector.New(x,y)
    local img = Images.Title1
    --create the background image ui--
    BackgroundImage = ImageBox.New("BackgroundImage",img,imgPos,imgSize,0,0,transparent,transparent,false,false)

    --setup appearance data for all the buttons--
    local white = Colours.CreateColour(Colours.White)
    local black = Colours.CreateColour(Colours.Black)
    local textBackClr = Colours.CreateColour({0,0,0,0.1})

    --all the text data for the buttons--
    local btnFont = Font.Georgia

    local txt1 = "Campaign Mode"
    local txt2 = "Quick Battle"
    local txt3 = "Settings"
    local txt4 = "Exit Game"

    --all the positional data for the buttons--
    local btnSize = Mathematics.ScreenScaleVector(0.3,0.1)

    local btnpos1 = Mathematics.ScreenScaleVector(0.035,0.2)
    local btnpos1b = Mathematics.ScreenScaleVector(0.0355,0.203)
    local btnpos2 = Mathematics.ScreenScaleVector(0.035,0.35)
    local btnpos2b = Mathematics.ScreenScaleVector(0.0355,0.353)
    local btnpos3 = Mathematics.ScreenScaleVector(0.035,0.5)
    local btnpos3b = Mathematics.ScreenScaleVector(0.0355,0.503)
    local btnpos4 = Mathematics.ScreenScaleVector(0.035,0.65)
    local btnpos4b = Mathematics.ScreenScaleVector(0.0355,0.653)

    --create all the button objects--
    btn1 = TextBox.New("CampaignBtn",txt1,btnpos1,btnSize,0,25,btnFont,1,white,textBackClr,transparent,true,true)
    btn1b = TextBox.New("CampaignBtnb",txt1,btnpos1b,btnSize,0,25,btnFont,1,black,transparent,transparent,true,false)

    btn2 = TextBox.New("QuickBattleBtn",txt2,btnpos2,btnSize,0,25,btnFont,1,white,textBackClr,transparent,true,true)
    btn2b = TextBox.New("QuickBattleBtnb",txt2,btnpos2b,btnSize,0,25,btnFont,1,black,transparent,transparent,true,false)

    btn3 = TextBox.New("SettingsBtn",txt3,btnpos3,btnSize,0,25,btnFont,1,white,textBackClr,transparent,true,true)
    btn3b = TextBox.New("SettingsBtnb",txt3,btnpos3b,btnSize,0,25,btnFont,1,black,transparent,transparent,true,false)

    btn4 = TextBox.New("ExitBtn",txt4,btnpos4,btnSize,0,25,btnFont,1,white,textBackClr,transparent,true,true)
    btn4b = TextBox.New("ExitBtnb",txt4,btnpos4b,btnSize,0,25,btnFont,1,black,transparent,transparent,true,false)


    --create a new screen to return to the menu handler--
    local newScreen = Screen.New(1)
    newScreen.UiObjects = {BackgroundImage,btn1b,btn1,btn2b,btn2,btn3b,btn3,btn4b,btn4}

    return newScreen--returns a screen object to call location--
end

return MainMenu