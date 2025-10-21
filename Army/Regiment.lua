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

Regiment = {}

function Regiment.New(name,brigade,team,unitType,startPos)
    --create new empty object--
    local newRegiment = {}

    --add referential data--
    newRegiment.Name = name
    newRegiment.Brigade = brigade
    newRegiment.Team = team
    newRegiment.UnitType = unitType
    newRegiment.Battalions = nil

    --add mathematical data--
    newRegiment.Position = startPos

    
    --finish up the object--
    setmetatable(newRegiment,{__index=Battalion})--map the new table onto the Battalion class--
    return newRegiment--return the new object--
end