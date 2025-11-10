
--// LIBRARY //--
--helps with the battalion class that draws the squads--



--// IMPORT OTHER LIBRARIES //--
Vector = require("../Mathematics/Vector")

Squads = {}

--// CONSTANTS //--
Squads.INFANTRY_MAXSIZE = Vector.New(70,55)
Squads.INFANTRY_SIZE_WESTEAST = Vector.New(20,55)
Squads.INFANTRY_OFFSET_WESTEAST = Vector.New(0,0)
Squads.INFANTRY_SIZE_NORTHSOUTH = Vector.New(20,55)
Squads.INFANTRY_OFFSET_NORTHSOUTH = Vector.New(-23,0)

Squads.ARTILLERY_SIZE_WESTEAST = Vector.New(250,115)
Squads.ARTILLERY_OFFSET_WESTEAST = Vector.New(1,12)
Squads.ARTILLERY_SIZE_NORTHSOUTH = Vector.New(100,164)
Squads.ARTILLERY_OFFSET_NORTHSOUTH = Vector.New(1,5)

Squads.CAVALRY_MAXSIZE = Vector.New(150,110)
Squads.CAVALRY_SIZE_WESTEAST = Vector.New(30,90)
Squads.CAVALRY_OFFSET_WESTEAST = Vector.New(0,0)
Squads.CAVALRY_SIZE_NORTHSOUTH = Vector.New(30,95)
Squads.CAVALRY_OFFSET_NORTHSOUTH = Vector.New(-30,0)

Squads.SKIRMISH_ORDER_SEED = 1870



----//// FUNCTIONS OF THE SQUAD LIBRARYH ////----
--function that crops the input image / canvas--
function Squads.CropImage(drawable,drawableType)
    if drawable then
        print(type(drawable), tostring(drawable))
        local imageData = drawable
        if drawableType=="Canvas" then imageData = drawable:newImageData() end
        local minX, minY = imageData:getWidth(), imageData:getHeight()
        local maxX, maxY = 0, 0

        for y = 0, imageData:getHeight() - 1 do
            for x = 0, imageData:getWidth() - 1 do
                local r, g, b, a = imageData:getPixel(x, y)
                if a > 0 then  -- non-transparent
                    if x < minX then minX = x end
                    if y < minY then minY = y end
                    if x > maxX then maxX = x end
                    if y > maxY then maxY = y end
                end
            end
        end
        local croppedWidth  = maxX - minX + 1
        local croppedHeight = maxY - minY + 1
        local cropped = love.image.newImageData(croppedWidth, croppedHeight)
        cropped:paste(imageData, 0, 0, minX, minY, croppedWidth, croppedHeight)
        drawable = love.graphics.newImage(cropped)
    end
    return drawable
end





