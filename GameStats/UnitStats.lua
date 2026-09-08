
-----///// LIBRARY : UNIT STATISTICS /////-----
UnitStats  = {}


-----///// GENERIC STATS FOR ALL UNITS ////-----

-- Km = 4250 --
InfantryRange = 1600
JaegerRange = 2000
CavalryRange = 300
ArtilleryRange = 5500


--------//////// GERMAN UNITS -- GERMAN UNITS -- GERMAN UNITS ////////--------
UnitStats.GermanUnits = {}


----//// INFANTRY -- INFANTRY -- INFANTRY ////----
---/// PRUSSIAN LINE INFANTRY ///---
UnitStats.GermanUnits.PrussianLineInfantry = {}
UnitStats.GermanUnits.PrussianLineInfantry.Health = 100
UnitStats.GermanUnits.PrussianLineInfantry.Damage = 1
UnitStats.GermanUnits.PrussianLineInfantry.Accuracy = 5/10
UnitStats.GermanUnits.PrussianLineInfantry.MaxRange = 2600
UnitStats.GermanUnits.PrussianLineInfantry.FireRate = 5 -- 1 / X chance to fire --
UnitStats.GermanUnits.PrussianLineInfantry.MarchSpeed = 6
UnitStats.GermanUnits.PrussianLineInfantry.Morale = 60
UnitStats.GermanUnits.PrussianLineInfantry.Energy = 100
UnitStats.GermanUnits.PrussianLineInfantry.ChargeEnabled = true
UnitStats.GermanUnits.PrussianLineInfantry.Actions = {"Move","Double","Wheel","Target","Charge"}
UnitStats.GermanUnits.PrussianLineInfantry.Formations = {"BattleLine","MarchingColumn","SkirmishOrder"}
function UnitStats.GermanUnits.PrussianLineInfantry.AccuracyFunction(magnitude, unitrange, enemyFormationBonus)
    local f = math.floor( ( ( 5 / unitrange ) * magnitude ) + 1 )
    local ran = math.random(1, math.ceil( f * enemyFormationBonus ) )
    if ran == 1 then return true
    else return false end
end



---/// HESSIAN LINE INFANTRY ///---
UnitStats.GermanUnits.HessianLineInfantry = {}
UnitStats.GermanUnits.HessianLineInfantry.Health = 100
UnitStats.GermanUnits.HessianLineInfantry.Damage = 1
UnitStats.GermanUnits.HessianLineInfantry.Accuracy = 5/10
UnitStats.GermanUnits.HessianLineInfantry.MaxRange = 2600
UnitStats.GermanUnits.HessianLineInfantry.FireRate = 5 -- 1 / X chance to fire --
UnitStats.GermanUnits.HessianLineInfantry.MarchSpeed = 6
UnitStats.GermanUnits.HessianLineInfantry.Morale = 60
UnitStats.GermanUnits.HessianLineInfantry.Energy = 100
UnitStats.GermanUnits.HessianLineInfantry.ChargeEnabled = true
UnitStats.GermanUnits.HessianLineInfantry.Actions = {"Move","Double","Wheel","Target","Charge"}
UnitStats.GermanUnits.HessianLineInfantry.Formations = {"BattleLine","MarchingColumn","SkirmishOrder"}
function UnitStats.GermanUnits.HessianLineInfantry.AccuracyFunction(magnitude, unitrange, enemyFormationBonus)
    local f = math.floor( ( ( 5 / unitrange ) * magnitude ) + 1 )
    local ran = math.random(1, math.ceil( f * enemyFormationBonus ) )
    if ran == 1 then return true
    else return false end
end

