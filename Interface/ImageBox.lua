--// IMPORT LIBRARIES //--
Colours = require("../Interface/Colours")
Images = require("../MediaHandler/Images")
Sounds = require("../MediaHandler/Sounds")

--// SETUP CLASS //--
ImageBox = {}

--// CONSTRUCTOR //--
function ImageBox.New(name, image, position, size, borderSize, padding, backColour, borderColour, hoverEnabled, clickFx)
    local newImageBox = {}

    newImageBox.Name = name

    -- Positional data --
    newImageBox.Position = position
    newImageBox.Size = size
    newImageBox.BorderSize = borderSize
    newImageBox.Padding = padding
    newImageBox.DrawWidth = size.X
    newImageBox.DrawHeight = size.Y

    -- Appearance data --
    newImageBox.BackColour = backColour
    newImageBox.BorderColour = borderColour
    newImageBox.HoverEnabled = hoverEnabled
    newImageBox.ClickSoundEnabled = clickFx
    newImageBox.HoverCurrent = false

    -- Content --
    newImageBox.Image = Images.CreateImage(image)
    newImageBox.Canvas = false

    setmetatable(newImageBox, { __index = ImageBox })
    return newImageBox
end

--// OTHER METHODS //--
function ImageBox:CreateCanvas()
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

    -- Layer 3: Image --
    Colours.SetColour(Colours.CreateColour(Colours.White))
    local scaleX = self.DrawWidth / self.Image:getWidth()
    local scaleY = self.DrawHeight / self.Image:getHeight()
    love.graphics.draw(self.Image, self.BorderSize + self.Padding, self.BorderSize + self.Padding,0,scaleX,scaleY)

    love.graphics.setCanvas()

    self.Canvas = newCanvas
end


function ImageBox:Draw()
    --method draws the image box onto the screen--
    if not self.Canvas then self:CreateCanvas() end--if the canvas dosen't exsist or has changed, redraw it--

    if self.HoverCurrent then Colours.SetColour(Colours.CreateColour(Colours.LightGray))--change colour based on wether its--
    else Colours.SetColour(Colours.CreateColour(Colours.White)) end--got the mouse hovering over it or not--

    love.graphics.draw(self.Canvas, self.Position.X, self.Position.Y)--draw the image to screen--
end


function ImageBox:CheckForMouse(mousePos,mouseClick)
    --checks the bounds of the image object to the position of the mouse--
    if (mousePos.X >= self.Position.X) and (mousePos.X <= self.Position.X+self.Size.X) then
        if (mousePos.Y >= self.Position.Y) and (mousePos.Y <= self.Position.Y+self.Size.Y) then

            if self.HoverEnabled then self.HoverCurrent = true end--checks that hover is enbaled for shading--

            if mouseClick and self.ClickSoundEnabled then--plays a sound if clicked--
                love.audio.play(Sounds.Click)--plays sound
            end
            
            return true
        end
    end
    self.HoverCurrent = false
end

return ImageBox