function Squads.LoadImages(team,unitTypeName,unitType,dress,facing,animation,formation)
    --function load images from directory--
    local filepath1 = "Not Found"
    local filepath2 = "Not Found"

    if unitType=="Infantry" then
        filepath2 = "Assets/Images/Units/"..team.."/"..unitTypeName.."/"..dress.."/"..facing.."/1.png"
        if animation=="Idle" then filepath1="Assets/Images/Units/"..team.."/"..unitTypeName.."/"..dress.."Dress".."/"..facing.."/3.png" end
        if animation=="Aiming" then filepath1="Assets/Images/Units/"..team.."/"..unitTypeName.."/"..dress.."Dress".."/"..facing.."/2.png" end
        if animation=="March1" then filepath1="Assets/Images/Units/"..team.."/"..unitTypeName.."/"..dress.."Dress".."/"..facing.."/4.png" end
        if animation=="March2" then filepath1="Assets/Images/Units/"..team.."/"..unitTypeName.."/"..dress.."Dress".."/"..facing.."/5.png" end
        if animation=="March3" then filepath1="Assets/Images/Units/"..team.."/"..unitTypeName.."/"..dress.."Dress".."/"..facing.."/6.png" end
        if animation=="March4" then filepath1="Assets/Images/Units/"..team.."/"..unitTypeName.."/"..dress.."Dress".."/"..facing.."/7.png" end
    end

    if unitType=="Artillery" then
        filepath2 = "Assets/Images/Units/"..team.."/"..unitTypeName.."/"..facing.."/1.png"
        if animation=="Firing" then filepath1 = "Assets/Images/Units/"..team.."/"..unitTypeName.."/"..facing.."/1.png" end
        if animation=="Idle"   then filepath1 = "Assets/Images/Units/"..team.."/"..unitTypeName.."/"..facing.."/2.png" end
        if animation=="March1" then filepath1 = "Assets/Images/Units/"..team.."/"..unitTypeName.."/"..facing.."/3.png" end
        if animation=="March2" then filepath1 = "Assets/Images/Units/"..team.."/"..unitTypeName.."/"..facing.."/1.png" end
    end

    if unitType=="Cavalry" then
        filepath2 = "Assets/Images/Units/"..team.."/"..unitTypeName.."/"..facing.."/1.png"
        if animation=="Idle"    then filepath1 = "Assets/Images/Units/"..team.."/"..unitTypeName.."/"..facing.."/2.png" end
        if animation=="March1"  then filepath1 = "Assets/Images/Units/"..team.."/"..unitTypeName.."/"..facing.."/3.png" end
        if animation=="March2"  then filepath1 = "Assets/Images/Units/"..team.."/"..unitTypeName.."/"..facing.."/4.png" end
        if animation=="Charge1" then filepath1 = "Assets/Images/Units/"..team.."/"..unitTypeName.."/"..facing.."/5.png" end
        if animation=="Charge2" then filepath1 = "Assets/Images/Units/"..team.."/"..unitTypeName.."/"..facing.."/7.png" end
        if animation=="Charge3" then filepath1 = "Assets/Images/Units/"..team.."/"..unitTypeName.."/"..facing.."/6.png" end
    end

    if unitType=="Dragoon" then
        filepath2 = "Assets/Images/Units/"..team.."/"..unitTypeName.."/Dismounted/"..facing.."/1.png"
        if formation=="Dismounted" then
            if animation=="Idle" then filepath1="Assets/Images/Units/"..team.."/"..unitTypeName.."/Dismounted/"..facing.."/3.png" end
            if animation=="Aiming" then filepath1="Assets/Images/Units/"..team.."/"..unitTypeName.."/Dismounted/"..facing.."/2.png" end
            if animation=="March1" then filepath1="Assets/Images/Units/"..team.."/"..unitTypeName.."/Dismounted/"..facing.."/4.png" end
            if animation=="March2" then filepath1="Assets/Images/Units/"..team.."/"..unitTypeName.."/Dismounted/"..facing.."/5.png" end
            if animation=="March3" then filepath1="Assets/Images/Units/"..team.."/"..unitTypeName.."/Dismounted/"..facing.."/6.png" end
            if animation=="March4" then filepath1="Assets/Images/Units/"..team.."/"..unitTypeName.."/Dismounted/"..facing.."/7.png" end
            if animation=="Guard" then filepath1="Assets/Images/Units/"..team.."/"..unitTypeName.."/Dismounted/"..facing.."/8.png" end
        else
            if animation=="MountedIdle"   then filepath1="Assets/Images/Units/"..team.."/"..unitTypeName.."/Mounted/"..facing.."/1.png" end
            if animation=="MountedMarch1" then filepath1="Assets/Images/Units/"..team.."/"..unitTypeName.."/Mounted/"..facing.."/3.png" end
            if animation=="MountedMarch2" then filepath1="Assets/Images/Units/"..team.."/"..unitTypeName.."/Mounted/"..facing.."/4.png" end
        end
    end

    -- safe image creation (avoid globals / hard errors)
    local function safeNewImage(path)
        if path == "Not Found" then return nil end
        local ok, img = pcall(love.graphics.newImage, path)
        if not ok then
            -- optional debug: print("Failed to load image:", path)
            return nil
        end
        return img
    end

    local image1 = safeNewImage(filepath1)
    local image2 = nil
    if not (image1==nil) then image2 = love.image.newImageData(filepath1) end 

    -- final fallback to a error image if nothing loaded
    if not image1 then
        image1 = love.graphics.newImage("Assets/Images/Icons/ImageNotFound.png")
    end
    if not image2 then
        image2 = love.image.newImageData("Assets/Images/Icons/ImageNotFound.png")
    end


    return {image1,image2}