---/// SAXON LINE INFANTRY ///---
UnitStats.GermanUnits.SaxonLineInfantry = {}
UnitStats.GermanUnits.SaxonLineInfantry.Health = 100
UnitStats.GermanUnits.SaxonLineInfantry.Damage = 1
UnitStats.GermanUnits.SaxonLineInfantry.Accuracy = 5/10
UnitStats.GermanUnits.SaxonLineInfantry.MaxRange = 2600
UnitStats.GermanUnits.SaxonLineInfantry.FireRate = 5 -- 1 / X chance to fire --
UnitStats.GermanUnits.SaxonLineInfantry.MarchSpeed = 6
UnitStats.GermanUnits.SaxonLineInfantry.Morale = 60
UnitStats.GermanUnits.SaxonLineInfantry.Energy = 100
UnitStats.GermanUnits.SaxonLineInfantry.ChargeEnabled = true
UnitStats.GermanUnits.SaxonLineInfantry.Actions = {"Move","Double","Wheel","Target","Charge"}
UnitStats.GermanUnits.SaxonLineInfantry.Formations = {"BattleLine","MarchingColumn","SkirmishOrder"}
function UnitStats.GermanUnits.SaxonLineInfantry.AccuracyFunction(magnitude, unitrange, enemyFormationBonus)
    local f = math.floor( ( ( 5 / unitrange ) * magnitude ) + 1 )
    local ran = math.random(1, math.ceil( f * enemyFormationBonus ) )
    if ran == 1 then return true
    else return false end
end

---/// BADEN LINE INFANTRY ///---
UnitStats.GermanUnits.BadenLineInfantry = {}
UnitStats.GermanUnits.BadenLineInfantry.Health = 100
UnitStats.GermanUnits.BadenLineInfantry.Damage = 1
UnitStats.GermanUnits.BadenLineInfantry.Accuracy = 5/10
UnitStats.GermanUnits.BadenLineInfantry.MaxRange = 2600
UnitStats.GermanUnits.BadenLineInfantry.FireRate = 5 -- 1 / X chance to fire --
UnitStats.GermanUnits.BadenLineInfantry.MarchSpeed = 6
UnitStats.GermanUnits.BadenLineInfantry.Morale = 60
UnitStats.GermanUnits.BadenLineInfantry.Energy = 100
UnitStats.GermanUnits.BadenLineInfantry.ChargeEnabled = true
UnitStats.GermanUnits.BadenLineInfantry.Actions = {"Move","Double","Wheel","Target","Charge"}
UnitStats.GermanUnits.BadenLineInfantry.Formations = {"BattleLine","MarchingColumn","SkirmishOrder"}
function UnitStats.GermanUnits.BadenLineInfantry.AccuracyFunction(magnitude, unitrange, enemyFormationBonus)
    local f = math.floor( ( ( 5 / unitrange ) * magnitude ) + 1 )
    local ran = math.random(1, math.ceil( f * enemyFormationBonus ) )
    if ran == 1 then return true
    else return false end
end


---/// WUERTEMMBURG LINE INFANTRY ///---
UnitStats.GermanUnits.WuerttemburgLineInfantry = {}
UnitStats.GermanUnits.WuerttemburgLineInfantry.Health = 100
UnitStats.GermanUnits.WuerttemburgLineInfantry.Damage = 1
UnitStats.GermanUnits.WuerttemburgLineInfantry.Accuracy = 5/10
UnitStats.GermanUnits.WuerttemburgLineInfantry.MaxRange = 2600
UnitStats.GermanUnits.WuerttemburgLineInfantry.FireRate = 5 -- 1 / X chance to fire --
UnitStats.GermanUnits.WuerttemburgLineInfantry.MarchSpeed = 6
UnitStats.GermanUnits.WuerttemburgLineInfantry.Morale = 60
UnitStats.GermanUnits.WuerttemburgLineInfantry.Energy = 100
UnitStats.GermanUnits.WuerttemburgLineInfantry.ChargeEnabled = true
UnitStats.GermanUnits.WuerttemburgLineInfantry.Actions = {"Move","Double","Wheel","Target","Charge"}
UnitStats.GermanUnits.WuerttemburgLineInfantry.Formations = {"BattleLine","MarchingColumn","SkirmishOrder"}
function UnitStats.GermanUnits.WuerttemburgLineInfantry.AccuracyFunction(magnitude, unitrange, enemyFormationBonus)
    local f = math.floor( ( ( 5 / unitrange ) * magnitude ) + 1 )
    local ran = math.random(1, math.ceil( f * enemyFormationBonus ) )
    if ran == 1 then return true
    else return false end
