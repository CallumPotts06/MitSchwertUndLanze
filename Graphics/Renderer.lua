
Renderer = {}

function Renderer.DrawWithLightingAndShadow( img, pos, zoom )
    Effects.DrawShadow(img,pos,"Image")
    Colours.SetColour(Effects.LightingColour(Colours.CreateColour({1,1,1,1})),false)
    love.graphics.draw(img,pos.X,pos.Y,0,zoom,zoom)
end

function Renderer.DrawShadow( img, pos, zoom )
    Effects.DrawShadow(img,pos,"Image")
end

function Renderer.DrawWithLighting( img, pos, zoom )
    Colours.SetColour(Effects.LightingColour(Colours.CreateColour({1,1,1,1})),false)
    love.graphics.draw(img,pos.X,pos.Y,0,zoom,zoom)
end

return Renderer