end



function Squads.CreateSquad(team,unitTypeName,unitType,dress,facing,animation,formation,time)
    --creates a squad canvas--

    --first get the necessary images--
    local images = Squads.LoadImages(team,unitTypeName,unitType,dress,facing,animation,formation)
    local img = Squads.CropImage(images[2],"Image")

    --positional data--
    local soldierCount = Vector.New(1,1)
    local soldierSize = Vector.New(img:getWidth(),img:getHeight())
    local override = false

    --setup the amount of soldiers for each squad (depending on service and formation)--
    if unitType=="Infantry" then 
        overide = true
        if formation=="BattleLine" then soldierCount = Vector.New(2,2)
        elseif formation=="MarchingColumn" then soldierCount = Vector.New(4,2)
        elseif formation=="SkirmishOrder" then soldierCount = Vector.New(1,1) end 

    elseif unitType=="Artillery" then
        soldierCount = Vector.New(1,1)

    elseif unitType=="Cavalry" then
        if formation=="BattleLine" then soldierCount = Vector.New(2,2)
        else soldierCount = Vector.New(4,2) end

    elseif unitType=="Dragoon" then
        if formation=="Mounted" then 
            soldierCount = Vector.New(4,2) 
        else
            if animation=="Guard" then soldierCount = Vector.New(1,1) 
            else overide = true soldierCount = Vector.New(2,2) end
        end
    end 

    local size = Vector.New(soldierSize.X*soldierCount.X,soldierSize.Y*soldierCount.Y)
    --for infantry and dismounted dragoons--
    if overide then size = Vector.New(70*soldierCount.X,soldierSize.Y*soldierCount.Y) end--70 is the width of the troops E/W--


    --canvas creation--
    local drawable = love.graphics.newCanvas(size.X, size.Y)
    love.graphics.setCanvas(drawable)
        for x=1,soldierCount.X,1 do for y=1,soldierCount.Y,1 do
            if (not overide)or(facing=="West") then
                love.graphics.draw(img, (soldierSize.X*(x-1)), ((soldierSize.Y/2)*(y-1)))
            else
                love.graphics.draw(img, (soldierSize.X*(x-1))+24, ((soldierSize.Y/2)*(y-1)))--offset for infantry--
            end
        end end
    love.graphics.setCanvas()

    --crop the final squad canvas (unless its infantry or dismounted dragoons)--
    if not override then drawable = Squads.CropImage(drawable,"Canvas") end

    --return the canvases
    return drawable
end






Squads.ImageLibrary = {}
Squads.ImageLibrary.SoldiersLoadedCounter = 0

Squads.ImageLibrary.GermanUnits = {}

Squads.ImageLibrary.GermanUnits.Flags = {}
Squads.ImageLibrary.GermanUnits.Infantry = {}
Squads.ImageLibrary.GermanUnits.Cavalry = {}
Squads.ImageLibrary.GermanUnits.Artillery = {}






