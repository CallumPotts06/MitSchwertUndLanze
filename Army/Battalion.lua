
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

--// IMPORT INTERFACE LIBRARIES //--
Colours = require("../Interface/Colours")
UnitSelectUI = require("../GameStates/Game/UnitSelectUI")

--// IMPORT MATHS LIBRARIES //--
Vector = require("../Mathematics/Vector")
Mathematics = require("../Mathematics/Mathematics")

--// IMPORT GRAPHICS LIBRARIES //--
Highlight = require("../Graphics/Highlighter")
Effects = require("../Graphics/Effects")

--// CONSTANTS //--
INFANTRY_MARCH_ANIMS = {"March1","March2","March1","Idle","March3","March4","March3","Idle"}
CAVALRY_MARCH_ANIMS = {"March1","March1","Idle","Idle","March2","March2","Idle","Idle"}
CAVALRY_CHARGE_ANIMS = {"Charge1","Charge1","Charge2","Charge2","Charge3","Charge3"}
ARTY_MARCH_ANIMS = {"March1","March1","Idle","Idle","March2","March2","Idle","Idle"}
DRAGOON_MARCH_ANIMS = {"MountedMarch1","MountedMarch1","MountedIdle","MountedIdle","MountedMarch2","MountedMarch2","MountedIdle","MountedIdle"}


local function shortestAngle(from, to)
    local diff = (to - from + math.pi) % (2 * math.pi) - math.pi
    return diff
end

local function normalizeAngle(a)
    return (a + math.pi) % (2 * math.pi) - math.pi
end

local function findStatsObject(team,unitType)
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
    end

    return typeStats
end


----//// CLASS : BATTALION ////----
Battalion = {}

---/// SETUP METHODS FOR BATTALION ///---
function LoadImagesOntoUnit(team,unitservice,unittype)
    local nationSet = "none"
    local imgSet = "none"

    --find the necessary object for the relevant nation--
    if team=="Germany" then nationSet = Squad.ImageLibrary.GermanUnits end
    if team=="France" then nationSet = Squad.ImageLibrary.FrenchUnits end

    --find the branch of service related to unit type--
    if unitservice=="Infantry" then imgSet = nationSet.Infantry
    elseif unitservice=="Artillery" then imgSet = nationSet.Artillery
    else imgSet = nationSet.Cavalry end
    local newImages = {}
    newImages.BattleLine = {}
    newImages.FiringLine = {}
    newImages.SkirmishOrder = {}
    newImages.MarchingColumn = {}
    newImages.Mounted = {}
    newImages.Dismounted = {}
    newImages.Flags = {}
    --look for images that apply to unit type and add them to anims table--
    for i=1,#imgSet,1 do
        if imgSet[i].UnitType==unittype then

            if imgSet[i].Formation=="BattleLine" then
                table.insert(newImages.BattleLine,imgSet[i])
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
---/// END OF SETUP METHODS FOR BATTALION ///---