end

---/// PRUSSIAN GARDE ZU FUSS ///---
UnitStats.GermanUnits.PrussianGuards = {}
UnitStats.GermanUnits.PrussianGuards.Health = 120
UnitStats.GermanUnits.PrussianGuards.Damage = 1
UnitStats.GermanUnits.PrussianGuards.Accuracy = 5/10
UnitStats.GermanUnits.PrussianGuards.MaxRange = 2800
UnitStats.GermanUnits.PrussianGuards.FireRate = 5 -- 1 / X chance to fire --
UnitStats.GermanUnits.PrussianGuards.MarchSpeed = 7
UnitStats.GermanUnits.PrussianGuards.Morale = 95
UnitStats.GermanUnits.PrussianGuards.Energy = 100
UnitStats.GermanUnits.PrussianGuards.ChargeEnabled = true
UnitStats.GermanUnits.PrussianGuards.Actions = {"Move","Double","Wheel","Target","Charge"}
UnitStats.GermanUnits.PrussianGuards.Formations = {"BattleLine","MarchingColumn","SkirmishOrder"}
function UnitStats.GermanUnits.PrussianGuards.AccuracyFunction(magnitude, unitrange, enemyFormationBonus)
    local f = math.floor( ( ( 5 / unitrange ) * magnitude ) + 1 )
    local ran = math.random(1, math.ceil( f * enemyFormationBonus ) )
    if ran == 1 then return true
    else return false end
end


---/// PRUSSIAN JAEGERS ///---
UnitStats.GermanUnits.PrussianJaegers = {}
UnitStats.GermanUnits.PrussianJaegers.Health = 100
UnitStats.GermanUnits.PrussianJaegers.Damage = 1
UnitStats.GermanUnits.PrussianJaegers.Accuracy = 5/10
UnitStats.GermanUnits.PrussianJaegers.MaxRange = 4250
UnitStats.GermanUnits.PrussianJaegers.FireRate = 5 -- 1 / X chance to fire --
UnitStats.GermanUnits.PrussianJaegers.MarchSpeed = 10
UnitStats.GermanUnits.PrussianJaegers.Morale = 80
UnitStats.GermanUnits.PrussianJaegers.Energy = 100
UnitStats.GermanUnits.PrussianJaegers.ChargeEnabled = true
UnitStats.GermanUnits.PrussianJaegers.Actions = {"Move","Double","Wheel","Target","Charge"}
UnitStats.GermanUnits.PrussianJaegers.Formations = {"BattleLine","MarchingColumn","SkirmishOrder"}
function UnitStats.GermanUnits.PrussianJaegers.AccuracyFunction(magnitude, unitrange, enemyFormationBonus)
    local f = math.floor( ( ( 5 / unitrange ) * magnitude ) + 1 )
    local ran = math.random(1, math.ceil( f * enemyFormationBonus ) )
    if ran == 1 then return true
    else return false end
end

