--// IMPORT LIBRARIES //--
Colours = require("../Interface/Colours")
Font = require("../Interface/Font")

--// SETUP CLASS //--
TextBox = {}

--// CONSTRUCTOR //--
function TextBox.New(name, text, position, size, borderSize, padding, font, textScale, textColour, backColour, borderColour, hoverEnabled, clickFx)
    local newTextBox = {}

    newTextBox.Name = name

    -- Positional data --
    newTextBox.Position = position
    newTextBox.Size = size
    newTextBox.BorderSize = borderSize
    newTextBox.Padding = padding

    -- Appearance data --
    newTextBox.Font = Font.CreateFont(text, font, size, padding)
    assert(newTextBox.Font, "Font creation failed") -- Ensure font is valid

    newTextBox.TextColour = textColour
    newTextBox.BackColour = backColour
    newTextBox.BorderColour = borderColour
    newTextBox.HoverEnabled = hoverEnabled
    newTextBox.ClickSoundEnabled = clickFx
    newTextBox.HoverCurrent = false
    newTextBox.TextScale = textScale

    -- Content --
    newTextBox.Text = text
    newTextBox.TextData = love.graphics.newText(newTextBox.Font, text)
    newTextBox.Canvas = false

    setmetatable(newTextBox, { __index = TextBox })
    return newTextBox
end

--// OTHER METHODS //--
function TextBox:CreateCanvas()
    --method that creates a canvas of the text box to be reused--
    local width = self.Size.X + self.BorderSize * 2 + self.Padding * 2
    local height = self.Size.Y + self.BorderSize * 2 + self.Padding * 2
    local newCanvas = love.graphics.newCanvas(width, height)

    love.graphics.setCanvas(newCanvas)
    love.graphics.clear()

    -- Layer 1: Background --
    Colours.SetColour(self.BackColour)
    love.graphics.rectangle("fill", self.BorderSize, self.BorderSize, self.Size.X, self.Size.Y)

    -- Layer 2: Border --
    love.graphics.setLineWidth(self.BorderSize)
    Colours.SetColour(self.BorderColour)
    love.graphics.rectangle("line", self.BorderSize / 2, self.BorderSize / 2, self.Size.X + self.BorderSize, self.Size.Y + self.BorderSize)
    love.graphics.setLineWidth(1)

    -- Layer 3: Text --
    love.graphics.push()
        love.graphics.scale(self.TextScale, self.TextScale)
        Colours.SetColour(self.TextColour)
        love.graphics.draw(self.TextData, self.BorderSize + self.Padding, self.BorderSize + self.Padding)
    love.graphics.pop()

    love.graphics.setCanvas()

    self.Canvas = newCanvas
end


function TextBox:Draw()
    --method draws the text box onto the screen--
    if not self.Canvas then self:CreateCanvas() end--if the canvas dosen't exsist or has changed, redraw it--

    if self.HoverCurrent then Colours.SetColour(Colours.CreateColour(Colours.LightGray))--change colour based on wether its--
    else Colours.SetColour(Colours.CreateColour(Colours.White)) end--got the mouse hovering over it or not--

    love.graphics.draw(self.Canvas, self.Position.X, self.Position.Y)--draw the text to screen--
end


function TextBox:CheckForMouse(mousePos,mouseClick)
    --checks the bounds of the text object to the position of the mouse--
    if (mousePos.X >= self.Position.X) and (mousePos.X <= self.Position.X+self.Size.X) then
        if (mousePos.Y >= self.Position.Y) and (mousePos.Y <= self.Position.Y+self.Size.Y) then

            if self.HoverEnabled then self.HoverCurrent = true end--checks that hover is enbaled for shading--

            if mouseClick and self.ClickSoundEnabled then--plays a sound if clicked--
                love.audio.play(Sounds.Click)--plays 
                return "clicked"
            end
            
            return true
        end
    end
    self.HoverCurrent = false
    return false
end

return TextBox
