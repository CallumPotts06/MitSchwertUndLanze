
--// IMPORT //--
KeyBinds = require("Config/KeyBinds")


--// LIBRARY //--
ReadSettings = {}

ReadSettings.Settings = {}
ReadSettings.Settings.Volume = 1--Default Values--
ReadSettings.Settings.MenuMusic = true
ReadSettings.Settings.FullScreen = true
ReadSettings.Settings.ScreenWidth = 2560
ReadSettings.Settings.ScreenHeight = 1440
ReadSettings.Settings.WeatherEffects = true

function ReadValue(i,settingsFile)
    local startValue = i+1
    local endValue = #settingsFile-1
    for i2=i,#settingsFile,1 do 
        if string.sub(settingsFile,i2,i2) == "<" then startValue = i2+1 end 
        if string.sub(settingsFile,i2,i2) == ">" then endValue = i2-1 break end 
    end
    local newValue = string.sub(settingsFile,startValue,endValue)
    return newValue
end


function ReadSettings.UpdateSettings()
    --open the settings file--
    local settingsFile,size = love.filesystem.read("Config/Settings.cfg")

    local newLine = false
    --loop through the config file--
    for i=1,#settingsFile,1 do
        --New Line--
        if string.sub(settingsFile,i,i) == "\n" then
            newLine = true
        end


        if newLine then
            newLine = false

            --// SOUND //--
            if string.sub(settingsFile,i,i+6) == "Volume" then
                Settings.Volume = ReadValue(i,settingsFile)
            end

            if string.sub(settingsFile,i,i+9) == "MenuMusic" then
                Settings.MenuMusic = ReadValue(i,settingsFile)
            end


            --// VIDEO //--
            if string.sub(settingsFile,i,i+16) == "WindowFullScreen" then
                Settings.FullScreen = ReadValue(i,settingsFile)
            end

            if string.sub(settingsFile,i,i+11) == "WindowSizeX" then
                Settings.ScreenWidth = ReadValue(i,settingsFile)
            end

            if string.sub(settingsFile,i,i+11) == "WindowSizeY" then
                Settings.ScreenHeight = ReadValue(i,settingsFile)
            end

            if string.sub(settingsFile,i,i+14) == "WeatherEffects" then
                Settings.WeatherEffects = ReadValue(i,settingsFile)
            end


            --// KEY BINDS //--
            if string.sub(settingsFile,i,i+8) == "MoveUnit" then
                KeyBinds.Move = ReadValue(i,settingsFile)
            end

            if string.sub(settingsFile,i,i+9) == "WheelUnit" then
                KeyBinds.Wheel = ReadValue(i,settingsFile)
            end

            if string.sub(settingsFile,i,i+10) == "ChargeUnit" then
                KeyBinds.Charge = ReadValue(i,settingsFile)
            end

        end
    end
end


return ReadSettings
