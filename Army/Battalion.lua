
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

--// IMPORT MATHS LIBRARIES //--
Vector = require("../Mathematics/Vector")
Mathematics = require("../Mathematics/Mathematics")

--// IMPORT GRAPHICS LIBRARIES //--
Highlight = require("../Graphics/Highlighter")
Effects = require("../Graphics/Effects")


local function findStatsObject(team,unitType)
    local teamStats = nil
    local typeStats = nil

    --simple function that maps team and unit type to find the correct stats object--
    if team == "Germany" then
        teamStats = Stats.GermanUnits
        if unitType == "PreussischerLineninfanterie" then typeStats = teamStats.PrussianLineInfantry end
        if unitType == "PreussischerGardeZuFuss" then typeStats = teamStats.PrussianGuards end
        if unitType == "Landwehr" then typeStats = teamStats.Landwehr end
        if unitType == "PreussischerUhlanen" then typeStats = teamStats.Uhlanen end
        if unitType == "PreussischerArtillerie" then typeStats = teamStats.Artillery end
        if unitType == "PreussischerDragoner" then typeStats = teamStats.Dragoons end
        if unitType == "BayerischerLineninfanterie" then typeStats = teamStats.BayerischerLineInfantry end
        if unitType == "HessischLineninfanterie" then typeStats = teamStats.HessianLineInfantry end
        if unitType == "WuerttemburgLineninfanterie" then typeStats = teamStats.WuerttemburgLineInfantry end
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
    newBattalion.Name = name
    newBattalion.Regiment = regiment
    newBattalion.Team = team
    newBattalion.UnitType = unitType
    newBattalion.UnitTypeName = unitTypeName
    newBattalion.BranchofService = service

    --add mathematical data--
    newBattalion.Position = startPos
    newBattalion.MoveObject = nil
    newBattalion.Moved = true
    newBattalion.PositionTable = {}

    --add statistics from stats library--
    local currentStats = findStatsObject(team,unitTypeName)
    newBattalion.MaxHealth = currentStats.Health
    newBattalion.Health = currentStats.Health
    newBattalion.Damage = currentStats.Damage
    newBattalion.Accuracy = currentStats.Accuracy
    newBattalion.MarchSpeed = currentStats.MarchSpeed
    newBattalion.Morale = currentStats.Morale
    newBattalion.ChargeEnabled = currentStats.ChargeEnabled

    --add appearance data--
    newBattalion.Images = LoadImagesOntoUnit(team,service,unitType)
    newBattalion.Facing = "South"
    newBattalion.CurrentImage = nil
    newBattalion.Season = season
    newBattalion.ColourBattalion = colour
    newBattalion.SkirmishOrderSeed = math.random(1,1000)

    --add game data--
    if service=="Infantry" or service=="Artillery" or service=="Cavalry" then
        newBattalion.Formation = "MarchingColumn"
        newBattalion.Animation = "Idle"
    end
    if (unitType=="PreussischerDragoner")or(unitType=="PreussischerDragoner") then newBattalion.Formation = "Mounted" newBattalion.Animation = "MountedIdle" end
    -- if the concrete unit type name indicates dragoons, default to Mounted
    if unitTypeName == "PreussischerDragoner" then
        newBattalion.Formation = "Mounted"
        newBattalion.Animation = "MountedIdle"
    end

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