---/// CONSTRUCTOR BY ARGUMENT PASSING FOR BATTALION ///---
function Battalion.New(name,regiment,team,service,unitType,unitTypeName,startPos,season,colour)
    --create new empty object--
    local newBattalion = {}

    --add referential data--
    newBattalion.UnitClass = "Battalion"
    newBattalion.Name = name
    newBattalion.Regiment = regiment
    newBattalion.Team = team
    newBattalion.UnitType = unitType
    newBattalion.UnitTypeName = unitTypeName
    newBattalion.BranchofService = service

    --add mathematical data--
    newBattalion.Position = startPos
    newBattalion.MoveTarget = nil
    newBattalion.Moved = true
    newBattalion.CurrentMoveType = nil
    newBattalion.PositionTable = {}
    newBattalion.Facing = "South"

    --add statistics from stats library--
    local currentStats = findStatsObject(team,unitTypeName)
    newBattalion.MaxHealth = currentStats.Health
    newBattalion.Health = currentStats.Health
    newBattalion.Damage = currentStats.Damage
    newBattalion.Accuracy = currentStats.Accuracy
    newBattalion.MarchSpeed = currentStats.MarchSpeed
    newBattalion.Morale = currentStats.Morale
    newBattalion.ChargeEnabled = currentStats.ChargeEnabled
    newBattalion.Actions = currentStats.Actions
    newBattalion.Formations = currentStats.Formations

    --add other statistical data--
    newBattalion.ColourBattalion = colour
    newBattalion.CurrentAction = "Idle"
    newBattalion.BuffInfo = {}
    newBattalion.BattalionNumber = nil

    --add appearance data--
    newBattalion.Images = LoadImagesOntoUnit(team,service,unitType)
    newBattalion.CurrentImage = nil
    newBattalion.Season = season
    newBattalion.SkirmishOrderSeed = math.random(1,1000)
    newBattalion.MarchSet = INFANTRY_MARCH_ANIMS

    newBattalion.NextFormation = nil

    --add game data--
    if service=="Infantry" or service=="Artillery" or service=="Cavalry" then
        newBattalion.Formation = "MarchingColumn"
        newBattalion.Animation = "Idle"
    end
    if (unitType=="PreussischerDragoner")or(unitType=="PreussischerDragoner") then newBattalion.Formation = "Mounted" newBattalion.Animation = "MountedIdle" end
    -- if the unit type name indicates dragoons, default to Mounted
    if unitTypeName == "PreussischerDragoner" then
        newBattalion.Formation = "Mounted"
        newBattalion.Animation = "MountedIdle"
    end


    if service=="Infantry" then newBattalion.MarchSet=INFANTRY_MARCH_ANIMS
    elseif service=="Cavalry" then newBattalion.MarchSet=CAVALRY_MARCH_ANIMS
    elseif service=="Artillery" then newBattalion.MarchSet=ARTY_MARCH_ANIMS end

    --finish up the object--
    setmetatable(newBattalion,{__index=Battalion})--map the new table onto the Battalion class--
    return newBattalion--return the new object--
end

---/// END OF CONSTRUCTOR METHOD FOR BATTALION ///---










---/// OTHER METHODS FOR BATTALION ///---

--// UPDATE THE BATTALION'S CURRENT IMAGE ATTRIBUTE //--
function Battalion:UpdateCurrentImage()
    self.Position.Theta = self.Position.Theta % (2 * math.pi)
    if (self.Position.Theta > math.rad(320)) or (self.Position.Theta < math.rad(45)) then self.Facing="North"
    elseif (self.Position.Theta >= math.rad(45)) and (self.Position.Theta <= math.rad(135)) then self.Facing="East"
    elseif (self.Position.Theta >= math.rad(135)) and (self.Position.Theta <= math.rad(225)) then self.Facing="South"
    elseif (self.Position.Theta >= math.rad(225)) and (self.Position.Theta <= math.rad(320)) then self.Facing="West"
    end

    local imgFormationSet = nil
    if self.Formation=="BattleLine" then imgFormationSet = self.Images.BattleLine
    elseif self.Formation=="MarchingColumn" then imgFormationSet = self.Images.MarchingColumn
    elseif self.Formation=="FiringLine" then imgFormationSet = self.Images.FiringLine
    elseif self.Formation=="SkirmishOrder" then imgFormationSet = self.Images.SkirmishOrder
    elseif self.Formation=="Mounted" then imgFormationSet = self.Images.Mounted
    elseif self.Formation=="Dismounted" then imgFormationSet = self.Images.Dismounted end

    local selectedImage = nil
    if imgFormationSet and #imgFormationSet > 0 then
        for i=1,#imgFormationSet,1 do
            if imgFormationSet[i].Animation==self.Animation and imgFormationSet[i].Facing==self.Facing and imgFormationSet[i].Dress==self.Season then
                selectedImage = imgFormationSet[i].Image
                break
            end
        end
    end

    -- fallback: if nothing matched, try a looser match (animation+facing), then any image in formation,
    -- then finally keep existing CurrentImage (or nil)
    if not selectedImage and imgFormationSet and #imgFormationSet>0 then
        for i=1,#imgFormationSet,1 do
            if imgFormationSet[i].Animation==self.Animation and imgFormationSet[i].Facing==self.Facing then
                selectedImage = imgFormationSet[i].Image; break
            end
        end
        if not selectedImage then selectedImage = imgFormationSet[1].Image end
    end

    if selectedImage then
        self.CurrentImage = selectedImage
    else
        -- leave CurrentImage unchanged (or set to a tiny fallback canvas if you prefer)
    end
