--// IMAGES MODULE //--

local Images = {}

-- Creates or returns an image
-- If passed a love.graphics Image object, returns it as-is
-- If passed a string path, loads the image
function Images.CreateImage(imageOrPath)
    if type(imageOrPath) == "string" then
        return love.graphics.newImage(imageOrPath)
    else
        return imageOrPath
    end
end

return Images
