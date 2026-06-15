--[[ UNIT INFORMATION

Chain Of Command:
Army 1x
    Division Nx
        Brigade 3x
            Regiment 4x <--
                Battalion 3x

Unit: Regiment
Parent Unit: Brigade
Child Unit: Battalion

Formation Types:
    Infantry:
        Battle Line (three battalions in battle line)
        Marching Column (three battalions in marching column)
        Skirmish Line (two battalions in skirmish order and colours battalion in reserve)

    Artillery:
        Deployed (three battalions in deployed formation)
        Marching Column (three battalions in marching column)

    Cavalry: (Hussars / Lancers / Cuirassiers)
        Battle Line (three battalions in battle line)
        Marching Column (three battalinos in marching column)

    Cavalry: (Dragoons)
        Deployed (two battalions in skirmish order and colour battalion in reserve)
        Marching Column (three battalions in marching column)
        
]]--

--// LOCAL FUNCTIONS //--
local function shortestAngle(from, to)
    local diff = (to - from + math.pi) % (2 * math.pi) - math.pi
    return diff
end

local function normalizeAngle(a)
    return (a + math.pi) % (2 * math.pi) - math.pi
end

local function findStatsObject(team,unitType)
    Stats = require("../GameStats/UnitStats")
    local teamStats = nil
    local typeStats = nil

    --simple function that maps team and unit type to find the correct stats object--
    if team == "Germany" then
        teamStats = Stats.GermanUnits
        if unitType == "PreussischerLineninfanterie" then typeStats = teamStats.PrussianLineInfantry end
        if unitType == "PreussischerGardeZuFuss" then typeStats = teamStats.PrussianGuards end
        if unitType == "PreussischerJaegers" then typeStats = teamStats.PrussianJaegers end
        if unitType == "PreussischerLandwehr" then typeStats = teamStats.Landwehr end
        if unitType == "PreussischerUhlanen" then typeStats = teamStats.Uhlanen end
        if unitType == "PreussischerHusaren" then typeStats = teamStats.Husaren end
        if unitType == "PreussischerKuerassiere" then typeStats = teamStats.Kuerassiere end
        if unitType == "PreussischerArtillerie" then typeStats = teamStats.Artillery end
        if unitType == "PreussischerDragoner" then typeStats = teamStats.Dragoons end
        if unitType == "BayerischerLineninfanterie" then typeStats = teamStats.BayerischerLineInfantry end
        if unitType == "HessischLineninfanterie" then typeStats = teamStats.HessianLineInfantry end
        if unitType == "BadenLineninfanterie" then typeStats = teamStats.BadenLineInfantry end
        if unitType == "SaechsischLineninfanterie" then typeStats = teamStats.SaxonLineInfantry end
        if unitType == "WuerttemburgLineninfanterie" then typeStats = teamStats.WuerttemburgLineInfantry end
    end

    if team == "France" then
        teamStats = Stats.FrenchUnits
        if unitType == "FrenchLineInfantry" then typeStats = teamStats.FrenchLineInfantry end
        if unitType == "FrenchZouaves" then typeStats = teamStats.FrenchZouaves end
        if unitType == "FrenchChasseurs" then typeStats = teamStats.FrenchChasseurs end
        if unitType == "FrenchArtillery" then typeStats = teamStats.Artillery end
    end

    return typeStats
end

Regiment = {}

BattalionMargins = {}

-- INFANTRY MARGINS --
BattalionMargins.Infantry = {}
BattalionMargins.Infantry.MarchingColumn = 185
BattalionMargins.Infantry.BattleLine = 315
BattalionMargins.Infantry.SkirmishOrder = 700

-- CAVALRY MARGINS --
BattalionMargins.Cavalry = {}
BattalionMargins.Cavalry.MarchingColumn = 220
BattalionMargins.Cavalry.BattleLine = 240

-- ARTILLERY MARGINS --
BattalionMargins.Artillery = {}
BattalionMargins.Artillery.MarchingColumn = 250
BattalionMargins.Artillery.FiringLine = 160


-- Local function that sets up the battalions on instantiation --
local function setupBattalions(service,name,initregiment,team,unitType,unitTypeName,startPos,season)
    local formation = "MarchingColumn"
    local bnMargin = BattalionMargins[service][formation]
    local pos2 = Mathematics.VectorFromAddition(startPos, Vector.New(0,bnMargin))
    local pos3 = Mathematics.VectorFromAddition(startPos, Vector.New(0,bnMargin*2))

    local bn1 = Battalion.New("1st Bn "..name,initregiment,team,service,unitType,unitTypeName,startPos,season,true)
    local bn2 = Battalion.New("2nd Bn "..name,initregiment,team,service,unitType,unitTypeName,pos2,season,false)
    local bn3 = Battalion.New("3rd Bn "..name,initregiment,team,service,unitType,unitTypeName,pos3,season,false)

    bns = { bn1, bn2, bn3 }
    
    for i=1,#bns,1 do
        bns[i].BattalionNumber = i
        bns[i].Formation = formation
        bns[i].CurrentAction = "Idle"
        bns[i]:UpdateAnimation()
    end

    return bns
