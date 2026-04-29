--[[ UNIT INFORMATION

Chain Of Command:
Army 1x
    Division Nx
        Brigade 3x <--
            Regiment 4x 
                Battalion 3x

Unit: Brigade
Parent Unit: ( Division ) 
Child Unit: Regiment

Formation Types:
    Infantry:
        Marching Column (4x Regiment In Column)
        Full Battle Line (4x Regiment Deployed In Line)
        Battle Line (2x Regiment Deployed In Line, 2x Regiment In Reserve)
        Skirmish Line (2x Regiment Deployed In Skirmish, 2x Regiment In Reserve)

    Artillery:
        Deployed (4x Regiments In Firing Line)
        Marching Column (4x Regiments In Column)

    Cavalry:
        Marching Column (4x Regiments In Column)
        Battle Line (2x Regiments Deployed In Line Infront, 2x Regiments Deployed In Line Behind)
        Full Battle Line (4x Regiments Deployed In Line)
        
]]--

local ActionTypes = {}
ActionTypes.Infantry = {"Move","Double","Target","Charge"}
ActionTypes.Cavalry = {"Move","Double","Charge"}
ActionTypes.Artillery = {"Move","Target"}

local FormationTypes = {}
FormationTypes.Infantry = {"MarchingColumn","FullBattleLine","BattleLine","SkirmishOrder"}
FormationTypes.Artillery = {"MarchingColumn","Deployed"}
FormationTypes.Cavalry = {"MarchingColumn","FullBattleLine","BattleLine"}

Brigade = {}

