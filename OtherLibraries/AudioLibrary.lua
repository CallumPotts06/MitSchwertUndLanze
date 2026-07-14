
Audio = {}


----//// SOUND EFFECTS - MOST SOUNDS THAT ARE STATIC IN MEMORY ////----

---/// MUSKET FIRE SOUND EFFECTS ///---
Audio.MusketFire = {}
for i = 1, 9, 1 do
    local str = "Assets/Sounds/Fire/MusketFire"..tostring(i)..".mp3"
    local newSound = love.audio.newSource(str, "static")
    Audio.MusketFire["FX"..tostring(i)] = newSound
    Audio.MusketFire.Count = 9
end



----//// LIBRARY FUNCTIONS ////----
function Audio.PlayEffect( effect )
    love.audio.play( effect[ "FX"..tostring( math.random( 1, effect.Count ) ) ] )
end

return Audio




