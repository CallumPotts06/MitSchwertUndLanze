

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

ReadSettings = require("OtherLibraries/ReadSettings")
KeyBinds = require("Config/KeyBinds")
--// END OF IMPORTS //--


SettingsMenu = {}

function SettingsMenu.Open()
    ReadSettings.UpdateSettings()

    --get the screen size--
    local x,y = love.graphics.getDimensions()

    --setup data for the background image--
    local transparent = Colours.CreateColour(Colours.Transparent)
    local imgPos = Vector.New(0,0)
    local imgSize = Vector.New(x,y)
    local img = Images.Title1Blurred
    --create the background image ui--
    BackgroundImage = ImageBox.New("BackgroundImage",img,imgPos,imgSize,0,0,transparent,transparent,false,false)

    --setup appearance data for all the buttons--
    local white = Colours.CreateColour(Colours.White)
    local lgray = Colours.CreateColour(Colours.LightGray)
    local black = Colours.CreateColour(Colours.Black)
    local textBackClr = Colours.CreateColour({0,0,0,0.1})

    --all the text data for the buttons--
    local btnFont = Font.Georgia

    local rtn = "Return To Main Menu"
    local txt1 = "Sound Settings"
    local txt2 = "Volume"
    local txt3 = "Menu Music"
    local txt4 = "Video Settings"
    local txt5 = "Full Screen"
    local txt6 = "Screen Width"
    local txt7 = "Screen Height"
    local txt8 = "Weather Effects"
    local txt9 = "Key Binds"
    local txt10 = "Move Unit"
    local txt11 = "Wheel Unit"
    local txt12 = "Charge Unit"

    local txt2b = tostring(ReadSettings.Settings.Volume)
    local txt3b = tostring(ReadSettings.Settings.MenuMusic)
    local txt5b = tostring(ReadSettings.Settings.FullScreen)
    local txt6b = tostring(ReadSettings.Settings.ScreenWidth)
    local txt7b = tostring(ReadSettings.Settings.ScreenHeight)
    local txt8b = tostring(ReadSettings.Settings.WeatherEffects)
    local txt10b = tostring(KeyBinds.Move)
    local txt11b = tostring(KeyBinds.Wheel)
    local txt12b = tostring(KeyBinds.Charge)
    

    --all the positional data for the buttons--
    local rtnSize = Mathematics.ScreenScaleVector(0.4,0.1)
    
    local headerSize = Mathematics.ScreenScaleVector(0.16,0.05)
    local btnSize = Mathematics.ScreenScaleVector(0.11,0.05)
    local etrSize = Mathematics.ScreenScaleVector(0.04,0.05)

    local returnPos = Mathematics.ScreenScaleVector(0.05,0.05)

    local soundPos = Mathematics.ScreenScaleVector(0.05,0.2)
    local btn2aPos = Mathematics.ScreenScaleVector(0.1,0.27)
    local btn2bPos = Mathematics.ScreenScaleVector(0.22,0.27)
    local btn3aPos = Mathematics.ScreenScaleVector(0.1,0.34)
    local btn3bPos = Mathematics.ScreenScaleVector(0.22,0.34)

    local videoPos = Mathematics.ScreenScaleVector(0.05,0.41)
    local btn5aPos = Mathematics.ScreenScaleVector(0.1,0.48)
    local btn5bPos = Mathematics.ScreenScaleVector(0.22,0.48)
    local btn6aPos = Mathematics.ScreenScaleVector(0.1,0.55)
    local btn6bPos = Mathematics.ScreenScaleVector(0.22,0.55)
    local btn7aPos = Mathematics.ScreenScaleVector(0.1,0.62)
    local btn7bPos = Mathematics.ScreenScaleVector(0.22,0.62)
    local btn8aPos = Mathematics.ScreenScaleVector(0.1,0.69)
    local btn8bPos = Mathematics.ScreenScaleVector(0.22,0.69)

    local keyPos = Mathematics.ScreenScaleVector(0.4,0.2)
    local btn10aPos = Mathematics.ScreenScaleVector(0.45,0.27)
    local btn10bPos = Mathematics.ScreenScaleVector(0.57,0.27)
    local btn11aPos = Mathematics.ScreenScaleVector(0.45,0.34)
    local btn11bPos = Mathematics.ScreenScaleVector(0.57,0.34)
    local btn12aPos = Mathematics.ScreenScaleVector(0.45,0.41)
    local btn12bPos = Mathematics.ScreenScaleVector(0.57,0.41)

    local maxFont = 22

    --create all the button objects--
    btnR = TextBox.New("Return",rtn,returnPos,rtnSize,50,5,10,btnFont,1,white,textBackClr,transparent,true,true)
    
    bx1 = TextBox.New("SoundSettingsHeader",txt1,soundPos,headerSize,maxFont,5,10,btnFont,1,black,white,lgray,false,false)
    bx2a = TextBox.New("VolumeTxt",txt2,btn2aPos,btnSize,maxFont,5,10,btnFont,0.95,black,textBackClr,transparent,false,false)
    bx2b = TextBox.New("VolumeBtn",txt2b,btn2bPos,etrSize,maxFont,5,10,btnFont,0.9,white,textBackClr,transparent,true,true)
    bx3a = TextBox.New("MenuMusicTxt",txt3,btn3aPos,btnSize,maxFont,5,10,btnFont,0.95,black,textBackClr,transparent,false,false)
    bx3b = TextBox.New("MenuMusicBtn",txt3b,btn3bPos,etrSize,maxFont,5,10,btnFont,0.9,white,textBackClr,transparent,true,true)

    bx4 = TextBox.New("VideoSettingsHeader",txt4,videoPos,headerSize,maxFont,5,10,btnFont,1,black,white,lgray,false,false)
    bx5a = TextBox.New("FullScreenTxt",txt5,btn5aPos,btnSize,maxFont,5,10,btnFont,0.95,black,textBackClr,transparent,false,false)
    bx5b = TextBox.New("FullScreenBtn",txt5b,btn5bPos,etrSize,maxFont,5,10,btnFont,0.9,white,textBackClr,transparent,true,true)
    bx6a = TextBox.New("WidthTxt",txt6,btn6aPos,btnSize,maxFont,5,10,btnFont,0.95,black,textBackClr,transparent,false,false)
    bx6b = TextBox.New("WidthBtn",txt6b,btn6bPos,etrSize,maxFont,5,10,btnFont,0.9,white,textBackClr,transparent,true,true)
    bx7a = TextBox.New("HeightTxt",txt7,btn7aPos,btnSize,maxFont,5,10,btnFont,0.95,black,textBackClr,transparent,false,false)
    bx7b = TextBox.New("HeightBtn",txt7b,btn7bPos,etrSize,maxFont,5,10,btnFont,0.9,white,textBackClr,transparent,true,true)
    bx8a = TextBox.New("WeatherTxt",txt8,btn8aPos,btnSize,maxFont,5,10,btnFont,0.95,black,textBackClr,transparent,false,false)
    bx8b = TextBox.New("WeatherBtn",txt8b,btn8bPos,etrSize,maxFont,5,10,btnFont,0.9,white,textBackClr,transparent,true,true)

    bx9 = TextBox.New("KeyBindsHeader",txt9,keyPos,headerSize,maxFont,5,10,btnFont,1,black,white,lgray,false,false)
    bx10a = TextBox.New("MoveTxt",txt10,btn10aPos,btnSize,maxFont,5,10,btnFont,0.95,black,textBackClr,transparent,false,false)
    bx10b = TextBox.New("MoveBtn",txt10b,btn10bPos,etrSize,maxFont,5,10,btnFont,0.9,white,textBackClr,transparent,true,true)
    bx11a = TextBox.New("WheelTxt",txt11,btn11aPos,btnSize,maxFont,5,10,btnFont,0.95,black,textBackClr,transparent,false,false)
    bx11b = TextBox.New("WheelBtn",txt11b,btn11bPos,etrSize,maxFont,5,10,btnFont,0.9,white,textBackClr,transparent,true,true)
    bx12a = TextBox.New("ChargeTxt",txt12,btn12aPos,btnSize,maxFont,5,10,btnFont,0.95,black,textBackClr,transparent,false,false)
    bx12b = TextBox.New("ChargeBtn",txt12b,btn12bPos,etrSize,maxFont,5,10,btnFont,0.9,white,textBackClr,transparent,true,true)




    --create a new screen to return to the menu handler--
    local newScreen = Screen.New(1)
    newScreen.UiObjects = {
        BackgroundImage,
        btnR,
        bx1,bx2a,bx2b,bx3a,bx3b,
        bx4,bx5a,bx5b,bx6a,bx6b,bx7a,bx7b,bx8a,bx8b,
        bx9,bx10a,bx10b,bx11a,bx11b,bx12a,bx12b
    }

    return newScreen--returns a screen object to call location--
end

return SettingsMenu