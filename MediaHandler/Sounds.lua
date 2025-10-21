
---/// LIBRARY ///---
Sounds = {}

--// SOUNDS LIBRARY //--
--/ USER INTERFACE /--
Sounds.Click = {"Assets/Sounds/UI/uiclick.mp3","static"}


---/// METHODS ///---
function Sounds.CreateSound(soundObject)
    newSound = love.audio.newSource(soundObject[1],soundObject[2])--creates a new sound--
    return newSound--returns the sound data to the called location--
end



---/// CREATE SOUNDS FROM THEIR SOURCES ///---
Sounds.Click = Sounds.CreateSound(Sounds.Click)

return Sounds