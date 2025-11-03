
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
Stats = require("../GameStats/UnitStats")

--// IMPORT SQUAD LIBRARY //--
Squad = require("../Army/Squad")


local function findStatsObject(team,unitType)
    local teamStats = nil
    local typeStats = nil

    --simple function that maps team and unit type to find the correct stats object--
    if team == "Germany" then
        teamStats = Stats.GermanUnits

        if unitType == "PrussianLineInfantry" then typeStats = teamStats.PrussianLineInfantry end
        if unitType == "Landwehr" then typeStats = teamStats.Landwehr end
    end

    return typeStats
end


----//// CLASS : BATTALION ////----
Battalion = {}

--// SETUP METHODS //--
function LoadImagesOntoUnit(team,unittype)
    local nationSet = "none"
    local imgSet = "none"

    --find the necessary object for the relevant nation--
    if team=="Germany" then nationSet = Squad.ImageLibrary.GermanUnits end

    --find the branch of service related to unit type--
    if unittype=="Infantry" then imgSet = nationSet.Infantry
    elseif unittype=="Artillery" then imgSet = nationSet.Artillery
    else imgSet = nationSet.Cavalry end

    local newImages = {}
    newImages.Battleline = {}
    newImages.FiringLine = {}
    newImages.SkirmishOrder = {}
    newImages.MarchingColumn = {}
    newImages.Mounted = {}
    newImages.Dismounted = {}
    --look for images that apply to unit type and add them to anims table--
    for i=1,#imgSet,1 do
        if imgSet[i].UnitType==unittype then

            if imgSet[i].Formation=="BattleLine" then
                table.insert(newImages.Battleline,imgSet[i])
            elseif imgSet[i].Formation=="FiringLine" then
                table.insert(newImages.FiringLine,imgSet[i])
            elseif imgSet[i].Formation=="SkirmishOrder" then
                table.insert(newImages.SkirmishOrder,imgSet[i])
            elseif imgSet[i].Formation=="MarchingColumn" then
                table.insert(newImages.MarchingColumn,imgSet[i])
            elseif imgSet[i].Formation=="Mounted" then
                table.insert(newImages.Mounted,imgSet[i])
            elseif imgSet[i].Formation=="Dismounted" then
                table.insert(newImages.Dismounted,imgSet[i])
            end

        end
    end

    return newImages
end

--// CONSTRUCTOR //--
function Battalion.New(name,regiment,team,unitType,unitTypeName,startPos,season)
    --create new empty object--
    local newBattalion = {}

    --add referential data--
    newBattalion.Name = name
    newBattalion.Regiment = regiment
    newBattalion.Team = team
    newBattalion.UnitType = unitType
    newBattalion.UnitTypeName = unitTypeName

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
    newBattalion.Images = LoadImagesOntoUnit(team,unitType)


    --finish up the object--
    setmetatable(newBattalion,{__index=Battalion})--map the new table onto the Battalion class--
    return newBattalion--return the new object--
end




return Battalion