end

--Function maps the current action to the correct animation--
function Battalion:UpdateAnimation()
    if self.CurrentAction == "Marching" then
        self.Animation=INFANTRY_MARCH_ANIMS[AnimTick]
        self:UpdateCurrentImage()
        return true
    else

        if self.CurrentAction=="Idle" then self.Animation="Idle"

        elseif self.CurrentAction=="Marching" then
            if self.Formation=="Mounted" then self.MarchSet = DRAGOON_MARCH_ANIMS
            elseif self.Formation=="Dismounted" then self.MarchSet = INFANTRY_MARCH_ANIMS end

            self.Animation=self.MarchSet[AnimTick]

        elseif self.CurrentAction=="Aiming" then self.Animation="Aiming"

        elseif self.CurrentAction=="Firing" then self.Animation="Firing"

        elseif self.CurrentAction=="Guard" then self.Animation="Guard"

        end

        self:UpdateCurrentImage()

    end
end

function Battalion:CreateFlagMeshes()
    --find flag--
    self.Images.Flags = {}
    for tick=-6,6,1 do
        local flagSet = nil
        local nationSet = nil
        if self.Team=="Germany" then nationSet=Squad.ImageLibrary.GermanUnits.Flags end
        if self.Team=="France" then nationSet=Squad.ImageLibrary.FrenchUnits.Flags end

        for i=1,#nationSet,1 do
            if nationSet[i][2]==self.UnitTypeName then
                flagSet = nationSet[i]
                break
            end
        end

        local flagPole = Vector.New(0,120)
        local flagDimensions = Vector.New(80*flagSet[3].X,80*flagSet[3].Y)
        local flagVertices = {}
        for x = 0,flagDimensions.X,10 do
            -- Calculate UV coordinates (0-1 range)
            local u = x/flagDimensions.X
            
            -- Top vertex
            local y1 = (tick*2)*math.sin(x/(flagDimensions.X/6))
            table.insert(flagVertices, {
                x, y1,           -- position (x,y)
                u, 0             -- texture coordinates (u,v)
            })
            
            -- Bottom vertex
            local y2 = flagDimensions.Y + (tick*2)*math.sin(x/(flagDimensions.X/6))
            table.insert(flagVertices, {
                x, y2,           -- position (x,y) 
                u, 1             -- texture coordinates (u,v)
            })
        end
        local flagMesh = love.graphics.newMesh(flagVertices,"strip")
        flagMesh:setTexture(flagSet[1])
        table.insert(self.Images.Flags,flagMesh)
    end
end



