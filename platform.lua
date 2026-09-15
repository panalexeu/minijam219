platform = class:new() 

function platform:init(x, y)
    self.img = sprites['platform']
    self.w, self.h = self.img:getWidth(), self.img:getHeight()
    self.x, self. y = x, y
    self.ox, self.oy = self.w / 2, self.h / 2 
end

function platform:update(dt)
end 

function platform:draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.img, self.x, self.y, 0, 1, 1, self.ox, self.oy)
end 