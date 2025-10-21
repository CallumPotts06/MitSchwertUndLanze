
---/// LIBRARY ///---
Images = {}

--// IMAGES LIBRARY //--
--/ OTHER /--
Images.Test = "Assets/Images/Other/prussian.jpg"

--/ MENUS /--
Images.Title1 = "Assets/Images/TitleScreen/Title1.png"
Images.Title1Blurred = "Assets/Images/TitleScreen/Title1Blurred.png"

--/ BATTLES /--
Images.BattleImages = {}
Images.BattleImages.Spicheren = "Assets/Images/BattleImages/BattleOfSpicheren.png"
Images.BattleImages.MarsLaTour = "Assets/Images/BattleImages/BattleOfMarsLaTour.png"
Images.BattleImages.Gravelotte = "Assets/Images/BattleImages/BattleOfGravelotte.png"
Images.BattleImages.Metz = "Assets/Images/BattleImages/BattleOfMetz.png"
Images.BattleImages.Sedan = "Assets/Images/BattleImages/BattleOfSedan.png"

--/ FACTION FLAGS /--
Images.FactionFlags = {}
Images.FactionFlags.Germany = "Assets/Images/FactionFlags/Germany.png"
Images.FactionFlags.France = "Assets/Images/FactionFlags/France.png"

---/// METHODS ///---
function Images.CreateImage(filepath)
    newImage = love.graphics.newImage(filepath)--creates a new image--
    return newImage--returns the image data to the called location--
end


return Images