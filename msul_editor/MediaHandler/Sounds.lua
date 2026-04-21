--// SOUNDS MODULE //--

local Sounds = {}

-- Placeholder sound effects
Sounds.Click = nil  -- No sound loaded yet

-- Function to load a sound
function Sounds.Load(name, path)
    Sounds[name] = love.audio.newSource(path, "static")
end

return Sounds
