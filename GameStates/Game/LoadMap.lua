
---/// LIBRARY ///---
--library that loads the map when required, and also loads all the tiles--

LoadMap = {}

LoadMap.RegularTiles = {}
LoadMap.SnowyTiles = {}


local TileTypes = {
    {"Grass","None"},
    {"Forest","Fill"},
    {"Urban","None"},
    --{"Creek","Direction"}
}

local FillTypes = {
    "Filled",--full tile--

    "EdgeN",--the edges of a (for example) forest--
    "EdgeE",
    "EdgeS",
    "EdgeW",

    "InsideNW",--the inside of a corner--
    "InsideSW",
    "InsideSE",
    "InsideNE",

    "OutsideNW",--the outside of a corner--
    "OutsideSW",
    "OutsideSE",
    "OutsideSW",
    "OutsideNE",
}

local DirectionTypes = {
    "NS",--straight line--
    "EW",

    "NE",--corner--
    "NW",
    "SE",
    "SW",

    "NES",--junctions for roads--
    "NWS",
    "ENW",
    "ESW",
    "NESW"
}

local NoneType = {"Fill"}




--// METHODS //--

--creates a tile canvas to return to the loadtiles function--
function LoadMap.CreateTile(tile,type)
    
end


--function that creates all the tiles required for the map to be drawn--
function LoadMap.LoadTiles(season)
    local newTileTable = {}
    

    for tileIndex = 1,#TileTypes,1 do
        --setup local variables--
        local newTiles = {}
        local types = {}

        --match the tile type to the predefined tables--
        if TileTypes[tileIndex][2] == "None" then types = NoneType end
        if TileTypes[tileIndex][2] == "FillTypes" then types = FillTypes end
        if TileTypes[tileIndex][2] == "DirectionTypes" then types = DirectionTypes end

        --loop through the types for the current tile--
        for typeIndex = 1,#types,1 do

            local newCanvas = LoadMap.CreateTile(TileTypes[tileIndex][1],types[typeIndex])

        end

    end

end




return LoadMap