---/// LANDWEHR LINE INFANTRY ///---
UnitStats.GermanUnits.Landwehr = {}
UnitStats.GermanUnits.Landwehr.Health = 90
UnitStats.GermanUnits.Landwehr.Damage = 1
UnitStats.GermanUnits.Landwehr.Accuracy = 4/10
UnitStats.GermanUnits.Landwehr.MaxRange = 2200
UnitStats.GermanUnits.Landwehr.FireRate = 5 -- 1 / X chance to fire --
UnitStats.GermanUnits.Landwehr.MarchSpeed = 5
UnitStats.GermanUnits.Landwehr.Morale = 50
UnitStats.GermanUnits.Landwehr.Energy = 100
UnitStats.GermanUnits.Landwehr.ChargeEnabled = true
UnitStats.GermanUnits.Landwehr.Actions = {"Move","Double","Wheel","Target","Charge"}
UnitStats.GermanUnits.Landwehr.Formations = {"BattleLine","MarchingColumn","SkirmishOrder"}
function UnitStats.GermanUnits.Landwehr.AccuracyFunction(magnitude, unitrange, enemyFormationBonus)
    local f = math.floor( ( ( 5 / unitrange ) * magnitude ) + 1 )
    local ran = math.random(1, math.ceil( f * enemyFormationBonus ) )
    if ran == 1 then return true
    else return false end
end


---/// BAYERISCHER LINE INFANTRY ///---
UnitStats.GermanUnits.BayerischerLineInfantry = {}
UnitStats.GermanUnits.BayerischerLineInfantry.Health = 100
UnitStats.GermanUnits.BayerischerLineInfantry.Damage = 1
UnitStats.GermanUnits.BayerischerLineInfantry.Accuracy = 5/10
UnitStats.GermanUnits.BayerischerLineInfantry.MaxRange = 3800
UnitStats.GermanUnits.BayerischerLineInfantry.FireRate = 5 -- 1 / X chance to fire --
UnitStats.GermanUnits.BayerischerLineInfantry.MarchSpeed = 6
UnitStats.GermanUnits.BayerischerLineInfantry.Morale = 60
UnitStats.GermanUnits.BayerischerLineInfantry.Energy = 100
UnitStats.GermanUnits.BayerischerLineInfantry.ChargeEnabled = true
UnitStats.GermanUnits.BayerischerLineInfantry.Actions = {"Move","Double","Wheel","Target","Charge"}
UnitStats.GermanUnits.BayerischerLineInfantry.Formations = {"BattleLine","MarchingColumn","SkirmishOrder"}
function UnitStats.GermanUnits.BayerischerLineInfantry.AccuracyFunction(magnitude, unitrange, enemyFormationBonus)
    local f = math.floor( ( ( 5 / unitrange ) * magnitude ) + 1 )
    local ran = math.random(1, math.ceil( f * enemyFormationBonus ) )
    if ran == 1 then return true
    else return false end
end



----//// CAVALRY -- CAVALRY -- CAVALRY ////----
---/// PRUSSIAN UHLANEN ///---
UnitStats.GermanUnits.Uhlanen = {}
UnitStats.GermanUnits.Uhlanen.Health = 80
UnitStats.GermanUnits.Uhlanen.Damage = 5
UnitStats.GermanUnits.Uhlanen.Accuracy = 8/10
UnitStats.GermanUnits.Uhlanen.MaxRange = 200
UnitStats.GermanUnits.Uhlanen.FireRate = 5 -- 1 / X chance to fire --
UnitStats.GermanUnits.Uhlanen.MarchSpeed = 16
UnitStats.GermanUnits.Uhlanen.Morale = 60
UnitStats.GermanUnits.Uhlanen.Energy = 100
UnitStats.GermanUnits.Uhlanen.ChargeEnabled = true
UnitStats.GermanUnits.Uhlanen.Actions = {"Move","Double","Wheel","Charge"}
UnitStats.GermanUnits.Uhlanen.Formations = {"BattleLine","MarchingColumn"}
function UnitStats.GermanUnits.Uhlanen.AccuracyFunction(magnitude, unitrange, enemyFormationBonus)
    local f = 1
    local ran = math.random(1, math.ceil( f * enemyFormationBonus ) )
    if ran == 1 then return true
    else return false end
end