function Squads.LoadAllSquads()
    local germanUnits = {
        {"PreussischerJaegers","DeutscherJaegers","Infantry","Seasonal"},
        {"PreussischerGardeZuFuss","DeutscherGardeZuFuss","Infantry","Seasonal"},
        {"PreussischerLineninfanterie","DeutscherLineninfanterie","Infantry","Seasonal"},
        {"BayerischerLineninfanterie","BayerischerLineninfanterie","Infantry","Seasonal"},
        {"BadenLineninfanterie","DeutscherLineninfanterie","Infantry","Seasonal"},
        {"HessischLineninfanterie","DeutscherLineninfanterie","Infantry","Seasonal"},
        {"SaechsischLineninfanterie","DeutscherLineninfanterie","Infantry","Seasonal"},
        {"WuerttemburgLineninfanterie","DeutscherLineninfanterie","Infantry","Seasonal"},
        {"PreussischerLandwehr","DeutscherLandwehr","Infantry","Seasonal"},

        {"PreussischerDragoner","PreussischerDragoner","Dragoon","None"},

        {"PreussischerHusaren","PreussischerHusaren","Cavalry","None"},
        {"PreussischerKuerassiere","PreussischerKuerassiere","Cavalry","None"},
        {"PreussischerUhlanen","PreussischerUhlanen","Cavalry","None"},

        {"PreussischerArtillerie","DeutscherArtillerie","Artillery","None"},
    }


    local nations = {germanUnits}

    local InfantryFormations = {"BattleLine","MarchingColumn","SkirmishOrder"}
    local InfantryAnimations = {"Idle","Aiming","March1","March2","March3","March4"}

    local ArtilleryFormations = {"FiringLine","MarchingColumn"}
    local ArtilleryAnimations = {"Idle","March1","March2"}

    local CavalryFormations = {"BattleLine","MarchingColumn"}
    local CavalryAnimations = {"Idle","March1","March2","Charge1","Charge2","Charge3"}

    local DragoonFormations = {"Dismounted","Mounted"}
    local DragoonMountedAnimations = {"MountedIdle","MountedMarch1","MountedMarch2"}
    local DragoonDismountedAnimations = {"Idle","Aiming","March1","March2","March3","March4","Guard"}

    local facings = {"North","East","South","West"}
    local timesOfDay = {1200} --for i=0,24,2 do table.insert(timesOfDay,i*100)end
    local seasons = {"Summer","Winter"}

    local forms = {}
    local anims = {}
    local team="None"
    local service="None"
    local season="None"



    for i1 = 1,#nations,1 do
        if nations[i1]==germanUnits then team="Germany" end


        for i2 = 1,#nations[i1],1 do
            --get the relevant formations and animations to the type of unit--
            if nations[i1][i2][3]=="Infantry" then forms = InfantryFormations anims = InfantryAnimations service="Infantry" season="Enabled"
            elseif nations[i1][i2][3]=="Artillery" then forms = ArtilleryFormations anims = ArtilleryAnimations service="Artillery" season="None"
            elseif nations[i1][i2][3]=="Dragoon" then forms = DragoonFormations anims = DragoonDismountedAnimations service="Cavalry" season="None"
            else forms = CavalryFormations anims = CavalryAnimations service="Cavalry" season="None" end

            local newFlag = love.graphics.newImage("Assets/Images/Units/"..team.."/Flags/"..nations[i1][i2][1]..".png", {mipmaps = false, linear = false})
            if team=="Germany" then table.insert(Squads.ImageLibrary.GermanUnits.Flags,{newFlag,nations[i1][i2][1],Vector.New(1,1)}) end

            for i3 = 1,#forms,1 do
                if (nations[i1][i2][3]=="Dragoon") then 
                    if (forms[i3]=="Dismounted") then anims=DragoonDismountedAnimations
                    else  anims=DragoonMountedAnimations end
                end

                for i4 = 1,#anims,1 do
                    for i5 = 1,#facings,1 do
                        for i6 = 1,#timesOfDay,1 do
                            if season=="Enabled" then currentSeasons=seasons else currentSeasons={"None"} end
                            for i7=1,#currentSeasons,1 do
                                Squads.ImageLibrary.SoldiersLoadedCounter=Squads.ImageLibrary.SoldiersLoadedCounter+1

                                local unit = nations[i1][i2]
                                local newSquad = Squads.CreateSquad(team,unit[2],unit[3],currentSeasons[i7],facings[i5],anims[i4],forms[i3],timesOfDay[i6])
                                local newSquadData = {}
                                newSquadData.UnitType = unit[2]
                                newSquadData.Animation = anims[i4]
                                newSquadData.Formation = forms[i3]
                                newSquadData.Facing = facings[i5]
                                newSquadData.Time = timesOfDay[i6]
                                newSquadData.Dress = currentSeasons[i7]
                                newSquadData.Image = newSquad

                                local nationImgSet = "None"
                                if team=="Germany" then
                                    nationImgSet = Squads.ImageLibrary.GermanUnits
                                end

                                local ImgSet = "None"
                                if service=="Infantry" then
                                    ImgSet = nationImgSet.Infantry
                                elseif service=="Artillery" then
                                    ImgSet = nationImgSet.Artillery
                                else
                                    ImgSet = nationImgSet.Cavalry
                                end
                                
                                table.insert(ImgSet,newSquadData)
                            end
                        end
                    end 
                end
            end
        end
    end
end


return Squads