function Battalion:FindSquadPositions()
    self.Moved = false
    self:UpdateCurrentImage()
    local img = self.CurrentImage.Drawable

    --setup data--
    local n1 = 1
    local n2 = 2 
    local direction = "Right"
    local squadsPerHealth = 1/15 
    local squadCount = self.Health*squadsPerHealth
    local positionTable = {}
    local pos = self.Position 
    local imgW = img:getWidth()
    local imgH = img:getHeight()

    local tempN = 0
    local increment = 1

    local offset = Vector.New(0,0)

    if (self.BranchofService=="Artillery") then offset.Y = -60 imgW=150 imgH=400 end
    if (self.BranchofService=="Infantry") or (self.Formation=="Dismounted") then imgW = 40 imgH = 110 end
    if (self.BranchofService=="Cavalry") and (not (self.Formation=="Dismounted")) then imgW = 70 imgH = 260 offset.Y=-120 end
    if (self.Animation=="Guard") then imgW=110 end

    local tempTheta = normalizeAngle(pos.Theta)
    if tempTheta < 0 then tempTheta = tempTheta + math.rad( 360 ) end
    pos = Mathematics.VectorFromAddition(pos,offset)
    pos.Theta = tempTheta

    --lowers the amount of squads if artillery or cavalry--
    if self.BranchofService == "Artillery" then squadsPerHealth = 1/45 squadCount = (self.Health*squadsPerHealth) end
    if self.BranchofService == "Cavalry" then squadsPerHealth = 1/25 squadCount = (self.Health*squadsPerHealth) end

    --refines the information for the equations later--
    if (self.Formation == "BattleLine") or (self.Formation == "FiringLine") or (self.Formation == "Dismounted") or (self.BranchofService == "Cavalry") then
        direction = "Right"
        n1 = - math.floor( squadCount / 2 )
        n2 = math.floor( squadCount / 2 )

        if self.BranchofService=="Artillery" then n1 = 0 end
        if (pos.Theta > math.rad(180)) and (pos.Theta < math.rad(360)) then tempN = n1 n1 = n2 n2 = tempN increment = -1 end

    elseif (self.Formation == "MarchingColumn") or (self.Formation == "Mounted") then
        direction = "Forward"
        n1 = 0
        n2 = squadCount / 2

        if (self.BranchofService=="Infantry") then n2 = math.ceil(n2 / 2)-1--infantry squads are 2x the size in this formation--
        else n2 = math.floor(n2 * 1.5) - 1 end
        if (self.BranchofService=="Artillery") then n2=n2+1 end
        if (pos.Theta>math.rad(90))and(pos.Theta<math.rad(270)) then tempN = n1 n1 = n2 n2 = tempN increment = -1 end

    elseif self.Formation == "SkirmishOrder" then
        squadCount = squadCount * 1.5
        n1 = - math.floor( squadCount / 2 )
        n2 = math.floor( squadCount / 2 )

    end

    --get to locating the positions of the squads--
    for n = n1,n2,increment do
        local newPos = Vector.New(0,0)
        
        if not (self.Formation == "SkirmishOrder") then
            if direction == "Right" then
                local dx = imgW * n
                newPos = Mathematics.VectorFromAddition(pos, Mathematics.RightVector(pos,dx))
                
            elseif direction == "Forward" then
                local dy = - ( ( imgH / 1.5 ) * n ) -- changed the denominator from 2 to 1.5 for test --
                newPos = Mathematics.VectorFromAddition(pos, Mathematics.ForwardVector(pos,dy))
            
            end
        else
            math.randomseed(self.SkirmishOrderSeed+n)
            --Front Rank--
            newPos = Mathematics.VectorFromAddition(Mathematics.RightVector(pos,(n*50)+math.random(-16,16)),pos)
            newPos = Mathematics.VectorFromAddition(Mathematics.ForwardVector(pos,math.random(-24,24)),newPos)

            math.randomseed(self.SkirmishOrderSeed+(n*2))
            --Rear Rank--
            local theta=pos.Theta
            newPos2 = Vector.New(0,0)
            newPos2.Theta=theta
            if n~=0 then
                --update theta accordingly--
                if n<0 then theta = Mathematics.AngleFromVector(Mathematics.VectorFromSubtraction(newPos,pos))
                else theta = Mathematics.AngleFromVector(Mathematics.VectorFromSubtraction(pos,newPos)) end
                newPos2.Theta=theta
                newPos2 = Mathematics.VectorFromAddition(Mathematics.RightVector(newPos,(-125)+math.random(-16,16)),newPos)
            else
                newPos2 = Mathematics.VectorFromAddition(Mathematics.ForwardVector(newPos,(-125)+math.random(-24,24)),newPos)
            end
            newPos2:ToScreenPosition()
            table.insert(positionTable,newPos2)
        end
        newPos:ToScreenPosition()
        table.insert(positionTable, newPos)
    end

    self.PositionTable = positionTable
end



