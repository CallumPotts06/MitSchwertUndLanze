maprules = {}

function maprules.LaunchBattle()


    local mapName = "Maps/Wissembourg.map"

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
    tempReg1.Name = "2nd Div Artillery A." tempReg1.UnitType = "FrenchArtillery" tempReg1.UnitTypeName = "FrenchArtillery"
    tempReg2.Name = "2nd Div Artillery B." tempReg2.UnitType = "FrenchArtillery" tempReg2.UnitTypeName = "FrenchArtillery"
    tempReg3.Name = "2nd Div Mitrailleuse" tempReg3.UnitType = "FrenchArtillery" tempReg3.UnitTypeName = "FrenchArtillery"
    tempReg4.Name = "null" tempReg4.UnitType = "FrenchArtillery" tempReg4.UnitTypeName = "FrenchArtillery"

    brigade4Names = { tempReg1, tempReg2, tempReg3, tempReg4 }

    Brigade1 = Brigade.New("1st Brigade",brigade1Names,"France","Infantry",Vector.New(4900,1750),"Summer")
    Brigade2 = Brigade.New("2nd Brigade",brigade2Names,"France","Infantry",Vector.New(4900,5250),"Summer")
    Brigade3 = Brigade.New("4th Brigade",brigade3Names,"France","Infantry",Vector.New(4900,10500),"Summer")
    Brigade4 = Brigade.New("Artillery Brigade",brigade4Names,"France","Artillery",Vector.New(4000,7000),"Summer")

    local FrenchArmy = { Brigade1, Brigade2, Brigade3, Brigade4 }

    ---/// ############ ///---
    ---/// GERMAN UNITS ///---
    ---/// ############ ///---

    local tempReg1 = {} local tempReg2 = {} local tempReg3 = {} local tempReg4 = {}
    tempReg1.Name = "6th Bavarian Regiment" tempReg1.UnitType = "BayerischerLineninfanterie" tempReg1.UnitTypeName = "BayerischerLineninfanterie"
    tempReg2.Name = "7th Bavarian Regiment" tempReg2.UnitType = "BayerischerLineninfanterie" tempReg2.UnitTypeName = "BayerischerLineninfanterie"
    tempReg3.Name = "14th Bavarian Regiment" tempReg3.UnitType = "BayerischerLineninfanterie" tempReg3.UnitTypeName = "BayerischerLineninfanterie"
    tempReg4.Name = "15th Bavarian Regiment" tempReg4.UnitType = "BayerischerLineninfanterie" tempReg4.UnitTypeName = "BayerischerLineninfanterie"

    brigade1Names = { tempReg1, tempReg2, tempReg3, tempReg4 }

    local tempReg1 = {} local tempReg2 = {} local tempReg3 = {} local tempReg4 = {}
    tempReg1.Name = "3rd Baden Regiment" tempReg1.UnitType = "DeutscherLineninfanterie" tempReg1.UnitTypeName = "BadenLineninfanterie"
    tempReg2.Name = "4th Baden Regiment" tempReg2.UnitType = "DeutscherLineninfanterie" tempReg2.UnitTypeName = "BadenLineninfanterie"
    tempReg3.Name = "3rd Wuerttemburg Regiment" tempReg3.UnitType = "DeutscherLineninfanterie" tempReg3.UnitTypeName = "WuerttemburgLineninfanterie"
    tempReg4.Name = "5th Wuerttemburg Regiment" tempReg4.UnitType = "DeutscherLineninfanterie" tempReg4.UnitTypeName = "WuerttemburgLineninfanterie"

    brigade2Names = { tempReg1, tempReg2, tempReg3, tempReg4 }

    local tempReg1 = {} local tempReg2 = {} local tempReg3 = {} local tempReg4 = {}
    tempReg1.Name = "2nd Hessian Regiment" tempReg1.UnitType = "DeutscherLineninfanterie" tempReg1.UnitTypeName = "HessischLineninfanterie"
    tempReg4.Name = "Hessian Jaegers" tempReg2.UnitType = "DeutscherJaegers" tempReg2.UnitTypeName = "PreussischerJaegers"
    tempReg3.Name = "Hessian Fusiliers" tempReg3.UnitType = "DeutscherLineninfanterie" tempReg3.UnitTypeName = "HessischLineninfanterie"
    tempReg2.Name = "3rd Hessian Regiment" tempReg4.UnitType = "DeutscherLineninfanterie" tempReg4.UnitTypeName = "HessischLineninfanterie"

    
    brigade3Names = { tempReg1, tempReg2, tempReg3, tempReg4 }

    local tempReg1 = {} local tempReg2 = {} local tempReg3 = {} local tempReg4 = {}
    tempReg1.Name = "3rd Posen Regiment" tempReg1.UnitType = "DeutscherLineninfanterie" tempReg1.UnitTypeName = "PreussischerLineninfanterie"
    tempReg2.Name = "4th Posen Regiment" tempReg2.UnitType = "DeutscherLineninfanterie" tempReg2.UnitTypeName = "PreussischerLineninfanterie"
    tempReg3.Name = "Westphalian Fusilier" tempReg3.UnitType = "DeutscherLineninfanterie" tempReg3.UnitTypeName = "PreussischerLineninfanterie"
    tempReg4.Name = "Silesian Jaegers" tempReg4.UnitType = "DeutscherJaegers" tempReg4.UnitTypeName = "PreussischerJaegers"

    brigade4Names = { tempReg1, tempReg2, tempReg3, tempReg4 }

    local tempReg1 = {} local tempReg2 = {} local tempReg3 = {} local tempReg4 = {}
    tempReg1.Name = "5th Artillery Battery 1" tempReg1.UnitType = "DeutscherArtillerie" tempReg1.UnitTypeName = "PreussischerArtillerie"
    tempReg2.Name = "5th Artillery Battery 2" tempReg2.UnitType = "DeutscherArtillerie" tempReg2.UnitTypeName = "PreussischerArtillerie"
    tempReg3.Name = "5th Artillery Battery 3" tempReg3.UnitType = "DeutscherArtillerie" tempReg3.UnitTypeName = "PreussischerArtillerie"
    tempReg4.Name = "5th Artillery Battery 4" tempReg4.UnitType = "DeutscherArtillerie" tempReg4.UnitTypeName = "PreussischerArtillerie"

    brigade5Names = { tempReg1, tempReg2, tempReg3, tempReg4 }

    local tempReg1 = {} local tempReg2 = {} local tempReg3 = {} local tempReg4 = {}
    tempReg1.Name = "1st Bavarian Uhlan" tempReg1.UnitType = "PreussischerUhlanen" tempReg1.UnitTypeName = "PreussischerUhlanen"
    tempReg2.Name = "2nd Bavarian Uhlan" tempReg2.UnitType = "PreussischerUhlanen" tempReg2.UnitTypeName = "PreussischerUhlanen"
    tempReg3.Name = "1st Hessian Hussars" tempReg3.UnitType = "PreussischerHusaren" tempReg3.UnitTypeName = "PreussischerHusaren"
    tempReg4.Name = "2nd Hessian Hussars" tempReg4.UnitType = "PreussischerHusaren" tempReg4.UnitTypeName = "PreussischerHusaren"

    brigade6Names = { tempReg1, tempReg2, tempReg3, tempReg4 }


    Brigade6 = Brigade.New("Bavarian Brigade",brigade1Names,"Germany","Infantry",Vector.New(15750,1750),"Summer")
    Brigade7 = Brigade.New("Baden-Wuerttemburg Brigade",brigade2Names,"Germany","Infantry",Vector.New(15750,8750),"Summer")
    Brigade8 = Brigade.New("Hessian Brigade",brigade3Names,"Germany","Infantry",Vector.New(15750,12250),"Summer")
    Brigade9 = Brigade.New("Prussian Brigade",brigade4Names,"Germany","Infantry",Vector.New(15750,14000),"Summer")
    Brigade10 = Brigade.New("Artillery Brigade",brigade5Names,"Germany","Artillery",Vector.New(15750,4200),"Summer")
    Brigade11 = Brigade.New("Cavalry Brigade",brigade6Names,"Germany","Cavalry",Vector.New(15750,2000),"Summer")

    local GermanArmy = {Brigade6,Brigade7,Brigade8,Brigade9,Brigade10,Brigade11}







    ---/// ############ ///---
    ---/// LOAD THE MAP ///---
    ---/// ############ ///---

    MapController.LoadMap( mapName )


    return FrenchArmy, GermanArmy

end	

return maprules