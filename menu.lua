menu = class:new()

function menu:init(x, y, w, h, items) 
    self.x, self.y = x, y 
    self.w, self.h = w, h 
    self.ox, self.oy = w / 2, h / 2 
    self.is_active = false 
end 

function menu:update(dt)
end 

function menu:draw()
    if self.is_active then
        love.graphics.setColor(1,1,1,1)
        love.graphics.rectangle('fill', self.x - self.ox, self.y - self.oy, self.w, self.h)
    end 
end 