function Battalion:DrawBattalion()
    --update squad positions if necessary--
    if self.Moved then self:FindSquadPositions() end

    --setup local necessary variables--
    local img = self.CurrentImage
    local imgSize = Vector.New(img.Drawable:getWidth(),img.Drawable:getHeight())
    local pos = self.Position

    --create data for flag--
    local flagPole = Vector.New(0,120*CameraZoom)
    local flagPos = Vector.New(pos.X+(imgSize.X/2),pos.Y-(imgSize.Y))
    local flagImg = self.Images.Flags[FlagTick+7]

    flagPos:ToScreenPosition()

    --draw all the troops' shadows--
    for i=1,#self.PositionTable,1 do Effects.DrawShadow(img.Drawable,self.PositionTable[i],"Image") end
    

    --set a lighting colour for the troops--
    Colours.SetColour(Effects.LightingColour(Colours.CreateColour({1,1,1,1})),false)
    --draw flag, flagpole and soldiers--
    for i=1,#self.PositionTable,1 do love.graphics.draw(img.Drawable,self.PositionTable[i].X,self.PositionTable[i].Y,0,CameraZoom,CameraZoom) end
    if self.ColourBattalion then
        love.graphics.draw(flagImg,flagPos.X,flagPos.Y,0,CameraZoom,CameraZoom)
        love.graphics.setLineWidth( 3 * CameraZoom )
        flagPole:DrawVector(flagPos,Effects.LightingColour(Colours.CreateColour({0.2627,0.1569,0.0941,1})))
    end
end


function Battalion:SelectUnit()
    local ui = UnitSelectUI.Open(self)

    return ui
end


function Battalion:CheckForClick(mousePos,task)
    local minx = 99999999999--inf--
    local maxx = -9999999999
    local miny = 99999999999
    local maxy = -9999999999

    local clicked = false

    for i = 1,#self.PositionTable,1 do
        if self.PositionTable[i].X<minx then minx = self.PositionTable[i].X end
        if self.PositionTable[i].X>maxx then maxx = self.PositionTable[i].X + self.CurrentImage.Drawable:getWidth() end

        if self.PositionTable[i].Y<miny then miny = self.PositionTable[i].Y end
        if self.PositionTable[i].Y>maxy then maxy = self.PositionTable[i].Y + self.CurrentImage.Drawable:getHeight() end
    end

    if (mousePos.X > minx) and (mousePos.X < maxx) and (mousePos.Y > miny) and (mousePos.Y < maxy) then 
        clicked = true
    end  


    if clicked then--click was successfull--
        if task == "Select" then
            CurrentUnit = self
            return self:SelectUnit()
        end

        return true
    end

    return false
end


function Battalion:WheelUnit(theta1, theta2, omega)
    theta1 = normalizeAngle(theta1)
    theta2 = normalizeAngle(theta2)

    local dTheta = shortestAngle(theta1, theta2)
    local direction = dTheta > 0 and 1 or -1
    local magnitude = math.abs(dTheta)

    --print(dTheta)
    --if magnitude > 0 then print(magnitude.." , "..math.rad( 90 ).."  Form="..self.Formation) end
    
    if ( magnitude > math.rad( 90 ) ) and ( self.Formation ~= "MarchingColumn" ) then
        -- do an about face if that makes the total turn faster, not in marching column though (as per the if statement) --
        self.Position.Theta = self.Position.Theta + math.rad( 180 )
        return false
    else
        if magnitude <= omega then
            self.Position.Theta = theta2
            return true
        else
            self.Position.Theta = self.Position.Theta + ( omega * direction) --normalizeAngle(self.Position.Theta + ( omega * direction) )
            return false
        end
    end
end



function Battalion:MoveUnit(speed, theta)
    if Mathematics.VectorMagnitude( self.Position, self.MoveTarget ) < speed then
        self.Position.X = self.MoveTarget.X 
        self.Position.Y = self.MoveTarget.Y
        return true
    else
        local dPos = Mathematics.ForwardVector(self.Position, speed)
        self.Position = Mathematics.VectorFromAddition( self.Position, dPos )
        self.Position.Theta = theta
        return false
    end 
