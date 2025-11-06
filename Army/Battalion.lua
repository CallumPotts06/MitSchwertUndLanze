
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

--// IMPORT MATHS LIBRARIES //--
Vector = require("../Mathematics/Vector")
Mathematics = require("../Mathematics/Mathematics")


local function findStatsObject(team,unitType)
    local teamStats = nil
    local typeStats = nil

    --simple function that maps team and unit type to find the correct stats object--
    if team == "Germany" then
        teamStats = Stats.GermanUnits
        if unitType == "PreussischerLineninfanterie" then typeStats = teamStats.PrussianLineInfantry end
        if unitType == "Landwehr" then typeStats = teamStats.Landwehr end
        if unitType == "PreussischerUhlanen" then typeStats = teamStats.Uhlanen end
        if unitType == "PreussischerArtillerie" then typeStats = teamStats.Artillery end
        if unitType == "PreussischerDragoner" then typeStats = teamStats.Dragoons end
        if unitType == "BayerischerLineninfanterie" then typeStats = teamStats.BayerischerLineInfantry end
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
    --look for images that apply to unit type and add them to anims table--
    for i=1,#imgSet,1 do
        print(imgSet[i].UnitType)
        if imgSet[i].UnitType==unittype then
            print("true")

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
function Battalion.New(name,regiment,team,service,unitType,unitTypeName,startPos,season)
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

    --add game data--
    if serive=="Infantry" or serive=="Artillery" or service=="Cavalry" then
        newBattalion.Formation = "MarchingColumn"
        newBattalion.Animation = "Idle"
    end
    if (unitType=="PreussischerDragoner")or(unitType=="PreussischerDragoner") then newBattalion.Formation = "Mounted" newBattalion.Animation = "MountedIdle" end

    --finish up the object--
    setmetatable(newBattalion,{__index=Battalion})--map the new table onto the Battalion class--
    return newBattalion--return the new object--
end

---/// END OF CONSTRUCTOR METHOD FOR BATTALION ///---










---/// OTHER METHODS FOR BATTALION ///---

--// UPDATE THE BATTALION'S CURRENT IMAGE ATTRIBUTE //--
function Battalion:UpdateCurrentImage()
    local imgFormationSet = nil
    if self.Formation=="BattleLine" then imgFormationSet = self.Images.BattleLine
    elseif self.Formation=="MarchingColumn" then imgFormationSet = self.Images.MarchingColumn
    elseif self.Formation=="FiringLine" then imgFormationSet = self.Images.FiringLine
    elseif self.Formation=="SkirmishOrder" then imgFormationSet = self.Images.SkirmishOrder
    elseif self.Formation=="Mounted" then imgFormationSet = self.Images.Mounted
    elseif self.Formation=="Dismounted" then imgFormationSet = self.Images.Dismounted end

    for i=1,#imgFormationSet,1 do
        if imgFormationSet[i].Animation==self.Animation then
            if imgFormationSet[i].Facing==self.Facing then
                if imgFormationSet[i].Dress==self.Season then
                    squadImage = imgFormationSet[i].Image
                end
            end
        end
    end

    self.CurrentImage = squadImage
end