function Battalion:CreateFlagMeshes()
    --find flag--
    self.Images.Flags = {}
    for tick=-6,6,1 do
        local flagSet = nil
        local nationSet = nil
        if self.Team=="Germany" then nationSet=Squad.ImageLibrary.GermanUnits.Flags end

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

    if (self.BranchofService=="Artillery") then imgW=imgW*2.2*math.cos(pos.Theta)  imgH=imgH*2.2*math.cos(pos.Theta) end
    if (self.BranchofService=="Infantry") or (self.Formation=="Dismounted") then imgW = 40 imgH = 125 end
    if (self.BranchofService=="Cavalry") and (not (self.Formation=="Dismounted")) then imgW = 70 imgH = 260 end


    --lowers the amount of squads if artillery--
    if self.BranchofService == "Artillery" then squadsPerHealth = 1/60 squadCount = self.Health*squadsPerHealth end


    --refines the information for the equations later--
    if (self.Formation == "BattleLine") or (self.Formation == "FiringLine") or (self.Formation == "Dismounted") or (self.Formation == "Guard") then
        n1 = - math.floor( squadCount / 2 )
        n2 = math.floor( squadCount / 2 )


        if (pos.Theta > math.rad(180)) and (pos.Theta < math.rad(360)) then tempN = n1 n1 = n2 n2 = tempN increment = -1 end
        --if( self.Facing == "North" ) or ( self.Facing == "South" )then imgW = imgH end--change dimensions for different facings--

    elseif (self.Formation == "MarchingColumn") or (self.Formation == "Mounted") then
        direction = "Forward"
        n1 = 0
        n2 = squadCount

        if (self.BranchofService=="Infantry")or(self.BranchofService=="Cavalry") then n2 = (n2 / 2)-1 end--infantry squads are 2x the size in this formation--
        if (pos.Theta > math.rad(90)) and (pos.Theta < math.rad(270)) then tempN = n1-1 n1 = n2-1 n2 = tempN increment = -1 end
       -- if( self.Facing == "East" ) or ( self.Facing == "West" )then imgH = imgW end--change dimensions for different facings--

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
                local dy = - ( ( imgH / 2 ) * n )
                newPos = Mathematics.VectorFromAddition(pos, Mathematics.ForwardVector(pos,dy))
            
            end
        else
            math.randomseed(self.SkirmishOrderSeed+n)
            --Front Rank--
            newPos = Mathematics.VectorFromAddition(Mathematics.RightVector(pos,(n*75)+math.random(-12,12)),pos)
            newPos = Mathematics.VectorFromAddition(Mathematics.ForwardVector(newPos,math.random(-20,20)),newPos)
            table.insert(positionTable,newPos)

            --Rear Rank--
            local theta=pos.Theta
            if n~=0 then
                --update theta accordingly--
                if n<0 then theta = Mathematics.AngleFromVector(Mathematics.VectorFromSubtraction(newPos,pos))
                else theta = Mathematics.AngleFromVector(Mathematics.VectorFromSubtraction(pos,newPos)) end

                newPos.Theta=theta
                newPos = Mathematics.VectorFromAddition(Mathematics.RightVector(newPos,(-125)+math.random(-12,12)),newPos)
            else
                newPos.Theta=theta
                newPos = Mathematics.VectorFromAddition(Mathematics.ForwardVector(newPos,(-125)+math.random(-20,20)),newPos)
            end

        end
        table.insert(positionTable, newPos)
    end

    self.PositionTable = positionTable
end



function Battalion:DrawBattalion()
    if self.Moved then self:FindSquadPositions() end

    --setup local necessary variables--
    local img = self.CurrentImage
    local imgSize = Vector.New(img.Drawable:getWidth(),img.Drawable:getHeight())
    local pos = self.Position

    --create data for flag--
    local flagPole = Vector.New(0,120)
    local flagPos = Vector.New(pos.X+(imgSize.X/2),pos.Y-(imgSize.Y))
    local flagImg = self.Images.Flags[FlagTick+7]

    --draw all the troops' shadows--
    for i=1,#self.PositionTable,1 do Effects.DrawShadow(img.Drawable,self.PositionTable[i],"Image") end
    

    --set a lighting colour for the troops--
    Colours.SetColour(Effects.LightingColour(Colours.CreateColour({1,1,1,1})),false)
    --draw flag, flagpole and soldiers--
    for i=1,#self.PositionTable,1 do love.graphics.draw(img.Drawable,self.PositionTable[i].X,self.PositionTable[i].Y) end
    love.graphics.draw(flagImg,flagPos.X,flagPos.Y)
    flagPole:DrawVector(flagPos,Colours.CreateColour({0.2627,0.1569,0.0941,1}))

    
    --Highlight.Box(pos,imgSize,Colours.CreateColour(Colours.White))
end



--// FINISH UP BY RETURNING THE NEW OBJECT BACK TO MAIN //--
return Battalion

