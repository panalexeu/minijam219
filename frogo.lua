frogo = class:new() 

function frogo:init(x, y, w, h)
    self.x = x
    self.y = y
    self.dir_x = -1
    self.dir_y = 0 
    self.ox = w/2
    self.oy = h/2 

    self.img = sprites['frogo']
    self.quad = quads['frogo_idle'][1]
end 

function frogo:update(dt)
end 

function frogo:draw() 
    love.graphics.draw(self.img, self.quad, self.x, self.y, 0, self.dir_x, 1, self.ox, self.oy)
end 
