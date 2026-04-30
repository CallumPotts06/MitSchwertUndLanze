maprules = {}

function maprules.LaunchBattle()


    local mapName = "Maps/Wissembourg.map"

    --load squads for gameplay--
    Squad.LoadAllSquads()

    ---/// ############ ///---
    ---/// FRENCH UNITS ///---
    ---/// ############ ///---

    local tempReg1 = {} local tempReg2 = {} local tempReg3 = {} local tempReg4 = {}
    tempReg1.Name = "1er Regiment De Ligne" tempReg1.UnitType = "FrenchLineInfantry" tempReg1.UnitTypeName = "FrenchLineInfantry"
    tempReg2.Name = "2er Regiment De Ligne" tempReg2.UnitType = "FrenchLineInfantry" tempReg2.UnitTypeName = "FrenchLineInfantry"
    tempReg3.Name = "3er Regiment De Ligne" tempReg3.UnitType = "FrenchLineInfantry" tempReg3.UnitTypeName = "FrenchLineInfantry"
    tempReg4.Name = "3er Regiment De Ligne" tempReg4.UnitType = "FrenchLineInfantry" tempReg4.UnitTypeName = "FrenchLineInfantry"

    brigade1Names = { tempReg1, tempReg2, tempReg3, tempReg4 }

    Brigade1 = Brigade.New("1st Brigade",brigade1Names,"France","Infantry",Vector.New(6000,6000),"Summer")
    Brigade2 = Brigade.New("2nd Brigade",brigade1Names,"France","Infantry",Vector.New(9000,8800),"Summer")
    Brigade3 = Brigade.New("3rd Brigade",brigade1Names,"France","Infantry",Vector.New(9000,13000),"Summer")
    Brigade4 = Brigade.New("4th Brigade",brigade1Names,"France","Infantry",Vector.New(9900,16800),"Summer")
    Brigade5 = Brigade.New("Artillery Brigade",brigade1Names,"France","Infantry",Vector.New(8750,13000),"Summer")

    local FrenchArmy = { Brigade1, Brigade2, Brigade3, Brigade4 }

    ---/// ############ ///---
    ---/// GERMAN UNITS ///---
    ---/// ############ ///---

    local tempReg1 = {} local tempReg2 = {} local tempReg3 = {} local tempReg4 = {}
    tempReg1.Name = "1st Bavarian Regiment" tempReg1.UnitType = "BayerischerLineninfanterie" tempReg1.UnitTypeName = "BayerischerLineninfanterie"
    tempReg2.Name = "2nd Bavarian Regiment" tempReg2.UnitType = "BayerischerLineninfanterie" tempReg2.UnitTypeName = "BayerischerLineninfanterie"
    tempReg3.Name = "3rd Bavarian Regiment" tempReg3.UnitType = "BayerischerLineninfanterie" tempReg3.UnitTypeName = "BayerischerLineninfanterie"
    tempReg4.Name = "4th Bavarian Regiment" tempReg4.UnitType = "BayerischerLineninfanterie" tempReg4.UnitTypeName = "BayerischerLineninfanterie"

    brigade1Names = { tempReg1, tempReg2, tempReg3, tempReg4 }

    tempReg1.Name = "1st Regiment of Foot" tempReg1.UnitType = "DeutscherLineninfanterie" tempReg1.UnitTypeName = "PreussischerLineninfanterie"
    tempReg2.Name = "2nd Regiment of Foot" tempReg2.UnitType = "DeutscherLineninfanterie" tempReg2.UnitTypeName = "PreussischerLineninfanterie"
    tempReg3.Name = "3rd Regiment of Foot" tempReg3.UnitType = "DeutscherLineninfanterie" tempReg3.UnitTypeName = "PreussischerLineninfanterie"
    tempReg4.Name = "4th Regiment of Foot" tempReg4.UnitType = "DeutscherLineninfanterie" tempReg4.UnitTypeName = "PreussischerLineninfanterie"

    brigade2Names = { tempReg1, tempReg2, tempReg3, tempReg4 }

    tempReg1.Name = "5th Regiment of Foot" tempReg1.UnitType = "DeutscherLineninfanterie" tempReg1.UnitTypeName = "PreussischerLineninfanterie"
    tempReg2.Name = "6th Regiment of Foot" tempReg2.UnitType = "DeutscherLineninfanterie" tempReg2.UnitTypeName = "PreussischerLineninfanterie"
    tempReg3.Name = "7th Regiment of Foot" tempReg3.UnitType = "DeutscherLineninfanterie" tempReg3.UnitTypeName = "PreussischerLineninfanterie"
    tempReg4.Name = "8th Regiment of Foot" tempReg4.UnitType = "DeutscherLineninfanterie" tempReg4.UnitTypeName = "PreussischerLineninfanterie"

    
    brigade3Names = { tempReg1, tempReg2, tempReg3, tempReg4 }

    tempReg1.Name = "9th Regiment of Foot" tempReg1.UnitType = "DeutscherLineninfanterie" tempReg1.UnitTypeName = "PreussischerLineninfanterie"
    tempReg2.Name = "10th Regiment of Foot" tempReg2.UnitType = "DeutscherLineninfanterie" tempReg2.UnitTypeName = "PreussischerLineninfanterie"
    tempReg3.Name = "11th Regiment of Foot" tempReg3.UnitType = "DeutscherLineninfanterie" tempReg3.UnitTypeName = "PreussischerLineninfanterie"
    tempReg4.Name = "12th Regiment of Foot" tempReg4.UnitType = "DeutscherLineninfanterie" tempReg4.UnitTypeName = "PreussischerLineninfanterie"

    brigade4Names = { tempReg1, tempReg2, tempReg3, tempReg4 }

    tempReg1.Name = "13th Artillery Regiment" tempReg1.UnitType = "DeutscherArtillerie" tempReg1.UnitTypeName = "PreussischerArtillerie"
    tempReg2.Name = "13th Artillery Regiment" tempReg2.UnitType = "DeutscherArtillerie" tempReg2.UnitTypeName = "PreussischerArtillerie"
    tempReg3.Name = "13th Artillery Regiment" tempReg3.UnitType = "DeutscherArtillerie" tempReg3.UnitTypeName = "PreussischerArtillerie"
    tempReg4.Name = "13th Artillery Regiment" tempReg4.UnitType = "DeutscherArtillerie" tempReg4.UnitTypeName = "PreussischerArtillerie"

    brigade5Names = { tempReg1, tempReg2, tempReg3, tempReg4 }

    tempReg1.Name = "14th Lancer Regiment" tempReg1.UnitType = "PreussischerUhlanen" tempReg1.UnitTypeName = "PreussischerUhlanen"
    tempReg2.Name = "15th Lancer Regiment" tempReg2.UnitType = "PreussischerUhlanen" tempReg2.UnitTypeName = "PreussischerUhlanen"
    tempReg3.Name = "16th Hussar Regiment" tempReg3.UnitType = "PreussischerHusaren" tempReg3.UnitTypeName = "PreussischerHusaren"
    tempReg4.Name = "17th Hussar Regiment" tempReg4.UnitType = "PreussischerHusaren" tempReg4.UnitTypeName = "PreussischerHusaren"

    brigade6Names = { tempReg1, tempReg2, tempReg3, tempReg4 }


    Brigade6 = Brigade.New("Bavarian Brigade",brigade1Names,"Germany","Infantry",Vector.New(18000,3300),"Summer")
    Brigade7 = Brigade.New("1st Brigade",brigade2Names,"Germany","Infantry",Vector.New(21200,8800),"Summer")
    Brigade8 = Brigade.New("2nd Brigade",brigade3Names,"Germany","Infantry",Vector.New(21200,11200),"Summer")
    Brigade9 = Brigade.New("3rd Brigade",brigade4Names,"Germany","Infantry",Vector.New(21200,15500),"Summer")
    Brigade10 = Brigade.New("Artillery Brigade",brigade5Names,"Germany","Artillery",Vector.New(21200,4300),"Summer")
    Brigade11 = Brigade.New("Cavalry Brigade",brigade6Names,"Germany","Cavalry",Vector.New(21200,4900),"Summer")

    local GermanArmy = {Brigade6,Brigade7,Brigade8,Brigade9,Brigade10,Brigade11}







    ---/// ############ ///---
    ---/// LOAD THE MAP ///---
    ---/// ############ ///---

    --MapController.LoadMap( mapName )


    return FrenchArmy, GermanArmy

end	

return maprules