local function getFormationPositions( service, formation, o, anglePos  )
    local theta = o.Theta
    if anglePos then theta = Mathematics.AngleFromVector( Mathematics.VectorFromSubtraction( o, anglePos ) ) end
    o = Mathematics.VectorFromAddition( o, Mathematics.ForwardVector( o, 15 ) )
    o.Theta = theta

    local returnSet = {}
    returnSet.Position = o
    returnSet.Formation = "MarchingColumn"

    local newPositions = {returnSet,returnSet,returnSet,returnSet}

    if formation == "MarchingColumn" then

        local frontmargin = BattalionMargins[ service ][ "MarchingColumn" ] * 3.2
        local rightmargin = BattalionMargins[ service ][ "MarchingColumn" ] * 2.2

        local pos1 = o
        local pos2 = Mathematics.VectorFromAddition( pos1, Mathematics.RightVector( pos1, rightmargin ) )
        local pos3 = Mathematics.VectorFromAddition( pos1, Mathematics.ForwardVector( pos1, -frontmargin ) )
        local pos4 = Mathematics.VectorFromAddition( pos3, Mathematics.RightVector( pos3, rightmargin ) )

        returnSet1 = {} returnSet1.Position = pos1 returnSet1.Formation = "MarchingColumn"
        returnSet2 = {} returnSet2.Position = pos2 returnSet2.Formation = "MarchingColumn"
        returnSet3 = {} returnSet3.Position = pos3 returnSet3.Formation = "MarchingColumn"
        returnSet4 = {} returnSet4.Position = pos4 returnSet4.Formation = "MarchingColumn"

        return {returnSet1,returnSet2,returnSet3,returnSet4}

    elseif ( formation == "FullBattleLine" ) or ( formation == "Deployed" ) then

        local margin = BattalionMargins[ service ][ "BattleLine" ] * 3.2

        local pos2 = o
        local pos1 = Mathematics.VectorFromAddition( pos2, Mathematics.RightVector( pos2, -margin ) )
        local pos3 = Mathematics.VectorFromAddition( pos1, Mathematics.RightVector( pos1, margin ) )
        local pos4 = Mathematics.VectorFromAddition( pos1, Mathematics.RightVector( pos1, margin*2 ) )

        returnSet1 = {} returnSet1.Position = pos1 returnSet1.Formation = "BattleLine"
        returnSet2 = {} returnSet2.Position = pos2 returnSet2.Formation = "BattleLine"
        returnSet3 = {} returnSet3.Position = pos3 returnSet3.Formation = "BattleLine"
        returnSet4 = {} returnSet4.Position = pos4 returnSet4.Formation = "BattleLine"

        return {returnSet1,returnSet2,returnSet3,returnSet4}

    elseif formation == "BattleLine" then

        local margin = BattalionMargins[ service ][ "BattleLine" ] * 3.2

        local pos1 = Mathematics.VectorFromAddition( o, Mathematics.RightVector( o, -margin/2 ) )
        local pos2 = Mathematics.VectorFromAddition( o, Mathematics.RightVector( o, margin/2 ) )
        local pos3 = Mathematics.VectorFromAddition( pos1, Mathematics.ForwardVector( pos1, -margin ) )
        local pos4 = Mathematics.VectorFromAddition( pos2, Mathematics.ForwardVector( pos2, -margin ) )

        returnSet1 = {} returnSet1.Position = pos1 returnSet1.Formation = "BattleLine"
        returnSet2 = {} returnSet2.Position = pos2 returnSet2.Formation = "BattleLine"
        returnSet3 = {} returnSet3.Position = pos3 returnSet3.Formation = "MarchingColumn"
        returnSet4 = {} returnSet4.Position = pos4 returnSet4.Formation = "MarchingColumn"
        if service == "Cavalry" then
            returnSet3 = {} returnSet3.Position = pos3 returnSet3.Formation = "BattleLine"
            returnSet4 = {} returnSet4.Position = pos4 returnSet4.Formation = "BattleLine"
        end

        return {returnSet1,returnSet2,returnSet3,returnSet4}


    elseif formation == "SkirmishOrder" then

        local skirmishmargin = BattalionMargins[ service ][ "SkirmishOrder" ] * 3.2
        local battlemargin = BattalionMargins[ service ][ "BattleLine" ] * 3.2

        local pos1 = Mathematics.VectorFromAddition( o, Mathematics.RightVector( o, -skirmishmargin/2 ) )
        local pos2 = Mathematics.VectorFromAddition( o, Mathematics.RightVector( o, skirmishmargin/2 ) )
        local pos3 = Mathematics.VectorFromAddition( pos1, Mathematics.ForwardVector( pos1, -battlemargin ) )
        local pos4 = Mathematics.VectorFromAddition( pos2, Mathematics.ForwardVector( pos2, -battlemargin ) )

        returnSet1 = {} returnSet1.Position = pos1 returnSet1.Formation = "SkirmishOrder"
        returnSet2 = {} returnSet2.Position = pos2 returnSet2.Formation = "SkirmishOrder"
        returnSet3 = {} returnSet3.Position = pos3 returnSet3.Formation = "BattleLine"
        returnSet4 = {} returnSet4.Position = pos4 returnSet4.Formation = "BattleLine"

        return {returnSet1,returnSet2,returnSet3,returnSet4}

    end
end



local function setupRegiments(nametypes,initbrigade,team,service,startPos,season)
    local formation = "MarchingColumn"

    local pos = getFormationPositions( service, "MarchingColumn", startPos, false )

    local reg1 = Regiment.New(nametypes[1].Name,initbrigade,team,service,nametypes[1].UnitType,nametypes[1].UnitTypeName,pos[1].Position,season)
    local reg2 = Regiment.New(nametypes[2].Name,initbrigade,team,service,nametypes[2].UnitType,nametypes[2].UnitTypeName,pos[2].Position,season)
    local reg3 = Regiment.New(nametypes[3].Name,initbrigade,team,service,nametypes[3].UnitType,nametypes[3].UnitTypeName,pos[3].Position,season)
    local reg4 = Regiment.New(nametypes[4].Name,initbrigade,team,service,nametypes[4].UnitType,nametypes[4].UnitTypeName,pos[4].Position,season)

    regs = { reg1, reg2, reg3, reg4 }
    
    for i=1,#regs,1 do
        regs[i].BrigadePosition = i
        regs[i].Formation = formation
        regs[i].CurrentAction = "Idle"
        regs[i]:UpdateAnimation()
        regs[i]:UpdateCurrentImages()
        regs[i]:CreateFlagMeshes()
    end

    return regs