end


function Battalion:UpdatePosition()
    local movetype = "normal"

    if ( not self.ColourBattalion ) and ( not self.NextFormation ) then --and ( self.Formation == "MarchingColumn" ) then
        movetype = "Wheel"
        local centerPos = self.Regiment.ColourBattalion.Position

        if self.Formation == "MarchingColumn" then
            dPos = Mathematics.ForwardVector(centerPos,-BattalionMargins[self.BranchofService][self.Formation]*(self.BattalionNumber-1))
            self.MoveTarget = Mathematics.VectorFromAddition( centerPos, dPos )
            self.MoveTarget.Theta = self.Regiment.ColourBattalion.Position.Theta
        else
            local bnNo = self.BattalionNumber local invertFlanks = self.Regiment.InvertedFlanks

            if ( ( bnNo == 2 ) and ( not invertFlanks ) ) or ( ( bnNo == 3 ) and ( invertFlanks ) ) then
                dPos = Mathematics.RightVector(centerPos,BattalionMargins[self.BranchofService][self.Formation])
            else
                dPos = Mathematics.RightVector(centerPos,-BattalionMargins[self.BranchofService][self.Formation])
            end
            self.MoveTarget = Mathematics.VectorFromAddition( centerPos, dPos )
            self.MoveTarget.Theta = self.Regiment.ColourBattalion.Position.Theta
        end
    end

    local currentSpeed = self.MarchSpeed / 1.35
    local omega = math.rad(2)
    local angleTolerance = math.rad(0.5)

    if (self.Formation ~= self.Regiment.ColourBattalion.NextFormation) then
        if ( self.MoveTarget ) and ( self.NextFormation ~= self.Formation ) then
            self:UpdateAnimation()
            local oldTheta = self.Position.Theta
            self.Moved = true
            self.CurrentAction = "Marching"
            local theta = Mathematics.AngleFromVector( Mathematics.VectorFromSubtraction(self.MoveTarget, self.Position) )

            -- if they are moving from skirmish order into any other formation, instantly swap formations --
            if(self.Formation=="SkirmishOrder")and(self.NextFormation)then self.Formation = self.NextFormation self.NextFormation = nil end


            if ( self.Position.X ~= self.MoveTarget.X ) or ( self.Position.Y ~= self.MoveTarget.Y ) then
                
                if ( movetype == "Wheel" ) then
                    -- if the whole regiment is wheeling (rather than bn) the bn is permitted to move and wheel at the same time --
                    self:WheelUnit(oldTheta, theta, omega * 1.25)
                    self:MoveUnit(currentSpeed * 1.25, theta)
                else

                    -- regular movement --
                    if ( self.NextFormation ) or ( self.ColourBattalion ) then

                        if math.abs(shortestAngle(oldTheta, theta)) > angleTolerance then self:WheelUnit(oldTheta, theta, omega)
                        else self:MoveUnit(currentSpeed, oldTheta) end
                        
                    else

                        self:MoveUnit(currentSpeed, oldTheta)
                        self:WheelUnit(oldTheta, theta, omega)

                    end
                    
                    self.Position.Theta = normalizeAngle(self.Position.Theta)
                end

            else
                -- the unit is in the final position --
                theta = self.MoveTarget.Theta

                -- wheel unit to final roation ( if :wheelunit returns true, final state is reached ) --
                if self:WheelUnit(oldTheta, theta, omega) then
                    -- finished state --
                    self.Position.X = self.MoveTarget.X
                    self.Position.Y = self.MoveTarget.Y
                    self.Position.Theta = self.MoveTarget.Theta
                    self.MoveTarget = nil

                    if self.NextFormation then self.Formation = self.NextFormation self.NextFormation = nil end
                    self.CurrentAction = "Idle"
                    self.CurrentMoveType = nil
                end
            end
        end
    end
    if self.ColourBattalion then self.Regiment.Position = self.Regiment.ColourBattalion.Position end
end

--// FINISH UP BY RETURNING THE NEW OBJECT BACK TO MAIN //--
return Battalion

