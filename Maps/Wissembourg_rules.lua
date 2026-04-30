maprules = {}

function maprules.LaunchBattle()

    local mapName = "Maps/Wissembourg.map"

    ---/// ############ ///---
    ---/// FRENCH UNITS ///---
    ---/// ############ ///---

    local tempReg1 = {} local tempReg2 = {} local tempReg3 = {} local tempReg4 = {}
    tempReg1.Name = "1er Regiment De Ligne" tempReg1.UnitType = "FrenchLineInfantry" tempReg1.UnitTypeName = "FrenchLineInfantry"
    tempReg2.Name = "2er Regiment De Ligne" tempReg2.UnitType = "FrenchLineInfantry" tempReg2.UnitTypeName = "FrenchLineInfantry"
    tempReg3.Name = "3er Regiment De Ligne" tempReg3.UnitType = "FrenchLineInfantry" tempReg3.UnitTypeName = "FrenchLineInfantry"
    tempReg4.Name = "4er Regiment De Ligne" tempReg4.UnitType = "FrenchLineInfantry" tempReg4.UnitTypeName = "FrenchLineInfantry"

    brigade1Names = { tempReg1, tempReg2, tempReg3, tempReg4 }

    Brigade1 = Brigade.New("1st Brigade",brigade1Names,"France","Infantry",Vector.New(6000,6000),"Summer")
    Brigade2 = Brigade.New("2nd Brigade",brigade1Names,"France","Infantry",Vector.New(8800,8800),"Summer")
    Brigade3 = Brigade.New("3rd Brigade",brigade1Names,"France","Infantry",Vector.New(8800,12800),"Summer")
    Brigade4 = Brigade.New("4th Brigade",brigade1Names,"France","Infantry",Vector.New(9000,17600),"Summer")

    FrenchArmy = { Brigade1, Brigade2, Brigade3, Brigade4 }

    ---/// ############ ///---
    ---/// GERMAN UNITS ///---
    ---/// ############ ///---







    ---/// ############ ///---
    ---/// LOAD THE MAP ///---
    ---/// ############ ///---

    MapController.LoadMap( mapName )

end	

return maprules