--// DRAW BATTALION METHOD //--
function Battalion:DrawBattalion()
    local preFacing = self.Facing
    --update the battalions facing--
    self.Position.Theta = self.Position.Theta % (2 * math.pi)
    if (self.Position.Theta > math.rad(320)) or (self.Position.Theta < math.rad(45)) then self.Facing="North"
    elseif (self.Position.Theta >= math.rad(45)) and (self.Position.Theta <= math.rad(135)) then self.Facing="East"
    elseif (self.Position.Theta >= math.rad(135)) and (self.Position.Theta <= math.rad(225)) then self.Facing="South"
    elseif (self.Position.Theta >= math.rad(225)) and (self.Position.Theta <= math.rad(320)) then self.Facing="West"
    end

    --if a change occurs, update the image--
    if not (preFacing==self.Facing) then self:UpdateCurrentImage() end
    
    --setup local variables for the method--
    local squadsPerHealth=2
    if self.BranchofService=="Artillery" then squadsPerHealth = 1/60
    else squadsPerHealth = 1/20 end
    local squadCount = self.Health*squadsPerHealth

    local squadWidth = self.CurrentImage:getWidth()
    local squadHeight = self.CurrentImage:getHeight()

    local drawPositions = {}

    local startMag = -1
    local endMag = 1

    --to make sure that the squads overlap correctly--
    if self.Formation=="BattleLine" then
        if self.Position.Theta > math.rad(180) then
            startMag = 1
            endMag = -1
        end
    end
    if self.Formation=="MarchingColumn" then
        if (self.Position.Theta < math.rad(90)) or (self.Position.Theta > math.rad(270)) then
            startMag = 1
            endMag = -1
        end
    end

    --finds all the positions that the squads need to be placed in--
    
    for i=math.floor((startMag*squadCount)/2),math.floor((endMag*squadCount)/2),endMag do

        if (self.Formation=="MarchingColumn")or(self.Formation=="Mounted") then
            if (not (i%2==0)) then--only half the amount of images drawn in marching column--
                if self.BranchofService=="Infantry" then squadHeight = ((Squad.INFANTRY_SIZE_NORTHSOUTH.Y/2)+4) end 
                if self.BranchofService=="Cavalry" then squadHeight = ((Squad.CAVALRY_SIZE_NORTHSOUTH.Y/1.4)+12) end 
                local newPos = Mathematics.VectorFromAddition(Mathematics.ForwardVector(self.Position,(squadHeight*i)),self.Position)
                table.insert(drawPositions,newPos)            
            elseif (self.BranchofService=="Artillery") then
                squadHeight = ((Squad.ARTILLERY_SIZE_NORTHSOUTH.X*2)+15)
                local newPos = Mathematics.VectorFromAddition(Mathematics.ForwardVector(self.Position,(squadHeight*i)),self.Position)
                table.insert(drawPositions,newPos)
            end
        elseif (self.Formation=="BattleLine")or(self.Formation=="FiringLine") then
            if self.BranchofService=="Infantry" then squadWidth = ((Squad.INFANTRY_SIZE_NORTHSOUTH.X*2)) end 
            if self.BranchofService=="Cavalry" then squadWidth = ((Squad.CAVALRY_SIZE_NORTHSOUTH.X*2)+5) end 
            if self.BranchofService=="Artillery" then squadWidth = ((Squad.ARTILLERY_SIZE_NORTHSOUTH.X*2)+5) end 

            local newPos = Mathematics.VectorFromAddition(Mathematics.RightVector(self.Position,(squadWidth*i)),self.Position)
            table.insert(drawPositions,newPos)  
        elseif self.Formation=="SkirmishOrder" then
            math.randomseed(Squad.SKIRMISH_ORDER_SEED+i)
            --Front Rank--
            local newPos = Mathematics.VectorFromAddition(Mathematics.RightVector(self.Position,(i*100)+math.random(-25,25)),self.Position)
            newPos = Mathematics.VectorFromAddition(Mathematics.ForwardVector(newPos,math.random(-35,35)),newPos)
            table.insert(drawPositions,newPos)

            --Rear Rank--
            local theta=self.Position.Theta
            if i~=0 then
                if i<0 then theta = Mathematics.AngleFromVector(Mathematics.VectorFromSubtraction(newPos,self.Position))
                else theta = Mathematics.AngleFromVector(Mathematics.VectorFromSubtraction(self.Position,newPos))
                end
                newPos.Theta=theta
                newPos = Mathematics.VectorFromAddition(Mathematics.RightVector(newPos,(-125)+math.random(-25,25)),newPos)
            else
                newPos.Theta=theta
                newPos = Mathematics.VectorFromAddition(Mathematics.ForwardVector(newPos,(-125)+math.random(-25,25)),newPos)
            end
            
            table.insert(drawPositions,newPos)
        end
    end

    --draw the squads to screen--
    for i=1,#drawPositions,1 do love.graphics.draw(self.CurrentImage,drawPositions[i].X,drawPositions[i].Y) end
end



--// FINISH UP BY RETURNING THE NEW OBJECT BACK TO MAIN //--
return Battalion

