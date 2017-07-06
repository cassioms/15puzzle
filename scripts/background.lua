local background = {}

function background.loadBackground(bgGroup)
    local rectangleHolder = display.newRect(bgGroup, display.contentCenterX, display.contentCenterY, 768, 1024)
    display.setDefault("textureWrapX", "repeat")
    display.setDefault("textureWrapY", "repeat")

    rectangleHolder.fill = {type = "image", filename = "design/bg_tile.png"}

    local scaleFactorX = 1 ; local scaleFactorY = 1
    if (rectangleHolder.width > rectangleHolder.height) then
       scaleFactorY = rectangleHolder.width / rectangleHolder.height
    else
       scaleFactorX = rectangleHolder.height / rectangleHolder.width
    end

    rectangleHolder.fill.x = 0
    rectangleHolder.fill.y = 0
    rectangleHolder.fill.scaleX = 0.075 * scaleFactorX
    rectangleHolder.fill.scaleY = 0.075 * scaleFactorY

    display.setDefault("textureWrapX", "clampToEdge")
    display.setDefault("textureWrapY", "clampToEdge")
end

return background
