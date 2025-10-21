
--// FIND ALL MENU FILES //--
TitleScreen = require("GameStates/Menu/TitleScreen")
MainMenu = require("GameStates/Menu/MainMenu")
SettingsMenu = require("GameStates/Menu/SettingsMenu")
QuickBattleMenu = require("GameStates/Menu/QuickBattle")


MenuController = {}

--// MENU CONTROLLER LOCAL VARIABLES //--
local currentMenu = "TitleScreen"

--// MENU CONTROLLER ATTRIBUTES //--
MenuController.currentScreen = false

--// METHODS //--

function returnToMain()
    local newScreen = MainMenu.Open()--create a new screen--
    MenuController.currentScreen = newScreen--set the menu's screen to the created screen object--
    currentMenu = "MainMenu"--change the local value of current menu to keep on track of the menu open--
end

function MenuController.InitialiseMenu(startScreen)
    --used on game open or re-entering menu after battles--

    if startScreen == "TitleScreen" then
        local newScreen = TitleScreen.Open()--create a new screen using the title screen's method--
        MenuController.currentScreen = newScreen--set the menu's screen to the created title screen object--
    end

end

function MenuController.CheckForClicks(mousePos,mouseClick)
    --if there is not any screen, return false--
    if not MenuController.currentScreen then return false end

    --creates an table of all clicked ui elements--
    clickedObjects = MenuController.currentScreen:CheckForMouse(mousePos,mouseClick)

    --FOR TITLE SCREEN--
    if currentMenu == "TitleScreen" then
        for i=1,#clickedObjects,1 do 
            --if it confirms that the start button was clicked, it opens the main menu--
            if clickedObjects[i].Name=="StartButton" then 
                local newScreen = MainMenu.Open()--create a new screen--
                MenuController.currentScreen = newScreen--set the menu's screen to the created screen object--
                currentMenu = "MainMenu"--change the local value of current menu to keep on track of the menu open--
                return true
            end 
        end
    end



    --FOR MAIN MENU--
    if currentMenu == "MainMenu" then
        for i=1,#clickedObjects,1 do 
            --exit the game--
            if clickedObjects[i].Name=="ExitBtn" then 
                love.event.quit()--closes the game--
            end

            --opens the campaign menu--
            if clickedObjects[i].Name=="CampaignBtn" then 
                --code--
            end

            --opens the quick battle menu--
            if clickedObjects[i].Name=="QuickBattleBtn" then 
                local newScreen = QuickBattleMenu.Open()--create a new screen--
                MenuController.currentScreen = newScreen--set the menu's screen to the created screen object--
                currentMenu = "QuickBattleMenu"--change the local value of current menu to keep on track of the menu open--
                return true
            end

            --opens the settings menu--
            if clickedObjects[i].Name=="SettingsBtn" then 
                local newScreen = SettingsMenu.Open()--create a new screen--
                MenuController.currentScreen = newScreen--set the menu's screen to the created screen object--
                currentMenu = "SettingsMenu"--change the local value of current menu to keep on track of the menu open--
                return true
            end

        end
    end



    --FOR SETTINGS MENU--
    if currentMenu == "SettingsMenu" then
        for i=1,#clickedObjects,1 do 

            if clickedObjects[i].Name=="Return" then
                returnToMain()
                return true
            end
 
        end
    end


    --FOR QUICK BATTLE--
    if currentMenu == "QuickBattleMenu" then
        for i=1,#clickedObjects,1 do 

            if clickedObjects[i].Name=="Return" then
                returnToMain()
                return true
            end

            if clickedObjects[i].Name=="nextBtl" then
                QuickBattleMenu.ChangeBattle(MenuController.currentScreen,1)
                break
            end

            if clickedObjects[i].Name=="prevBtl" then
                QuickBattleMenu.ChangeBattle(MenuController.currentScreen,-1)
                break
            end
 
        end
    end
end


function MenuController.DrawMenu()
    --checks that there actually is a screen ready--
    if not (not MenuController.currentScreen) then
        --draws the screen--
        MenuController.currentScreen:DrawScreen()
    end
end

return MenuController