end

----//// ########### ////----
----//// CONSTRUCTOR ////----
----//// ########### ////----
function Regiment.New(name,brigade,team,service,unitType,unitTypeName,startPos,season)
    --create new empty object--
    local newRegiment = {}

    --add referential data--
    local newBns = setupBattalions(service,name,newRegiment,team,unitType,unitTypeName,startPos,season)

    newRegiment.Name = name
    newRegiment.Brigade = brigade
    newRegiment.Team = team
    newRegiment.UnitType = unitType
    newRegiment.Battalions = newBns
    newRegiment.UnitClass = "Regiment"
    newRegiment.Formation = "MarchingColumn"
    newRegiment.BranchofService = service
    newRegiment.ColourBattalion = newBns[1]
    newRegiment.BrigadePosition = 0

    --add mathematical data--
    newRegiment.Position = startPos

    --add logical / admin data--
    local currentStats = findStatsObject(team,unitTypeName)
    newRegiment.MaxHealth = currentStats.Health
    newRegiment.Health = currentStats.Health
    newRegiment.Damage = currentStats.Damage
    newRegiment.Accuracy = currentStats.Accuracy
    newRegiment.MarchSpeed = currentStats.MarchSpeed
    newRegiment.Morale = currentStats.Morale
    newRegiment.ChargeEnabled = currentStats.ChargeEnabled
    newRegiment.Actions = currentStats.Actions
    newRegiment.Formations = currentStats.Formations

    newRegiment.CurrentAction = "Idle"
    newRegiment.InvertedFlanks = false
    newRegiment.RemainingWheel = nil
    
    --finish up the object--
    setmetatable(newRegiment,{__index=Regiment})--map the new table onto the Battalion class--
    return newRegiment--return the new object--
end




----//// ###################### ////----
----//// METHODS FOR THE OBJECT ////----
----//// ###################### ////----
function Regiment:UpdateCurrentImages()
    for i=1,#self.Battalions,1 do
        self.Battalions[i]:UpdateCurrentImage()
    end
end

function Regiment:CreateFlagMeshes()
    for i=1,#self.Battalions,1 do
        if self.Battalions[i].ColourBattalion then
            local bn = self.Battalions[i]
            bn:CreateFlagMeshes()
        end
    end
end

function Regiment:DrawRegiment()
    for i=1,#self.Battalions,1 do
        self.Battalions[i]:DrawBattalion()
    end
end

function Regiment:Moved()
    for i=1,#self.Battalions,1 do
        self.Battalions[i].Moved = true
    end
end

function Regiment:CheckForClick(mPos,mode)
    for i=1,#self.Battalions,1 do
        local ui = self.Battalions[i]:CheckForClick(mPos,mode)
        if ui then CurrentUnit = self return self:SelectUnit() end
    end
    return false
end

function Regiment:SelectUnit()
    local ui = UnitSelectUI.Open(self)

    return ui
end


function Regiment:ChangeFormation(newFormation, newPos)
    self.Position = self.ColourBattalion.Position

    local lastFormation = self.Formation
    self.Formation = newFormation
    local originPos = self.Battalions[1].Position

    if newPos then originPos = newPos end

    local newBnPositions = { Vector.New(0,0), Vector.New(0,0), Vector.New(0,0)}

    if ( newFormation == "BattleLine" ) or ( newFormation == "FiringLine" ) or ( newFormation == "SkirmishOrder" ) then
        dPos1 = Mathematics.ForwardVector( originPos, ( BattalionMargins[self.BranchofService]["MarchingColumn"] * 0.01 ) )
        newBnPositions[1] = Mathematics.VectorFromAddition( originPos, dPos1 )
        newBnPositions[1].Theta = originPos.Theta
        dPos2 = Mathematics.RightVector( newBnPositions[1], BattalionMargins[self.BranchofService][newFormation] )
        dPos3 = Mathematics.RightVector( newBnPositions[1], -BattalionMargins[self.BranchofService][newFormation] )
        newBnPositions[2] = Mathematics.VectorFromAddition( newBnPositions[1], dPos2 )
        newBnPositions[3] = Mathematics.VectorFromAddition( newBnPositions[1], dPos3 )
        newBnPositions[2].Theta = originPos.Theta
        newBnPositions[3].Theta = originPos.Theta
    end

    if ( newFormation == "MarchingColumn" ) then
        dPos1 = Mathematics.ForwardVector( originPos, ( BattalionMargins[self.BranchofService]["MarchingColumn"] * 2 ) )
        newBnPositions[1] = Mathematics.VectorFromAddition( originPos, dPos1 )
        newBnPositions[1].Theta = originPos.Theta
        dPos2 = Mathematics.ForwardVector( newBnPositions[1], -BattalionMargins[self.BranchofService][newFormation] )
        dPos3 = Mathematics.ForwardVector( newBnPositions[1], -BattalionMargins[self.BranchofService][newFormation]*2 )
        newBnPositions[2] = Mathematics.VectorFromAddition( newBnPositions[1], dPos2 )
        newBnPositions[3] = Mathematics.VectorFromAddition( newBnPositions[1], dPos3 )
        newBnPositions[2].Theta = originPos.Theta
        newBnPositions[3].Theta = originPos.Theta
    end

    for i=1,#self.Battalions,1 do
        self.Battalions[i].NextFormation = newFormation
        self.Battalions[i].MoveTarget = newBnPositions[i]
    end