---/// PRUSSIAN HUSAREN ///---
UnitStats.GermanUnits.Husaren = {}
UnitStats.GermanUnits.Husaren.Health = 80
UnitStats.GermanUnits.Husaren.Damage = 5
UnitStats.GermanUnits.Husaren.Accuracy = 8/10
UnitStats.GermanUnits.Husaren.MaxRange = 200
UnitStats.GermanUnits.Husaren.FireRate = 5 -- 1 / X chance to fire --
UnitStats.GermanUnits.Husaren.MarchSpeed = 16
UnitStats.GermanUnits.Husaren.Morale = 60
UnitStats.GermanUnits.Husaren.Energy = 100
UnitStats.GermanUnits.Husaren.ChargeEnabled = true
UnitStats.GermanUnits.Husaren.Actions = {"Move","Double","Wheel","Charge"}
UnitStats.GermanUnits.Husaren.Formations = {"BattleLine","MarchingColumn"}
function UnitStats.GermanUnits.Husaren.AccuracyFunction(magnitude, unitrange, enemyFormationBonus)
    local f = 1
    local ran = math.random(1, math.ceil( f * enemyFormationBonus ) )
    if ran == 1 then return true
    else return false end
end

---/// PRUSSIAN KUERASSIERE ///---
UnitStats.GermanUnits.Kuerassiere = {}
UnitStats.GermanUnits.Kuerassiere.Health = 80
UnitStats.GermanUnits.Kuerassiere.Damage = 5
UnitStats.GermanUnits.Kuerassiere.Accuracy = 8/10
UnitStats.GermanUnits.Kuerassiere.MaxRange = 200
UnitStats.GermanUnits.Kuerassiere.FireRate = 5 -- 1 / X chance to fire --
UnitStats.GermanUnits.Kuerassiere.MarchSpeed = 16
UnitStats.GermanUnits.Kuerassiere.Morale = 60
UnitStats.GermanUnits.Kuerassiere.Energy = 100
UnitStats.GermanUnits.Kuerassiere.ChargeEnabled = true
UnitStats.GermanUnits.Kuerassiere.Actions = {"Move","Double","Wheel","Charge"}
UnitStats.GermanUnits.Kuerassiere.Formations = {"BattleLine","MarchingColumn"}
function UnitStats.GermanUnits.Kuerassiere.AccuracyFunction(magnitude, unitrange, enemyFormationBonus)
    local f = 1
    local ran = math.random(1, math.ceil( f * enemyFormationBonus ) )
    if ran == 1 then return true
    else return false end
end


--[[
---/// PRUSSIAN DRAGOONS ///---
UnitStats.GermanUnits.Dragoons = {}
UnitStats.GermanUnits.Dragoons.Health = 80
UnitStats.GermanUnits.Dragoons.Damage = 3
UnitStats.GermanUnits.Dragoons.Accuracy = 5/10
UnitStats.GermanUnits.Dragoons.MarchSpeed = 14
UnitStats.GermanUnits.Dragoons.Morale = 80
UnitStats.GermanUnits.Dragoons.Energy = 100
UnitStats.GermanUnits.Dragoons.ChargeEnabled = false
UnitStats.GermanUnits.Dragoons.Actions = {"Move","Double","Wheel"}
UnitStats.GermanUnits.Dragoons.Formations = {"Mounted","Dismounted"}

UnitStats.GermanUnits.DismountedDragoons = {}
UnitStats.GermanUnits.DismountedDragoons.Health = 80
UnitStats.GermanUnits.DismountedDragoons.Damage = 2
UnitStats.GermanUnits.DismountedDragoons.Accuracy = 5/10
UnitStats.GermanUnits.DismountedDragoons.MarchSpeed = 6
UnitStats.GermanUnits.DismountedDragoons.Morale = 80
UnitStats.GermanUnits.DismountedDragoons.Energy = 100
UnitStats.GermanUnits.DismountedDragoons.ChargeEnabled = true
UnitStats.GermanUnits.DismountedDragoons.Actions = {"Move","Wheel"}
UnitStats.GermanUnits.DismountedDragoons.Formations = {"Mounted","Dismounted"}
]]