end


function Brigade.New(name,nametypes,team,service,startPos,season)

    local newBrigade = {}

    regs = setupRegiments( nametypes,newBrigade,team,service,startPos,season )

    newBrigade.Regiments = regs
    newBrigade.Name = name
    newBrigade.BranchOfService = service
    newBrigade.Position = startPos
    newBrigade.Team = team
    newBrigade.Formation = "MarchingColumn"
    newBrigade.Actions = ActionTypes[service]
    newBrigade.Formations = FormationTypes[service]
    newBrigade.UnitClass = "Brigade"

    newBrigade.AnimsToUpdate = {}
    newBrigade.BattalionsToDraw = {}

    newBrigade.UpdateTick = UnitUpdateTickAllocator
    UnitUpdateTickAllocator = UnitUpdateTickAllocator + 1
    if UnitUpdateTickAllocator > 5 then
        UnitUpdateTickAllocator = 1
    end


    --finish up the object--
    setmetatable(newBrigade,{__index=Brigade})--map the new table onto the Battalion class--
    return newBrigade--return the new object--
end








----//// ###################### ////----
----//// METHODS FOR THE OBJECT ////----
----//// ###################### ////----
function Brigade:ChangeFormation( newFormation )
    self.Formation = newFormation
    local newPos = getFormationPositions( self.BranchOfService, newFormation, self.Regiments[1].Position, false )
    for i=1,#self.Regiments,1 do
        self.Regiments[i]:ChangeFormation(newPos[i].Formation, newPos[i].Position)
    end
end

function Brigade:MoveBrigade( newPos )
    local newPos = getFormationPositions( self.BranchOfService, self.Formation, newPos, self.Regiments[1].Position )
    for i=1,#self.Regiments,1 do
        self.Regiments[i]:MoveRegiment( newPos[i].Position )
    end
end


function Brigade:UpdateCurrentImages()
    for i=1,#self.Regiments,1 do
        self.Regiments[i]:UpdateCurrentImage()
    end
end

function Brigade:CreateFlagMeshes()
    for i=1,#self.Regiments,1 do
        self.Regiments[i]:CreateFlagMeshes()
    end
end

function Brigade:DrawBrigade()
    --[[for i=1,#self.Regiments,1 do
        self.Regiments[i]:DrawRegiment()
    end]]

    for i=#self.BattalionsToDraw,1,-1 do
        --print("Drawn: "..self.BattalionsToDraw[i].Name)
        self.BattalionsToDraw[i]:DrawBattalion()
    end
end

function Brigade:FindSquadPositions()
    if CameraMoved or ( self.UpdateTick == unitUpdateTick)  then
        for i=1,#self.Regiments,1 do
            for i2=1,#self.Regiments[i].Battalions,1 do
                self.Regiments[i].Battalions[i2]:FindSquadPositions()
            end
        end
    end

end

function Brigade:Moved()
    for i=1,#self.Regiments,1 do
        self.Regiments[i]:Moved()
    end
end


function Brigade:UpdatePosition()
    for i=1,#self.Regiments,1 do
        self.Regiments[i]:UpdatePosition()
    end
    self:FindSquadPositions()
end

function Brigade:UpdateAnimation()
    for i=#self.AnimsToUpdate,1,-1 do
        self.AnimsToUpdate[i]:UpdateAnimation()
        if self.AnimsToUpdate[i].CurrentAction ~= "Marching" then 
            self.AnimsToUpdate[i].ToUpdateAnim = false 
            table.remove(self.AnimsToUpdate, i)
        end
    end
end


function Brigade:CheckForClick(mPos,mode)
    for i=1,#self.Regiments,1 do
        local ui = self.Regiments[i]:CheckForClick(mPos,mode)
        if ui then CurrentUnit = self return self:SelectUnit() end
    end
    return false
end

function Brigade:SelectUnit()
    local ui = UnitSelectUI.Open(self)

    return ui
end


return Brigade