end




function Regiment:MoveRegiment(newPos, wheel)
    self.RemainingWheel = wheel

    local form = self.Formation
    local originPos = self.Battalions[1].Position

    local newBnPositions = { Vector.New(0,0), Vector.New(0,0), Vector.New(0,0) }

    ------------------------------------------------------------
    -- Compute new facing and rotation amount
    ------------------------------------------------------------
    local oldTheta = originPos.Theta
    local newTheta = newPos.Theta

    

    if not wheel then
        newTheta = Mathematics.AngleFromVector(
        --    Mathematics.VectorFromSubtraction(originPos, newPos)
        --) - math.rad(180)
        Mathematics.VectorFromSubtraction( newPos, originPos )
        )
        newPos.Theta = newTheta
    end

    local dTheta = math.abs(shortestAngle(oldTheta, newTheta))
    local aboutFace = dTheta > math.rad(90)

    -- if an about face has occured, invert the flanks --
    if aboutFace then self.InvertedFlanks = not self.InvertedFlanks end

    ------------------------------------------------------------
    -- Assign center battalion
    ------------------------------------------------------------
    newBnPositions[1] = newPos

    ------------------------------------------------------------
    -- Battle line / firing line / skirmish order logic
    ------------------------------------------------------------
    if form == "BattleLine" or form == "FiringLine" or form == "SkirmishOrder" then
        local spacing = BattalionMargins[self.BranchofService][form]

        local dPosRight = Mathematics.RightVector(newPos, spacing)
        local dPosLeft  = Mathematics.RightVector(newPos, -spacing)

        if not self.InvertedFlanks then
            -- Normal orientation
            newBnPositions[2] = Mathematics.VectorFromAddition(newPos, dPosRight)
            newBnPositions[3] = Mathematics.VectorFromAddition(newPos, dPosLeft)
        else
            -- Regiment has rotated past 90deg , invert flanks
            newBnPositions[2] = Mathematics.VectorFromAddition(newPos, dPosLeft)
            newBnPositions[3] = Mathematics.VectorFromAddition(newPos, dPosRight)
        end

        newBnPositions[2].Theta = newTheta
        newBnPositions[3].Theta = newTheta
    end

    ------------------------------------------------------------
    -- Marching column logic
    ------------------------------------------------------------
    if form == "MarchingColumn" then
        local spacing = BattalionMargins[self.BranchofService][form]

        local dPos2 = Mathematics.ForwardVector(newPos, -spacing)
        local dPos3 = Mathematics.ForwardVector(newPos, -spacing * 2)

        newBnPositions[2] = Mathematics.VectorFromAddition(newPos, dPos2)
        newBnPositions[3] = Mathematics.VectorFromAddition(newPos, dPos3)

        newBnPositions[2].Theta = newTheta
        newBnPositions[3].Theta = newTheta
    end

    ------------------------------------------------------------
    -- Assign movement targets
    ------------------------------------------------------------
    for i = 1, #self.Battalions do
        self.Battalions[i].NextFormation = newFormation
        self.Battalions[i].MoveTarget = newBnPositions[i]
    end
end


function Regiment:UpdatePosition()
    for i=1,#self.Battalions,1 do
        self.Battalions[i]:UpdatePosition( self.RemainingWheel )
    end
end

function Regiment:UpdateAnimation()
    for i=1,#self.Battalions,1 do
        self.Battalions[i]:UpdateAnimation()
    end
end
function Regiment:ScoutMap(initScout)
    local viewRadius = 5
    if self.BranchOfService == "Cavalry" then viewRadius = 8 end

    local scoutPos = self.Position --self.Position:ToGamePosition()

    local fogX = math.floor(scoutPos.X / FogDivisions)
    local fogY = math.floor(scoutPos.Y / FogDivisions)

    --[[
    if initScout then
        -- Reveal full circle
        for y = fogY - viewRadius, fogY + viewRadius do
            for x = fogX - viewRadius, fogX + viewRadius do

                if y >= 1 and y <= #FogTiles and x >= 1 and x <= #FogTiles[1] then
                    FogTiles[y][x] = true
                end

            end
        end

    else
        -- Reveal full circle (same logic — no reason to reveal only 4 points)
        for y = fogY - viewRadius, fogY + viewRadius do
            for x = fogX - viewRadius, fogX + viewRadius do

                if y >= 1 and y <= #FogTiles and x >= 1 and x <= #FogTiles[1] then
                    FogTiles[y][x] = true
                end

            end
        end
    end
    ]]

end

return Regiment