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
        Battle Line (3x Regiment Deployed In Line, 1x Regiment In Reserve)
        Skirmish Line (2x Regiment Deployed In Skirmish, 2x Regiment In Reserve)

    Artillery:
        Deployed (4x Regiments In Firing Line)
        Marching Column (4x Regiments In Column)

    Cavalry:
        Marching Column (4x Regiments In Column)
        Battle Line (2x Regiments Deployed In Line Infront, 2x Regiments Deployed In Line Behind)
        Full Battle Line (4x Regiments Deployed In Line)
        
]]--

Brigade = {}

local function getFormationPositions( service, formation, o )
    local newPositions = {o,o,o,o}

    if service == "Infantry" then
        
        if formation == "MarchingColumn" then

            local frontmargin = BattalionMargins[ service ][ "MarchingColumn" ] * 3.2
            local rightmargin = BattalionMargins[ service ][ "MarchingColumn" ] * 2.2

            local pos1 = o
            local pos2 = Mathematics.VectorFromAddition( pos1, Mathematics.RightVector( pos1, rightmargin ) )
            local pos3 = Mathematics.VectorFromAddition( pos1, Mathematics.ForwardVector( pos1, -frontmargin ) )
            local pos4 = Mathematics.VectorFromAddition( pos3, Mathematics.RightVector( pos3, rightmargin ) )

            return {pos1,pos2,pos3,pos4}
        end

        -- ... --
    end
    -- ... --
end



local function setupRegiments(nametypes,initbrigade,team,service,startPos,season)
    local formation = "MarchingColumn"

    local pos = getFormationPositions( service, "MarchingColumn", startPos )

    local reg1 = Regiment.New(nametypes[1].Name,initbrigade,team,service,nametypes[1].UnitType,nametypes[1].UnitTypeName,pos[1],season)
    local reg2 = Regiment.New(nametypes[2].Name,initbrigade,team,service,nametypes[2].UnitType,nametypes[2].UnitTypeName,pos[2],season)
    local reg3 = Regiment.New(nametypes[3].Name,initbrigade,team,service,nametypes[3].UnitType,nametypes[3].UnitTypeName,pos[3],season)
    local reg4 = Regiment.New(nametypes[4].Name,initbrigade,team,service,nametypes[4].UnitType,nametypes[4].UnitTypeName,pos[4],season)

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


    --finish up the object--
    setmetatable(newBrigade,{__index=Brigade})--map the new table onto the Battalion class--
    return newBrigade--return the new object--
end








----//// ###################### ////----
----//// METHODS FOR THE OBJECT ////----
----//// ###################### ////----
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
    for i=1,#self.Regiments,1 do
        self.Regiments[i]:DrawRegiment()
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
end

function Brigade:UpdateAnimation()
    for i=1,#self.Regiments,1 do
        self.Regiments[i]:UpdateAnimation()
    end
end


function Brigade:CheckForClick(mPos,mode)
    for i=1,#self.Regiments,1 do
        local ui = self.Regiments[i]:CheckForClick(mPos,mode)
        if ui then return self:SelectUnit() end
    end
    return false
end

function Brigade:SelectUnit()
    local ui = UnitSelectUI.Open(self)

    return ui
end


return Brigade