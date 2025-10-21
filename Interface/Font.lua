
--// LIBRARY //--
Font = {}

--FIND ALL THE FONTS NEEDED--
Font.Georgia = "Assets/Other/Georgiab.ttf"
Font.Western = "Assets/Other/gomarice_nandaka_western.ttf"
Font.TypeWriter = "Assets/Other/Typewriter.ttf"
Font.TypeWrong = "Assets/Other/typwrng.ttf"
Font.Gothic1 = "Assets/Other/JBLACK.ttf"
Font.Gothic2 = "Assets/Other/BLACC___.ttf"
Font.Deutsch1 = "Assets/Other/Deutsch.ttf"
Font.Deutsch2 = "Assets/Other/deutsch_gotisch_regular.otf"
Font.Deutsch3 = "Assets/Other/deutsch_gotisch_heavy.otf"
Font.Deutsch4 = "Assets/Other/deutsch_gotisch_shadow.otf"

--// METHODS //--
function Font.CreateFont(text,fontStyle,areaSize,padding)
    --creates a new font for a specific text box according to size--

    local newfont = love.graphics.newFont(fontStyle, 8)--create a back up font with size before the loop--
    for size = 80, 8, -1 do--loop to find the best size--
        newfont = love.graphics.newFont(fontStyle, size)

        --breaks loop having found best size--
        if (newfont:getWidth(text)<=areaSize.X-(padding*2))and(newfont:getHeight(text)<=areaSize.Y-(padding*2)) then break end
    end

    return newfont--returns a love2d font object--
end

return Font