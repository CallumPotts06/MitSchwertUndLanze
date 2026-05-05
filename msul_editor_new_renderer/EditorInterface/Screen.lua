
---/// CLASS - SCREEN ///---
Screen = {}

--// CONSTRUCTOR //--
function Screen.New(zindex)
    local newScreen = {}

    newScreen.UiObjects = {}
    newScreen.Zindex = zindex
    newScreen.Visible = true

    setmetatable(newScreen, {__index = Screen})
    return newScreen
end

--// METHODS //--
function Screen:CheckForMouse(mousePos,mouseClick)
    --returns the ui object(s) that was clicked--

    local interactedObjects = {}

    if self.Visible then--check screen is visible first--
        for i=1,#self.UiObjects,1 do--loop through all of the screens objects--
            local objectI = self.UiObjects[i]:CheckForMouse(mousePos,mouseClick)--check the object for click--
            if objectI=="clicked" then table.insert(interactedObjects,self.UiObjects[i]) end--add object if true--
        end
    end

    return interactedObjects
end

function Screen:DrawScreen()
    --draw the whole screen--

    if self.Visible then--check that its visible--
        for i=1,#self.UiObjects,1 do
            self.UiObjects[i]:Draw()
        end
    end

end

return Screen