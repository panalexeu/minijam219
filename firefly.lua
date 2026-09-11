firefly = class:new()

function firefly:init(x, y, size)
    self.x = x 
    self.y = y 
    self.size = size 
    self.color = {0.8, 1, 0.3, 1}
    local img_data = love.image.newImageData(size, size)
    -- eucledian distance with alpha gradually decreasing from the centre of an image
    img_data:mapPixel(function(x,y)
        local d = math.sqrt((x-size/2)^2 + (y-size/2)^2) / (size/2)
        return 1,1,1, math.max(0, 1-d)^2
    end)
    self.img = love.graphics.newImage(img_data)
end 

function firefly:draw()
    love.graphics.setColor(self.color)
    love.graphics.draw(self.img, self.x, self.y, 0, 1, 1, 0, 0)
    --                 image     x       y      rot sx sy ox oy
end  