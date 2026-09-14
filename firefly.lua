firefly = class:new()

function firefly:init(x, y, size)
    self.x, self.y = x, y 
    self.ox, self.oy = size / 2,  size / 2
    self.size = size 

    self.dirs = {-1, 1}
    self.dir_x = self.dirs[love.math.random(#self.dirs)]    
    self.dir_y = math.sin(self.x)

    self.velocities = {10, 20, 30}
    self.v = self.velocities[love.math.random(#self.velocities)]

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
    love.graphics.draw(self.img, self.x, self.y, 0, 1, 1, self.ox, self.oy)
    --                 image     x       y      rot sx sy ox oy
end  

function firefly:update(dt)
    self.x = self.x + self.dir_x * self.v * dt
    self.y = self.y + self.dir_y * self.v * dt
    self.dir_y = math.sin(self.x)
end 