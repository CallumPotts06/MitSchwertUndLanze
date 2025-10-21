
--[[ UNIT INFORMATION

Chain Of Command:
Army 1x
    Division Nx
        Brigade 3x
            Regiment 4x
                Battalion 3x <--

Unit: Battalion
Parent Unit: Regiment
Child Unit: N/A

Formation Types:
    Infantry:
        Battle Line (Close Order)
        Marching Column 
        Skirmish Line (Open Order)

        --the rally point for infantry will just be a battalion of battle line--
        Rally Point / Reserve (in relation to other battalions, will hold the colours for reserve)

    Artillery:
        Marching Column
        Deployed (Dismounted)
        Rally Point / Reserve (in relation to other battalions, will hold the colours for reserve)

    Cavalry: (Hussars / Lancers / Cuirassiers)
        Battle Line (Close Order)
        Marching Column

    Cavalry: (Dragoons)
        Marching Column
        Deployed (Dismounted)
        Rally Point / Reserve (in relation to other battalions, will hold the colours for reserve)

]]--

--// IMPORT UNIT STATISTICS //--
stats = require("../GameStats/UnitStats")


local function findStatsObject(team,unitType)
    local teamStats = nil
    local typeStats = nil

    --simple function that maps team and unit type to find the correct stats object--
    if team == "Germany" then
        teamStats = stats.GermanUnits

        if unitType == "PrussianLineInfantry" then typeStats = teamStats.PrussianLineInfantry end
        if unitType == "Landwehr" then typeStats = teamStats.Landwehr end

    end

    return typeStats
end


----//// CLASS : BATTALION ////----
Battalion = {}

--// CONSTRUCTOR //--
function Battalion.New(name,regiment,team,unitType,startPos)
    --create new empty object--
    local newBattalion = {}

    --add referential data--
    newBattalion.Name = name
    newBattalion.Regiment = regiment
    newBattalion.Team = team
    newBattalion.UnitType = unitType

    --add mathematical data--
    newBattalion.Position = startPos
    newBattalion.MoveObject = nil

    --add statistics from stats library--
    local currentStats = findStatsObject(team,unitType)
    newBattalion.Health = currentStats.Health
    newBattalion.Damage = currentStats.Damage
    newBattalion.Accuracy = currentStats.Accuracy
    newBattalion.MarchSpeed = currentStats.MarchSpeed
    newBattalion.Morale = currentStats.Morale
    newBattalion.ChargeEnabled = currentStats.ChargeEnabled

    --add appearance data--
    newBattalion.BattleLineSquad = nil
    newBattalion.BattleLineSquadFlag = nil
    newBattalion.MarchingSquad = nil
    newBattalion.MarchingSquadFlag = nil

    --add appearance data for skirmishing infantry and dismounted dragoons--
    newBattalion.OpenOrderSquad1 = nil
    newBattalion.OpenOrderSquad2 = nil
    newBattalion.OpenOrderSquad3 = nil

    --add appearance data for dragoon and artillery rally / reserve points--
    newBattalion.ReserveSquad = nil
    newBattalion.ReserveSquadFlag = nil

    --finish up the object--
    setmetatable(newBattalion,{__index=Battalion})--map the new table onto the Battalion class--
    return newBattalion--return the new object--
end

return Battalion