----//// ARTILLERY -- ARTILLERY -- ARTILLERY ////----
---/// PRUSSIAN ARTILLERY ///---
UnitStats.GermanUnits.Artillery = {}
UnitStats.GermanUnits.Artillery.Health = 80
UnitStats.GermanUnits.Artillery.Damage = 10
UnitStats.GermanUnits.Artillery.Accuracy = 5/10
UnitStats.GermanUnits.Artillery.MaxRange = 9000
UnitStats.GermanUnits.Artillery.FireRate = 35 -- 1 / X chance to fire --
UnitStats.GermanUnits.Artillery.MarchSpeed = 6
UnitStats.GermanUnits.Artillery.Morale = 80
UnitStats.GermanUnits.Artillery.Energy = 100
UnitStats.GermanUnits.Artillery.ChargeEnabled = false
UnitStats.GermanUnits.Artillery.Actions = {"Move","Wheel","Target"}
UnitStats.GermanUnits.Artillery.Formations = {"FiringLine","MarchingColumn"}
function UnitStats.GermanUnits.Artillery.AccuracyFunction(magnitude, unitrange, enemyFormationBonus)
    local f = math.floor( ( ( 5 / unitrange ) * magnitude ) + 1 )
    local ran = math.random(1, math.ceil( f * enemyFormationBonus ) )
    if ran == 1 then return true
    else return false end
end











--------//////// FRENCH UNITS -- FRENCH UNITS -- FRENCH UNITS ////////--------
UnitStats.FrenchUnits = {}


----//// INFANTRY -- INFANTRY -- INFANTRY ////----
---/// FRENCH LINE INFANTRY ///---
UnitStats.FrenchUnits.FrenchLineInfantry = {}
UnitStats.FrenchUnits.FrenchLineInfantry.Health = 100
UnitStats.FrenchUnits.FrenchLineInfantry.Damage = 1
UnitStats.FrenchUnits.FrenchLineInfantry.Accuracy = 5/10
UnitStats.FrenchUnits.FrenchLineInfantry.MaxRange = 3900
UnitStats.FrenchUnits.FrenchLineInfantry.FireRate = 5 -- 1 / X chance to fire --
UnitStats.FrenchUnits.FrenchLineInfantry.MarchSpeed = 6
UnitStats.FrenchUnits.FrenchLineInfantry.Morale = 60
UnitStats.FrenchUnits.FrenchLineInfantry.Energy = 100
UnitStats.FrenchUnits.FrenchLineInfantry.ChargeEnabled = true
UnitStats.FrenchUnits.FrenchLineInfantry.Actions = {"Move","Double","Wheel","Target","Charge"}
UnitStats.FrenchUnits.FrenchLineInfantry.Formations = {"BattleLine","MarchingColumn","SkirmishOrder"}
function UnitStats.FrenchUnits.FrenchLineInfantry.AccuracyFunction(magnitude, unitrange, enemyFormationBonus)
    local f = math.floor( ( ( 5 / unitrange ) * magnitude ) + 1 )
    local ran = math.random(1, math.ceil( f * enemyFormationBonus ) )
    if ran == 1 then return true
    else return false end
end

