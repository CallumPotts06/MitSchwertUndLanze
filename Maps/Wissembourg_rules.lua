maprules = {}

function maprules.LaunchBattle()

    

    local mapName = "Maps/Wissembourg.map"

    ---/// ######### ///---
    ---/// MAP STATS ///---
    ---/// ######### ///---

    TimeOfDay = 0745
    PlayerTeam = 1

    --load squads for gameplay--
    Squad.LoadAllSquads()

    ---/// ############ ///---
    ---/// FRENCH UNITS ///---
    ---/// ############ ///---

    local tempReg1 = {} local tempReg2 = {} local tempReg3 = {} local tempReg4 = {}
    tempReg1.Name = "50th Infantry Regiment" tempReg1.UnitType = "FrenchLineInfantry" tempReg1.UnitTypeName = "FrenchLineInfantry"
    tempReg2.Name = "74th Infantry Regiment" tempReg2.UnitType = "FrenchLineInfantry" tempReg2.UnitTypeName = "FrenchLineInfantry"
    tempReg3.Name = "16th Chasseurs" tempReg3.UnitType = "FrenchLineInfantry" tempReg3.UnitTypeName = "FrenchLineInfantry"
    tempReg4.Name = "null" tempReg4.UnitType = "FrenchChasseurs" tempReg4.UnitTypeName = "FrenchChasseurs"

    brigade1Names = { tempReg1, tempReg2, tempReg3, tempReg4 }

    local tempReg1 = {} local tempReg2 = {} local tempReg3 = {} local tempReg4 = {}
    tempReg1.Name = "78th Infantry Regiment" tempReg1.UnitType = "FrenchLineInfantry" tempReg1.UnitTypeName = "FrenchLineInfantry"
    tempReg2.Name = "1st Turkish Zouaves" tempReg2.UnitType = "FrenchZouaves" tempReg2.UnitTypeName = "FrenchZouaves"
    tempReg3.Name = "null" tempReg3.UnitType = "FrenchLineInfantry" tempReg3.UnitTypeName = "FrenchLineInfantry"
    tempReg4.Name = "null" tempReg4.UnitType = "FrenchLineInfantry" tempReg4.UnitTypeName = "FrenchLineInfantry"

    brigade2Names = { tempReg1, tempReg2, tempReg3, tempReg4 }

    local tempReg1 = {} local tempReg2 = {} local tempReg3 = {} local tempReg4 = {}
    tempReg1.Name = "11th Infantry Regiment" tempReg1.UnitType = "FrenchLineInfantry" tempReg1.UnitTypeName = "FrenchLineInfantry"
    tempReg2.Name = "46th Infantry Regiment" tempReg2.UnitType = "FrenchLineInfantry" tempReg2.UnitTypeName = "FrenchLineInfantry"
    tempReg3.Name = "61st Infantry Regiment" tempReg3.UnitType = "FrenchLineInfantry" tempReg3.UnitTypeName = "FrenchLineInfantry"
    tempReg4.Name = "4th Chasseurs" tempReg4.UnitType = "FrenchChasseurs" tempReg4.UnitTypeName = "FrenchChasseurs"

    brigade3Names = { tempReg1, tempReg2, tempReg3, tempReg4 }

    local tempReg1 = {} local tempReg2 = {} local tempReg3 = {} local tempReg4 = {}
    tempReg1.Name = "2nd Div Artillery" tempReg1.UnitType = "FrenchArtillery" tempReg1.UnitTypeName = "FrenchArtillery"
    tempReg2.Name = "2nd Div Mitrailleuse" tempReg2.UnitType = "FrenchArtillery" tempReg2.UnitTypeName = "FrenchArtillery"
    tempReg3.Name = "null" tempReg3.UnitType = "FrenchArtillery" tempReg3.UnitTypeName = "FrenchArtillery"
    tempReg4.Name = "null" tempReg4.UnitType = "FrenchArtillery" tempReg4.UnitTypeName = "FrenchArtillery"

    brigade4Names = { tempReg1, tempReg2, tempReg3, tempReg4 }

    Brigade1 = Brigade.New("1st Brigade",brigade1Names,"France","Infantry",Vector.New(4900,1750),"Summer")
    Brigade2 = Brigade.New("2nd Brigade",brigade2Names,"France","Infantry",Vector.New(4900,5250),"Summer")
    Brigade3 = Brigade.New("4th Brigade",brigade3Names,"France","Infantry",Vector.New(4900,9750),"Summer")
    Brigade4 = Brigade.New("Artillery Brigade",brigade4Names,"France","Artillery",Vector.New(4000,8500),"Summer")

    local FrenchArmy = { Brigade1, Brigade2, Brigade3, Brigade4 }

    ---/// ############ ///---
    ---/// GERMAN UNITS ///---
    ---/// ############ ///---

    local tempReg1 = {} local tempReg2 = {} local tempReg3 = {} local tempReg4 = {}
    tempReg1.Name = "6th Bavarian Regiment" tempReg1.UnitType = "BayerischerLineninfanterie" tempReg1.UnitTypeName = "BayerischerLineninfanterie"
    tempReg2.Name = "7th Bavarian Regiment" tempReg2.UnitType = "BayerischerLineninfanterie" tempReg2.UnitTypeName = "BayerischerLineninfanterie"
    tempReg3.Name = "14th Bavarian Regiment" tempReg3.UnitType = "BayerischerLineninfanterie" tempReg3.UnitTypeName = "BayerischerLineninfanterie"
    tempReg4.Name = "null" tempReg4.UnitType = "BayerischerLineninfanterie" tempReg4.UnitTypeName = "BayerischerLineninfanterie"

    brigade1Names = { tempReg1, tempReg2, tempReg3, tempReg4 }

    local tempReg1 = {} local tempReg2 = {} local tempReg3 = {} local tempReg4 = {}
    tempReg1.Name = "3rd Baden Regiment" tempReg1.UnitType = "DeutscherLineninfanterie" tempReg1.UnitTypeName = "BadenLineninfanterie"
    tempReg2.Name = "4th Baden Regiment" tempReg2.UnitType = "DeutscherLineninfanterie" tempReg2.UnitTypeName = "BadenLineninfanterie"
    tempReg3.Name = "3rd Wuerttemburg Regiment" tempReg3.UnitType = "DeutscherLineninfanterie" tempReg3.UnitTypeName = "WuerttemburgLineninfanterie"
    tempReg4.Name = "5th Wuerttemburg Regiment" tempReg4.UnitType = "DeutscherLineninfanterie" tempReg4.UnitTypeName = "WuerttemburgLineninfanterie"

    brigade2Names = { tempReg1, tempReg2, tempReg3, tempReg4 }

    local tempReg1 = {} local tempReg2 = {} local tempReg3 = {} local tempReg4 = {}
    tempReg1.Name = "2nd Hessian Regiment" tempReg1.UnitType = "DeutscherLineninfanterie" tempReg1.UnitTypeName = "HessischLineninfanterie"
    tempReg4.Name = "1st Nassau Regiment" tempReg2.UnitType = "DeutscherLineninfanterie" tempReg2.UnitTypeName = "PreussischerLineninfanterie"
    tempReg3.Name = "2nd Nassau Regiment" tempReg3.UnitType = "DeutscherLineninfanterie" tempReg3.UnitTypeName = "PreussischerLineninfanterie"
    tempReg2.Name = "Hessian Jaegers" tempReg4.UnitType = "DeutscherJaegers" tempReg4.UnitTypeName = "PreussischerJaegers"

    
    brigade3Names = { tempReg1, tempReg2, tempReg3, tempReg4 }

    local tempReg1 = {} local tempReg2 = {} local tempReg3 = {} local tempReg4 = {}
    tempReg1.Name = "5th Artillery Battery 1" tempReg1.UnitType = "DeutscherArtillerie" tempReg1.UnitTypeName = "PreussischerArtillerie"
    tempReg2.Name = "5th Artillery Battery 2" tempReg2.UnitType = "DeutscherArtillerie" tempReg2.UnitTypeName = "PreussischerArtillerie"
    tempReg3.Name = "5th Artillery Battery 3" tempReg3.UnitType = "DeutscherArtillerie" tempReg3.UnitTypeName = "PreussischerArtillerie"
    tempReg4.Name = "null" tempReg4.UnitType = "DeutscherArtillerie" tempReg4.UnitTypeName = "PreussischerArtillerie"

    brigade5Names = { tempReg1, tempReg2, tempReg3, tempReg4 }

    local tempReg1 = {} local tempReg2 = {} local tempReg3 = {} local tempReg4 = {}
    tempReg1.Name = "1st Kurmark Dragoner" tempReg1.UnitType = "PreussischerHusaren" tempReg1.UnitTypeName = "PreussischerHusaren"
    tempReg2.Name = "2nd Silesian Dragoner" tempReg2.UnitType = "PreussischerHusaren" tempReg2.UnitTypeName = "PreussischerHusaren"
    tempReg3.Name = "null" tempReg3.UnitType = "PreussischerHusaren" tempReg3.UnitTypeName = "PreussischerHusaren"
    tempReg4.Name = "null" tempReg4.UnitType = "PreussischerHusaren" tempReg4.UnitTypeName = "PreussischerHusaren"

    brigade6Names = { tempReg1, tempReg2, tempReg3, tempReg4 }


    Brigade6 = Brigade.New("Bavarian Brigade",brigade1Names,"Germany","Infantry",Vector.New(22525,2125),"Summer")
    Brigade7 = Brigade.New("Baden-Wuerttemburg Brigade",brigade2Names,"Germany","Infantry",Vector.New(30600,11050),"Summer")
    Brigade8 = Brigade.New("Prussian-Hessian Brigade",brigade3Names,"Germany","Infantry",Vector.New(26350,19125),"Summer")
    Brigade9 = Brigade.New("Artillery Brigade",brigade5Names,"Germany","Artillery",Vector.New(28500,7650),"Summer")
    Brigade10 = Brigade.New("Cavalry Brigade",brigade6Names,"Germany","Cavalry",Vector.New(26350,7650),"Summer")

    local GermanArmy = { Brigade6,Brigade7,Brigade8,Brigade9,Brigade10 }



    ---/// ############ ///---
    ---/// LOAD THE MAP ///---
    ---/// ############ ///---

    MapController.LoadMap( mapName )

    FogWidth = FogDivisions+2--math.ceil(  CurrentMapSize.X / FogDivisions  )
    FogHeight = FogDivisions+2--math.ceil( CurrentMapSize.Y / FogDivisions )
    FogTiles = { }

    print("X,Y  =  "..FogWidth..","..FogHeight)

    for y=1,FogHeight,1 do
        table.insert(FogTiles, {})
        for x=1,FogWidth,1 do
            table.insert(FogTiles[y], false)
        end
    end

    FogofWar.init(FogWidth, FogHeight, FogDivisions)

    print("Loaded Fog Map")

    -- for the users team, which is GERMANY --
    --for i=1,#GermanArmy,1 do GermanArmy[i]:ScoutMap( true ) end

    return GermanArmy, FrenchArmy 

end	

return maprules