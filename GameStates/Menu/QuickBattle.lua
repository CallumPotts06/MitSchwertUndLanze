


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


QuickBattleMenu = {}


local function BattleData(name,picture,t1,t2)
    --little function to create an object for the battle data--
    local newTable = {}
    newTable.Name = name
    newTable.Picture = picture
    newTable.Team1 = t1
    newTable.Team2 = t2
    return newTable
end

--// CREATE DATA FOR THE BATTLES //--
--/ FRANCO PRUSSIAN WAR /--
local Spicheren = BattleData("Spicheren",Images.BattleImages.Spicheren,"France","Germany")
local MarsLaTour = BattleData("Mars La Tour",Images.BattleImages.MarsLaTour,"France","Germany")
local Gravelotte = BattleData("Gravelotte",Images.BattleImages.Gravelotte,"France","Germany")
local Metz = BattleData("Metz",Images.BattleImages.Metz,"France","Germany")
local Sedan = BattleData("Sedan",Images.BattleImages.Sedan,"France","Germany")

local Battles = {}
Battles.CurrentBattleIndex = 1--index values--
Battles.BattleList = {Spicheren,MarsLaTour,Gravelotte,Metz,Sedan} 



function QuickBattleMenu.Open()
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
    local lGray = Colours.CreateColour(Colours.LightGray)
    local black = Colours.CreateColour(Colours.Black)
    local yellow = Colours.CreateColour({0.85,0.85,0.2,1})
    local textBackClr = Colours.CreateColour({0,0,0,0.1})
    local img = Images.BattleImages.Spicheren
    local t1Img = Images.FactionFlags.France
    local t2Img = Images.FactionFlags.Germany

    --all the text data for the buttons--
    local btnFont = Font.Georgia
    local battleFont = Font.Gothic2

    local rtn = "Return To Main Menu"
    local battleText = "Spicheren"

    local prompt1 = "Play as France"
    local prompt2 = "Play as Germany"

    --all the positional data for the buttons--
    local battleImageSize = Mathematics.ScreenScaleVector(0.5,0.5)
    local battleImagePos = Mathematics.ScreenScaleVector(0.25,0.125)

    local tSize = Mathematics.ScreenScaleVector(0.14,0.12)
    local pSize = Mathematics.ScreenScaleVector(0.14,0.06)
    local t1Pos = Mathematics.ScreenScaleVector(0.3,0.75)
    local t2Pos = Mathematics.ScreenScaleVector(0.56,0.75)

    local p1Pos =  Mathematics.ScreenScaleVector(0.3,0.9)
    local p2Pos =  Mathematics.ScreenScaleVector(0.56,0.9)

    local battleTextSize = Mathematics.ScreenScaleVector(0.5,0.2)
    local battleTextPosA = Mathematics.ScreenScaleVector(0.25,0.4)
    local battleTextPosB = Mathematics.ScreenScaleVector(0.253,0.403)

    local returnPos = Mathematics.ScreenScaleVector(0.025,0.015)
    local rtnSize = Mathematics.ScreenScaleVector(0.4,0.08)

    local iconSize = Vector.New(75,75)
    local nextBtlPos = Mathematics.ScreenScaleVector(0.8,0.5)
    local prevBtlPos = Mathematics.ScreenScaleVector(0.18,0.5)
    
    --create all the button objects--
    btnR = TextBox.New("Return",rtn,returnPos,rtnSize,5,10,btnFont,1,white,textBackClr,transparent,true,true)

    battleImage = ImageBox.New("BattleImage",img,battleImagePos,battleImageSize,15,0,black,black,false,false)
    battleTextA = TextBox.New("BattleTextA",battleText,battleTextPosA,battleTextSize,0,25,battleFont,2,white,transparent,transparent,false,false)
    battleTextB = TextBox.New("BattleTextB",battleText,battleTextPosB,battleTextSize,0,25,battleFont,2,black,transparent,transparent,false,false)
    
    nextBattle = TextBox.New("nextBtl",">",nextBtlPos,iconSize,0,5,btnFont,1,black,white,lGray,true,true)
    prevBattle = TextBox.New("prevBtl","<",prevBtlPos,iconSize,0,5,btnFont,1,black,white,lGray,true,true)

    t1Image = ImageBox.New("Faction1",t1Img,t1Pos,tSize,5,0,yellow,yellow,true,true)
    t2Image = ImageBox.New("Faction2",t2Img,t2Pos,tSize,5,0,yellow,yellow,true,true)

    p1Txt = TextBox.New("Faction1Prompt",prompt1,p1Pos,pSize,0,5,btnFont,1,black,textBackClr,transparent,false,false)
    p2Txt = TextBox.New("Faction2Prompt",prompt2,p2Pos,pSize,0,5,btnFont,1,black,textBackClr,transparent,false,false)

    --create a new screen to return to the menu handler--
    local newScreen = Screen.New(1)
    newScreen.UiObjects = {
        BackgroundImage,btnR,battleImage,battleTextB,battleTextA,nextBattle,prevBattle,t1Image,t2Image,p1Txt,p2Txt
    }

    return newScreen--returns a screen object to call location--
end

function QuickBattleMenu.ChangeBattle(screen,indexChange)
    --change index in the list--
    if Battles.CurrentBattleIndex + indexChange < 1 then
        Battles.CurrentBattleIndex = #Battles.BattleList
    elseif Battles.CurrentBattleIndex + indexChange > #Battles.BattleList then
        Battles.CurrentBattleIndex = 1
    else
        Battles.CurrentBattleIndex = Battles.CurrentBattleIndex + indexChange
    end 

    --update ui--
    for i = 1,#screen.UiObjects,1 do--look through all the objects--
        if screen.UiObjects[i].Name == "BattleImage" then
            screen.UiObjects[i].Image = Images.CreateImage(Battles.BattleList[Battles.CurrentBattleIndex].Picture)
            screen.UiObjects[i]:CreateCanvas()
        elseif screen.UiObjects[i].Name == "BattleTextA" then
            screen.UiObjects[i].Text =  Battles.BattleList[Battles.CurrentBattleIndex].Name
            screen.UiObjects[i].TextData = love.graphics.newText(screen.UiObjects[i].Font, screen.UiObjects[i].Text)
            screen.UiObjects[i]:CreateCanvas()
        elseif screen.UiObjects[i].Name == "BattleTextB" then
            screen.UiObjects[i].Text =  Battles.BattleList[Battles.CurrentBattleIndex].Name
            screen.UiObjects[i].TextData = love.graphics.newText(screen.UiObjects[i].Font, screen.UiObjects[i].Text)
            screen.UiObjects[i]:CreateCanvas()
        end
    end
end


return QuickBattleMenu