---/// FRENCH ZOUAVES ///---
UnitStats.FrenchUnits.FrenchZouaves = {}
UnitStats.FrenchUnits.FrenchZouaves.Health = 100
UnitStats.FrenchUnits.FrenchZouaves.Damage = 1
UnitStats.FrenchUnits.FrenchZouaves.Accuracy = 5/10
UnitStats.FrenchUnits.FrenchZouaves.MaxRange = 4000
UnitStats.FrenchUnits.FrenchZouaves.FireRate = 5 -- 1 / X chance to fire --
UnitStats.FrenchUnits.FrenchZouaves.MarchSpeed = 6
UnitStats.FrenchUnits.FrenchZouaves.Morale = 65
UnitStats.FrenchUnits.FrenchZouaves.Energy = 100
UnitStats.FrenchUnits.FrenchZouaves.ChargeEnabled = true
UnitStats.FrenchUnits.FrenchZouaves.Actions = {"Move","Double","Wheel","Target","Charge"}
UnitStats.FrenchUnits.FrenchZouaves.Formations = {"BattleLine","MarchingColumn","SkirmishOrder"}
function UnitStats.FrenchUnits.FrenchZouaves.AccuracyFunction(magnitude, unitrange, enemyFormationBonus)
    local f = math.floor( ( ( 5 / unitrange ) * magnitude ) + 1 )
    local ran = math.random(1, math.ceil( f * enemyFormationBonus ) )
    if ran == 1 then return true
    else return false end
end

---/// FRENCH CHASSEURS ///---
UnitStats.FrenchUnits.FrenchChasseurs = {}
UnitStats.FrenchUnits.FrenchChasseurs.Health = 100
UnitStats.FrenchUnits.FrenchChasseurs.Damage = 1
UnitStats.FrenchUnits.FrenchChasseurs.Accuracy = 5/10
UnitStats.FrenchUnits.FrenchChasseurs.MaxRange = 4250
UnitStats.FrenchUnits.FrenchChasseurs.FireRate = 5 -- 1 / X chance to fire --
UnitStats.FrenchUnits.FrenchChasseurs.MarchSpeed = 9
UnitStats.FrenchUnits.FrenchChasseurs.Morale = 70
UnitStats.FrenchUnits.FrenchChasseurs.Energy = 100
UnitStats.FrenchUnits.FrenchChasseurs.ChargeEnabled = true
UnitStats.FrenchUnits.FrenchChasseurs.Actions = {"Move","Double","Wheel","Target","Charge"}
UnitStats.FrenchUnits.FrenchChasseurs.Formations = {"BattleLine","MarchingColumn","SkirmishOrder"}
function UnitStats.FrenchUnits.FrenchChasseurs.AccuracyFunction(magnitude, unitrange, enemyFormationBonus)
    local f = math.floor( ( ( 5 / unitrange ) * magnitude ) + 1 )
    local ran = math.random(1, math.ceil( f * enemyFormationBonus ) )
    if ran == 1 then return true
    else return false end
end


----//// ARTILLERY -- ARTILLERY -- ARTILLERY ////----
---/// FRENCH ARTILLERY ///---
UnitStats.FrenchUnits.Artillery = {}
UnitStats.FrenchUnits.Artillery.Health = 80
UnitStats.FrenchUnits.Artillery.Damage = 10
UnitStats.FrenchUnits.Artillery.Accuracy = 5/10
UnitStats.FrenchUnits.Artillery.MaxRange = 9000
UnitStats.FrenchUnits.Artillery.FireRate = 35 -- 1 / X chance to fire --
UnitStats.FrenchUnits.Artillery.MarchSpeed = 6
UnitStats.FrenchUnits.Artillery.Morale = 80
UnitStats.FrenchUnits.Artillery.Energy = 100
UnitStats.FrenchUnits.Artillery.ChargeEnabled = false
UnitStats.FrenchUnits.Artillery.Actions = {"Move","Wheel","Target"}
UnitStats.FrenchUnits.Artillery.Formations = {"FiringLine","MarchingColumn"}
function UnitStats.FrenchUnits.Artillery.AccuracyFunction(magnitude, unitrange, enemyFormationBonus)
    local f = math.floor( ( ( 5 / unitrange ) * magnitude ) + 1 )
    local ran = math.random(1, math.ceil( f * enemyFormationBonus ) )
    if ran == 1 then return true
    else return false end
end

return UnitStats

